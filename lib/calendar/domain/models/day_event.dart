import '../../../models/lens_data.dart';

enum DayEventType {
  replacement,
  symptom,
  visionCheck,
  stockUpdate,
}

class DayEvent {
  const DayEvent({
    required this.type,
    required this.date,
    required this.title,
    this.subtitle,
    this.payload,
  });

  final DayEventType type;
  final DateTime date;
  final String title;
  final String? subtitle;
  final Object? payload;
}

class CalendarRawData {
  const CalendarRawData({
    required this.cycles,
    required this.replacements,
    required this.symptoms,
    required this.visionChecks,
    required this.stockUpdates,
    required this.stockAlertThreshold,
  });

  final List<LensCycle> cycles;
  final List<LensReplacement> replacements;
  final List<SymptomEntry> symptoms;
  final List<VisionCheck> visionChecks;
  final List<StockUpdate> stockUpdates;
  final int stockAlertThreshold;
}

