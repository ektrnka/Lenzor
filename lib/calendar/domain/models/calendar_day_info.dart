import 'day_event.dart';
import 'wear_range_position.dart';

class CalendarDayInfo {
  const CalendarDayInfo({
    required this.date,
    required this.isInWearCycle,
    required this.wearPosition,
    required this.isNearReplacementWearDay,
    required this.isOverdueWearDay,
    required this.isLowStockDay,
    required this.events,
    required this.isToday,
    required this.isSelected,
  });

  final DateTime date;
  final bool isInWearCycle;
  final WearRangePosition wearPosition;
  final bool isNearReplacementWearDay;
  final bool isOverdueWearDay;
  final bool isLowStockDay;
  final List<DayEvent> events;
  final bool isToday;
  final bool isSelected;

  bool get hasEvents => events.isNotEmpty;

  List<DayEventType> get eventTypes => [
        for (final type in events.map((event) => event.type).toSet()) type,
      ];
}

