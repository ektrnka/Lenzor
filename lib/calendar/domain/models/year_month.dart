class YearMonth {
  const YearMonth(this.year, this.month);

  final int year;
  final int month;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YearMonth && other.year == year && other.month == month;
  }

  @override
  int get hashCode => Object.hash(year, month);
}

