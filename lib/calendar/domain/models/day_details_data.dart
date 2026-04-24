import 'day_event.dart';
import '../../../models/lens_data.dart';

class DayDetailsData {
  const DayDetailsData({
    required this.title,
    required this.sections,
  });

  final String title;
  final List<DayDetailSection> sections;
}

class DayDetailSection {
  const DayDetailSection({
    required this.title,
    required this.type,
    required this.items,
    this.isLowStock = false,
    this.isRemovalSection = false,
  });

  final String title;
  final DayEventType type;
  final List<DayDetailItem> items;
  final bool isLowStock;
  final bool isRemovalSection;
}

class DayDetailItem {
  const DayDetailItem({
    required this.label,
    this.value,
    this.symptom,
    this.isRemovalAction = false,
  });

  final String label;
  final String? value;
  final Symptom? symptom;
  final bool isRemovalAction;
}

