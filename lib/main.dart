import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'l10n/domain_localization_extensions.dart';
import 'l10n/l10n_extensions.dart';
import 'services/lens_data_service.dart';
import 'services/auth_service.dart';
import 'services/sync_service.dart';
import 'models/lens_data.dart' as models;
import 'models/lens_data.dart' show Symptom;
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/notification_service.dart';
import 'services/app_navigation.dart';
import 'services/app_locale_controller.dart';
import 'services/app_theme_controller.dart';
import 'services/home_widget_service.dart';
import 'theme/app_theme.dart';
import 'theme/neon_theme.dart';
import 'widgets/primary_gradient_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ru_RU');
  await initializeDateFormatting('en_US');

  // РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ Firebase (РѕРїС†РёРѕРЅР°Р»СЊРЅРѕ)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AuthService().setFirebaseReady(true);
  } catch (e) {
    debugPrint('Firebase is not configured: $e');
    AuthService().setFirebaseReady(false);
  }

  // РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ СЃРµСЂРІРёСЃР° СѓРІРµРґРѕРјР»РµРЅРёР№
  await NotificationService().initialize();

  final dataService = await LensDataService.create();
  final localeController = await AppLocaleController.create(dataService);
  final themeController = await AppThemeController.create();

  SystemChrome.setSystemUIOverlayStyle(
    _buildSystemUiOverlayStyle(themeController.effectiveBrightness),
  );

  // рџ”ґ FIX BUG-002: РњРёРіСЂР°С†РёСЏ РґР°РЅРЅС‹С… РІ РЅРѕРІСѓСЋ СЃРёСЃС‚РµРјСѓ С†РёРєР»РѕРІ
  await dataService.migrateToCycleSystem();

  // рџ”ґ FIX BUG-002: РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ РїРµСЂРІРѕРіРѕ С†РёРєР»Р° РїСЂРё РїРµСЂРІРѕРј Р·Р°РїСѓСЃРєРµ
  await dataService.initializeFirstCycle();

  // РЈСЃС‚Р°РЅРѕРІРёС‚СЊ dataService РІ AppNavigation РґР»СЏ РёСЃРїРѕР»СЊР·РѕРІР°РЅРёСЏ РІ РЅР°РІРёРіР°С†РёРё
  AppNavigation.dataService = dataService;
  AppNavigation.localeController = localeController;
  AppNavigation.themeController = themeController;
  NotificationService.setLocaleResolver(() => localeController.resolvedLocale);

  // РћР±РЅРѕРІРёС‚СЊ РІРёРґР¶РµС‚ РЅР° СЂР°Р±РѕС‡РµРј СЃС‚РѕР»Рµ (Android)
  HomeWidgetService.updateLensWidget(dataService);

  runApp(
    MyApp(
      dataService: dataService,
      localeController: localeController,
      themeController: themeController,
    ),
  );
}

