import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../theme/neon_theme.dart';
import '../../../theme/action_palette.dart';
import '../../../utils/intl_locale.dart';
import '../../domain/models/calendar_day_info.dart';
import '../../domain/models/calendar_month_data.dart';
import '../../domain/services/calendar_date_utils.dart';
import 'calendar_legend.dart';

class MonthSection extends StatelessWidget {
  const MonthSection({
    super.key,
    required this.data,
    required this.selectedDay,
    required this.daysIndex,
    required this.isNarrowScreen,
    required this.onDaySelected,
  });

  final CalendarMonthData data;
  final DateTime selectedDay;
  final Map<DateTime, CalendarDayInfo> daysIndex;
  final bool isNarrowScreen;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode.toLowerCase();
    final startsSunday = languageCode.startsWith('en');
    final calendarLocale =
        intlDateFormattingLocale(Localizations.localeOf(context));
    final colorScheme = Theme.of(context).colorScheme;
    final neon = context.neon;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.all(isNarrowScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: neon.ghostBorder),
        boxShadow: [
          BoxShadow(
            color: neon.glowColor.withValues(alpha: 0.35),
            blurRadius: neon.blurLg,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: TextStyle(
              fontSize: isNarrowScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          TableCalendar<dynamic>(
            firstDay: data.visibleDays.first,
            lastDay: data.visibleDays.last,
            focusedDay: data.visibleDays.first,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek:
                startsSunday ? StartingDayOfWeek.sunday : StartingDayOfWeek.monday,
            locale: calendarLocale,
            headerVisible: false,
            availableGestures: AvailableGestures.none,
            selectedDayPredicate: (day) => isSameDate(day, selectedDay),
            daysOfWeekHeight: isNarrowScreen ? 24 : 28,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: isNarrowScreen ? 11 : 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
              weekendStyle: TextStyle(
                fontSize: isNarrowScreen ? 11 : 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                gradient: neon.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              selectedDecoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              markerDecoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(
                fontSize: isNarrowScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
              weekendTextStyle: TextStyle(
                fontSize: isNarrowScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onDaySelected: (selectedDay, _) => onDaySelected(selectedDay),
            eventLoader: (day) => daysIndex[dateOnly(day)]?.events ?? const [],
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) =>
                  _buildDayCell(context, day),
              todayBuilder: (context, day, focusedDay) =>
                  _buildDayCell(context, day),
              selectedBuilder: (context, day, focusedDay) =>
                  _buildDayCell(context, day),
              markerBuilder: (context, date, events) => _buildMarkers(context, date),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildDayCell(BuildContext context, DateTime day) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final info = daysIndex[dateOnly(day)];
    final isWearDay = info?.isInWearCycle ?? false;
    final isNearReplacementWearDay = info?.isNearReplacementWearDay ?? false;
    final isOverdueWearDay = info?.isOverdueWearDay ?? false;
    final isToday = info?.isToday ?? isSameDate(day, DateTime.now());
    final isSelected = isSameDate(day, selectedDay);
    final usePrimaryContrastText = isToday || isSelected;
    final useSurfaceContrastText =
        isOverdueWearDay || isNearReplacementWearDay;
    final dayTextColor = isSelected
        ? (isDarkTheme ? const Color(0xFF111111) : Colors.white)
        : useSurfaceContrastText
            ? colorScheme.onSurface
            : usePrimaryContrastText
                ? colorScheme.onPrimary
                : colorScheme.onSurface;

    if (!isWearDay && !isToday && !isSelected) return null;

    final decoration = _buildDecoration(
      context,
      isWearDay: isWearDay,
      isNearReplacementWearDay: isNearReplacementWearDay,
      isOverdueWearDay: isOverdueWearDay,
      isToday: isToday,
      isSelected: isSelected,
    );

    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: decoration,
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: TextStyle(
            fontSize: isNarrowScreen ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: dayTextColor,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(
    BuildContext context, {
    required bool isWearDay,
    required bool isNearReplacementWearDay,
    required bool isOverdueWearDay,
    required bool isToday,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final neon = context.neon;
    final actions = context.actionPalette;
    final overdueColor = isDarkTheme ? actions.attention : actions.overdue;

    if (isOverdueWearDay) {
      if (isSelected) {
        return BoxDecoration(
          color: overdueColor.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(8),
        );
      }

      return BoxDecoration(
        color: overdueColor.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(8),
      );
    }

    if (isNearReplacementWearDay && isDarkTheme) {
      if (isSelected) {
        return BoxDecoration(
          color: actions.attention.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(8),
        );
      }

      return BoxDecoration(
        color: actions.attention.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(8),
      );
    }

    if (isToday) {
      return BoxDecoration(
        gradient: neon.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      );
    }

    if (isSelected) {
      return BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
      );
    }

    if (isWearDay) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            actions.removal.withValues(alpha: 0.20),
            actions.removal.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      );
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget? _buildMarkers(BuildContext context, DateTime day) {
    final info = daysIndex[dateOnly(day)];
    if (info == null || info.events.isEmpty) return null;

    final markerColors = <Color>[];
    for (final event in info.events) {
      final color = markerColorForEvent(
        context,
        event,
        isLowStockDay: info.isLowStockDay,
      );
      if (!markerColors.contains(color)) {
        markerColors.add(color);
      }
    }

    return Positioned(
      bottom: 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: markerColors.map((markerColor) {
          return Container(
            width: isNarrowScreen ? 5 : 6,
            height: isNarrowScreen ? 5 : 6,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: markerColor,
              shape: BoxShape.circle,
              border: Border.all(color: markerColor, width: 0.5),
            ),
          );
        }).toList(),
      ),
    );
  }
}


