// screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../l10n/app_localizations.dart';
import '../l10n/domain_localization_extensions.dart';
import '../l10n/l10n_extensions.dart';
import '../services/lens_data_service.dart';
import '../models/lens_data.dart';
import '../utils/intl_locale.dart';

/// ?? ЭКРАН ИСТОРИИ [file:15] 7
/// 
/// Отображает историю всех циклов ношения линз с фильтрацией по годам
/// и адаптивным прогресс-баром для каждого типа линз
class HistoryScreen extends StatefulWidget {
  final LensDataService dataService;

  const HistoryScreen({Key? key, required this.dataService}) : super(key: key);

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  String _selectedYear = 'all';
  List<LensCycle> _allCycles = [];
  List<LensCycle> _filteredCycles = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadCycles();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// ?? АВТООБНОВЛЕНИЕ [file:15] 7.1
  /// 
  /// Обновляем UI каждую минуту ТОЛЬКО для активных однодневных линз
  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        final activeCycle = widget.dataService.getActiveCycle();
        if (activeCycle != null && activeCycle.lensType == LensType.daily) {
          setState(() {
            // Обновляем UI для пересчёта hourов
          });
        }
      }
    });
  }

  /// Метод для обновления данных извне (через GlobalKey)
  void refreshData() {
    setState(() {
      _loadCycles();
    });
  }

  /// ?? ЗАГРУЗКА И ФИЛЬТРАЦИЯ [file:15] 7.1
  /// 
  /// Data: dataService.getAllCycles()
  /// Фильтр: по году (из endDate цикла; для активных — текущий год)
  void _loadCycles() {
    // Получаем все циклы из dataService
    _allCycles = widget.dataService.getAllCycles();

    // Фильтрация по году: цикл показываем, если пересекается с выбранным годом
    if (_selectedYear == 'all') {
      _filteredCycles = _allCycles;
    } else {
      final year = int.parse(_selectedYear);
      final now = DateTime.now();
      _filteredCycles = _allCycles.where((cycle) {
        final startYear = cycle.startDate.year;
        final endYear = cycle.endDate?.year ?? now.year;
        return year >= startYear && year <= endYear;
      }).toList();
    }

    debugPrint(
        '?? History loaded: ${_allCycles.length} total, ${_filteredCycles.length} filtered');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildYearFilter(),
            Expanded(
              child: _filteredCycles.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 16,
                        bottom: 100,
                      ),
                      itemCount: _filteredCycles.length,
                      itemBuilder: (context, index) {
                        final cycle = _filteredCycles[index];
                        return _buildCycleCard(cycle);
                      },
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

  Widget _buildHeader() {
    final isNarrowScreen = MediaQuery.of(context).size.width < 360;
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
                  context.l10n.historyTitle,
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
                  context.l10n.historySubtitle,
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
        ],
      ),
    );
  }

  // =======================================================================
  // ФИЛЬТР ПО ГОДАМ [file:15] 7.1
  // =======================================================================

  /// ?? ФИЛЬТР ПО ГОДАМ
  /// 
  /// Опции: "All time" + годы из циклов (startDate и endDate), скролл влево/вправо
  Widget _buildYearFilter() {
    final now = DateTime.now();
    final Set<int> years = {};
    for (final cycle in _allCycles) {
      years.add(cycle.startDate.year);
      years.add(cycle.endDate?.year ?? now.year);
    }
    years.add(now.year);
    final yearList = years.toList()..sort((a, b) => b.compareTo(a));
    final List<String> yearOptions = ['all'];
    yearOptions.addAll(yearList.map((y) => y.toString()));

    final labels = <String, String>{'all': context.l10n.historyAllTime};
    for (final year in yearList) {
      labels[year.toString()] = year.toString();
    }

    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width < 360 ? 16 : 24,
        vertical: 12,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: yearOptions.map((year) {
            final isSelected = _selectedYear == year;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedYear = year;
                      _loadCycles();
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      labels[year]!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // =======================================================================
  // ПУСТОЕ СОСТОЯНИЕ
  // =======================================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.bar_chart_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.historyEmptyTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.historyEmptyDescription,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // =======================================================================
  // КАРТОЧКА ЦИКЛА [file:15] 7.2
  // =======================================================================

  /// ?? КАРТОЧКА ЦИКЛА [file:15] 7.2
  /// 
  /// Содержит:
  /// - Lens type + бейдж "Активно" (если isActive)
  /// - Диапазон дат: "start - сегоdays" или "start - end"
  /// - Способ завершения: "Завершено ручным снятием" / "Завершено заменой"
  /// - Статус с цветом [file:15] 1.8
  /// - Прогресс (адаптивный, аналогично HomeScreen)
  Widget _buildCycleCard(LensCycle cycle) {
    final l10n = context.l10n;
    final dateFormattingLocale = intlDateFormattingLocale(Localizations.localeOf(context));
    final todayLabel = l10n.historyToday;
    final isActive = cycle.isActive;
    final totalDays = cycle.lensType.days;
    
    // Единый сценарий расчёта days через модель LensCycle (как на главном экране)
    final daysWorn = cycle.daysWorn;
    
    final isOverdue = daysWorn > totalDays;
    
    // ?? ПОРОГ «СКОРО ЗАМЕНА» [file:15] 1.1, 1.8
    // ?2 days для daily/weekly/biweekly/monthly
    // ?7 days для quarterly/halfYearly
    final nearEndThreshold = (totalDays > 30) ? 7 : 2;
    final isNearEnd = daysWorn >= totalDays - nearEndThreshold && daysWorn <= totalDays;

    // ?? СТАТУСЫ И ЦВЕТА [file:15] 1.8
    String status;
    Color statusColor;

    if (isActive) {
      if (isOverdue) {
        status = '${l10n.historyLegendOverdue} ${daysWorn - totalDays} ${l10n.dayWord(daysWorn - totalDays)}';
        statusColor = Theme.of(context).colorScheme.error;
      } else if (isNearEnd) {
        status = l10n.historyLegendSoon;
        statusColor = Theme.of(context).colorScheme.tertiaryContainer;
      } else {
        status = l10n.historyLegendActive;
        statusColor = Theme.of(context).colorScheme.primary;
      }
    } else {
      if (isOverdue) {
        status = l10n.historyLegendOverdue;
        statusColor = Theme.of(context).colorScheme.error; // Красный
      } else {
        status = l10n.historyLegendCompleted;
        statusColor = Theme.of(context).colorScheme.primaryContainer;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок: тип линз (слева) | лейбл статуса (справа)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cycle.lensType.localizedLabel(l10n),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Даты (слева) | количество days (справа) — для дневных/квартальных/полугодовых время/дни не дублируем над ползунком
          if (totalDays <= 30)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isActive
                            ? '${DateFormat('d MMM yyyy', dateFormattingLocale).format(cycle.startDate)} - $todayLabel'
                            : '${DateFormat('d MMM yyyy', dateFormattingLocale).format(cycle.startDate)} - ${DateFormat('d MMM yyyy', dateFormattingLocale).format(cycle.endDate!)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (!isActive) ...[
                        const SizedBox(height: 4),
                        Text(
                          cycle.completedManually
                              ? l10n.historyCompletedByRemoval
                              : l10n.historyCompletedByReplacement,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Для дневных не показываем "10 ч" — уже есть в "Использовано X из 14 hourов"
                if (totalDays != 1)
                  Text(
                    '$daysWorn ${l10n.dayWord(daysWorn)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
              ],
            )
          else
            // Для квартальных/полугодовых: только примечание, дни — в "Использовано X из Y days" над ползунком
            !isActive
                ? Text(
                    cycle.completedManually
                        ? l10n.historyCompletedByRemoval
                        : l10n.historyCompletedByReplacement,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                : const SizedBox.shrink(),
          const SizedBox(height: 16),

          // ?? АДАПТИВНЫЙ ПРОГРЕСС [file:15] 7.2
          // daily (days=1): hourы, прогресс-бар, 14ч макс
          // 7-30 days: кружочки (dots)
          // >30 days: линейный прогресс-бар
          if (totalDays == 1)
            _buildHourlyProgress(cycle, isActive, l10n)
          else if (totalDays <= 30)
            _buildDailyProgress(daysWorn, totalDays, isActive, nearEndThreshold, l10n)
          else
            _buildLongProgress(daysWorn, totalDays, isActive, nearEndThreshold, l10n),
        ],
      ),
    );
  }

  // =======================================================================
  // ПРОГРЕСС-БАРЫ [file:15] 6.4
  // =======================================================================

  /// ?? ПРОГРЕСС ДЛЯ ОДНОДНЕВНЫХ ЛИНЗ (14 ЧАСОВ) [file:15] 6.4
  Widget _buildHourlyProgress(LensCycle cycle, bool isActive, AppLocalizations l10n) {
    const minHours = 8;
    const maxHours = 14;
    int hoursWorn;

    if (isActive) {
      // Для активного цикла считаем hourы от startDate до текущего времени
      final timeSince = DateTime.now().difference(cycle.startDate);
      hoursWorn = timeSince.inHours;
    } else {
      // Для завершенного цикла используем разницу между endDate и startDate
      if (cycle.endDate != null) {
        final duration = cycle.endDate!.difference(cycle.startDate);
        hoursWorn = duration.inHours;
      } else {
        hoursWorn = 0;
      }
    }

    Color progressColor = hoursWorn > maxHours
        ? Theme.of(context).colorScheme.error
        : (hoursWorn >= 12
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isActive
              ? l10n.historyPassedOfHours(hoursWorn, maxHours)
              : l10n.historyUsedOfHours(hoursWorn, maxHours),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (hoursWorn / maxHours).clamp(0.0, 1.0),
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.historyRecommendedHours(minHours, maxHours),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// ?? ПРОГРЕСС ДЛЯ ЛИНЗ 7-30 ДНЕЙ (КРУЖОЧКИ) [file:15] 6.4
  Widget _buildDailyProgress(
    int daysWorn,
    int totalDays,
    bool isActive,
    int nearEndThreshold,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isActive
              ? l10n.historyPassedOfDays(daysWorn, totalDays)
              : l10n.historyUsedOfDays(daysWorn, totalDays),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            return _buildProgressDots(
              daysWorn,
              totalDays,
              isActive,
              nearEndThreshold,
              maxWidth: constraints.maxWidth,
            );
          },
        ),
      ],
    );
  }

  /// ?? КРУЖОЧКИ ПРОГРЕССА [file:15] 6.4
  /// Кружки в одну строку на всю ширину: варьируем расстояние, в меньшей степени размер
  Widget _buildProgressDots(
    int daysWorn,
    int totalDays,
    bool isActive,
    int nearEndThreshold, {
    double? maxWidth,
  }) {
    const minGap = 2.0;
    const minDotSize = 2.0;
    const maxDotSize = 11.0;
    const preferredDotSize = 10.0;

    final effectiveMaxWidth = maxWidth ?? double.infinity;
    if (totalDays <= 1) {
      return Row(
        children: [
          Container(
            width: preferredDotSize,
            height: preferredDotSize,
            decoration: BoxDecoration(
              color: daysWorn >= 1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
    }

    // Формула: totalDays*dotSize + (totalDays-1)*gap = effectiveMaxWidth
    var dotSize = (effectiveMaxWidth - (totalDays - 1) * minGap) / totalDays;
    dotSize = dotSize.clamp(minDotSize, maxDotSize);
    var gap = (effectiveMaxWidth - totalDays * dotSize) / (totalDays - 1);
    gap = gap.clamp(minGap, 24.0);
    // Если не влезает — уменьшаем dotSize (для 30 days на узком экране)
    final totalNeeded = totalDays * dotSize + (totalDays - 1) * gap;
    if (totalNeeded > effectiveMaxWidth && totalDays > 1) {
      dotSize = (effectiveMaxWidth - (totalDays - 1) * minGap) / totalDays;
      dotSize = dotSize.clamp(1.0, maxDotSize);
      gap = minGap;
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(totalDays, (index) {
        final dayNumber = index + 1;
        final isDone = dayNumber <= daysWorn;
        final isNearEnd = dayNumber >= totalDays - nearEndThreshold && dayNumber <= totalDays && isDone;

        Color dotColor;
        if (daysWorn > totalDays && isDone) {
          dotColor = Theme.of(context).colorScheme.error;
        } else if (isActive && isNearEnd) {
          dotColor = Theme.of(context).colorScheme.tertiaryContainer;
        } else if (isDone) {
          dotColor = Theme.of(context).colorScheme.primary;
        } else {
          dotColor = Theme.of(context).colorScheme.secondaryContainer;
        }

        return Padding(
          padding: EdgeInsets.only(right: index < totalDays - 1 ? gap : 0),
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  /// ?? ПРОГРЕСС ДЛЯ ДЛИННЫХ ЦИКЛОВ (ЛИНЕЙНЫЙ БАР) [file:15] 6.4
  Widget _buildLongProgress(
    int daysWorn,
    int totalDays,
    bool isActive,
    int nearEndThreshold,
    AppLocalizations l10n,
  ) {
    final isOverdue = daysWorn > totalDays;
    final isNearEnd = daysWorn >= totalDays - nearEndThreshold && daysWorn <= totalDays;

    Color progressColor;
    if (isOverdue) {
      progressColor = Theme.of(context).colorScheme.error;
    } else if (isActive && isNearEnd) {
      progressColor = Theme.of(context).colorScheme.tertiaryContainer;
    } else {
      progressColor = Theme.of(context).colorScheme.primary;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Не дублируем дни справа — уже в "Использовано X из Y days"
        Text(
          isActive
              ? l10n.historyPassedOfDays(daysWorn, totalDays)
              : l10n.historyUsedOfDays(daysWorn, totalDays),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (daysWorn / totalDays).clamp(0.0, 1.0),
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =======================================================================
  // ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
  // =======================================================================

  /// Часы для однодневных линз
  int _getHoursWorn(LensCycle cycle) {
    if (cycle.isActive) {
      return DateTime.now().difference(cycle.startDate).inHours;
    }
    if (cycle.endDate != null) {
      return cycle.endDate!.difference(cycle.startDate).inHours;
    }
    return 0;
  }
}




