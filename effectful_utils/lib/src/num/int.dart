// ignore_for_file: public_member_api_docs, document_ignores

extension Ordinals<T extends int> on T {
  /// Returns an ordinal number of `String` type for any integer
  ///
  /// ```dart
  /// 101.ordinal(); // 101st
  ///
  /// 999218.ordinal(); // 999218th
  /// ```
  String ordinal() {
    final value = abs();
    final onesPlace = value % 10;
    final tensPlace = (value ~/ 10) % 10;
    if (tensPlace == 1) {
      return '${this}th';
    } else {
      switch (onesPlace) {
        case 1:
          return '${this}st';
        case 2:
          return '${this}nd';
        case 3:
          return '${this}rd';
        default:
          return '${this}th';
      }
    }
  }
}
