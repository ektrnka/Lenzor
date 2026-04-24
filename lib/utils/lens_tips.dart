import 'package:flutter/material.dart';

import '../models/lens_data.dart';
import '../services/app_locale_controller.dart';
import '../theme/app_colors.dart';

class LensTipsManager {
  static const Color _defaultColor = AppColors.onSurfaceVariant;

  static const List<Map<String, dynamic>> _generalTips = [
// БАЗОВАЯ ГИГИЕНА РУК И ПОВЕРХНОСТЕЙ
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Всегда мойте руки с мылом перед тем как трогать линзы',
      'en': 'Always wash your hands with soap before touching your lenses'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Мойте руки не менее 20 секунд перед работой с линзами',
      'en': 'Wash your hands for at least 20 seconds before handling lenses'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Тщательно смывайте мыло с рук перед касанием линз',
      'en': 'Rinse soap thoroughly from your hands before touching lenses'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Вытирайте руки чистым полотенцем без ворса перед линзами',
      'en': 'Dry your hands with a clean lint-free towel before handling lenses'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Не используйте кремовое мыло перед работой с линзами, оно оставляет плёнку',
      'en':
          'Do not use creamy soap before handling lenses because it can leave a film'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Не трогайте линзы мокрыми или недосушенными руками',
      'en': 'Do not touch lenses with wet or not fully dried hands'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Короткие ногти снижают риск порвать линзу или поцарапать глаз',
      'en':
          'Short nails reduce the risk of tearing a lens or scratching your eye'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Перед постановкой линзы убедитесь, что под ногтями нет грязи',
      'en':
          'Before inserting a lens, make sure there is no dirt under your nails'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Антисептик для рук не заменяет мытьё с мылом перед линзами',
      'en':
          'Hand sanitizer does not replace washing with soap before handling lenses'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Работайте с линзами над чистой ровной поверхностью, чтобы снизить риск загрязнения',
      'en':
          'Handle lenses over a clean flat surface to reduce the risk of contamination'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Всегда начинайте надевать линзу с одного и того же глаза, чтобы не перепутать пары',
      'en': 'Always start with the same eye so you do not mix up the lenses'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Не прикасайтесь пальцами к внутренней поверхности линзы без необходимости',
      'en': 'Do not touch the inner surface of the lens unnecessarily'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Избегайте прикосновения линз к немытым предметам во время надевания',
      'en': 'Avoid letting lenses touch unclean objects during insertion'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Не облокачивайтесь лицом на грязные поверхности, пока линзы уже надеты',
      'en': 'Do not rest your face on dirty surfaces while wearing lenses'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru':
          'Не пользуйтесь влажными салфетками с ароматизаторами перед работой с линзами',
      'en': 'Do not use scented wet wipes before handling lenses'
    },

// ВОДА И ЛИНЗЫ
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Никогда не промывайте линзы водопроводной водой',
      'en': 'Never rinse lenses with tap water'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Не храните линзы в воде, даже кипячёной или дистиллированной',
      'en': 'Do not store lenses in water, even if it is boiled or distilled'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Не смачивайте линзы слюной — во рту слишком много бактерий',
      'en':
          'Do not wet lenses with saliva because the mouth contains too many bacteria'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Снимайте линзы перед душем, чтобы снизить риск заражения водой',
      'en':
          'Remove lenses before showering to reduce the risk of waterborne infection'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Снимайте линзы перед купанием в бассейне, море или озере',
      'en': 'Remove lenses before swimming in a pool, the sea, or a lake'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Не пользуйтесь джакузи и горячей ванной в линзах — вода повышает риск инфекции',
      'en':
          'Do not use a hot tub or hot bath while wearing lenses because water increases infection risk'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Если линза контактировала с водой, по возможности замените её на новую',
      'en':
          'If a lens has come into contact with water, replace it with a new one if possible'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Акантамёба из воды может вызывать тяжёлые инфекционные кератиты, избегайте воды с линзами',
      'en':
          'Acanthamoeba from water can cause severe infectious keratitis, so avoid water exposure with lenses'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Не ополаскивайте контейнер для линз водопроводной водой, используйте только раствор',
      'en': 'Do not rinse your lens case with tap water, use only solution'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Не разбавляйте раствор водой, это снижает его дезинфицирующие свойства',
      'en':
          'Do not dilute solution with water because it reduces its disinfecting power'
    },
    {
      'icon': Icons.pool_outlined,
      'color': _defaultColor,
      'ru':
          'Не носите линзы в бассейне без плотных очков для плавания',
      'en': 'Do not wear lenses in a pool without tight-fitting swim goggles'
    },
    {
      'icon': Icons.shower,
      'color': _defaultColor,
      'ru':
          'Снимайте линзы перед душем и любыми водными процедурами',
      'en': 'Remove lenses before showering and any water activities'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Даже дистиллированная вода не безопасна для хранения линз',
      'en': 'Even distilled water is not safe for storing lenses'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'После случайного контакта линзы с водой обсудите замену с врачом при дискомфорте',
      'en':
          'After accidental water exposure, discuss lens replacement with your doctor if you feel discomfort'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Не используйте самодельные солевые растворы для ухода за линзами',
      'en': 'Do not use homemade saline solutions for lens care'
    },

// РАСТВОРЫ И ДЕЗИНФЕКЦИЯ
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Используйте только тот раствор, который рекомендовал ваш офтальмолог',
      'en': 'Use only the solution recommended by your eye doctor'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Не смешивайте свежий раствор со старым в контейнере, всегда выливайте старый',
      'en':
          'Do not mix fresh solution with old solution in the case, always discard the old one'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Каждый раз заполняйте контейнер только свежим дезинфицирующим раствором',
      'en': 'Fill the case with fresh disinfecting solution every time'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Проверяйте срок годности раствора перед каждым использованием',
      'en': 'Check the expiration date of the solution before each use'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Не используйте раствор после истечения срока годности',
      'en': 'Do not use solution after its expiration date'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Открытую бутылку раствора обычно нужно использовать в течение 90 дней',
      'en':
          'An opened bottle of solution usually needs to be used within 90 days'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Физраствор подходит только для ополаскивания, но не для дезинфекции линз',
      'en': 'Saline is suitable only for rinsing, not for disinfecting lenses'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Многофункциональный раствор очищает, дезинфицирует и хранит линзы',
      'en': 'Multipurpose solution cleans, disinfects, and stores lenses'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Перекисные системы глубокой очистки эффективно удаляют микробы и отложения',
      'en': 'Hydrogen peroxide systems effectively remove microbes and deposits'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'При использовании перекисной системы всегда дождитесь полной нейтрализации раствора',
      'en':
          'When using a peroxide system, always wait for full neutralization of the solution'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Никогда не надевайте линзы до окончания нейтрализации перекисного раствора',
      'en':
          'Never insert lenses before the peroxide solution has fully neutralized'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Используйте только специальный контейнер из комплекта перекисной системы',
      'en': 'Use only the special case that comes with the peroxide system'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Не переливайте раствор в другие ёмкости, это нарушает стерильность',
      'en':
          'Do not transfer solution into other containers because this breaks sterility'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Всегда протирайте линзы пальцами в ладони с раствором даже при no-rub растворах',
      'en':
          'Always rub lenses with your fingers in your palm with solution even if the product says no-rub'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Протирайте каждую сторону линзы не менее 10–20 секунд для лучшей очистки',
      'en':
          'Rub each side of the lens for at least 10–20 seconds for better cleaning'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'После протирки ополосните линзу струёй раствора несколько секунд',
      'en':
          'After rubbing, rinse the lens with a stream of solution for a few seconds'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Замачивайте линзы в растворе минимум 4–6 часов, чтобы завершить дезинфекцию',
      'en':
          'Soak lenses in solution for at least 4–6 hours to complete disinfection'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Не используйте глазные капли, которые не одобрены для ношения с контактными линзами',
      'en':
          'Do not use eye drops that are not approved for use with contact lenses'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Увлажняющие капли для линз выбирайте без консервантов при частом применении',
      'en':
          'Choose preservative-free lubricating drops for frequent use with lenses'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Не используйте сосудосуживающие капли от покраснения вместе с линзами без назначения врача',
      'en':
          'Do not use redness-relief vasoconstrictor drops with lenses unless prescribed by a doctor'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Средства для жёстких линз нельзя использовать с мягкими линзами и наоборот',
      'en':
          'Products for rigid lenses must not be used with soft lenses and vice versa'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Храните раствор при комнатной температуре и защищайте от прямого солнца',
      'en':
          'Store solution at room temperature and protect it from direct sunlight'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Не используйте раствор с повреждённой пломбой на крышке',
      'en': 'Do not use solution if the seal on the cap is damaged'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Внимательно читайте инструкцию к вашему раствору — режимы могут отличаться',
      'en':
          'Read the instructions for your solution carefully because directions may differ'
    },

// КОНТЕЙНЕР ДЛЯ ЛИНЗ
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Заменяйте контейнер для линз не реже одного раза в 3 месяца',
      'en': 'Replace your lens case at least once every 3 months'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'После каждого использования полностью выливайте раствор из контейнера',
      'en': 'Empty the case completely after each use'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Промывайте контейнер свежим раствором, а не водой из-под крана',
      'en': 'Rinse the case with fresh solution, not tap water'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Оставляйте контейнер для линз сушиться крышками вверх на чистой поверхности',
      'en':
          'Leave the lens case to air dry with the caps facing up on a clean surface'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Не держите контейнер закрытым и влажным длительное время без линз внутри',
      'en':
          'Do not keep the case closed and damp for a long time when there are no lenses inside'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Грязный или потемневший контейнер — повод немедленно заменить его',
      'en': 'A dirty or discolored case is a reason to replace it immediately'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Не используйте треснувший или деформированный контейнер для линз',
      'en': 'Do not use a cracked or deformed lens case'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Подписывайте стороны контейнера для правого и левого глаза, чтобы не перепутать линзы',
      'en':
          'Label the right and left sides of the case so you do not mix up the lenses'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Не давайте свой контейнер для линз другим людям',
      'en': 'Do not let other people use your lens case'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Не храните контейнер возле раковины, где на него попадает грязная вода',
      'en':
          'Do not store the case near a sink where dirty water can splash onto it'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Регулярно очищайте резьбу крышек контейнера от отложений раствора',
      'en':
          'Clean the threads of the case caps regularly to remove solution buildup'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Не стерилизуйте контейнер кипятком, пластик может деформироваться',
      'en':
          'Do not sterilize the case with boiling water because the plastic may deform'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Контейнер из комплекта перекисной системы используйте только для перекиси',
      'en': 'Use the case from a peroxide system only for peroxide solution'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Каждая новая бутылка раствора обычно идёт с новым контейнером — пользуйтесь этим',
      'en':
          'Each new bottle of solution usually comes with a new case, so use it'
    },
    {
      'icon': Icons.inventory_2,
      'color': _defaultColor,
      'ru':
          'Храните контейнер в сухом и чистом месте, вдали от пыли и косметики',
      'en': 'Store the case in a dry clean place away from dust and cosmetics'
    },

