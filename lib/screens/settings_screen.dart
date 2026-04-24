import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';
import '../l10n/domain_localization_extensions.dart';
import '../l10n/l10n_extensions.dart';
import '../models/app_language_preference.dart';
import '../models/app_theme_preference.dart';
import '../models/lens_data.dart';
import '../services/app_locale_controller.dart';
import '../services/app_theme_controller.dart';
import '../services/home_widget_service.dart';
import '../services/lens_data_service.dart';
import '../services/notification_service.dart';
import '../theme/neon_theme.dart';
import '../utils/intl_locale.dart';
import '../widgets/primary_gradient_button.dart';

class SettingsScreen extends StatefulWidget {
  final LensDataService dataService;
  final AppLocaleController localeController;
  final AppThemeController themeController;
  final VoidCallback onDataChanged;

  const SettingsScreen({
    Key? key,
    required this.dataService,
    required this.localeController,
    required this.themeController,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);
  int _stockAlertThreshold = 1;
  String _notificationStatus = '...';
  bool _isLoading = true;
  int _dailyHoursBeforeReminder = 2;
  bool _dailyNotifyAtExpiry = true;
  int _otherDaysBeforeReminder = 1;
  bool _tipsNotificationsEnabled = false;
  TimeOfDay _tipsNotificationTime = const TimeOfDay(hour: 9, minute: 0);
  bool _solutionPurchaseEnabled = false;
  int _solutionPurchaseDayOfWeek = 1;
  TimeOfDay _solutionPurchaseTime = const TimeOfDay(hour: 9, minute: 0);
  int _solutionPurchasePeriodMonths = 1;
  bool _lowStockReminderEnabled = false;
  TimeOfDay _lowStockReminderTime = const TimeOfDay(hour: 9, minute: 0);
  late AppLanguagePreference _languagePreference;
  late AppThemePreference _themePreference;

  @override
  void initState() {
    super.initState();
    _languagePreference = widget.localeController.preference;
    _themePreference = widget.themeController.preference;
    _loadSettings();
    _initNotifications();
  }

  Future<void> _loadSettings() async {
    try {
      final timeString = widget.dataService.getNotificationTime();
      final parts = timeString.split(':');

      setState(() {
        _notificationsEnabled = widget.dataService.getNotificationsEnabled();
        _notificationTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts[1]) ?? 0,
        );
        _stockAlertThreshold = widget.dataService.getStockAlertThreshold();
        _dailyHoursBeforeReminder =
            widget.dataService.getDailyHoursBeforeReminder();
        _dailyNotifyAtExpiry = widget.dataService.getDailyNotifyAtExpiry();
        _otherDaysBeforeReminder =
            widget.dataService.getOtherDaysBeforeReminder();
        _tipsNotificationsEnabled =
            widget.dataService.getTipsNotificationsEnabled();
        final tipsParts =
            widget.dataService.getTipsNotificationTime().split(':');
        _tipsNotificationTime = TimeOfDay(
          hour: int.tryParse(tipsParts[0]) ?? 9,
          minute: int.tryParse(tipsParts[1]) ?? 0,
        );
        _solutionPurchaseEnabled =
            widget.dataService.getSolutionPurchaseEnabled();
        _solutionPurchaseDayOfWeek =
            widget.dataService.getSolutionPurchaseDayOfWeek();
        final solParts =
            widget.dataService.getSolutionPurchaseTime().split(':');
        _solutionPurchaseTime = TimeOfDay(
          hour: int.tryParse(solParts[0]) ?? 9,
          minute: int.tryParse(solParts[1]) ?? 0,
        );
        _solutionPurchasePeriodMonths =
            widget.dataService.getSolutionPurchasePeriodMonths();
        _lowStockReminderEnabled =
            widget.dataService.getLowStockReminderEnabled();
        final lowStockParts =
            widget.dataService.getLowStockReminderTime().split(':');
        _lowStockReminderTime = TimeOfDay(
          hour: int.tryParse(lowStockParts[0]) ?? 9,
          minute: int.tryParse(lowStockParts[1]) ?? 0,
        );
      });
    } catch (e) {
      debugPrint('Settings loading error: $e');
    }
  }

  Future<void> _initNotifications() async {
    final l10n = context.l10n;
    try {
      setState(() {
        _notificationStatus = l10n.loadingDots;
        _isLoading = true;
      });

      final notificationService = NotificationService();
      final hasPermission =
          await notificationService.areNotificationsEnabled().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('Permission check timeout');
          return false;
        },
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (hasPermission) {
            _notificationStatus = l10n.notificationsEnabled;
            _notificationsEnabled = true;
          } else {
            _notificationStatus = l10n.notificationsDisabled;
            _notificationsEnabled = false;
          }
        });
      }
    } catch (e) {
      debugPrint('Notification initialization error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _notificationStatus = l10n.notificationsDisabled;
          _notificationsEnabled = false;
        });
      }
    }
  }

  void refreshData() {
    _languagePreference = widget.localeController.preference;
    _themePreference = widget.themeController.preference;
    _loadSettings();
    _initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    // рџџЎ РђР”РђРџРўРР’РќРћРЎРўР¬: РћРїСЂРµРґРµР»СЏРµРј СЂР°Р·РјРµСЂ СЌРєСЂР°РЅР°
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 360;
    final padding = isNarrowScreen ? 12.0 : 16.0;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isNarrowScreen, l10n),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    _buildNotificationsSection(isNarrowScreen),
                    const SizedBox(height: 16),
                    _buildStockSection(isNarrowScreen),
                    const SizedBox(height: 16),
                    _buildLanguageSection(isNarrowScreen, l10n),
                    const SizedBox(height: 16),
                    _buildThemeSection(isNarrowScreen, l10n),
                    const SizedBox(height: 16),
                    _buildDataSection(isNarrowScreen),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isNarrowScreen, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(isNarrowScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsTitle,
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 20 : 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.settingsSubtitle,
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 11 : 12,
                    color:
                        Theme.of(context).colorScheme.onPrimary.withOpacity(0.82),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(bool isNarrowScreen, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.neon.glowColor.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.language,
            title: l10n.language,
            subtitle: l10n.languagePreferenceLabel(_languagePreference),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _showLanguageDialog,
            isNarrowScreen: isNarrowScreen,
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguageDialog() async {
    final l10n = context.l10n;
    final selected = await showDialog<AppLanguagePreference>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLanguagePreference.values.map((preference) {
              return RadioListTile<AppLanguagePreference>(
                value: preference,
                groupValue: _languagePreference,
                title: Text(l10n.languagePreferenceLabel(preference)),
                onChanged: (value) {
                  if (value == null) return;
                  Navigator.pop(dialogContext, value);
                },
              );
            }).toList(),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: const StadiumBorder(),
                alignment: Alignment.center,
              ),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );

    if (selected == null || selected == _languagePreference) return;
    setState(() => _languagePreference = selected);
    await widget.localeController.setPreference(selected);
    await HomeWidgetService.updateLensWidget(widget.dataService);
    widget.onDataChanged();
  }

  Widget _buildThemeSection(bool isNarrowScreen, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.neon.glowColor.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.palette_outlined,
            title: l10n.theme,
            subtitle: l10n.themePreferenceLabel(_themePreference),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: _showThemeDialog,
            isNarrowScreen: isNarrowScreen,
          ),
        ],
      ),
    );
  }

  Future<void> _showThemeDialog() async {
    final l10n = context.l10n;
    final selected = await showDialog<AppThemePreference>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.theme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppThemePreference.values.map((preference) {
              return RadioListTile<AppThemePreference>(
                value: preference,
                groupValue: _themePreference,
                title: Text(l10n.themePreferenceLabel(preference)),
                onChanged: (value) {
                  if (value == null) return;
                  Navigator.pop(dialogContext, value);
                },
              );
            }).toList(),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: const StadiumBorder(),
                alignment: Alignment.center,
              ),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );

    if (selected == null || selected == _themePreference) return;
    setState(() => _themePreference = selected);
    await widget.themeController.setPreference(selected);
  }

  Widget _buildNotificationsSection(bool isNarrowScreen) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.neon.glowColor.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isNarrowScreen ? 16 : 20),
            child: Row(
              children: [
                Container(
                  width: isNarrowScreen ? 40 : 48,
                  height: isNarrowScreen ? 40 : 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      size: isNarrowScreen ? 24 : 28,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                SizedBox(width: isNarrowScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.notifications,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        l10n.notificationsReplacementReminders,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 12 : 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.notifications_active,
            title: l10n.notificationsStatus,
            subtitle: _isLoading ? l10n.loadingDots : _notificationStatus,
            trailing: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _initNotifications,
                    tooltip: l10n.refreshStatus,
                  ),
            onTap: _requestNotificationPermission,
            isNarrowScreen: isNarrowScreen,
          ),
          if (Platform.isAndroid)
            _buildSettingsTile(
              icon: Icons.battery_charging_full,
              title: l10n.allowBackgroundWork,
              subtitle: l10n.allowBackgroundWorkSubtitle,
              trailing: const Icon(Icons.open_in_new),
              onTap: _requestBatteryOptimizationExemption,
              isNarrowScreen: isNarrowScreen,
            ),
          ..._buildLensTypeNotificationTiles(isNarrowScreen),
          _buildTipsNotificationsTile(isNarrowScreen),
          _buildSolutionPurchaseTile(isNarrowScreen),
          _buildLowStockReminderTile(isNarrowScreen),
        ],
      ),
    );
  }

  Widget _buildTipsNotificationsTile(bool isNarrowScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showTipsNotificationTimeDialog,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrowScreen ? 16 : 20,
            vertical: isNarrowScreen ? 14 : 16,
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.primary,
                size: isNarrowScreen ? 20 : 24,
              ),
              SizedBox(width: isNarrowScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.homeTipsTitle,
                      style: TextStyle(
                        fontSize: isNarrowScreen ? 15 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _tipsNotificationsEnabled
                          ? context.l10n.settingsDailyAt(
                              '${_tipsNotificationTime.hour.toString().padLeft(2, '0')}:${_tipsNotificationTime.minute.toString().padLeft(2, '0')}',
                            )
                          : context.l10n.notificationsOff,
                      style: TextStyle(
                        fontSize: isNarrowScreen ? 12 : 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _tipsNotificationsEnabled,
                onChanged: (v) async {
                  setState(() => _tipsNotificationsEnabled = v);
                  await widget.dataService.setTipsNotificationsEnabled(v);
                  await _applyTipsSchedule();
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTipsNotificationTimeDialog() async {
    TimeOfDay selected = _tipsNotificationTime;
    final result = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(context.l10n.settingsTipTime),
              content: ListTile(
                title: Text(context.l10n.settingsNotificationTime),
                subtitle: Text(
                  '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: selected,
                  );
                  if (t != null) setDialogState(() => selected = t);
                },
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    shape: const StadiumBorder(),
                    alignment: Alignment.center,
                  ),
                  child: Text(context.l10n.cancel),
                ),
                PrimaryGradientButton(
                  onPressed: () => Navigator.pop(context, selected),
                  child: Text(context.l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null && result != _tipsNotificationTime && mounted) {
      setState(() => _tipsNotificationTime = result);
      await widget.dataService.setTipsNotificationTime(
        '${result.hour.toString().padLeft(2, '0')}:${result.minute.toString().padLeft(2, '0')}',
      );
      await _applyTipsSchedule();
    }
  }

  Future<void> _applyTipsSchedule() async {
    final notificationService = NotificationService();
    final lensInfo = widget.dataService.getLensInfo();
    await notificationService.scheduleDailyTipNotifications(
      enabled: widget.dataService.getTipsNotificationsEnabled(),
      timeString: widget.dataService.getTipsNotificationTime(),
      lensType: lensInfo.type,
    );
    widget.onDataChanged();
  }

  String _weekdayName(int weekday) {
    final locale = intlDateFormattingLocale(Localizations.localeOf(context));
    final date = DateTime(2024, 1, weekday);
    return DateFormat('EEEE', locale).format(date);
  }

  String _periodLabel(int months) {
    return context.l10n.settingsEveryMonths(months);
  }

  Widget _buildSolutionPurchaseTile(bool isNarrowScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    final subtitle = _solutionPurchaseEnabled
        ? '${_weekdayName(_solutionPurchaseDayOfWeek)}, '
            '${_solutionPurchaseTime.hour.toString().padLeft(2, '0')}:${_solutionPurchaseTime.minute.toString().padLeft(2, '0')}, '
            '${_periodLabel(_solutionPurchasePeriodMonths)}'
        : context.l10n.notificationsOff;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _solutionPurchaseEnabled ? _showSolutionPurchaseDialog : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrowScreen ? 16 : 20,
            vertical: isNarrowScreen ? 14 : 16,
          ),
          child: Row(
            children: [
              Icon(
                Icons.water_drop_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: isNarrowScreen ? 20 : 24,
              ),
              SizedBox(width: isNarrowScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.notificationSolutionTitle,
                      style: TextStyle(
                        fontSize: isNarrowScreen ? 15 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isNarrowScreen ? 12 : 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Switch(
                value: _solutionPurchaseEnabled,
                onChanged: (v) async {
                  if (v) {
                    await _showSolutionPurchaseDialog();
                  } else {
                    setState(() => _solutionPurchaseEnabled = false);
                    await widget.dataService.setSolutionPurchaseEnabled(false);
                    await _applySolutionPurchaseSchedule();
                  }
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showSolutionPurchaseDialog() async {
    int dayOfWeek = _solutionPurchaseDayOfWeek;
    TimeOfDay time = _solutionPurchaseTime;
    int periodMonths = _solutionPurchasePeriodMonths;

    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 360;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(context.l10n.settingsSolutionPurchaseReminder),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.settingsWeekday,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isNarrowScreen ? 14 : 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: dayOfWeek,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(7, (i) => i + 1).map((d) {
                        return DropdownMenuItem(
                          value: d,
                          child: Text(_weekdayName(d)),
                        );
                      }).toList(),
                      onChanged: (v) =>
                          setDialogState(() => dayOfWeek = v ?? 1),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.settingsTime,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isNarrowScreen ? 14 : 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: Text(
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: time,
                        );
                        if (t != null) setDialogState(() => time = t);
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.settingsPeriod,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isNarrowScreen ? 14 : 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: periodMonths,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(5, (i) => i + 1).map((m) {
                        return DropdownMenuItem(
                          value: m,
                          child: Text(_periodLabel(m)),
                        );
                      }).toList(),
                      onChanged: (v) =>
                          setDialogState(() => periodMonths = v ?? 1),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    shape: const StadiumBorder(),
                    alignment: Alignment.center,
                  ),
                  child: Text(context.l10n.cancel),
                ),
                PrimaryGradientButton(
                  onPressed: () => Navigator.pop(context, {
                    'dayOfWeek': dayOfWeek,
                    'time': time,
                    'periodMonths': periodMonths,
                  }),
                  child: Text(context.l10n.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      final newDay = result['dayOfWeek'] as int;
      final newTime = result['time'] as TimeOfDay;
      final newPeriod = result['periodMonths'] as int;
      setState(() {
        _solutionPurchaseEnabled = true;
        _solutionPurchaseDayOfWeek = newDay;
        _solutionPurchaseTime = newTime;
        _solutionPurchasePeriodMonths = newPeriod;
      });
      await widget.dataService.setSolutionPurchaseEnabled(true);
      await widget.dataService.setSolutionPurchaseDayOfWeek(newDay);
      await widget.dataService.setSolutionPurchaseTime(
        '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}',
      );
      await widget.dataService.setSolutionPurchasePeriodMonths(newPeriod);
      await _applySolutionPurchaseSchedule();
      return true;
    }
    return false;
  }

  Future<void> _applySolutionPurchaseSchedule() async {
    final notificationService = NotificationService();
    await notificationService.scheduleSolutionPurchaseNotification(
      enabled: widget.dataService.getSolutionPurchaseEnabled(),
      dayOfWeek: widget.dataService.getSolutionPurchaseDayOfWeek(),
      timeString: widget.dataService.getSolutionPurchaseTime(),
      periodMonths: widget.dataService.getSolutionPurchasePeriodMonths(),
    );
    widget.onDataChanged();
  }

  Widget _buildLowStockReminderTile(bool isNarrowScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    final subtitle = _lowStockReminderEnabled
        ? context.l10n.settingsDailyAtLowStock(
            '${_lowStockReminderTime.hour.toString().padLeft(2, '0')}:${_lowStockReminderTime.minute.toString().padLeft(2, '0')}',
          )
        : context.l10n.notificationsOff;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            _lowStockReminderEnabled ? _showLowStockReminderTimeDialog : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrowScreen ? 16 : 20,
            vertical: isNarrowScreen ? 14 : 16,
          ),
          child: Row(
            children: [
              Icon(
                Icons.inventory_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: isNarrowScreen ? 20 : 24,
              ),
              SizedBox(width: isNarrowScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.notificationLowStockTitle,
                      style: TextStyle(
                        fontSize: isNarrowScreen ? 15 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isNarrowScreen ? 12 : 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Switch(
                value: _lowStockReminderEnabled,
                onChanged: (v) async {
                  if (v) {
                    final result = await _showLowStockReminderTimeDialog();
                    if (result != null && mounted) {
                      setState(() => _lowStockReminderEnabled = true);
                      await widget.dataService.setLowStockReminderEnabled(true);
                      await _applyLowStockReminderSchedule();
                    }
                  } else {
                    setState(() => _lowStockReminderEnabled = false);
                    await widget.dataService.setLowStockReminderEnabled(false);
                    await _applyLowStockReminderSchedule();
                  }
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showLowStockReminderTimeDialog() async {
    TimeOfDay selected = _lowStockReminderTime;
    final result = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(context.l10n.notificationLowStockTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.settingsLowStockReminderHelp,
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(context.l10n.settingsNotificationTime),
                    subtitle: Text(
                      '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: selected,
                      );
                      if (t != null) setDialogState(() => selected = t);
                    },
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    shape: const StadiumBorder(),
                    alignment: Alignment.center,
                  ),
                  child: Text(context.l10n.cancel),
                ),
                PrimaryGradientButton(
                  onPressed: () => Navigator.pop(context, selected),
                  child: Text(context.l10n.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      setState(() => _lowStockReminderTime = result);
      await widget.dataService.setLowStockReminderTime(
        '${result.hour.toString().padLeft(2, '0')}:${result.minute.toString().padLeft(2, '0')}',
      );
      await _applyLowStockReminderSchedule();
      return true;
    }
    return false;
  }

  void _updateLowStockReminderState() {
    setState(() {
      _lowStockReminderEnabled =
          widget.dataService.getLowStockReminderEnabled();
      final parts = widget.dataService.getLowStockReminderTime().split(':');
      _lowStockReminderTime = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 9,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    });
  }

  Future<void> _applyLowStockReminderSchedule() async {
    final notificationService = NotificationService();
    await notificationService.scheduleLowStockReminder(widget.dataService);
    widget.onDataChanged();
  }

  Widget _buildStockSection(bool isNarrowScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.neon.glowColor.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isNarrowScreen ? 16 : 20),
            child: Row(
              children: [
                Container(
                  width: isNarrowScreen ? 40 : 48,
                  height: isNarrowScreen ? 40 : 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.secondaryContainer,
                        colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: isNarrowScreen ? 24 : 28,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                SizedBox(width: isNarrowScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.settingsLensStock,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        context.l10n.settingsAlertThreshold,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 12 : 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.warning_amber,
            title: context.l10n.settingsAlertThreshold,
            subtitle:
                '$_stockAlertThreshold ${context.l10n.pairWord(_stockAlertThreshold)}',
            trailing: const Icon(Icons.chevron_right),
            onTap: _showStockThresholdDialog,
            isNarrowScreen: isNarrowScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection(bool isNarrowScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.neon.glowColor.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isNarrowScreen ? 16 : 20),
            child: Row(
              children: [
                Container(
                  width: isNarrowScreen ? 40 : 48,
                  height: isNarrowScreen ? 40 : 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.tertiaryContainer,
                        colorScheme.tertiary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.folder_outlined,
                      size: isNarrowScreen ? 24 : 28,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                SizedBox(width: isNarrowScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.settingsData,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        context.l10n.settingsDataManagement,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 12 : 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.delete_forever,
            title: context.l10n.profileDeleteHistoryTitle,
            subtitle: context.l10n.settingsDeleteAllHistory,
            trailing: const Icon(Icons.chevron_right),
            color: Theme.of(context).colorScheme.error,
            onTap: _showClearDataDialog,
            titleColor: Theme.of(context).colorScheme.error,
            isNarrowScreen: isNarrowScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
    required bool isNarrowScreen,
    Color? titleColor,
    Color? color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrowScreen ? 16 : 20,
            vertical: isNarrowScreen ? 14 : 16,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: color ?? titleColor ?? Theme.of(context).colorScheme.primary,
                size: isNarrowScreen ? 20 : 24,
              ),
              SizedBox(width: isNarrowScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isNarrowScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isNarrowScreen ? 12 : 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLensTypeNotificationTiles(bool isNarrowScreen) {
    final lensType = widget.dataService.getLensInfo().type;

    if (lensType == LensType.daily) {
      return [
        _buildSettingsTile(
          icon: Icons.timer,
          title: context.l10n.settingsHoursBeforeEndTitle,
          subtitle:
              '$_dailyHoursBeforeReminder ${context.l10n.hourWord(_dailyHoursBeforeReminder)}',
          trailing: const Icon(Icons.chevron_right),
          onTap: _showDailyHoursBeforeDialog,
          isNarrowScreen: isNarrowScreen,
        ),
        _buildSettingsTile(
          icon: Icons.notifications,
          title: context.l10n.settingsAtExpiry,
          subtitle: _dailyNotifyAtExpiry
              ? context.l10n.notificationsEnabled
              : context.l10n.notificationsOff,
          trailing: Switch(
            value: _dailyNotifyAtExpiry,
            onChanged: (v) async {
              setState(() => _dailyNotifyAtExpiry = v);
              await widget.dataService.setDailyNotifyAtExpiry(v);
              widget.onDataChanged();
              _rescheduleNotificationsAfterTimeChange();
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          onTap: null,
          isNarrowScreen: isNarrowScreen,
        ),
      ];
    }

    return [
      _buildSettingsTile(
        icon: Icons.calendar_today,
        title: context.l10n.settingsDaysBeforeReplacement,
        subtitle:
            '$_otherDaysBeforeReminder ${context.l10n.dayWord(_otherDaysBeforeReminder)}',
        trailing: const Icon(Icons.chevron_right),
        onTap: _showOtherDaysBeforeDialog,
        isNarrowScreen: isNarrowScreen,
      ),
      _buildSettingsTile(
        icon: Icons.schedule,
        title: context.l10n.settingsReplacementDayTime,
        subtitle:
            '${_notificationTime.hour.toString().padLeft(2, '0')}:${_notificationTime.minute.toString().padLeft(2, '0')}',
        trailing: const Icon(Icons.chevron_right),
        onTap: _showNotificationTimeDialog,
        isNarrowScreen: isNarrowScreen,
      ),
    ];
  }

  Future<void> _showDailyHoursBeforeDialog() async {
    int? newValue = _dailyHoursBeforeReminder;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(context.l10n.settingsHoursBeforeEndTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.settingsHoursBeforeEndHelp),
            const SizedBox(height: 16),
            ...List.generate(6, (index) {
              final value = index + 1;
              return RadioListTile<int>(
                title: Text('$value ${context.l10n.hourWord(value)}'),
                value: value,
                groupValue: newValue,
                onChanged: (val) {
                  newValue = val;
                  (context as Element).markNeedsBuild();
                },
              );
            }),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.cancel),
          ),
          PrimaryGradientButton(
            onPressed: () async {
              if (newValue != null) {
                setState(() => _dailyHoursBeforeReminder = newValue!);
                await widget.dataService.setDailyHoursBeforeReminder(newValue!);
                widget.onDataChanged();
                if (context.mounted) {
                  Navigator.pop(context);
                  _rescheduleNotificationsAfterTimeChange();
                }
              }
            },
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _showOtherDaysBeforeDialog() async {
    int? newValue = _otherDaysBeforeReminder;
    const options = [1, 2, 3, 7];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(context.l10n.settingsDaysBeforeReplacement),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.settingsDaysBeforeReplacementHelp),
            const SizedBox(height: 16),
            ...options.map((value) => RadioListTile<int>(
                  title: Text('$value ${context.l10n.dayWord(value)}'),
                  value: value,
                  groupValue: newValue,
                  onChanged: (val) {
                    newValue = val;
                    (context as Element).markNeedsBuild();
                  },
                )),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.cancel),
          ),
          PrimaryGradientButton(
            onPressed: () async {
              if (newValue != null) {
                setState(() => _otherDaysBeforeReminder = newValue!);
                await widget.dataService.setOtherDaysBeforeReminder(newValue!);
                widget.onDataChanged();
                if (context.mounted) {
                  Navigator.pop(context);
                  _rescheduleNotificationsAfterTimeChange();
                }
              }
            },
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _requestNotificationPermission() async {
    try {
      setState(() {
        _notificationStatus = context.l10n.loadingDots;
      });

      final notificationService = NotificationService();
      final granted =
          await notificationService.checkAndRequestPermission(context);

      if (mounted) {
        await _initNotifications();

        if (granted) {
          await notificationService.requestExactAlarmsPermissionIfNeeded();
        }
      }
    } catch (e) {
      debugPrint('Permission request error: $e');
      if (mounted) {
        setState(() {
          _notificationStatus = context.l10n.error;
        });
      }
    }
  }

  Future<void> _requestBatteryOptimizationExemption() async {
    if (!Platform.isAndroid) return;
    try {
      final status = await Permission.ignoreBatteryOptimizations.status;
      if (status.isGranted) {
        return;
      }
      final result = await Permission.ignoreBatteryOptimizations.request();
      if (mounted) {
        if (!result.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.l10n.settingsBatteryNoRestrictionsHint,
              ),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Battery optimization request error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.l10n.error}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _showNotificationTimeDialog() async {
    TimeOfDay selectedTime = _notificationTime;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(context.l10n.settingsNotificationTime),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.settingsReplacementNotificationTimeHelp,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      selectedTime = time;
                      setDialogState(() {});
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  shape: const StadiumBorder(),
                  alignment: Alignment.center,
                ),
                child: Text(context.l10n.cancel),
              ),
              PrimaryGradientButton(
                onPressed: () async {
                  setState(() {
                    _notificationTime = selectedTime;
                  });

                  final timeString =
                      '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                  await widget.dataService.setNotificationTime(timeString);
                  widget.onDataChanged();

                  if (context.mounted) {
                    Navigator.pop(context);
                    _rescheduleNotificationsAfterTimeChange();
                  }
                },
                child: Text(context.l10n.save),
              ),
            ],
          );
        },
      ),
    );
  }

  // рџџЎ MISSING-003: РџРµСЂРµРїР»Р°РЅРёСЂРѕРІР°РЅРёРµ СѓРІРµРґРѕРјР»РµРЅРёР№ РїСЂРё РёР·РјРµРЅРµРЅРёРё РІСЂРµРјРµРЅРё
  Future<void> _rescheduleNotificationsAfterTimeChange() async {
    try {
      final notificationService = NotificationService();
      final hasPermission = await notificationService.areNotificationsEnabled();

      if (!hasPermission) return;

      await notificationService.requestExactAlarmsPermissionIfNeeded();

      final activeCycle = widget.dataService.getActiveCycle();
      if (activeCycle == null) return;

      final lensInfo = widget.dataService.getLensInfo();
      final daysToReplace = lensInfo.type.days;
      final nextReplacementDate =
          activeCycle.startDate.add(Duration(days: daysToReplace));

      // РћС‚РјРµРЅСЏРµРј СЃС‚Р°СЂС‹Рµ СѓРІРµРґРѕРјР»РµРЅРёСЏ (РІСЃРµ РІР°СЂРёР°РЅС‚С‹)
      await notificationService.cancelLensNotifications('current_lens');
      await notificationService.cancelLensNotifications('current_lens_day');
      await notificationService.cancelLensNotifications('current_lens_before');
      await notificationService.cancelLensNotifications('current_lens_expiry');

      final hoursBefore = widget.dataService.getDailyHoursBeforeReminder();
      final notifyAtExpiry = widget.dataService.getDailyNotifyAtExpiry();
      final otherDaysBefore = widget.dataService.getOtherDaysBeforeReminder();
      final timeStr = widget.dataService.getNotificationTime();
      final parts = timeStr.split(':');
      final notifTime = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 8,
        minute: int.tryParse(parts[1]) ?? 0,
      );

      if (lensInfo.type.days == 1) {
        // РћРґРЅРѕРґРЅРµРІРЅС‹Рµ: Р·Р° N hourРѕРІ РґРѕ РєРѕРЅС†Р° (14С‡) Рё РІ РјРѕРјРµРЅС‚ РёСЃС‚РµС‡РµРЅРёСЏ
        final reminderBefore =
            activeCycle.startDate.add(Duration(hours: 14 - hoursBefore));
        if (reminderBefore.isAfter(DateTime.now())) {
          await notificationService.scheduleLensReplacementNotification(
            lensId: 'current_lens_before',
            lensName: lensInfo.type.label,
            replacementDate: reminderBefore,
            notificationTime: TimeOfDay.fromDateTime(reminderBefore),
            customMessage: context.l10n.mainTimeMessageHoursBefore(hoursBefore),
          );
        }

        if (notifyAtExpiry) {
          final reminderExpiry =
              activeCycle.startDate.add(const Duration(hours: 14));
          if (reminderExpiry.isAfter(DateTime.now())) {
            await notificationService.scheduleLensReplacementNotification(
              lensId: 'current_lens_expiry',
              lensName: lensInfo.type.label,
              replacementDate: reminderExpiry,
              notificationTime: TimeOfDay.fromDateTime(reminderExpiry),
              notificationId: 1002,
              customMessage: context.l10n.mainTimeMessageExpiry,
            );
          }
        }
      } else {
        // РћСЃС‚Р°Р»СЊРЅС‹Рµ С‚РёРїС‹: Р·Р° N days Рё РІ day Р·Р°РјРµРЅС‹
        final reminderDate =
            nextReplacementDate.subtract(Duration(days: otherDaysBefore));

        if (reminderDate.isAfter(DateTime.now())) {
          final dayWord = otherDaysBefore == 1
              ? context.l10n.mainTomorrow
              : context.l10n.mainInDays(otherDaysBefore);
          await notificationService.scheduleLensReplacementNotification(
            lensId: 'current_lens',
            lensName: lensInfo.type.label,
            replacementDate: reminderDate,
            notificationTime: notifTime,
            customMessage: context.l10n.mainTimeToReplaceMessage(dayWord),
          );
        }

        if (nextReplacementDate.isAfter(DateTime.now())) {
          await notificationService.scheduleLensReplacementNotification(
            lensId: 'current_lens_day',
            lensName: lensInfo.type.label,
            replacementDate: nextReplacementDate,
            notificationTime: notifTime,
            notificationId: 1001,
          );
        }
      }

      debugPrint('Notifications rescheduled to new time');
    } catch (e) {
      debugPrint('Notification reschedule error: $e');
    }
  }

  Future<void> _showStockThresholdDialog() async {
    int? newThreshold = _stockAlertThreshold;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(context.l10n.settingsAlertThreshold),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.settingsWarnWhenStockDrops),
            const SizedBox(height: 20),
            ...List.generate(5, (index) {
              final value = index + 1;
              return RadioListTile<int>(
                title: Text('$value ${context.l10n.pairWord(value)}'),
                value: value,
                groupValue: newThreshold,
                onChanged: (val) {
                  newThreshold = val;
                  (context as Element).markNeedsBuild();
                },
              );
            }),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.cancel),
          ),
          PrimaryGradientButton(
            onPressed: () async {
              if (newThreshold != null) {
                setState(() {
                  _stockAlertThreshold = newThreshold!;
                });

                await widget.dataService.setStockAlertThreshold(newThreshold!);
                widget.onDataChanged();

                // рџџЎ MISSING-001: РџСЂРѕРІРµСЂРєР° С‚РµРєСѓС‰РµРіРѕ Р·Р°РїР°СЃР° РїРѕСЃР»Рµ РёР·РјРµРЅРµРЅРёСЏ РїРѕСЂРѕРіР°
                final currentStock = widget.dataService.getCurrentStock();
                if (context.mounted) {
                  Navigator.pop(context);

                  // рџџЎ MISSING-001: РџСЂРµРґСѓРїСЂРµР¶РґРµРЅРёРµ РµСЃР»Рё С‚РµРєСѓС‰РёР№ Р·Р°РїР°СЃ РЅРёР¶Рµ РїРѕСЂРѕРіР°
                  if (currentStock <= newThreshold!) {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.l10n.settingsStockBelowThreshold(
                                currentStock,
                                context.l10n.pairWord(currentStock),
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      }
                    });
                  }
                }
              }
            },
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDataDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.l10n.profileDeleteHistoryTitle,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        content: Text(context.l10n.settingsClearHistoryWarning),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.profileDeleteHistoryTitle),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // рџ”ґ FIX BUG-003: РћС‚РјРµРЅСЏРµРј Р’РЎР• СѓРІРµРґРѕРјР»РµРЅРёСЏ РїРµСЂРµРґ РѕС‡РёСЃС‚РєРѕР№
        final notificationService = NotificationService();
        await notificationService.cancelAllNotifications();

        // РћС‡РёС‰Р°РµРј РёСЃС‚РѕСЂРёСЋ Рё РґР°РЅРЅС‹Рµ (Р°РєРєР°СѓРЅС‚ СЃРѕС…СЂР°РЅСЏРµС‚СЃСЏ)
        await widget.dataService.clearUserData();

        // РћР±РЅРѕРІР»СЏРµРј РІРёРґР¶РµС‚ (РїРѕРєР°Р¶РµС‚ В«вЂ”В»)
        HomeWidgetService.updateLensWidget(widget.dataService);

        widget.onDataChanged();

        if (mounted) {
          // РџРµСЂРµР·Р°РіСЂСѓР¶Р°РµРј РЅР°СЃС‚СЂРѕР№РєРё (РІРµСЂРЅСѓС‚СЃСЏ Рє Р·РЅР°С‡РµРЅРёСЏРј РїРѕ СѓРјРѕР»С‡Р°РЅРёСЋ)
          await _loadSettings();
          await _initNotifications();
        }
      } catch (e) {
        if (mounted) {
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
}




