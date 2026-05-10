// ignore_for_file: public_member_api_docs, document_ignores, lines_longer_than_80_chars

extension NumTimeExtension<T extends num> on T {
  /// Returns a Duration represented in weeks
  Duration get weeks => days * DurationTimeExtension.daysPerWeek;

  /// Returns a Duration represented in days
  Duration get days => milliseconds * Duration.millisecondsPerDay;

  /// Returns a Duration represented in hours
  Duration get hours => milliseconds * Duration.millisecondsPerHour;

  /// Returns a Duration represented in minutes
  Duration get minutes => milliseconds * Duration.millisecondsPerMinute;

  /// Returns a Duration represented in seconds
  Duration get seconds => milliseconds * Duration.millisecondsPerSecond;

  /// Returns a Duration represented in milliseconds
  Duration get milliseconds => Duration(
        microseconds: (this * Duration.microsecondsPerMillisecond).toInt(),
      );

  /// Returns a Duration represented in microseconds.
  ///
  /// Since [Duration] stores values with microsecond precision, any fractional
  /// microseconds are truncated toward zero.
  Duration get microseconds => milliseconds ~/ Duration.microsecondsPerMillisecond;

  /// Returns a Duration represented in nanoseconds.
  ///
  /// Since [Duration] stores values with microsecond precision, this value is
  /// truncated toward zero to whole microseconds. Values with an absolute value
  /// smaller than 1000 nanoseconds therefore become [Duration.zero].
  Duration get nanoseconds => microseconds ~/ DurationTimeExtension.nanosecondsPerMicrosecond;
}

extension DateTimeTimeExtension on DateTime {
  /// Adds this DateTime and Duration and returns the sum as a new DateTime object.
  DateTime operator +(Duration duration) => add(duration);

  /// Subtracts the Duration from this DateTime returns the difference as a new DateTime object.
  DateTime operator -(Duration duration) => subtract(duration);

  /// Returns only year, month and day
  DateTime get date => isUtc ? DateTime.utc(year, month, day) : DateTime(year, month, day);

  /// Returns only the time
  Duration get timeOfDay =>
      hour.hours +
      minute.minutes +
      second.seconds +
      millisecond.milliseconds +
      microsecond.microseconds;

  /// Returns if today, true
  bool get isToday {
    return _calculateDifference(this) == 0;
  }

  /// Returns if tomorrow, true
  bool get isTomorrow {
    return _calculateDifference(this) == 1;
  }

  /// Returns if yesterday, true
  bool get wasYesterday {
    return _calculateDifference(this) == -1;
  }

  /// Returns true if this year is a leap year.
  bool get isLeapYear => year >= 1582 && year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

  /// Returns the amount of days that are in this month.
  int get daysInMonth {
    final days = [
      31,
      if (isLeapYear) 29 else 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];

    return days[month - 1];
  }

  /// Returns true if [other] is in the same year as this DateTime.
  bool isAtSameYearAs(DateTime other) => year == other.year;

  /// Returns true if [other] is in the same month as this DateTime.
  bool isAtSameMonthAs(DateTime other) => isAtSameYearAs(other) && month == other.month;

  /// Returns true if [other] is on the same day as this DateTime.
  bool isAtSameDayAs(DateTime other) => isAtSameMonthAs(other) && day == other.day;

  /// Returns true if [other] is at the same hour as this DateTime.
  bool isAtSameHourAs(DateTime other) => isAtSameDayAs(other) && hour == other.hour;

  /// Returns true if [other] is at the same minute as this DateTime.
  bool isAtSameMinuteAs(DateTime other) => isAtSameHourAs(other) && minute == other.minute;

  /// Returns true if [other] is at the same second as this DateTime.
  bool isAtSameSecondAs(DateTime other) => isAtSameMinuteAs(other) && second == other.second;

  /// Returns true if [other] is at the same millisecond as this DateTime.
  bool isAtSameMillisecondAs(DateTime other) =>
      isAtSameSecondAs(other) && millisecond == other.millisecond;

  /// Returns true if [other] is at the same microsecond as this DateTime.
  bool isAtSameMicrosecondAs(DateTime other) =>
      isAtSameMillisecondAs(other) && microsecond == other.microsecond;

  static int _calculateDifference(DateTime date) {
    final localDate = date.toLocal();
    final localNow = DateTime.now().toLocal();
    return DateTime(localDate.year, localDate.month, localDate.day)
        .difference(DateTime(localNow.year, localNow.month, localNow.day))
        .inDays;
  }

