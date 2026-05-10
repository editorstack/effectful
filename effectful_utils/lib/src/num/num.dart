// ignore_for_file: public_member_api_docs, document_ignores, lines_longer_than_80_chars

import 'dart:typed_data';

import 'package:effectful_utils/src/range.dart';

extension NumCoerceInExtension<T extends num> on T {
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

extension NumCoerceAtLeastExtension<T extends num> on T {
  /// Ensures that this value is not less than the specified [minimumValue].
  T coerceAtLeast(T minimumValue) => this < minimumValue ? minimumValue : this;
}

extension NumCoerceAtMostExtension<T extends num> on T {
  /// Ensures that this value is not greater than the specified [maximumValue].
  T coerceAtMost(T maximumValue) => this > maximumValue ? maximumValue : this;
}

extension IntCoerceInRangeExtension on int {
  /// Returns true if in the [range].
  bool inRange(Range<int> range) => range.contains(this);
}

extension DoubleCoerceInRangeExtension on double {
  /// Returns true if in the [range].
  bool inRange(Range<double> range) => range.contains(this);
}

extension IntBetweenExtension on int {
  /// Returns true if between [first] and [endInclusive].
  bool between(int first, int endInclusive) => first.rangeTo(endInclusive).contains(this);
}

extension DoubleBetweenExtension on double {
  /// Returns true if between [first] and [endInclusive].
  bool between(double first, double endInclusive) => first.rangeTo(endInclusive).contains(this);
}

extension IntToBytesExtension<T extends int> on T {
  /// Converts this value to binary form.
  Uint8List toBytes([Endian endian = Endian.big]) {
    final data = ByteData(8)..setInt64(0, this, endian);
    return data.buffer.asUint8List();
  }
}

extension DoubleToBytesExtension<T extends double> on T {
  /// Converts this value to binary form.
  Uint8List toBytes([Endian endian = Endian.big]) {
    final data = ByteData(8)..setFloat64(0, this, endian);
    return data.buffer.asUint8List();
  }
}

extension IntToCharExtension<T extends int> on T {
  /// Converts this [int] value to character.
  String toChar() => String.fromCharCode(this);
}
