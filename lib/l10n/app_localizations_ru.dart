// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Линзор';

  @override
  String get appName => 'Linsor';

  @override
  String get navHome => 'Главная';

  @override
  String get navHistory => 'История';

  @override
  String get navProfile => 'Профиль';

  @override
  String get navSettings => 'Настройки';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSubtitle => 'Персонализация приложения';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get languageSystem => 'Системный';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get refreshStatus => 'Обновить статус';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notificationsReplacementReminders => 'Напоминания о замене';

  @override
  String get notificationsStatus => 'Статус уведомлений';

  @override
  String get notificationsDisabled => 'Уведомления отключены';

  @override
  String get notificationsEnabled => 'Уведомления включены';

  @override
  String get notificationsOff => 'Уведомления отключены';

  @override
  String get allowBackgroundWork => 'Разрешить фоновую работу';

  @override
  String get allowBackgroundWorkSubtitle =>
      'Нужно для напоминаний, когда приложение закрыто';

  @override
  String get loadingDots => '...';

  @override
  String get error => 'Ошибка';

  @override
  String get ok => 'ОК';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get delete => 'Удалить';

  @override
  String get retry => 'Повторить';

  @override
  String get lensTypeDaily => 'Однодневные';

  @override
  String get lensTypeWeekly => 'Недельные';

  @override
  String get lensTypeBiweekly => 'Двухнедельные';

  @override
  String get lensTypeMonthly => 'Месячные';

  @override
  String get lensTypeQuarterly => 'Квартальные';

  @override
  String get lensTypeHalfYearly => 'Полугодовые';

  @override
  String get symptomDiscomfort => 'Дискомфорт';

  @override
  String get symptomDryEyes => 'Сухость глаз';

  @override
  String get symptomRedness => 'Покраснение';

  @override
  String get symptomTearing => 'Слезотечение';

  @override
  String get symptomBlurryVision => 'Размытое зрение';

  @override
  String get symptomPain => 'Боль';

  @override
  String get symptomLightSensitivity => 'Светочувствительность';

  @override
  String get symptomEyeFatigue => 'Усталость глаз';

  @override
  String get wordDayOne => 'день';

  @override
  String get wordDayFew => 'дня';

  @override
  String get wordDayMany => 'дней';

  @override
  String get wordHourOne => 'час';

  @override
  String get wordHourFew => 'часа';

  @override
  String get wordHourMany => 'часов';

  @override
  String get wordPairOne => 'пара';

  @override
  String get wordPairFew => 'пары';

  @override
  String get wordPairMany => 'пар';

  @override
  String get homeTitle => 'Линзор';

  @override
  String get homeSubtitle => 'Мониторинг контактных линз';

  @override
  String get homeWearing => 'Ношение';

  @override
  String get homeStock => 'Запас';

  @override
  String get homeUpdateStock => 'Обновить запас';

  @override
  String get homeHowManyPairsToAdd => 'Сколько пар добавить';

  @override
  String homeCurrentStock(int count) {
    return 'Текущий запас: $count пар';
  }

  @override
  String get homeEnterPositiveNumber => 'Введите положительное число';

  @override
  String get homeNoActiveLenses => 'У вас нет активных линз';

  @override
  String get homeCompleteWearing => 'Завершить ношение';

  @override
  String get homeCompleteWearingQuestion => 'Завершить ношение?';

  @override
  String get homeCompleteWearingConfirm =>
      'Вы уверены, что хотите завершить текущий цикл ношения линз?';

  @override
  String get homeWearingCompleted => 'Цикл ношения завершён';

  @override
  String get homeTipsTitle => 'Советы по уходу';

  @override
  String get homeNoCyclePlaceholder =>
      'Текущий цикл появится здесь после начала ношения линз';

  @override
  String get homePutOnNewPair => 'Надеть новую пару';

  @override
  String get homeOverdueBy => 'Линзы просрочены на';

  @override
  String get homeUntilReplacement => 'До замены линз';

  @override
  String get mainAddRecord => 'Добавить запись';

  @override
  String mainRecordForDate(String date) {
    return 'Запись за $date';
  }

  @override
  String mainAddRecordForDate(String date) {
    return 'Добавить запись за $date';
  }

  @override
  String get mainCannotAddFutureRecords =>
      'Нельзя добавлять записи на будущие даты';

  @override
  String get mainReplaceLenses => 'Заменить линзы';

  @override
  String get mainReplaceLensesDescription => 'Начать новый цикл пары';

  @override
  String get mainUpdateStockDescription => 'Изменить количество пар в запасе';

  @override
  String get mainAddSymptoms => 'Добавить симптомы';

  @override
  String get mainAddSymptomsDescription => 'Отметить дискомфорт или проблемы';

  @override
  String get mainTakeOffLenses => 'Снять линзы';

  @override
  String get mainTakeOffLensesDescription => 'Завершить текущий цикл ношения';

  @override
  String get mainNotEnoughLenses => 'Недостаточно линз';

  @override
  String get mainNoLensesAndTakeOffPrompt =>
      'Линзы закончились, начать новую пару нельзя.\n\nСнять текущие линзы?';

  @override
  String get mainNoLensesAddStockPrompt =>
      'Линзы закончились. Пополните запас в разделе «Профиль».';

  @override
  String get mainLensReplacement => 'Замена линз';

  @override
  String get mainStartNewPairQuestion =>
      'Начать новый цикл пары линз?\n\nТекущий цикл будет завершён автоматически.';

  @override
  String get mainPutOnNewPairQuestion => 'Надеть новую пару линз?';

  @override
  String get mainReplace => 'Заменить';

  @override
  String mainLowStockWarning(int count) {
    return 'Низкий запас: осталось $count пар';
  }

  @override
  String get mainErrorReplacingLenses => 'Ошибка при замене линз';

  @override
  String mainTimeMessageHoursBefore(int hours) {
    return 'Снимите линзы через $hours ч';
  }

  @override
  String get mainTimeMessageExpiry => 'Пора снять линзы! (прошло 14 часов)';

  @override
  String get mainTomorrow => 'Завтра';

  @override
  String mainInDays(int days) {
    return 'Через $days дней';
  }

  @override
  String mainTimeToReplaceMessage(String when) {
    return '$when пора заменить линзы';
  }

  @override
  String get mainTakeOffConfirm =>
      'Вы уверены, что хотите завершить текущий цикл ношения? Будет создана запись о снятии линз.';

  @override
  String get historyTitle => 'История ношения';

  @override
  String get historySubtitle => 'Циклы ношения линз';

  @override
  String get historyAllTime => 'За всё время';

  @override
  String get historyLegendActive => 'Активно';

  @override
  String get historyLegendCompleted => 'Завершено';

  @override
  String get historyLegendSoon => 'Скоро замена';

  @override
  String get historyLegendOverdue => 'Просрочено';

  @override
  String get historyEmptyTitle => 'История пуста';

  @override
  String get historyEmptyDescription =>
      'Начните носить линзы, и здесь появится история циклов';

  @override
  String get historyCompletedByRemoval => 'Завершено ручным снятием';

  @override
  String get historyCompletedByReplacement => 'Завершено заменой';

  @override
  String historyPassedOfHours(int used, int total) {
    return 'Прошло: $used из $total часов';
  }

  @override
  String historyUsedOfHours(int used, int total) {
    return 'Использовано: $used из $total часов';
  }

  @override
  String historyRecommendedHours(int from, int to) {
    return 'Рекомендовано: $from-$to часов';
  }

  @override
  String historyPassedOfDays(int used, int total) {
    return 'Прошло: $used из $total дней';
  }

  @override
  String historyUsedOfDays(int used, int total) {
    return 'Использовано: $used из $total дней';
  }

  @override
  String get calendarTitle => 'Календарь';

  @override
  String get calendarAllYears => 'Все годы';

  @override
  String get calendarLegendWearDays => 'Дни ношения';

  @override
  String get calendarLegendOverwear => 'Перенашивание';

  @override
  String get calendarLegendReplacement => 'Замена';

  @override
  String get calendarLegendSymptoms => 'Симптомы';

  @override
  String get calendarLegendVisionCheck => 'Проверка зрения';

  @override
  String get calendarLegendStock => 'Запас';

  @override
  String get calendarLoadError => 'Не удалось загрузить календарь';

  @override
  String get calendarDetailsInfo => 'Информация';

  @override
  String get calendarNoRecordsDay => 'На этот день нет записей';

  @override
  String get calendarOverwearDay =>
      'Перенашивание: в этот день срок ношения был превышен';

  @override
  String get calendarWearingNoDetails =>
      'День ношения без дополнительных записей';

  @override
  String get calendarNewPair => 'Новая пара линз';

  @override
  String get calendarManualRemoval => 'Линзы сняты вручную';

  @override
  String get calendarNote => 'Заметка';

  @override
  String get calendarNoAdditionalDetails => 'Нет дополнительных деталей';

  @override
  String get calendarLeftEye => 'Левый глаз';

  @override
  String get calendarRightEye => 'Правый глаз';

  @override
  String get calendarStockLabel => 'Запас';

  @override
  String get calendarReplacementTitle => 'Замена линз';

  @override
  String get calendarSymptomsTitle => 'Симптомы';

  @override
  String get calendarVisionTitle => 'Проверка зрения';

  @override
  String get calendarStockUpdateTitle => 'Обновление запаса';

  @override
  String get onboardingSubtitle => 'Мониторинг контактных линз';

  @override
  String get onboardingSignInPrompt =>
      'Войдите, чтобы синхронизировать данные между устройствами';

  @override
  String get onboardingSignInGoogle => 'Войти через Google';

  @override
  String get onboardingContinueWithoutAccount => 'Продолжить без аккаунта';

  @override
  String onboardingSignInFailed(String reason) {
    return 'Ошибка входа: $reason';
  }

  @override
  String get onboardingDataConflictTitle =>
      'Данные есть и на устройстве, и в аккаунте';

  @override
  String get onboardingDataConflictMessage =>
      'Выберите, какие данные оставить: данные устройства можно загрузить в облако, либо облачные данные заменят локальные.';

  @override
  String get onboardingUseCloudData => 'Загрузить из аккаунта';

  @override
  String get onboardingKeepDeviceData => 'Оставить данные устройства';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileSubtitle => 'Ваши данные и история';

  @override
  String get profileAccount => 'Аккаунт';

  @override
  String get profileUser => 'Пользователь';

  @override
  String get profileSignOut => 'Выйти';

  @override
  String get profileSignInHint =>
      'Войдите, чтобы синхронизировать данные между устройствами';

  @override
  String get profileSignInGoogle => 'Войти через Google';

  @override
  String profileSyncError(String reason) {
    return 'Ошибка синхронизации: $reason';
  }

  @override
  String get profileStatisticsTotalCycles => 'Всего циклов';

  @override
  String get profileStatisticsAverageDays => 'Среднее, дней';

  @override
  String get profileLensInfoTitle => 'Информация о линзах';

  @override
  String get profileVisionCheckTitle => 'Проверки зрения';

  @override
  String get profileDeleteHistoryTitle => 'Очистить историю';

  @override
  String get profileDeleteHistoryConfirm =>
      'Вы уверены, что хотите очистить историю?';

  @override
  String get notificationAllowTitle => 'Разрешить уведомления?';

  @override
  String get notificationAllowSubtitle => 'Linsor использует уведомления для:';

  @override
  String get notificationFeatureReplacement => 'Напоминаний о замене';

  @override
  String get notificationFeatureEyeHealth => 'Советов по здоровью глаз';

  @override
  String get notificationFeaturePeriodControl => 'Контроля срока ношения';

  @override
  String get notificationFeatureWarnings => 'Важных предупреждений';

  @override
  String get notificationAllowLater => 'Не сейчас';

  @override
  String get notificationAllow => 'Разрешить';

  @override
  String get notificationBlockedTitle => 'Уведомления заблокированы';

  @override
  String get notificationBlockedMessage =>
      'Откройте настройки устройства и разрешите уведомления для Linsor.';

  @override
  String get notificationOpenSettings => 'Открыть настройки';

  @override
  String get notificationPermissionError => 'Ошибка запроса разрешения';

  @override
  String get notificationPermissionGranted =>
      'Уведомления включены. Вы будете получать напоминания.';

  @override
  String get notificationPermissionDenied =>
      'Уведомления отключены. Вы можете включить их позже в Настройках.';

  @override
  String get notificationPermissionDisableAnytime =>
      'Вы можете отключить уведомления в любое время в Настройках.';

  @override
  String get notificationBlockedMessageDetailed =>
      'Вы ранее отклонили разрешение на уведомления.\n\nЧтобы включить его:\n1. Откройте настройки устройства\n2. Найдите Linsor\n3. Разрешите уведомления\n4. Вернитесь в приложение';

  @override
  String get notificationChannelName => 'Напоминания о линзах';

  @override
  String get notificationChannelDescription =>
      'Уведомления о замене линз и здоровье глаз';

  @override
  String get notificationTitleReplace => 'Пора заменить линзы!';

  @override
  String get notificationBodyReplaceToday =>
      'Сегодня рекомендованная дата замены.';

  @override
  String get notificationActionDone => 'Я заменил(а)';

  @override
  String get notificationActionSnooze => 'Напомнить позже';

  @override
  String get notificationDailyTipTitle => 'Совет по уходу';

  @override
  String get notificationSolutionTitle => 'Покупка раствора';

  @override
  String get notificationSolutionBody =>
      'Пора купить раствор для контактных линз';

  @override
  String get notificationLowStockTitle => 'Напоминание о низком запасе';

  @override
  String appNavMarkDoneQuestion(String lensName) {
    return 'Вы заменили «$lensName»?';
  }

  @override
  String get appNavAfterConfirm => 'После подтверждения:';

  @override
  String get appNavMarkDoneFeature1 => 'Линзы будут отмечены как заменённые';

  @override
  String get appNavMarkDoneFeature2 => 'Начнётся новый цикл ношения';

  @override
  String get appNavMarkDoneFeature3 => 'Запас уменьшится на 1 пару';

  @override
  String get appNavMarkDoneFeature4 => 'Старые напоминания будут удалены';

  @override
  String get appNavMarkDoneFeature5 => 'Новые напоминания будут запланированы';

  @override
  String get appNavMarkDoneConfirmButton => 'Да, заменил(а)';

  @override
  String get appNavRestock => 'Пополнить запас';

  @override
  String get appNavSnoozeChooseTime => 'Выберите, когда напомнить о линзах:';

  @override
  String get appNavSnoozeIn1Hour => 'Через 1 час';

  @override
  String get appNavSnoozeIn3Hours => 'Через 3 часа';

  @override
  String get appNavSnoozeTomorrowMorning => 'Завтра утром';

  @override
  String get appNavSnoozeIn2Days => 'Через 2 дня';

  @override
  String get appNavReminderDelayedMessage =>
      'Напоминание отложено. Пора заменить линзы.';

  @override
  String appNavReminderSnoozedFor(String duration) {
    return 'Напоминание отложено на $duration';
  }

  @override
  String get appNavEyeHealthTitle => 'Здоровье глаз';

  @override
  String get appNavEyeHealthSubtitle => 'Рекомендации по контактным линзам:';

  @override
  String get appNavEyeHealthTip1 => 'Мойте руки перед обращением с линзами';

  @override
  String get appNavEyeHealthTip2 => 'Соблюдайте график замены';

  @override
  String get appNavEyeHealthTip3 => 'Не спите в линзах без разрешения врача';

  @override
  String get appNavEyeHealthTip4 => 'Используйте свежий раствор каждый день';

  @override
  String get appNavEyeHealthTip5 => 'Регулярно посещайте офтальмолога';

  @override
  String get appNavEyeHealthTip6 => 'Избегайте воды (бассейн, душ) в линзах';

  @override
  String get appNavEyeHealthWarning =>
      'Если появились дискомфорт, покраснение или размытое зрение — снимите линзы и обратитесь к врачу.';

  @override
  String get appNavClose => 'Закрыть';

  @override
  String get appNavMyLenses => 'Мои линзы';

  @override
  String get appNavOpenProfileSetupHint =>
      'Откройте профиль, чтобы настроить линзы';

  @override
  String get appNavMinutesShort => 'мин';

  @override
  String get profileSignOutDataTitle => 'Что сделать с данными?';

  @override
  String get profileSignOutDataMessage =>
      'Данные останутся в облаке и будут доступны после входа.\n\n• Оставить на устройстве — продолжить офлайн\n• Удалить с устройства — освободить место, данные в облаке сохранятся';

  @override
  String get profileDeleteFromDevice => 'Удалить с устройства';

  @override
  String get profileKeepOnDevice => 'Оставить на устройстве';

  @override
  String get profileLensType => 'Тип линз';

  @override
  String get profileWearingPeriod => 'Срок ношения';

  @override
  String get profileBaseCurve => 'Базовая кривизна';

  @override
  String get profileDiameter => 'Диаметр';

  @override
  String get profileFirstUseDate => 'Дата первого использования';

  @override
  String get profileBrand => 'Бренд';

  @override
  String get profileChangeLensType => 'Изменить тип линз';

  @override
  String get profileVision => 'Зрение';

  @override
  String get profileNoVisionData => 'Нет данных о зрении';

  @override
  String get profileAddCheck => 'Добавить проверку';

  @override
  String get profileNoVisionRecords => 'Нет записей проверки зрения';

  @override
  String get profileAddFirstCheckHint =>
      'Добавьте первую проверку, чтобы отслеживать изменения';

  @override
  String profileDeleteVisionCheckMessage(String date) {
    return 'Проверка зрения от $date будет удалена безвозвратно.';
  }

  @override
  String get profileLensSetup => 'Настройка линз';

  @override
  String get profileContactLensType => 'Тип контактных линз';

  @override
  String get profileLensBrand => 'Бренд линз';

  @override
  String get profileLensBrandHint => 'Например: Acuvue Oasys';

  @override
  String get profileBaseCurveWithCode => 'Базовая кривизна (BC)';

  @override
  String get profileDiameterWithCode => 'Диаметр (DIA)';

  @override
  String get profileLeftMm => 'Левый, мм';

  @override
  String get profileRightMm => 'Правый, мм';

  @override
  String get profileLensTypeChangeWarning =>
      'Изменение типа линз влияет на текущий цикл. Новый тип будет применён к текущему и следующим циклам.';

  @override
  String get profileCheckDate => 'Дата проверки';

  @override
  String get profileOpticalPowerSph => 'Оптическая сила (SPH)';

  @override
  String get profileCylinderCyl => 'Цилиндр (CYL) — для астигматизма';

  @override
  String get profileAxis => 'Ось (AXIS) — для астигматизма';

  @override
  String get profileAstigmatismHint =>
      'Оставьте CYL и AXIS пустыми, если у вас нет астигматизма.';

  @override
  String get profileFillSphError =>
      'Пожалуйста, заполните оптическую силу (SPH)';

  @override
  String get profileLeftAxisError =>
      'Для левого глаза CYL укажите AXIS от 0 до 180°';

  @override
  String get profileRightAxisError =>
      'Для правого глаза CYL укажите AXIS от 0 до 180°';

  @override
  String settingsDailyAt(String time) {
    return 'Ежедневно в $time';
  }

  @override
  String get settingsTipTime => 'Время советов';

  @override
  String get settingsNotificationTime => 'Время уведомления';

  @override
  String settingsEveryMonths(int months) {
    return 'каждые $months мес.';
  }

  @override
  String settingsDailyAtLowStock(String time) {
    return 'Ежедневно в $time, если запас ниже порога';
  }

  @override
  String get settingsLowStockReminderHelp =>
      'Ежедневное уведомление будет отправляться в выбранное время, если запас линз ниже порогового значения.';

  @override
  String get settingsLensStock => 'Запас линз';

  @override
  String get settingsAlertThreshold => 'Порог предупреждения';

  @override
  String get settingsData => 'Данные';

  @override
  String get settingsDataManagement => 'Управление данными';

  @override
  String get settingsDeleteAllHistory => 'Удалить всю историю';

  @override
  String get settingsHoursBeforeEndTitle => 'За сколько часов до окончания';

  @override
  String get settingsAtExpiry => 'В момент окончания';

  @override
  String get settingsDaysBeforeReplacement => 'За сколько дней до замены';

  @override
  String get settingsReplacementDayTime => 'Время в день замены';

  @override
  String get settingsHoursBeforeEndHelp =>
      'Напоминать за N часов до конца 14-часового периода ношения:';

  @override
  String get settingsDaysBeforeReplacementHelp =>
      'Напоминать за N дней до даты замены:';

  @override
  String get settingsBatteryNoRestrictionsHint =>
      'Выберите «Без ограничений» для приложения в настройках батареи';

  @override
  String get settingsReplacementNotificationTimeHelp =>
      'Выберите время уведомлений о замене';

  @override
  String get settingsWarnWhenStockDrops =>
      'Предупреждать, когда запас линз упадёт до:';

  @override
  String settingsStockBelowThreshold(int count, String unit) {
    return 'Запас линз ($count $unit) ниже порога!';
  }

  @override
  String get settingsClearHistoryWarning =>
      'Вы уверены? Это действие удалит:\n\n• Всю историю замен линз\n• Все записи симптомов\n• Проверки зрения\n• Историю запаса\n\nАккаунт, тип линз и настройки будут сохранены.\nЭто действие НЕОБРАТИМО!';

  @override
  String get settingsSolutionPurchaseReminder =>
      'Напоминание о покупке раствора';

  @override
  String get settingsWeekday => 'День недели';

  @override
  String get settingsTime => 'Время';

  @override
  String get settingsPeriod => 'Период';

  @override
  String get historyToday => 'сегодня';

  @override
  String get notificationTestAllowForTest =>
      'Пожалуйста, разрешите уведомления для теста';

  @override
  String get notificationTestScheduledBody =>
      'Тест запланирован: уведомления работают.';

  @override
  String notificationTestTitleInSeconds(int seconds) {
    return 'Тест через $seconds сек';
  }

  @override
  String notificationTestInSeconds(int seconds) {
    return 'Уведомление через $seconds сек';
  }

  @override
  String notificationTestInMinutes(int minutes) {
    return 'Уведомление через $minutes мин';
  }

  @override
  String notificationTestScheduledSuccess(String message) {
    return 'Запланировано: $message. Можно закрыть приложение.';
  }

  @override
  String get notificationTestPermissionNotGranted =>
      'Разрешение на уведомления не выдано';

  @override
  String get notificationTestDebugBody => 'zonedSchedule работает.';

  @override
  String notificationTestDebugScheduledSuccess(int seconds) {
    return 'Через $seconds сек (zonedSchedule). Можно закрыть приложение.';
  }

  @override
  String get notificationTestManualTitle => 'Linsor - тестовое уведомление';

  @override
  String get notificationTestManualBody =>
      'Уведомления работают. Напоминания будут приходить вовремя.';

  @override
  String get notificationTestSent => 'Тестовое уведомление отправлено';

  @override
  String notificationTestSendError(String error) {
    return 'Ошибка отправки уведомления: $error';
  }
}
