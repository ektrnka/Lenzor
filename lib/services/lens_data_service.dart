// services/lens_data_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lens_data.dart';

/// ?? РЎР•Р Р’РРЎ Р”РђРќРќР«РҐ [file:15] Р РђР—Р”Р•Р› 2
///
/// РЈРїСЂР°РІР»РµРЅРёРµ РІСЃРµРјРё РґР°РЅРЅС‹РјРё РїСЂРёР»РѕР¶РµРЅРёСЏ С‡РµСЂРµР· SharedPreferences
class LensDataService {
  // =======================================================================
  // РљР›Р®Р§Р SharedPreferences [file:15] 2.1
  // =======================================================================

  static const String _keyLensInfo = 'lens_info';
  static const String _keyVisionChecks = 'vision_checks';
  static const String _keySymptoms = 'symptoms';
  static const String _keyReplacements = 'replacements';
  static const String _keyStockUpdates = 'stock_updates';
  static const String _keyCurrentStock = 'current_stock';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyNotificationTime = 'notification_time';
  static const String _keyDailyHoursBeforeReminder =
      'daily_hours_before_reminder';
  static const String _keyDailyNotifyAtExpiry = 'daily_notify_at_expiry';
  static const String _keyOtherDaysBeforeReminder =
      'other_days_before_reminder';
  static const String _keyStockAlertThreshold = 'stock_alert_threshold';
  static const String _keyLensCycles = 'lens_cycles';
  static const String _keyActiveCycle = 'active_cycle';
  static const String _keyTipsNotificationsEnabled =
      'tips_notifications_enabled';
  static const String _keyTipsNotificationTime = 'tips_notification_time';
  static const String _keySolutionPurchaseEnabled = 'solution_purchase_enabled';
  static const String _keySolutionPurchaseDayOfWeek =
      'solution_purchase_day_of_week';
  static const String _keySolutionPurchaseTime = 'solution_purchase_time';
  static const String _keySolutionPurchasePeriodMonths =
      'solution_purchase_period_months';
  static const String _keyLowStockReminderEnabled =
      'low_stock_reminder_enabled';
  static const String _keyLowStockReminderTime = 'low_stock_reminder_time';
  static const String _keyLanguagePreference = 'language_preference';

  final SharedPreferences _prefs;

  LensDataService._(this._prefs);

