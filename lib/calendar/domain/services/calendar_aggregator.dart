import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../l10n/app_localizations.dart';
import '../../../models/lens_data.dart';
import '../models/calendar_day_info.dart';
import '../models/calendar_month_data.dart';
import '../models/day_event.dart';
import '../models/wear_range_position.dart';
import '../models/year_month.dart';
import 'calendar_date_utils.dart';

class CalendarBuildResult {
  const CalendarBuildResult({
    required this.availableYears,
    required this.months,
    required this.daysIndex,
    required this.initialScrollTarget,
  });

  final List<int> availableYears;
  final List<CalendarMonthData> months;
  final Map<DateTime, CalendarDayInfo> daysIndex;
  final YearMonth initialScrollTarget;
}

class CalendarAggregator {
  CalendarBuildResult build({
    required CalendarRawData rawData,
    required int? selectedYear,
    required DateTime selectedDay,
    required DateTime today,
    required String dateFormattingLocale,
    required AppLocalizations l10n,
    int monthsBefore = 6,
    int monthsAfter = 12,
  }) {
    final normalizedToday = dateOnly(today);
    final normalizedSelectedDay = dateOnly(selectedDay);
    final years = _buildAvailableYears(rawData, normalizedToday.year);
    final months = _buildMonths(
      availableYears: years,
      selectedYear: selectedYear,
      today: normalizedToday,
      monthsBefore: monthsBefore,
      monthsAfter: monthsAfter,
      dateFormattingLocale: dateFormattingLocale,
    );
    final visibleYears = months.map((month) => month.year).toSet();
    final daysIndex = _buildDaysIndex(
      rawData: rawData,
      visibleYears: visibleYears,
      selectedDay: normalizedSelectedDay,
      today: normalizedToday,
      l10n: l10n,
    );

    return CalendarBuildResult(
      availableYears: years,
      months: months,
      daysIndex: daysIndex,
      initialScrollTarget: _resolveScrollTarget(
        selectedYear: selectedYear,
        today: normalizedToday,
        months: months,
      ),
    );
  }

  List<int> _buildAvailableYears(CalendarRawData rawData, int currentYear) {
    final recordYears = <int>{};

    for (final cycle in rawData.cycles) {
      recordYears.add(cycle.startDate.year);
      if (cycle.endDate != null) {
        recordYears.add(cycle.endDate!.year);
      }
    }
    for (final replacement in rawData.replacements) {
      recordYears.add(replacement.date.year);
    }
    for (final symptom in rawData.symptoms) {
      recordYears.add(symptom.date.year);
    }
    for (final visionCheck in rawData.visionChecks) {
      recordYears.add(visionCheck.date.year);
    }
    for (final stockUpdate in rawData.stockUpdates) {
      recordYears.add(stockUpdate.date.year);
    }

    if (recordYears.isEmpty) {
      return <int>[currentYear];
    }

    final minRecordYear = recordYears.reduce(math.min);
    final maxRecordYear = recordYears.reduce(math.max);
    final years = <int>{currentYear};
    for (var year = minRecordYear - 1; year <= maxRecordYear + 1; year++) {
      years.add(year);
    }

    final result = years.toList()..sort((a, b) => b.compareTo(a));
    return result;
  }

  List<CalendarMonthData> _buildMonths({
    required List<int> availableYears,
    required int? selectedYear,
    required DateTime today,
    required int monthsBefore,
    required int monthsAfter,
    required String dateFormattingLocale,
  }) {
    final monthStarts = <DateTime>[];
    if (selectedYear == null) {
      if (availableYears.isNotEmpty) {
        final minYear = availableYears.reduce(math.min);
        final maxYear = availableYears.reduce(math.max);
        for (var year = minYear; year <= maxYear; year++) {
          for (var month = 1; month <= 12; month++) {
            monthStarts.add(DateTime(year, month, 1));
          }
        }
      } else {
        for (var i = -monthsBefore; i <= monthsAfter; i++) {
          monthStarts.add(DateTime(today.year, today.month + i, 1));
        }
      }
    } else {
      for (var month = 1; month <= 12; month++) {
        monthStarts.add(DateTime(selectedYear, month, 1));
      }
    }

    return monthStarts
        .map(
          (month) => CalendarMonthData(
            year: month.year,
            month: month.month,
            title: DateFormat('LLLL yyyy', dateFormattingLocale).format(month),
            visibleDays: List.generate(
              DateTime(month.year, month.month + 1, 0).day,
              (index) => DateTime(month.year, month.month, index + 1),
            ),
          ),
        )
        .toList();
  }

