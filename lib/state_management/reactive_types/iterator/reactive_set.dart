part of '../../reactive_types.dart';

/// A reactive implementation of a set.
///
/// The [ReactiveSet] class extends [Reactive] and implements [SetMixin].
/// It provides reactive capabilities to a standard set by tracking changes
/// and automatically updating the UI when the set is modified.
///
/// Example usage:
/// ```dart
/// final set = ReactiveSet<int>({1, 2, 3});
/// set.add(4);
/// print(set.value); // Output: {1, 2, 3, 4}
/// ```
class ReactiveSet<T> extends Reactive<Set<T>> with SetMixin<T> {
  bool _isRefreshing = false;

  /// Creates a new instance of [ReactiveSet] with the initial value.
  ///
  /// The initial [value] is set for the reactive set variable.
  ReactiveSet(Set<T> value) : super(value);

  @override
  int get length => value.length;

  @override
  @protected
  Set<T> get value {
    return _valueNotifier.value;
  }

  @override
  Iterator<T> get iterator => value.iterator;

  @override
  bool add(T value) {
    final val = _valueNotifier.value.add(value);
    if (val) {
      _scheduleRefresh();
    }
    return val;
  }

  @override
  void addAll(Iterable<T> elements) {
    super.value.addAll(elements);
    _scheduleRefresh();
  }

  @override
  Iterable<T> where(bool Function(T) f) {
    return super.value.where(f);
  }

  @override
  Set<T> toSet() {
    return super.value.toSet();
  }

  @override
  bool remove(Object? value) {
    final status = super.value.remove(value);
    if (status) {
      _scheduleRefresh();
    }
    return status;
  }

  @override
  void removeWhere(bool Function(T) test) {
    super.value.removeWhere(test);
    _scheduleRefresh();
  }

  @override
  bool contains(Object? element) {
    return value.contains(element);
  }

  @override
  T? lookup(Object? element) {
    return value.lookup(element);
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
