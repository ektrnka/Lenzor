// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Linsor';

  @override
  String get appName => 'Linsor';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'App personalization';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageEnglish => 'English';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get refreshStatus => 'Refresh status';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsReplacementReminders => 'Replacement reminders';

  @override
  String get notificationsStatus => 'Notification status';

  @override
  String get notificationsDisabled => 'Notifications disabled';

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsOff => 'Notifications are off';

  @override
  String get allowBackgroundWork => 'Allow background work';

  @override
  String get allowBackgroundWorkSubtitle =>
      'Needed for reminders when the app is closed';

  @override
  String get loadingDots => '...';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Try again';

  @override
  String get lensTypeDaily => 'Daily';

  @override
  String get lensTypeWeekly => 'Weekly';

  @override
  String get lensTypeBiweekly => 'Bi-weekly';

  @override
  String get lensTypeMonthly => 'Monthly';

  @override
  String get lensTypeQuarterly => 'Quarterly';

  @override
  String get lensTypeHalfYearly => 'Semi-annual';

  @override
  String get symptomDiscomfort => 'Discomfort';

  @override
  String get symptomDryEyes => 'Dry eyes';

  @override
  String get symptomRedness => 'Redness';

  @override
  String get symptomTearing => 'Tearing';

  @override
  String get symptomBlurryVision => 'Blurred vision';

  @override
  String get symptomPain => 'Pain';

  @override
  String get symptomLightSensitivity => 'Light sensitivity';

  @override
  String get symptomEyeFatigue => 'Eye fatigue';

  @override
  String get wordDayOne => 'day';

  @override
  String get wordDayFew => 'days';

  @override
  String get wordDayMany => 'days';

  @override
  String get wordHourOne => 'hour';

  @override
  String get wordHourFew => 'hours';

  @override
  String get wordHourMany => 'hours';

  @override
  String get wordPairOne => 'pair';

  @override
  String get wordPairFew => 'pairs';

  @override
  String get wordPairMany => 'pairs';

  @override
  String get homeTitle => 'Linsor';

  @override
  String get homeSubtitle => 'Contact lens tracking';

  @override
  String get homeWearing => 'Wearing';

  @override
  String get homeStock => 'Stock';

  @override
  String get homeUpdateStock => 'Update stock';

  @override
  String get homeHowManyPairsToAdd => 'How many pairs to add';

  @override
  String homeCurrentStock(int count) {
    return 'Current stock: $count pairs';
  }

  @override
  String get homeEnterPositiveNumber => 'Enter a positive number';

  @override
  String get homeNoActiveLenses => 'You have no active lenses';

  @override
  String get homeCompleteWearing => 'Complete wearing';

  @override
  String get homeCompleteWearingQuestion => 'Complete wearing?';

  @override
  String get homeCompleteWearingConfirm =>
      'Are you sure you want to complete the current lens cycle?';

  @override
  String get homeWearingCompleted => 'Wearing cycle completed';

  @override
  String get homeTipsTitle => 'Care tips';

  @override
  String get homeNoCyclePlaceholder =>
      'The current cycle will appear here once you start using lenses';

  @override
  String get homePutOnNewPair => 'Put on a new pair';

  @override
  String get homeOverdueBy => 'Lenses are overdue by';

  @override
  String get homeUntilReplacement => 'Until replacement';

  @override
  String get mainAddRecord => 'Add record';

  @override
  String mainRecordForDate(String date) {
    return 'Record for $date';
  }

  @override
  String mainAddRecordForDate(String date) {
    return 'Add record for $date';
  }

  @override
  String get mainCannotAddFutureRecords =>
      'You can\'t add records for future dates';

  @override
  String get mainReplaceLenses => 'Replace lenses';

  @override
  String get mainReplaceLensesDescription => 'Start a new pair cycle';

  @override
  String get mainUpdateStockDescription => 'Change pairs in stock';

  @override
  String get mainAddSymptoms => 'Add symptoms';

  @override
  String get mainAddSymptomsDescription => 'Mark discomfort or issues';

  @override
  String get mainTakeOffLenses => 'Take off lenses';

  @override
  String get mainTakeOffLensesDescription => 'Complete current wearing cycle';

  @override
  String get mainNotEnoughLenses => 'Not enough lenses';

  @override
  String get mainNoLensesAndTakeOffPrompt =>
      'You\'re out of lenses and cannot start a new pair. Take off current lenses instead?';

  @override
  String get mainNoLensesAddStockPrompt =>
      'You\'re out of lenses. Add stock in the Profile section.';

  @override
  String get mainLensReplacement => 'Lens replacement';

  @override
  String get mainStartNewPairQuestion =>
      'Start a new lens pair cycle? The current cycle will be completed automatically.';

  @override
  String get mainPutOnNewPairQuestion => 'Put on a new lens pair?';

  @override
  String get mainReplace => 'Replace';

  @override
  String mainLowStockWarning(int count) {
    return 'Low stock warning: $count pairs left';
  }

  @override
  String get mainErrorReplacingLenses => 'Error while replacing lenses';

  @override
  String mainTimeMessageHoursBefore(int hours) {
    return 'Take lenses off in $hours h';
  }

  @override
  String get mainTimeMessageExpiry =>
      'Time to take off lenses! (14 hours passed)';

  @override
  String get mainTomorrow => 'Tomorrow';

  @override
  String mainInDays(int days) {
    return 'In $days days';
  }

  @override
  String mainTimeToReplaceMessage(String when) {
    return '$when it\'s time to replace lenses';
  }

  @override
  String get mainTakeOffConfirm =>
      'Are you sure you want to complete the current wearing cycle? This will create a lens removal entry.';

  @override
  String get historyTitle => 'Usage history';

  @override
  String get historySubtitle => 'Lens wearing cycles';

  @override
  String get historyAllTime => 'All time';

  @override
  String get historyLegendActive => 'Active';

  @override
  String get historyLegendCompleted => 'Completed';

  @override
  String get historyLegendSoon => 'Replace soon';

  @override
  String get historyLegendOverdue => 'Overdue';

  @override
  String get historyEmptyTitle => 'History is empty';

  @override
  String get historyEmptyDescription =>
      'Start wearing lenses and your cycle history will appear here';

  @override
  String get historyCompletedByRemoval => 'Completed by manual removal';

  @override
  String get historyCompletedByReplacement => 'Completed by replacement';

  @override
  String historyPassedOfHours(int used, int total) {
    return 'Passed: $used of $total hours';
  }

  @override
  String historyUsedOfHours(int used, int total) {
    return 'Used: $used of $total hours';
  }

  @override
  String historyRecommendedHours(int from, int to) {
    return 'Recommended: $from-$to hours';
  }

  @override
  String historyPassedOfDays(int used, int total) {
    return 'Passed: $used of $total days';
  }

  @override
  String historyUsedOfDays(int used, int total) {
    return 'Used: $used of $total days';
  }

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarAllYears => 'All years';

  @override
  String get calendarLegendWearDays => 'Wearing days';

  @override
  String get calendarLegendOverwear => 'Overwear';

  @override
  String get calendarLegendReplacement => 'Replacement';

  @override
  String get calendarLegendSymptoms => 'Symptoms';

  @override
  String get calendarLegendVisionCheck => 'Vision check';

  @override
  String get calendarLegendStock => 'Stock';

  @override
  String get calendarLoadError => 'Failed to load calendar';

  @override
  String get calendarDetailsInfo => 'Information';

  @override
  String get calendarNoRecordsDay => 'No records for this day';

  @override
  String get calendarOverwearDay =>
      'Overwear: wearing period was exceeded on this day';

  @override
  String get calendarWearingNoDetails => 'Wearing day with no extra records';

  @override
  String get calendarNewPair => 'New pair of lenses';

  @override
  String get calendarManualRemoval => 'Lenses removed manually';

  @override
  String get calendarNote => 'Note';

  @override
  String get calendarNoAdditionalDetails => 'No additional details';

  @override
  String get calendarLeftEye => 'Left eye';

  @override
  String get calendarRightEye => 'Right eye';

  @override
  String get calendarStockLabel => 'Stock';

  @override
  String get calendarReplacementTitle => 'Lens replacement';

  @override
  String get calendarSymptomsTitle => 'Symptoms';

  @override
  String get calendarVisionTitle => 'Vision check';

  @override
  String get calendarStockUpdateTitle => 'Stock update';

  @override
  String get onboardingSubtitle => 'Contact lens monitoring';

  @override
  String get onboardingSignInPrompt => 'Sign in to sync data across devices';

  @override
  String get onboardingSignInGoogle => 'Sign in with Google';

  @override
  String get onboardingContinueWithoutAccount => 'Continue without account';

  @override
  String onboardingSignInFailed(String reason) {
    return 'Sign-in failed: $reason';
  }

  @override
  String get onboardingDataConflictTitle =>
      'You have data both on device and in account';

  @override
  String get onboardingDataConflictMessage =>
      'Choose which data to keep: device data can be uploaded, or cloud data can replace local data.';

  @override
  String get onboardingUseCloudData => 'Load from account';

  @override
  String get onboardingKeepDeviceData => 'Keep device data';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSubtitle => 'Your info and history';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileUser => 'User';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileSignInHint => 'Sign in to sync data across devices';

  @override
  String get profileSignInGoogle => 'Sign in with Google';

  @override
  String profileSyncError(String reason) {
    return 'Sync error: $reason';
  }

  @override
  String get profileStatisticsTotalCycles => 'Total cycles';

  @override
  String get profileStatisticsAverageDays => 'Average, days';

  @override
  String get profileLensInfoTitle => 'Lens information';

  @override
  String get profileVisionCheckTitle => 'Vision check';

  @override
  String get profileDeleteHistoryTitle => 'Clear history';

  @override
  String get profileDeleteHistoryConfirm =>
      'Are you sure you want to clear history?';

  @override
  String get notificationAllowTitle => 'Allow notifications?';

  @override
  String get notificationAllowSubtitle => 'Linsor uses notifications for:';

  @override
  String get notificationFeatureReplacement => 'Replacement reminders';

  @override
  String get notificationFeatureEyeHealth => 'Eye health tips';

  @override
  String get notificationFeaturePeriodControl => 'Wearing period control';

  @override
  String get notificationFeatureWarnings => 'Important warnings';

  @override
  String get notificationAllowLater => 'Not now';

  @override
  String get notificationAllow => 'Allow';

  @override
  String get notificationBlockedTitle => 'Notifications are blocked';

  @override
  String get notificationBlockedMessage =>
      'Open device settings and allow notifications for Linsor.';

  @override
  String get notificationOpenSettings => 'Open settings';

  @override
  String get notificationPermissionError => 'Permission request error';

  @override
  String get notificationPermissionGranted =>
      'Notifications enabled. You will receive reminders.';

  @override
  String get notificationPermissionDenied =>
      'Notifications are disabled. You can enable them later in Settings.';

  @override
  String get notificationPermissionDisableAnytime =>
      'You can disable notifications anytime in Settings.';

  @override
  String get notificationBlockedMessageDetailed =>
      'You previously denied notification permission.\n\nTo enable it:\n1. Open device settings\n2. Find Linsor\n3. Allow notifications\n4. Return to the app';

  @override
  String get notificationChannelName => 'Lens reminders';

  @override
  String get notificationChannelDescription =>
      'Lens replacement and eye health notifications';

  @override
  String get notificationTitleReplace => 'Time to replace lenses!';

  @override
  String get notificationBodyReplaceToday =>
      'Today is the recommended replacement date.';

  @override
  String get notificationActionDone => 'I replaced them';

  @override
  String get notificationActionSnooze => 'Remind me later';

  @override
  String get notificationDailyTipTitle => 'Care tip';

  @override
  String get notificationSolutionTitle => 'Solution purchase';

  @override
  String get notificationSolutionBody => 'Time to buy contact lens solution';

  @override
  String get notificationLowStockTitle => 'Low stock reminder';

  @override
  String appNavMarkDoneQuestion(String lensName) {
    return 'Did you replace \"$lensName\"?';
  }

  @override
  String get appNavAfterConfirm => 'After confirmation:';

  @override
  String get appNavMarkDoneFeature1 => 'Lenses will be marked as replaced';

  @override
  String get appNavMarkDoneFeature2 => 'A new wearing cycle will start';

  @override
  String get appNavMarkDoneFeature3 => 'Stock will decrease by 1 pair';

  @override
  String get appNavMarkDoneFeature4 => 'Old reminders will be removed';

  @override
  String get appNavMarkDoneFeature5 => 'New reminders will be scheduled';

  @override
  String get appNavMarkDoneConfirmButton => 'Yes, replaced';

  @override
  String get appNavRestock => 'Restock';

  @override
  String get appNavSnoozeChooseTime => 'Choose when to remind about lenses:';

  @override
  String get appNavSnoozeIn1Hour => 'In 1 hour';

  @override
  String get appNavSnoozeIn3Hours => 'In 3 hours';

  @override
  String get appNavSnoozeTomorrowMorning => 'Tomorrow morning';

  @override
  String get appNavSnoozeIn2Days => 'In 2 days';

  @override
  String get appNavReminderDelayedMessage =>
      'Reminder delayed. Time to replace lenses.';

  @override
  String appNavReminderSnoozedFor(String duration) {
    return 'Reminder delayed for $duration';
  }

  @override
  String get appNavEyeHealthTitle => 'Eye health';

  @override
  String get appNavEyeHealthSubtitle => 'Contact lens recommendations:';

  @override
  String get appNavEyeHealthTip1 => 'Wash your hands before handling lenses';

  @override
  String get appNavEyeHealthTip2 => 'Follow the replacement schedule';

  @override
  String get appNavEyeHealthTip3 =>
      'Do not sleep in lenses unless approved for overnight wear';

  @override
  String get appNavEyeHealthTip4 => 'Use fresh solution every day';

  @override
  String get appNavEyeHealthTip5 => 'Visit your eye doctor regularly';

  @override
  String get appNavEyeHealthTip6 =>
      'Avoid water (pool, shower) while wearing lenses';

  @override
  String get appNavEyeHealthWarning =>
      'If discomfort, redness, or blurry vision appears, remove lenses and consult a doctor.';

  @override
  String get appNavClose => 'Close';

  @override
  String get appNavMyLenses => 'My lenses';

  @override
  String get appNavOpenProfileSetupHint =>
      'Open profile editing to set up lenses';

  @override
  String get appNavMinutesShort => 'min';

  @override
  String get profileSignOutDataTitle => 'What to do with your data?';

  @override
  String get profileSignOutDataMessage =>
      'Data will stay in the cloud and be available after sign-in.\n\n• Keep on device — continue working offline\n• Delete from device — free space, cloud data remains available';

  @override
  String get profileDeleteFromDevice => 'Delete from device';

  @override
  String get profileKeepOnDevice => 'Keep on device';

  @override
  String get profileLensType => 'Lens type';

  @override
  String get profileWearingPeriod => 'Wearing period';

  @override
  String get profileBaseCurve => 'Base curve';

  @override
  String get profileDiameter => 'Diameter';

  @override
  String get profileFirstUseDate => 'First use date';

  @override
  String get profileBrand => 'Brand';

  @override
  String get profileChangeLensType => 'Change lens type';

  @override
  String get profileVision => 'Vision';

  @override
  String get profileNoVisionData => 'No vision data';

  @override
  String get profileAddCheck => 'Add check';

  @override
  String get profileNoVisionRecords => 'No vision check records';

  @override
  String get profileAddFirstCheckHint => 'Add the first check to track changes';

  @override
  String profileDeleteVisionCheckMessage(String date) {
    return 'Vision check from $date will be deleted permanently.';
  }

  @override
  String get profileLensSetup => 'Lens setup';

  @override
  String get profileContactLensType => 'Contact lens type';

  @override
  String get profileLensBrand => 'Lens brand';

  @override
  String get profileLensBrandHint => 'Example: Acuvue Oasys';

  @override
  String get profileBaseCurveWithCode => 'Base curve (BC)';

  @override
  String get profileDiameterWithCode => 'Diameter (DIA)';

  @override
  String get profileLeftMm => 'Left, mm';

  @override
  String get profileRightMm => 'Right, mm';

  @override
  String get profileLensTypeChangeWarning =>
      'Changing lens type affects current cycle. The new type will apply to current and next cycles.';

  @override
  String get profileCheckDate => 'Check date';

  @override
  String get profileOpticalPowerSph => 'Optical power (SPH)';

  @override
  String get profileCylinderCyl => 'Cylinder (CYL) - for astigmatism';

  @override
  String get profileAxis => 'Axis (AXIS) - for astigmatism';

  @override
  String get profileAstigmatismHint =>
      'Leave CYL and AXIS empty if you do not have astigmatism.';

  @override
  String get profileFillSphError => 'Please fill in optical power (SPH)';

  @override
  String get profileLeftAxisError =>
      'For left eye CYL, specify AXIS from 0 to 180°';

  @override
  String get profileRightAxisError =>
      'For right eye CYL, specify AXIS from 0 to 180°';

  @override
  String settingsDailyAt(String time) {
    return 'Daily at $time';
  }

  @override
  String get settingsTipTime => 'Tip time';

  @override
  String get settingsNotificationTime => 'Notification time';

  @override
  String settingsEveryMonths(int months) {
    return 'every $months month(s)';
  }

  @override
  String settingsDailyAtLowStock(String time) {
    return 'Daily at $time when stock is below threshold';
  }

  @override
  String get settingsLowStockReminderHelp =>
      'A daily notification will be sent at the selected time if lens stock is below the warning threshold.';

  @override
  String get settingsLensStock => 'Lens stock';

  @override
  String get settingsAlertThreshold => 'Alert threshold';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsDataManagement => 'Data management';

  @override
  String get settingsDeleteAllHistory => 'Delete all history';

  @override
  String get settingsHoursBeforeEndTitle => 'How many hours before end';

  @override
  String get settingsAtExpiry => 'At expiry';

  @override
  String get settingsDaysBeforeReplacement =>
      'How many days before replacement';

  @override
  String get settingsReplacementDayTime => 'Time on replacement day';

  @override
  String get settingsHoursBeforeEndHelp =>
      'Notify N hours before the end of 14-hour wear period:';

  @override
  String get settingsDaysBeforeReplacementHelp =>
      'Remind N days before replacement date:';

  @override
  String get settingsBatteryNoRestrictionsHint =>
      'Choose \"No restrictions\" for the app in battery settings';

  @override
  String get settingsReplacementNotificationTimeHelp =>
      'Choose time for replacement notifications';

  @override
  String get settingsWarnWhenStockDrops => 'Warn when lens stock drops to:';

  @override
  String settingsStockBelowThreshold(int count, String unit) {
    return 'Lens stock ($count $unit) is below threshold!';
  }

  @override
  String get settingsClearHistoryWarning =>
      'Are you sure? This action will delete:\n\n• All lens replacement history\n• All symptom records\n• Vision checks\n• Stock history\n\nAccount, lens type, and settings will be kept.\nThis action is IRREVERSIBLE!';

  @override
  String get settingsSolutionPurchaseReminder => 'Solution purchase reminder';

  @override
  String get settingsWeekday => 'Weekday';

  @override
  String get settingsTime => 'Time';

  @override
  String get settingsPeriod => 'Period';

  @override
  String get historyToday => 'today';

  @override
  String get notificationTestAllowForTest =>
      'Please allow notifications for test';

  @override
  String get notificationTestScheduledBody =>
      'Scheduled test: notifications are working.';

  @override
  String notificationTestTitleInSeconds(int seconds) {
    return 'Test in $seconds sec';
  }

  @override
  String notificationTestInSeconds(int seconds) {
    return 'Notification in $seconds sec';
  }

  @override
  String notificationTestInMinutes(int minutes) {
    return 'Notification in $minutes min';
  }

  @override
  String notificationTestScheduledSuccess(String message) {
    return 'Scheduled: $message. You can close the app.';
  }

  @override
  String get notificationTestPermissionNotGranted =>
      'Notification permission is not granted';

  @override
  String get notificationTestDebugBody => 'zonedSchedule is working.';

  @override
  String notificationTestDebugScheduledSuccess(int seconds) {
    return 'In $seconds sec (zonedSchedule). You can close the app.';
  }

  @override
  String get notificationTestManualTitle => 'Linsor - Test notification';

  @override
  String get notificationTestManualBody =>
      'Notifications are working. Reminders will be delivered on time.';

  @override
  String get notificationTestSent => 'Test notification sent';

  @override
  String notificationTestSendError(String error) {
    return 'Notification send error: $error';
  }
}
