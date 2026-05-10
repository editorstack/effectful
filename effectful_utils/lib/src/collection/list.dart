// ignore_for_file: public_member_api_docs, document_ignores

import 'package:collection/collection.dart' as collection;

extension ListExtension<E> on List<E> {
  /// Index of the first element or -1 if the collection is empty.
  int get firstIndex => isNotEmpty ? 0 : -1;
}

extension ListLastIndexExtension<E> on List<E> {
  /// Index of the last element or -1 if the collection is empty.
  int get lastIndex => length - 1;
}

extension ListIndicesExtension<E> on List<E> {
  Iterable<int> get indices sync* {
    var index = 0;
    while (index <= lastIndex) {
      yield index++;
    }
  }
}

extension ListDropExtension<E> on List<E> {
  /// Returns a new list containing all elements except first [n] elements.
  List<E> drop(int n) {
    if (n < 0) {
      throw ArgumentError('Requested element count $n is less than zero.');
    }
    if (n == 0) return toList();

    final resultSize = length - n;
    if (resultSize <= 0) return [];
    if (resultSize == 1) return [last];
    return sublist(n);
  }
}

extension ListDropWhileExtension<E> on List<E> {
  /// Returns a new list containing all elements except first elements that
  /// satisfy the given [predicate].
  List<E> dropWhile(bool Function(E element) predicate) {
    int? startIndex;
    for (var i = 0; i < length; i++) {
      if (!predicate(this[i])) {
        startIndex = i;
        break;
      }
    }
    if (startIndex == null) return [];
    return sublist(startIndex);
  }
}

extension ListDropLastExtension<E> on List<E> {
  /// Returns a new list containing all elements except last [n] elements.
  List<E> dropLast(int n) {
    if (n < 0) {
      throw ArgumentError('Requested element count $n is less than zero.');
    }
    if (n == 0) return toList();

    final resultSize = length - n;
    if (resultSize <= 0) return [];
    if (resultSize == 1) return [first];
    return sublist(0, length - n);
  }
}

extension ListDropLastWhileExtension<E> on List<E> {
  /// Returns a new list containing all elements except last elements that
  /// satisfy the given [predicate].
  List<E> dropLastWhile(bool Function(E element) predicate) {
    int? endIndex;
    for (var i = lastIndex; i >= 0; i--) {
      if (!predicate(this[i])) {
        endIndex = i;
        break;
      }
    }
    if (endIndex == null) return [];
    return sublist(0, endIndex + 1);
  }
}

extension ListLowerBoundExtension<E> on List<E> {
  /// Returns the first position in this list that does not compare less than
  /// [value].
  int lowerBound(E value, {int Function(E a, E b)? compare}) {
    return collection.lowerBound(this, value, compare: compare);
  }
}

extension ListBinarySearchExtension<E> on List<E> {
  /// Returns a position of the [value] in this list, if it is there.
  ///
  /// Returns -1 if [value] is not in the list by default.
  int binarySearch(E value, {int Function(E a, E b)? compare}) {
    return collection.binarySearch(this, value, compare: compare);
  }
}

extension ListInsertionSortExtension<E> on List<E> {
  /// Sort this list between [start] (inclusive) and [end] (exclusive) using
  /// insertion sort.
  void insertionSort({Comparator<E>? comparator, int start = 0, int? end}) {
    collection.insertionSort(this, compare: comparator, start: start, end: end);
  }
}

extension ListMergeSortExtension<E> on List<E> {
  /// Sorts this list between [start] (inclusive) and [end] (exclusive) using
  /// the merge sort algorithm.
  void mergeSort({int start = 0, int? end, Comparator<E>? comparator}) {
    collection.mergeSort(this, start: start, end: end, compare: comparator);
  }
}

extension ListSwapExtension<E> on List<E> {
  /// Swaps the elements in the indices provided.
  void swap(int indexA, int indexB) {
    final temp = this[indexA];
    this[indexA] = this[indexB];
    this[indexB] = temp;
  }
}

extension ListFlattenExtension<E> on List<List<E>> {
  /// Returns a new [List] of all elements from all lists in this [List].
  List<E> flatten() => [for (final list in this) ...list];
}
