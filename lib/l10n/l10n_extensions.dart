import 'package:flutter/widgets.dart';

import 'app_localizations.dart';
import '../models/app_language_preference.dart';
import '../models/app_theme_preference.dart';

extension L10nContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension LanguagePreferenceL10nX on AppLocalizations {
  String languagePreferenceLabel(AppLanguagePreference preference) {
    switch (preference) {
      case AppLanguagePreference.system:
        return languageSystem;
      case AppLanguagePreference.ru:
        return languageRussian;
      case AppLanguagePreference.en:
        return languageEnglish;
    }
  }

  String themePreferenceLabel(AppThemePreference preference) {
    switch (preference) {
      case AppThemePreference.system:
        return themeSystem;
      case AppThemePreference.light:
        return themeLight;
      case AppThemePreference.dark:
        return themeDark;
    }
  }
}

