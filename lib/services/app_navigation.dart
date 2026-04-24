// services/app_navigation.dart

import 'package:flutter/material.dart';
import 'package:my_button_app_new/l10n/app_localizations.dart';
import 'package:my_button_app_new/l10n/domain_localization_extensions.dart';
import 'package:my_button_app_new/l10n/l10n_extensions.dart';
import 'package:my_button_app_new/screens/history_screen.dart';
import 'package:my_button_app_new/screens/home_screen.dart';
import 'package:my_button_app_new/screens/profile_screen.dart';
import 'package:my_button_app_new/screens/settings_screen.dart';
import 'package:my_button_app_new/services/app_locale_controller.dart';
import 'package:my_button_app_new/services/app_theme_controller.dart';
import 'package:my_button_app_new/services/home_widget_service.dart';
import 'package:my_button_app_new/services/lens_data_service.dart';
import 'package:my_button_app_new/services/notification_service.dart';
import 'package:my_button_app_new/theme/app_colors.dart';
import 'package:my_button_app_new/widgets/primary_gradient_button.dart';

/// рџџў РќРђР’РР“РђР¦РРЇ РџР РР›РћР–Р•РќРРЇ [file:12] 4
///
/// Р¦РµРЅС‚СЂР°Р»СЊРЅС‹Р№ РєР»Р°СЃСЃ РґР»СЏ СѓРїСЂР°РІР»РµРЅРёСЏ РЅР°РІРёРіР°С†РёРµР№ РјРµР¶РґСѓ СЌРєСЂР°РЅР°РјРё
/// Рё РѕР±СЂР°Р±РѕС‚РєРё РґРµР№СЃС‚РІРёР№ РёР· СѓРІРµРґРѕРјР»РµРЅРёР№
class AppNavigation {
  /// РЎС‚Р°С‚РёС‡РµСЃРєРѕРµ РїРѕР»Рµ РґР»СЏ РґРѕСЃС‚СѓРїР° Рє dataService РёР· Р»СЋР±РѕРіРѕ РјРµСЃС‚Р°
  static late LensDataService dataService;
  static late AppLocaleController localeController;
  static late AppThemeController themeController;

  /// рџџў РћР‘Р РђР‘РћРўРљРђ РќРђР’РР“РђР¦РР РР— РЈР’Р•Р”РћРњР›Р•РќРР™ [file:12] 4.1
  ///
  /// РџРћР”Р”Р•Р Р–РР’РђР•РњР«Р• Р”Р•Р™РЎРўР’РРЇ:
  /// - open_lens_details: РџРµСЂРµС…РѕРґ Рє РёСЃС‚РѕСЂРёРё Р»РёРЅР·
  /// - open_history: РћС‚РєСЂС‹С‚СЊ СЌРєСЂР°РЅ РёСЃС‚РѕСЂРёРё
  /// - open_home: Р’РµСЂРЅСѓС‚СЊСЃСЏ РЅР° РіР»Р°РІРЅС‹Р№ СЌРєСЂР°РЅ
  /// - open_profile: РћС‚РєСЂС‹С‚СЊ РїСЂРѕС„РёР»СЊ
  /// - open_settings: РћС‚РєСЂС‹С‚СЊ РЅР°СЃС‚СЂРѕР№РєРё
  /// - mark_lens_replaced: Р”РёР°Р»РѕРі РїРѕРґС‚РІРµСЂР¶РґРµРЅРёСЏ Р·Р°РјРµРЅС‹ Р»РёРЅР·
  /// - snooze_lens_reminder: РћС‚Р»РѕР¶РёС‚СЊ РЅР°РїРѕРјРёРЅР°РЅРёРµ
  /// - add_new_lens: Р”РѕР±Р°РІРёС‚СЊ РЅРѕРІС‹Рµ Р»РёРЅР·С‹ (РїРµСЂРµС…РѕРґ РІ РїСЂРѕС„РёР»СЊ)
  /// - check_eye_health: РџРѕРєР°Р·Р°С‚СЊ СЃРѕРІРµС‚С‹ РїРѕ Р·РґРѕСЂРѕРІСЊСЋ РіР»Р°Р·
  static void handleNotificationNavigation(
    BuildContext context,
    String action,
    Map<String, dynamic> payload,
  ) {
    debugPrint('Notification navigation: action=$action, payload=$payload');

    switch (action) {
      case 'open_lens_details':
        _openLensDetails(context, payload);
        break;
      case 'open_history':
        _openHistoryScreen(context);
        break;
      case 'open_home':
        _openHomeScreen(context);
        break;
      case 'open_profile':
        _openProfileScreen(context);
        break;
      case 'open_settings':
        _openSettingsScreen(context);
        break;
      case 'mark_lens_replaced':
      case 'mark_as_done':
        _showMarkAsDoneDialog(context, payload);
        break;
      case 'snooze_lens_reminder':
      case 'snooze':
        _showSnoozeDialog(context, payload);
        break;
      case 'add_new_lens':
        _openAddLensScreen(context);
        break;
      case 'check_eye_health':
        _showEyeHealthTips(context);
        break;
      default:
        debugPrint('Unknown notification action: $action, opening home');
        _openHomeScreen(context);
    }
  }

  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
  // РњР•РўРћР”Р« РќРђР’РР“РђР¦РР
  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

