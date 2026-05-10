// ignore_for_file: public_member_api_docs, document_ignores, lines_longer_than_80_chars

import 'dart:collection';

import 'package:collection/collection.dart' as collection;

extension IterableSlice<E> on Iterable<E> {
  /// Returns a new list containing elements at indices between [start]
  /// (inclusive) and [end] (inclusive).
  List<E> slice(int start, [int end = -1]) {
    final list = this is List ? this as List<E> : toList();
    var s = start;
    var e = end;

    if (s < 0) {
      s = s + list.length;
    }
    if (e < 0) {
      e = e + list.length;
    }

    RangeError.checkValidRange(s, e, list.length);

    return list.sublist(s, e + 1);
  }
}

extension IterableContainsAll<E> on Iterable<E> {
  /// Checks if all elements in the specified [collection] are contained in
  /// this collection.
  bool containsAll(Iterable<E> collection) {
    for (final element in collection) {
      if (!contains(element)) return false;
    }
    return true;
  }
}

extension IterableContainsAny<E> on Iterable<E> {
  /// Checks if any elements in the specified [collection] are contained in
  /// this collection.
  bool containsAny(Iterable<E> collection) {
    for (final element in collection) {
      if (contains(element)) return true;
    }
    return false;
  }
}

extension IterableContentEquals<E> on Iterable<E> {
  /// Returns true if this collection is structurally equal to the [other]
  /// collection.
  bool contentEquals(Iterable<E> other, [bool Function(E a, E b)? checkEqual]) {
    final it1 = iterator;
    final it2 = other.iterator;
    if (checkEqual != null) {
      while (it1.moveNext()) {
        if (!it2.moveNext()) return false;
        if (!checkEqual(it1.current, it2.current)) return false;
      }
    } else {
      while (it1.moveNext()) {
        if (!it2.moveNext()) return false;
        if (it1.current != it2.current) return false;
      }
    }
    return !it2.moveNext();
  }
}

extension IterableJoinToString<E> on Iterable<E> {
  /// Creates a string from all the elements separated using [separator] and
  /// using the given [prefix] and [postfix] if supplied.
  String joinToString({
    String separator = ', ',
    String Function(E element)? transform,
    String prefix = '',
    String postfix = '',
    int? limit,
    String truncated = '...',
  }) {
    final buffer = StringBuffer()..write(prefix);
    var count = 0;
    for (final element in this) {
      if (limit != null && count >= limit) {
        buffer.write(truncated);
        break;
      }
      if (count > 0) {
        buffer.write(separator);
      }
      if (transform != null) {
        buffer.write(transform(element));
      } else {
        buffer.write(element.toString());
      }
      count++;
    }
    buffer.write(postfix);
    return buffer.toString();
  }
}

extension IterableSumBy<E> on Iterable<E> {
  /// Returns the sum of all values produced by [selector] function applied to
  /// each element in the collection.
  T sumBy<T extends num>(T Function(E element) selector) {
    var sum = T == double ? 0.0 : 0;
    for (final current in this) {
      sum += selector(current);
    }
    return sum as T;
  }
}

extension IterableAverageBy<E> on Iterable<E> {
  /// Returns the average of values returned by [selector] for all elements in
  /// the collection.
  double averageBy(num Function(E element) selector) {
    var count = 0;
    num sum = 0;

    for (final current in this) {
      sum += selector(current);
      count++;
    }

    if (count == 0) {
      throw StateError('No elements in collection');
    } else {
      return sum / count;
    }
  }
}

extension IterableMin<E> on Iterable<E> {
  /// Returns the smallest element or `null` if there are no elements.
  ///
  /// All elements must be of type [Comparable].
  E? min() => _minMax(-1);
}

extension _MinMaxHelper<E> on Iterable<E> {
  E? _minMax(int order) {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    var currentMin = it.current;

    if (order < 0) {
      while (it.moveNext()) {
        if ((it.current as Comparable).compareTo(currentMin) < 0) {
          currentMin = it.current;
        }
      }
    } else {
      while (it.moveNext()) {
        if ((it.current as Comparable).compareTo(currentMin) > 0) {
          currentMin = it.current;
        }
      }
    }

    return currentMin;
  }

