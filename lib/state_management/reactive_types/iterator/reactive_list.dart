part of '../../reactive_types.dart';

/// A reactive list that automatically notifies listeners when modified.
///
/// [ReactiveList] combines the functionality of Dart's [List] with reactive
/// state management. Any modification to the list (add, remove, sort, etc.)
/// automatically triggers UI updates in dependent [Observer] widgets.
///
/// All standard [List] operations are supported, plus reactive features from
/// [Reactive] like listeners, history tracking, and stream binding.
///
/// Example:
/// ```dart
/// final items = ReactiveList<String>(['apple', 'banana']);
///
/// // Use in Observer widget
/// Observer(
///   builder: (_) => ListView(
///     children: items.map((item) => Text(item)).toList(),
///   ),
/// );
///
/// // Modifications trigger automatic UI updates
/// items.add('cherry');
/// items.removeAt(0);
/// items.sort();
/// ```
class ReactiveList<T> extends Reactive<List<T>> with ListMixin<T> {
  /// Flag to prevent multiple refresh calls in the same frame.
  bool _isRefreshing = false;

  /// Creates a [ReactiveList] with the given initial [value].
  ///
  /// Example:
  /// ```dart
  /// final numbers = ReactiveList<int>([1, 2, 3]);
  /// final empty = ReactiveList<String>([]);
  /// ```
  ReactiveList(List<T> value) : super(value);

  /// Returns the number of elements in the list.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2, 3]);
  /// print(list.length); // 3
  /// ```
  @override
  int get length => value.length;

  /// Gets the current list value.
  @override
  @protected
  List<T> get value {
    return _valueNotifier.value;
  }

  /// Sets the length of the list.
  ///
  /// If [newLength] is greater than current length, the list is extended with
  /// `null` values (if nullable). If shorter, elements are removed from the end.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2, 3]);
  /// list.length = 2; // [1, 2]
  /// ```
  @override
  set length(int newLength) {
    _valueNotifier.value.length = newLength;
    _scheduleRefresh();
  }

  /// Returns an iterator for the list elements.
  @override
  Iterator<T> get iterator => value.iterator;

  /// Sets the value at the given [index] to [val].
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<String>(['a', 'b', 'c']);
  /// list[1] = 'x'; // ['a', 'x', 'c']
  /// ```
  @override
  void operator []=(int index, T val) {
    _valueNotifier.value[index] = val;
    _scheduleRefresh();
  }

  /// Adds all elements from [val] to the end of this list.
  ///
  /// Returns this list to allow method chaining.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2]);
  /// list + [3, 4]; // [1, 2, 3, 4]
  /// ```
  @override
  ReactiveList<T> operator +(Iterable<T> val) {
    addAll(val);
    return this;
  }

  /// Returns the element at the given [index].
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<String>(['a', 'b', 'c']);
  /// print(list[0]); // 'a'
  /// ```
  @override
  T operator [](int index) {
    return value[index];
  }

  /// Adds [element] to the end of the list.
  ///
  /// Triggers reactive updates to notify all listeners and observers.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2]);
  /// list.add(3); // [1, 2, 3]
  /// ```
  @override
  void add(T element) {
    super.value.add(element);
    _scheduleRefresh();
  }

  /// Adds all elements of [iterable] to the end of the list.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2]);
  /// list.addAll([3, 4, 5]); // [1, 2, 3, 4, 5]
  /// ```
  @override
  void addAll(Iterable<T> iterable) {
    super.value.addAll(iterable);
    _scheduleRefresh();
  }

  /// Inserts all elements of [iterable] at position [index].
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 4]);
  /// list.insertAll(1, [2, 3]); // [1, 2, 3, 4]
  /// ```
  @override
  void insertAll(int index, Iterable<T> iterable) {
    _valueNotifier.value.insertAll(index, iterable);
    _scheduleRefresh();
  }

  /// Returns a new lazy iterable with all elements that satisfy [test].
  ///
  /// Note: This returns a non-reactive [Iterable]. Modifications won't trigger updates.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2, 3, 4]);
  /// final evens = list.where((n) => n % 2 == 0); // [2, 4]
  /// ```
  @override
  Iterable<T> where(bool Function(T) test) {
    return super.value.where(test);
  }

  /// Returns the first index where [test] returns true, or -1 if not found.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2, 3, 4]);
  /// print(list.indexWhere((n) => n > 2)); // 2
  /// ```
  @override
  int indexWhere(bool Function(T) test, [int start = 0]) {
    return super.value.indexWhere(test, start);
  }

  /// Creates a [Set] containing the elements of this list.
  ///
  /// Note: Returns a non-reactive [Set]. Use [ReactiveSet] for reactive sets.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2, 2, 3]);
  /// final set = list.toSet(); // {1, 2, 3}
  /// ```
  @override
  Set<T> toSet() {
    return super.value.toSet();
  }

  /// Sorts the list according to the order specified by [compare].
  ///
  /// If [compare] is omitted, elements must be [Comparable].
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([3, 1, 2]);
  /// list.sort(); // [1, 2, 3]
  ///
  /// final names = ReactiveList<String>(['Charlie', 'Alice', 'Bob']);
  /// names.sort((a, b) => b.compareTo(a)); // ['Charlie', 'Bob', 'Alice']
  /// ```
  @override
  void sort([int Function(T, T)? compare]) {
    super.value.sort(compare);
    _scheduleRefresh();
  }

  /// Returns a new list containing elements from [start] to [end].
  ///
  /// Note: Returns a non-reactive [List]. Modifications won't trigger updates.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2, 3, 4, 5]);
  /// final sub = list.sublist(1, 4); // [2, 3, 4]
  /// ```
  @override
  List<T> sublist(int start, [int? end]) {
    return super.value.sublist(start, end);
  }

  /// Removes the first occurrence of [element] from the list.
  ///
  /// Returns `true` if [element] was removed, `false` if not found.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2, 3, 2]);
  /// list.remove(2); // true, list is now [1, 3, 2]
  /// list.remove(5); // false
  /// ```
  @override
  bool remove(Object? element) {
    final status = super.value.remove(element);
    if (status) {
      _scheduleRefresh();
    }
    return status;
  }

  /// Removes and returns the last element of the list.
  ///
  /// Throws [RangeError] if the list is empty.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2, 3]);
  /// final last = list.removeLast(); // 3, list is now [1, 2]
  /// ```
  @override
  T removeLast() {
    final result = super.value.removeLast();
    _scheduleRefresh();
    return result;
  }

  /// Removes all elements that satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2, 3, 4, 5]);
  /// list.removeWhere((n) => n % 2 == 0); // [1, 3, 5]
  /// ```
  @override
  void removeWhere(bool Function(T) test) {
    super.value.removeWhere(test);
    _scheduleRefresh();
  }

  /// Removes and returns the element at [index].
  ///
  /// Throws [RangeError] if [index] is out of bounds.
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<String>(['a', 'b', 'c']);
  /// final removed = list.removeAt(1); // 'b', list is now ['a', 'c']
  /// ```
  @override
  T removeAt(int index) {
    T result = super.value.removeAt(index);
    _scheduleRefresh();
    return result;
  }

  /// Removes elements in the range from [start] to [end].
  ///
  /// Example:
  /// ```dart
  /// final list = ReactiveList<int>([1, 2, 3, 4, 5]);
  /// list.removeRange(1, 3); // [1, 4, 5]
  /// ```
  @override
  void removeRange(int start, int end) {
    super.value.removeRange(start, end);
    _scheduleRefresh();
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
