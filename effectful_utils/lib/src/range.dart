// ignore_for_file: public_member_api_docs, document_ignores, lines_longer_than_80_chars, avoid_equals_and_hash_code_on_mutable_classes

import 'dart:collection';

/// Represents a range of values (for example, numbers or characters)
/// with a fixed [start] value and a fixed [endInclusive] value.
abstract class Range<T extends Comparable<Object?>> {
  const Range();

  /// The first value in the range.
  T get start;

  /// The last value in the range (inclusive).
  T get endInclusive;

  /// Checks whether the specified [value] belongs to the range.
  bool contains(T value) {
    if (start.compareTo(endInclusive) <= 0) {
      return start.compareTo(value) <= 0 && value.compareTo(endInclusive) <= 0;
    } else {
      return endInclusive.compareTo(value) <= 0 && value.compareTo(start) <= 0;
    }
  }

  @override
  String toString() => '$start..$endInclusive';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Range &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          endInclusive == other.endInclusive;

  @override
  int get hashCode => start.hashCode ^ endInclusive.hashCode;
}

/// Represents a range of [Comparable] values such as [String] or [DateTime]
class ComparableRange<T extends Comparable<Object?>> extends Range<T> {
  ComparableRange(this.start, this.endInclusive);

  @override
  final T start;

  @override
  final T endInclusive;
}

extension ComparableRangeX<T extends Comparable<Object?>> on T {
  /// Creates a [Range] from this [Comparable] value
  /// to the specified [endInclusive] value.
  ComparableRange<T> rangeTo(T endInclusive) => ComparableRange<T>(this, endInclusive);
}

extension IntRangeToExtension on int {
  /// Creates a [IntRange] with a step count of 1
  IntRange rangeTo(int endInclusive) => IntRange(this, endInclusive);
}

extension DoubleRangeToExtension on double {
  DoubleRange rangeTo(double endInclusive) => DoubleRange(this, endInclusive);
}

class DoubleRange extends Range<double> {
  DoubleRange(this.start, this.endInclusive);
  @override
  final double endInclusive;

  @override
  final double start;

  @override
  bool contains(covariant num value) {
    if (start <= endInclusive) {
      return start <= value && value <= endInclusive;
    } else {
      return endInclusive <= value && value <= start;
    }
  }
}

class IntRange extends IntProgression implements Range<int> {
  IntRange(super.first, super.endInclusive);

  @override
  bool contains(covariant num value) {
    assert(stepSize == 1, 'IntRange.contains only supports a step size of 1.');
    if (value is! int) {
      return false;
    }
    if (start <= endInclusive) {
      return start <= value && value <= endInclusive;
    } else {
      return endInclusive <= value && value <= start;
    }
  }
}

class IntProgression extends IterableBase<int> {
  IntProgression(int first, int endInclusive, {int step = 1})
      : _first = first,
        stepSize = step,
        _last = _getProgressionLastElement(first, endInclusive, step);

  @override
  Iterator<int> get iterator => _IntRangeIterator(_first, _last, stepSize);

  final int _first;
  final int _last;
  final int stepSize;

  int get endInclusive => _last;
  int get start => _first;

  @override
  int get first => _first;

  @override
  int get last => _last;

  @override
  String toString() => '$start..$endInclusive';

  @override
  // ignore: avoid_renaming_method_parameters, matches Iterable.contains.
  bool contains(covariant int value) {
    bool inRange;
    if (start <= endInclusive) {
      inRange = start <= value && value <= endInclusive;
    } else {
      inRange = endInclusive <= value && value <= start;
    }
    if (!inRange) return false;
    return _differenceModulo(value, start, stepSize) == 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntProgression &&
          runtimeType == other.runtimeType &&
          _first == other._first &&
          _last == other._last &&
          stepSize == other.stepSize;

  @override
  int get hashCode => _first.hashCode ^ _last.hashCode ^ stepSize.hashCode;

  /// Creates an [IntProgression] with a different [stepSize].
  ///
  /// The [step] method keeps the same first value, but
  /// [IntProgression(_first, _last, step: step)] recomputes the last value to
  /// the nearest value that fits the new step, so the last value may change.
  IntProgression step(int step) => IntProgression(_first, _last, step: step);
}

int _getProgressionLastElement(int start, int end, int step) {
  if (step <= 0) {
    throw RangeError.range(step, 1, null);
  }
  if (start >= end) {
    return end + _differenceModulo(start, end, step);
  }
  return end - _differenceModulo(end, start, step);
}

int _differenceModulo(int a, int b, int c) {
  return _mod(_mod(a, c) - _mod(b, c), c);
}

int _mod(int a, int b) {
  final mod = a % b;
  return mod >= 0 ? mod : mod + b;
}

class _IntRangeIterator implements Iterator<int> {
  _IntRangeIterator(this.first, this.last, this.step);

  final int first;
  final int step;
  final int last;

  @override
  int get current => _current!;
  int? _current;
  bool completed = false;

  @override
  bool moveNext() {
    if (completed) return false;

    if (first == last) {
      _current = first;
      completed = true;
      return true;
    }

    final now = _current ?? first;
    var next = now;
    if (_current != null) {
      assert(first != last, 'The first and last values must differ once iteration starts.');
      if (first <= last) {
        next += step;
      } else {
        next -= step;
      }
    }
    if (first <= last) {
      if (next > last) {
        _current = null;
        completed = true;
        return false;
      }
    } else {
      if (next < last) {
        _current = null;
        completed = true;
        return false;
      }
    }

    _current = next;
    return true;
  }
}