  E? _minMaxBy<R extends Comparable<R>>(
    int order,
    R Function(E element) selector,
  ) {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }

    var currentMin = it.current;
    var currentMinValue = selector(it.current);
    while (it.moveNext()) {
      final comp = selector(it.current);
      if (order < 0 ? comp.compareTo(currentMinValue) < 0 : comp.compareTo(currentMinValue) > 0) {
        currentMin = it.current;
        currentMinValue = comp;
      }
    }

    return currentMin;
  }

  E? _minMaxWith(int order, Comparator<E> comparator) {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    var currentMin = it.current;

    while (it.moveNext()) {
      if (order < 0
          ? comparator(it.current, currentMin) < 0
          : comparator(it.current, currentMin) > 0) {
        currentMin = it.current;
      }
    }

    return currentMin;
  }
}

extension IterableMinBy<E> on Iterable<E> {
  /// Returns the first element yielding the smallest value of the given
  /// [selector] or `null` if there are no elements.
  E? minBy<R extends Comparable<R>>(R Function(E element) selector) => _minMaxBy(-1, selector);
}

extension IterableMinWith<E> on Iterable<E> {
  /// Returns the first element having the smallest value according to the
  /// provided [comparator] or `null` if there are no elements.
  E? minWith(Comparator<E> comparator) => _minMaxWith(-1, comparator);
}

extension IterableMax<E> on Iterable<E> {
  /// Returns the largest element or `null` if there are no elements.
  ///
  /// All elements must be of type [Comparable].
  E? max() => _minMax(1);
}

extension IterableMaxBy<E> on Iterable<E> {
  /// Returns the first element yielding the largest value of the given
  /// [selector] or `null` if there are no elements.
  E? maxBy<R extends Comparable<R>>(R Function(E element) selector) => _minMaxBy(1, selector);
}

extension IterableMaxWith<E> on Iterable<E> {
  /// Returns the first element having the largest value according to the
  /// provided [comparator] or `null` if there are no elements.
  E? maxWith(Comparator<E> comparator) => _minMaxWith(1, comparator);
}

extension IterableCount<E> on Iterable<E> {
  /// Returns the number of elements matching the given [predicate].
  ///
  /// If no [predicate] is given, this equals to [length].
  int count([bool Function(E element)? predicate]) {
    var count = 0;
    if (predicate == null) {
      return length;
    } else {
      for (final current in this) {
        if (predicate(current)) {
          count++;
        }
      }
    }

    return count;
  }
}

extension IterableReversed<E> on Iterable<E> {
  /// Returns an [Iterable] of the objects in this list in reverse order.
  Iterable<E> get reversed {
    return this is List<E> ? (this as List<E>).reversed : toList().reversed;
  }
}

extension IterableTakeFirst<E> on Iterable<E> {
  /// Returns a list containing first [n] elements.
  List<E> takeFirst(int n) {
    final list = this is List<E> ? this as List<E> : toList();
    return list.take(n).toList();
  }
}

extension IterableTakeLast<E> on Iterable<E> {
  /// Returns a list containing last [n] elements.
  List<E> takeLast(int n) {
    final list = this is List<E> ? this as List<E> : toList();
    return list.reversed.take(n).reversed.toList();
  }
}

extension IterableMapNotNull<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing only the non-null results of
  /// applying the given [transform] function to each element in the original
  /// collection.
  Iterable<R> mapNotNull<R>(R? Function(E element) transform) sync* {
    for (final element in this) {
      final result = transform(element);
      if (result != null) {
        yield result;
      }
    }
  }
}

extension IterableMapIndexedNotNull<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing only the non-null results of
  /// applying the given [transform] function to each element and its index
  /// in the original collection.
  Iterable<R> mapIndexedNotNull<R>(R? Function(int index, E) transform) sync* {
    var index = 0;
    for (final element in this) {
      final result = transform(index++, element);
      if (result != null) {
        yield result;
      }
    }
  }
}

