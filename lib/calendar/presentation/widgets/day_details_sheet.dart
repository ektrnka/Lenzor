import 'package:flutter/material.dart';

import '../../../theme/action_palette.dart';
import '../../../theme/neon_theme.dart';
import '../../domain/models/day_details_data.dart';
import '../../domain/models/day_event.dart';
import 'calendar_legend.dart';

class DayDetailsSheet extends StatelessWidget {
  const DayDetailsSheet({
    super.key,
    required this.data,
  });

  final DayDetailsData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final neon = context.neon;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          border: Border.all(color: neon.ghostBorder),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              ...data.sections.map((section) => _buildSection(context, section)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, DayDetailSection section) {
    final colorScheme = Theme.of(context).colorScheme;
    final sectionColor = _sectionColor(context, section);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _iconForType(section),
                size: 24,
                color: sectionColor,
              ),
              const SizedBox(width: 12),
              Text(
                section.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...section.items.map((item) => _buildItem(context, section, item)),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    DayDetailSection section,
    DayDetailItem item,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final text = item.value == null ? item.label : '${item.label}: ${item.value}';
    final itemColor = colorScheme.onSurfaceVariant;

    if (section.type == DayEventType.symptom && item.symptom != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              item.symptom!.icon,
              size: 18,
              color: context.actionPalette.symptom,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (item.isRemovalAction) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.remove_circle_outline,
              size: 18,
              color: context.actionPalette.removal,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: itemColor,
        ),
      ),
    );
  }

  Color _sectionColor(BuildContext context, DayDetailSection section) {
    if (section.type == DayEventType.stockUpdate && section.isLowStock) {
      return context.actionPalette.attention;
    }
    if (section.type == DayEventType.symptom && section.isRemovalSection) {
      return context.actionPalette.removal;
    }
    return eventColor(context, section.type);
  }

  IconData _iconForType(DayDetailSection section) {
    if (section.type == DayEventType.symptom && section.isRemovalSection) {
      return Icons.remove_circle_outline;
    }

    switch (section.type) {
      case DayEventType.replacement:
        return Icons.autorenew;
      case DayEventType.symptom:
        return Icons.medical_services_outlined;
      case DayEventType.visionCheck:
        return Icons.visibility_outlined;
      case DayEventType.stockUpdate:
        return Icons.inventory_2_outlined;
    }
  }
}
