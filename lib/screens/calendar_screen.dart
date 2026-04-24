import 'package:flutter/material.dart';

import '../calendar/data/calendar_repository_impl.dart';
import '../calendar/presentation/state/calendar_controller.dart';
import '../calendar/presentation/widgets/calendar_view.dart';
import '../l10n/l10n_extensions.dart';
import '../services/lens_data_service.dart';
import '../utils/intl_locale.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    required this.dataService,
    this.onDataChanged,
  });

  final LensDataService dataService;
  final VoidCallback? onDataChanged;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(
      repository: CalendarRepositoryImpl(widget.dataService),
    )..load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.updateLocalization(
      dateFormattingLocale: intlDateFormattingLocale(Localizations.localeOf(context)),
      l10n: context.l10n,
    );
  }

  @override
  void didUpdateWidget(covariant CalendarScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataService != widget.dataService) {
      _controller.dispose();
      _controller = CalendarController(
        repository: CalendarRepositoryImpl(widget.dataService),
      )..load();
      _controller.updateLocalization(
        dateFormattingLocale: intlDateFormattingLocale(Localizations.localeOf(context)),
        l10n: context.l10n,
      );
      return;
    }
    _controller.refresh();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        colorScheme.primary,
        colorScheme.primaryContainer,
      ],
    );
    final headerForeground = isDark
        ? const Color(0xFF052B44)
        : colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: headerForeground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.l10n.calendarTitle,
          style: TextStyle(
            color: headerForeground,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: headerGradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CalendarView(
            state: _controller.state,
            onYearSelected: _controller.changeYear,
            onDaySelected: _controller.selectDay,
            onRequestDayDetails: _controller.getDayDetails,
          );
        },
      ),
    );
  }
}





