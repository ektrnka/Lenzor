// services/home_widget_service.dart

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import 'app_locale_controller.dart';
import 'lens_data_service.dart';
import '../models/lens_data.dart';

/// Сервис обновления виджета «До замены линз» на рабочем столе Android.
class HomeWidgetService {
  static const String _androidName = 'LensWidgetProvider';
  static const String _qualifiedAndroidName =
      'com.example.my_button_app_new.LensWidgetProvider';

  /// Обновляет данные виджета и триггерит перерисовку.
  /// Сохраняем сырые данные (startDate, lensType), чтобы нативный виджет
  /// мог вычислять актуальное значение при каждом onUpdate (в т.ч. в фоне).
  static Future<void> updateLensWidget(LensDataService dataService) async {
    if (!Platform.isAndroid) return;

    try {
      final activeCycle = dataService.getActiveCycle();
      final lensInfo = dataService.getLensInfo();
      await HomeWidget.saveWidgetData<String>(
        'lens_language_code',
        AppLocaleController.currentLanguageCode,
      );

      if (activeCycle == null) {
        await HomeWidget.saveWidgetData<String>('lens_start_date_millis', '0');
        await HomeWidget.saveWidgetData<String>(
            'lens_label', _labelUntilReplacement);
      } else {
        await HomeWidget.saveWidgetData<String>(
          'lens_start_date_millis',
          '${activeCycle.startDate.millisecondsSinceEpoch}',
        );
        await HomeWidget.saveWidgetData<String>(
          'lens_type',
          lensInfo.type.name,
        );
        await HomeWidget.saveWidgetData<int>(
          'lens_total_days',
          lensInfo.type.days,
        );
        final isOverdue = _isOverdue(activeCycle, lensInfo);
        await HomeWidget.saveWidgetData<String>(
          'lens_label',
          isOverdue ? _labelOverdueBy : _labelUntilReplacement,
        );
      }
      // Fallback для обратной совместимости (нативный код приоритетно использует сырые данные)
      await HomeWidget.saveWidgetData<String>(
        'lens_remaining_text',
        _computeValue(activeCycle, lensInfo),
      );

      await HomeWidget.updateWidget(
        name: _androidName,
        androidName: _androidName,
        qualifiedAndroidName: _qualifiedAndroidName,
      );
    } catch (e, st) {
      debugPrint('⚠️ HomeWidgetService.updateLensWidget: $e\n$st');
    }
  }

  static bool _isOverdue(LensCycle activeCycle, LensInfo lensInfo) {
    if (lensInfo.type == LensType.daily) {
      final hoursPassed = DateTime.now().difference(activeCycle.startDate).inHours;
      return hoursPassed >= 14;
    }
    final totalDays = lensInfo.type.days;
    var daysWorn = activeCycle.daysWorn;
    if (daysWorn <= 0) daysWorn = 1;
    return daysWorn > totalDays;
  }

  static String _computeValue(
    LensCycle? activeCycle,
    LensInfo lensInfo,
  ) {
    if (activeCycle == null) return '—';
    if (lensInfo.type == LensType.daily) {
      final now = DateTime.now();
      final hoursPassed = now.difference(activeCycle.startDate).inHours;
      const maxHours = 14;
      final isOverdue = hoursPassed >= maxHours;
      if (isOverdue) {
        return '${hoursPassed - maxHours} ${_getHoursLabel(hoursPassed - maxHours)}';
      } else {
        final hoursRemaining = (maxHours - hoursPassed).clamp(0, maxHours);
        return '$hoursRemaining ${_getHoursLabel(hoursRemaining)}';
      }
    } else {
      final totalDays = lensInfo.type.days;
      var daysWorn = activeCycle.daysWorn;
      if (daysWorn <= 0) daysWorn = 1;
      final isOverdue = daysWorn > totalDays;
      if (isOverdue) {
        return '${daysWorn - totalDays} ${_getDaysLabel(daysWorn - totalDays)}';
      } else {
        final daysRemaining = (totalDays - daysWorn).clamp(0, totalDays);
        return '$daysRemaining ${_getDaysLabel(daysRemaining)}';
      }
    }
  }

  static String _getHoursLabel(int hours) {
    if (_isRussian) {
      if (hours % 10 == 1 && hours % 100 != 11) return 'час';
      if ([2, 3, 4].contains(hours % 10) &&
          ![12, 13, 14].contains(hours % 100)) {
        return 'часа';
      }
      return 'часов';
    }
    return hours == 1 ? 'hour' : 'hours';
  }

  static String _getDaysLabel(int days) {
    if (_isRussian) {
      if (days % 10 == 1 && days % 100 != 11) return 'день';
      if ([2, 3, 4].contains(days % 10) &&
          ![12, 13, 14].contains(days % 100)) {
        return 'дня';
      }
      return 'дней';
    }
    return days == 1 ? 'day' : 'days';
  }

  static bool get _isRussian => AppLocaleController.currentLanguageCode == 'ru';

  static String get _labelUntilReplacement =>
      _isRussian ? 'До замены линз' : 'Until replacement';

  static String get _labelOverdueBy =>
      _isRussian ? 'Линзы просрочены на' : 'Overdue by';
}

