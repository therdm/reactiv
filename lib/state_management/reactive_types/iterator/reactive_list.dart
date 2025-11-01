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
    refresh();
  }

  @override
  Iterator<T> get iterator => value.iterator;

  @override
  void operator []=(int index, T val) {
    _valueNotifier.value[index] = val;
    refresh();
  }

  /// Special override to push() element(s) in a reactive way
  /// inside the List,
  @override
  ReactiveList<T> operator +(Iterable<T> val) {
    addAll(val);
    refresh();
    return this;
  }

  @override
  T operator [](int index) {
    return value[index];
  }

  @override
  void add(T element){
    super.value.add(element);
    refresh();
  }

  @override
  void addAll(Iterable<T> iterable){
    super.value.addAll(iterable);
    refresh();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _valueNotifier.value.insertAll(index, iterable);
    refresh();
  }

  @override
  Iterable<T> where(bool Function(T) test){
    return super.value.where(test);
  }

  @override
  int indexWhere(bool Function(T) test, [int start = 0]){
    return super.value.indexWhere(test, start);
  }

  @override
  Set<T> toSet(){
    return super.value.toSet();
  }

  @override
  void sort([int Function(T, T)? compare]){
    super.value.sort(compare);
    refresh();
  }

  @override
  List<T> sublist(int start, [int? end]){
    return super.value.sublist(start, end);
  }

  @override
  bool remove(Object? element){
    final status = super.value.remove(element);
    refresh();
    return status;
  }

  @override
  T removeLast(){
    final result = super.value.removeLast();
    refresh();
    return result;
  }

  @override
  void removeWhere(bool Function(T) test){
    super.value.removeWhere(test);
    refresh();
  }

  @override
  T removeAt(int index){
    T result = super.value.removeAt(index);
    refresh();
    return result;
  }

  @override
  void removeRange(int start, int end){
    super.value.removeRange(start, end);
    refresh();
  }

}


