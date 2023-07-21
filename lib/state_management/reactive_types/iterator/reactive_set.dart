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
class ReactiveSet<T> extends Reactive<Set<T>> with SetMixin<T> {
  /// Creates a new instance of [ReactiveList] with the initial value.
  ///
  /// The initial [value] is set for the reactive list variable.
  ReactiveSet(Set<T> value) : super(value);

  @override
  int get length => value.length;

  @override
  @protected
  Set<T> get value {
    return _value;
  }

  @override
  Iterator<T> get iterator => value.iterator;

  @override
  bool add(T value) {
    final val = _value.add(value);
    refresh();
    return val;
  }

  @override
  void addAll(Iterable<T> elements) {
    super.value.addAll(elements);
    refresh();
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
    refresh();
    return status;
  }

  @override
  void removeWhere(bool Function(T) test) {
    super.value.removeWhere(test);
    refresh();
  }

  @override
  bool contains(Object? element) {
    // TODO: implement contains
    throw UnimplementedError();
  }

  @override
  T? lookup(Object? element) {
    // TODO: implement lookup
    throw UnimplementedError();
  }
}
