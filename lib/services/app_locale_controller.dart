import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../models/app_language_preference.dart';
import 'lens_data_service.dart';

class AppLocaleController extends ChangeNotifier {
  static AppLocaleController? _instance;

  AppLocaleController._(
    this._dataService,
    this._preference,
  );

  final LensDataService _dataService;
  AppLanguagePreference _preference;

  AppLanguagePreference get preference => _preference;

  Locale? get materialLocale {
    switch (_preference) {
      case AppLanguagePreference.system:
        return null;
      case AppLanguagePreference.ru:
        return const Locale('ru');
      case AppLanguagePreference.en:
        return const Locale('en');
    }
  }

  static Future<AppLocaleController> create(LensDataService dataService) async {
    final savedCode = dataService.getLanguagePreference();
    final controller = AppLocaleController._(
      dataService,
      AppLanguagePreference.fromCode(savedCode),
    );
    _instance = controller;
    return controller;
  }

  Future<void> setPreference(AppLanguagePreference preference) async {
    if (_preference == preference) return;
    _preference = preference;
    notifyListeners();
    await _dataService.setLanguagePreference(preference.code);
  }

  static Locale resolveSystemLocale(Locale? systemLocale) {
    final code = systemLocale?.languageCode.toLowerCase();
    if (code == 'ru') return const Locale('ru');
    if (code == 'en') return const Locale('en');
    return const Locale('en');
  }

  static String resolveLanguageCode({
    required String savedPreference,
    required Locale? systemLocale,
  }) {
    if (savedPreference == 'ru') return 'ru';
    if (savedPreference == 'en') return 'en';

    final code = systemLocale?.languageCode.toLowerCase();
    if (code == 'ru') return 'ru';
    if (code == 'en') return 'en';
    return 'en';
  }

  Locale get resolvedLocale {
    if (_preference == AppLanguagePreference.system) {
      return resolveSystemLocale(PlatformDispatcher.instance.locale);
    }
    return materialLocale ?? const Locale('en');
  }

  String get resolvedLanguageCode => resolvedLocale.languageCode;

  static String get currentLanguageCode {
    return _instance?.resolvedLanguageCode ??
        resolveSystemLocale(PlatformDispatcher.instance.locale).languageCode;
  }
}

