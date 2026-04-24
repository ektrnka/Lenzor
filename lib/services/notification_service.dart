import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import '../models/lens_data.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n_extensions.dart';
import '../utils/lens_tips.dart';
import 'app_locale_controller.dart';
import 'lens_data_service.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_gradient_button.dart';

/// Модель запланированного уведомления
class ScheduledNotification {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledDate;
  final String payload;
  final String lensId;

  ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDate,
    required this.payload,
    required this.lensId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'scheduledDate': scheduledDate.toIso8601String(),
      'payload': payload,
      'lensId': lensId,
    };
  }

  factory ScheduledNotification.fromMap(Map<String, dynamic> map) {
    return ScheduledNotification(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      scheduledDate: DateTime.parse(map['scheduledDate']),
      payload: map['payload'],
      lensId: map['lensId'],
    );
  }
}

/// Сервис уведомлений (Singleton)
/// 
/// 🟢 АРХИТЕКТУРА [file:12] 3.1:
/// - Singleton паттерн для глобального доступа
/// - Управление запланированными уведомлениями через flutter_local_notifications
/// - Хранение состояния в SharedPreferences
/// - Обработка foreground/background нажатий
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late SharedPreferences _prefs;

  /// Список запланированных уведомлений (в памяти + SharedPreferences)
  List<ScheduledNotification> _scheduledNotifications = [];

  /// Стрим для передачи событий нажатий на уведомления в UI
  final StreamController<Map<String, dynamic>> _notificationClickStream =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onNotificationClick =>
      _notificationClickStream.stream;

  /// Callback для навигации (устанавливается из main.dart)
  static Function(String, Map<String, dynamic>)? _navigationCallback;
  static Locale Function()? _localeResolver;

  static void setNavigationCallback(
      Function(String, Map<String, dynamic>) callback) {
    _navigationCallback = callback;
  }

  static void setLocaleResolver(Locale Function() resolver) {
    _localeResolver = resolver;
  }

  AppLocalizations get _l10n {
    final locale = _localeResolver?.call() ??
        AppLocaleController.resolveSystemLocale(
          WidgetsBinding.instance.platformDispatcher.locale,
        );
    return lookupAppLocalizations(locale);
  }

  /// 🟢 ИНИЦИАЛИЗАЦИЯ [file:12] 3.2
  /// 
  /// ПОСЛЕДОВАТЕЛЬНОСТЬ:
  /// 1. Создать FlutterLocalNotificationsPlugin
  /// 2. Получить SharedPreferences
  /// 3. Инициализировать hourовые пояса (tz_data.initializeTimeZones)
  /// 4. Загрузить сохранённые уведомления из SharedPreferences
  /// 5. Настроить Android/iOS pairметры
  /// 6. Зарегистрировать обработчики нажатий (foreground + background)
  /// 7. Создать канал уведомлений
  /// 8. Delete просроченные уведомления (_restoreMissedNotifications)
  Future<void> initialize() async {
    try {
      // 1. Часовые пояса — ДОЛЖНЫ быть инициализированы до любых zonedSchedule
      tz_data.initializeTimeZones();
      try {
        final timezoneInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
        debugPrint('Timezone: ${timezoneInfo.identifier}');
      } catch (e) {
        debugPrint('Failed to set timezone, using UTC: $e');
        tz.setLocalLocation(tz.UTC);
      }

      // 2. Плагин и SharedPreferences
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      _prefs = await SharedPreferences.getInstance();

      // 3. Инициализация плагина — ПЕРЕД загрузкой и планированием
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _handleNotificationClick(response);
        },
        onDidReceiveBackgroundNotificationResponse:
            _handleBackgroundNotificationClick,
      );

      // 4. Канал уведомлений (Android)
      await _createNotificationChannel();

      // 5. Загрузка и очистка — после инициализации плагина
      await _loadScheduledNotifications();
      await _restoreMissedNotifications();

      debugPrint('NotificationService initialized');
      debugPrint(
          'Scheduled notifications: ${_scheduledNotifications.length}');
    } catch (e) {
      debugPrint('NotificationService init error: $e');
      rethrow;
    }
  }

  /// 🟢 СОЗДАНИЕ КАНАЛА УВЕДОМЛЕНИЙ [file:12] 3.1
  /// 
  /// КАНАЛ (Android):
  /// - ID: 'lens_tracker_channel'
  /// - Название: 'Напоминания о линзах'
  /// - Важность: max
  /// - Звук: custom (notification)
  /// - Вибрация: [0, 500, 1000, 500]
  /// - LED: primary (#004B71)
  Future<void> _createNotificationChannel() async {
    final l10n = _l10n;
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'lens_tracker_channel',
      l10n.notificationChannelName,
      description: l10n.notificationChannelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 1000, 500]),
      ledColor: AppColors.primary,
      enableLights: true,
      showBadge: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// 🟢 ПРОВЕРКА И ЗАПРОС РАЗРЕШЕНИЙ [file:12] 3.5
  /// 
  /// ПОТОК:
  /// 1. Проверить текущий статус Permission.notification
  /// 2. Если granted → return true
  /// 3. Если permanentlyDenied → показать диалог с инструкцией → openAppSettings()
  /// 4. Иначе → показать объяснительный диалог
  ///    → Если пользователь согласен → Permission.notification.request()
  ///    → Если granted → SnackBar "Notifications разрешены! ✅"
  ///    → Если denied → SnackBar "Notifications отключены"
  Future<bool> checkAndRequestPermission(BuildContext context) async {
    final l10n = context.l10n;
    try {
      final status = await Permission.notification.status;

      // 🟢 Уже разрешено
      if (status.isGranted) {
        return true;
      }

      // 🟢 Навсегда запрещено → инструкция к настройкам
      if (status.isPermanentlyDenied) {
        _showPermanentlyDeniedDialog(context);
        return false;
      }

      // 🟢 Показываем объяснительный диалог
      final shouldRequest = await _showPermissionDialog(context);

      if (shouldRequest == true) {
        final result = await Permission.notification.request();

        if (result.isGranted) {
          _showSuccessMessage(context, l10n.notificationPermissionGranted);
          return true;
        } else if (result.isDenied) {
          _showInfoMessage(context, l10n.notificationPermissionDenied);
          return false;
        }
      }

      return false;
    } catch (e) {
      debugPrint('❌ Permission request error: $e');
      _showErrorMessage(context, l10n.notificationPermissionError);
      return false;
    }
  }

  /// Диалог объяснения необходимости разрешений
  Future<bool?> _showPermissionDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.l10n.notificationAllowTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.notificationAllowSubtitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                _buildFeatureRow(Icons.change_circle, context.l10n.notificationFeatureReplacement),
                _buildFeatureRow(
                    Icons.health_and_safety, context.l10n.notificationFeatureEyeHealth),
                _buildFeatureRow(Icons.schedule, context.l10n.notificationFeaturePeriodControl),
                _buildFeatureRow(
                    Icons.notifications_active, context.l10n.notificationFeatureWarnings),
                const SizedBox(height: 20),
                Text(
                  context.l10n.notificationPermissionDisableAnytime,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                shape: const StadiumBorder(),
                alignment: Alignment.center,
              ),
              child: Text(
                context.l10n.notificationAllowLater,
                style: TextStyle(fontSize: 16),
              ),
            ),
            PrimaryGradientButton(
              onPressed: () => Navigator.of(context).pop(true),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                context.l10n.notificationAllow,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// Диалог при permanentlyDenied → инструкция к настройкам
  void _showPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.l10n.notificationBlockedTitle),
          content: Text(
            context.l10n.notificationBlockedMessageDetailed,
            style: TextStyle(fontSize: 15),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                shape: const StadiumBorder(),
                alignment: Alignment.center,
              ),
              child: Text(context.l10n.cancel),
            ),
            PrimaryGradientButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text(context.l10n.notificationOpenSettings),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(BuildContext _, String __) {
    // Успешные действия не дублируем нижним snackbar — достаточно системных уведомлений / UI.
  }

  void _showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.onError,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 🟢 ПЛАНИРОВАНИЕ УВЕДОМЛЕНИЙ О ЗАМЕНЕ ЛИНЗ [file:12] 3.3
  /// 
  /// 🔧 ИСПРАВЛЕНА ЛОГИКА:
  /// - Notification time теперь берётся из pairметра notificationTime (не 09:00)
  /// - Перед планированием отменяются старые уведомления с тем же lensId
  /// - Для однодневных линз специальная обработка (через 12-13 hourов)
  /// 
  /// ПАРАМЕТРЫ:
  /// - lensId: String — идентификатор линз
  /// - lensName: String — название для отображения
  /// - replacementDate: DateTime — дата уведомления
  /// - notificationTime: TimeOfDay — время уведомления
  /// - customMessage: String? — кастомный текст (иначе стандартный)
  /// - notificationId: int? — ID уведомления (иначе хэш от lensId)
  /// 
  /// ЛОГИКА:
  /// 1. Вычислить tz.TZDateTime из replacementDate + notificationTime
  /// 2. Если дата в прошлом → НЕ планировать (return)
  /// 3. Сформировать NotificationDetails (Android: actions ["mark_as_done", "snooze"])
  /// 4. Вызвать zonedSchedule (exactAllowWhileIdle)
  /// 5. Save в _scheduledNotifications + SharedPreferences
  Future<void> scheduleLensReplacementNotification({
    required String lensId,
    required String lensName,
    required DateTime replacementDate,
    required TimeOfDay notificationTime,
    String? customMessage,
    int? notificationId,
    int daysOffset = 0,
    int second = 0,
  }) async {
    try {
      // 🟢 Генерация ID
      final int finalNotificationId =
          notificationId ?? _generateNotificationId(lensId, daysOffset);

      // 🟢 Вычисление запланированной даты с учётом hourового пояса
      final tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        replacementDate.year,
        replacementDate.month,
        replacementDate.day,
        notificationTime.hour,
        notificationTime.minute,
        second,
      );

      final now = tz.TZDateTime.now(tz.local);
      debugPrint(
          'TEST schedule: now=$now, scheduled=$scheduledDate, diff=${scheduledDate.difference(now)}');

      // 🟢 Пропускаем, если дата в прошлом
      if (scheduledDate.isBefore(now)) {
        debugPrint('Skipping notification in the past ($scheduledDate)');
        return;
      }

      final l10n = _l10n;
      final title = l10n.notificationTitleReplace;
      final body =
          customMessage ?? l10n.notificationBodyReplaceToday;

      // 🟢 Android детали (канал lens_tracker_channel, системный звук по умолчанию)
      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'lens_tracker_channel',
        l10n.notificationChannelName,
        channelDescription: l10n.notificationChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
        sound: null,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 500, 1000, 500]),
        colorized: true,
        color: AppColors.primary,
        styleInformation: const BigTextStyleInformation(''),
        actions: [
          AndroidNotificationAction(
            'mark_as_done',
            l10n.notificationActionDone,
            showsUserInterface: true,
          ),
          AndroidNotificationAction(
            'snooze',
            l10n.notificationActionSnooze,
          ),
        ],
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      // 🟢 Формирование payload
      final payload = json.encode({
        'type': 'lens_replacement',
        'lensId': lensId,
        'lensName': lensName,
        'replacementDate': replacementDate.toIso8601String(),
        'notificationId': finalNotificationId,
        'action': 'open_lens_details',
      });

      // 🟢 Планирование уведомления (с fallback на inexact при ошибке разрешений)
      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // inexactAllowWhileIdle — надёжнее на многих устройствах (Xiaomi, Huawei и др.)
      AndroidScheduleMode scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
      if (androidPlugin != null) {
        final canExact = await androidPlugin.canScheduleExactNotifications();
        if (canExact == true) {
          scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
          debugPrint('Exact notifications available');
        } else {
          debugPrint('Using inexact schedule mode');
        }
      }

      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          finalNotificationId,
          title,
          body,
          scheduledDate,
          notificationDetails,
          androidScheduleMode: scheduleMode,
          payload: payload,
        );
      } catch (e) {
        if (e.toString().contains('exact_alarms') ||
            e.toString().contains('SCHEDULE_EXACT_ALARM')) {
          debugPrint('Fallback to inexactAllowWhileIdle: $e');
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            finalNotificationId,
            title,
            body,
            scheduledDate,
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: payload,
          );
        } else {
          rethrow;
        }
      }

      // 🟢 Сохранение в списке
      final notification = ScheduledNotification(
        id: finalNotificationId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        payload: payload,
        lensId: lensId,
      );

      _scheduledNotifications.add(notification);
      await _saveScheduledNotifications();

      debugPrint('Notification scheduled:');
      debugPrint('   ID: $finalNotificationId');
      debugPrint('   Lens: $lensName');
      debugPrint('   Date: $scheduledDate');
      debugPrint('   Text: $body');
    } catch (e) {
      debugPrint('Notification scheduling error: $e');
      rethrow;
    }
  }

  /// 🟢 ПЛАНИРОВАНИЕ РЕГУЛЯРНЫХ НАПОМИНАНИЙ [file:12] 3.3
  /// 
  /// Планирует несколько уведомлений за N days до замены
  /// Например: [7, 3, 1] → за неделю, за 3 days, за 1 day
  Future<void> scheduleRegularReminder({
    required String lensId,
    required String lensName,
    required List<int> daysBefore,
    required DateTime replacementDate,
    TimeOfDay notificationTime = const TimeOfDay(hour: 9, minute: 0),
  }) async {
    final l10n = _l10n;
    for (final days in daysBefore) {
      final reminderDate =
          replacementDate.subtract(Duration(days: days));
      final when = days == 1 ? l10n.mainTomorrow : l10n.mainInDays(days);

      await scheduleLensReplacementNotification(
        lensId: lensId,
        lensName: lensName,
        replacementDate: reminderDate,
        notificationTime: notificationTime,
        customMessage: l10n.mainTimeToReplaceMessage(when),
        notificationId: _generateNotificationId(lensId, days),
      );
    }
  }

  /// 🟢 ОТМЕНА УВЕДОМЛЕНИЙ ПО lensId [file:12] 3.3
  /// 
  /// Отменяет все уведомления для указанного lensId
  Future<void> cancelLensNotifications(String lensId) async {
    try {
      final notificationsToRemove = _scheduledNotifications
          .where((n) => n.lensId == lensId)
          .toList();

      for (final notification in notificationsToRemove) {
        await _flutterLocalNotificationsPlugin.cancel(notification.id);
        _scheduledNotifications.remove(notification);
      }

      await _saveScheduledNotifications();
      debugPrint('Canceled notifications for $lensId: ${notificationsToRemove.length}');
    } catch (e) {
      debugPrint('Notification cancel error: $e');
    }
  }

  /// Планирование ежедневных уведомлений с советами по уходу
  Future<void> scheduleDailyTipNotifications({
    required bool enabled,
    required String timeString,
    required LensType lensType,
  }) async {
    await cancelLensNotifications('daily_tip');
    if (!enabled) return;

    final parts = timeString.split(':');
    final hour = int.tryParse(parts[0]) ?? 9;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = tz.TZDateTime.now(tz.local);
    final l10n = _l10n;
    final androidDetails = AndroidNotificationDetails(
      'lens_tracker_channel',
      l10n.notificationChannelName,
      channelDescription: l10n.notificationChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    final details = NotificationDetails(android: androidDetails);

    for (int d = 0; d < 7; d++) {
      final date = now.add(Duration(days: d));
      final scheduled = tz.TZDateTime(tz.local, date.year, date.month, date.day, hour, minute);
      if (scheduled.isBefore(now)) continue;

      final tipText = LensTipsManager.getTipTextForDate(lensType, date);
      final id = 888800 + (d % 100);

      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          l10n.notificationDailyTipTitle,
          tipText,
          scheduled,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: json.encode({'type': 'daily_tip', 'date': date.toIso8601String()}),
        );
        _scheduledNotifications.add(ScheduledNotification(
          id: id,
          title: l10n.notificationDailyTipTitle,
          body: tipText,
          scheduledDate: scheduled,
          payload: json.encode({'type': 'daily_tip'}),
          lensId: 'daily_tip',
        ));
      } catch (e) {
        debugPrint('Daily tip scheduling error at $scheduled: $e');
      }
    }
    await _saveScheduledNotifications();
    debugPrint('Daily tips scheduled for 7 days');
  }

  /// Уведомление о покупке раствора (раз в N месяцев, в выбранный day недели и время)
  Future<void> scheduleSolutionPurchaseNotification({
    required bool enabled,
    required int dayOfWeek,
    required String timeString,
    required int periodMonths,
  }) async {
    await cancelLensNotifications('solution_purchase');
    if (!enabled) return;

    final parts = timeString.split(':');
    final hour = int.tryParse(parts[0]) ?? 9;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = tz.TZDateTime.now(tz.local);
    final l10n = _l10n;
    final androidDetails = AndroidNotificationDetails(
      'lens_tracker_channel',
      l10n.notificationChannelName,
      channelDescription: l10n.notificationChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    final details = NotificationDetails(android: androidDetails);

    int scheduledCount = 0;
    const maxScheduled = 12;

    for (int period = 0; period < maxScheduled; period++) {
      final target = DateTime(now.year, now.month + period * periodMonths, 1);
      var date = target;
      while (date.weekday != dayOfWeek) {
        date = date.add(const Duration(days: 1));
        if (date.month != target.month) break;
      }
      if (date.month != target.month) continue;

      final scheduled = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
      if (scheduled.isBefore(now)) continue;

      final id = 777700 + scheduledCount;
      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          l10n.notificationSolutionTitle,
          l10n.notificationSolutionBody,
          scheduled,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: json.encode({
            'type': 'solution_purchase',
            'lensId': 'solution_purchase',
          }),
        );
        _scheduledNotifications.add(ScheduledNotification(
          id: id,
          title: l10n.notificationSolutionTitle,
          body: l10n.notificationSolutionBody,
          scheduledDate: scheduled,
          payload: json.encode({'type': 'solution_purchase'}),
          lensId: 'solution_purchase',
        ));
        scheduledCount++;
      } catch (e) {
        debugPrint('Solution reminder scheduling error: $e');
      }
    }

    await _saveScheduledNotifications();
    debugPrint('Solution purchase reminders scheduled: $scheduledCount');
  }

  /// Low stock reminder — ежедневно в выбранное время, если запас < порога
  Future<void> scheduleLowStockReminder(LensDataService dataService) async {
    await cancelLensNotifications('low_stock_reminder');
    if (!dataService.getLowStockReminderEnabled()) return;

    final currentStock = dataService.getCurrentStock();
    final threshold = dataService.getStockAlertThreshold();
    if (currentStock >= threshold) return;

    final timeString = dataService.getLowStockReminderTime();
    final parts = timeString.split(':');
    final hour = int.tryParse(parts[0]) ?? 9;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = tz.TZDateTime.now(tz.local);
    final l10n = _l10n;
    final androidDetails = AndroidNotificationDetails(
      'lens_tracker_channel',
      l10n.notificationChannelName,
      channelDescription: l10n.notificationChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    final details = NotificationDetails(android: androidDetails);

    const daysAhead = 7;
    int scheduledCount = 0;

    for (int d = 0; d < daysAhead; d++) {
      final date = now.add(Duration(days: d));
      final scheduled = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
      if (scheduled.isBefore(now)) continue;

      final id = 666600 + d;
      final body = l10n.mainLowStockWarning(currentStock);
      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          l10n.notificationLowStockTitle,
          body,
          scheduled,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: json.encode({
            'type': 'low_stock_reminder',
            'lensId': 'low_stock_reminder',
          }),
        );
        _scheduledNotifications.add(ScheduledNotification(
          id: id,
          title: l10n.notificationLowStockTitle,
          body: body,
          scheduledDate: scheduled,
          payload: json.encode({'type': 'low_stock_reminder'}),
          lensId: 'low_stock_reminder',
        ));
        scheduledCount++;
      } catch (e) {
        debugPrint('Low stock reminder scheduling error: $e');
      }
    }

    await _saveScheduledNotifications();
    debugPrint('Low stock reminders scheduled: $scheduledCount');
  }

  /// 🟢 ОТМЕНА ВСЕХ УВЕДОМЛЕНИЙ [file:12] 2.6, 3.3
  /// 
  /// 🔧 ИСПРАВЛЕНА ЛОГИКА:
  /// - Теперь вызывается при clearAll() в SettingsScreen
  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      _scheduledNotifications.clear();
      await _saveScheduledNotifications();
      debugPrint('All notifications canceled');
    } catch (e) {
      debugPrint('Cancel-all notifications error: $e');
    }
  }

  /// Тестовое запланированное уведомление через zonedSchedule
  Future<void> scheduleTestNotification(
    BuildContext context, {
    int delaySeconds = 60,
  }) async {
    try {
      final hasPermission = await areNotificationsEnabled();
      if (!hasPermission) {
        final granted = await checkAndRequestPermission(context);
        if (!granted && context.mounted) {
          _showErrorMessage(context, _l10n.notificationTestAllowForTest);
          return;
        }
      }

      await requestExactAlarmsPermissionIfNeeded();
      await cancelLensNotifications('test_scheduled');

      final scheduledTZ =
          tz.TZDateTime.now(tz.local).add(Duration(seconds: delaySeconds));
      final body = _l10n.notificationTestScheduledBody;

      debugPrint('Test zonedSchedule at $scheduledTZ in $delaySeconds sec');

      final l10n = _l10n;
      final androidDetails = AndroidNotificationDetails(
        'lens_tracker_channel',
        l10n.notificationChannelName,
        channelDescription: l10n.notificationChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 500, 1000, 500]),
        colorized: true,
        color: AppColors.primary,
        styleInformation: const BigTextStyleInformation(''),
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final payload = json.encode({
        'type': 'test_scheduled',
        'action': 'open_home',
      });

      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      AndroidScheduleMode scheduleMode =
          AndroidScheduleMode.exactAllowWhileIdle;
      if (androidPlugin != null) {
        final canExact = await androidPlugin.canScheduleExactNotifications();
        if (canExact != true) {
          scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
        }
      }

      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          999998,
          _l10n.notificationTestTitleInSeconds(delaySeconds),
          body,
          scheduledTZ,
          details,
          androidScheduleMode: scheduleMode,
          payload: payload,
        );
      } catch (e) {
        if (e.toString().contains('exact_alarms') ||
            e.toString().contains('SCHEDULE_EXACT_ALARM')) {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            999998,
            _l10n.notificationTestTitleInSeconds(delaySeconds),
            body,
            scheduledTZ,
            details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: payload,
          );
        } else {
          rethrow;
        }
      }

      _scheduledNotifications.add(ScheduledNotification(
        id: 999998,
        title: _l10n.notificationTestTitleInSeconds(delaySeconds),
        body: body,
        scheduledDate: scheduledTZ,
        payload: payload,
        lensId: 'test_scheduled',
      ));
      await _saveScheduledNotifications();

      debugPrint('Test zonedSchedule scheduled');

      if (context.mounted) {
        final msg = delaySeconds < 60
            ? _l10n.notificationTestInSeconds(delaySeconds)
            : _l10n.notificationTestInMinutes(delaySeconds ~/ 60);
        _showSuccessMessage(context, _l10n.notificationTestScheduledSuccess(msg));
      }
    } catch (e) {
      debugPrint('Schedule test error: $e');
      if (context.mounted) {
        _showErrorMessage(context, '${_l10n.error}: $e');
      }
    }
  }

  /// Тест zonedSchedule — прямой вызов для проверки запланированных уведомлений
  Future<void> debugScheduleInSeconds(
      BuildContext context, int delaySeconds) async {
    try {
      final hasPermission = await areNotificationsEnabled();
      if (!hasPermission) {
        final granted = await checkAndRequestPermission(context);
        if (!granted && context.mounted) {
          _showErrorMessage(context, _l10n.notificationTestPermissionNotGranted);
          return;
        }
      }

      await requestExactAlarmsPermissionIfNeeded();

      final now = tz.TZDateTime.now(tz.local);
      final scheduled = now.add(Duration(seconds: delaySeconds));
      debugPrint('📅 zonedSchedule: now=$now, scheduled=$scheduled');

      final androidDetails = AndroidNotificationDetails(
        'lens_tracker_channel',
        _l10n.notificationChannelName,
        channelDescription: _l10n.notificationChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 500, 1000, 500]),
        colorized: true,
        color: AppColors.primary,
        styleInformation: const BigTextStyleInformation(''),
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        424242,
        _l10n.notificationTestTitleInSeconds(delaySeconds),
        _l10n.notificationTestDebugBody,
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: json.encode({'type': 'debug_test'}),
      );

      debugPrint('zonedSchedule set for $scheduled');

      if (context.mounted) {
        _showSuccessMessage(
          context,
          _l10n.notificationTestDebugScheduledSuccess(delaySeconds),
        );
      }
    } catch (e) {
      debugPrint('❌ debugScheduleInSeconds error: $e');
      if (context.mounted) {
        _showErrorMessage(context, '${_l10n.error}: $e');
      }
    }
  }

  /// Тестовое уведомление
  Future<void> showTestNotification(BuildContext context) async {
    try {
      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'lens_tracker_channel',
        _l10n.notificationChannelName,
        channelDescription: _l10n.notificationChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        999999,
        _l10n.notificationTestManualTitle,
        _l10n.notificationTestManualBody,
        notificationDetails,
        payload: json.encode({
          'type': 'test',
          'message': 'Test notification',
          'action': 'open_home',
        }),
      );

      _showSuccessMessage(context, _l10n.notificationTestSent);
    } catch (e) {
      _showErrorMessage(context, _l10n.notificationTestSendError('$e'));
    }
  }

  /// 🟢 Запрос разрешения на точные уведомления (Android 14+)
  /// Открывает настройки «Будильники и напоминания» если нужно
  Future<bool> requestExactAlarmsPermissionIfNeeded() async {
    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return true;

    final canExact = await androidPlugin.canScheduleExactNotifications();
    if (canExact == true) return true;

    debugPrint('Requesting exact alarm permission...');
    final granted = await androidPlugin.requestExactAlarmsPermission();
    return granted == true;
  }

  /// Получить все запланированные уведомления
  List<ScheduledNotification> getScheduledNotifications() {
    return List.from(_scheduledNotifications);
  }

  /// Получить уведомления для конкретных линз
  List<ScheduledNotification> getLensNotifications(String lensId) {
    return _scheduledNotifications
        .where((n) => n.lensId == lensId)
        .toList();
  }

  /// Статус разрешений
  Future<PermissionStatus> getPermissionStatus() async {
    return await Permission.notification.status;
  }

  /// Проверка, разрешены ли уведомления
  Future<bool> areNotificationsEnabled() async {
    final status = await getPermissionStatus();
    return status.isGranted;
  }

  /// 🟢 ГЕНЕРАЦИЯ ID УВЕДОМЛЕНИЯ [file:12] 3.3
  /// 
  /// Базовый ID из хэша lensId + offset для множественных уведомлений
  int _generateNotificationId(String lensId, [int daysOffset = 0]) {
    final baseId = lensId.hashCode.abs();
    return daysOffset > 0 ? baseId + daysOffset : baseId;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // РАБОТА С SharedPreferences
  // ═══════════════════════════════════════════════════════════════════════

  /// Сохранение запланированных уведомлений в SharedPreferences
  Future<void> _saveScheduledNotifications() async {
    final list = _scheduledNotifications.map((n) => n.toMap()).toList();
    await _prefs.setString('scheduled_notifications', json.encode(list));
  }

  /// Загрузка запланированных уведомлений из SharedPreferences
  Future<void> _loadScheduledNotifications() async {
    final jsonString = _prefs.getString('scheduled_notifications');
    if (jsonString != null) {
      try {
        final list = json.decode(jsonString) as List;
        _scheduledNotifications = list
            .map((item) => ScheduledNotification.fromMap(item))
            .toList();
      } catch (e) {
        debugPrint('Failed to load scheduled notifications: $e');
        _scheduledNotifications = [];
      }
    }
  }

  /// Удаление просроченных уведомлений
  Future<void> _restoreMissedNotifications() async {
    final now = tz.TZDateTime.now(tz.local);
    final missedNotifications = _scheduledNotifications
        .where((n) => n.scheduledDate.isBefore(now))
        .toList();

    if (missedNotifications.isNotEmpty) {
      debugPrint('Removing expired notifications: ${missedNotifications.length}');
      for (final notification in missedNotifications) {
        _scheduledNotifications.remove(notification);
      }
      await _saveScheduledNotifications();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ОБРАБОТКА НАЖАТИЙ НА УВЕДОМЛЕНИЯ [file:12] 3.4
  // ═══════════════════════════════════════════════════════════════════════

  /// Foreground обработка нажатий
  void _handleNotificationClick(NotificationResponse response) async {
    debugPrint('Notification tap (foreground): ${response.payload}');

    if (response.payload == null) return;

    try {
      final payload = json.decode(response.payload!) as Map<String, dynamic>;
      final action = response.actionId;

      if (action != null) {
        await _handleNotificationAction(action, payload);
      } else {
        await _handleNotificationTap(payload);
      }
    } catch (e) {
      debugPrint('Notification tap handling error: $e');
    }
  }

  /// Background обработка нажатий
  /// 
  /// 🟢 Сохраняет действие в SharedPreferences для обработки при следующем запуске
  @pragma('vm:entry-point')
  static Future<void> _handleBackgroundNotificationClick(
      NotificationResponse response) async {
    debugPrint('Notification tap (background): ${response.payload}');

    if (response.payload == null) return;

    try {
      final payload = json.decode(response.payload!) as Map<String, dynamic>;
      final action = response.actionId;

      if (action != null) {
        // Сохраняем действие для обработки при запуске приложения
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'pending_notification_action',
          json.encode({'action': action, 'payload': payload}),
        );
      }
    } catch (e) {
      debugPrint('Background notification tap error: $e');
    }
  }

  /// Обработка действий из уведомлений (кнопки)
  Future<void> _handleNotificationAction(
      String action, Map<String, dynamic> payload) async {
    switch (action) {
      case 'mark_as_done':
        // Emit событие для UI
        _notificationClickStream.add({
          'action': 'mark_lens_replaced',
          'lensId': payload['lensId'],
          'lensName': payload['lensName'],
        });
        // Отменяем все уведомления для этих линз
        await cancelLensNotifications(payload['lensId']);
        break;

      case 'snooze':
        // Перепланирование через 1 hour
        final newDate = DateTime.now().add(const Duration(hours: 1));
        await scheduleLensReplacementNotification(
          lensId: payload['lensId'],
          lensName: payload['lensName'],
          replacementDate: newDate,
          notificationTime: TimeOfDay.now(),
        );
        break;

      default:
        await _handleNotificationTap(payload);
    }
  }

  /// Обработка обычного нажатия на уведомление (не на кнопку)
  Future<void> _handleNotificationTap(Map<String, dynamic> payload) async {
    final action = payload['action'];
    _notificationClickStream.add(payload);

    // Вызов callback для навигации
    if (_navigationCallback != null) {
      _navigationCallback!(action, payload);
    }
  }

  /// 🟢 ПРОВЕРКА ОТЛОЖЕННЫХ ДЕЙСТВИЙ [file:12] 3.4
  /// 
  /// Вызывается в main() → _checkPendingNotificationActions()
  /// Читает 'pending_notification_action' из SharedPreferences
  /// Удаляет после прочтения
  Future<Map<String, dynamic>?> getPendingNotificationAction() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('pending_notification_action');

    if (jsonString != null) {
      await prefs.remove('pending_notification_action');
      return json.decode(jsonString);
    }

    return null;
  }

  /// Сохранение настроек уведомлений
  Future<void> setNotificationSettings({
    required bool enabled,
    TimeOfDay? defaultTime,
    List<int>? reminderDays,
  }) async {
    await _prefs.setBool('notifications_enabled', enabled);

    if (defaultTime != null) {
      await _prefs.setInt('notification_hour', defaultTime.hour);
      await _prefs.setInt('notification_minute', defaultTime.minute);
    }

    if (reminderDays != null) {
      await _prefs.setString('reminder_days', json.encode(reminderDays));
    }
  }

  /// Получение настроек уведомлений
  Future<Map<String, dynamic>> getNotificationSettings() async {
    final enabled = _prefs.getBool('notifications_enabled') ?? true;
    final hour = _prefs.getInt('notification_hour') ?? 9;
    final minute = _prefs.getInt('notification_minute') ?? 0;
    final reminderDaysJson = _prefs.getString('reminder_days');

    final reminderDays = reminderDaysJson != null
        ? List<int>.from(json.decode(reminderDaysJson))
        : [7, 3, 1];

    return {
      'enabled': enabled,
      'defaultTime': TimeOfDay(hour: hour, minute: minute),
      'reminderDays': reminderDays,
    };
  }

  /// 🟢 ПОЛНАЯ ОЧИСТКА ДАННЫХ [file:12] 2.6, 3.3
  /// 
  /// 🔧 ИСПРАВЛЕНА ЛОГИКА:
  /// - Теперь вызывается при clearAll() в SettingsScreen
  Future<void> clearAllData() async {
    await cancelAllNotifications();
    await _prefs.remove('scheduled_notifications');
    await _prefs.remove('pending_notification_action');
    _scheduledNotifications.clear();
  }

  /// Отладочная печать всех уведомлений
  Future<void> debugPrintNotifications() async {
    debugPrint('=== DEBUG: Scheduled notifications ===');
    for (final notification in _scheduledNotifications) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('ID: ${notification.id}');
      debugPrint('Lens ID: ${notification.lensId}');
      debugPrint('Date: ${notification.scheduledDate}');
      debugPrint('Text: ${notification.body}');
    }
    debugPrint('═══════════════════════════════════════════');
    debugPrint('Total notifications: ${_scheduledNotifications.length}');
  }
}