extension IterableOnEach<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] which performs the given action on each
  /// element.
  Iterable<E> onEach(void Function(E element) action) sync* {
    for (final element in this) {
      action(element);
      yield element;
    }
  }
}

extension IterableDistinct<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing only distinct elements from the
  /// collection.
  Iterable<E> distinct() sync* {
    final existing = HashSet<E>();
    for (final current in this) {
      if (existing.add(current)) {
        yield current;
      }
    }
  }
}

extension IterableDistinctBy<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing only elements from the collection
  /// having distinct keys returned by the given [selector] function.
  Iterable<E> distinctBy<R>(R Function(E element) selector) sync* {
    final existing = HashSet<R>();
    for (final current in this) {
      if (existing.add(selector(current))) {
        yield current;
      }
    }
  }
}

extension IterableChunked<E> on Iterable<E> {
  /// Splits this collection into a new lazy [Iterable] of lists each not
  /// exceeding the given [size].
  Iterable<List<E>> chunked(int size) sync* {
    if (size < 1) {
      throw ArgumentError('Requested chunk size $size is less than one.');
    }

    var currentChunk = <E>[];
    for (final current in this) {
      currentChunk.add(current);
      if (currentChunk.length >= size) {
        yield currentChunk;
        currentChunk = <E>[];
      }
    }
    if (currentChunk.isNotEmpty) {
      yield currentChunk;
    }
  }
}

extension IterableChunkWhile<E> on Iterable<E> {
  /// Splits this collection into a lazy [Iterable] of chunks, where chunks are
  /// created as long as [predicate] is true for a pair of entries.
  Iterable<List<E>> chunkWhile(bool Function(E, E) predicate) sync* {
    var currentChunk = <E>[];
    var hasPrevious = false;
    late E previous;

    for (final element in this) {
      if (!hasPrevious || predicate(previous, element)) {
        currentChunk.add(element);
      } else {
        yield currentChunk;
        currentChunk = [element];
      }

      previous = element;
      hasPrevious = true;
    }

    if (currentChunk.isNotEmpty) yield currentChunk;
  }
}

extension IterableSplitWhen<E> on Iterable<E> {
  /// Splits this collection into a lazy [Iterable], where each split will be
  /// make if [predicate] returns true for a pair of entries.
  Iterable<List<E>> splitWhen(bool Function(E, E) predicate) {
    return chunkWhile((a, b) => !predicate(a, b));
  }
}

extension IterableWindowed<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] of windows of the given [size] sliding along
  /// this collection with the given [step].
  Iterable<List<E>> windowed(
    int size, {
    int step = 1,
    bool partialWindows = false,
  }) sync* {
    if (size <= 0) {
      throw RangeError.range(size, 1, null, 'size');
    }
    if (step <= 0) {
      throw RangeError.range(step, 1, null, 'step');
    }

    final gap = step - size;
    if (gap >= 0) {
      var buffer = <E>[];
      var skip = 0;
      for (final element in this) {
        if (skip > 0) {
          skip -= 1;
          continue;
        }
        buffer.add(element);
        if (buffer.length == size) {
          yield buffer;
          buffer = <E>[];
          skip = gap;
        }
      }
      if (buffer.isNotEmpty && (partialWindows || buffer.length == size)) {
        yield buffer;
      }
    } else {
      final buffer = ListQueue<E>(size);
      for (final element in this) {
        buffer.add(element);
        if (buffer.length == size) {
          yield buffer.toList();
          for (var i = 0; i < step; i++) {
            buffer.removeFirst();
          }
        }
      }
      if (partialWindows) {
        while (buffer.length > step) {
          yield buffer.toList();
          for (var i = 0; i < step; i++) {
            buffer.removeFirst();
          }
        }
        if (buffer.isNotEmpty) {
          yield buffer.toList();
        }
      }
    }
  }
}

