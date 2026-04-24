import 'package:flutter/material.dart';

import '../../../l10n/l10n_extensions.dart';

class YearSelector extends StatelessWidget {
  const YearSelector({
    super.key,
    required this.availableYears,
    required this.selectedYear,
    required this.onYearSelected,
    this.showAllOption = true,
  });

  final List<int> availableYears;
  final int? selectedYear;
  final ValueChanged<int?> onYearSelected;
  final bool showAllOption;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            if (showAllOption)
              _YearChip(
                label: context.l10n.calendarAllYears,
                isSelected: selectedYear == null,
                onTap: () => onYearSelected(null),
              ),
            ...availableYears.map(
              (year) => _YearChip(
                label: '$year',
                isSelected: selectedYear == year,
                onTap: () => onYearSelected(year),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearChip extends StatelessWidget {
  const _YearChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

