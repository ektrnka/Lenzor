DateTime dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);

bool isSameDate(DateTime a, DateTime b) => dateOnly(a) == dateOnly(b);