// РЕЖИМ НОШЕНИЯ И ЗАМЕНА
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Не носите линзы дольше 8–12 часов в день, если врач не рекомендовал иначе',
      'en':
          'Do not wear lenses longer than 8–12 hours a day unless your doctor advised otherwise'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Давайте глазам отдых каждый день, хотя бы несколько часов носите очки',
      'en':
          'Give your eyes a break every day and wear glasses for at least a few hours'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Не спите в линзах, если вам не назначены специальные ночные линзы',
      'en':
          'Do not sleep in lenses unless you were prescribed special overnight lenses'
    },
    {
      'icon': Icons.bedtime_outlined,
      'color': _defaultColor,
      'ru':
          'Сон в обычных линзах увеличивает риск инфекции роговицы в несколько раз',
      'en':
          'Sleeping in regular lenses increases the risk of corneal infection several times over'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Всегда соблюдайте рекомендованный срок замены линз, указанный на упаковке',
      'en':
          'Always follow the recommended lens replacement schedule shown on the package'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Срок замены считается с даты вскрытия блистера, а не от количества дней ношения',
      'en':
          'The replacement period starts from the date you open the blister, not from the number of days worn'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Даже если линза выглядит чистой, меняйте её строго по графику замены',
      'en':
          'Even if a lens looks clean, replace it strictly according to schedule'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Не продлевайте срок ношения линз «ещё на пару дней» ради экономии',
      'en': 'Do not extend lens wear for just a couple more days to save money'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Не используйте линзы из повреждённого или вскрытого заранее блистера',
      'en': 'Do not use lenses from a damaged or previously opened blister pack'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Проверяйте дату производства и срок годности линз на упаковке перед применением',
      'en':
          'Check the manufacturing date and expiration date of lenses on the package before use'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Используйте напоминания в телефоне, чтобы не забывать о замене линз',
      'en':
          'Use reminders on your phone so you do not forget to replace your lenses'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Храните запас линз, чтобы не приходилось носить просроченные изделия',
      'en': 'Keep spare lenses so you do not have to wear expired ones'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Никогда не используйте высохшую линзу повторно, даже после размягчения раствором',
      'en': 'Never reuse a dried-out lens, even after softening it in solution'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Не делите одну пару линз на двоих, даже если параметры совпадают',
      'en':
          'Do not share one pair of lenses between two people even if the parameters match'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'При потере одной линзы не носите вторую в одиночку длительное время, это нарушает баланс зрения',
      'en':
          'If you lose one lens, do not wear the other alone for a long time because it can disrupt visual balance'
    },
// ЗДОРОВЬЕ ГЛАЗ И ВРАЧ
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'Посещайте офтальмолога не реже одного раза в год',
      'en': 'Visit your eye doctor at least once a year'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Немедленно снимите линзы при боли, покраснении или резком ухудшении зрения',
      'en':
          'Remove lenses immediately if you feel pain, redness, or sudden vision loss'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'При появлении гнойных выделений из глаз срочно обратитесь к врачу и не надевайте линзы',
      'en':
          'If you have discharge from your eyes, see a doctor urgently and do not put lenses in'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Светобоязнь и ощущение песка в глазах в линзах требуют консультации офтальмолога',
      'en':
          'Light sensitivity and a gritty feeling while wearing lenses require an eye doctor consultation'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Не надевайте линзы снова, если была сильная боль, пока врач не разрешит',
      'en':
          'Do not put lenses back in after severe pain until your doctor gives permission'
    },
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'Сообщайте врачу о любой сухости, жжении или зуде в линзах',
      'en':
          'Tell your doctor about any dryness, burning, or itching you experience in lenses'
    },
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'Регулярно проверяйте остроту зрения, параметры могут меняться со временем',
      'en':
          'Have your vision checked regularly because your prescription can change over time'
    },
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'Сообщайте офтальмологу обо всех лекарствах, которые вы принимаете',
      'en': 'Tell your eye doctor about all medications you are taking'
    },
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'Не подбирайте линзы самостоятельно без очного осмотра у специалиста',
      'en':
          'Do not select lenses on your own without an in-person exam by a specialist'
    },
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'После инфекций глаз замените все используемые линзы и контейнер',
      'en':
          'After an eye infection replace all lenses you were using and the case'
    },
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'Не носите линзы при конъюнктивите до полного разрешения воспаления',
      'en':
          'Do not wear lenses during conjunctivitis until the inflammation has fully resolved'
    },
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'При сахарном диабете обязательно обсуждайте ношение линз с врачом',
      'en': 'If you have diabetes, always discuss lens wear with your doctor'
    },
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'Беременность может влиять на комфорт в линзах, сообщите об этом офтальмологу',
      'en': 'Pregnancy can affect lens comfort, so let your eye doctor know'
    },
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'При синдроме сухого глаза подбирайте режим линз только с врачом',
      'en':
          'If you have dry eye syndrome, choose a lens wearing schedule only with your doctor'
    },
    {
      'icon': Icons.remove_red_eye,
      'color': _defaultColor,
      'ru':
          'Не используйте линзы во время тяжёлых системных заболеваний без консультации специалиста',
      'en':
          'Do not wear lenses during serious systemic illness without consulting a specialist'
    },

// МАКИЯЖ И КОСМЕТИКА
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Надевайте линзы до нанесения макияжа на глаза',
      'en': 'Insert lenses before applying eye makeup'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Снимайте линзы перед тем как смывать макияж с век и ресниц',
      'en': 'Remove lenses before washing makeup off your eyelids and lashes'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Не наносите подводку по внутренней кромке века при ношении линз',
      'en':
          'Do not apply eyeliner to the inner rim of your eyelid while wearing lenses'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Выбирайте гипоаллергенную косметику для глаз, если носите линзы',
      'en': 'Choose hypoallergenic eye cosmetics if you wear contact lenses'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Заменяйте тушь для ресниц каждые три месяца, чтобы снизить риск инфекции',
      'en': 'Replace mascara every three months to reduce the risk of infection'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Не пользуйтесь тушью с удлиняющими волокнами, они легче попадают под линзу',
      'en':
          'Avoid fiber-lengthening mascaras because the fibers can get under your lens more easily'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Не делитесь косметикой для глаз с другими людьми, если носите линзы',
      'en': 'Do not share eye cosmetics with others while wearing lenses'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Старайтесь использовать прессованные тени, а не сильно рассыпчатые',
      'en': 'Prefer pressed eyeshadows over very loose powders'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Если частица косметики попала под линзу, снимите её и промойте раствором',
      'en':
          'If a cosmetic particle gets under a lens, remove it and rinse with solution'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Используйте безмасляные средства для снятия макияжа при ношении линз',
      'en': 'Use oil-free makeup removers when you wear contact lenses'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Наносите лаки для волос и спреи с закрытыми глазами, если линзы уже надеты',
      'en':
          'Apply hair sprays and aerosols with your eyes closed if lenses are already in'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Не наносите кремы и масла слишком близко к ресницам при ношении линз',
      'en':
          'Do not apply creams or oils too close to your lashes while wearing lenses'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'При раздражении век от косметики временно откажитесь от линз и макияжа',
      'en':
          'If cosmetics irritate your eyelids, temporarily stop wearing lenses and makeup'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Проверяйте срок годности косметики для глаз так же тщательно, как и срок годности раствора',
      'en':
          'Check the expiry date of eye cosmetics just as carefully as the expiry date of your solution'
    },
    {
      'icon': Icons.brush,
      'color': _defaultColor,
      'ru':
          'Используйте зеркало с хорошим освещением, чтобы аккуратно наносить макияж в линзах',
      'en':
          'Use a well-lit mirror to apply makeup carefully while wearing lenses'
    },

// ЭКРАНЫ, КОМПЬЮТЕР, СУХОСТЬ
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Применяйте правило 20-20-20 при работе за экраном: каждые 20 минут смотрите вдаль на 20 секунд',
      'en':
          'Use the 20-20-20 rule at screens: every 20 minutes look at something 20 feet away for 20 seconds'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'При работе за компьютером в линзах старайтесь моргать чаще, чтобы уменьшить сухость',
      'en':
          'Blink more often when working at a computer in lenses to reduce dryness'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Расположите монитор чуть ниже уровня глаз, чтобы уменьшить испарение слёз',
      'en':
          'Position your monitor slightly below eye level to reduce tear evaporation'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Делайте перерыв от экрана хотя бы на 5 минут каждый час',
      'en': 'Take a break from your screen for at least 5 minutes every hour'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Пользуйтесь увлажняющими каплями, совместимыми с линзами, при длительной работе за компьютером',
      'en':
          'Use lens-compatible lubricating drops during long hours at a computer'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Снижайте яркость экрана до комфортного уровня, чтобы уменьшить утомление глаз',
      'en':
          'Lower screen brightness to a comfortable level to reduce eye strain'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Используйте ночной режим экрана вечером, чтобы снизить зрительную нагрузку',
      'en': 'Use night mode in the evening to reduce visual strain'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Держите смартфон на расстоянии 30–40 см от глаз при чтении в линзах',
      'en':
          'Hold your smartphone 30–40 cm from your eyes when reading while wearing lenses'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Если к вечеру зрение в линзах «плывёт», возможно, глаза пересохли и нужна пауза',
      'en':
          'If your vision blurs by evening in lenses, your eyes may be too dry and you need a break'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'При сильной утомляемости глаз вечером снимайте линзы и переходите на очки',
      'en':
          'If your eyes feel very tired in the evening, remove lenses and switch to glasses'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Антибликовые очки поверх линз могут повысить комфорт при работе за экраном',
      'en':
          'Anti-glare glasses worn over lenses can improve comfort at a screen'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Расположите источник света так, чтобы избежать бликов на экране',
      'en': 'Position your light source to avoid glare on the screen'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Не читайте с экрана в полной темноте при ношении линз',
      'en':
          'Do not read from a screen in complete darkness while wearing lenses'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'Делайте короткие упражнения для глаз, чтобы сменить фокус с близи на даль',
      'en': 'Do short eye exercises to shift your focus from near to far'
    },
    {
      'icon': Icons.computer,
      'color': _defaultColor,
      'ru':
          'При длительном чтении с экрана закрывайте глаза на несколько секунд каждые 10–15 минут',
      'en':
          'During long reading sessions close your eyes for a few seconds every 10–15 minutes'
    },

