import '../domain/models/day_event.dart';

abstract class CalendarRepository {
  Future<CalendarRawData> loadCalendarData();
}