  /// ?? РРќРР¦РРђР›РР—РђР¦РРЇ [file:15] 2.1
  static Future<LensDataService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LensDataService._(prefs);
  }

  /// Р•СЃС‚СЊ Р»Рё Р·РЅР°С‡РёРјС‹Рµ Р»РѕРєР°Р»СЊРЅС‹Рµ РґР°РЅРЅС‹Рµ (РёСЃС‚РѕСЂРёСЏ, С†РёРєР»С‹, symptomС‹ Рё С‚.Рґ.)
  bool hasLocalData() {
    if (getLensReplacements().isNotEmpty) return true;
    if (getSymptomEntries().isNotEmpty) return true;
    if (getVisionChecks().isNotEmpty) return true;
    if (getLensCycles().isNotEmpty) return true;
    if (getActiveCycle() != null) return true;
    if (getLensInfo().firstUseDate != null) return true;
    return false;
  }

  // =======================================================================
  // РРќР¤РћР РњРђР¦РРЇ Рћ Р›РРќР—РђРҐ [file:15] 1.3
  // =======================================================================

  Future<void> saveLensInfo(LensInfo info) async {
    await _prefs.setString(_keyLensInfo, jsonEncode(info.toJson()));
    debugPrint('LensInfo saved: ${info.brand}, ${info.type.label}');
  }

  LensInfo getLensInfo() {
    final str = _prefs.getString(_keyLensInfo);
    if (str == null) {
      debugPrint(
          'LensInfo not found, using defaults (no lenses)');
      return LensInfo(); // firstUseDate = null вЂ” С‡РµР»РѕРІРµРє РїРѕ СѓРјРѕР»С‡Р°РЅРёСЋ Р±РµР· Р»РёРЅР·
    }
    return LensInfo.fromJson(jsonDecode(str) as Map<String, dynamic>);
  }

  // =======================================================================
  // РџР РћР’Р•Р РљР Р—Р Р•РќРРЇ [file:15] 1.4
  // =======================================================================

  Future<void> saveVisionCheck(VisionCheck check) async {
    final checks = getVisionChecks();
    checks.add(check);
    await _prefs.setString(
      _keyVisionChecks,
      jsonEncode(checks.map((c) => c.toJson()).toList()),
    );
    debugPrint('VisionCheck saved: ${check.date}');
  }

  List<VisionCheck> getVisionChecks() {
    final str = _prefs.getString(_keyVisionChecks);
    if (str == null) return [];
    final List<dynamic> list = jsonDecode(str) as List;
    return list
        .map((e) => VisionCheck.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteVisionCheck(VisionCheck check) async {
    final checks = getVisionChecks();
    checks.removeWhere((c) =>
        c.date == check.date &&
        c.leftSph == check.leftSph &&
        c.rightSph == check.rightSph &&
        c.leftCyl == check.leftCyl &&
        c.rightCyl == check.rightCyl &&
        c.leftAxis == check.leftAxis &&
        c.rightAxis == check.rightAxis);
    await _prefs.setString(
      _keyVisionChecks,
      jsonEncode(checks.map((c) => c.toJson()).toList()),
    );
    debugPrint('VisionCheck deleted: ${check.date}');
  }

  // =======================================================================
  // РЎРРњРџРўРћРњР« [file:15] 1.5
  // =======================================================================

  /// ?? РЎРѕС…СЂР°РЅРµРЅРёРµ symptoms [file:15] 1.5
  ///
  /// РћРґРЅР° Р·Р°РїРёСЃСЊ РЅР° day. РџСЂРё РїРѕРІС‚РѕСЂРЅРѕРј СЃРѕС…СЂР°РЅРµРЅРёРё Р·Р°РјРµРЅСЏРµС‚СЃСЏ
  Future<void> saveSymptomEntry(SymptomEntry entry) async {
    final entries = getSymptomEntries();

    // Delete СЃСѓС‰РµСЃС‚РІСѓСЋС‰СѓСЋ Р·Р°РїРёСЃСЊ Р·Р° СЌС‚РѕС‚ day [file:15] 1.5
    entries.removeWhere((e) =>
        e.date.year == entry.date.year &&
        e.date.month == entry.date.month &&
        e.date.day == entry.date.day);

    entries.add(entry);
    await _prefs.setString(
      _keySymptoms,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
    debugPrint(
        'SymptomEntry saved: ${entry.date}, ${entry.symptoms.length} symptoms');
  }

  List<SymptomEntry> getSymptomEntries() {
    final str = _prefs.getString(_keySymptoms);
    if (str == null) return [];
    final List<dynamic> list = jsonDecode(str) as List;
    return list
        .map((e) => SymptomEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// РџРѕР»СѓС‡РёС‚СЊ symptomС‹ Р·Р° РєРѕРЅРєСЂРµС‚РЅСѓСЋ РґР°С‚Сѓ
  SymptomEntry? getSymptomsForDate(DateTime date) {
    final entries = getSymptomEntries();
    try {
      return entries.firstWhere((e) =>
          e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day);
    } catch (_) {
      return null;
    }
  }

  // =======================================================================
  // Р—РђРњР•РќР« Р›РРќР— [file:15] 1.6
  // =======================================================================

  Future<void> saveLensReplacement(LensReplacement replacement) async {
    final replacements = getLensReplacements();
    replacements.add(replacement);
    await _prefs.setString(
      _keyReplacements,
      jsonEncode(replacements.map((r) => r.toJson()).toList()),
    );

    // РћР±РЅРѕРІРёС‚СЊ firstUseDate [file:15] 1.6
    final lensInfo = getLensInfo();
    lensInfo.firstUseDate = replacement.date;
    await saveLensInfo(lensInfo);

    debugPrint('LensReplacement saved: ${replacement.date}');
  }

  List<LensReplacement> getLensReplacements() {
    final str = _prefs.getString(_keyReplacements);
    if (str == null) return [];
    final List<dynamic> list = jsonDecode(str) as List;
    return list
        .map((e) => LensReplacement.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  LensReplacement? getLastReplacement() {
    final replacements = getLensReplacements();
    if (replacements.isEmpty) return null;
    replacements.sort((a, b) => b.date.compareTo(a.date));
    return replacements.first;
  }

  // =======================================================================
  // Р—РђРџРђРЎ Р›РРќР— [file:15] 1.7, 2.3
  // =======================================================================

  Future<void> saveStockUpdate(StockUpdate update) async {
    final updates = getStockUpdates();
    updates.add(update);
    await _prefs.setString(
      _keyStockUpdates,
      jsonEncode(updates.map((u) => u.toJson()).toList()),
    );
    await _prefs.setInt(_keyCurrentStock, update.pairsCount);
    debugPrint('StockUpdate saved: ${update.pairsCount} pairs');
  }

  List<StockUpdate> getStockUpdates() {
    final str = _prefs.getString(_keyStockUpdates);
    if (str == null) return [];
    final List<dynamic> list = jsonDecode(str) as List;
    return list
        .map((e) => StockUpdate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  int getCurrentStock() {
    return _prefs.getInt(_keyCurrentStock) ?? 1;
  }

  Future<void> setCurrentStock(int count) async {
    await _prefs.setInt(_keyCurrentStock, count);
  }

  /// ?? РџСЂРѕРІРµСЂРєР°: Р·Р°РїР°СЃ РЅРёР¶Рµ РїРѕСЂРѕРіР° [file:15] 2.3
  bool isStockLow() {
    final current = getCurrentStock();
    final threshold = getStockAlertThreshold();
    debugPrint(
        'Stock check: $current <= $threshold = ${current <= threshold}');
    return current <= threshold;
  }

  // =======================================================================
  // РќРђРЎРўР РћР™РљР
  // =======================================================================

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationTime(String time) async {
    await _prefs.setString(_keyNotificationTime, time);
  }

  String getNotificationTime() {
    return _prefs.getString(_keyNotificationTime) ?? '08:00';
  }

  /// РћРґРЅРѕРґРЅРµРІРЅС‹Рµ: Р·Р° СЃРєРѕР»СЊРєРѕ hourРѕРІ РґРѕ РєРѕРЅС†Р° (14С‡) РЅР°РїРѕРјРёРЅР°С‚СЊ. РџРѕ СѓРјРѕР»С‡Р°РЅРёСЋ 2.
  Future<void> setDailyHoursBeforeReminder(int hours) async {
    await _prefs.setInt(_keyDailyHoursBeforeReminder, hours);
  }

  int getDailyHoursBeforeReminder() {
    return _prefs.getInt(_keyDailyHoursBeforeReminder) ?? 2;
  }

  /// РћРґРЅРѕРґРЅРµРІРЅС‹Рµ: СѓРІРµРґРѕРјР»СЏС‚СЊ РІ РјРѕРјРµРЅС‚ РёСЃС‚РµС‡РµРЅРёСЏ 14С‡. РџРѕ СѓРјРѕР»С‡Р°РЅРёСЋ true.
  Future<void> setDailyNotifyAtExpiry(bool value) async {
    await _prefs.setBool(_keyDailyNotifyAtExpiry, value);
  }

  bool getDailyNotifyAtExpiry() {
    return _prefs.getBool(_keyDailyNotifyAtExpiry) ?? true;
  }

  /// РџСЂРѕС‡РёРµ С‚РёРїС‹: Р·Р° СЃРєРѕР»СЊРєРѕ days РґРѕ Р·Р°РјРµРЅС‹ РЅР°РїРѕРјРёРЅР°С‚СЊ. РџРѕ СѓРјРѕР»С‡Р°РЅРёСЋ 1.
  Future<void> setOtherDaysBeforeReminder(int days) async {
    await _prefs.setInt(_keyOtherDaysBeforeReminder, days);
  }

  int getOtherDaysBeforeReminder() {
    return _prefs.getInt(_keyOtherDaysBeforeReminder) ?? 1;
  }

  Future<void> setStockAlertThreshold(int threshold) async {
    await _prefs.setInt(_keyStockAlertThreshold, threshold);
  }

  int getStockAlertThreshold() {
    return _prefs.getInt(_keyStockAlertThreshold) ?? 1;
  }

  Future<void> setTipsNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_keyTipsNotificationsEnabled, enabled);
  }

  bool getTipsNotificationsEnabled() {
    return _prefs.getBool(_keyTipsNotificationsEnabled) ?? false;
  }

  Future<void> setTipsNotificationTime(String time) async {
    await _prefs.setString(_keyTipsNotificationTime, time);
  }

  String getTipsNotificationTime() {
    return _prefs.getString(_keyTipsNotificationTime) ?? '09:00';
  }

  // =======================================================================
  // РЈР’Р•Р”РћРњР›Р•РќРР• Рћ РџРћРљРЈРџРљР• Р РђРЎРўР’РћР Рђ
  // =======================================================================

  Future<void> setSolutionPurchaseEnabled(bool enabled) async {
    await _prefs.setBool(_keySolutionPurchaseEnabled, enabled);
  }

  bool getSolutionPurchaseEnabled() {
    return _prefs.getBool(_keySolutionPurchaseEnabled) ?? false;
  }

  Future<void> setSolutionPurchaseDayOfWeek(int day) async {
    await _prefs.setInt(_keySolutionPurchaseDayOfWeek, day);
  }

  int getSolutionPurchaseDayOfWeek() {
    return _prefs.getInt(_keySolutionPurchaseDayOfWeek) ?? 1; // 1 = Monday
  }

  Future<void> setSolutionPurchaseTime(String time) async {
    await _prefs.setString(_keySolutionPurchaseTime, time);
  }

  String getSolutionPurchaseTime() {
    return _prefs.getString(_keySolutionPurchaseTime) ?? '09:00';
  }

  Future<void> setSolutionPurchasePeriodMonths(int months) async {
    await _prefs.setInt(_keySolutionPurchasePeriodMonths, months);
  }

  int getSolutionPurchasePeriodMonths() {
    return _prefs.getInt(_keySolutionPurchasePeriodMonths) ?? 1;
  }

  // =======================================================================
  // РќРђРџРћРњРРќРђРќРР• Рћ РљРћРќР¦Р• Р—РђРџРђРЎРћР’
  // =======================================================================

  Future<void> setLowStockReminderEnabled(bool enabled) async {
    await _prefs.setBool(_keyLowStockReminderEnabled, enabled);
  }

  bool getLowStockReminderEnabled() {
    return _prefs.getBool(_keyLowStockReminderEnabled) ?? false;
  }

  Future<void> setLowStockReminderTime(String time) async {
    await _prefs.setString(_keyLowStockReminderTime, time);
  }

  String getLowStockReminderTime() {
    return _prefs.getString(_keyLowStockReminderTime) ?? '09:00';
  }

  Future<void> setLanguagePreference(String preference) async {
    await _prefs.setString(_keyLanguagePreference, preference);
  }

  String getLanguagePreference() {
    return _prefs.getString(_keyLanguagePreference) ?? 'system';
  }

  // =======================================================================
  // Р¦РРљР›Р« РќРћРЁР•РќРРЇ [file:15] 1.8, 2.2
  // =======================================================================

  /// ?? РРЎРџР РђР’Р›Р•РќРћ: СѓР±СЂР°РЅ LensCycleManager [file:15] 2.2
  Future<void> saveLensCycles(List<LensCycle> cycles) async {
    // ? Р‘Р«Р›Рћ (РћРЁРР‘РљРђ):
    // final cycleManager = LensCycleManager(cycles);
    // await _prefs.setString(_keyLensCycles, jsonEncode(cycleManager.toJsonList()));

    // ? РЎРўРђР›Рћ (РџР РђР’РР›Р¬РќРћ):
    final jsonList = cycles.map((cycle) => cycle.toJson()).toList();
    await _prefs.setString(_keyLensCycles, jsonEncode(jsonList));
    debugPrint('LensCycles saved: ${cycles.length} cycles');
  }

  Future<void> saveActiveCycle(LensCycle? cycle) async {
    if (cycle == null) {
      await _prefs.remove(_keyActiveCycle);
      debugPrint('Active cycle removed');
    } else {
      await _prefs.setString(_keyActiveCycle, jsonEncode(cycle.toJson()));
      debugPrint('Active cycle saved: ${cycle.startDate}');
    }
  }

  List<LensCycle> getLensCycles() {
    final str = _prefs.getString(_keyLensCycles);
    if (str == null) return [];
    final List<dynamic> list = jsonDecode(str) as List;
    return list
        .map((e) => LensCycle.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// ?? РџРћР›РЈР§Р•РќРР• РђРљРўРР’РќРћР“Рћ Р¦РРљР›Рђ [file:15] 2.2
  ///
  /// РџСЂРёРѕСЂРёС‚РµС‚ РїРѕРёСЃРєР°:
  /// 1. SharedPreferences РєР»СЋС‡ 'active_cycle'
  /// 2. РџРѕСЃР»РµdaysСЏ Р·Р°РјРµРЅР° (РІРёСЂС‚СѓР°Р»СЊРЅС‹Р№ С†РёРєР»)
  /// 3. LensInfo.firstUseDate (РІРёСЂС‚СѓР°Р»СЊРЅС‹Р№ С†РёРєР»)
  /// 4. null
  LensCycle? getActiveCycle() {
    // 1. РџСЂРѕРІРµСЂРёС‚СЊ active_cycle
    final str = _prefs.getString(_keyActiveCycle);
    if (str != null) {
      try {
        final cycle =
            LensCycle.fromJson(jsonDecode(str) as Map<String, dynamic>);
        if (cycle.isActive) {
          return cycle;
        }
      } catch (e) {
        debugPrint('Active cycle parse error: $e');
      }
    }

    // 2. РџСЂРѕРІРµСЂРёС‚СЊ РїРѕСЃР»РµРґРЅСЋСЋ Р·Р°РјРµРЅСѓ (РѕР±СЂР°С‚РЅР°СЏ СЃРѕРІРјРµСЃС‚РёРјРѕСЃС‚СЊ)
    // РќРµ СЃРѕР·РґР°С‘Рј РІРёСЂС‚СѓР°Р»СЊРЅС‹Р№ С†РёРєР», РµСЃР»Рё С†РёРєР» СЃ СЌС‚РѕР№ РґР°С‚С‹ СѓР¶Рµ Р·Р°РІРµСЂС€С‘РЅ (СЃРЅСЏС‚РёРµ Р»РёРЅР·)
    final lastReplacement = getLastReplacement();
    final lensInfo = getLensInfo();
    final completedCycles = getCompletedCycles();

    if (lastReplacement != null) {
      final replacementDate = lastReplacement.date;
      final sameDayCompleted = completedCycles.any((c) =>
          c.startDate.year == replacementDate.year &&
          c.startDate.month == replacementDate.month &&
          c.startDate.day == replacementDate.day);
      if (!sameDayCompleted) {
        final daysWorn = DateTime.now().difference(replacementDate).inDays;
        if (daysWorn >= 0) {
          debugPrint('Created virtual cycle from last replacement');
          return LensCycle(
            startDate: replacementDate,
            lensType: lensInfo.type,
            completedManually: false,
          );
        }
      }
    }
    if (lensInfo.firstUseDate != null) {
      // 3. РџСЂРѕРІРµСЂРёС‚СЊ firstUseDate (РЅРµ СЃРѕР·РґР°С‘Рј РІРёСЂС‚СѓР°Р»СЊРЅС‹Р№ С†РёРєР», РµСЃР»Рё СѓР¶Рµ Р·Р°РІРµСЂС€С‘РЅ)
      final fud = lensInfo.firstUseDate!;
      final sameDayCompleted = completedCycles.any((c) =>
          c.startDate.year == fud.year &&
          c.startDate.month == fud.month &&
          c.startDate.day == fud.day);
      if (!sameDayCompleted) {
        final daysWorn = DateTime.now().difference(fud).inDays;
        if (daysWorn >= 0) {
          debugPrint('Created virtual cycle from firstUseDate');
          return LensCycle(
            startDate: fud,
            lensType: lensInfo.type,
            completedManually: false,
          );
        }
      }
    }

    return null;
  }

  List<LensCycle> getCompletedCycles() {
    final allCycles = getLensCycles();
    return allCycles.where((cycle) => !cycle.isActive).toList();
  }

  /// ?? Р—РђР’Р•Р РЁР•РќРР• РўР•РљРЈР©Р•Р“Рћ Р¦РРљР›Рђ [file:15] 2.2
  ///
  /// РџРћРЎР›Р•Р”РћР’РђРўР•Р›Р¬РќРћРЎРўР¬:
  /// 1. РџРѕР»СѓС‡РёС‚СЊ Р°РєС‚РёРІРЅС‹Р№ С†РёРєР» (РµСЃР»Рё null > РІС‹С…РѕРґ)
  /// 2. РЎРѕР·РґР°С‚СЊ Р·Р°РІРµСЂС€С‘РЅРЅС‹Р№ С†РёРєР»
  /// 3. РћР±РЅРѕРІРёС‚СЊ СЃРїРёСЃРѕРє Р·Р°РІРµСЂС€С‘РЅРЅС‹С… cycles
  /// 4. РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Р°РєС‚РёРІРЅС‹Р№ С†РёРєР» РІ null
  /// 5. Р•СЃР»Рё manually=true > СЃРѕР·РґР°С‚СЊ SymptomEntry
  Future<void> completeCurrentCycle(bool manually) async {
    final activeCycle = getActiveCycle();
    if (activeCycle == null) {
      debugPrint('No active cycle to complete');
      return;
    }

    final now = DateTime.now();
    final allCycles = getLensCycles();

    // Р—Р°РІРµСЂС€РёС‚СЊ С†РёРєР»
    final completedCycle = activeCycle.completeCycle(
      now,
      manually: manually,
      symptomEntryId: manually ? 'manual_${now.millisecondsSinceEpoch}' : null,
    );

    // РћР±РЅРѕРІРёС‚СЊ СЃРїРёСЃРѕРє (СѓРґР°Р»РёС‚СЊ Р°РєС‚РёРІРЅС‹Рµ, РґРѕР±Р°РІРёС‚СЊ Р·Р°РІРµСЂС€С‘РЅРЅС‹Р№)
    final updatedCycles = List<LensCycle>.from(allCycles)
      ..removeWhere((cycle) => cycle.isActive)
      ..add(completedCycle);

    await saveLensCycles(updatedCycles);
    await saveActiveCycle(null);

    debugPrint(
        'Cycle completed: manually=$manually, daysWorn=${completedCycle.actualDaysWorn}');

    // РЎРѕР·РґР°С‚СЊ Р·Р°РїРёСЃСЊ symptoms РїСЂРё СЂСѓС‡РЅРѕРј СЃРЅСЏС‚РёРё [file:15] 2.2
    if (manually) {
      await saveSymptomEntry(
        SymptomEntry(
          date: now,
          symptoms: [],
          notes: 'Lenses removed manually',
        ),
      );
    }
  }

  /// Р—Р°РІРµСЂС€РёС‚СЊ С†РёРєР» РІСЂСѓС‡РЅСѓСЋ (РІС‹Р·С‹РІР°РµС‚СЃСЏ РёР· home_screen)
  Future<void> completeCycleManually() async {
    await completeCurrentCycle(true);
  }

  /// ?? РќРђР§РђРўР¬ РќРћР’Р«Р™ Р¦РРљР› [file:15] 2.2
  ///
  /// РџР Р•Р”РЈРЎР›РћР’РРЇ: currentStock > 0
  /// РџРћРЎР›Р•Р”РћР’РђРўР•Р›Р¬РќРћРЎРўР¬:
  /// 1. РџСЂРѕРІРµСЂРёС‚СЊ Р·Р°РїР°СЃ
  /// 2. Р—Р°РІРµСЂС€РёС‚СЊ Р°РєС‚РёРІРЅС‹Р№ С†РёРєР» (РµСЃР»Рё РµСЃС‚СЊ)
  /// 3. РЎРѕР·РґР°С‚СЊ LensReplacement
  /// 4. РЎРѕР·РґР°С‚СЊ РЅРѕРІС‹Р№ LensCycle
  /// 5. РЈРјРµРЅСЊС€РёС‚СЊ Р·Р°РїР°СЃ РЅР° 1
  Future<void> startNewCycle() async {
    final now = DateTime.now();
    final lensInfo = getLensInfo();
    final currentStock = getCurrentStock();

    if (currentStock <= 0) {
      throw Exception('Not enough lenses in stock');
    }

    // Р—Р°РІРµСЂС€РёС‚СЊ С‚РµРєСѓС‰РёР№ С†РёРєР»
    final activeCycle = getActiveCycle();
    if (activeCycle != null) {
      await completeCurrentCycle(false);
    }

    // РЎРѕР·РґР°С‚СЊ Р·Р°РјРµРЅСѓ
    await saveLensReplacement(LensReplacement(date: now));

    // РЎРѕР·РґР°С‚СЊ РЅРѕРІС‹Р№ С†РёРєР»
    final newCycle = LensCycle(
      startDate: now,
      lensType: lensInfo.type,
      completedManually: false,
    );
    await saveActiveCycle(newCycle);

    // РЈРјРµРЅСЊС€РёС‚СЊ Р·Р°РїР°СЃ РЅР° 1
    final updatedStock = currentStock - 1;
    await saveStockUpdate(StockUpdate(
      date: now,
      pairsCount: updatedStock,
    ));

    debugPrint(
        'New cycle started: ${lensInfo.type.label}, stock: $updatedStock');
  }

  /// РђР»РёР°СЃ РґР»СЏ main.dart (startNewLensPair)
  Future<void> startNewLensPair() async {
    await startNewCycle();
  }

  /// ?? РќРђР§РђРўР¬ РќРћР’Р«Р™ Р¦РРљР› РЎ РЈРљРђР—РђРќРќРћР™ Р”РђРўРћР™ (РґР»СЏ Р·Р°РїРёСЃРµР№ Р·Р° РїСЂРѕС€Р»С‹Рµ РґР°С‚С‹)
  Future<void> startNewCycleWithDate(DateTime date) async {
    final lensInfo = getLensInfo();
    final currentStock = getCurrentStock();

    if (currentStock <= 0) {
      throw Exception('Not enough lenses in stock');
    }

    final activeCycle = getActiveCycle();
    if (activeCycle != null && !date.isBefore(activeCycle.startDate)) {
      await completeCurrentCycleAsOf(date);
    } else if (activeCycle != null) {
      await saveActiveCycle(
          null); // РІС‹Р±СЂР°РЅРЅР°СЏ РґР°С‚Р° СЂР°РЅСЊС€Рµ С‚РµРєСѓС‰РµРіРѕ С†РёРєР»Р° вЂ” СЃР±СЂР°СЃС‹РІР°РµРј
    }

    await saveLensReplacement(LensReplacement(date: date));
    final newCycle = LensCycle(
      startDate: date,
      lensType: lensInfo.type,
      completedManually: false,
    );
    await saveActiveCycle(newCycle);

    final updatedStock = currentStock - 1;
    await saveStockUpdate(StockUpdate(date: date, pairsCount: updatedStock));
    debugPrint('New cycle started from date $date');
  }

  /// ?? Р—РђР’Р•Р РЁРРўР¬ Р¦РРљР› РќРђ РЈРљРђР—РђРќРќРЈР® Р”РђРўРЈ (РґР»СЏ Р·Р°РїРёСЃРµР№ Р·Р° РїСЂРѕС€Р»С‹Рµ РґР°С‚С‹)
  Future<void> completeCurrentCycleAsOf(DateTime date) async {
    final activeCycle = getActiveCycle();
    if (activeCycle == null) return;

    final allCycles = getLensCycles();
    final completedCycle = activeCycle.completeCycle(
      date,
      manually: true,
      symptomEntryId: 'manual_${date.millisecondsSinceEpoch}',
    );

    final updatedCycles = List<LensCycle>.from(allCycles)
      ..removeWhere((cycle) => cycle.isActive)
      ..add(completedCycle);

    await saveLensCycles(updatedCycles);
    await saveActiveCycle(null);

    await saveSymptomEntry(
      SymptomEntry(
        date: date,
        symptoms: [],
        notes: 'Lenses removed manually',
      ),
    );
    debugPrint('Cycle completed on date $date');
  }

  /// ?? РџРћР›РЈР§РРўР¬ Р’РЎР• Р¦РРљР›Р« [file:15] 7.1
  ///
  /// Р’РѕР·РІСЂР°С‰Р°РµС‚ Р°РєС‚РёРІРЅС‹Р№ + Р·Р°РІРµСЂС€С‘РЅРЅС‹Рµ С†РёРєР»С‹, РѕС‚СЃРѕСЂС‚РёСЂРѕРІР°РЅРЅС‹Рµ РїРѕ РґР°С‚Рµ (РЅРѕРІС‹Рµ РїРµСЂРІС‹РјРё)
  List<LensCycle> getAllCycles() {
    final activeCycle = getActiveCycle();
    final completedCycles = getCompletedCycles();

    final allCycles = <LensCycle>[];
    if (activeCycle != null) {
      allCycles.add(activeCycle);
    }
    allCycles.addAll(completedCycles);

    // РЎРѕСЂС‚РёСЂРѕРІРєР°: РЅРѕРІС‹Рµ РїРµСЂРІС‹РјРё
    allCycles.sort((a, b) => b.startDate.compareTo(a.startDate));

    return allCycles;
  }

  /// Р’СЃРµ РґРЅРё РЅРѕС€РµРЅРёСЏ Р»РёРЅР· (С‚РµРєСѓС‰РёР№ Рё РїСЂРµРґС‹РґСѓС‰РёРµ С†РёРєР»С‹) вЂ” РґР»СЏ РїРѕРґСЃРІРµС‚РєРё РІ РєР°Р»РµРЅРґР°СЂРµ
  Set<DateTime> getAllWearDays() {
    final days = <DateTime>{};
    for (final cycle in getAllCycles()) {
      final start = DateTime(
          cycle.startDate.year, cycle.startDate.month, cycle.startDate.day);
      final end = cycle.endDate != null
          ? DateTime(
              cycle.endDate!.year, cycle.endDate!.month, cycle.endDate!.day)
          : DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);

      if (cycle.lensType.days == 1) {
        days.add(start);
      } else {
        var d = start;
        while (!d.isAfter(end)) {
          days.add(d);
          d = d.add(const Duration(days: 1));
        }
      }
    }
    return days;
  }

  /// ?? РЎРўРђРўРРЎРўРРљРђ Р¦РРљР›РћР’ [file:15] 2.5
  Map<String, dynamic> getCycleStatistics() {
    final completedCycles = getCompletedCycles();
    final activeCycle = getActiveCycle();

    final totalCycles = completedCycles.length + (activeCycle != null ? 1 : 0);
    final totalDays = completedCycles.fold<int>(
      0,
      (sum, cycle) => sum + (cycle.actualDaysWorn ?? 0),
    );
    final averageDays =
        completedCycles.isNotEmpty ? totalDays ~/ completedCycles.length : 0;

    return {
      'totalCycles': totalCycles,
      'completedCycles': completedCycles.length,
      'activeCycle': activeCycle != null,
      'totalDaysWorn': totalDays,
      'averageDaysPerCycle': averageDays,
    };
  }

  LensCycle? getLastCompletedCycle() {
    final completedCycles = getCompletedCycles();
    if (completedCycles.isEmpty) return null;
    completedCycles.sort((a, b) =>
        (b.endDate ?? DateTime.now()).compareTo(a.endDate ?? DateTime.now()));
    return completedCycles.first;
  }

  List<LensCycle> getCyclesByYear(int year) {
    final allCycles = getAllCycles();
    return allCycles.where((cycle) {
      final cycleYear = cycle.endDate?.year ?? DateTime.now().year;
      return cycleYear == year;
    }).toList();
  }

  List<int> getCycleYears() {
    final allCycles = getAllCycles();
    final years = <int>{};
    for (final cycle in allCycles) {
      final cycleYear = cycle.endDate?.year ?? DateTime.now().year;
      years.add(cycleYear);
    }
    return years.toList()..sort((a, b) => b.compareTo(a));
  }

  // =======================================================================
  // РРќРР¦РРђР›РР—РђР¦РРЇ Р РњРР“Р РђР¦РРЇ [file:15] 2.4
  // =======================================================================

  /// ?? РРќРР¦РРђР›РР—РђР¦РРЇ РџР•Р Р’РћР“Рћ Р¦РРљР›Рђ [file:15] 2.4
  Future<void> initializeFirstCycle() async {
    final activeCycle = getActiveCycle();
    final hasCycles = getLensCycles().isNotEmpty;

    if (activeCycle == null && !hasCycles) {
      final lensInfo = getLensInfo();
      if (lensInfo.firstUseDate != null) {
        final daysWorn =
            DateTime.now().difference(lensInfo.firstUseDate!).inDays;
        if (daysWorn >= 0) {
          final newCycle = LensCycle(
            startDate: lensInfo.firstUseDate!,
            lensType: lensInfo.type,
            completedManually: false,
          );
          await saveActiveCycle(newCycle);
          debugPrint('First cycle initialized from firstUseDate');
        }
      }
    }
  }

  /// ?? РњРР“Р РђР¦РРЇ Рљ РЎРРЎРўР•РњР• Р¦РРљР›РћР’ [file:15] 2.4
  Future<void> migrateToCycleSystem() async {
    final hasCycles = _prefs.containsKey(_keyLensCycles);
    if (hasCycles) {
      debugPrint('Migration not required (cycles already exist)');
      return;
    }

    debugPrint('Starting migration to cycle system...');

    final replacements = getLensReplacements();
    final lensInfo = getLensInfo();
    final cycles = <LensCycle>[];

    // РЎРѕР·РґР°С‚СЊ Р·Р°РІРµСЂС€С‘РЅРЅС‹Рµ С†РёРєР»С‹ РёР· pairs Р·Р°РјРµРЅ
    for (int i = 1; i < replacements.length; i++) {
      final start = replacements[i - 1];
      final end = replacements[i];
      final daysWorn = end.date.difference(start.date).inDays + 1;

      cycles.add(LensCycle(
        startDate: start.date,
        endDate: end.date,
        lensType: lensInfo.type,
        actualDaysWorn: daysWorn,
        completedManually: false,
        replacementId: 'migrated_${i - 1}_to_$i',
      ));
    }

    if (cycles.isNotEmpty) {
      await saveLensCycles(cycles);
      debugPrint('Created ${cycles.length} completed cycles');
    }

    // РЎРѕР·РґР°С‚СЊ Р°РєС‚РёРІРЅС‹Р№ С†РёРєР»
    final lastReplacement = replacements.isNotEmpty ? replacements.last : null;
    if (lastReplacement != null) {
      final daysWorn = DateTime.now().difference(lastReplacement.date).inDays;
      if (daysWorn >= 0) {
        final activeCycle = LensCycle(
          startDate: lastReplacement.date,
          lensType: lensInfo.type,
          completedManually: false,
        );
        await saveActiveCycle(activeCycle);
        debugPrint('Created active cycle from last replacement');
      }
    } else if (lensInfo.firstUseDate != null) {
      final daysWorn = DateTime.now().difference(lensInfo.firstUseDate!).inDays;
      if (daysWorn >= 0) {
        final activeCycle = LensCycle(
          startDate: lensInfo.firstUseDate!,
          lensType: lensInfo.type,
          completedManually: false,
        );
        await saveActiveCycle(activeCycle);
        debugPrint('Created active cycle from firstUseDate');
      }
    }

    debugPrint('Migration completed');
  }

  // =======================================================================
  // РЎРћР‘Р«РўРРЇ Р’Р Р•РњР•РќРќРћР™ РЁРљРђР›Р« [file:15] 1.9
  // =======================================================================

  /// ?? РџРћР›РЈР§РРўР¬ РЎРћР‘Р«РўРРЇ Р’Р Р•РњР•РќРќРћР™ РЁРљРђР›Р« [file:15] 1.9
  List<TimelineEvent> getTimelineEvents() {
    final List<TimelineEvent> events = [];

    // Р—Р°РјРµРЅС‹
    for (var replacement in getLensReplacements()) {
      events.add(TimelineEvent(
        type: TimelineEventType.replacement,
        date: replacement.date,
        title: 'Lens replacement',
        description: 'New pair ${getLensInfo().type.label.toLowerCase()}',
        data: replacement,
      ));
    }

    // Symptoms
    for (var entry in getSymptomEntries()) {
      events.add(TimelineEvent(
        type: TimelineEventType.symptoms,
        date: entry.date,
        title: 'Symptoms',
        description:
            '${entry.symptoms.length} ${_getSymptomWord(entry.symptoms.length)}',
        data: entry,
      ));
    }

    // Stock
    for (var update in getStockUpdates()) {
      events.add(TimelineEvent(
        type: TimelineEventType.stock,
        date: update.date,
        title: 'Stock update',
        description: '${update.pairsCount} ${getPairWord(update.pairsCount)}',
        data: update,
      ));
    }

    // РџСЂРѕРІРµСЂРєРё Р·СЂРµРЅРёСЏ
    for (var check in getVisionChecks()) {
      events.add(TimelineEvent(
        type: TimelineEventType.vision,
        date: check.date,
        title: 'Vision check',
        description: 'SPH: ${check.leftSph} / ${check.rightSph}',
        data: check,
      ));
    }

    // Р—Р°РІРµСЂС€С‘РЅРЅС‹Рµ С†РёРєР»С‹
    for (var cycle in getCompletedCycles()) {
      if (cycle.endDate != null) {
        events.add(TimelineEvent(
          type: TimelineEventType.replacement,
          date: cycle.endDate!,
          title: cycle.completedManually ? 'Lens removal' : 'Lens replacement',
          description: cycle.completionDescription,
          data: cycle,
        ));
      }
    }

    // РЎРѕСЂС‚РёСЂРѕРІРєР°: РЅРѕРІС‹Рµ РїРµСЂРІС‹РјРё
    events.sort((a, b) => b.date.compareTo(a.date));
    return events;
  }

  /// РџРѕР»СѓС‡РёС‚СЊ РґРЅРё РЅРѕС€РµРЅРёСЏ (РґР»СЏ home_screen)
  /// РљРѕРіРґР° РЅРµС‚ Р°РєС‚РёРІРЅРѕРіРѕ С†РёРєР»Р° (СЃРЅСЏС‚РёРµ Р»РёРЅР·) вЂ” РІРѕР·РІСЂР°С‰Р°РµС‚ 0
  int getDaysWorn() {
    final activeCycle = getActiveCycle();
    if (activeCycle != null) {
      return activeCycle.daysWorn;
    }
    return 0;
  }

  // =======================================================================
  // Р’РЎРџРћРњРћР“РђРўР•Р›Р¬РќР«Р• РњР•РўРћР”Р« (РґР»СЏ app_navigation.dart)
  // =======================================================================

  /// РџРѕР»СѓС‡РёС‚СЊ С†РёРєР» РїРѕ ID (РґР»СЏ app_navigation.dart)
  Future<LensCycle?> getLensById(String lensId) async {
    if (lensId == 'current_lens' || lensId == 'current_lens_day') {
      return getActiveCycle();
    }

    // РџРѕРёСЃРє РїРѕ ID РІ Р·Р°РІРµСЂС€С‘РЅРЅС‹С… С†РёРєР»Р°С…
    final allCycles = getAllCycles();
    try {
      return allCycles.firstWhere((cycle) => _getCycleId(cycle) == lensId);
    } catch (_) {
      return null;
    }
  }

  /// РџРѕР»СѓС‡РёС‚СЊ ID С†РёРєР»Р°
  String _getCycleId(LensCycle cycle) {
    return cycle.replacementId ??
        'cycle_${cycle.startDate.millisecondsSinceEpoch}';
  }

  /// РћР±РЅРѕРІРёС‚СЊ С†РёРєР»
  Future<void> updateLens(LensCycle lens) async {
    if (lens.isActive) {
      await saveActiveCycle(lens);
    } else {
      final allCycles = getLensCycles();
      final lensId = _getCycleId(lens);
      final index = allCycles.indexWhere((c) => _getCycleId(c) == lensId);
      if (index != -1) {
        allCycles[index] = lens;
        await saveLensCycles(allCycles);
      }
    }
  }

  // =======================================================================
  // Р’РЎРџРћРњРћР“РђРўР•Р›Р¬РќР«Р• Р¤РЈРќРљР¦РР
  // =======================================================================

  String _getSymptomWord(int count) {
    if (count == 1) return 'symptom';
    if (count >= 2 && count <= 4) return 'symptoms';
    return 'symptoms';
  }

  // =======================================================================
  // РЎРРќРҐР РћРќРР—РђР¦РРЇ [Р·Р°РјРµРЅР° РґР°РЅРЅС‹С… РёР· РѕР±Р»Р°РєР°]
  // =======================================================================

  /// Replace РІСЃРµ РґР°РЅРЅС‹Рµ РёР· РѕР±Р»Р°С‡РЅРѕР№ СЃРёРЅС…СЂРѕРЅРёР·Р°С†РёРё
  Future<void> replaceAllFromSync(Map<String, dynamic> data) async {
    if (data['lens_info'] != null) {
      await saveLensInfo(
        LensInfo.fromJson(data['lens_info'] as Map<String, dynamic>),
      );
    }
    if (data['vision_checks'] != null) {
      final list = data['vision_checks'] as List;
      await _prefs.setString(
        _keyVisionChecks,
        jsonEncode(list),
      );
    }
    if (data['symptoms'] != null) {
      final list = data['symptoms'] as List;
      await _prefs.setString(_keySymptoms, jsonEncode(list));
    }
    if (data['replacements'] != null) {
      final list = data['replacements'] as List;
      await _prefs.setString(_keyReplacements, jsonEncode(list));
    }
    if (data['stock_updates'] != null) {
      final list = data['stock_updates'] as List;
      await _prefs.setString(_keyStockUpdates, jsonEncode(list));
    }
    if (data['current_stock'] != null) {
      await setCurrentStock(data['current_stock'] as int);
    }
    if (data['lens_cycles'] != null) {
      final list = data['lens_cycles'] as List;
      await _prefs.setString(_keyLensCycles, jsonEncode(list));
    }
    if (data['active_cycle'] != null) {
      await _prefs.setString(
        _keyActiveCycle,
        jsonEncode(data['active_cycle'] as Map<String, dynamic>),
      );
    } else {
      await _prefs.remove(_keyActiveCycle);
    }
    if (data['notifications_enabled'] != null) {
      await setNotificationsEnabled(data['notifications_enabled'] as bool);
    }
    if (data['notification_time'] != null) {
      await setNotificationTime(data['notification_time'] as String);
    }
    if (data['daily_hours_before_reminder'] != null) {
      await setDailyHoursBeforeReminder(
        data['daily_hours_before_reminder'] as int,
      );
    }
    if (data['daily_notify_at_expiry'] != null) {
      await setDailyNotifyAtExpiry(data['daily_notify_at_expiry'] as bool);
    }
    if (data['other_days_before_reminder'] != null) {
      await setOtherDaysBeforeReminder(
        data['other_days_before_reminder'] as int,
      );
    }
    if (data['stock_alert_threshold'] != null) {
      await setStockAlertThreshold(data['stock_alert_threshold'] as int);
    }
    if (data['tips_notifications_enabled'] != null) {
      await setTipsNotificationsEnabled(
        data['tips_notifications_enabled'] as bool,
      );
    }
    if (data['tips_notification_time'] != null) {
      await setTipsNotificationTime(
        data['tips_notification_time'] as String,
      );
    }
    if (data['solution_purchase_enabled'] != null) {
      await setSolutionPurchaseEnabled(
        data['solution_purchase_enabled'] as bool,
      );
    }
    if (data['solution_purchase_day_of_week'] != null) {
      await setSolutionPurchaseDayOfWeek(
        data['solution_purchase_day_of_week'] as int,
      );
    }
    if (data['solution_purchase_time'] != null) {
      await setSolutionPurchaseTime(
        data['solution_purchase_time'] as String,
      );
    }
    if (data['solution_purchase_period_months'] != null) {
      await setSolutionPurchasePeriodMonths(
        data['solution_purchase_period_months'] as int,
      );
    }
    if (data['low_stock_reminder_enabled'] != null) {
      await setLowStockReminderEnabled(
        data['low_stock_reminder_enabled'] as bool,
      );
    }
    if (data['low_stock_reminder_time'] != null) {
      await setLowStockReminderTime(
        data['low_stock_reminder_time'] as String,
      );
    }
    debugPrint('Data replaced from cloud sync');
  }

  // =======================================================================
  // РћР§РРЎРўРљРђ Р”РђРќРќР«РҐ [file:15] 2.6
  // =======================================================================

  /// РћС‡РёСЃС‚РєР° РёСЃС‚РѕСЂРёРё РїРѕР»СЊР·РѕРІР°С‚РµР»СЏ. РђРєРєР°СѓРЅС‚, С‚РёРї Р»РёРЅР· Рё РЅР°СЃС‚СЂРѕР№РєРё СЃРѕС…СЂР°РЅСЏСЋС‚СЃСЏ.
  /// Р’РђР–РќРћ: РўР°РєР¶Рµ РЅСѓР¶РЅРѕ РІС‹Р·РІР°С‚СЊ NotificationService().cancelAllNotifications()
  Future<void> clearUserData() async {
    const keysToRemove = [
      _keyVisionChecks,
      _keySymptoms,
      _keyReplacements,
      _keyStockUpdates,
      _keyCurrentStock,
      _keyLensCycles,
      _keyActiveCycle,
    ];
    for (final key in keysToRemove) {
      await _prefs.remove(key);
    }
    // РЎР±СЂР°СЃС‹РІР°РµРј firstUseDate РІ lens_info (СЃРІСЏР·Р°РЅ СЃ РёСЃС‚РѕСЂРёРµР№ Р·Р°РјРµРЅ)
    final lensInfo = getLensInfo();
    lensInfo.firstUseDate = null;
    await saveLensInfo(lensInfo);
    debugPrint('History cleared (account and settings preserved)');
  }

  /// ?? РџРћР›РќРђРЇ РћР§РРЎРўРљРђ [file:15] 2.6 вЂ” РІРєР»СЋС‡Р°СЏ РґР°РЅРЅС‹Рµ Р°РІС‚РѕСЂРёР·Р°С†РёРё
  /// РСЃРїРѕР»СЊР·СѓР№С‚Рµ clearUserData() РґР»СЏ РѕС‡РёСЃС‚РєРё С‚РѕР»СЊРєРѕ РёСЃС‚РѕСЂРёРё
  Future<void> clearAll() async {
    await _prefs.clear();
    debugPrint('All data cleared');
  }
}