// ВОЗДУХ, КОНДИЦИОНЕР, УВЛАЖНЕНИЕ
    {
      'icon': Icons.thermostat,
      'color': _defaultColor,
      'ru':
          'Кондиционер сушит глаза — используйте увлажнитель воздуха в комнате',
      'en': 'Air conditioning dries your eyes, so use a humidifier in the room'
    },
    {
      'icon': Icons.thermostat,
      'color': _defaultColor,
      'ru':
          'Направляйте поток от кондиционера в сторону от лица, если носите линзы',
      'en':
          'Direct the airflow from the air conditioner away from your face when wearing lenses'
    },
    {
      'icon': Icons.thermostat,
      'color': _defaultColor,
      'ru':
          'Сухой воздух в помещении усиливает испарение слёз и сухость линз',
      'en': 'Dry indoor air increases tear evaporation and lens dryness'
    },
    {
      'icon': Icons.thermostat,
      'color': _defaultColor,
      'ru':
          'Увлажнитель воздуха дома и на работе помогает уменьшить дискомфорт в линзах',
      'en': 'A humidifier at home and at work helps reduce lens discomfort'
    },
    {
      'icon': Icons.thermostat,
      'color': _defaultColor,
      'ru':
          'Проветривайте помещение, но избегайте прямых сквозняков в лицо',
      'en': 'Ventilate the room but avoid direct drafts blowing at your face'
    },
    {
      'icon': Icons.thermostat,
      'color': _defaultColor,
      'ru':
          'Регулярная влажная уборка снижает количество пыли и аллергенов, раздражающих глаза',
      'en':
          'Regular wet cleaning reduces the amount of dust and allergens that irritate eyes'
    },
    {
      'icon': Icons.thermostat,
      'color': _defaultColor,
      'ru':
          'Комнатные растения могут немного повышать влажность воздуха и улучшать комфорт',
      'en':
          'Indoor plants can slightly increase air humidity and improve comfort'
    },
    {
      'icon': Icons.water_drop_outlined,
      'color': _defaultColor,
      'ru':
          'Используйте безконсервантные увлажняющие капли при частой сухости глаз',
      'en':
          'Use preservative-free lubricating drops when you experience frequent eye dryness'
    },
    {
      'icon': Icons.water_drop_outlined,
      'color': _defaultColor,
      'ru':
          'Не закапывайте слишком много капель сразу, чтобы не вымыть линзу из глаза',
      'en':
          'Do not instill too many drops at once so you do not flush the lens out of your eye'
    },
    {
      'icon': Icons.water_drop_outlined,
      'color': _defaultColor,
      'ru':
          'Подберите увлажняющие капли, одобренные именно для ваших линз',
      'en':
          'Choose lubricating drops that are approved specifically for your type of lenses'
    },
    {
      'icon': Icons.water_drop_outlined,
      'color': _defaultColor,
      'ru':
          'При сильной сухости глаз с линзами обсудите с врачом возможную смену материала линз',
      'en':
          'If you have severe dry eyes with lenses, discuss switching to a different lens material with your doctor'
    },
    {
      'icon': Icons.water_drop_outlined,
      'color': _defaultColor,
      'ru':
          'Не используйте капли от покраснения для регулярного увлажнения глаз',
      'en': 'Do not use redness-relief drops for regular eye lubrication'
    },
    {
      'icon': Icons.water_drop_outlined,
      'color': _defaultColor,
      'ru':
          'Одноразовые монодозы капель удобны при редком использовании в течение дня',
      'en':
          'Single-dose vials are convenient when you only need drops occasionally during the day'
    },
    {
      'icon': Icons.thermostat,
      'color': _defaultColor,
      'ru':
          'Зимой отопление дополнительно сушит воздух, используйте капли чаще',
      'en':
          'Indoor heating in winter dries the air further, so use drops more often'
    },
    {
      'icon': Icons.thermostat,
      'color': _defaultColor,
      'ru':
          'На улице в мороз линзы не замерзают, но воздух суше — следите за комфортом',
      'en':
          'Lenses do not freeze in the cold outdoors, but the air is drier so monitor your comfort'
    },

// ПИТАНИЕ И ОБРАЗ ЖИЗНИ
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Омега‑3 жирные кислоты в рационе помогают уменьшить сухость глаз',
      'en': 'Omega-3 fatty acids in your diet help reduce eye dryness'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Пейте достаточно воды, обезвоживание усиливает сухость глаз в линзах',
      'en':
          'Drink enough water because dehydration increases eye dryness when wearing lenses'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Морская рыба, орехи и льняное семя поддерживают здоровье слёзной плёнки',
      'en': 'Seafish, nuts, and flaxseed support a healthy tear film'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Витамин A важен для здоровья роговицы, включайте в рацион морковь и зелень',
      'en':
          'Vitamin A is important for corneal health, so include carrots and greens in your diet'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Избыточное потребление кофеина может усилить сухость глаз при ношении линз',
      'en':
          'Excessive caffeine intake can increase eye dryness when wearing lenses'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Чрезмерное употребление соли может способствовать отёкам и дискомфорту глаз',
      'en':
          'Excessive salt intake can contribute to eye swelling and discomfort'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Сбалансированное питание помогает поддерживать общее здоровье глаз',
      'en': 'A balanced diet helps maintain overall eye health'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Алкоголь обезвоживает организм и может усиливать сухость глаз',
      'en': 'Alcohol dehydrates the body and can increase eye dryness'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Регулярный сон помогает глазам восстанавливаться после ношения линз',
      'en': 'Regular sleep helps your eyes recover after wearing lenses'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Хронический недосып снижает переносимость контактных линз',
      'en': 'Chronic sleep deprivation reduces tolerance to contact lenses'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Стресс может усиливать ощущение сухости и дискомфорта в глазах',
      'en':
          'Stress can increase the feeling of dryness and discomfort in your eyes'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Зелёный чай и продукты с антиоксидантами полезны для здоровья глаз',
      'en': 'Green tea and antioxidant-rich foods are beneficial for eye health'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Курение ухудшает состояние слёзной плёнки и повышает риск осложнений с линзами',
      'en':
          'Smoking worsens the tear film and increases the risk of complications with lenses'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'При жёстких диетах контролируйте поступление витаминов, важных для глаз',
      'en':
          'On restrictive diets make sure you are getting enough vitamins that are important for eye health'
    },
    {
      'icon': Icons.local_dining,
      'color': _defaultColor,
      'ru':
          'Регулярные прогулки на свежем воздухе полезны для общего состояния зрения',
      'en': 'Regular outdoor walks are beneficial for overall vision health'
    },

// СПОРТ, ПУТЕШЕСТВИЯ, ОБРАЗ ЖИЗНИ
    {
      'icon': Icons.directions_run,
      'color': _defaultColor,
      'ru':
          'Одноразовые линзы идеальны для спорта и активного образа жизни',
      'en':
          'Daily disposable lenses are ideal for sports and an active lifestyle'
    },
    {
      'icon': Icons.directions_run,
      'color': _defaultColor,
      'ru':
          'При контактных видах спорта линзы безопаснее очков, но нужны защитные очки',
      'en':
          'In contact sports lenses are safer than glasses, but protective eyewear is still needed'
    },
    {
      'icon': Icons.directions_run,
      'color': _defaultColor,
      'ru':
          'Не трите глаза руками во время тренировки, чтобы не сместить линзу',
      'en':
          'Do not rub your eyes with your hands during exercise so you do not dislodge a lens'
    },
    {
      'icon': Icons.directions_run,
      'color': _defaultColor,
      'ru':
          'После тренировки снимайте линзы чистыми руками и при необходимости используйте капли',
      'en':
          'After training remove lenses with clean hands and use drops if needed'
    },
    {
      'icon': Icons.directions_run,
      'color': _defaultColor,
      'ru':
          'При езде на велосипеде носите очки поверх линз для защиты от ветра и пыли',
      'en':
          'When cycling wear glasses over your lenses to protect against wind and dust'
    },
    {
      'icon': Icons.directions_run,
      'color': _defaultColor,
      'ru':
          'При плавании в линзах обязательно надевайте плотные очки для плавания',
      'en': 'If you swim in lenses, always wear tight-fitting swim goggles'
    },
    {
      'icon': Icons.directions_run,
      'color': _defaultColor,
      'ru':
          'После водных видов спорта по возможности замените линзы на новые',
      'en': 'After water sports replace your lenses with new ones if possible'
    },
    {
      'icon': Icons.directions_run,
      'color': _defaultColor,
      'ru':
          'Запасная пара линз в спортивной сумке полезна при потере или загрязнении',
      'en':
          'A spare pair of lenses in your sports bag is useful in case of loss or contamination'
    },
    {
      'icon': Icons.flight,
      'color': _defaultColor,
      'ru':
          'Воздух в самолёте сухой — используйте увлажняющие капли в полёте',
      'en':
          'Aircraft cabin air is dry, so use lubricating drops during the flight'
    },
    {
      'icon': Icons.flight,
      'color': _defaultColor,
      'ru':
          'На длительных перелётах лучше снять линзы и надеть очки',
      'en':
          'On long flights it is better to remove lenses and wear glasses instead'
    },
    {
      'icon': Icons.flight,
      'color': _defaultColor,
      'ru':
          'Берите в путешествие запасные линзы, раствор и контейнер',
      'en': 'Pack spare lenses, solution, and a case when you travel'
    },
    {
      'icon': Icons.flight,
      'color': _defaultColor,
      'ru':
          'Не переливайте раствор в непредназначенные флаконы в поездке, чтобы сохранить стерильность',
      'en':
          'Do not transfer solution into unsuitable containers while traveling to preserve sterility'
    },
    {
      'icon': Icons.flight,
      'color': _defaultColor,
      'ru':
          'Храните линзы и раствор в ручной клади, а не в багаже при перелётах',
      'en':
          'Keep lenses and solution in your carry-on luggage rather than checked baggage'
    },
    {
      'icon': Icons.flight,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы особенно удобны в поездках, потому что не требуют ухода',
      'en':
          'Daily disposable lenses are especially convenient for travel because they require no maintenance'
    },
    {
      'icon': Icons.flight,
      'color': _defaultColor,
      'ru':
          'Имейте при себе копию рецепта на линзы во время длительных путешествий',
      'en': 'Carry a copy of your lens prescription during long trips'
    },

