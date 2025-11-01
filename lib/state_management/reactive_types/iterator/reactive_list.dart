part of '../../reactive_types.dart';

/// A reactive implementation of a list.
///
/// The [ReactiveList] class extends [Reactive] and implements [ListMixin].
/// It provides reactive capabilities to a standard list by tracking changes
/// and automatically updating the UI when the list is modified.
///
/// Example usage:
/// ```dart
/// final list = ReactiveList<int>([1, 2, 3]);
/// list.add(4);
/// print(list.value); // Output: [1, 2, 3, 4]
/// ```
class ReactiveList<T> extends Reactive<List<T>> with ListMixin<T> {
  bool _isRefreshing = false;

  /// Creates a new instance of [ReactiveList] with the initial value.
  ///
  /// The initial [value] is set for the reactive list variable.
  ReactiveList(List<T> value) : super(value);

  @override
  int get length => value.length;

  @override
  @protected
  List<T> get value {
    return _valueNotifier.value;
  }

  @override
  set length(int newLength) {
    _valueNotifier.value.length = newLength;
    _scheduleRefresh();
  }

  @override
  Iterator<T> get iterator => value.iterator;

  @override
  void operator []=(int index, T val) {
    _valueNotifier.value[index] = val;
    _scheduleRefresh();
  }

  /// Special override to push() element(s) in a reactive way inside the List
  @override
  ReactiveList<T> operator +(Iterable<T> val) {
    addAll(val);
    return this;
  }

  @override
  T operator [](int index) {
    return value[index];
  }

  @override
  void add(T element) {
    super.value.add(element);
    _scheduleRefresh();
  }

  @override
  void addAll(Iterable<T> iterable) {
    super.value.addAll(iterable);
    _scheduleRefresh();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _valueNotifier.value.insertAll(index, iterable);
    _scheduleRefresh();
  }

  @override
  Iterable<T> where(bool Function(T) test) {
    return super.value.where(test);
  }

  @override
  int indexWhere(bool Function(T) test, [int start = 0]) {
    return super.value.indexWhere(test, start);
  }

  @override
  Set<T> toSet() {
    return super.value.toSet();
  }

  @override
  void sort([int Function(T, T)? compare]) {
    super.value.sort(compare);
    _scheduleRefresh();
  }

  @override
  List<T> sublist(int start, [int? end]) {
    return super.value.sublist(start, end);
  }

  @override
  bool remove(Object? element) {
    final status = super.value.remove(element);
    if (status) {
      _scheduleRefresh();
    }
    return status;
  }

  @override
  T removeLast() {
    final result = super.value.removeLast();
    _scheduleRefresh();
    return result;
  }

  @override
  void removeWhere(bool Function(T) test) {
    super.value.removeWhere(test);
    _scheduleRefresh();
  }

  @override
  T removeAt(int index) {
    T result = super.value.removeAt(index);
    _scheduleRefresh();
    return result;
  }

  @override
  void removeRange(int start, int end) {
    super.value.removeRange(start, end);
    _scheduleRefresh();
  }

  /// Schedules a refresh to avoid multiple refreshes in a single frame
  void _scheduleRefresh() {
    if (_isRefreshing) return;

    _isRefreshing = true;
    Future.microtask(() {
      refresh();
      _isRefreshing = false;
    });
  }
}
