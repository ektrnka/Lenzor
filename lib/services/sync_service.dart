import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';
import '../services/lens_data_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._();
  factory SyncService() => _instance;

  SyncService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  static const String _collectionUsers = 'users';

  bool get canSync => _auth.isFirebaseReady && _auth.isSignedIn;

  String? get _userDocPath {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) return null;
    return '$_collectionUsers/$uid';
  }

  Map<String, dynamic> _exportAllData(LensDataService dataService) {
    final lensInfo = dataService.getLensInfo();
    final visionChecks = dataService.getVisionChecks();
    final symptomEntries = dataService.getSymptomEntries();
    final replacements = dataService.getLensReplacements();
    final stockUpdates = dataService.getStockUpdates();
    final currentStock = dataService.getCurrentStock();
    final lensCycles = dataService.getLensCycles();
    final activeCycle = dataService.getActiveCycle();

    return {
      'lens_info': lensInfo.toJson(),
      'vision_checks': visionChecks.map((c) => c.toJson()).toList(),
      'symptoms': symptomEntries.map((e) => e.toJson()).toList(),
      'replacements': replacements.map((r) => r.toJson()).toList(),
      'stock_updates': stockUpdates.map((u) => u.toJson()).toList(),
      'current_stock': currentStock,
      'lens_cycles': lensCycles.map((c) => c.toJson()).toList(),
      'active_cycle': activeCycle?.toJson(),
      'notifications_enabled': dataService.getNotificationsEnabled(),
      'notification_time': dataService.getNotificationTime(),
      'daily_hours_before_reminder': dataService.getDailyHoursBeforeReminder(),
      'daily_notify_at_expiry': dataService.getDailyNotifyAtExpiry(),
      'other_days_before_reminder': dataService.getOtherDaysBeforeReminder(),
      'stock_alert_threshold': dataService.getStockAlertThreshold(),
      'tips_notifications_enabled': dataService.getTipsNotificationsEnabled(),
      'tips_notification_time': dataService.getTipsNotificationTime(),
      'solution_purchase_enabled': dataService.getSolutionPurchaseEnabled(),
      'solution_purchase_day_of_week': dataService.getSolutionPurchaseDayOfWeek(),
      'solution_purchase_time': dataService.getSolutionPurchaseTime(),
      'solution_purchase_period_months':
          dataService.getSolutionPurchasePeriodMonths(),
      'low_stock_reminder_enabled': dataService.getLowStockReminderEnabled(),
      'low_stock_reminder_time': dataService.getLowStockReminderTime(),
      'synced_at': FieldValue.serverTimestamp(),
    };
  }

  Future<bool> hasCloudData() async {
    if (!canSync) return false;
    final path = _userDocPath;
    if (path == null) return false;
    try {
      final doc = await _firestore.doc(path).get();
      if (!doc.exists || doc.data() == null) return false;
      final d = doc.data()!;
      return (d['lens_cycles'] as List?)?.isNotEmpty == true ||
          (d['replacements'] as List?)?.isNotEmpty == true ||
          (d['vision_checks'] as List?)?.isNotEmpty == true ||
          (d['symptoms'] as List?)?.isNotEmpty == true ||
          d['active_cycle'] != null;
    } catch (_) {
      return false;
    }
  }

  Future<bool> pullFromCloud(LensDataService dataService) async {
    if (!canSync) return false;
    final path = _userDocPath;
    if (path == null) return false;

    try {
      final doc = await _firestore.doc(path).get();
      if (doc.exists && doc.data() != null) {
        await dataService.replaceAllFromSync(doc.data()!);
        debugPrint('Sync: cloud data pulled');
        return true;
      }
    } catch (e) {
      debugPrint('Sync pull error: $e');
      rethrow;
    }
    return true;
  }

  Future<bool> pushToCloud(LensDataService dataService) async {
    if (!canSync) return false;
    final path = _userDocPath;
    if (path == null) return false;

    final data = _exportAllData(dataService);
    await _firestore.doc(path).set(data, SetOptions(merge: true));
    debugPrint('Sync: cloud data pushed');
    return true;
  }

  String _formatError(Object e) {
    if (e is FirebaseException) {
      final code = e.code;
      final msg = e.message ?? '';
      if (msg.isNotEmpty) return '$code: $msg';
      return code;
    }
    return e.toString().split('\n').first;
  }

  Future<String?> sync(LensDataService dataService) async {
    if (!canSync) return 'Sync is unavailable';
    try {
      await pushToCloud(dataService);
      await pullFromCloud(dataService);
      return null;
    } catch (e) {
      debugPrint('Sync error: $e');
      return _formatError(e);
    }
  }
}

