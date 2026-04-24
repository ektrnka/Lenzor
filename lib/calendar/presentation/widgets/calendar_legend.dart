import 'package:flutter/material.dart';

import '../../../l10n/l10n_extensions.dart';
import '../../../models/lens_data.dart';
import '../../../theme/action_palette.dart';
import '../../domain/models/day_event.dart';

class CalendarLegend extends StatelessWidget {
  const CalendarLegend({
    super.key,
    required this.isNarrowScreen,
  });

  final bool isNarrowScreen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = context.actionPalette;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final overWearColor = isDarkTheme ? actions.attention : actions.overdue;

    return Wrap(
      spacing: isNarrowScreen ? 8 : 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        if (isDarkTheme)
          _LegendItem(
            color: actions.attention,
            label: l10n.historyLegendSoon,
            isNarrowScreen: isNarrowScreen,
          ),
        _LegendItem(
          color: overWearColor,
          label: l10n.calendarLegendOverwear,
          isNarrowScreen: isNarrowScreen,
        ),
        _LegendItem(
          color: eventColor(context, DayEventType.replacement),
          label: l10n.calendarLegendReplacement,
          isNarrowScreen: isNarrowScreen,
        ),
        _LegendItem(
          color: eventColor(context, DayEventType.symptom),
          label: l10n.calendarLegendSymptoms,
          isNarrowScreen: isNarrowScreen,
        ),
        _LegendItem(
          color: eventColor(context, DayEventType.visionCheck),
          label: l10n.calendarLegendVisionCheck,
          isNarrowScreen: isNarrowScreen,
        ),
        _LegendItem(
          color: eventColor(context, DayEventType.stockUpdate),
          label: l10n.calendarLegendStock,
          isNarrowScreen: isNarrowScreen,
        ),
      ],
    );
  }
}

Color eventColor(BuildContext context, DayEventType type) {
  final actions = context.actionPalette;
  switch (type) {
    case DayEventType.replacement:
      return actions.replacement;
    case DayEventType.symptom:
      return actions.symptom;
    case DayEventType.visionCheck:
      return actions.removal;
    case DayEventType.stockUpdate:
      return actions.attention;
  }
}

Color markerColorForEvent(
  BuildContext context,
  DayEvent event, {
  required bool isLowStockDay,
}) {
  if (event.type == DayEventType.symptom) {
    final entry = event.payload as SymptomEntry?;
    final isRemoval = entry != null && entry.isManualRemoval && entry.symptoms.isEmpty;
    if (isRemoval) {
      return context.actionPalette.removal;
    }
  }

  if (event.type == DayEventType.stockUpdate && isLowStockDay) {
    return context.actionPalette.attention;
  }

  return eventColor(context, event.type);
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.isNarrowScreen,
  });

  final Color color;
  final String label;
  final bool isNarrowScreen;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isNarrowScreen ? 10 : 12,
          height: isNarrowScreen ? 10 : 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: isNarrowScreen ? 4 : 6),
        Text(
          label,
          style: TextStyle(
            fontSize: isNarrowScreen ? 10 : 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
