// ignore_for_file: public_member_api_docs, document_ignores

extension NumArithmeticX on num {
  /// Subtracts [val] when it is not null, otherwise returns `this`.
  num minus(num? val) => val == null ? this : this - val;

  /// Returns null if [val] is null, otherwise returns `this - val`.
  num? minusOrNull(num? val) => val == null ? null : this - val;

  /// Adds [val] when it is not null, otherwise returns `this`.
  num plus(num? val) => val == null ? this : this + val;

  /// Returns null if [val] is null, otherwise returns `this + val`.
  num? plusOrNull(num? val) => val == null ? null : this + val;
}
