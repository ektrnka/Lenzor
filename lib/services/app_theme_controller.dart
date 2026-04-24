import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_theme_preference.dart';

class AppThemeController extends ChangeNotifier with WidgetsBindingObserver {
  static const String preferenceStorageKey = 'app_theme_preference';

  AppThemeController._(
    this._prefs,
    this._preference,
  );

  final SharedPreferences _prefs;
  AppThemePreference _preference;

  AppThemePreference get preference => _preference;

  ThemeMode get themeMode => _preference.themeMode;

  Brightness get effectiveBrightness {
    if (_preference == AppThemePreference.system) {
      return PlatformDispatcher.instance.platformBrightness;
    }
    return _preference == AppThemePreference.dark
        ? Brightness.dark
        : Brightness.light;
  }

  static Future<AppThemeController> create() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(preferenceStorageKey);
    final controller = AppThemeController._(
      prefs,
      AppThemePreference.fromCode(savedCode),
    );
    WidgetsBinding.instance.addObserver(controller);
    return controller;
  }

  Future<void> setPreference(AppThemePreference preference) async {
    if (_preference == preference) return;
    _preference = preference;
    notifyListeners();
    await _prefs.setString(preferenceStorageKey, preference.code);
  }

  @override
  void didChangePlatformBrightness() {
    if (_preference == AppThemePreference.system) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