  Map<DateTime, CalendarDayInfo> _buildDaysIndex({
    required CalendarRawData rawData,
    required Set<int> visibleYears,
    required DateTime selectedDay,
    required DateTime today,
    required AppLocalizations l10n,
  }) {
    final index = <DateTime, _MutableDayInfo>{};

    void ensureDay(DateTime date) {
      final normalized = dateOnly(date);
      if (!visibleYears.contains(normalized.year)) return;
      index.putIfAbsent(
        normalized,
        () => _MutableDayInfo(
          date: normalized,
          isToday: normalized == today,
          isSelected: normalized == selectedDay,
        ),
      );
    }

    void addEvent(DayEvent event) {
      ensureDay(event.date);
      final info = index[dateOnly(event.date)];
      if (info == null) return;
      info.events.add(event);
    }

    for (final replacement in rawData.replacements) {
      addEvent(
        DayEvent(
          type: DayEventType.replacement,
          date: replacement.date,
          title: l10n.calendarReplacementTitle,
          subtitle: replacement.notes,
          payload: replacement,
        ),
      );
    }

    for (final symptom in rawData.symptoms) {
      addEvent(
        DayEvent(
          type: DayEventType.symptom,
          date: symptom.date,
          title: symptom.isManualRemoval
              ? l10n.calendarManualRemoval
              : l10n.calendarSymptomsTitle,
          subtitle: symptom.notes,
          payload: symptom,
        ),
      );
    }

    for (final visionCheck in rawData.visionChecks) {
      addEvent(
        DayEvent(
          type: DayEventType.visionCheck,
          date: visionCheck.date,
          title: l10n.calendarVisionTitle,
          subtitle: 'SPH: ${visionCheck.leftSph} / ${visionCheck.rightSph}',
          payload: visionCheck,
        ),
      );
    }

    for (final stockUpdate in rawData.stockUpdates) {
      final isLowStock = stockUpdate.pairsCount < rawData.stockAlertThreshold;
      addEvent(
        DayEvent(
          type: DayEventType.stockUpdate,
          date: stockUpdate.date,
          title: l10n.calendarStockUpdateTitle,
          subtitle: '${l10n.calendarStockLabel}: ${stockUpdate.pairsCount}',
          payload: stockUpdate,
        ),
      );
      ensureDay(stockUpdate.date);
      final info = index[dateOnly(stockUpdate.date)];
      if (info != null && isLowStock) {
        info.isLowStockDay = true;
      }
    }

    for (final cycle in rawData.cycles) {
      final start = dateOnly(cycle.startDate);
      final end = dateOnly(cycle.endDate ?? today);
      if (end.isBefore(start)) continue;

      DateTime cursor = start;
      while (!cursor.isAfter(end)) {
        if (visibleYears.contains(cursor.year)) {
          ensureDay(cursor);
          final info = index[cursor]!;
          info.isInWearCycle = true;
          info.isNearReplacementWearDay = info.isNearReplacementWearDay ||
              _isNearReplacementWearDayInCycle(
                cycle: cycle,
                day: cursor,
              );
          info.isOverdueWearDay = info.isOverdueWearDay ||
              _isOverdueWearDayInCycle(
                cycle: cycle,
                day: cursor,
                today: today,
              );
          info.wearPosition = _resolveWearPosition(
            day: cursor,
            cycleStart: start,
            cycleEnd: end,
          );
        }
        cursor = cursor.add(const Duration(days: 1));
      }
    }

    return Map<DateTime, CalendarDayInfo>.fromEntries(
      index.entries.map(
        (entry) => MapEntry(
          entry.key,
          CalendarDayInfo(
            date: entry.value.date,
            isInWearCycle: entry.value.isInWearCycle,
            wearPosition: entry.value.wearPosition,
            isNearReplacementWearDay: entry.value.isNearReplacementWearDay,
            isOverdueWearDay: entry.value.isOverdueWearDay,
            isLowStockDay: entry.value.isLowStockDay,
            events: List.unmodifiable(entry.value.events),
            isToday: entry.value.isToday,
            isSelected: entry.value.isSelected,
          ),
        ),
      ),
    );
  }

  WearRangePosition _resolveWearPosition({
    required DateTime day,
    required DateTime cycleStart,
    required DateTime cycleEnd,
  }) {
    if (cycleStart == cycleEnd) return WearRangePosition.single;
    if (day == cycleStart) return WearRangePosition.start;
    if (day == cycleEnd) return WearRangePosition.end;
    return WearRangePosition.middle;
  }

  bool _isOverdueWearDayInCycle({
    required LensCycle cycle,
    required DateTime day,
    required DateTime today,
  }) {
    final cycleStart = dateOnly(cycle.startDate);
    final cycleEnd = dateOnly(cycle.endDate ?? today);
    if (day.isBefore(cycleStart) || day.isAfter(cycleEnd)) return false;

    if (cycle.lensType == LensType.daily) {
      final effectiveEnd = cycle.endDate ?? DateTime.now();
      final overdueMoment = cycle.startDate.add(const Duration(hours: 14));
      if (!effectiveEnd.isAfter(overdueMoment)) return false;
      final overdueStartDay = dateOnly(overdueMoment);
      return !day.isBefore(overdueStartDay);
    }

    final dayIndex = day.difference(cycleStart).inDays + 1;
    return dayIndex > cycle.lensType.days;
  }

  bool _isNearReplacementWearDayInCycle({
    required LensCycle cycle,
    required DateTime day,
  }) {
    final cycleStart = dateOnly(cycle.startDate);
    if (day.isBefore(cycleStart)) return false;
    if (cycle.lensType == LensType.daily) return false;

    final dayIndex = day.difference(cycleStart).inDays + 1;
    if (dayIndex > cycle.lensType.days) return false;

    final threshold = cycle.lensType.nearEndThreshold;
    return dayIndex >= cycle.lensType.days - threshold;
  }

  YearMonth _resolveScrollTarget({
    required int? selectedYear,
    required DateTime today,
    required List<CalendarMonthData> months,
  }) {
    final target = selectedYear == null
        ? YearMonth(today.year, today.month)
        : YearMonth(selectedYear, selectedYear == today.year ? today.month : 1);

    final hasTarget = months.any(
      (month) => month.year == target.year && month.month == target.month,
    );
    return hasTarget ? target : months.first.yearMonth;
  }
}

class _MutableDayInfo {
  _MutableDayInfo({
    required this.date,
    required this.isToday,
    required this.isSelected,
  });

  final DateTime date;
  final bool isToday;
  final bool isSelected;
  bool isInWearCycle = false;
  WearRangePosition wearPosition = WearRangePosition.none;
  bool isNearReplacementWearDay = false;
  bool isOverdueWearDay = false;
  bool isLowStockDay = false;
  final List<DayEvent> events = [];
}