extension IterableFlatMap<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] of all elements yielded from results of
  /// [transform] function being invoked on each element of this collection.
  Iterable<R> flatMap<R>(Iterable<R> Function(E element) transform) sync* {
    for (final current in this) {
      yield* transform(current);
    }
  }
}

extension IterableCycle<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] which iterates over this collection [n]
  /// times.
  Iterable<E> cycle([int? n]) sync* {
    if (n != null && n <= 0) {
      return;
    }

    var it = iterator;
    if (!it.moveNext()) {
      return;
    }
    if (n == null) {
      yield it.current;
      while (true) {
        while (it.moveNext()) {
          yield it.current;
        }
        it = iterator;
      }
    } else {
      var count = 0;
      while (count < n) {
        if (count == 0) {
          yield it.current;
        } else {
          it = iterator;
          if (!it.moveNext()) {
            return;
          }
          yield it.current;
        }
        while (it.moveNext()) {
          yield it.current;
        }
        count++;
      }
    }
  }
}

extension IterableIntersect<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing all elements that are contained
  /// by both this collection and the [other] collection.
  Iterable<E> intersect(Iterable<E> other) sync* {
    final second = HashSet<E>.from(other);
    final output = HashSet<E>();
    for (final current in this) {
      if (second.contains(current)) {
        if (output.add(current)) {
          yield current;
        }
      }
    }
  }
}

extension IterableExcept<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing all elements of this collection
  /// except the elements contained in the given [elements] collection.
  Iterable<E> except(Iterable<E> elements) sync* {
    for (final current in this) {
      if (!elements.contains(current)) yield current;
    }
  }
}

extension IterableMinus<E> on Iterable<E> {
  /// Returns a new list containing all elements of this collection except the
  /// elements contained in the given [elements] collection.
  List<E> operator -(Iterable<E> elements) => except(elements).toList();
}

extension IterableExceptElement<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing all elements of this collection
  /// except the given [element].
  Iterable<E> exceptElement(E element) sync* {
    for (final current in this) {
      if (element != current) yield current;
    }
  }
}

extension IterablePrepend<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] with [elements] before this collection.
  Iterable<E> prepend(Iterable<E> elements) sync* {
    yield* elements;
    yield* this;
  }
}

extension IterablePrependElement<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] with [element] before this collection.
  Iterable<E> prependElement(E element) sync* {
    yield element;
    yield* this;
  }
}

extension IterableAppend<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] with [elements] after this collection.
  Iterable<E> append(Iterable<E> elements) sync* {
    yield* this;
    yield* elements;
  }
}

extension IterablePlus<E> on Iterable<E> {
  /// Returns a new list with [elements] appended.
  List<E> operator +(Iterable<E> elements) => append(elements).toList();
}

extension IterableAppendElement<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] with [element] after this collection.
  Iterable<E> appendElement(E element) sync* {
    yield* this;
    yield element;
  }
}

extension IterableUnion<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing all distinct elements from
  /// both collections.
  Iterable<E> union(Iterable<E> other) sync* {
    final existing = HashSet<E>();
    for (final element in this) {
      if (existing.add(element)) yield element;
    }

    for (final element in other) {
      if (existing.add(element)) yield element;
    }
  }
}

extension IterableZip<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] of values built from the elements of this
  /// collection and the [other] collection with the same index.
  Iterable<V> zip<R, V>(
    Iterable<R> other,
    V Function(E a, R b) transform,
  ) sync* {
    final it1 = iterator;
    final it2 = other.iterator;
    while (it1.moveNext() && it2.moveNext()) {
      yield transform(it1.current, it2.current);
    }
  }
}

extension IterableToIterable<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] with all elements of this collection.
  Iterable<E> toIterable() sync* {
    yield* this;
  }
}

extension IterableAsStream<E> on Iterable<E> {
  /// Returns a new [Stream] with all elements of this collection.
  Stream<E> asStream() => Stream.fromIterable(this);
}

