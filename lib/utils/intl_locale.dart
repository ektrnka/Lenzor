import 'package:flutter/widgets.dart';

String intlDateFormattingLocale(Locale locale) {
  switch (locale.languageCode.toLowerCase()) {
    case 'ru':
      return 'ru_RU';
    default:
      return 'en_US';
  }
}

