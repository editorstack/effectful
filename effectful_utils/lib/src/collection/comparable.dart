// ignore_for_file: public_member_api_docs, document_ignores, lines_longer_than_80_chars

import 'package:effectful_utils/src/range.dart';

extension ComparableSmallerExtension<T extends Comparable<T>> on T {
  bool operator <(T other) => compareTo(other) < 0;
}

extension ComparableSmallerEqualsExtension<T extends Comparable<T>> on T {
  bool operator <=(T other) => compareTo(other) <= 0;
}

extension ComparableBiggerExtension<T extends Comparable<T>> on T {
  bool operator >(T other) => compareTo(other) > 0;
}

extension ComparableBiggerEqualsExtension<T extends Comparable<T>> on T {
  bool operator >=(T other) => compareTo(other) >= 0;
}

extension ComparableCoerceInExtension<T extends Comparable<T>> on T {
  /// Ensures that this value lies in the specified range
  /// [minimumValue]..[maximumValue].
  T coerceIn(T minimumValue, [T? maximumValue]) {
    if (maximumValue != null && minimumValue > maximumValue) {
      throw ArgumentError(
        'Cannot coerce value to an empty range: '
        'maximum $maximumValue is less than minimum $minimumValue.',
      );
    }
    if (this < minimumValue) return minimumValue;
    if (maximumValue != null && this > maximumValue) return maximumValue;
    return this;
  }
}

extension ComparableCoerceAtLeastExtension<T extends Comparable<T>> on T {
  /// Ensures that this value is not less than the specified [minimumValue].
  T coerceAtLeast(T minimumValue) => this < minimumValue ? minimumValue : this;
}

extension ComparableCoerceAtMostExtension<T extends Comparable<T>> on T {
  /// Ensures that this value is not greater than the specified [maximumValue].
  T coerceAtMost(T maximumValue) => this > maximumValue ? maximumValue : this;
}

extension ComparableBetweenExtension<T extends Comparable<T>> on T {
  /// Returns true when between [first] and [endInclusive].
  bool between(T first, T endInclusive) => first.rangeTo(endInclusive).contains(this);
}

extension ComparableInRangeExtension<T extends Comparable<T>> on T {
  /// Returns true if in the [range].
  bool inRange(Range<T> range) => range.contains(this);
}