// ДЕТИ, ПОДРОСТКИ, АЛЛЕРГИЯ
    {
      'icon': Icons.child_care,
      'color': _defaultColor,
      'ru':
          'Одноразовые линзы — лучший выбор для детей по гигиене и простоте',
      'en':
          'Daily disposable lenses are the best choice for children in terms of hygiene and simplicity'
    },
    {
      'icon': Icons.child_care,
      'color': _defaultColor,
      'ru':
          'Дети должны носить линзы только при готовности соблюдать правила гигиены',
      'en':
          'Children should wear lenses only when they are ready to follow hygiene rules'
    },
    {
      'icon': Icons.child_care,
      'color': _defaultColor,
      'ru':
          'Родители должны контролировать, как ребёнок надевает и снимает линзы',
      'en':
          'Parents should supervise how their child inserts and removes lenses'
    },
    {
      'icon': Icons.child_care,
      'color': _defaultColor,
      'ru':
          'Не позволяйте ребёнку делиться линзами с друзьями даже для примерки цвета',
      'en':
          'Do not let your child share lenses with friends even to try on a color'
    },
    {
      'icon': Icons.child_care,
      'color': _defaultColor,
      'ru':
          'При жалобе ребёнка на боль в глазу немедленно снимите линзы и обратитесь к врачу',
      'en':
          'If your child complains of eye pain, remove the lenses immediately and see a doctor'
    },
    {
      'icon': Icons.child_care,
      'color': _defaultColor,
      'ru':
          'Запасные очки должны быть у ребёнка всегда на случай проблем с линзами',
      'en':
          'Your child should always have spare glasses in case of problems with lenses'
    },
    {
      'icon': Icons.child_care,
      'color': _defaultColor,
      'ru':
          'Декоративные линзы без рецепта врача опасны для детей и подростков',
      'en':
          'Decorative lenses without a prescription are dangerous for children and teenagers'
    },
    {
      'icon': Icons.child_care,
      'color': _defaultColor,
      'ru':
          'На уроках физкультуры линзы часто удобнее очков при правильном уходе',
      'en':
          'Lenses are often more comfortable than glasses during PE lessons when properly cared for'
    },
    {
      'icon': Icons.filter_vintage,
      'color': _defaultColor,
      'ru':
          'В сезон аллергии рассмотрите переход на однодневные линзы',
      'en':
          'During allergy season consider switching to daily disposable lenses'
    },
    {
      'icon': Icons.filter_vintage,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы меньше накапливают пыльцу и аллергены',
      'en': 'Daily disposable lenses accumulate less pollen and allergens'
    },
    {
      'icon': Icons.filter_vintage,
      'color': _defaultColor,
      'ru':
          'При сильной аллергии временно переходите с линз на очки',
      'en':
          'During severe allergy episodes temporarily switch from lenses to glasses'
    },
    {
      'icon': Icons.filter_vintage,
      'color': _defaultColor,
      'ru':
          'Не трите глаза при аллергии, чтобы не смещать линзу и не раздражать роговицу',
      'en':
          'Do not rub your eyes during allergy attacks so you do not displace the lens or irritate the cornea'
    },
    {
      'icon': Icons.filter_vintage,
      'color': _defaultColor,
      'ru':
          'После прогулки в сезон пыльцы умывайтесь и смените одежду, чтобы снизить контакт аллергенов с глазами',
      'en':
          'After outdoor walks during pollen season wash your face and change clothes to reduce allergen contact with your eyes'
    },
    {
      'icon': Icons.filter_vintage,
      'color': _defaultColor,
      'ru':
          'Солнцезащитные очки поверх линз частично защищают от попадания пыльцы в глаза',
      'en':
          'Sunglasses worn over lenses provide partial protection from pollen entering your eyes'
    },
    {
      'icon': Icons.filter_vintage,
      'color': _defaultColor,
      'ru':
          'При аллергическом конъюнктивите прекратите ношение линз до полного устранения симптомов',
      'en':
          'Stop wearing lenses during allergic conjunctivitis until all symptoms have fully resolved'
    },

