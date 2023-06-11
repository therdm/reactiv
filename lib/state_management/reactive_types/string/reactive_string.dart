part of '../../reactive_types.dart';

/// A specialized implementation of [Reactive] for [String] values.
///
/// It extends the [Reactive] class and provides specific functionality for [String] values.
/// Use this class when you need a reactive [String] variable that can be observed for changes.
class ReactiveString extends Reactive<String> {
  /// Creates a new instance of [ReactiveString] with the initial value.
  ///
  /// The initial [value] is set for the reactive [String] variable.
  ReactiveString(super.value);
}

/// A specialized implementation of [ReactiveN] for nullable [String] values.
///
/// It extends the [ReactiveN] class and provides specific functionality for nullable [String] values.
/// Use this class when you need a reactive [String] variable that supports null values and can be observed for changes.
class ReactiveStringN extends ReactiveN<String> {
  /// Creates a new instance of [ReactiveStringN] with the initial value.
  ///
  /// The initial [value] is set for the reactive [String] variable.
  ReactiveStringN([super.value]);
}


