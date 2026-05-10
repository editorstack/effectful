import 'package:effectful_utils/effectful_utils.dart';
import 'package:test/test.dart';

class WeirdComparable implements Comparable<WeirdComparable> {
  const WeirdComparable(this.value);

  final int value;

  @override
  int compareTo(WeirdComparable other) {
    if (value == other.value) return 0;
    return value < other.value ? -2 : 2;
  }
}

void main() {
  group('list extensions', () {
    test('drop returns a copy when n is zero', () {
      final source = [1, 2, 3];
      final result = source.drop(0);

      expect(result, equals(source));
      expect(identical(result, source), isFalse);
    });

    test('dropLast returns a copy when n is zero', () {
      final source = [1, 2, 3];
      final result = source.dropLast(0);

      expect(result, equals(source));
      expect(identical(result, source), isFalse);
    });

    test('windowed rejects non-positive size and step', () {
      final source = [1, 2, 3];

      expect(
        () => source.windowed(0).toList(),
        throwsA(isA<RangeError>()),
      );
      expect(
        () => source.windowed(0, partialWindows: true).toList(),
        throwsA(isA<RangeError>()),
      );
      expect(
        () => source.windowed(2, step: 0).toList(),
        throwsA(isA<RangeError>()),
      );
      expect(
        () => source.windowed(2, step: 0, partialWindows: true).toList(),
        throwsA(isA<RangeError>()),
      );
    });

    test('cycle returns no items for non-positive repeat counts', () {
      final source = [1, 2, 3];

      expect(source.cycle(0), isEmpty);
      expect(source.cycle(-1), isEmpty);
    });
  });

  group('sorted list', () {
    test('is immutable after sorting the source iterable', () {
      final sorted = SortedList<int>([3, 1, 2], (a, b) => a.compareTo(b));

      expect(sorted, orderedEquals([1, 2, 3]));
      expect(() => sorted.add(4), throwsA(isA<UnsupportedError>()));
      expect(() => sorted[0] = 99, throwsA(isA<UnsupportedError>()));
      expect(sorted, orderedEquals([1, 2, 3]));
    });
  });

  group('iterable min/max helpers', () {
    test('minBy accepts comparables with any negative compareTo result', () {
      final values = [
        const WeirdComparable(2),
        const WeirdComparable(1),
      ];

      expect(values.minBy((value) => value)?.value, 1);
      expect(values.maxBy((value) => value)?.value, 2);
    });
  });

  group('num arithmetic extensions', () {
    test('plus and minus preserve null-handling without casts', () {
      expect(1.plus(2), 3);
      expect(1.minus(2), -1);
      expect(1.plusOrNull(null), isNull);
      expect(1.5.minusOrNull(0.5), 1.0);
    });

    test('typed between and inRange work for int and double', () {
      expect(3.between(1, 5), isTrue);
      expect(3.inRange(1.rangeTo(5)), isTrue);
      expect(3.5.between(1.5, 4.5), isTrue);
      expect(3.5.inRange(1.5.rangeTo(4.5)), isTrue);
    });

    test('ordinal uses absolute value for negative suffix selection', () {
      expect((-1).ordinal(), '-1st');
      expect((-2).ordinal(), '-2nd');
      expect((-3).ordinal(), '-3rd');
      expect((-11).ordinal(), '-11th');
      expect((-21).ordinal(), '-21st');
    });
  });

  group('time extensions', () {
    test('timeAgo reports future values when allowFromNow is enabled', () {
      final clock = DateTime(2024, 1, 1, 12);
      final future = DateTime(2024, 1, 1, 12, 30);

      expect(
        future.timeAgo(clock: clock, allowFromNow: true),
        '30 minutes from now',
      );
    });

    test('to rejects non-positive step sizes', () {
      final start = DateTime(2024);
      final end = DateTime(2024, 1, 3);

      expect(
        () => start.to(end, by: Duration.zero).toList(),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => start.to(end, by: const Duration(days: -1)).toList(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('isToday compares UTC dates in local day context', () {
      final now = DateTime.now();
      final localSameDay = now.timeZoneOffset.isNegative
          ? DateTime(now.year, now.month, now.day, 23, 30)
          : DateTime(now.year, now.month, now.day, 0, 30);
      final utcEquivalent = localSameDay.toUtc();

      expect(utcEquivalent.isUtc, isTrue);
      expect(utcEquivalent.isToday, isTrue);
    });

    test('shift clamps the day before applying additional day overflow', () {
      final start = DateTime(2024, 1, 31, 10, 15);

      expect(start.shift(months: 1), DateTime(2024, 2, 29, 10, 15));
      expect(start.shift(months: 1, days: 5), DateTime(2024, 3, 5, 10, 15));
    });

    test('nanoseconds are truncated to microsecond precision', () {
      expect(999.nanoseconds, Duration.zero);
      expect(1500.nanoseconds, const Duration(microseconds: 1));
    });

    test('inWeeks truncates partial weeks', () {
      expect(1.days.inWeeks, 0);
      expect(8.days.inWeeks, 1);
    });
  });

  group('ranges', () {
    test('descending IntProgression recomputes endInclusive for the step', () {
      final progression = IntProgression(5, 0, step: 2);

      expect(progression.endInclusive, 1);
      expect(progression.contains(progression.endInclusive), isTrue);
    });

    test('IntRange.contains rejects fractional values', () {
      expect(1.rangeTo(3).contains(1.5), isFalse);
    });
  });

  group('string extensions', () {
    test('urlEncode and urlDecode round-trip full URIs', () {
      const uri = 'https://example.com/a path?q=hello world';

      expect(uri.urlEncode.urlDecode, uri);
    });
  });
}
