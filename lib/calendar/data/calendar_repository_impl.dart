import '../../services/lens_data_service.dart';
import '../domain/models/day_event.dart';
import 'calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  CalendarRepositoryImpl(this._dataService);

  final LensDataService _dataService;

  @override
  Future<CalendarRawData> loadCalendarData() async {
    return CalendarRawData(
      cycles: _dataService.getAllCycles(),
      replacements: _dataService.getLensReplacements(),
      symptoms: _dataService.getSymptomEntries(),
      visionChecks: _dataService.getVisionChecks(),
      stockUpdates: _dataService.getStockUpdates(),
      stockAlertThreshold: _dataService.getStockAlertThreshold(),
    );
  }
}