SystemUiOverlayStyle _buildSystemUiOverlayStyle(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final darkTokens = NeonThemeTokens.dark();
  final lightTokens = NeonThemeTokens.light();
  return (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
      .copyWith(
    statusBarColor: isDark ? darkTokens.surface : lightTokens.surface,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: isDark
        ? darkTokens.surfaceContainerLowest
        : lightTokens.surfaceContainerLowest,
    systemNavigationBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
  );
}

class MyApp extends StatelessWidget {
  final LensDataService dataService;
  final AppLocaleController localeController;
  final AppThemeController themeController;

  const MyApp({
    Key? key,
    required this.dataService,
    required this.localeController,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightTheme = AppTheme.light();
    final darkTheme = AppTheme.dark();
    return ListenableBuilder(
      listenable: Listenable.merge([localeController, themeController]),
      builder: (context, child) {
        final statusBarStyle =
            _buildSystemUiOverlayStyle(themeController.effectiveBrightness);
        SystemChrome.setSystemUIOverlayStyle(statusBarStyle);

        return MaterialApp(
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: false,
          theme: lightTheme.copyWith(
            appBarTheme: lightTheme.appBarTheme.copyWith(
              systemOverlayStyle: statusBarStyle,
            ),
          ),
          darkTheme: darkTheme.copyWith(
            appBarTheme: darkTheme.appBarTheme.copyWith(
              systemOverlayStyle: statusBarStyle,
            ),
          ),
          themeMode: themeController.themeMode,
          locale: localeController.materialLocale,
          supportedLocales: const [
            Locale('ru'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            return AppLocaleController.resolveSystemLocale(deviceLocale);
          },
          builder: (context, child) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: statusBarStyle,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: _AppInitializer(
            dataService: dataService,
            localeController: localeController,
            themeController: themeController,
          ),
        );
      },
    );
  }
}

/// РћРїСЂРµРґРµР»СЏРµС‚ РЅР°С‡Р°Р»СЊРЅС‹Р№ СЌРєСЂР°РЅ: РѕРЅР±РѕСЂРґРёРЅРі РёР»Рё РѕСЃРЅРѕРІРЅРѕРµ РїСЂРёР»РѕР¶РµРЅРёРµ
class _AppInitializer extends StatefulWidget {
  final LensDataService dataService;
  final AppLocaleController localeController;
  final AppThemeController themeController;

  const _AppInitializer({
    required this.dataService,
    required this.localeController,
    required this.themeController,
  });

  @override
  State<_AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<_AppInitializer> {
  bool _initialized = false;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final completed = await AuthService().isOnboardingCompleted();
    if (mounted) {
      setState(() {
        _showOnboarding = !completed;
        _initialized = true;
      });
    }
  }

  void _onOnboardingComplete() {
    setState(() => _showOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      final neon = context.neon;
      return Scaffold(
        backgroundColor: neon.surface,
        body: Center(
          child: CircularProgressIndicator(
            color: neon.primary,
          ),
        ),
      );
    }
    if (_showOnboarding) {
      return OnboardingScreen(
        dataService: widget.dataService,
        onComplete: _onOnboardingComplete,
      );
    }
    return MainNavigationScreen(
      dataService: widget.dataService,
      localeController: widget.localeController,
      themeController: widget.themeController,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final LensDataService dataService;
  final AppLocaleController localeController;
  final AppThemeController themeController;

  const MainNavigationScreen({
    Key? key,
    required this.dataService,
    required this.localeController,
    required this.themeController,
  }) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final GlobalKey _homeScreenKey = GlobalKey();
  final GlobalKey _historyScreenKey = GlobalKey();
  final GlobalKey _profileScreenKey = GlobalKey();
  final GlobalKey _settingsScreenKey = GlobalKey();

  StreamSubscription<Map<String, dynamic>>? _notificationSubscription;

  Timer? _syncDebounceTimer;
  Timer? _periodicSyncTimer;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _schedulePeriodicSync();
    _doInitialSync();

    // РќР°СЃС‚СЂРѕР№РєР° callback РґР»СЏ РЅР°РІРёРіР°С†РёРё РёР· СѓРІРµРґРѕРјР»РµРЅРёР№
    NotificationService.setNavigationCallback((action, payload) {
      if (mounted) {
        AppNavigation.handleNotificationNavigation(context, action, payload);
      }
    });

    // РџСЂРѕРІРµСЂРєР° РѕС‚Р»РѕР¶РµРЅРЅС‹С… РґРµР№СЃС‚РІРёР№ РёР· СѓРІРµРґРѕРјР»РµРЅРёР№
    _checkPendingNotificationActions();

    // РџРѕРґРїРёСЃРєР° РЅР° РєР»РёРєРё РїРѕ СѓРІРµРґРѕРјР»РµРЅРёСЏРј
    _setupNotificationListener();

    // РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ СЌРєСЂР°РЅРѕРІ
    _screens = [
      HomeScreen(
        key: _homeScreenKey,
        dataService: widget.dataService,
        onDataChanged: _refreshAllScreens,
        onCheckNotifications: _checkNotificationPermission,
        onPutOnLenses: () => _replaceLenses(DateTime.now()),
        onAddEntryForDate: (calendarContext, date) {
          Navigator.pop(calendarContext);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _showAddEntryModal(context, selectedDate: date);
          });
        },
        onRequestAddForDate: (date) {
          _showAddEntryModal(context, selectedDate: date);
        },
      ),
      HistoryScreen(
        key: _historyScreenKey,
        dataService: widget.dataService,
      ),
      ProfileScreen(
        key: _profileScreenKey,
        dataService: widget.dataService,
        onDataChanged: _refreshAllScreens,
      ),
      SettingsScreen(
        key: _settingsScreenKey,
        dataService: widget.dataService,
        localeController: widget.localeController,
        themeController: widget.themeController,
        onDataChanged: _refreshSettings,
      ),
    ];

    // Р—Р°РґРµСЂР¶РєР° РґР»СЏ РїСЂРѕРІРµСЂРєРё СЂР°Р·СЂРµС€РµРЅРёР№ РЅР° СѓРІРµРґРѕРјР»РµРЅРёСЏ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNotificationPermissionOnStart();
      _scheduleLensNotifications();
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _syncDebounceTimer?.cancel();
    _periodicSyncTimer?.cancel();
    super.dispose();
  }

  /// РђРІС‚РѕСЃРёРЅС…СЂРѕРЅРёР·Р°С†РёСЏ РїСЂРё Р·Р°РїСѓСЃРєРµ (Р·Р°РіСЂСѓР·РєР° РґР°РЅРЅС‹С… РёР· РѕР±Р»Р°РєР°)
  Future<void> _doInitialSync() async {
    if (!SyncService().canSync) return;
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final err = await SyncService().sync(widget.dataService);
    if (err == null && mounted) {
      _refreshAllScreens();
    }
  }

  /// PeriodРёС‡РµСЃРєР°СЏ СЃРёРЅС…СЂРѕРЅРёР·Р°С†РёСЏ (РєР°Р¶РґС‹Рµ 5 РјРёРЅСѓС‚)
  void _schedulePeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (!mounted) return;
      _doAutoSync();
    });
  }

  /// РЎРёРЅС…СЂРѕРЅРёР·Р°С†РёСЏ РїСЂРё РёР·РјРµРЅРµРЅРёРё РґР°РЅРЅС‹С… (СЃ Р·Р°РґРµСЂР¶РєРѕР№ 2 СЃРµРє)
  void _scheduleAutoSync() {
    if (!SyncService().canSync) return;
    _syncDebounceTimer?.cancel();
    _syncDebounceTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      _doAutoSync();
    });
  }

  Future<void> _doAutoSync() async {
    if (!SyncService().canSync) return;
    final err = await SyncService().sync(widget.dataService);
    if (err == null && mounted) {
      _refreshAllScreens();
    }
  }

  void _setupNotificationListener() {
    final notificationService = NotificationService();
    _notificationSubscription =
        notificationService.onNotificationClick.listen((payload) {
      if (mounted) {
        final action = payload['action'] ?? 'open_home';
        AppNavigation.handleNotificationNavigation(context, action, payload);
      }
    });
  }

  Future<void> _checkPendingNotificationActions() async {
    final notificationService = NotificationService();
    final pendingAction =
        await notificationService.getPendingNotificationAction();

    if (pendingAction != null && mounted) {
      final action = pendingAction['action'];
      final payload = pendingAction['payload'];
      AppNavigation.handleNotificationNavigation(context, action, payload);
    }
  }

  Future<void> _checkNotificationPermissionOnStart() async {
    final notificationService = NotificationService();
    final hasPermission = await notificationService.areNotificationsEnabled();

    if (!hasPermission) {
      // РќРµ Р·Р°РїСЂР°С€РёРІР°РµРј СЃСЂР°Р·Сѓ РїСЂРё Р·Р°РїСѓСЃРєРµ, Р° С‚РѕР»СЊРєРѕ РїСЂРё РїРµСЂРІРѕРј РґРµР№СЃС‚РІРёРё
      // РёР»Рё С‡РµСЂРµР· 5 СЃРµРєСѓРЅРґ РїРѕСЃР»Рµ Р·Р°РїСѓСЃРєР°
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _selectedIndex == 0) {
          _checkNotificationPermission();
        }
      });
    }
  }

  Future<void> _checkNotificationPermission() async {
    final notificationService = NotificationService();
    await notificationService.checkAndRequestPermission(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      (_homeScreenKey.currentState as dynamic)?.loadData();
      HomeWidgetService.updateLensWidget(widget.dataService);
    } else if (index == 1) {
      (_historyScreenKey.currentState as dynamic)?.refreshData();
    } else if (index == 2) {
      (_profileScreenKey.currentState as dynamic)?.refreshData();
    } else if (index == 3) {
      (_settingsScreenKey.currentState as dynamic)?.refreshData();
    }
  }

  void _refreshAllScreens() {
    (_homeScreenKey.currentState as dynamic)?.loadData();
    (_historyScreenKey.currentState as dynamic)?.refreshData();
    (_profileScreenKey.currentState as dynamic)?.refreshData();
    (_settingsScreenKey.currentState as dynamic)?.refreshData();
    HomeWidgetService.updateLensWidget(widget.dataService);
    _scheduleLensNotifications();
    _scheduleAutoSync();
    setState(() {});
  }

  void _refreshProfile() {
    (_profileScreenKey.currentState as dynamic)?.refreshData();
    setState(() {});
  }

  void _refreshSettings() {
    (_settingsScreenKey.currentState as dynamic)?.refreshData();
    HomeWidgetService.updateLensWidget(widget.dataService);
    _scheduleAutoSync();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // рџџЎ РђР”РђРџРўРР’РќРћРЎРўР¬: РћРїСЂРµРґРµР»СЏРµРј С€РёСЂРёРЅСѓ СЌРєСЂР°РЅР°
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 360;
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final neon = context.neon;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: _selectedIndex == 0
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(neon.radiusPill),
                gradient: neon.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: neon.glowColor,
                    blurRadius: neon.blurLg * 1.6,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () => _showAddEntryModal(context),
                backgroundColor: Colors.transparent,
                elevation: 0,
                highlightElevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                shape: const StadiumBorder(),
                child: Icon(Icons.add, size: 32, color: neon.onPrimary),
              ),
            )
          : null,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.92),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: neon.glowColor.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: colorScheme.primary,
              unselectedItemColor: colorScheme.onSurfaceVariant,
              selectedFontSize: isNarrowScreen ? 10 : 11,
              unselectedFontSize: isNarrowScreen ? 9 : 11,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_outlined, size: 26),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_outlined,
                        size: 26, color: colorScheme.primary),
                  ),
                  label: l10n.navHome,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.bar_chart_outlined, size: 26),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.bar_chart_outlined,
                        size: 26, color: colorScheme.primary),
                  ),
                  label: l10n.navHistory,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_outline, size: 26),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_outline,
                        size: 26, color: colorScheme.primary),
                  ),
                  label: l10n.navProfile,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.settings_outlined, size: 26),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.settings_outlined,
                        size: 26, color: colorScheme.primary),
                  ),
                  label: l10n.navSettings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddEntryModal(BuildContext context, {DateTime? selectedDate}) {
    final homeState = _homeScreenKey.currentState as HomeScreenState?;
    final date = selectedDate ?? homeState?.selectedDay ?? DateTime.now();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);
    final isFutureDate = selected.isAfter(today);
    final isPastDate = selected.isBefore(today);
    final localeName = Localizations.localeOf(context).toString();
    final l10n = context.l10n;

    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 360;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isNarrowScreen ? 12 : 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Container(
                          width: 36,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withOpacity(0.38),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        Text(
                          isFutureDate
                              ? l10n.mainRecordForDate(
                                  DateFormat('d.MM.yyyy', localeName)
                                      .format(date),
                                )
                              : isPastDate
                                  ? l10n.mainAddRecordForDate(
                                      DateFormat('d.MM.yyyy', localeName)
                                          .format(date),
                                    )
                                  : l10n.mainAddRecord,
                          style: TextStyle(
                            fontSize: isNarrowScreen ? 18 : 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        if (isFutureDate)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              l10n.mainCannotAddFutureRecords,
                              style: TextStyle(
                                fontSize: isNarrowScreen ? 12 : 13,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        SizedBox(height: isNarrowScreen ? 16 : 20),
                        _buildModalOption(
                          context,
                          icon: Icons.autorenew,
                          title: l10n.mainReplaceLenses,
                          description: l10n.mainReplaceLensesDescription,
                          enabled: !isFutureDate,
                          onTap: () {
                            Navigator.pop(context);
                            _replaceLenses(date);
                          },
                        ),
                        SizedBox(height: isNarrowScreen ? 10 : 12),
                        _buildModalOption(
                          context,
                          icon: Icons.inventory_2_outlined,
                          title: l10n.homeUpdateStock,
                          description: l10n.mainUpdateStockDescription,
                          enabled: !isFutureDate,
                          onTap: () {
                            Navigator.pop(context);
                            _updateStock(date);
                          },
                        ),
                        SizedBox(height: isNarrowScreen ? 10 : 12),
                        _buildModalOption(
                          context,
                          icon: Icons.medical_services_outlined,
                          title: l10n.mainAddSymptoms,
                          description: l10n.mainAddSymptomsDescription,
                          enabled: !isFutureDate,
                          onTap: () {
                            Navigator.pop(context);
                            _addSymptoms(date);
                          },
                        ),
                        SizedBox(height: isNarrowScreen ? 10 : 12),
                        _buildModalOption(
                          context,
                          icon: Icons.visibility_off_outlined,
                          title: l10n.mainTakeOffLenses,
                          description: l10n.mainTakeOffLensesDescription,
                          enabled: !isFutureDate,
                          onTap: () {
                            Navigator.pop(context);
                            _removeLenses(date);
                          },
                        ),
                        SizedBox(height: isNarrowScreen ? 16 : 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonal(
                            onPressed: () => Navigator.pop(context),
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: isNarrowScreen ? 12 : 14),
                              backgroundColor:
                                  Theme.of(context).colorScheme.surfaceContainerHighest,
                              foregroundColor: Theme.of(context).colorScheme.primary,
                              shape: const StadiumBorder(),
                              alignment: Alignment.center,
                            ),
                            child: Text(
                              l10n.cancel,
                              style: TextStyle(
                                fontSize: isNarrowScreen ? 15 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 360;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(isNarrowScreen ? 10 : 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: isNarrowScreen ? 44 : 48,
                  height: isNarrowScreen ? 44 : 48,
                  decoration: BoxDecoration(
                    gradient: context.neon.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: isNarrowScreen ? 22 : 24,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                SizedBox(width: isNarrowScreen ? 10 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 14 : 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 11 : 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary,
                  size: isNarrowScreen ? 14 : 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _replaceLenses(DateTime date) async {
    // РџСЂРѕРІРµСЂСЏРµРј Р·Р°РїР°СЃ Р»РёРЅР·
    final currentStock = widget.dataService.getCurrentStock();
    final hasActiveCycle = widget.dataService.getActiveCycle() != null;

    if (currentStock <= 0) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.mainNotEnoughLenses),
          content: Text(
            hasActiveCycle
                ? context.l10n.mainNoLensesAndTakeOffPrompt
                : context.l10n.mainNoLensesAddStockPrompt,
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
            if (hasActiveCycle)
              PrimaryGradientButton(
                onPressed: () {
                  Navigator.pop(context);
                  _removeLenses(DateTime.now());
                },
                child: Text(context.l10n.mainTakeOffLenses),
              ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.mainLensReplacement),
        content: Text(
          hasActiveCycle
              ? context.l10n.mainStartNewPairQuestion
              : context.l10n.mainPutOnNewPairQuestion,
        ),
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
          PrimaryGradientButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.mainReplace),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final isToday = date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;
        if (isToday) {
          await widget.dataService.startNewLensPair();
        } else {
          await widget.dataService.startNewCycleWithDate(date);
        }

        // рџ”ґ FIX BUG-005: РћС‚РјРµРЅСЏРµРј СЃС‚Р°СЂС‹Рµ СѓРІРµРґРѕРјР»РµРЅРёСЏ РїРµСЂРµРґ РїР»Р°РЅРёСЂРѕРІР°РЅРёРµРј РЅРѕРІС‹С…
        final notificationService = NotificationService();
        await notificationService.cancelLensNotifications('current_lens');
        await notificationService.cancelLensNotifications('current_lens_day');
        await notificationService
            .cancelLensNotifications('current_lens_before');
        await notificationService
            .cancelLensNotifications('current_lens_expiry');

        // РџР»Р°РЅРёСЂСѓРµРј СѓРІРµРґРѕРјР»РµРЅРёСЏ РґР»СЏ РЅРѕРІС‹С… Р»РёРЅР·
        await _scheduleLensNotifications();

        _refreshAllScreens();

        // рџџЎ MISSING-001: РџСЂРѕРІРµСЂРєР° РїРѕСЂРѕРіР° Р·Р°РїР°СЃР°
        final updatedStock = widget.dataService.getCurrentStock();
        final threshold = widget.dataService.getStockAlertThreshold();

        if (updatedStock <= threshold && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.l10n.mainLowStockWarning(updatedStock),
              ),
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.mainErrorReplacingLenses),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _scheduleLensNotifications() async {
    try {
      final notificationService = NotificationService();
      final hasPermission = await notificationService.areNotificationsEnabled();

      if (!hasPermission) return;

      // Android 14+: Р·Р°РїСЂРѕСЃ СЂР°Р·СЂРµС€РµРЅРёСЏ РЅР° С‚РѕС‡РЅС‹Рµ СѓРІРµРґРѕРјР»РµРЅРёСЏ
      await notificationService.requestExactAlarmsPermissionIfNeeded();

      final lensInfo = widget.dataService.getLensInfo();
      final activeCycle = widget.dataService.getActiveCycle();

      // Р•СЃР»Рё РµСЃС‚СЊ Р°РєС‚РёРІРЅС‹Р№ С†РёРєР», РІС‹С‡РёСЃР»СЏРµРј РґР°С‚Сѓ СЃР»РµРґСѓСЋС‰РµР№ Р·Р°РјРµРЅС‹
      if (activeCycle != null) {
        final daysToReplace = lensInfo.type.days;
        final nextReplacementDate =
            activeCycle.startDate.add(Duration(days: daysToReplace));

        // рџџЎ Settings РёР· РЅР°СЃС‚СЂРѕРµРє РїСЂРёР»РѕР¶РµРЅРёСЏ
        final timeStr = widget.dataService.getNotificationTime();
        final parts = timeStr.split(':');
        final notifTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts[1]) ?? 0,
        );
        final hoursBefore = widget.dataService.getDailyHoursBeforeReminder();
        final notifyAtExpiry = widget.dataService.getDailyNotifyAtExpiry();
        final otherDaysBefore = widget.dataService.getOtherDaysBeforeReminder();

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
              customMessage:
                  context.l10n.mainTimeMessageHoursBefore(hoursBefore),
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
                customMessage: context.l10n.mainTimeMessageExpiry,
                notificationId: 1002,
              );
            }
          }
        } else {
          // РћСЃС‚Р°Р»СЊРЅС‹Рµ С‚РёРїС‹: Р·Р° N days Рё РІ day Р·Р°РјРµРЅС‹
          final reminderDate =
              nextReplacementDate.subtract(Duration(days: otherDaysBefore));
          final dayMsg = otherDaysBefore == 1
              ? context.l10n.mainTomorrow
              : context.l10n.mainInDays(otherDaysBefore);

          if (reminderDate.isAfter(DateTime.now())) {
            await notificationService.scheduleLensReplacementNotification(
              lensId: 'current_lens',
              lensName: lensInfo.type.label,
              replacementDate: reminderDate,
              notificationTime: notifTime,
              customMessage: context.l10n.mainTimeToReplaceMessage(dayMsg),
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

        debugPrint('Notifications scheduled for: $nextReplacementDate');
      }

      // Care tips вЂ” РµР¶РµРґРЅРµРІРЅС‹Рµ СѓРІРµРґРѕРјР»РµРЅРёСЏ
      if (widget.dataService.getTipsNotificationsEnabled()) {
        await notificationService.scheduleDailyTipNotifications(
          enabled: true,
          timeString: widget.dataService.getTipsNotificationTime(),
          lensType: lensInfo.type,
        );
      }

      // Solution purchase reminder
      await notificationService.scheduleSolutionPurchaseNotification(
        enabled: widget.dataService.getSolutionPurchaseEnabled(),
        dayOfWeek: widget.dataService.getSolutionPurchaseDayOfWeek(),
        timeString: widget.dataService.getSolutionPurchaseTime(),
        periodMonths: widget.dataService.getSolutionPurchasePeriodMonths(),
      );

      // Low stock reminder (РµР¶РµРґРЅРµРІРЅРѕ РїСЂРё Р·Р°РїР°СЃРµ < РїРѕСЂРѕРіР°)
      await notificationService.scheduleLowStockReminder(widget.dataService);
    } catch (e) {
      debugPrint('Notification scheduling error: $e');
    }
  }

  void _updateStock(DateTime date) async {
    final controller = TextEditingController();
    final l10n = context.l10n;
    String? inputError;

    final result = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          void submit() {
            final raw = controller.text.trim();
            final count = int.tryParse(raw);
            if (count == null || count <= 0) {
              setDialogState(() => inputError = l10n.homeEnterPositiveNumber);
              return;
            }
            Navigator.pop(dialogContext, count);
          }

          return AlertDialog(
            title: Text(l10n.homeUpdateStock),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (_) {
                      if (inputError != null) {
                        setDialogState(() => inputError = null);
                      }
                    },
                    onSubmitted: (_) => submit(),
                    decoration: InputDecoration(
                      labelText: l10n.homeHowManyPairsToAdd,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  if (inputError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      inputError!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(dialogContext).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    l10n.homeCurrentStock(widget.dataService.getCurrentStock()),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(dialogContext).colorScheme.primary,
                  shape: const StadiumBorder(),
                  alignment: Alignment.center,
                ),
                child: Text(l10n.cancel),
              ),
              PrimaryGradientButton(
                onPressed: submit,
                child: Text(l10n.save),
              ),
            ],
          );
        },
      ),
    );
    controller.dispose();

    if (result != null && result > 0) {
      final current = widget.dataService.getCurrentStock();
      final updated = current + result;

      await widget.dataService.saveStockUpdate(
        models.StockUpdate(date: date, pairsCount: updated),
      );

      _refreshAllScreens();
    } else if (result != null && result <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.homeEnterPositiveNumber),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _addSymptoms(DateTime date) {
    _showSimpleSymptomsDialog(date: date);
  }

  void _removeLenses(DateTime date) async {
    // РџСЂРѕРІРµСЂСЏРµРј, РµСЃС‚СЊ Р»Рё Р°РєС‚РёРІРЅС‹Рµ Р»РёРЅР·С‹
    final activeCycle = widget.dataService.getActiveCycle();

    if (activeCycle == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.homeNoActiveLenses),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          ),
        );
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.mainTakeOffLenses),
        content: Text(context.l10n.mainTakeOffConfirm),
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
          PrimaryGradientButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.mainTakeOffLenses),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final isToday = date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;
      if (isToday) {
        await widget.dataService.completeCycleManually();
      } else {
        await widget.dataService.completeCurrentCycleAsOf(date);
      }

      // рџ”ґ FIX BUG-001: РћС‚РјРµРЅСЏРµРј РІСЃРµ СѓРІРµРґРѕРјР»РµРЅРёСЏ Рѕ Р·Р°РјРµРЅРµ
      final notificationService = NotificationService();
      await notificationService.cancelLensNotifications('current_lens');
      await notificationService.cancelLensNotifications('current_lens_day');
      await notificationService.cancelLensNotifications('current_lens_before');
      await notificationService.cancelLensNotifications('current_lens_expiry');

      // РћР±РЅРѕРІР»СЏРµРј РІСЃРµ СЌРєСЂР°РЅС‹
      _refreshAllScreens();
    }
  }

  void _showSimpleSymptomsDialog({DateTime? date}) {
    final Set<Symptom> selectedSymptoms = {};
    final dateToUse = date ?? DateTime.now();

    // рџџЎ MISSING-011: РџСЂРµРґРІС‹Р±РѕСЂ СЃСѓС‰РµСЃС‚РІСѓСЋС‰РёС… СЃРёРјРїС‚РѕРјРѕРІ
    final existingEntry = widget.dataService.getSymptomsForDate(dateToUse);
    if (existingEntry != null) {
      selectedSymptoms.addAll(existingEntry.symptoms);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(context.l10n.mainAddSymptoms),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.5,
                      children: Symptom.values.map((symptom) {
                        final isSelected = selectedSymptoms.contains(symptom);

                        return InkWell(
                          onTap: () {
                            setDialogState(() {
                              if (isSelected) {
                                selectedSymptoms.remove(symptom);
                              } else {
                                selectedSymptoms.add(symptom);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    symptom.icon,
                                    size: 18,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      symptom.localizedLabel(context.l10n),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isSelected
                                            ? Theme.of(context).colorScheme.onPrimary
                                            : Theme.of(context).colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
                  onPressed: selectedSymptoms.isEmpty
                      ? null
                      : () async {
                          await widget.dataService.saveSymptomEntry(
                            models.SymptomEntry(
                              date: dateToUse,
                              symptoms: selectedSymptoms.toList(),
                            ),
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                            _refreshAllScreens();
                          }
                        },
                  child: Text(context.l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }
}





