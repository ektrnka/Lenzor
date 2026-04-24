import 'app_localizations.dart';
import '../models/lens_data.dart';

extension LensTypeLocalizationX on LensType {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case LensType.daily:
        return l10n.lensTypeDaily;
      case LensType.weekly:
        return l10n.lensTypeWeekly;
      case LensType.biweekly:
        return l10n.lensTypeBiweekly;
      case LensType.monthly:
        return l10n.lensTypeMonthly;
      case LensType.quarterly:
        return l10n.lensTypeQuarterly;
      case LensType.halfYearly:
        return l10n.lensTypeHalfYearly;
    }
  }
}

extension SymptomLocalizationX on Symptom {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case Symptom.discomfort:
        return l10n.symptomDiscomfort;
      case Symptom.dryEyes:
        return l10n.symptomDryEyes;
      case Symptom.redness:
        return l10n.symptomRedness;
      case Symptom.tearing:
        return l10n.symptomTearing;
      case Symptom.blurryVision:
        return l10n.symptomBlurryVision;
      case Symptom.pain:
        return l10n.symptomPain;
      case Symptom.lightSensitivity:
        return l10n.symptomLightSensitivity;
      case Symptom.eyeFatigue:
        return l10n.symptomEyeFatigue;
    }
  }
}

extension AppLocalizationsPluralX on AppLocalizations {
  String dayWord(int value) {
    final abs = value.abs();
    final mod100 = abs % 100;
    final mod10 = abs % 10;
    final isRu = localeName.startsWith('ru');
    if (!isRu) return value == 1 ? wordDayOne : wordDayMany;
    if (mod10 == 1 && mod100 != 11) return wordDayOne;
    if ([2, 3, 4].contains(mod10) && ![12, 13, 14].contains(mod100)) {
      return wordDayFew;
    }
    return wordDayMany;
  }

  String hourWord(int value) {
    final abs = value.abs();
    final mod100 = abs % 100;
    final mod10 = abs % 10;
    final isRu = localeName.startsWith('ru');
    if (!isRu) return value == 1 ? wordHourOne : wordHourMany;
    if (mod10 == 1 && mod100 != 11) return wordHourOne;
    if ([2, 3, 4].contains(mod10) && ![12, 13, 14].contains(mod100)) {
      return wordHourFew;
    }
    return wordHourMany;
  }

  String pairWord(int value) {
    final abs = value.abs();
    final mod100 = abs % 100;
    final mod10 = abs % 10;
    final isRu = localeName.startsWith('ru');
    if (!isRu) return value == 1 ? wordPairOne : wordPairMany;
    if (mod10 == 1 && mod100 != 11) return wordPairOne;
    if ([2, 3, 4].contains(mod10) && ![12, 13, 14].contains(mod100)) {
      return wordPairFew;
    }
    return wordPairMany;
  }
}

