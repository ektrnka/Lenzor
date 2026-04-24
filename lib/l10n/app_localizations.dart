import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Linsor'**
  String get appTitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Linsor'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App personalization'**
  String get settingsSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @refreshStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh status'**
  String get refreshStatus;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsReplacementReminders.
  ///
  /// In en, this message translates to:
  /// **'Replacement reminders'**
  String get notificationsReplacementReminders;

  /// No description provided for @notificationsStatus.
  ///
  /// In en, this message translates to:
  /// **'Notification status'**
  String get notificationsStatus;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabled;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off'**
  String get notificationsOff;

  /// No description provided for @allowBackgroundWork.
  ///
  /// In en, this message translates to:
  /// **'Allow background work'**
  String get allowBackgroundWork;

  /// No description provided for @allowBackgroundWorkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Needed for reminders when the app is closed'**
  String get allowBackgroundWorkSubtitle;

  /// No description provided for @loadingDots.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get loadingDots;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @lensTypeDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get lensTypeDaily;

  /// No description provided for @lensTypeWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get lensTypeWeekly;

  /// No description provided for @lensTypeBiweekly.
  ///
  /// In en, this message translates to:
  /// **'Bi-weekly'**
  String get lensTypeBiweekly;

  /// No description provided for @lensTypeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get lensTypeMonthly;

  /// No description provided for @lensTypeQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get lensTypeQuarterly;

  /// No description provided for @lensTypeHalfYearly.
  ///
  /// In en, this message translates to:
  /// **'Semi-annual'**
  String get lensTypeHalfYearly;

  /// No description provided for @symptomDiscomfort.
  ///
  /// In en, this message translates to:
  /// **'Discomfort'**
  String get symptomDiscomfort;

  /// No description provided for @symptomDryEyes.
  ///
  /// In en, this message translates to:
  /// **'Dry eyes'**
  String get symptomDryEyes;

  /// No description provided for @symptomRedness.
  ///
  /// In en, this message translates to:
  /// **'Redness'**
  String get symptomRedness;

  /// No description provided for @symptomTearing.
  ///
  /// In en, this message translates to:
  /// **'Tearing'**
  String get symptomTearing;

  /// No description provided for @symptomBlurryVision.
  ///
  /// In en, this message translates to:
  /// **'Blurred vision'**
  String get symptomBlurryVision;

  /// No description provided for @symptomPain.
  ///
  /// In en, this message translates to:
  /// **'Pain'**
  String get symptomPain;

  /// No description provided for @symptomLightSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Light sensitivity'**
  String get symptomLightSensitivity;

  /// No description provided for @symptomEyeFatigue.
  ///
  /// In en, this message translates to:
  /// **'Eye fatigue'**
  String get symptomEyeFatigue;

  /// No description provided for @wordDayOne.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get wordDayOne;

  /// No description provided for @wordDayFew.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get wordDayFew;

  /// No description provided for @wordDayMany.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get wordDayMany;

  /// No description provided for @wordHourOne.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get wordHourOne;

  /// No description provided for @wordHourFew.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get wordHourFew;

  /// No description provided for @wordHourMany.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get wordHourMany;

  /// No description provided for @wordPairOne.
  ///
  /// In en, this message translates to:
  /// **'pair'**
  String get wordPairOne;

  /// No description provided for @wordPairFew.
  ///
  /// In en, this message translates to:
  /// **'pairs'**
  String get wordPairFew;

  /// No description provided for @wordPairMany.
  ///
  /// In en, this message translates to:
  /// **'pairs'**
  String get wordPairMany;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Linsor'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contact lens tracking'**
  String get homeSubtitle;

  /// No description provided for @homeWearing.
  ///
  /// In en, this message translates to:
  /// **'Wearing'**
  String get homeWearing;

  /// No description provided for @homeStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get homeStock;

  /// No description provided for @homeUpdateStock.
  ///
  /// In en, this message translates to:
  /// **'Update stock'**
  String get homeUpdateStock;

  /// No description provided for @homeHowManyPairsToAdd.
  ///
  /// In en, this message translates to:
  /// **'How many pairs to add'**
  String get homeHowManyPairsToAdd;

  /// No description provided for @homeCurrentStock.
  ///
  /// In en, this message translates to:
  /// **'Current stock: {count} pairs'**
  String homeCurrentStock(int count);

  /// No description provided for @homeEnterPositiveNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive number'**
  String get homeEnterPositiveNumber;

  /// No description provided for @homeNoActiveLenses.
  ///
  /// In en, this message translates to:
  /// **'You have no active lenses'**
  String get homeNoActiveLenses;

  /// No description provided for @homeCompleteWearing.
  ///
  /// In en, this message translates to:
  /// **'Complete wearing'**
  String get homeCompleteWearing;

  /// No description provided for @homeCompleteWearingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Complete wearing?'**
  String get homeCompleteWearingQuestion;

  /// No description provided for @homeCompleteWearingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to complete the current lens cycle?'**
  String get homeCompleteWearingConfirm;

  /// No description provided for @homeWearingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Wearing cycle completed'**
  String get homeWearingCompleted;

  /// No description provided for @homeTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Care tips'**
  String get homeTipsTitle;

  /// No description provided for @homeNoCyclePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The current cycle will appear here once you start using lenses'**
  String get homeNoCyclePlaceholder;

  /// No description provided for @homePutOnNewPair.
  ///
  /// In en, this message translates to:
  /// **'Put on a new pair'**
  String get homePutOnNewPair;

  /// No description provided for @homeOverdueBy.
  ///
  /// In en, this message translates to:
  /// **'Lenses are overdue by'**
  String get homeOverdueBy;

  /// No description provided for @homeUntilReplacement.
  ///
  /// In en, this message translates to:
  /// **'Until replacement'**
  String get homeUntilReplacement;

  /// No description provided for @mainAddRecord.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get mainAddRecord;

  /// No description provided for @mainRecordForDate.
  ///
  /// In en, this message translates to:
  /// **'Record for {date}'**
  String mainRecordForDate(String date);

  /// No description provided for @mainAddRecordForDate.
  ///
  /// In en, this message translates to:
  /// **'Add record for {date}'**
  String mainAddRecordForDate(String date);

  /// No description provided for @mainCannotAddFutureRecords.
  ///
  /// In en, this message translates to:
  /// **'You can\'t add records for future dates'**
  String get mainCannotAddFutureRecords;

  /// No description provided for @mainReplaceLenses.
  ///
  /// In en, this message translates to:
  /// **'Replace lenses'**
  String get mainReplaceLenses;

  /// No description provided for @mainReplaceLensesDescription.
  ///
  /// In en, this message translates to:
  /// **'Start a new pair cycle'**
  String get mainReplaceLensesDescription;

  /// No description provided for @mainUpdateStockDescription.
  ///
  /// In en, this message translates to:
  /// **'Change pairs in stock'**
  String get mainUpdateStockDescription;

  /// No description provided for @mainAddSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Add symptoms'**
  String get mainAddSymptoms;

  /// No description provided for @mainAddSymptomsDescription.
  ///
  /// In en, this message translates to:
  /// **'Mark discomfort or issues'**
  String get mainAddSymptomsDescription;

  /// No description provided for @mainTakeOffLenses.
  ///
  /// In en, this message translates to:
  /// **'Take off lenses'**
  String get mainTakeOffLenses;

  /// No description provided for @mainTakeOffLensesDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete current wearing cycle'**
  String get mainTakeOffLensesDescription;

  /// No description provided for @mainNotEnoughLenses.
  ///
  /// In en, this message translates to:
  /// **'Not enough lenses'**
  String get mainNotEnoughLenses;

  /// No description provided for @mainNoLensesAndTakeOffPrompt.
  ///
  /// In en, this message translates to:
  /// **'You\'re out of lenses and cannot start a new pair. Take off current lenses instead?'**
  String get mainNoLensesAndTakeOffPrompt;

  /// No description provided for @mainNoLensesAddStockPrompt.
  ///
  /// In en, this message translates to:
  /// **'You\'re out of lenses. Add stock in the Profile section.'**
  String get mainNoLensesAddStockPrompt;

  /// No description provided for @mainLensReplacement.
  ///
  /// In en, this message translates to:
  /// **'Lens replacement'**
  String get mainLensReplacement;

  /// No description provided for @mainStartNewPairQuestion.
  ///
  /// In en, this message translates to:
  /// **'Start a new lens pair cycle? The current cycle will be completed automatically.'**
  String get mainStartNewPairQuestion;

  /// No description provided for @mainPutOnNewPairQuestion.
  ///
  /// In en, this message translates to:
  /// **'Put on a new lens pair?'**
  String get mainPutOnNewPairQuestion;

  /// No description provided for @mainReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get mainReplace;

  /// No description provided for @mainLowStockWarning.
  ///
  /// In en, this message translates to:
  /// **'Low stock warning: {count} pairs left'**
  String mainLowStockWarning(int count);

  /// No description provided for @mainErrorReplacingLenses.
  ///
  /// In en, this message translates to:
  /// **'Error while replacing lenses'**
  String get mainErrorReplacingLenses;

  /// No description provided for @mainTimeMessageHoursBefore.
  ///
  /// In en, this message translates to:
  /// **'Take lenses off in {hours} h'**
  String mainTimeMessageHoursBefore(int hours);

  /// No description provided for @mainTimeMessageExpiry.
  ///
  /// In en, this message translates to:
  /// **'Time to take off lenses! (14 hours passed)'**
  String get mainTimeMessageExpiry;

  /// No description provided for @mainTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get mainTomorrow;

  /// No description provided for @mainInDays.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String mainInDays(int days);

  /// No description provided for @mainTimeToReplaceMessage.
  ///
  /// In en, this message translates to:
  /// **'{when} it\'s time to replace lenses'**
  String mainTimeToReplaceMessage(String when);

  /// No description provided for @mainTakeOffConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to complete the current wearing cycle? This will create a lens removal entry.'**
  String get mainTakeOffConfirm;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage history'**
  String get historyTitle;

  /// No description provided for @historySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lens wearing cycles'**
  String get historySubtitle;

  /// No description provided for @historyAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get historyAllTime;

  /// No description provided for @historyLegendActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get historyLegendActive;

  /// No description provided for @historyLegendCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get historyLegendCompleted;

  /// No description provided for @historyLegendSoon.
  ///
  /// In en, this message translates to:
  /// **'Replace soon'**
  String get historyLegendSoon;

  /// No description provided for @historyLegendOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get historyLegendOverdue;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'History is empty'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Start wearing lenses and your cycle history will appear here'**
  String get historyEmptyDescription;

  /// No description provided for @historyCompletedByRemoval.
  ///
  /// In en, this message translates to:
  /// **'Completed by manual removal'**
  String get historyCompletedByRemoval;

  /// No description provided for @historyCompletedByReplacement.
  ///
  /// In en, this message translates to:
  /// **'Completed by replacement'**
  String get historyCompletedByReplacement;

  /// No description provided for @historyPassedOfHours.
  ///
  /// In en, this message translates to:
  /// **'Passed: {used} of {total} hours'**
  String historyPassedOfHours(int used, int total);

  /// No description provided for @historyUsedOfHours.
  ///
  /// In en, this message translates to:
  /// **'Used: {used} of {total} hours'**
  String historyUsedOfHours(int used, int total);

  /// No description provided for @historyRecommendedHours.
  ///
  /// In en, this message translates to:
  /// **'Recommended: {from}-{to} hours'**
  String historyRecommendedHours(int from, int to);

  /// No description provided for @historyPassedOfDays.
  ///
  /// In en, this message translates to:
  /// **'Passed: {used} of {total} days'**
  String historyPassedOfDays(int used, int total);

  /// No description provided for @historyUsedOfDays.
  ///
  /// In en, this message translates to:
  /// **'Used: {used} of {total} days'**
  String historyUsedOfDays(int used, int total);

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarAllYears.
  ///
  /// In en, this message translates to:
  /// **'All years'**
  String get calendarAllYears;

  /// No description provided for @calendarLegendWearDays.
  ///
  /// In en, this message translates to:
  /// **'Wearing days'**
  String get calendarLegendWearDays;

  /// No description provided for @calendarLegendOverwear.
  ///
  /// In en, this message translates to:
  /// **'Overwear'**
  String get calendarLegendOverwear;

  /// No description provided for @calendarLegendReplacement.
  ///
  /// In en, this message translates to:
  /// **'Replacement'**
  String get calendarLegendReplacement;

  /// No description provided for @calendarLegendSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get calendarLegendSymptoms;

  /// No description provided for @calendarLegendVisionCheck.
  ///
  /// In en, this message translates to:
  /// **'Vision check'**
  String get calendarLegendVisionCheck;

  /// No description provided for @calendarLegendStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get calendarLegendStock;

  /// No description provided for @calendarLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load calendar'**
  String get calendarLoadError;

  /// No description provided for @calendarDetailsInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get calendarDetailsInfo;

  /// No description provided for @calendarNoRecordsDay.
  ///
  /// In en, this message translates to:
  /// **'No records for this day'**
  String get calendarNoRecordsDay;

  /// No description provided for @calendarOverwearDay.
  ///
  /// In en, this message translates to:
  /// **'Overwear: wearing period was exceeded on this day'**
  String get calendarOverwearDay;

  /// No description provided for @calendarWearingNoDetails.
  ///
  /// In en, this message translates to:
  /// **'Wearing day with no extra records'**
  String get calendarWearingNoDetails;

  /// No description provided for @calendarNewPair.
  ///
  /// In en, this message translates to:
  /// **'New pair of lenses'**
  String get calendarNewPair;

  /// No description provided for @calendarManualRemoval.
  ///
  /// In en, this message translates to:
  /// **'Lenses removed manually'**
  String get calendarManualRemoval;

  /// No description provided for @calendarNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get calendarNote;

  /// No description provided for @calendarNoAdditionalDetails.
  ///
  /// In en, this message translates to:
  /// **'No additional details'**
  String get calendarNoAdditionalDetails;

  /// No description provided for @calendarLeftEye.
  ///
  /// In en, this message translates to:
  /// **'Left eye'**
  String get calendarLeftEye;

  /// No description provided for @calendarRightEye.
  ///
  /// In en, this message translates to:
  /// **'Right eye'**
  String get calendarRightEye;

  /// No description provided for @calendarStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get calendarStockLabel;

  /// No description provided for @calendarReplacementTitle.
  ///
  /// In en, this message translates to:
  /// **'Lens replacement'**
  String get calendarReplacementTitle;

  /// No description provided for @calendarSymptomsTitle.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get calendarSymptomsTitle;

  /// No description provided for @calendarVisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Vision check'**
  String get calendarVisionTitle;

  /// No description provided for @calendarStockUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock update'**
  String get calendarStockUpdateTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contact lens monitoring'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync data across devices'**
  String get onboardingSignInPrompt;

  /// No description provided for @onboardingSignInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get onboardingSignInGoogle;

  /// No description provided for @onboardingContinueWithoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Continue without account'**
  String get onboardingContinueWithoutAccount;

  /// No description provided for @onboardingSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed: {reason}'**
  String onboardingSignInFailed(String reason);

  /// No description provided for @onboardingDataConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'You have data both on device and in account'**
  String get onboardingDataConflictTitle;

  /// No description provided for @onboardingDataConflictMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose which data to keep: device data can be uploaded, or cloud data can replace local data.'**
  String get onboardingDataConflictMessage;

  /// No description provided for @onboardingUseCloudData.
  ///
  /// In en, this message translates to:
  /// **'Load from account'**
  String get onboardingUseCloudData;

  /// No description provided for @onboardingKeepDeviceData.
  ///
  /// In en, this message translates to:
  /// **'Keep device data'**
  String get onboardingKeepDeviceData;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your info and history'**
  String get profileSubtitle;

  /// No description provided for @profileAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccount;

  /// No description provided for @profileUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profileUser;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileSignInHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync data across devices'**
  String get profileSignInHint;

  /// No description provided for @profileSignInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get profileSignInGoogle;

  /// No description provided for @profileSyncError.
  ///
  /// In en, this message translates to:
  /// **'Sync error: {reason}'**
  String profileSyncError(String reason);

  /// No description provided for @profileStatisticsTotalCycles.
  ///
  /// In en, this message translates to:
  /// **'Total cycles'**
  String get profileStatisticsTotalCycles;

  /// No description provided for @profileStatisticsAverageDays.
  ///
  /// In en, this message translates to:
  /// **'Average, days'**
  String get profileStatisticsAverageDays;

  /// No description provided for @profileLensInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Lens information'**
  String get profileLensInfoTitle;

  /// No description provided for @profileVisionCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Vision check'**
  String get profileVisionCheckTitle;

  /// No description provided for @profileDeleteHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get profileDeleteHistoryTitle;

  /// No description provided for @profileDeleteHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear history?'**
  String get profileDeleteHistoryConfirm;

  /// No description provided for @notificationAllowTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications?'**
  String get notificationAllowTitle;

  /// No description provided for @notificationAllowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Linsor uses notifications for:'**
  String get notificationAllowSubtitle;

  /// No description provided for @notificationFeatureReplacement.
  ///
  /// In en, this message translates to:
  /// **'Replacement reminders'**
  String get notificationFeatureReplacement;

  /// No description provided for @notificationFeatureEyeHealth.
  ///
  /// In en, this message translates to:
  /// **'Eye health tips'**
  String get notificationFeatureEyeHealth;

  /// No description provided for @notificationFeaturePeriodControl.
  ///
  /// In en, this message translates to:
  /// **'Wearing period control'**
  String get notificationFeaturePeriodControl;

  /// No description provided for @notificationFeatureWarnings.
  ///
  /// In en, this message translates to:
  /// **'Important warnings'**
  String get notificationFeatureWarnings;

  /// No description provided for @notificationAllowLater.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notificationAllowLater;

  /// No description provided for @notificationAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get notificationAllow;

  /// No description provided for @notificationBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked'**
  String get notificationBlockedTitle;

  /// No description provided for @notificationBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Open device settings and allow notifications for Linsor.'**
  String get notificationBlockedMessage;

  /// No description provided for @notificationOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get notificationOpenSettings;

  /// No description provided for @notificationPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Permission request error'**
  String get notificationPermissionError;

  /// No description provided for @notificationPermissionGranted.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled. You will receive reminders.'**
  String get notificationPermissionGranted;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled. You can enable them later in Settings.'**
  String get notificationPermissionDenied;

  /// No description provided for @notificationPermissionDisableAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can disable notifications anytime in Settings.'**
  String get notificationPermissionDisableAnytime;

  /// No description provided for @notificationBlockedMessageDetailed.
  ///
  /// In en, this message translates to:
  /// **'You previously denied notification permission.\n\nTo enable it:\n1. Open device settings\n2. Find Linsor\n3. Allow notifications\n4. Return to the app'**
  String get notificationBlockedMessageDetailed;

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Lens reminders'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Lens replacement and eye health notifications'**
  String get notificationChannelDescription;

  /// No description provided for @notificationTitleReplace.
  ///
  /// In en, this message translates to:
  /// **'Time to replace lenses!'**
  String get notificationTitleReplace;

  /// No description provided for @notificationBodyReplaceToday.
  ///
  /// In en, this message translates to:
  /// **'Today is the recommended replacement date.'**
  String get notificationBodyReplaceToday;

  /// No description provided for @notificationActionDone.
  ///
  /// In en, this message translates to:
  /// **'I replaced them'**
  String get notificationActionDone;

  /// No description provided for @notificationActionSnooze.
  ///
  /// In en, this message translates to:
  /// **'Remind me later'**
  String get notificationActionSnooze;

  /// No description provided for @notificationDailyTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Care tip'**
  String get notificationDailyTipTitle;

  /// No description provided for @notificationSolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Solution purchase'**
  String get notificationSolutionTitle;

  /// No description provided for @notificationSolutionBody.
  ///
  /// In en, this message translates to:
  /// **'Time to buy contact lens solution'**
  String get notificationSolutionBody;

  /// No description provided for @notificationLowStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Low stock reminder'**
  String get notificationLowStockTitle;

  /// No description provided for @appNavMarkDoneQuestion.
  ///
  /// In en, this message translates to:
  /// **'Did you replace \"{lensName}\"?'**
  String appNavMarkDoneQuestion(String lensName);

  /// No description provided for @appNavAfterConfirm.
  ///
  /// In en, this message translates to:
  /// **'After confirmation:'**
  String get appNavAfterConfirm;

  /// No description provided for @appNavMarkDoneFeature1.
  ///
  /// In en, this message translates to:
  /// **'Lenses will be marked as replaced'**
  String get appNavMarkDoneFeature1;

  /// No description provided for @appNavMarkDoneFeature2.
  ///
  /// In en, this message translates to:
  /// **'A new wearing cycle will start'**
  String get appNavMarkDoneFeature2;

  /// No description provided for @appNavMarkDoneFeature3.
  ///
  /// In en, this message translates to:
  /// **'Stock will decrease by 1 pair'**
  String get appNavMarkDoneFeature3;

  /// No description provided for @appNavMarkDoneFeature4.
  ///
  /// In en, this message translates to:
  /// **'Old reminders will be removed'**
  String get appNavMarkDoneFeature4;

  /// No description provided for @appNavMarkDoneFeature5.
  ///
  /// In en, this message translates to:
  /// **'New reminders will be scheduled'**
  String get appNavMarkDoneFeature5;

  /// No description provided for @appNavMarkDoneConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, replaced'**
  String get appNavMarkDoneConfirmButton;

  /// No description provided for @appNavRestock.
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get appNavRestock;

  /// No description provided for @appNavSnoozeChooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose when to remind about lenses:'**
  String get appNavSnoozeChooseTime;

  /// No description provided for @appNavSnoozeIn1Hour.
  ///
  /// In en, this message translates to:
  /// **'In 1 hour'**
  String get appNavSnoozeIn1Hour;

  /// No description provided for @appNavSnoozeIn3Hours.
  ///
  /// In en, this message translates to:
  /// **'In 3 hours'**
  String get appNavSnoozeIn3Hours;

  /// No description provided for @appNavSnoozeTomorrowMorning.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow morning'**
  String get appNavSnoozeTomorrowMorning;

  /// No description provided for @appNavSnoozeIn2Days.
  ///
  /// In en, this message translates to:
  /// **'In 2 days'**
  String get appNavSnoozeIn2Days;

  /// No description provided for @appNavReminderDelayedMessage.
  ///
  /// In en, this message translates to:
  /// **'Reminder delayed. Time to replace lenses.'**
  String get appNavReminderDelayedMessage;

  /// No description provided for @appNavReminderSnoozedFor.
  ///
  /// In en, this message translates to:
  /// **'Reminder delayed for {duration}'**
  String appNavReminderSnoozedFor(String duration);

  /// No description provided for @appNavEyeHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Eye health'**
  String get appNavEyeHealthTitle;

  /// No description provided for @appNavEyeHealthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contact lens recommendations:'**
  String get appNavEyeHealthSubtitle;

  /// No description provided for @appNavEyeHealthTip1.
  ///
  /// In en, this message translates to:
  /// **'Wash your hands before handling lenses'**
  String get appNavEyeHealthTip1;

  /// No description provided for @appNavEyeHealthTip2.
  ///
  /// In en, this message translates to:
  /// **'Follow the replacement schedule'**
  String get appNavEyeHealthTip2;

  /// No description provided for @appNavEyeHealthTip3.
  ///
  /// In en, this message translates to:
  /// **'Do not sleep in lenses unless approved for overnight wear'**
  String get appNavEyeHealthTip3;

  /// No description provided for @appNavEyeHealthTip4.
  ///
  /// In en, this message translates to:
  /// **'Use fresh solution every day'**
  String get appNavEyeHealthTip4;

  /// No description provided for @appNavEyeHealthTip5.
  ///
  /// In en, this message translates to:
  /// **'Visit your eye doctor regularly'**
  String get appNavEyeHealthTip5;

  /// No description provided for @appNavEyeHealthTip6.
  ///
  /// In en, this message translates to:
  /// **'Avoid water (pool, shower) while wearing lenses'**
  String get appNavEyeHealthTip6;

  /// No description provided for @appNavEyeHealthWarning.
  ///
  /// In en, this message translates to:
  /// **'If discomfort, redness, or blurry vision appears, remove lenses and consult a doctor.'**
  String get appNavEyeHealthWarning;

  /// No description provided for @appNavClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get appNavClose;

  /// No description provided for @appNavMyLenses.
  ///
  /// In en, this message translates to:
  /// **'My lenses'**
  String get appNavMyLenses;

  /// No description provided for @appNavOpenProfileSetupHint.
  ///
  /// In en, this message translates to:
  /// **'Open profile editing to set up lenses'**
  String get appNavOpenProfileSetupHint;

  /// No description provided for @appNavMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get appNavMinutesShort;

  /// No description provided for @profileSignOutDataTitle.
  ///
  /// In en, this message translates to:
  /// **'What to do with your data?'**
  String get profileSignOutDataTitle;

  /// No description provided for @profileSignOutDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Data will stay in the cloud and be available after sign-in.\n\n• Keep on device — continue working offline\n• Delete from device — free space, cloud data remains available'**
  String get profileSignOutDataMessage;

  /// No description provided for @profileDeleteFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Delete from device'**
  String get profileDeleteFromDevice;

  /// No description provided for @profileKeepOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Keep on device'**
  String get profileKeepOnDevice;

  /// No description provided for @profileLensType.
  ///
  /// In en, this message translates to:
  /// **'Lens type'**
  String get profileLensType;

  /// No description provided for @profileWearingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Wearing period'**
  String get profileWearingPeriod;

  /// No description provided for @profileBaseCurve.
  ///
  /// In en, this message translates to:
  /// **'Base curve'**
  String get profileBaseCurve;

  /// No description provided for @profileDiameter.
  ///
  /// In en, this message translates to:
  /// **'Diameter'**
  String get profileDiameter;

  /// No description provided for @profileFirstUseDate.
  ///
  /// In en, this message translates to:
  /// **'First use date'**
  String get profileFirstUseDate;

  /// No description provided for @profileBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get profileBrand;

  /// No description provided for @profileChangeLensType.
  ///
  /// In en, this message translates to:
  /// **'Change lens type'**
  String get profileChangeLensType;

  /// No description provided for @profileVision.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get profileVision;

  /// No description provided for @profileNoVisionData.
  ///
  /// In en, this message translates to:
  /// **'No vision data'**
  String get profileNoVisionData;

  /// No description provided for @profileAddCheck.
  ///
  /// In en, this message translates to:
  /// **'Add check'**
  String get profileAddCheck;

  /// No description provided for @profileNoVisionRecords.
  ///
  /// In en, this message translates to:
  /// **'No vision check records'**
  String get profileNoVisionRecords;

  /// No description provided for @profileAddFirstCheckHint.
  ///
  /// In en, this message translates to:
  /// **'Add the first check to track changes'**
  String get profileAddFirstCheckHint;

  /// No description provided for @profileDeleteVisionCheckMessage.
  ///
  /// In en, this message translates to:
  /// **'Vision check from {date} will be deleted permanently.'**
  String profileDeleteVisionCheckMessage(String date);

  /// No description provided for @profileLensSetup.
  ///
  /// In en, this message translates to:
  /// **'Lens setup'**
  String get profileLensSetup;

  /// No description provided for @profileContactLensType.
  ///
  /// In en, this message translates to:
  /// **'Contact lens type'**
  String get profileContactLensType;

  /// No description provided for @profileLensBrand.
  ///
  /// In en, this message translates to:
  /// **'Lens brand'**
  String get profileLensBrand;

  /// No description provided for @profileLensBrandHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Acuvue Oasys'**
  String get profileLensBrandHint;

  /// No description provided for @profileBaseCurveWithCode.
  ///
  /// In en, this message translates to:
  /// **'Base curve (BC)'**
  String get profileBaseCurveWithCode;

  /// No description provided for @profileDiameterWithCode.
  ///
  /// In en, this message translates to:
  /// **'Diameter (DIA)'**
  String get profileDiameterWithCode;

  /// No description provided for @profileLeftMm.
  ///
  /// In en, this message translates to:
  /// **'Left, mm'**
  String get profileLeftMm;

  /// No description provided for @profileRightMm.
  ///
  /// In en, this message translates to:
  /// **'Right, mm'**
  String get profileRightMm;

  /// No description provided for @profileLensTypeChangeWarning.
  ///
  /// In en, this message translates to:
  /// **'Changing lens type affects current cycle. The new type will apply to current and next cycles.'**
  String get profileLensTypeChangeWarning;

  /// No description provided for @profileCheckDate.
  ///
  /// In en, this message translates to:
  /// **'Check date'**
  String get profileCheckDate;

  /// No description provided for @profileOpticalPowerSph.
  ///
  /// In en, this message translates to:
  /// **'Optical power (SPH)'**
  String get profileOpticalPowerSph;

  /// No description provided for @profileCylinderCyl.
  ///
  /// In en, this message translates to:
  /// **'Cylinder (CYL) - for astigmatism'**
  String get profileCylinderCyl;

  /// No description provided for @profileAxis.
  ///
  /// In en, this message translates to:
  /// **'Axis (AXIS) - for astigmatism'**
  String get profileAxis;

  /// No description provided for @profileAstigmatismHint.
  ///
  /// In en, this message translates to:
  /// **'Leave CYL and AXIS empty if you do not have astigmatism.'**
  String get profileAstigmatismHint;

  /// No description provided for @profileFillSphError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in optical power (SPH)'**
  String get profileFillSphError;

  /// No description provided for @profileLeftAxisError.
  ///
  /// In en, this message translates to:
  /// **'For left eye CYL, specify AXIS from 0 to 180°'**
  String get profileLeftAxisError;

  /// No description provided for @profileRightAxisError.
  ///
  /// In en, this message translates to:
  /// **'For right eye CYL, specify AXIS from 0 to 180°'**
  String get profileRightAxisError;

  /// No description provided for @settingsDailyAt.
  ///
  /// In en, this message translates to:
  /// **'Daily at {time}'**
  String settingsDailyAt(String time);

  /// No description provided for @settingsTipTime.
  ///
  /// In en, this message translates to:
  /// **'Tip time'**
  String get settingsTipTime;

  /// No description provided for @settingsNotificationTime.
  ///
  /// In en, this message translates to:
  /// **'Notification time'**
  String get settingsNotificationTime;

  /// No description provided for @settingsEveryMonths.
  ///
  /// In en, this message translates to:
  /// **'every {months} month(s)'**
  String settingsEveryMonths(int months);

  /// No description provided for @settingsDailyAtLowStock.
  ///
  /// In en, this message translates to:
  /// **'Daily at {time} when stock is below threshold'**
  String settingsDailyAtLowStock(String time);

  /// No description provided for @settingsLowStockReminderHelp.
  ///
  /// In en, this message translates to:
  /// **'A daily notification will be sent at the selected time if lens stock is below the warning threshold.'**
  String get settingsLowStockReminderHelp;

  /// No description provided for @settingsLensStock.
  ///
  /// In en, this message translates to:
  /// **'Lens stock'**
  String get settingsLensStock;

  /// No description provided for @settingsAlertThreshold.
  ///
  /// In en, this message translates to:
  /// **'Alert threshold'**
  String get settingsAlertThreshold;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsDataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data management'**
  String get settingsDataManagement;

  /// No description provided for @settingsDeleteAllHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete all history'**
  String get settingsDeleteAllHistory;

  /// No description provided for @settingsHoursBeforeEndTitle.
  ///
  /// In en, this message translates to:
  /// **'How many hours before end'**
  String get settingsHoursBeforeEndTitle;

  /// No description provided for @settingsAtExpiry.
  ///
  /// In en, this message translates to:
  /// **'At expiry'**
  String get settingsAtExpiry;

  /// No description provided for @settingsDaysBeforeReplacement.
  ///
  /// In en, this message translates to:
  /// **'How many days before replacement'**
  String get settingsDaysBeforeReplacement;

  /// No description provided for @settingsReplacementDayTime.
  ///
  /// In en, this message translates to:
  /// **'Time on replacement day'**
  String get settingsReplacementDayTime;

  /// No description provided for @settingsHoursBeforeEndHelp.
  ///
  /// In en, this message translates to:
  /// **'Notify N hours before the end of 14-hour wear period:'**
  String get settingsHoursBeforeEndHelp;

  /// No description provided for @settingsDaysBeforeReplacementHelp.
  ///
  /// In en, this message translates to:
  /// **'Remind N days before replacement date:'**
  String get settingsDaysBeforeReplacementHelp;

  /// No description provided for @settingsBatteryNoRestrictionsHint.
  ///
  /// In en, this message translates to:
  /// **'Choose \"No restrictions\" for the app in battery settings'**
  String get settingsBatteryNoRestrictionsHint;

  /// No description provided for @settingsReplacementNotificationTimeHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose time for replacement notifications'**
  String get settingsReplacementNotificationTimeHelp;

  /// No description provided for @settingsWarnWhenStockDrops.
  ///
  /// In en, this message translates to:
  /// **'Warn when lens stock drops to:'**
  String get settingsWarnWhenStockDrops;

  /// No description provided for @settingsStockBelowThreshold.
  ///
  /// In en, this message translates to:
  /// **'Lens stock ({count} {unit}) is below threshold!'**
  String settingsStockBelowThreshold(int count, String unit);

  /// No description provided for @settingsClearHistoryWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This action will delete:\n\n• All lens replacement history\n• All symptom records\n• Vision checks\n• Stock history\n\nAccount, lens type, and settings will be kept.\nThis action is IRREVERSIBLE!'**
  String get settingsClearHistoryWarning;

  /// No description provided for @settingsSolutionPurchaseReminder.
  ///
  /// In en, this message translates to:
  /// **'Solution purchase reminder'**
  String get settingsSolutionPurchaseReminder;

  /// No description provided for @settingsWeekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get settingsWeekday;

  /// No description provided for @settingsTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get settingsTime;

  /// No description provided for @settingsPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get settingsPeriod;

  /// No description provided for @historyToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get historyToday;

  /// No description provided for @notificationTestAllowForTest.
  ///
  /// In en, this message translates to:
  /// **'Please allow notifications for test'**
  String get notificationTestAllowForTest;

  /// No description provided for @notificationTestScheduledBody.
  ///
  /// In en, this message translates to:
  /// **'Scheduled test: notifications are working.'**
  String get notificationTestScheduledBody;

  /// No description provided for @notificationTestTitleInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Test in {seconds} sec'**
  String notificationTestTitleInSeconds(int seconds);

  /// No description provided for @notificationTestInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Notification in {seconds} sec'**
  String notificationTestInSeconds(int seconds);

  /// No description provided for @notificationTestInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Notification in {minutes} min'**
  String notificationTestInMinutes(int minutes);

  /// No description provided for @notificationTestScheduledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Scheduled: {message}. You can close the app.'**
  String notificationTestScheduledSuccess(String message);

  /// No description provided for @notificationTestPermissionNotGranted.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is not granted'**
  String get notificationTestPermissionNotGranted;

  /// No description provided for @notificationTestDebugBody.
  ///
  /// In en, this message translates to:
  /// **'zonedSchedule is working.'**
  String get notificationTestDebugBody;

  /// No description provided for @notificationTestDebugScheduledSuccess.
  ///
  /// In en, this message translates to:
  /// **'In {seconds} sec (zonedSchedule). You can close the app.'**
  String notificationTestDebugScheduledSuccess(int seconds);

  /// No description provided for @notificationTestManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Linsor - Test notification'**
  String get notificationTestManualTitle;

  /// No description provided for @notificationTestManualBody.
  ///
  /// In en, this message translates to:
  /// **'Notifications are working. Reminders will be delivered on time.'**
  String get notificationTestManualBody;

  /// No description provided for @notificationTestSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get notificationTestSent;

  /// No description provided for @notificationTestSendError.
  ///
  /// In en, this message translates to:
  /// **'Notification send error: {error}'**
  String notificationTestSendError(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
