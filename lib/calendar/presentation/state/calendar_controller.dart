import 'package:flutter/foundation.dart';

import '../../../l10n/app_localizations.dart';
import '../../data/calendar_repository.dart';
import '../../domain/models/day_details_data.dart';
import '../../domain/models/day_event.dart';
import '../../domain/services/calendar_aggregator.dart';
import '../../domain/services/calendar_date_utils.dart';
import '../../domain/services/day_details_builder.dart';
import 'calendar_state.dart';

class CalendarController extends ChangeNotifier {
  CalendarController({
    required CalendarRepository repository,
    CalendarAggregator? aggregator,
    DayDetailsBuilder? dayDetailsBuilder,
    DateTime Function()? now,
  })  : _repository = repository,
        _aggregator = aggregator ?? CalendarAggregator(),
        _dayDetailsBuilder = dayDetailsBuilder ?? DayDetailsBuilder(),
        _now = now ?? DateTime.now,
        _state = CalendarState.initial((now ?? DateTime.now)());

  final CalendarRepository _repository;
  final CalendarAggregator _aggregator;
  final DayDetailsBuilder _dayDetailsBuilder;
  final DateTime Function() _now;
  String _dateFormattingLocale = 'en_US';
  AppLocalizations? _l10n;

  CalendarState _state;
  CalendarState get state => _state;

  CalendarRawData? _rawDataCache;

  void updateLocalization({
    required String dateFormattingLocale,
    required AppLocalizations l10n,
  }) {
    final changed = _dateFormattingLocale != dateFormattingLocale || _l10n != l10n;
    _dateFormattingLocale = dateFormattingLocale;
    _l10n = l10n;
    if (changed && _rawDataCache != null) {
      _rebuild();
    }
  }

  Future<void> load() async {
    _state = _state.copyWith(isLoading: true, clearErrorMessage: true);
    notifyListeners();

    try {
      _rawDataCache = await _repository.loadCalendarData();
      _rebuild();
    } catch (_) {
      final l10n = _l10n;
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: l10n?.calendarLoadError ?? 'Failed to load calendar',
      );
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  void changeYear(int? year) {
    _state = _state.copyWith(
      selectedYear: year,
      clearSelectedYear: year == null,
    );
    _rebuild();
  }

  void selectDay(DateTime day) {
    _state = _state.copyWith(selectedDay: dateOnly(day));
    _rebuild();
  }

  DayDetailsData? getDayDetails(DateTime day) {
    final l10n = _l10n;
    if (l10n == null) return null;
    return _dayDetailsBuilder.build(
      day: day,
      info: _state.infoForDay(day),
      dateFormattingLocale: _dateFormattingLocale,
      l10n: l10n,
    );
  }

  void _rebuild() {
    final rawData = _rawDataCache;
    final l10n = _l10n;
    if (rawData == null || l10n == null) {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      return;
    }

    final result = _aggregator.build(
      rawData: rawData,
      selectedYear: _state.selectedYear,
      selectedDay: _state.selectedDay,
      today: _now(),
      dateFormattingLocale: _dateFormattingLocale,
      l10n: l10n,
    );

    _state = _state.copyWith(
      isLoading: false,
      availableYears: result.availableYears,
      months: result.months,
      daysIndex: result.daysIndex,
      initialScrollTarget: result.initialScrollTarget,
      clearErrorMessage: true,
    );
    notifyListeners();
  }
}