// ПРОЧЕЕ: БЕЗОПАСНОСТЬ И ОПЫТНЫЕ СИТУАЦИИ
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Не покупайте линзы и растворы в сомнительных местах или без маркировки',
      'en':
          'Do not buy lenses or solutions from questionable sources or without proper labeling'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Покупайте линзы только по действительному рецепту офтальмолога',
      'en': 'Buy lenses only with a valid prescription from an eye doctor'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Декоративные цветные линзы также являются медицинским изделием и требуют рецепта',
      'en':
          'Decorative colored lenses are also a medical device and require a prescription'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Не используйте линзы с истёкшим сроком годности, даже если блистер не вскрыт',
      'en':
          'Do not use lenses past their expiration date even if the blister is still sealed'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Не носите линзы при высокой температуре тела или тяжёлой инфекции',
      'en': 'Do not wear lenses when you have a fever or a serious infection'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Если линза потерялась в глазу, спокойно моргайте и при необходимости обратитесь к врачу',
      'en':
          'If a lens gets lost in your eye, blink calmly and see a doctor if needed'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'При сильной боли или внезапном ухудшении зрения не ждите, обращайтесь за неотложной помощью',
      'en':
          'If you have severe pain or sudden vision loss do not wait, seek emergency care immediately'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'При работе с химикатами и пылью надевайте защитные очки поверх линз',
      'en':
          'When working with chemicals or dust wear protective goggles over your lenses'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Не носите линзы во время сварочных работ, это опасно для роговицы',
      'en':
          'Do not wear lenses during welding work because it is dangerous for the cornea'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Перед операцией или наркозом обязательно снимите линзы и сообщите врачу',
      'en':
          'Always remove lenses before surgery or anesthesia and inform your doctor'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Храните линзы и растворы в недоступном для маленьких детей месте',
      'en': 'Store lenses and solutions out of the reach of small children'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Использованные линзы выбрасывайте в мусор, а не в раковину или унитаз',
      'en': 'Dispose of used lenses in the trash, not down the sink or toilet'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'Запасная пара очков и линз должна быть под рукой на случай непредвиденных ситуаций',
      'en':
          'A spare pair of glasses and lenses should be within reach for unexpected situations'
    },
    {
      'icon': Icons.warning,
      'color': _defaultColor,
      'ru':
          'При любых сомнениях по уходу за линзами уточняйте рекомендации у своего врача',
      'en':
          'If you have any doubts about lens care always check with your eye doctor'
    },
    {
      'icon': Icons.clean_hands,
      'color': _defaultColor,
      'ru': 'Всегда мойте руки перед линзами',
      'en': 'Always wash your hands before handling lenses'
    },
    {
      'icon': Icons.opacity,
      'color': _defaultColor,
      'ru':
          'Никогда не промывайте линзы водой из-под крана',
      'en': 'Never rinse lenses with tap water'
    },
    {
      'icon': Icons.science,
      'color': _defaultColor,
      'ru':
          'Используйте только свежий раствор в контейнере',
      'en': 'Use only fresh solution in your case'
    },
    {
      'icon': Icons.schedule,
      'color': _defaultColor,
      'ru':
          'Соблюдайте срок замены линз строго по графику',
      'en': 'Follow your replacement schedule strictly'
    },
    {
      'icon': Icons.bedtime_outlined,
      'color': _defaultColor,
      'ru':
          'Не спите в линзах, если они не для ночного ношения',
      'en': 'Do not sleep in lenses unless they are approved for overnight wear'
    },
    {
      'icon': Icons.inventory_2_outlined,
      'color': _defaultColor,
      'ru':
          'Меняйте контейнер для линз не реже чем раз в 3 месяца',
      'en': 'Replace your lens case at least every 3 months'
    },
    {
      'icon': Icons.medical_services_outlined,
      'color': _defaultColor,
      'ru':
          'При боли и покраснении сразу снимите линзы',
      'en': 'Remove lenses immediately if you feel pain or redness'
    },
    {
      'icon': Icons.water_drop_outlined,
      'color': _defaultColor,
      'ru':
          'Используйте увлажняющие капли при сухости глаз',
      'en': 'Use lubricating drops when your eyes feel dry'
    },
    {
      'icon': Icons.calendar_today_outlined,
      'color': _defaultColor,
      'ru': 'Регулярно посещайте офтальмолога',
      'en': 'Visit your eye doctor regularly'
    },
    {
      'icon': Icons.travel_explore,
      'color': _defaultColor,
      'ru':
          'Берите в поездку запасную пару линз и раствор',
      'en': 'Carry spare lenses and solution when traveling'
    }
  ];

  static const List<Map<String, dynamic>> _dailyTips = [
    // ОДНОДНЕВНЫЕ ЛИНЗЫ
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Ежедневные линзы имеют самый низкий риск инфекций среди мягких линз',
      'en':
          'Daily disposable lenses have the lowest infection risk among soft lenses'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы не нужно очищать, их просто выбрасывают после снятия',
      'en':
          'Daily lenses do not need to be cleaned, just discard them after removal'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Каждый день вы надеваете новую стерильную пару однодневных линз',
      'en':
          'Each day you put in a fresh sterile pair of daily disposable lenses'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы не требуют контейнера и раствора для хранения',
      'en': 'Daily lenses do not require a case or storage solution'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы — идеальный выбор для аллергиков и при частых поездках',
      'en':
          'Daily disposable lenses are an ideal choice for allergy sufferers and frequent travelers'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Не пытайтесь продлить однодневную линзу на второй день использования',
      'en': 'Do not try to extend a daily lens to a second day of use'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Не промывайте однодневную линзу для повторного ношения, она рассчитана на один день',
      'en':
          'Do not rinse a daily lens for reuse because it is designed for one day only'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы уменьшают риск отложений и бактериального загрязнения',
      'en':
          'Daily lenses reduce the risk of deposits and bacterial contamination'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы особенно подходят детям и подросткам из-за простоты ухода',
      'en':
          'Daily lenses are especially suitable for children and teenagers because of their simple care routine'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При нерегулярном ношении однодневные линзы экономят на растворах и контейнерах',
      'en':
          'For irregular wearers daily lenses save money on solutions and cases'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы удобнее всего при редких поездках и командировках',
      'en':
          'Daily lenses are most convenient for occasional trips and business travel'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Для спорта однодневные линзы удобны тем, что их легко заменить после тренировки',
      'en':
          'For sports daily lenses are convenient because you can simply replace them after training'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Не спите в однодневных линзах, они не рассчитаны на ночной режим',
      'en':
          'Do not sleep in daily lenses because they are not designed for overnight wear'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Если однодневная линза высохла, выбросьте её и возьмите новую пару',
      'en': 'If a daily lens has dried out, discard it and open a new pair'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Проверяйте блистер однодневной линзы, он должен быть герметично закрыт',
      'en':
          'Check the blister pack of a daily lens to make sure it is sealed airtight'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Не вскрывайте блистер однодневной линзы заранее, делайте это прямо перед надеванием',
      'en':
          'Do not open the blister pack of a daily lens in advance, do it right before insertion'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы бывают сферическими, торическими и мультифокальными',
      'en': 'Daily lenses come in spherical, toric, and multifocal designs'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При частых инфекциях глаз врачи часто рекомендуют переход на однодневные линзы',
      'en':
          'For frequent eye infections doctors often recommend switching to daily disposable lenses'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Храните запас однодневных линз дома, на работе и в сумке для подстраховки',
      'en':
          'Keep a supply of daily lenses at home, at work, and in your bag as a backup'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные цветные линзы требуют такого же рецепта и контроля, как и прозрачные',
      'en':
          'Daily colored lenses require the same prescription and oversight as clear ones'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы удобны, если вы носите линзы только по выходным',
      'en': 'Daily lenses are convenient if you only wear lenses on weekends'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневная линза после снятия всегда подлежит утилизации, даже если вы носили её мало',
      'en':
          'A daily lens must always be discarded after removal even if you wore it for only a short time'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы уменьшают риск ошибок при очистке и хранении',
      'en': 'Daily lenses reduce the risk of errors in cleaning and storage'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Людям с плохой дисциплиной ухода безопаснее использовать однодневные линзы',
      'en':
          'People who struggle with lens care routines are safer using daily disposable lenses'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы подходят для людей с лёгким синдромом сухого глаза',
      'en': 'Daily lenses are suitable for people with mild dry eye syndrome'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При высоком риске кератита врачи часто переводят пациента на однодневные линзы',
      'en':
          'When the risk of keratitis is high doctors often switch the patient to daily disposable lenses'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Не носите однодневные линзы дольше 12–14 часов в сутки',
      'en': 'Do not wear daily lenses for more than 12–14 hours a day'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При повреждении однодневной линзы сразу возьмите новую из блистера',
      'en':
          'If a daily lens is damaged take a new one from a blister pack straight away'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы позволяют уменьшить контакт пальцев с поверхностью линзы',
      'en':
          'Daily lenses allow you to minimize finger contact with the lens surface'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При плавании и занятиях водными видами спорта лучше использовать однодневные линзы и выбрасывать их после занятия',
      'en':
          'For swimming and water sports use daily lenses and discard them after the session'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'В долгих перелётах удобно иметь несколько пар однодневных линз на смену',
      'en':
          'On long flights it is handy to have a few spare pairs of daily lenses to change into'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы часто лучше переносятся при сезонной аллергии',
      'en': 'Daily lenses are often better tolerated during seasonal allergies'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы помогают снизить риск накопления отложений на фоне аллергии',
      'en':
          'Daily lenses help reduce the risk of deposit buildup during allergy season'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Не пытайтесь промывать однодневную линзу физиологическим раствором для продления срока',
      'en':
          'Do not try to extend a daily lens by rinsing it with saline solution'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы удобны как резервный вариант, если плановые линзы вызывают дискомфорт',
      'en':
          'Daily lenses are a useful backup option if your scheduled replacement lenses cause discomfort'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Если вы часто забываете почистить линзы вечером, однодневные безопаснее',
      'en':
          'If you often forget to clean your lenses in the evening, daily lenses are the safer option'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы уменьшают риск заражения через загрязнённый контейнер',
      'en':
          'Daily lenses reduce the risk of contamination through a dirty lens case'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При использовании однодневных линз всё равно нужно мыть руки перед надеванием',
      'en':
          'Even with daily lenses you still need to wash your hands before insertion'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При острых инфекциях глаз однодневные линзы после выздоровления лучше начать с новой упаковки',
      'en':
          'After an acute eye infection start with a new pack of daily lenses when you recover'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы — удобное решение для тех, кто предпочитает минимум манипуляций с глазами',
      'en':
          'Daily lenses are a convenient choice for those who prefer minimal handling of their eyes'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При нерегулярном графике работы однодневные линзы легко адаптировать под ваши дни ношения',
      'en':
          'With an irregular work schedule daily lenses are easy to adapt to the days you actually wear them'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Не носите однодневные линзы в режиме продлённого ношения, это не предусмотрено',
      'en':
          'Do not wear daily lenses in an extended wear mode because they are not designed for it'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы особенно удобны для людей, которые часто путешествуют',
      'en':
          'Daily lenses are especially convenient for people who travel frequently'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Если вы часто пользуетесь бассейном, однодневные линзы проще заменить после плавания',
      'en':
          'If you swim regularly daily lenses are easier to replace after each pool session'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы помогают снизить количество шагов по уходу за линзами',
      'en':
          'Daily lenses help reduce the number of steps in your lens care routine'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При появлении дискомфорта в однодневной линзе просто замените её на новую',
      'en':
          'If you feel discomfort in a daily lens simply replace it with a new one'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы хорошо подходят людям с непереносимостью многофункциональных растворов',
      'en':
          'Daily lenses are a good fit for people who are intolerant to multipurpose solutions'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Не сочетайте ношение однодневных линз с плановыми, если это не согласовано с врачом',
      'en':
          'Do not mix daily lenses with scheduled replacement lenses unless your doctor has agreed to this'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Храните упаковку с однодневными линзами в сухом и прохладном месте',
      'en': 'Store the pack of daily lenses in a dry cool place'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Не используйте однодневные линзы, если блистер вскрыт или высох',
      'en':
          'Do not use daily lenses if the blister has been opened or has dried out'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы удобны для проб разных материалов и брендов перед выбором постоянного варианта',
      'en':
          'Daily lenses are convenient for trying different materials and brands before committing to one'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы снижают риск ошибок при расчёте срока замены',
      'en':
          'Daily lenses eliminate errors in calculating the replacement schedule'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При повышенном риске акантамёбного кератита предпочтительнее использовать однодневные линзы',
      'en':
          'When the risk of Acanthamoeba keratitis is elevated daily disposable lenses are the preferred option'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Для детей и подростков однодневные линзы проще объяснить и контролировать',
      'en':
          'Daily lenses are easier to explain and monitor for children and teenagers'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы хорошо подходят для тех, кто периодически возвращается к очкам',
      'en':
          'Daily lenses work well for those who switch back to glasses from time to time'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'В отпуске на море однодневные линзы удобнее, так как их легче заменять после контакта с водой',
      'en':
          'On a beach holiday daily lenses are more practical because they are easy to replace after water contact'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы позволяют отказаться от хранения и очистки линз в поездках',
      'en':
          'Daily lenses let you skip lens storage and cleaning entirely when traveling'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'При смене часовых поясов проще адаптировать режим ношения однодневных линз',
      'en':
          'When crossing time zones it is easier to adjust your wearing schedule with daily lenses'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы часто рекомендуют новичкам для безопасного начала ношения',
      'en':
          'Daily lenses are often recommended for first-time wearers to start safely'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы минимизируют риск накопления биоплёнки на поверхности линзы',
      'en':
          'Daily lenses minimize the risk of biofilm buildup on the lens surface'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Если вы склонны забывать про замачивание линз, однодневные помогают избежать ошибок ухода',
      'en':
          'If you tend to forget to soak your lenses daily disposables help you avoid care errors'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Дети и подростки легче осваивают уход за однодневными линзами, чем за плановыми',
      'en':
          'Children and teenagers find it easier to learn the routine for daily lenses than for scheduled replacement lenses'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы — самый простой по уходу вариант мягких контактных линз',
      'en':
          'Daily lenses are the easiest-to-care-for type of soft contact lenses'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы утилизируйте сразу после снятия',
      'en': 'Dispose of daily lenses right after removal'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Не пытайтесь носить однодневные линзы повторно',
      'en': 'Never reuse daily disposable lenses'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Для спорта однодневные линзы — самый удобный вариант',
      'en': 'Daily lenses are often the most convenient option for sports'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Однодневные линзы подходят при редком ношении',
      'en': 'Daily lenses are great for occasional wear'
    },
    {
      'icon': Icons.event,
      'color': _defaultColor,
      'ru':
          'Хранить однодневные линзы после вскрытия нельзя',
      'en': 'Do not store daily lenses after opening'
    }
  ];

  static const List<Map<String, dynamic>> _biweeklyTips = [
    // ДВУХНЕДЕЛЬНЫЕ ЛИНЗЫ
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Соблюдайте график: двухнедельные линзы носят 14 дней с момента вскрытия',
      'en':
          'Follow the schedule: two-week lenses are worn for 14 days from the date of opening'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы требуют ежедневной очистки и дезинфекции',
      'en': 'Two-week lenses require daily cleaning and disinfection'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Отмечайте дату вскрытия двухнедельных линз в календаре или приложении',
      'en': 'Mark the opening date of your two-week lenses in a calendar or app'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Не носите двухнедельные линзы дольше 14 дней, даже если они комфортны',
      'en':
          'Do not wear two-week lenses for more than 14 days even if they still feel comfortable'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Тщательно протирайте двухнедельные линзы пальцем с раствором каждый вечер',
      'en':
          'Rub your two-week lenses carefully with your finger and solution every evening'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'После протирки двухнедельные линзы всегда ополаскивайте свежим раствором',
      'en': 'After rubbing always rinse two-week lenses with fresh solution'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Замачивайте двухнедельные линзы в растворе не менее 4–6 часов',
      'en': 'Soak two-week lenses in solution for at least 4–6 hours'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Утром перед надеванием двухнедельной линзы ополосните её свежим раствором',
      'en':
          'In the morning rinse your two-week lens with fresh solution before insertion'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Не доливайте свежий раствор к старому в контейнере для двухнедельных линз',
      'en':
          'Do not top up old solution with fresh solution in the case for two-week lenses'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При нерегулярном ношении всё равно заменяйте двухнедельные линзы через 14 дней',
      'en':
          'Even with irregular wear still replace two-week lenses after 14 days'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы занимают промежуточное место между однодневными и месячными',
      'en':
          'Two-week lenses sit between daily and monthly lenses in terms of replacement frequency'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы дешевле однодневных, но требуют затрат на раствор и контейнер',
      'en':
          'Two-week lenses cost less than dailies but require spending on solution and a case'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Белковые отложения на двухнедельных линзах нарастают к концу срока ношения',
      'en':
          'Protein deposits on two-week lenses build up toward the end of the wearing period'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Если двухнедельная линза мутнеет до истечения 14 дней, замените её раньше',
      'en':
          'If a two-week lens becomes cloudy before 14 days are up replace it early'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Не спите в двухнедельных линзах без специального назначения врача',
      'en':
          'Do not sleep in two-week lenses without a specific prescription from your doctor'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Меняйте контейнер для двухнедельных линз примерно раз в месяц',
      'en': 'Replace the case for two-week lenses approximately once a month'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы требуют дисциплины в ежедневном уходе и замене',
      'en':
          'Two-week lenses require discipline in daily care and timely replacement'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы бывают торическими для коррекции астигматизма',
      'en':
          'Two-week lenses are available in toric designs for astigmatism correction'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Существуют двухнедельные мультифокальные линзы для коррекции пресбиопии',
      'en': 'Two-week multifocal lenses are available for presbyopia correction'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Не переходите с одной марки двухнедельных линз на другую без консультации врача',
      'en':
          'Do not switch from one brand of two-week lenses to another without consulting your doctor'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы часто изготавливают из силикон‑гидрогеля для лучшей кислородопроницаемости',
      'en':
          'Two-week lenses are often made from silicone hydrogel for better oxygen permeability'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Если вы склонны забывать об очистке, двухнедельные линзы требуют особого контроля',
      'en':
          'If you tend to forget cleaning your lenses two-week lenses require extra attention'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы подходят людям с регулярным графиком ношения',
      'en': 'Two-week lenses suit people who have a regular wearing schedule'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При аллергии тщательно очищайте двухнедельные линзы каждый вечер',
      'en':
          'During allergy season clean your two-week lenses thoroughly every evening'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Ферментный очиститель раз в неделю может помочь удалить белковые отложения с двухнедельных линз',
      'en':
          'A weekly enzymatic cleaner can help remove protein deposits from two-week lenses'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Не используйте физраствор как основной метод ухода за двухнедельными линзами',
      'en': 'Do not use saline as the primary care method for two-week lenses'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Перекисная система хорошо подходит для глубокой очистки двухнедельных линз',
      'en':
          'A hydrogen peroxide system works well for deep cleaning of two-week lenses'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Соблюдайте инструкции к раствору при уходе за двухнедельными линзами',
      'en': 'Follow the solution instructions when caring for two-week lenses'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При повреждении двухнедельной линзы замените её сразу, не дожидаясь конца срока',
      'en':
          'If a two-week lens is damaged replace it immediately without waiting for the end of the period'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы нельзя стерилизовать кипячением или обычной перекисью из аптеки',
      'en':
          'Two-week lenses must not be sterilized by boiling or with regular pharmacy hydrogen peroxide'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Если не носили двухнедельные линзы несколько дней, замените раствор перед надеванием',
      'en':
          'If you have not worn your two-week lenses for a few days replace the solution before putting them in'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При выпадении двухнедельной линзы на пол необходимо провести полную дезинфекцию перед повторным использованием',
      'en':
          'If a two-week lens falls on the floor perform a full disinfection before reusing it'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Не храните двухнедельные линзы в растворе дольше срока, указанного производителем раствора',
      'en':
          'Do not store two-week lenses in solution longer than the period stated by the solution manufacturer'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Если вы часто забываете день замены, используйте напоминания или приложения',
      'en':
          'If you often forget your replacement day use reminders or a dedicated app'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы являются хорошим компромиссом между комфортом и ценой',
      'en': 'Two-week lenses offer a good compromise between comfort and cost'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При повышенной чувствительности к отложениям обсудите с врачом переход на однодневные линзы',
      'en':
          'If you are highly sensitive to deposits discuss switching to daily lenses with your doctor'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Не носите двухнедельные линзы во время сна, если нет отдельного назначения',
      'en':
          'Do not wear two-week lenses while sleeping unless specifically prescribed'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Ведите записи о сроках замены двухнедельных линз, чтобы не продлевать их случайно',
      'en':
          'Keep track of your two-week lens replacement dates so you do not accidentally extend them'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При частых воспалениях глаз смена двухнедельных линз на однодневные может снизить риск осложнений',
      'en':
          'Switching from two-week to daily lenses may reduce the risk of complications if you have frequent eye inflammation'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Не меняйте марку раствора для двухнедельных линз без консультации офтальмолога',
      'en':
          'Do not change the brand of solution for your two-week lenses without consulting your eye doctor'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При длительных поездках заранее продумайте запас раствора и контейнеров для двухнедельных линз',
      'en':
          'For long trips plan ahead and pack enough solution and cases for your two-week lenses'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы требуют более тщательного отношения к контейнеру, чем однодневные',
      'en':
          'Two-week lenses require more careful attention to the case than daily lenses do'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Если двухнедельные линзы вызывают дискомфорт в конце срока, обсудите смену режима',
      'en':
          'If two-week lenses cause discomfort near the end of the period discuss changing your schedule with your doctor'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При переходе с месячных на двухнедельные уточните у врача рекомендации по уходу',
      'en':
          'When switching from monthly to two-week lenses ask your doctor about the updated care routine'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы могут быть хорошим шагом от месячных к более гигиеничным режимам',
      'en':
          'Two-week lenses can be a good step from monthly lenses toward more hygienic wear schedules'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Не используйте двухнедельные линзы после перенесённых тяжёлых инфекций глаз, начните с новой пары',
      'en':
          'Do not use two-week lenses after a serious eye infection, start with a fresh pair'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы удобно сочетать с очками, чтобы давать глазам отдых',
      'en':
          'Two-week lenses work well when alternated with glasses to give your eyes a rest'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При появлении частых отложений на двухнедельных линзах обсудите смену раствора или материала',
      'en':
          'If deposits form frequently on your two-week lenses discuss changing your solution or lens material'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Соблюдение чёткого 14‑дневного графика снижает риск воспалений при двухнедельных линзах',
      'en':
          'Following a strict 14-day schedule reduces the risk of inflammation with two-week lenses'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При высокой чувствительности роговицы двухнедельные линзы могут быть комфортнее месячных',
      'en':
          'For highly sensitive corneas two-week lenses may be more comfortable than monthly ones'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Старайтесь не превышать 8–12 часов ношения двухнедельных линз в день',
      'en': 'Try not to exceed 8–12 hours of daily wear with two-week lenses'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Если вы часто занимаетесь спортом, двухнедельные линзы можно сочетать с однодневными на тренировки',
      'en':
          'If you exercise frequently you can combine two-week lenses with daily lenses for workouts'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При сезонной аллергии возможно временное переключение с двухнедельных линз на однодневные',
      'en':
          'During seasonal allergy season you can temporarily switch from two-week to daily lenses'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Не забывайте очищать и дезинфицировать двухнедельные линзы даже при редком ношении',
      'en':
          'Remember to clean and disinfect two-week lenses even when you wear them infrequently'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Старайтесь не превышать рекомендованный срок хранения вскрытого блистера двухнедельной линзы',
      'en':
          'Try not to exceed the recommended storage period for an opened two-week lens blister'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При стрессе и недосыпании глаза хуже переносят двухнедельные линзы, снижайте время ношения',
      'en':
          'During stress and sleep deprivation eyes tolerate two-week lenses less well, so reduce wearing time'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При беременности обсуждайте с врачом комфорт и срок ношения двухнедельных линз',
      'en':
          'During pregnancy discuss lens comfort and wearing schedule with your doctor'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы требуют чёткой связи между датой вскрытия и датой утилизации',
      'en':
          'Two-week lenses require a clear link between the opening date and the disposal date'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Если вам сложно соблюдать график, возможно, однодневные линзы будут безопаснее двухнедельных',
      'en':
          'If you find it hard to stick to a schedule daily lenses may be safer than two-week ones'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы подходят людям, которые готовы немного больше уделять внимания уходу',
      'en':
          'Two-week lenses suit people who are prepared to put a little more effort into lens care'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При регулярном ношении двухнедельных линз не забывайте менять контейнер каждые 1–3 месяца',
      'en':
          'When wearing two-week lenses regularly remember to replace the case every 1–3 months'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'При любых подозрениях на инфекцию снимайте двухнедельные линзы и обращайтесь к врачу',
      'en':
          'At any sign of infection remove your two-week lenses and see a doctor'
    },
    {
      'icon': Icons.event_note,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы дают хороший баланс между стоимостью и частотой замены',
      'en':
          'Two-week lenses offer a good balance between cost and replacement frequency'
    },
    {
      'icon': Icons.date_range,
      'color': _defaultColor,
      'ru':
          'Двухнедельные линзы меняйте каждые 14 дней от даты вскрытия',
      'en': 'Replace bi-weekly lenses every 14 days from opening'
    },
    {
      'icon': Icons.date_range,
      'color': _defaultColor,
      'ru':
          'Каждый вечер очищайте двусторонне с раствором',
      'en': 'Rub and rinse both sides every evening'
    },
    {
      'icon': Icons.date_range,
      'color': _defaultColor,
      'ru':
          'Не продлевайте срок ношения двухнедельных линз',
      'en': 'Do not extend bi-weekly lens wear beyond schedule'
    },
    {
      'icon': Icons.date_range,
      'color': _defaultColor,
      'ru':
          'При дискомфорте замените линзу раньше срока',
      'en': 'Replace lenses earlier if discomfort appears'
    },
    {
      'icon': Icons.date_range,
      'color': _defaultColor,
      'ru':
          'Отмечайте дату вскрытия на упаковке',
      'en': 'Mark the opening date on the package'
    }
  ];

  static const List<Map<String, dynamic>> _monthlyTips = [
    // МЕСЯЧНЫЕ ЛИНЗЫ
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы служат 30 дней с момента вскрытия блистера',
      'en': 'Monthly lenses last 30 days from the date the blister is opened'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Срок ношения месячных линз отсчитывается от даты вскрытия, а не дней использования',
      'en':
          'The wear period of monthly lenses is counted from the opening date, not the number of days worn'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Ежедневная очистка обязательна для безопасного ношения месячных линз',
      'en': 'Daily cleaning is essential for safe wear of monthly lenses'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Протирайте месячные линзы пальцем с раствором после каждого дня ношения',
      'en':
          'Rub your monthly lenses with your finger and solution after each day of wear'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'После протирки месячных линз всегда ополаскивайте их свежим раствором',
      'en': 'After rubbing always rinse monthly lenses with fresh solution'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Перекисные системы особенно хорошо очищают месячные линзы от отложений',
      'en':
          'Hydrogen peroxide systems are especially effective at removing deposits from monthly lenses'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не надевайте месячные линзы до окончания нейтрализации перекисного раствора',
      'en':
          'Do not insert monthly lenses before the peroxide solution has fully neutralized'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Осматривайте месячную линзу перед каждым надеванием на разрывы и помутнения',
      'en':
          'Inspect your monthly lens for tears and cloudiness before each insertion'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Если на месячной линзе появились белые точки или мутные участки, замените её раньше срока',
      'en':
          'If white spots or cloudy areas appear on a monthly lens replace it before the end of the period'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не носите месячные линзы дольше 30 дней, даже если они кажутся комфортными',
      'en':
          'Do not wear monthly lenses for more than 30 days even if they still feel comfortable'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Меняйте контейнер для месячных линз каждые 1–3 месяца',
      'en': 'Replace the case for monthly lenses every 1–3 months'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы требуют строгого соблюдения гигиены контейнера и раствора',
      'en': 'Monthly lenses require strict hygiene of the case and solution'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы экономичны при ежедневном ношении, но требуют дисциплины',
      'en':
          'Monthly lenses are cost-effective for daily wear but require discipline'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Силикон‑гидрогелевые месячные линзы пропускают больше кислорода к роговице',
      'en':
          'Silicone hydrogel monthly lenses allow more oxygen to reach the cornea'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не используйте аптечную 3% перекись водорода вместо специальной системы для очистки',
      'en':
          'Do not use pharmacy 3% hydrogen peroxide instead of a dedicated lens care system'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При появлении дискомфорта в конце месяца обсудите с врачом смену типа линз',
      'en':
          'If you feel discomfort toward the end of the month discuss switching lens types with your doctor'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы подходят при стабильном образе жизни и регулярном ношении',
      'en':
          'Monthly lenses are suitable for a stable lifestyle with regular wear'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При редком ношении линз пересчитайте, возможно, однодневные будут выгоднее месячных',
      'en':
          'If you wear lenses infrequently recalculate whether daily lenses would be more cost-effective than monthly ones'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Если вы забыли очистить месячные линзы вечером, тщательно промойте их перед надеванием',
      'en':
          'If you forgot to clean your monthly lenses in the evening rinse them thoroughly before putting them in'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не носите месячные линзы во время сна без отдельного назначения',
      'en':
          'Do not wear monthly lenses while sleeping without a specific prescription'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Некоторые месячные линзы одобрены для непрерывного ношения, но этот режим повышает риск осложнений',
      'en':
          'Some monthly lenses are approved for continuous wear but this mode increases the risk of complications'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Оптимальный режим месячных линз — дневное ношение с ночным хранением в растворе',
      'en':
          'The optimal routine for monthly lenses is daytime wear with overnight storage in solution'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не храните месячные линзы в растворе дольше, чем указано производителем раствора',
      'en':
          'Do not store monthly lenses in solution longer than stated by the solution manufacturer'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При инфекциях глаз заменяйте месячные линзы новой парой после выздоровления',
      'en':
          'After an eye infection replace your monthly lenses with a new pair when you recover'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При плавании в месячных линзах лучше заменять их после контакта с водой',
      'en':
          'If you swim in monthly lenses it is better to replace them after water contact'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы доступны в торических вариантах для коррекции астигматизма',
      'en':
          'Monthly lenses are available in toric designs for astigmatism correction'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Мультифокальные месячные линзы помогают видеть и вблизи, и вдаль без очков',
      'en':
          'Multifocal monthly lenses allow you to see both near and far without glasses'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не переходите на другую марку месячных линз без согласования с офтальмологом',
      'en':
          'Do not switch to a different brand of monthly lenses without consulting your eye doctor'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При частых воспалениях глаз рассмотрите с врачом переход с месячных линз на более частую замену',
      'en':
          'If you have frequent eye inflammation discuss switching from monthly lenses to a more frequent replacement schedule with your doctor'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы требуют регулярных контрольных осмотров у офтальмолога',
      'en':
          'Monthly lenses require regular follow-up check-ups with your eye doctor'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При первых признаках помутнения или микротрещин на месячной линзе не пытайтесь её доносить',
      'en':
          'At the first signs of cloudiness or micro-cracks in a monthly lens do not try to keep wearing it'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Соблюдение 30‑дневного срока ношения снижает риск инфекционных осложнений',
      'en':
          'Keeping to the 30-day wear period reduces the risk of infectious complications'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не используйте месячные линзы в качестве ночных ортокератологических линз',
      'en': 'Do not use monthly lenses as overnight orthokeratology lenses'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При сильной сухости глаз иногда лучше перейти с месячных линз на однодневные',
      'en':
          'If you have severe dry eyes it may be better to switch from monthly lenses to daily ones'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При нерегулярном графике ношения месячные линзы сложнее контролировать по срокам',
      'en':
          'With an irregular wearing schedule it is harder to keep track of monthly lens replacement dates'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы хорошо подходят тем, кто готов ежедневно ухаживать за линзами',
      'en':
          'Monthly lenses work well for people who are prepared to care for their lenses every day'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Сочетайте месячные линзы с очками по вечерам, чтобы дать глазам отдых',
      'en':
          'Alternate monthly lenses with glasses in the evenings to give your eyes a rest'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не превышайте рекомендованное ежедневное время ношения месячных линз',
      'en':
          'Do not exceed the recommended daily wearing time for monthly lenses'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При появлении белковых отложений на месячных линзах обсудите с врачом ферментную очистку',
      'en':
          'If protein deposits appear on your monthly lenses discuss enzymatic cleaning with your doctor'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не используйте старые контейнеры для хранения новых месячных линз',
      'en': 'Do not use old cases to store new monthly lenses'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Храните упаковки с месячными линзами в прохладном сухом месте, защищённом от солнца',
      'en':
          'Store monthly lens packs in a cool dry place protected from sunlight'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Проверяйте целостность блистеров месячных линз перед вскрытием',
      'en': 'Check the integrity of monthly lens blisters before opening them'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При повреждении блистера не используйте линзу, даже если она выглядит целой',
      'en': 'Do not use a lens from a damaged blister even if it looks intact'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При смене раствора для месячных линз следите за комфортом в первые недели',
      'en':
          'When you change solution for monthly lenses monitor your comfort during the first few weeks'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы удобны для тех, кто носит линзы практически каждый день',
      'en':
          'Monthly lenses are convenient for people who wear lenses almost every day'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Если вы часто забываете дату замены, используйте календарь или приложение',
      'en':
          'If you often forget the replacement date use a calendar or an app to track it'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При частых простудах и вирусных инфекциях обсуждайте с врачом режим ношения месячных линз',
      'en':
          'If you frequently get colds or viral infections discuss your monthly lens wearing schedule with your doctor'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы требуют аккуратного отношения к срокам и ежедневной гигиене',
      'en':
          'Monthly lenses require careful attention to schedules and daily hygiene'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При любых признаках аллергии на раствор попробуйте с врачом сменить систему ухода',
      'en':
          'At any sign of an allergic reaction to your solution try changing the care system with your doctor'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы могут быть хорошим выбором при стабильных параметрах зрения',
      'en':
          'Monthly lenses can be a good choice when your vision prescription is stable'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не носите месячные линзы при активном воспалении век или ячмене',
      'en':
          'Do not wear monthly lenses during active eyelid inflammation or a stye'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При регулярном спорте может быть удобно иметь однодневные линзы вместо месячных на тренировки',
      'en':
          'If you exercise regularly it may be convenient to use daily lenses instead of monthly ones for workouts'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы требуют более частых визитов к врачу, чем очки, для контроля состояния роговицы',
      'en':
          'Monthly lenses require more frequent doctor visits than glasses to monitor corneal health'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Старайтесь не откладывать замену месячных линз даже при отсутствии симптомов',
      'en':
          'Try not to delay replacing monthly lenses even when you have no symptoms'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При переходе с очков на месячные линзы дайте себе время для адаптации',
      'en':
          'When switching from glasses to monthly lenses give yourself time to adapt'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не носите месячные линзы во время тяжёлых системных заболеваний без согласования с врачом',
      'en':
          'Do not wear monthly lenses during serious systemic illness without your doctor\'s approval'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При планировании беременности обсудите использование месячных линз с офтальмологом',
      'en':
          'When planning a pregnancy discuss monthly lens use with your eye doctor'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы — популярный режим, но он требует ответственного ухода каждый день',
      'en':
          'Monthly lenses are a popular choice but they require responsible care every day'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При частых отложениях на месячных линзах возможно, вам больше подойдёт другой материал или режим замены',
      'en':
          'If deposits form frequently on your monthly lenses a different material or replacement schedule may suit you better'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'При любом подозрении на инфекцию снимайте месячные линзы и обращайтесь к врачу',
      'en':
          'At any suspicion of infection remove your monthly lenses and see a doctor'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Месячные линзы дают хорошее качество зрения при правильном подборе и уходе',
      'en':
          'Monthly lenses provide good vision quality when properly fitted and cared for'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Храните запас месячных линз так, чтобы легко отслеживать сроки каждой пары',
      'en':
          'Store your supply of monthly lenses in a way that makes it easy to track the expiry of each pair'
    },
    {
      'icon': Icons.calendar_today,
      'color': _defaultColor,
      'ru':
          'Не пытайтесь удлинять срок ношения месячных линз даже при хорошем самочувствии глаз',
      'en':
          'Do not try to extend the wear period of monthly lenses even when your eyes feel fine'
    },
    {
      'icon': Icons.calendar_month,
      'color': _defaultColor,
      'ru':
          'Месячные линзы требуют особенно аккуратной гигиены',
      'en': 'Monthly lenses require especially careful hygiene'
    },
    {
      'icon': Icons.calendar_month,
      'color': _defaultColor,
      'ru':
          'Не используйте просроченные месячные линзы',
      'en': 'Do not use expired monthly lenses'
    },
    {
      'icon': Icons.calendar_month,
      'color': _defaultColor,
      'ru':
          'Срок замены считается с момента вскрытия блистера',
      'en': 'Replacement period starts from blister opening, not wear count'
    },
    {
      'icon': Icons.calendar_month,
      'color': _defaultColor,
      'ru':
          'Для ночного сна используйте только линзы с разрешением врача',
      'en': 'Wear lenses overnight only with medical approval'
    },
    {
      'icon': Icons.calendar_month,
      'color': _defaultColor,
      'ru':
          'При частых отложениях обсудите смену материала линз',
      'en': 'Discuss changing lens material if deposits appear frequently'
    }
  ];

  static const List<Map<String, dynamic>> _quarterlyTips = [
    // КВАРТАЛЬНЫЕ ЛИНЗЫ
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы рассчитаны на ношение около 90 дней с момента вскрытия',
      'en':
          'Quarterly lenses are designed for approximately 90 days of wear from the date of opening'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          '90 дней — максимальный срок ношения квартальных линз, не продлевайте его',
      'en':
          '90 days is the maximum wear period for quarterly lenses, do not extend it'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы требуют особенно тщательной ежедневной очистки',
      'en': 'Quarterly lenses require especially thorough daily cleaning'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Обязательно протирайте квартальные линзы пальцем с раствором каждый вечер',
      'en':
          'Always rub your quarterly lenses with your finger and solution every evening'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы накапливают отложения — следите за чистотой и прозрачностью',
      'en':
          'Quarterly lenses accumulate deposits, so monitor their cleanliness and clarity'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При первых признаках помутнения квартальной линзы обсудите с врачом необходимость замены',
      'en':
          'At the first signs of cloudiness in a quarterly lens discuss whether to replace it with your doctor'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Раз в неделю можно использовать ферментный очиститель для квартальных линз по рекомендации врача',
      'en':
          'A weekly enzymatic cleaner can be used for quarterly lenses on your doctor\'s recommendation'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Не носите квартальные линзы при появлении трещин или надрывов, замените их немедленно',
      'en':
          'Do not wear quarterly lenses if cracks or tears appear, replace them immediately'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы чаще всего требуют перекисной системы для глубокой очистки',
      'en':
          'Quarterly lenses most often require a hydrogen peroxide system for deep cleaning'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы не подходят людям, которые не готовы к строгому уходу',
      'en':
          'Quarterly lenses are not suitable for people who are not prepared for a strict care routine'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При аллергии старайтесь избегать длительных режимов ношения вроде квартальных линз',
      'en':
          'If you have allergies try to avoid long replacement schedules such as quarterly lenses'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные мягкие линзы должны заменяться по графику даже при внешней целостности',
      'en':
          'Soft quarterly lenses must be replaced on schedule even if they look intact'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Жёсткие газопроницаемые линзы могут служить дольше, но уход за ними отличается',
      'en':
          'Rigid gas-permeable lenses can last longer but their care routine is different'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Растворы для мягких квартальных линз нельзя использовать с жёсткими линзами',
      'en':
          'Solutions for soft quarterly lenses must not be used with rigid lenses'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы требуют более частых осмотров у офтальмолога',
      'en':
          'Quarterly lenses require more frequent check-ups with your eye doctor'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При появлении частых воспалений глаз обсудите с врачом отказ от квартальных линз',
      'en':
          'If you have frequent eye inflammation discuss switching away from quarterly lenses with your doctor'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Не спите в квартальных линзах, если только это не отдельный режим по назначению',
      'en':
          'Do not sleep in quarterly lenses unless this is a specifically prescribed wearing mode'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При использовании квартальных линз соблюдайте особенно строгую гигиену контейнера',
      'en':
          'When using quarterly lenses maintain especially strict hygiene of the lens case'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Не используйте квартальные линзы, если часто забываете об очистке и смене раствора',
      'en':
          'Do not use quarterly lenses if you often forget to clean them and change the solution'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы могут быть экономичными, но цена ошибки ухода у них выше',
      'en':
          'Quarterly lenses can be cost-effective but the consequences of poor care are more serious'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При сезонной аллергии лучше временно переходить на линзы с более частой заменой',
      'en':
          'During seasonal allergies it is better to temporarily switch to lenses with a more frequent replacement schedule'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы подходят только мотивированным и дисциплинированным пользователям',
      'en':
          'Quarterly lenses are only suitable for motivated and disciplined wearers'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При нестабильном зрении квартальные линзы менее удобны, чем короткие режимы',
      'en':
          'With an unstable prescription quarterly lenses are less practical than shorter replacement schedules'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Не продлевайте срок ношения квартальных линз ради экономии, это опасно для глаз',
      'en':
          'Do not extend the wear period of quarterly lenses to save money because it is dangerous for your eyes'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При смене раствора для квартальных линз внимательно следите за реакцией глаз',
      'en':
          'When you change solution for quarterly lenses monitor your eye reaction carefully'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы необходимы не всем, обсуждайте режим замены с офтальмологом',
      'en':
          'Quarterly lenses are not for everyone, discuss your replacement schedule with your eye doctor'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При длительных режимах ношения, например квартальных, риск накопления отложений выше',
      'en':
          'With long replacement schedules such as quarterly lenses the risk of deposit buildup is higher'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При частых поездках и смене условий лучше выбирать менее длительные режимы, чем квартальные',
      'en':
          'If you travel frequently or your environment changes often choose a shorter replacement schedule than quarterly'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы особенно чувствительны к нарушениям гигиены, не пренебрегайте уходом',
      'en':
          'Quarterly lenses are particularly sensitive to hygiene lapses so never neglect their care'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При длительных режимах ношения важнее регулярно посещать офтальмолога',
      'en':
          'With long replacement schedules it is even more important to visit your eye doctor regularly'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Не используйте квартальные линзы, если у вас в прошлом были тяжёлые инфекционные осложнения',
      'en':
          'Do not use quarterly lenses if you have had serious infectious complications in the past'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При любых признаках раздражения или покраснения снимайте квартальные линзы и обращайтесь к врачу',
      'en':
          'At any signs of irritation or redness remove your quarterly lenses and see a doctor'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы обычно более толстые, чем линзы коротких режимов',
      'en':
          'Quarterly lenses are usually thicker than lenses designed for shorter replacement schedules'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При ощущении инородного тела в квартальной линзе проверьте её на повреждения',
      'en':
          'If you feel a foreign body sensation with a quarterly lens check it for damage'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Не продолжайте ношение квартальной линзы, если она стала заметно менее комфортной',
      'en':
          'Do not continue wearing a quarterly lens if it has become noticeably less comfortable'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы могут быть оправданы при некоторых сложных нарушениях зрения, но только по назначению',
      'en':
          'Quarterly lenses may be justified for certain complex vision conditions but only when prescribed'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При любых сомнениях лучше заменить квартальную линзу, чем рисковать здоровьем глаза',
      'en':
          'When in doubt it is better to replace a quarterly lens than to risk your eye health'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Чем дольше срок замены линзы, тем строже должны быть правила гигиены',
      'en':
          'The longer the lens replacement period the stricter the hygiene rules must be'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы требуют максимального контроля за чистотой раствора и контейнера',
      'en':
          'Quarterly lenses require maximum control over the cleanliness of the solution and case'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При повышенной чувствительности глаз к отложениям лучше рассмотреть более частую замену линз',
      'en':
          'If your eyes are highly sensitive to deposits consider switching to a more frequent replacement schedule'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Длительные режимы ношения, такие как квартальные, не подходят большинству новичков',
      'en':
          'Long replacement schedules such as quarterly lenses are not suitable for most first-time wearers'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы желательно использовать только после успешного опыта с более короткими режимами',
      'en':
          'Quarterly lenses should ideally be used only after successful experience with shorter replacement schedules'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При выборе квартальных линз учитывайте риск акантамёбного кератита при нарушении гигиены',
      'en':
          'When choosing quarterly lenses consider the risk of Acanthamoeba keratitis from any hygiene lapses'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При сухом климате и кондиционированном воздухе квартальные линзы могут быть менее комфортны',
      'en':
          'In dry climates and air-conditioned environments quarterly lenses may be less comfortable'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Не сочетайте квартальные линзы с нерегулярным режимом ухода, это повышает риск осложнений',
      'en':
          'Do not combine quarterly lenses with an irregular care routine because it increases the risk of complications'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При смене образа жизни стоит пересмотреть целесообразность квартальных линз',
      'en':
          'When your lifestyle changes it is worth reconsidering whether quarterly lenses are still the right choice'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы требуют точного отслеживания даты открытия и даты замены',
      'en':
          'Quarterly lenses require accurate tracking of the opening date and the replacement date'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Не рекомендуйте квартальные линзы другим без обсуждения с их врачом',
      'en':
          'Do not recommend quarterly lenses to others without them consulting their own doctor'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При появлении любых болевых ощущений в квартальных линзах снимайте их немедленно',
      'en':
          'If you feel any pain while wearing quarterly lenses remove them immediately'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы требуют более внимательного отношения к качеству раствора и сроку годности',
      'en':
          'Quarterly lenses require extra attention to solution quality and expiration dates'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Если вы часто забываете дату замены, квартальные линзы могут быть небезопасным выбором',
      'en':
          'If you often forget your replacement date quarterly lenses may not be a safe choice for you'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При сомнении всегда отдавайте предпочтение более частой замене линз, а не квартальному режиму',
      'en':
          'When in doubt always prefer a more frequent replacement schedule over a quarterly one'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы могут быть удобны опытным пользователям при строгом соблюдении всех правил ухода',
      'en':
          'Quarterly lenses can be convenient for experienced wearers who strictly follow all care guidelines'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При подборе квартальных линз важно особо тщательно оценить поверхность роговицы',
      'en':
          'When fitting quarterly lenses it is especially important to thoroughly assess the corneal surface'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Не забывайте, что риск осложнений выше при любых длительных режимах ношения, включая квартальные линзы',
      'en':
          'Remember that the risk of complications is higher with any long replacement schedule including quarterly lenses'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При ухудшении переносимости квартальных линз обсудите с врачом смену режима на меньший срок',
      'en':
          'If your tolerance for quarterly lenses worsens discuss switching to a shorter replacement schedule with your doctor'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы не должны использоваться для компенсации редких визитов к офтальмологу',
      'en':
          'Quarterly lenses should not be used as a substitute for regular eye doctor visits'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При серьёзных факторах риска инфекций глаз откажитесь от квартальных линз в пользу более частой замены',
      'en':
          'If you have serious eye infection risk factors switch from quarterly lenses to a more frequent replacement schedule'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы следует использовать только по согласованию с офтальмологом и при хорошем контроле ухода',
      'en':
          'Quarterly lenses should only be used with your eye doctor\'s approval and under good care control'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При появлении стойкого дискомфорта в квартальных линзах не затягивайте с визитом к врачу',
      'en':
          'If persistent discomfort develops with quarterly lenses do not delay seeing your doctor'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы подходят не всем, выбор режима замены должен быть индивидуальным',
      'en':
          'Quarterly lenses are not right for everyone and the replacement schedule must be chosen individually'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Всегда храните дату вскрытия квартальных линз вместе с упаковкой для контроля срока',
      'en':
          'Always keep the opening date with the pack so you can track the wear period of your quarterly lenses'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы требуют, чтобы вы особенно внимательно относились к любым изменениям в глазах',
      'en':
          'Quarterly lenses require you to pay especially close attention to any changes in your eyes'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Если возникли трудности с уходом за квартальными линзами, попросите врача подобрать более простой режим',
      'en':
          'If you are struggling with the care of quarterly lenses ask your doctor to find a simpler replacement schedule'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Квартальные линзы требуют строгого соблюдения ухода',
      'en': 'Quarterly lenses require strict care routines'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При длительном режиме ношения чаще проходите осмотры',
      'en': 'Have checkups more often with long replacement schedules'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Не продлевайте срок квартальных линз ради экономии',
      'en': 'Do not extend quarterly lens use to save money'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'При первых симптомах раздражения снимайте линзы',
      'en': 'Remove lenses at the first sign of irritation'
    },
    {
      'icon': Icons.insights,
      'color': _defaultColor,
      'ru':
          'Качественный уход важнее при длинных циклах замены',
      'en': 'High-quality care is critical for long replacement cycles'
    }
  ];

  static List<Map<String, dynamic>> _getTipsForLensType(LensType lensType) {
    switch (lensType) {
      case LensType.daily:
      case LensType.weekly:
        return _dailyTips;
      case LensType.biweekly:
        return _biweeklyTips;
      case LensType.monthly:
        return _monthlyTips;
      case LensType.quarterly:
      case LensType.halfYearly:
        return _quarterlyTips;
    }
  }

  static int _getDayOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    return date.difference(firstDayOfYear).inDays + 1;
  }

  static Map<String, dynamic> _localizedTip(
    Map<String, dynamic> source,
    String languageCode,
  ) {
    final isRu = languageCode == 'ru';
    return {
      'icon': source['icon'],
      'color': source['color'],
      'text': isRu ? source['ru'] : source['en'],
    };
  }

  static Map<String, dynamic> getTipForToday(LensType lensType) {
    return getTipForDate(lensType, DateTime.now());
  }

  static Map<String, dynamic> getTipForDate(LensType lensType, DateTime date) {
    final languageCode = AppLocaleController.currentLanguageCode;
    final dayOfYear = _getDayOfYear(date);
    final specificTips = _getTipsForLensType(lensType);
    final source = dayOfYear % 2 == 0
        ? _generalTips[(dayOfYear ~/ 2) % _generalTips.length]
        : specificTips[(dayOfYear ~/ 2) % specificTips.length];
    return _localizedTip(source, languageCode);
  }

  static String getTipTextForToday(LensType lensType) {
    return getTipForToday(lensType)['text'] as String;
  }

  static String getTipTextForDate(LensType lensType, DateTime date) {
    return getTipForDate(lensType, date)['text'] as String;
  }

  static List<Map<String, dynamic>> getAllGeneralTips() {
    final languageCode = AppLocaleController.currentLanguageCode;
    return _generalTips.map((tip) => _localizedTip(tip, languageCode)).toList();
  }
}

