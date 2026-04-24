import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/action_palette.dart';
import '../../../utils/intl_locale.dart';
import '../../domain/models/calendar_day_info.dart';
import '../../domain/models/calendar_month_data.dart';
import '../../domain/models/day_details_data.dart';
import '../../domain/models/day_event.dart';
import '../../domain/models/year_month.dart';
import '../state/calendar_state.dart';
import 'calendar_legend.dart';
import 'day_details_sheet.dart';
import 'month_section.dart';
import 'year_selector.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({
    super.key,
    required this.state,
    required this.onYearSelected,
    required this.onDaySelected,
    required this.onRequestDayDetails,
  });

  final CalendarState state;
  final ValueChanged<int?> onYearSelected;
  final ValueChanged<DateTime> onDaySelected;
  final DayDetailsData? Function(DateTime day) onRequestDayDetails;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  static const double _estimatedMonthHeight = 380;

  final ScrollController _scrollController = ScrollController();
  final Map<YearMonth, GlobalKey> _monthKeys = {};
  YearMonth? _lastScrollTarget;
  _CalendarDisplayMode _displayMode = _CalendarDisplayMode.month;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_displayMode == _CalendarDisplayMode.month) {
        _scrollToTarget(widget.state.initialScrollTarget);
      }
    });
  }

  @override
  void didUpdateWidget(covariant CalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_displayMode != _CalendarDisplayMode.month) return;

    final target = widget.state.initialScrollTarget;
    final finishedLoading = oldWidget.state.isLoading && !widget.state.isLoading;
    if (_lastScrollTarget != target || finishedLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget(target));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrowScreen = MediaQuery.of(context).size.width < 360;
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.state.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    if (widget.state.errorMessage != null) {
      return Center(
        child: Text(
          widget.state.errorMessage!,
          style: TextStyle(color: colorScheme.onSurface),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            isNarrowScreen ? 16 : 24,
            12,
            isNarrowScreen ? 16 : 24,
            8,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildModeToggle(context),
          ),
        ),
        if (_displayMode == _CalendarDisplayMode.year)
          Padding(
            padding: EdgeInsets.fromLTRB(
              isNarrowScreen ? 16 : 24,
              0,
              isNarrowScreen ? 16 : 24,
              8,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: YearSelector(
                availableYears: widget.state.availableYears,
                selectedYear: widget.state.selectedYear,
                onYearSelected: widget.onYearSelected,
                showAllOption: false,
              ),
            ),
          ),
        Expanded(
          child: _displayMode == _CalendarDisplayMode.month
              ? _buildMonthMode(isNarrowScreen)
              : _buildYearMode(isNarrowScreen),
        ),
      ],
    );
  }

  Widget _buildModeToggle(BuildContext context) {
    final isRu = Localizations.localeOf(context).languageCode.toLowerCase() == 'ru';
    final monthLabel = isRu ? 'Месяц' : 'Month';
    final yearLabel = isRu ? 'Год' : 'Year';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ModeChip(
          label: monthLabel,
          selected: _displayMode == _CalendarDisplayMode.month,
          onTap: () => _setDisplayMode(_CalendarDisplayMode.month),
        ),
        const SizedBox(width: 10),
        _ModeChip(
          label: yearLabel,
          selected: _displayMode == _CalendarDisplayMode.year,
          onTap: () => _setDisplayMode(_CalendarDisplayMode.year),
        ),
      ],
    );
  }

  Widget _buildMonthMode(bool isNarrowScreen) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        left: isNarrowScreen ? 16 : 24,
        right: isNarrowScreen ? 16 : 24,
        bottom: 24,
      ),
      itemCount: widget.state.months.length,
      itemBuilder: (context, index) {
        final month = widget.state.months[index];
        final key = _monthKeys.putIfAbsent(month.yearMonth, GlobalKey.new);
        return KeyedSubtree(
          key: key,
          child: MonthSection(
            data: month,
            selectedDay: widget.state.selectedDay,
            daysIndex: widget.state.daysIndex,
            isNarrowScreen: isNarrowScreen,
            onDaySelected: (day) => _handleDaySelected(context, day),
          ),
        );
      },
    );
  }

  Widget _buildYearMode(bool isNarrowScreen) {
    final selectedYear = widget.state.selectedYear ?? widget.state.selectedDay.year;
    final byMonth = <int, CalendarMonthData>{
      for (final month in widget.state.months.where((m) => m.year == selectedYear))
        month.month: month,
    };

    final months = List<CalendarMonthData>.generate(12, (index) {
      final month = index + 1;
      final existing = byMonth[month];
      if (existing != null) return existing;
      final daysInMonth = DateTime(selectedYear, month + 1, 0).day;
      return CalendarMonthData(
        year: selectedYear,
        month: month,
        title: '',
        visibleDays: List.generate(
          daysInMonth,
          (day) => DateTime(selectedYear, month, day + 1),
        ),
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final horizontalPadding = isNarrowScreen ? 16.0 : 24.0;
        final contentWidth = constraints.maxWidth - horizontalPadding * 2;
        final columns = contentWidth >= 900
            ? 3
            : contentWidth >= 320
                ? 2
                : 1;
        final itemWidth = (contentWidth - spacing * (columns - 1)) / columns;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            24,
          ),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: months
                .map(
                  (month) => SizedBox(
                    width: itemWidth,
                    child: _MiniMonthSection(
                      data: month,
                      selectedDay: widget.state.selectedDay,
                      daysIndex: widget.state.daysIndex,
                      onDayTap: (day) => _handleDaySelected(context, day),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _setDisplayMode(_CalendarDisplayMode mode) {
    if (_displayMode == mode) return;
    setState(() => _displayMode = mode);

    if (mode == _CalendarDisplayMode.month) {
      widget.onYearSelected(null);
      return;
    }

    final availableYears = widget.state.availableYears;
    final currentYear = widget.state.selectedDay.year;
    final targetYear = availableYears.contains(currentYear)
        ? currentYear
        : (availableYears.isNotEmpty ? availableYears.first : DateTime.now().year);
    widget.onYearSelected(targetYear);
  }

  void _handleDaySelected(BuildContext context, DateTime day) {
    widget.onDaySelected(day);
    final details = widget.onRequestDayDetails(day);
    if (details == null) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DayDetailsSheet(data: details),
    );
  }

  void _scrollToTarget(YearMonth target) {
    if (!mounted) return;

    final targetContext = _monthKeys[target]?.currentContext;
    if (targetContext != null) {
      _lastScrollTarget = target;
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      return;
    }

    final targetIndex = widget.state.months.indexWhere(
      (month) => month.year == target.year && month.month == target.month,
    );
    if (targetIndex < 0 || !_scrollController.hasClients) return;

    _lastScrollTarget = target;
    final offset = targetIndex * _estimatedMonthHeight;
    final maxOffset = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(offset.clamp(0, maxOffset));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final builtContext = _monthKeys[target]?.currentContext;
      if (builtContext == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget(target));
        return;
      }
      Scrollable.ensureVisible(
        builtContext,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    });
  }
}

enum _CalendarDisplayMode { month, year }

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniMonthSection extends StatelessWidget {
  const _MiniMonthSection({
    required this.data,
    required this.selectedDay,
    required this.daysIndex,
    required this.onDayTap,
  });

  final CalendarMonthData data;
  final DateTime selectedDay;
  final Map<DateTime, CalendarDayInfo> daysIndex;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = intlDateFormattingLocale(Localizations.localeOf(context));
    final isEnglish =
        Localizations.localeOf(context).languageCode.toLowerCase().startsWith('en');
    final startsSunday = isEnglish;
    final monthLabel = DateFormat('LLLL', locale).format(DateTime(data.year, data.month, 1));
    final weekdays = _weekdayLabels(locale, startsSunday: startsSunday);
    final firstWeekday = DateTime(data.year, data.month, 1).weekday;
    final leading = startsSunday ? (firstWeekday % 7) : (firstWeekday - 1);
    final totalDays = DateTime(data.year, data.month + 1, 0).day;
    final totalCells = ((leading + totalDays + 6) ~/ 7) * 7;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _capitalize(monthLabel),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          if (!isEnglish) ...[
            Row(
              children: [
                for (final label in weekdays)
                  Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          const SizedBox(height: 4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - leading + 1;
              if (index < leading || dayNumber > totalDays) {
                return const SizedBox.shrink();
              }
              final day = DateTime(data.year, data.month, dayNumber);
              return _MiniDayCell(
                day: day,
                info: daysIndex[DateTime(day.year, day.month, day.day)],
                isSelected: DateUtils.isSameDay(day, selectedDay),
                onTap: () => onDayTap(day),
              );
            },
          ),
        ],
      ),
    );
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  static List<String> _weekdayLabels(
    String locale, {
    required bool startsSunday,
  }) {
    final monday = DateTime(2024, 1, 1);
    final labels = List<String>.generate(
      7,
      (index) => DateFormat('EE', locale)
          .format(monday.add(Duration(days: index)))
          .toLowerCase(),
    );
    if (!startsSunday) return labels;
    return <String>[labels.last, ...labels.take(6)];
  }
}

class _MiniDayCell extends StatelessWidget {
  const _MiniDayCell({
    required this.day,
    required this.info,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime day;
  final CalendarDayInfo? info;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final actions = context.actionPalette;

    final isWearDay = info?.isInWearCycle ?? false;
    final isNearReplacementWearDay = info?.isNearReplacementWearDay ?? false;
    final isOverdueWearDay = info?.isOverdueWearDay ?? false;
    final isToday = info?.isToday ?? DateUtils.isSameDay(day, DateTime.now());
    final overdueColor = isDarkTheme ? actions.attention : actions.overdue;

    final decoration = _buildDecoration(
      colorScheme: colorScheme,
      actions: actions,
      overdueColor: overdueColor,
      isDarkTheme: isDarkTheme,
      isWearDay: isWearDay,
      isNearReplacementWearDay: isNearReplacementWearDay,
      isOverdueWearDay: isOverdueWearDay,
      isToday: isToday,
      isSelected: isSelected,
    );

    final dayTextColor = isSelected
        ? (isDarkTheme ? const Color(0xFF111111) : Colors.white)
        : (isOverdueWearDay || isNearReplacementWearDay)
            ? colorScheme.onSurface
            : isToday
                ? colorScheme.onPrimary
                : colorScheme.onSurface;

    final markerColors = <Color>[];
    final events = info?.events ?? const <DayEvent>[];
    for (final event in events) {
      final color = markerColorForEvent(
        context,
        event,
        isLowStockDay: info?.isLowStockDay ?? false,
      );
      if (!markerColors.contains(color)) {
        markerColors.add(color);
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: decoration,
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: dayTextColor,
                ),
              ),
            ),
          ),
          if (markerColors.isNotEmpty)
            Positioned(
              bottom: 1,
              child: Row(
                children: markerColors.take(3).map((color) {
                  return Container(
                    width: 3,
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 0.8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration({
    required ColorScheme colorScheme,
    required ActionPalette actions,
    required Color overdueColor,
    required bool isDarkTheme,
    required bool isWearDay,
    required bool isNearReplacementWearDay,
    required bool isOverdueWearDay,
    required bool isToday,
    required bool isSelected,
  }) {
    if (isOverdueWearDay) {
      return BoxDecoration(
        color: overdueColor.withValues(alpha: isSelected ? 0.85 : 0.24),
        borderRadius: BorderRadius.circular(6),
      );
    }

    if (isNearReplacementWearDay && isDarkTheme) {
      return BoxDecoration(
        color: actions.attention.withValues(alpha: isSelected ? 0.82 : 0.22),
        borderRadius: BorderRadius.circular(6),
      );
    }

    if (isToday) {
      return BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
      );
    }

    if (isSelected) {
      return BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(6),
      );
    }

    if (isWearDay) {
      return BoxDecoration(
        color: actions.removal.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(6),
      );
    }

    return const BoxDecoration();
  }
}
