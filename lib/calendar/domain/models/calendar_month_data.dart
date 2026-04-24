import 'year_month.dart';

class CalendarMonthData {
  const CalendarMonthData({
    required this.year,
    required this.month,
    required this.title,
    required this.visibleDays,
  });

  final int year;
  final int month;
  final String title;
  final List<DateTime> visibleDays;

  YearMonth get yearMonth => YearMonth(year, month);
}

