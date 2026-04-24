// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../l10n/domain_localization_extensions.dart';
import '../l10n/l10n_extensions.dart';
import '../services/lens_data_service.dart';
import '../services/home_widget_service.dart';
import '../models/lens_data.dart';
import '../calendar/domain/models/day_event.dart';
import '../calendar/domain/services/calendar_aggregator.dart';
import '../calendar/domain/services/day_details_builder.dart';
import '../calendar/presentation/widgets/day_details_sheet.dart';
import '../utils/lens_tips.dart';
import '../utils/intl_locale.dart';
import '../theme/action_palette.dart';
import 'calendar_screen.dart';
import '../widgets/primary_gradient_button.dart';

class HomeScreen extends StatefulWidget {
  final LensDataService dataService;
  final VoidCallback? onDataChanged;
  final VoidCallback onCheckNotifications;
  final VoidCallback? onPutOnLenses;
  final void Function(BuildContext calendarContext, DateTime date)? onAddEntryForDate;
  final void Function(DateTime date)? onRequestAddForDate;

  const HomeScreen({
    Key? key,
    required this.dataService,
    this.onDataChanged,
    required this.onCheckNotifications,
    this.onPutOnLenses,
    this.onAddEntryForDate,
    this.onRequestAddForDate,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  DateTime _selectedDay = DateTime.now();
  final ScrollController _weekScrollController = ScrollController();
  bool _weekScrollInitialized = false;
  final CalendarAggregator _calendarAggregator = CalendarAggregator();
  final DayDetailsBuilder _dayDetailsBuilder = DayDetailsBuilder();

  late LensInfo _lensInfo;
  late int _daysWorn;
  late int _currentStock;
  late bool _hasActiveCycle;
  late DateTime? _cycleStartDate;
  late LensCycle? _activeCycle;
  late int _stockAlertThreshold;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadData();
  }

  @override
  void dispose() {
    _weekScrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadData();
    }
  }

  /// Выбранная дата для добавления записей
  DateTime get selectedDay => _selectedDay;

