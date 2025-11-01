part of '../../reactive_types.dart';

/// A reactive set that automatically notifies listeners when modified.
///
/// [ReactiveSet] combines the functionality of Dart's [Set] with reactive
/// state management. Any modification to the set (add, remove, etc.)
/// automatically triggers UI updates in dependent [Observer] widgets.
///
/// All standard [Set] operations are supported, plus reactive features from
/// [Reactive] like listeners, history tracking, and stream binding.
///
/// Example:
/// ```dart
/// final tags = ReactiveSet<String>({'flutter', 'dart'});
///
/// // Use in Observer widget
/// Observer(
///   builder: (_) => Wrap(
///     children: tags.map((tag) => Chip(label: Text(tag))).toList(),
///   ),
/// );
///
/// // Modifications trigger automatic UI updates
/// tags.add('mobile');
/// tags.remove('dart');
/// tags.addAll({'ios', 'android'});
/// ```
class ReactiveSet<T> extends Reactive<Set<T>> with SetMixin<T> {
  /// Flag to prevent multiple refresh calls in the same frame.
  bool _isRefreshing = false;

  /// Creates a [ReactiveSet] with the given initial [value].
  ///
  /// Example:
  /// ```dart
  /// final numbers = ReactiveSet<int>({1, 2, 3});
  /// final empty = ReactiveSet<String>({});
  /// ```
  ReactiveSet(Set<T> value) : super(value);

  /// Returns the number of elements in the set.
  ///
  /// Example:
  /// ```dart
  /// final set = ReactiveSet<int>({1, 2, 3});
  /// print(set.length); // 3
  /// ```
  @override
  int get length => value.length;

  /// Gets the current set value.
  @override
  @protected
  Set<T> get value {
    return _valueNotifier.value;
  }

  /// Returns an iterator for the set elements.
  @override
  Iterator<T> get iterator => value.iterator;

  /// Adds [value] to the set.
  ///
  /// Returns `true` if [value] was added to the set (wasn't already present).
  /// Returns `false` if [value] was already in the set.
  ///
  /// Example:
  /// ```dart
  /// final set = ReactiveSet<int>({1, 2});
  /// print(set.add(3)); // true, set is now {1, 2, 3}
  /// print(set.add(2)); // false, set is still {1, 2, 3}
  /// ```
  @override
  bool add(T value) {
    final val = _valueNotifier.value.add(value);
    if (val) {
      _scheduleRefresh();
    }
    return val;
  }

  /// Adds all [elements] to the set.
  ///
  /// Example:
  /// ```dart
  /// final set = ReactiveSet<int>({1, 2});
  /// set.addAll({3, 4, 5}); // {1, 2, 3, 4, 5}
  /// ```
  @override
  void addAll(Iterable<T> elements) {
    super.value.addAll(elements);
    _scheduleRefresh();
  }

  /// Returns a new lazy iterable with all elements that satisfy [f].
  ///
  /// Note: This returns a non-reactive [Iterable]. Modifications won't trigger updates.
  ///
  /// Example:
  /// ```dart
  /// final set = ReactiveSet<int>({1, 2, 3, 4});
  /// final evens = set.where((n) => n % 2 == 0); // {2, 4}
  /// ```
  @override
  Iterable<T> where(bool Function(T) f) {
    return super.value.where(f);
  }

  /// Creates a [Set] containing the elements of this set.
  ///
  /// Note: Returns a non-reactive copy of the set.
  ///
  /// Example:
  /// ```dart
  /// final set = ReactiveSet<int>({1, 2, 3});
  /// final copy = set.toSet(); // {1, 2, 3}
  /// ```
  @override
  Set<T> toSet() {
    return super.value.toSet();
  }

  /// Removes [value] from the set.
  ///
  /// Returns `true` if [value] was in the set and has been removed.
  /// Returns `false` if [value] was not in the set.
  ///
  /// Example:
  /// ```dart
  /// final set = ReactiveSet<int>({1, 2, 3});
  /// print(set.remove(2)); // true, set is now {1, 3}
  /// print(set.remove(5)); // false, set is still {1, 3}
  /// ```
  @override
  bool remove(Object? value) {
    final status = super.value.remove(value);
    if (status) {
      _scheduleRefresh();
    }
    return status;
  }

  /// Removes all elements that satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final set = ReactiveSet<int>({1, 2, 3, 4, 5});
  /// set.removeWhere((n) => n % 2 == 0); // {1, 3, 5}
  /// ```
  @override
  void removeWhere(bool Function(T) test) {
    super.value.removeWhere(test);
    _scheduleRefresh();
  }

  /// Returns `true` if [element] is in the set.
  ///
  /// Example:
  /// ```dart
  /// final set = ReactiveSet<String>({'apple', 'banana'});
  /// print(set.contains('apple'));  // true
  /// print(set.contains('cherry')); // false
  /// ```
  @override
  bool contains(Object? element) {
    return value.contains(element);
  }

  /// Returns the element in the set that is equal to [element], or `null`.
  ///
  /// This is useful when you need the actual set element, not just equality.
  ///
  /// Example:
  /// ```dart
  /// final set = ReactiveSet<String>({'Apple'});
  /// print(set.lookup('Apple')); // 'Apple'
  /// print(set.lookup('apple')); // null
  /// ```
  @override
  T? lookup(Object? element) {
    return value.lookup(element);
  }

  /// Schedules a refresh to avoid multiple refreshes in a single frame.
  ///
  /// This internal method uses a microtask to batch multiple modifications
  /// into a single UI update for better performance.
  void _scheduleRefresh() {
    if (_isRefreshing) return;

    _isRefreshing = true;
    Future.microtask(() {
      refresh();
      _isRefreshing = false;
    });
  }
}