extension IterableToHashSet<E> on Iterable<E> {
  /// Returns a new [HashSet] with all distinct elements of this collection.
  HashSet<E> toHashSet() => HashSet.from(this);
}

extension IterableToUnmodifiable<E> on Iterable<E> {
  /// Returns an unmodifiable List view of this collection.
  List<E> toUnmodifiable() => collection.UnmodifiableListView(this);
}

extension IterableAssociate<E> on Iterable<E> {
  /// Returns a Map containing key-value pairs provided by [transform] function
  /// applied to elements of this collection.
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(E element) transform) {
    final map = <K, V>{};
    for (final element in this) {
      final entry = transform(element);
      map[entry.key] = entry.value;
    }
    return map;
  }
}

extension IterableAssociateBy<E> on Iterable<E> {
  /// Returns a Map containing the elements from the collection indexed by
  /// the key returned from [keySelector] function applied to each element.
  Map<K, E> associateBy<K>(K Function(E element) keySelector) {
    final map = <K, E>{};
    for (final current in this) {
      map[keySelector(current)] = current;
    }
    return map;
  }
}

extension IterableAssociateWith<E> on Iterable<E> {
  /// Returns a Map containing the values returned from [valueSelector] function
  /// applied to each element indexed by the elements from the collection.
  Map<E, V> associateWith<V>(V Function(E element) valueSelector) {
    final map = <E, V>{};
    for (final current in this) {
      map[current] = valueSelector(current);
    }
    return map;
  }
}

extension IterablePartition<E> on Iterable<E> {
  /// Splits the collection into two lists according to [predicate].
  List<List<E>> partition(bool Function(E element) predicate) {
    final t = <E>[];
    final f = <E>[];
    for (final element in this) {
      if (predicate(element)) {
        t.add(element);
      } else {
        f.add(element);
      }
    }
    return [t, f];
  }
}

extension IterableCached<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] that caches the computation of the current
  /// [Iterable].
  Iterable<E> get cached => _CachedIterable<E>(this);
}

class _CachedIterable<T> extends IterableBase<T> {
  _CachedIterable(Iterable<T> iterable) : _uncomputedIterator = iterable.iterator;

  final Iterator<T> _uncomputedIterator;
  final _cache = _IterableCache<T>(null);

  @override
  Iterator<T> get iterator => _CachedIterator<T>(_cache, _uncomputedIterator);
}

class _CachedIterator<T> implements Iterator<T> {
  _CachedIterator(_IterableCache<T> cache, this._uncomputedIterator)
      : _cache = cache,
        _latestValidCache = cache;

  _IterableCache<T>? _cache;
  _IterableCache<T> _latestValidCache;
  final Iterator<T> _uncomputedIterator;

  @override
  T get current => _current as T;
  T? _current;

  @override
  bool moveNext() {
    final next = _cache?.next;
    _cache = next;
    if (next != null) {
      _current = next.value;
      _latestValidCache = next;
      return true;
    }
    if (_uncomputedIterator.moveNext()) {
      _current = _uncomputedIterator.current;
      assert(_latestValidCache.next == null, 'Expected the cache tail to be empty.');
      _latestValidCache.next = _IterableCache(current);
      _latestValidCache = _latestValidCache.next!;
      return true;
    }
    return false;
  }
}

class _IterableCache<T> {
  _IterableCache(this.value);

  _IterableCache<T>? next;
  final T? value;
}

extension IterableFutureX<E> on Iterable<Future<E>> {
  /// Create a stream from a group of futures.
  Stream<E> asStreamAwaited() => Stream.fromFutures(this);
}

extension IterableStartsWithExtension<E> on Iterable<E> {
  /// Returns if this [Iterable] starts with the elements of [otherIterable].
  bool startsWith(Iterable<E> otherIterable) {
    final thisIterator = iterator;
    final otherIterator = otherIterable.iterator;
    if (!otherIterator.moveNext()) return true;
    do {
      if (!thisIterator.moveNext() || otherIterator.current != thisIterator.current) {
        return false;
      }
    } while (otherIterator.moveNext());
    return true;
  }
}