  void loadData() {
    setState(() {
      _lensInfo = widget.dataService.getLensInfo();
      _daysWorn = widget.dataService.getDaysWorn();
      _currentStock = widget.dataService.getCurrentStock();
      _activeCycle = widget.dataService.getActiveCycle();
      _hasActiveCycle = _activeCycle != null;
      _cycleStartDate = _activeCycle?.startDate;
      _stockAlertThreshold = widget.dataService.getStockAlertThreshold();

      // ?? EDGE-001: защита от отрицательных значений
      if (_daysWorn <= 0 && _hasActiveCycle) {
        _daysWorn = 1;
      }
    });
    // Виджет «До замены линз» обновляется синхронно с полем на главном экране
    HomeWidgetService.updateLensWidget(widget.dataService);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 360;
    final horizontalPadding = isNarrowScreen ? 16.0 : 24.0;
    final totalDays = _lensInfo.type.days;
    final daysRemaining = _hasActiveCycle ? (totalDays - _daysWorn).clamp(0, totalDays) : totalDays;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isNarrowScreen),
            _buildWeekSelector(isNarrowScreen),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Padding(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    children: [
                      _buildProgressCard(
                        _daysWorn,
                        totalDays,
                        daysRemaining,
                        _hasActiveCycle,
                        isNarrowScreen,
                      ),
                      const SizedBox(height: 20),
                      _buildStatsGrid(_daysWorn, _currentStock, isNarrowScreen),
                      const SizedBox(height: 20),
                      _buildTipsCard(isNarrowScreen),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =======================================================================
  // ХЕДЕР
  // =======================================================================

  Widget _buildHeader(bool isNarrowScreen) {
    return Container(
      padding: EdgeInsets.all(isNarrowScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homeTitle,
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 20 : 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.homeSubtitle,
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 11 : 12,
                    color:
                        Theme.of(context).colorScheme.onPrimary.withOpacity(0.82),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarScreen(
                    dataService: widget.dataService,
                    onDataChanged: widget.onDataChanged,
                  ),
                ),
              );
              if (mounted) loadData();
            },
            icon: Icon(
              Icons.calendar_month,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
        ],
      ),
    );
  }

  // =======================================================================
  // ВЫБОР ДНЕЙ НЕДЕЛИ (ПН–ВС)
  // =======================================================================

  Color get _colorReplacement => context.actionPalette.replacement;
  Color get _colorSymptom => context.actionPalette.symptom;
  Color get _colorRemoval => context.actionPalette.removal;
  Color get _colorStockAttention => context.actionPalette.attention;
  Color get _colorStockLow => context.actionPalette.overdue;

  static const int _weeksBefore = 4;
  static const int _weeksAfter = 8;
  static const double _blockWidth = 44.0;
  static const double _blockHeight = 64.0;
  static const double _blockGap = 4.0;

  Widget _buildWeekSelector(bool isNarrowScreen) {
    final dateFormattingLocale = intlDateFormattingLocale(Localizations.localeOf(context));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentWeekMonday = now.subtract(Duration(days: now.weekday - 1));

    final weeks = <List<DateTime>>[];
    for (var w = -_weeksBefore; w <= _weeksAfter; w++) {
      final monday = currentWeekMonday.add(Duration(days: w * 7));
      weeks.add(List.generate(7, (i) => monday.add(Duration(days: i))));
    }

    final weekWidth = _blockWidth * 7 + _blockGap * 6;
    final initialScrollOffset = _weeksBefore * (weekWidth + _blockGap);

    if (!_weekScrollInitialized) {
      _weekScrollInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _weekScrollController.hasClients) {
          _weekScrollController.jumpTo(initialScrollOffset);
        }
      });
    }

    return Container(
      height: _blockHeight + (isNarrowScreen ? 20 : 24),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: SingleChildScrollView(
        controller: _weekScrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: isNarrowScreen ? 12 : 16,
          vertical: isNarrowScreen ? 10 : 12,
        ),
        child: Row(
          children: [
            for (var i = 0; i < weeks.length; i++) ...[
              if (i > 0) SizedBox(width: _blockGap),
              SizedBox(
                width: weekWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: weeks[i].map((day) {
                  final dateOnly = DateTime(day.year, day.month, day.day);
                  final isToday = dateOnly == today;
                  final isSelected = isSameDay(_selectedDay, day);
                  final eventColors = _getEventColorsForDay(day);

                  return SizedBox(
                    width: _blockWidth,
                    height: _blockHeight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedDay = day);
                        _showDayDetails(day);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : isToday
                                  ? Theme.of(context).colorScheme.primary.withOpacity(0.25)
                                  : Theme.of(context).colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected || isToday
                              ? [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE', dateFormattingLocale).format(day),
                              style: TextStyle(
                                fontSize: isNarrowScreen ? 10 : 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : isToday
                                        ? Theme.of(context).colorScheme.onSurface
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: isNarrowScreen ? 4 : 6),
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: isNarrowScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : isToday
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            if (eventColors.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: eventColors.map((color) {
                                    return Container(
                                      width: 5,
                                      height: 5,
                                      margin: const EdgeInsets.symmetric(horizontal: 1),
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Color> _getEventColorsForDay(DateTime day) {
    final colors = <Color>[];
    for (final r in widget.dataService.getLensReplacements()) {
      if (isSameDay(r.date, day)) {
        colors.add(_colorReplacement);
        break;
      }
    }
    final symptoms = widget.dataService.getSymptomsForDate(day);
    if (symptoms != null) {
      if (symptoms.isManualRemoval && symptoms.symptoms.isEmpty) {
        colors.add(_colorRemoval);
      } else if (symptoms.symptoms.isNotEmpty) {
        colors.add(_colorSymptom);
      }
    }
    for (final v in widget.dataService.getVisionChecks()) {
      if (isSameDay(v.date, day)) {
        colors.add(_colorRemoval);
        break;
      }
    }
    var hasStockUpdate = false;
    var hasLowStockUpdate = false;
    for (final s in widget.dataService.getStockUpdates()) {
      if (!isSameDay(s.date, day)) continue;
      hasStockUpdate = true;
      if (s.pairsCount < _stockAlertThreshold) {
        hasLowStockUpdate = true;
      }
    }
    if (hasStockUpdate) {
      colors.add(hasLowStockUpdate ? _colorStockLow : _colorStockAttention);
    }
    return colors;
  }

  void _showDayDetails(DateTime day) {
    final dayOnly = DateTime(day.year, day.month, day.day);
    final dateFormattingLocale = intlDateFormattingLocale(Localizations.localeOf(context));
    final l10n = context.l10n;
    final result = _calendarAggregator.build(
      rawData: CalendarRawData(
        cycles: widget.dataService.getAllCycles(),
        replacements: widget.dataService.getLensReplacements(),
        symptoms: widget.dataService.getSymptomEntries(),
        visionChecks: widget.dataService.getVisionChecks(),
        stockUpdates: widget.dataService.getStockUpdates(),
        stockAlertThreshold: _stockAlertThreshold,
      ),
      selectedYear: dayOnly.year,
      selectedDay: dayOnly,
      today: DateTime.now(),
      dateFormattingLocale: dateFormattingLocale,
      l10n: l10n,
      monthsBefore: 0,
      monthsAfter: 0,
    );
    final info = result.daysIndex[dayOnly];
    final details = _dayDetailsBuilder.build(
      day: dayOnly,
      info: info,
      dateFormattingLocale: dateFormattingLocale,
      l10n: l10n,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      isScrollControlled: true,
      builder: (context) => DayDetailsSheet(data: details),
    );
  }

  // =======================================================================
  // СТАТИСТИКА (НОШУ + ЗАПАС)
  // =======================================================================

  Widget _buildStatsGrid(int daysWorn, int stock, bool isNarrowScreen) {
    // ?? НИЗКИЙ ЗАПАС [file:15] 2.3
    final isLowStock = stock < _stockAlertThreshold;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.visibility_outlined,
            label: context.l10n.homeWearing,
            value: '$daysWorn ${context.l10n.dayWord(daysWorn)}',
            color: Theme.of(context).colorScheme.primary,
            isNarrowScreen: isNarrowScreen,
          ),
        ),
        SizedBox(width: isNarrowScreen ? 12 : 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.inventory_2_outlined,
            label: context.l10n.homeStock,
            value: '$stock ${context.l10n.pairWord(stock)}',
            color: isLowStock
                ? context.actionPalette.overdue
                : context.actionPalette.attention,
            isNarrowScreen: isNarrowScreen,
            onTap: _showStockUpdateDialog,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isNarrowScreen,
    VoidCallback? onTap,
  }) {
    final card = Container(
      padding: EdgeInsets.all(isNarrowScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: isNarrowScreen ? 32 : 36,
            color: color,
          ),
          SizedBox(height: isNarrowScreen ? 8 : 12),
          Text(
            label,
            style: TextStyle(
              fontSize: isNarrowScreen ? 11 : 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: isNarrowScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: card,
      ),
    );
  }

  Future<void> _showStockUpdateDialog() async {
    final controller = TextEditingController();
    final currentStock = widget.dataService.getCurrentStock();
    final l10n = context.l10n;
    String? inputError;

    int? result;
    try {
      result = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (dialogContext, setDialogState) {
              void submit() {
                final raw = controller.text.trim();
                final delta = int.tryParse(raw);
                if (delta == null || delta <= 0) {
                  setDialogState(() => inputError = l10n.homeEnterPositiveNumber);
                  return;
                }
                Navigator.pop(dialogContext, delta);
              }

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(l10n.homeUpdateStock),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: controller,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) {
                          if (inputError != null) {
                            setDialogState(() => inputError = null);
                          }
                        },
                        onSubmitted: (_) => submit(),
                        decoration: InputDecoration(
                          labelText: l10n.homeHowManyPairsToAdd,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      if (inputError != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          inputError!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(dialogContext).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        l10n.homeCurrentStock(currentStock),
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(dialogContext).colorScheme.primary,
                      shape: const StadiumBorder(),
                      alignment: Alignment.center,
                    ),
                    child: Text(l10n.cancel),
                  ),
                  PrimaryGradientButton(
                    onPressed: submit,
                    child: Text(l10n.save),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      controller.dispose();
    }

    if (!mounted) return;

    if (result != null && result > 0) {
      final updated = currentStock + result;
      await widget.dataService.saveStockUpdate(
        StockUpdate(
          date: DateTime.now(),
          pairsCount: updated,
        ),
      );
      loadData();
      widget.onDataChanged?.call();
      HomeWidgetService.updateLensWidget(widget.dataService);
    } else if (result != null && result <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.homeEnterPositiveNumber),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  // =======================================================================
  // ?? ПРОГРЕСС (ДО ЗАМЕНЫ ЛИНЗ) - НОВЫЙ ДИЗАЙН
  // =======================================================================

  Widget _buildProgressCard(
    int daysWorn,
    int totalDays,
    int daysRemaining,
    bool hasActiveCycle,
    bool isNarrowScreen,
  ) {
    if (!hasActiveCycle) {
      return _buildEmptyProgressCard(isNarrowScreen);
    }

    // ?? Адаптивный прогресс [file:15] 6.4
    if (_lensInfo.type == LensType.daily) {
      return _buildDailyLensProgress(isNarrowScreen);
    } else if (totalDays <= 30) {
      return _buildCircleProgress(daysWorn, totalDays, daysRemaining, isNarrowScreen);
    } else {
      return _buildLinearProgress(daysWorn, totalDays, daysRemaining, isNarrowScreen);
    }
  }

  /// Блок «До замены линз» когда нет активного цикла
  Widget _buildEmptyProgressCard(bool isNarrowScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrowScreen ? 24 : 32,
        vertical: isNarrowScreen ? 28 : 36,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.homeNoCyclePlaceholder,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isNarrowScreen ? 14 : 15,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          SizedBox(height: isNarrowScreen ? 24 : 28),
          SizedBox(
            width: double.infinity,
            child: PrimaryGradientButton(
              onPressed: widget.onPutOnLenses,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                context.l10n.homePutOnNewPair,
                style: TextStyle(
                  fontSize: isNarrowScreen ? 15 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Блок «До замены линз» с активным циклом — единый лаконичный дизайн
  Widget _buildActiveProgressCard(
    String valueText,
    bool isOverdue,
    bool isNarrowScreen,
  ) {
    final title = isOverdue ? context.l10n.homeOverdueBy : context.l10n.homeUntilReplacement;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrowScreen ? 24 : 32,
        vertical: isNarrowScreen ? 28 : 36,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isNarrowScreen ? 15 : 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: isNarrowScreen ? 12 : 16),
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                valueText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isNarrowScreen ? 32 : 36,
                  fontWeight: FontWeight.bold,
                  color: isOverdue ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SizedBox(height: isNarrowScreen ? 24 : 28),
          SizedBox(
            width: double.infinity,
            child: PrimaryGradientButton(
              onPressed: _completeCycle,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                context.l10n.homeCompleteWearing,
                style: TextStyle(
                  fontSize: isNarrowScreen ? 15 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyLensProgress(bool isNarrowScreen) {
    if (_cycleStartDate == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final hoursPassed = now.difference(_cycleStartDate!).inHours;
    const maxHours = 14;
    final hoursRemaining = (maxHours - hoursPassed).clamp(0, maxHours);
    final isOverdue = hoursPassed >= maxHours;
    final valueText = isOverdue
        ? '${hoursPassed - maxHours} ${context.l10n.hourWord(hoursPassed - maxHours)}'
        : '$hoursRemaining ${context.l10n.hourWord(hoursRemaining)}';

    return _buildActiveProgressCard(valueText, isOverdue, isNarrowScreen);
  }

  Widget _buildCircleProgress(
    int daysWorn,
    int totalDays,
    int daysRemaining,
    bool isNarrowScreen,
  ) {
    final isOverdue = daysWorn > totalDays;
    final valueText = isOverdue
        ? '${daysWorn - totalDays} ${context.l10n.dayWord(daysWorn - totalDays)}'
        : '$daysRemaining ${context.l10n.dayWord(daysRemaining)}';

    return _buildActiveProgressCard(valueText, isOverdue, isNarrowScreen);
  }

  Widget _buildLinearProgress(
    int daysWorn,
    int totalDays,
    int daysRemaining,
    bool isNarrowScreen,
  ) {
    final isOverdue = daysWorn > totalDays;
    final valueText = isOverdue
        ? '${daysWorn - totalDays} ${context.l10n.dayWord(daysWorn - totalDays)}'
        : '$daysRemaining ${context.l10n.dayWord(daysRemaining)}';

    return _buildActiveProgressCard(valueText, isOverdue, isNarrowScreen);
  }

  // =======================================================================
  // ЗАВЕРШЕНИЕ ЦИКЛА
  // =======================================================================

  void _completeCycle() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.l10n.homeCompleteWearingQuestion,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: Text(
          context.l10n.homeCompleteWearingConfirm,
          style: TextStyle(fontSize: 15),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.cancel),
          ),
          PrimaryGradientButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.homeCompleteWearing),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.dataService.completeCycleManually();
        loadData();
        widget.onDataChanged?.call();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.homeWearingCompleted),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: const StadiumBorder(),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${context.l10n.error}: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  // =======================================================================
  // СОВЕТЫ
  // =======================================================================

  Widget _buildTipsCard(bool isNarrowScreen) {
    final tip = LensTipsManager.getTipForToday(_lensInfo.type);
    final icon = tip['icon'] as IconData;
    final text = tip['text'] as String;
    final color = tip['color'] as Color? ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      padding: EdgeInsets.all(isNarrowScreen ? 20 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.12),
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: isNarrowScreen ? 24 : 28,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: isNarrowScreen ? 8 : 12),
              Text(
                context.l10n.homeTipsTitle,
                style: TextStyle(
                  fontSize: isNarrowScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: isNarrowScreen ? 16 : 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: isNarrowScreen ? 20 : 22,
                color: color,
              ),
              SizedBox(width: isNarrowScreen ? 8 : 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 12 : 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