  /// Returns a range of dates to [to], exclusive start, inclusive end
  Iterable<DateTime> to(
    DateTime to, {
    Duration by = const Duration(days: 1),
  }) sync* {
    if (by <= Duration.zero) {
      throw ArgumentError.value(by, 'by', 'Step size must be positive.');
    }

    if (isAtSameMomentAs(to)) return;

    if (isBefore(to)) {
      var count = 1;
      while (true) {
        final value = this + (by * count);
        if (value.isAfter(to)) break;
        yield value;
        count++;
      }
    } else {
      var count = 1;
      while (true) {
        final value = this - (by * count);
        if (value.isBefore(to)) break;
        yield value;
        count++;
      }
    }
  }

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return isUtc
        ? DateTime.utc(
            year ?? this.year,
            month ?? this.month,
            day ?? this.day,
            hour ?? this.hour,
            minute ?? this.minute,
            second ?? this.second,
            millisecond ?? this.millisecond,
            microsecond ?? this.microsecond,
          )
        : DateTime(
            year ?? this.year,
            month ?? this.month,
            day ?? this.day,
            hour ?? this.hour,
            minute ?? this.minute,
            second ?? this.second,
            millisecond ?? this.millisecond,
            microsecond ?? this.microsecond,
          );
  }

  /// Returns the Monday of this week
  DateTime get firstDayOfWeek => isUtc
      ? DateTime.utc(year, month, day + 1 - weekday)
      : DateTime(year, month, day + 1 - weekday);

  /// Returns the Sunday of this week
  DateTime get lastDayOfWeek => isUtc
      ? DateTime.utc(year, month, day + 7 - weekday)
      : DateTime(year, month, day + 7 - weekday);

  /// Returns the first day of this month
  DateTime get firstDayOfMonth => isUtc ? DateTime.utc(year, month) : DateTime(year, month);

  /// Returns the last day of this month (considers leap years)
  DateTime get lastDayOfMonth =>
      isUtc ? DateTime.utc(year, month + 1, 0) : DateTime(year, month + 1, 0);

  /// Returns the first day of this year
  DateTime get firstDayOfYear => isUtc ? DateTime.utc(year) : DateTime(year);

  /// Returns the last day of this year
  DateTime get lastDayOfYear => isUtc ? DateTime.utc(year, 12, 31) : DateTime(year, 12, 31);

  /// Returns this [DateTime] clamped to be in the range [min]-[max].
  DateTime clamp({DateTime? min, DateTime? max}) {
    assert(
      !((min != null) && (max != null)) || (min.isBefore(max) || (min == max)),
      'DateTime min has to be before or equal to max\n(min: $min - max: $max)',
    );
    if ((min != null) && compareTo(min).isNegative) {
      return min;
    } else if ((max != null) && max.compareTo(this).isNegative) {
      return max;
    }
    return this;
  }

  /// Adds time units to the calendar date and/or clock time.
  DateTime shift({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) {
    final totalMonths = (year + years) * 12 + month + months - 1;
    final targetYear = totalMonths ~/ 12;
    final targetMonth = (totalMonths % 12) + 1;
    final lastDay = _daysInMonth(targetYear, targetMonth);
    final clampedDay = day <= lastDay ? day : lastDay;

    return copyWith(
      year: targetYear,
      month: targetMonth,
      day: clampedDay + days,
      hour: hour + hours,
      minute: minute + minutes,
      second: second + seconds,
      millisecond: millisecond + milliseconds,
      microsecond: microsecond + microseconds,
    );
  }

  static int _daysInMonth(int year, int month) => DateTime.utc(year, month + 1, 0).day;

  bool get isWeekend => (weekday == DateTime.saturday) || (weekday == DateTime.sunday);

  bool get isWorkday => !isWeekend;

  /// Returns the last microsecond of the day (23:59:59.999999)
  DateTime get endOfDay {
    const microsecond = Duration(microseconds: 1);
    if (isUtc) return DateTime.utc(year, month, day + 1) - microsecond;
    return DateTime(year, month, day + 1) - microsecond;
  }
}

extension DurationTimeExtension on Duration {
  static const int daysPerWeek = 7;
  static const int nanosecondsPerMicrosecond = 1000;

  /// Returns the representation in weeks
  int get inWeeks => inDays ~/ daysPerWeek;

  /// Adds the Duration to the current DateTime and returns a DateTime in the future
  DateTime get fromNow => DateTime.now() + this;

  /// Subtracts the Duration from the current DateTime and returns a DateTime in the past
  DateTime get ago => DateTime.now() - this;

  /// Returns a Future.delayed from this
  Future<void> get delay => Future.delayed(this);

  /// Returns this [Duration] clamped to be in the range [min]-[max].
  Duration clamp({Duration? min, Duration? max}) {
    assert(
      !((min != null) && (max != null)) || min.compareTo(max) <= 0,
      'Duration min has to be shorter than max\n(min: $min - max: $max)',
    );
    if ((min != null) && compareTo(min).isNegative) {
      return min;
    } else if ((max != null) && max.compareTo(this).isNegative) {
      return max;
    }
    return this;
  }
}