  /// РћС‚РєСЂС‹С‚СЊ РґРµС‚Р°Р»Рё Р»РёРЅР· (РїРµСЂРµС…РѕРґ РЅР° СЌРєСЂР°РЅ РёСЃС‚РѕСЂРёРё)
  static void _openLensDetails(
      BuildContext context, Map<String, dynamic> payload) {
    final l10n = context.l10n;
    final lensName = payload['lensName'] ?? l10n.mainReplaceLenses;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          dataService: dataService,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.historyTitle}: $lensName'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  /// РћС‚РєСЂС‹С‚СЊ СЌРєСЂР°РЅ РёСЃС‚РѕСЂРёРё
  static void _openHistoryScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(dataService: dataService),
      ),
    );
  }

  /// РћС‚РєСЂС‹С‚СЊ РіР»Р°РІРЅС‹Р№ СЌРєСЂР°РЅ
  static void _openHomeScreen(BuildContext context) {
    // РџСЂРѕРІРµСЂСЏРµРј, РЅРµ РЅР°С…РѕРґРёРјСЃСЏ Р»Рё СѓР¶Рµ РЅР° РіР»Р°РІРЅРѕРј СЌРєСЂР°РЅРµ
    if (ModalRoute.of(context)?.settings.name != '/') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            dataService: dataService,
            onDataChanged: () {},
            onCheckNotifications: () {},
          ),
        ),
        (route) => false,
      );
    }
  }

  /// РћС‚РєСЂС‹С‚СЊ СЌРєСЂР°РЅ РїСЂРѕС„РёР»СЏ
  static void _openProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          dataService: dataService,
          onDataChanged: () {},
        ),
      ),
    );
  }

  /// РћС‚РєСЂС‹С‚СЊ СЌРєСЂР°РЅ РЅР°СЃС‚СЂРѕРµРє
  static void _openSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          dataService: dataService,
          localeController: localeController,
          themeController: themeController,
          onDataChanged: () {},
        ),
      ),
    );
  }

  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
  // Р”РРђР›РћР“Р Р”Р•Р™РЎРўР’РР™ [file:12] 4.1
  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

  /// рџџў Р”РРђР›РћР“ РџРћР”РўР’Р•Р Р–Р”Р•РќРРЇ Р—РђРњР•РќР« Р›РРќР— [file:12] 4.1
  ///
  /// РџРћРЎР›Р•Р”РћР’РђРўР•Р›Р¬РќРћРЎРўР¬:
  /// 1. РџРѕРєР°Р·Р°С‚СЊ РґРёР°Р»РѕРі РїРѕРґС‚РІРµСЂР¶РґРµРЅРёСЏ СЃ РѕРїРёСЃР°РЅРёРµРј РґРµР№СЃС‚РІРёР№
  /// 2. РџСЂРё РїРѕРґС‚РІРµСЂР¶РґРµРЅРёРё:
  ///    - РћС‚РјРµРЅРёС‚СЊ СЃС‚Р°СЂС‹Рµ СѓРІРµРґРѕРјР»РµРЅРёСЏ (BUG-005)
  ///    - Р’С‹Р·РІР°С‚СЊ startNewLensPair()
  ///    - Р—Р°РїР»Р°РЅРёСЂРѕРІР°С‚СЊ РЅРѕРІС‹Рµ СѓРІРµРґРѕРјР»РµРЅРёСЏ СЃ РІСЂРµРјРµРЅРµРј РёР· РЅР°СЃС‚СЂРѕРµРє (MISSING-002)
  ///    - РџСЂРѕРІРµСЂРёС‚СЊ Р·Р°РїР°СЃ Рё РїРѕРєР°Р·Р°С‚СЊ РїСЂРµРґСѓРїСЂРµР¶РґРµРЅРёРµ (MISSING-001)
  /// 3. РџСЂРё РѕС€РёР±РєРµ: РїРѕРєР°Р·Р°С‚СЊ SnackBar
  static Future<void> _showMarkAsDoneDialog(
    BuildContext context,
    Map<String, dynamic> payload,
  ) async {
    final l10n = context.l10n;
    final lensId = payload['lensId'] ?? 'current_lens';
    final lensName = payload['lensName'] ?? l10n.mainReplaceLenses;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.mainLensReplacement),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.appNavMarkDoneQuestion(lensName),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.appNavAfterConfirm,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildDialogFeature(
                Icons.check_circle, context.l10n.appNavMarkDoneFeature1),
            _buildDialogFeature(
                Icons.calendar_today, context.l10n.appNavMarkDoneFeature2),
            _buildDialogFeature(
                Icons.inventory, context.l10n.appNavMarkDoneFeature3),
            _buildDialogFeature(
                Icons.notifications_off, context.l10n.appNavMarkDoneFeature4),
            _buildDialogFeature(
                Icons.alarm, context.l10n.appNavMarkDoneFeature5),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.notificationAllowLater),
          ),
          PrimaryGradientButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.appNavMarkDoneConfirmButton),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      try {
        final notificationService = NotificationService();

        // рџ”§ BUG-005: РћС‚РјРµРЅСЏРµРј СЃС‚Р°СЂС‹Рµ СѓРІРµРґРѕРјР»РµРЅРёСЏ РїРµСЂРµРґ РїР»Р°РЅРёСЂРѕРІР°РЅРёРµРј РЅРѕРІС‹С…
        await notificationService.cancelLensNotifications(lensId);
        await notificationService.cancelLensNotifications('current_lens');
        await notificationService.cancelLensNotifications('current_lens_day');

        debugPrint('Old lens notifications canceled');

        // РќР°С‡РёРЅР°РµРј РЅРѕРІС‹Р№ С†РёРєР»
        await dataService.startNewLensPair();

        debugPrint('New lens cycle started');

        // РћР±РЅРѕРІР»СЏРµРј РІРёРґР¶РµС‚ В«Р”Рѕ Р·Р°РјРµРЅС‹ Р»РёРЅР·В»
        HomeWidgetService.updateLensWidget(dataService);

        // РџР»Р°РЅРёСЂСѓРµРј РЅРѕРІС‹Рµ СѓРІРµРґРѕРјР»РµРЅРёСЏ
        await _scheduleNotificationsForActiveCycle();

        // рџ”§ MISSING-001: РџСЂРѕРІРµСЂСЏРµРј Р·Р°РїР°СЃ Рё РїРѕРєР°Р·С‹РІР°РµРј РїСЂРµРґСѓРїСЂРµР¶РґРµРЅРёРµ
        final currentStock = dataService.getCurrentStock();
        final isLowStock = dataService.isStockLow();

        if (context.mounted) {
          // РџРѕРєР°Р·С‹РІР°РµРј РїСЂРµРґСѓРїСЂРµР¶РґРµРЅРёРµ Рѕ РЅРёР·РєРѕРј Р·Р°РїР°СЃРµ
          if (isLowStock) {
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.l10n.mainLowStockWarning(currentStock),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    duration: const Duration(seconds: 4),
                    action: SnackBarAction(
                      label: context.l10n.appNavRestock,
                      textColor: Theme.of(context).colorScheme.onTertiary,
                      onPressed: () {
                        // Р’РѕР·РІСЂР°С‚ РЅР° РіР»Р°РІРЅС‹Р№ СЌРєСЂР°РЅ РґР»СЏ РѕР±РЅРѕРІР»РµРЅРёСЏ Р·Р°РїР°СЃР°
                        _openHomeScreen(context);
                      },
                    ),
                  ),
                );
              }
            });
          }
        }
      } catch (e) {
        debugPrint('вќЊ Error while replacing lenses: $e');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.mainErrorReplacingLenses}: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  /// рџ”§ РџР»Р°РЅРёСЂРѕРІР°РЅРёРµ СѓРІРµРґРѕРјР»РµРЅРёР№ СЃ РІСЂРµРјРµРЅРµРј РёР· РЅР°СЃС‚СЂРѕРµРє
  ///
  /// Р›РћР“РРљРђ (СѓРЅРёС„РёС†РёСЂРѕРІР°РЅР° СЃ main.dart Рё settings):
  /// - РћРґРЅРѕРґРЅРµРІРЅС‹Рµ: Р·Р° N hourРѕРІ РґРѕ РєРѕРЅС†Р° (14С‡) + РІ РјРѕРјРµРЅС‚ РёСЃС‚РµС‡РµРЅРёСЏ
  /// - РћСЃС‚Р°Р»СЊРЅС‹Рµ: Р·Р° N days РґРѕ Р·Р°РјРµРЅС‹ + РІ day Р·Р°РјРµРЅС‹
  static Future<void> _scheduleNotificationsForActiveCycle() async {
    final l10n = lookupAppLocalizations(localeController.resolvedLocale);
    final activeCycle = dataService.getActiveCycle();
    if (activeCycle == null) {
      debugPrint('No active cycle for notification scheduling');
      return;
    }

    final lensType = activeCycle.lensType;
    final lensTypeLabel = lensType.localizedLabel(l10n);
    final notificationService = NotificationService();
    final hoursBefore = dataService.getDailyHoursBeforeReminder();
    final notifyAtExpiry = dataService.getDailyNotifyAtExpiry();
    final otherDaysBefore = dataService.getOtherDaysBeforeReminder();
    final timeStr = dataService.getNotificationTime();
    final parts = timeStr.split(':');
    final notifTime = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 8,
      minute: int.tryParse(parts[1]) ?? 0,
    );
    final nextReplacementDate =
        activeCycle.startDate.add(Duration(days: lensType.days));

    debugPrint(
        'Scheduling notifications: $lensTypeLabel, date: $nextReplacementDate');

    // РћС‚РјРµРЅСЏРµРј СЃС‚Р°СЂС‹Рµ РїРµСЂРµРґ РїР»Р°РЅРёСЂРѕРІР°РЅРёРµРј
    await notificationService.cancelLensNotifications('current_lens');
    await notificationService.cancelLensNotifications('current_lens_day');
    await notificationService.cancelLensNotifications('current_lens_before');
    await notificationService.cancelLensNotifications('current_lens_expiry');

    if (lensType.days == 1) {
      final reminderBefore =
          activeCycle.startDate.add(Duration(hours: 14 - hoursBefore));
      if (reminderBefore.isAfter(DateTime.now())) {
        await notificationService.scheduleLensReplacementNotification(
          lensId: 'current_lens_before',
          lensName: lensTypeLabel,
          replacementDate: reminderBefore,
          notificationTime: TimeOfDay.fromDateTime(reminderBefore),
          customMessage: l10n.mainTimeMessageHoursBefore(hoursBefore),
        );
      }
      if (notifyAtExpiry) {
        final reminderExpiry =
            activeCycle.startDate.add(const Duration(hours: 14));
        if (reminderExpiry.isAfter(DateTime.now())) {
          await notificationService.scheduleLensReplacementNotification(
            lensId: 'current_lens_expiry',
            lensName: lensTypeLabel,
            replacementDate: reminderExpiry,
            notificationTime: TimeOfDay.fromDateTime(reminderExpiry),
            notificationId: 1002,
            customMessage: l10n.mainTimeMessageExpiry,
          );
        }
      }
      return;
    }

    final reminderDate =
        nextReplacementDate.subtract(Duration(days: otherDaysBefore));
    if (reminderDate.isAfter(DateTime.now())) {
      final when = otherDaysBefore == 1
          ? l10n.mainTomorrow
          : l10n.mainInDays(otherDaysBefore);
      await notificationService.scheduleLensReplacementNotification(
        lensId: 'current_lens',
        lensName: lensTypeLabel,
        replacementDate: reminderDate,
        notificationTime: notifTime,
        customMessage: l10n.mainTimeToReplaceMessage(when),
      );
    }
    if (nextReplacementDate.isAfter(DateTime.now())) {
      await notificationService.scheduleLensReplacementNotification(
        lensId: 'current_lens_day',
        lensName: lensTypeLabel,
        replacementDate: nextReplacementDate,
        notificationTime: notifTime,
        notificationId: 1001,
      );
    }
  }

  /// рџџў Р”РРђР›РћР“ РћРўРљР›РђР”Р«Р’РђРќРРЇ РќРђРџРћРњРРќРђРќРРЇ [file:12] 4.1
  ///
  /// Р’РђР РРђРќРўР«:
  /// - In 1 hour
  /// - In 3 hourР°
  /// - Tomorrow СѓС‚СЂРѕРј (С‡РµСЂРµР· 1 day)
  /// - In 2 days
  static Future<void> _showSnoozeDialog(
    BuildContext context,
    Map<String, dynamic> payload,
  ) async {
    final l10n = context.l10n;
    final lensName = payload['lensName'] ?? l10n.mainReplaceLenses;
    final lensId = payload['lensId'] ?? 'current_lens';

    final selectedDuration = await showDialog<Duration>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.notificationActionSnooze),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.appNavSnoozeChooseTime),
            const SizedBox(height: 20),
            _buildSnoozeOption(context, context.l10n.appNavSnoozeIn1Hour,
                const Duration(hours: 1)),
            _buildSnoozeOption(context, context.l10n.appNavSnoozeIn3Hours,
                const Duration(hours: 3)),
            _buildSnoozeOption(
                context,
                context.l10n.appNavSnoozeTomorrowMorning,
                const Duration(days: 1)),
            _buildSnoozeOption(context, context.l10n.appNavSnoozeIn2Days,
                const Duration(days: 2)),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.cancel),
          ),
        ],
      ),
    );

    if (selectedDuration != null && context.mounted) {
      try {
        final notificationService = NotificationService();
        final newDate = DateTime.now().add(selectedDuration);

        await notificationService.scheduleLensReplacementNotification(
          lensId: lensId,
          lensName: lensName,
          replacementDate: newDate,
          notificationTime: TimeOfDay.fromDateTime(newDate),
          customMessage: l10n.appNavReminderDelayedMessage,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.appNavReminderSnoozedFor(
                  _formatDuration(selectedDuration, l10n))),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error while snoozing reminder: $e');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${context.l10n.error}: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  /// рџ”§ MISSING-008: РћС‚РєСЂС‹С‚СЊ СЌРєСЂР°РЅ РґРѕР±Р°РІР»РµРЅРёСЏ Р»РёРЅР· (ProfileScreen)
  ///
  /// РРЎРџР РђР’Р›Р•РќРђ Р›РћР“РРљРђ:
  /// - РўРµРїРµСЂСЊ РїРµСЂРµС…РѕРґ РЅР° ProfileScreen РІРјРµСЃС‚Рѕ Р·Р°РіР»СѓС€РєРё
  /// - TODO: РђРІС‚РѕРјР°С‚РёС‡РµСЃРєРѕРµ РѕС‚РєСЂС‹С‚РёРµ РґРёР°Р»РѕРіР° СЂРµРґР°РєС‚РёСЂРѕРІР°РЅРёСЏ Р»РёРЅР·
  static void _openAddLensScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          dataService: dataService,
          onDataChanged: () {},
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.appNavOpenProfileSetupHint),
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// рџџў РЎРћР’Р•РўР« РџРћ Р—Р”РћР РћР’Р¬Р® Р“Р›РђР— [file:12] 4.1
  ///
  /// РџРѕРєР°Р·С‹РІР°РµС‚ РґРёР°Р»РѕРі СЃ 6 СЂРµРєРѕРјРµРЅРґР°С†РёСЏРјРё
  static Future<void> _showEyeHealthTips(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.appNavEyeHealthTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.appNavEyeHealthSubtitle,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildHealthTip(
                  Icons.water_drop_outlined, context.l10n.appNavEyeHealthTip1),
              _buildHealthTip(
                  Icons.schedule_outlined, context.l10n.appNavEyeHealthTip2),
              _buildHealthTip(
                  Icons.block_outlined, context.l10n.appNavEyeHealthTip3),
              _buildHealthTip(Icons.cleaning_services_outlined,
                  context.l10n.appNavEyeHealthTip4),
              _buildHealthTip(Icons.calendar_today_outlined,
                  context.l10n.appNavEyeHealthTip5),
              _buildHealthTip(
                  Icons.pool_outlined, context.l10n.appNavEyeHealthTip6),
              const SizedBox(height: 12),
              Text(
                context.l10n.appNavEyeHealthWarning,
                style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.appNavClose),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openProfileScreen(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.appNavMyLenses),
          ),
        ],
      ),
    );
  }

  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
  // Р’РЎРџРћРњРћР“РђРўР•Р›Р¬РќР«Р• Р’РР”Р–Р•РўР«
  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

  /// Р­Р»РµРјРµРЅС‚ СЃРїРёСЃРєР° РІ РґРёР°Р»РѕРіРµ СЃ РёРєРѕРЅРєРѕР№
  static Widget _buildDialogFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  /// РЎРѕРІРµС‚ РїРѕ Р·РґРѕСЂРѕРІСЊСЋ РіР»Р°Р·
  static Widget _buildHealthTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  /// РћРїС†РёСЏ РѕС‚РєР»Р°РґС‹РІР°РЅРёСЏ
  static Widget _buildSnoozeOption(
    BuildContext context,
    String text,
    Duration duration,
  ) {
    return ListTile(
      title: Text(text),
      leading: const Icon(Icons.access_time),
      onTap: () => Navigator.pop(context, duration),
    );
  }

  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
  // РЈРўРР›РРўР« РќРђР’РР“РђР¦РР [file:12] 4.2
  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

  /// РЎС‚Р°С‚РёС‡РµСЃРєРёР№ РјРµС‚РѕРґ РґР»СЏ Р±С‹СЃС‚СЂРѕР№ РЅР°РІРёРіР°С†РёРё РјРµР¶РґСѓ СЌРєСЂР°РЅР°РјРё
  static void navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    switch (routeName) {
      case '/home':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              dataService: dataService,
              onDataChanged: () {},
              onCheckNotifications: () {},
            ),
          ),
          (route) => false,
        );
        break;
      case '/history':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryScreen(dataService: dataService),
          ),
        );
        break;
      case '/profile':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              dataService: dataService,
              onDataChanged: () {},
            ),
          ),
        );
        break;
      case '/settings':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsScreen(
              dataService: dataService,
              localeController: localeController,
              themeController: themeController,
              onDataChanged: () {},
            ),
          ),
        );
        break;
      default:
        Navigator.pushNamed(context, routeName, arguments: arguments);
    }
  }

  /// РџСЂРѕРІРµСЂРєР° Р°РєС‚РёРІРЅРѕРіРѕ СЌРєСЂР°РЅР°
  static bool isScreenActive(BuildContext context, String screenName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return currentRoute == screenName;
  }

  /// РџРѕРєР°Р·Р°С‚СЊ РёРЅРґРёРєР°С‚РѕСЂ Р·Р°РіСЂСѓР·РєРё
  static Future<void> showLoadingIndicator(
    BuildContext context, {
    String? message,
  }) async {
    final effectiveMessage = message ?? context.l10n.loadingDots;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(effectiveMessage),
            ],
          ),
        ),
      ),
    );
  }

  /// РЎРєСЂС‹С‚СЊ РёРЅРґРёРєР°С‚РѕСЂ Р·Р°РіСЂСѓР·РєРё
  static void hideLoadingIndicator(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// РџРѕРєР°Р·Р°С‚СЊ СЃРѕРѕР±С‰РµРЅРёРµ РѕР± РѕС€РёР±РєРµ
  static void showErrorDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }

  /// РџРѕРєР°Р·Р°С‚СЊ СѓСЃРїРµС€РЅРѕРµ СЃРѕРѕР±С‰РµРЅРёРµ
  static void showSuccessDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }

  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
  // Р’РЎРџРћРњРћР“РђРўР•Р›Р¬РќР«Р• Р¤РЈРќРљР¦РР
  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

  /// Р¤РѕСЂРјР°С‚РёСЂРѕРІР°РЅРёРµ РїСЂРѕРґРѕР»Р¶РёС‚РµР»СЊРЅРѕСЃС‚Рё
  static String _formatDuration(Duration duration, AppLocalizations l10n) {
    if (duration.inDays > 0) {
      final days = duration.inDays;
      return '$days ${l10n.dayWord(days)}';
    } else if (duration.inHours > 0) {
      final hours = duration.inHours;
      return '$hours ${l10n.hourWord(hours)}';
    } else {
      final minutes = duration.inMinutes;
      return '$minutes ${l10n.appNavMinutesShort}';
    }
  }
}

