enum AppLanguagePreference {
  system('system'),
  ru('ru'),
  en('en');

  const AppLanguagePreference(this.code);

  final String code;

  static AppLanguagePreference fromCode(String? code) {
    switch (code) {
      case 'ru':
        return AppLanguagePreference.ru;
      case 'en':
        return AppLanguagePreference.en;
      case 'system':
      default:
        return AppLanguagePreference.system;
    }
  }
}

