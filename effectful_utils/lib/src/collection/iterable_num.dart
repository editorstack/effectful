// ignore_for_file: public_member_api_docs, document_ignores

extension IterableNumMedianExtension<T extends num> on Iterable<T> {
  /// Returns the median of the elements in this collection.
  ///
  /// Empty collections throw an error.
  double median() {
    if (length == 0) throw StateError('No elements in collection');
    final values = toList()..sort();
    final size = values.length;
    if (size.isOdd) {
      return values[size ~/ 2].toDouble();
    } else {
      final x = values[size ~/ 2];
      final y = values[size ~/ 2 - 1];
      return (x + y) / 2;
    }
  }
}
