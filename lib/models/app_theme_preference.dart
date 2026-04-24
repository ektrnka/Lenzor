import 'package:flutter/material.dart';

enum AppThemePreference {
  system('system'),
  light('light'),
  dark('dark');

  const AppThemePreference(this.code);

  final String code;

  ThemeMode get themeMode {
    switch (this) {
      case AppThemePreference.system:
        return ThemeMode.system;
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
    }
  }

  static AppThemePreference fromCode(String? code) {
    switch (code) {
      case 'light':
        return AppThemePreference.light;
      case 'dark':
        return AppThemePreference.dark;
      case 'system':
      default:
        return AppThemePreference.system;
    }
  }
}

