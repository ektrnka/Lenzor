import '../../domain/models/calendar_day_info.dart';
import '../../domain/models/calendar_month_data.dart';
import '../../domain/models/year_month.dart';

class CalendarState {
  const CalendarState({
    required this.isLoading,
    required this.selectedYear,
    required this.selectedDay,
    required this.availableYears,
    required this.months,
    required this.daysIndex,
    required this.initialScrollTarget,
    this.errorMessage,
  });

  factory CalendarState.initial(DateTime today) {
    final normalized = DateTime(today.year, today.month, today.day);
    return CalendarState(
      isLoading: true,
      selectedYear: null,
      selectedDay: normalized,
      availableYears: const [],
      months: const [],
      daysIndex: const <DateTime, CalendarDayInfo>{},
      initialScrollTarget: YearMonth(normalized.year, normalized.month),
    );
  }

  final bool isLoading;
  final int? selectedYear;
  final DateTime selectedDay;
  final List<int> availableYears;
  final List<CalendarMonthData> months;
  final Map<DateTime, CalendarDayInfo> daysIndex;
  final YearMonth initialScrollTarget;
  final String? errorMessage;

  CalendarDayInfo? infoForDay(DateTime day) => daysIndex[DateTime(day.year, day.month, day.day)];

  CalendarState copyWith({
    bool? isLoading,
    int? selectedYear,
    bool clearSelectedYear = false,
    DateTime? selectedDay,
    List<int>? availableYears,
    List<CalendarMonthData>? months,
    Map<DateTime, CalendarDayInfo>? daysIndex,
    YearMonth? initialScrollTarget,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      selectedYear: clearSelectedYear ? null : (selectedYear ?? this.selectedYear),
      selectedDay: selectedDay ?? this.selectedDay,
      availableYears: availableYears ?? this.availableYears,
      months: months ?? this.months,
      daysIndex: daysIndex ?? this.daysIndex,
      initialScrollTarget: initialScrollTarget ?? this.initialScrollTarget,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

