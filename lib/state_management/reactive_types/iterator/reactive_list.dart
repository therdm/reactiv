part of '../../reactive_types.dart';

/// A specialized implementation of [Reactive] for List<T> values.
///
/// It extends the [Reactive] class and provides specific functionality for List<T> values.
/// Use this class when you need a reactive list variable that can be observed for changes.
class ReactiveList<T> extends Reactive<List<T>> {
  /// Creates a new instance of [ReactiveList] with the initial value.
  ///
  /// The initial [value] is set for the reactive list variable.
  ReactiveList(List<T> value) : super(value);
}

/// A specialized implementation of [ReactiveN] for nullable List<T> values.
///
/// It extends the [ReactiveN] class and provides specific functionality for nullable List<T> values.
/// Use this class when you need a reactive list variable that supports null values and can be observed for changes.
class ReactiveListN<T> extends ReactiveN<List<T>> {
  /// Creates a new instance of [ReactiveListN] with the initial value.
  ///
  /// The initial [value] is set for the reactive list variable.
  ReactiveListN([List<T>? value]) : super(value);
}
