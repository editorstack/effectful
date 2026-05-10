// ignore_for_file: public_member_api_docs, document_ignores, lines_longer_than_80_chars, avoid_equals_and_hash_code_on_mutable_classes

extension MapAll<K, V> on Map<K, V> {
  /// Returns true if all entries match the given [predicate].
  bool all(bool Function(K key, V value) predicate) {
    if (isEmpty) {
      return true;
    }
    for (final entry in entries) {
      if (!predicate(entry.key, entry.value)) {
        return false;
      }
    }
    return true;
  }
}

extension MapAny<K, V> on Map<K, V> {
  /// Returns true if there is at least one entry that matches the given [predicate].
  bool any(bool Function(K key, V value) predicate) {
    if (isEmpty) {
      return false;
    }
    for (final entry in entries) {
      if (predicate(entry.key, entry.value)) {
        return true;
      }
    }
    return false;
  }
}

extension MapCount<K, V> on Map<K, V> {
  /// Returns the number of entries matching the given [predicate] or the number
  /// of entries when `predicate = null`.
  int count([bool Function(MapEntry<K, V>)? predicate]) {
    if (predicate == null) {
      return length;
    }
    var count = 0;

    final i = entries.iterator;
    while (i.moveNext()) {
      if (predicate(i.current)) {
        count++;
      }
    }
    return count;
  }
}

extension MapFilter<K, V> on Map<K, V> {
  /// Returns a new map containing all key-value pairs matching the given [predicate].
  Map<K, V> filter(bool Function(MapEntry<K, V> entry) predicate) {
    final result = <K, V>{};
    for (final entry in entries) {
      if (predicate(entry)) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
}

extension MapFilterKeys<K, V> on Map<K, V> {
  /// Returns a map containing all key-value pairs with keys matching the given [predicate].
  Map<K, V> filterKeys(bool Function(K) predicate) {
    final result = <K, V>{};
    for (final entry in entries) {
      if (predicate(entry.key)) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
}

extension MapFilterNot<K, V> on Map<K, V> {
  /// Returns a new map containing all key-value pairs not matching the given [predicate].
  Map<K, V> filterNot(bool Function(MapEntry<K, V> entry) predicate) {
    final result = <K, V>{};
    for (final entry in entries) {
      if (!predicate(entry)) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
}

extension MapFilterValues<K, V> on Map<K, V> {
  /// Returns a map containing all key-value pairs with values matching the given [predicate].
  Map<K, V> filterValues(bool Function(V) predicate) {
    final result = <K, V>{};
    for (final entry in entries) {
      if (predicate(entry.value)) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
}

extension MapGetOrElse<K, V> on Map<K, V> {
  /// Returns the value for the given key, or the result of the [defaultValue] function if there was no entry for the given key.
  V getOrElse(K key, V Function() defaultValue) {
    if (containsKey(key)) return this[key] as V;
    return defaultValue();
  }
}

extension MapEntries<K, V> on Map<K, V> {
  /// Maps [entries] in this map to a [List<R>]
  Iterable<R> mapEntries<R>(R Function(MapEntry<K, V>) transform) sync* {
    for (final entry in entries) {
      yield transform(entry);
    }
  }
}

extension MapMapKeys<K, V> on Map<K, V> {
  /// Returns a new Map with entries having the keys obtained by applying the [transform] function to each entry in this
  /// [Map] and the values of this map.
  Map<R, V> mapKeys<R>(R Function(MapEntry<K, V>) transform) {
    return map((key, value) {
      return MapEntry(transform(MapEntry(key, value)), value);
    });
  }
}

extension MapMapValues<K, V> on Map<K, V> {
  /// Returns a new map with entries having the keys of this map and the values obtained by applying the [transform]
  /// function to each entry in this [Map].
  Map<K, R> mapValues<R>(R Function(MapEntry<K, V>) transform) {
    return map((key, value) {
      return MapEntry(key, transform(MapEntry(key, value)));
    });
  }
}

extension MapMaxBy<K, V> on Map<K, V> {
  /// Returns the first entry yielding the largest value of the given function or `null` if there are no entries.
  MapEntry<K, V>? maxBy<R extends Comparable<R>>(
    R Function(MapEntry<K, V>) selector,
  ) {
    final i = entries.iterator;
    if (!i.moveNext()) return null;
    var maxElement = i.current;
    var maxValue = selector(maxElement);
    while (i.moveNext()) {
      final e = i.current;
      final v = selector(e);
      if (maxValue.compareTo(v) < 0) {
        maxElement = e;
        maxValue = v;
      }
    }
    return maxElement;
  }
}

extension MapMaxWith<K, V> on Map<K, V> {
  /// Returns the first entry having the largest value according to the provided [comparator] or `null` if there are no entries.
  MapEntry<K, V>? maxWith(Comparator<MapEntry<K, V>> comparator) {
    final i = entries.iterator;
    if (!i.moveNext()) return null;
    var max = i.current;
    while (i.moveNext()) {
      final e = i.current;
      if (comparator(max, e) < 0) {
        max = e;
      }
    }
    return max;
  }
}

extension MapMinBy<K, V> on Map<K, V> {
  /// Returns the first entry yielding the smallest value of the given function or `null` if there are no entries.
  MapEntry<K, V>? minBy<R extends Comparable<R>>(
    R Function(MapEntry<K, V>) selector,
  ) {
    final i = entries.iterator;
    if (!i.moveNext()) return null;
    var minElement = i.current;
    var minValue = selector(minElement);
    while (i.moveNext()) {
      final e = i.current;
      final v = selector(e);
      if (minValue.compareTo(v) > 0) {
        minElement = e;
        minValue = v;
      }
    }
    return minElement;
  }
}

extension MapMinWith<K, V> on Map<K, V> {
  /// Returns the first entry having the smallest value according to the provided [comparator] or `null` if there are no entries.
  MapEntry<K, V>? minWith(Comparator<MapEntry<K, V>> comparator) {
    final i = entries.iterator;
    if (!i.moveNext()) return null;
    var min = i.current;
    while (i.moveNext()) {
      final e = i.current;
      if (comparator(min, e) > 0) {
        min = e;
      }
    }
    return min;
  }
}

extension MapNone<K, V> on Map<K, V> {
  /// Returns `true` if there is no entries in the map that match the given [predicate].
  bool none(bool Function(K key, V value) predicate) {
    if (isEmpty) {
      return true;
    }
    for (final entry in entries) {
      if (predicate(entry.key, entry.value)) {
        return false;
      }
    }
    return true;
  }
}

extension MapToList<K, V> on Map<K, V> {
  /// Returns a list of map entries
  List<Pair<K, V>> toList() {
    return mapEntries((e) => Pair<K, V>(e.key, e.value)).toList();
  }
}

extension MapToMap<K, V> on Map<K, V> {
  /// Returns a new map containing all key-value pairs from the original map.
  Map<K, V> toMap() {
    return Map.of(this);
  }
}

extension MapOrEmpty<K, V> on Map<K, V>? {
  /// Returns the [Map] if its not `null`, or the empty [Map] otherwise.
  Map<K, V> orEmpty() => this ?? <K, V>{};
}

/// Represents a generic pair of two values.
class Pair<A, B> {
  const Pair(this.first, this.second);

  final A first;
  final B second;

  @override
  String toString() => '($first, $second)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}

extension PairDeconstruction<T> on Pair<T, T> {
  /// Converts this pair into a list.
  List<T> toList() => [first, second];
}
