import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../l10n/domain_localization_extensions.dart';
import '../../../models/lens_data.dart';
import '../models/calendar_day_info.dart';
import '../models/day_details_data.dart';
import '../models/day_event.dart';

class DayDetailsBuilder {
  DayDetailsData build({
    required DateTime day,
    required CalendarDayInfo? info,
    required String dateFormattingLocale,
    required AppLocalizations l10n,
  }) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final title = DateFormat('d MMMM yyyy', dateFormattingLocale).format(normalizedDay);

    if (info == null || info.events.isEmpty) {
      return DayDetailsData(
        title: title,
        sections: [
          DayDetailSection(
            title: l10n.calendarDetailsInfo,
            type: DayEventType.visionCheck,
            items: [
              DayDetailItem(
                label: _emptyDayLabel(info, l10n),
              ),
            ],
          ),
        ],
      );
    }

    return DayDetailsData(
      title: title,
      sections: info.events
          .map(
            (event) => _buildSection(
              event,
              l10n,
              isLowStockDay: info.isLowStockDay,
            ),
          )
          .toList(),
    );
  }

  String _emptyDayLabel(CalendarDayInfo? info, AppLocalizations l10n) {
    if (info == null) {
      return l10n.calendarNoRecordsDay;
    }
    if (info.isOverdueWearDay) {
      return l10n.calendarOverwearDay;
    }
    if (info.isInWearCycle) {
      return l10n.calendarWearingNoDetails;
    }
    return l10n.calendarNoRecordsDay;
  }

  DayDetailSection _buildSection(
    DayEvent event,
    AppLocalizations l10n, {
    required bool isLowStockDay,
  }) {
    switch (event.type) {
      case DayEventType.replacement:
        final replacementLabel =
            event.subtitle?.isNotEmpty == true ? event.subtitle! : null;
        return DayDetailSection(
          title: l10n.calendarReplacementTitle,
          type: event.type,
          items: [
            if (replacementLabel != null) DayDetailItem(label: replacementLabel),
          ],
        );
      case DayEventType.symptom:
        final entry = event.payload as SymptomEntry?;
        final isRemovalSection =
            entry != null && entry.isManualRemoval && entry.symptoms.isEmpty;
        final items = <DayDetailItem>[
          if (entry != null && entry.symptoms.isNotEmpty)
            ...entry.symptoms.map(
              (symptom) => DayDetailItem(
                label: _symptomLabel(symptom, l10n),
                symptom: symptom,
              ),
            ),
          if (entry != null && entry.isManualRemoval && !isRemovalSection)
            DayDetailItem(
              label: _manualRemovalLabel(l10n),
              isRemovalAction: true,
            ),
          if (entry?.notes != null &&
              entry!.notes!.isNotEmpty &&
              !entry.isManualRemoval)
            DayDetailItem(label: l10n.calendarNote, value: entry.notes),
          if (entry != null &&
              entry.symptoms.isEmpty &&
              (entry.notes == null || entry.notes!.isEmpty) &&
              !entry.isManualRemoval)
            DayDetailItem(label: l10n.calendarNoAdditionalDetails),
        ];
        return DayDetailSection(
          title: isRemovalSection ? _manualRemovalLabel(l10n) : event.title,
          type: event.type,
          items: items,
          isRemovalSection: isRemovalSection,
        );
      case DayEventType.visionCheck:
        final check = event.payload as VisionCheck?;
        return DayDetailSection(
          title: l10n.calendarVisionTitle,
          type: event.type,
          items: [
            if (check != null)
              DayDetailItem(label: l10n.calendarLeftEye, value: 'SPH: ${check.leftSph}'),
            if (check != null)
              DayDetailItem(label: l10n.calendarRightEye, value: 'SPH: ${check.rightSph}'),
          ],
        );
      case DayEventType.stockUpdate:
        final update = event.payload as StockUpdate?;
        return DayDetailSection(
          title: l10n.calendarStockUpdateTitle,
          type: event.type,
          items: [
            if (update != null)
              DayDetailItem(label: l10n.calendarStockLabel, value: '${update.pairsCount}'),
          ],
          isLowStock: isLowStockDay,
        );
    }
  }

  String _symptomLabel(Symptom symptom, AppLocalizations l10n) {
    return symptom.localizedLabel(l10n);
  }

  String _manualRemovalLabel(AppLocalizations l10n) {
    if (l10n.localeName.startsWith('ru')) {
      return 'Линзы снятые вручную';
    }
    return l10n.calendarManualRemoval;
  }
}

