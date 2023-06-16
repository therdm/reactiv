part of '../../reactive_types.dart';

/// A specialized implementation of [Reactive] for [bool] values.
///
/// It extends the [Reactive] class and provides specific functionality for [bool] values.
/// Use this class when you need a reactive [bool] variable that can be observed for changes.
class ReactiveBool extends Reactive<bool> {
  /// Creates a new instance of [ReactiveString] with the initial value.
  ///
  /// The initial [value] is set for the reactive [bool] variable.
  ReactiveBool(super.value);
}

/// A specialized implementation of [ReactiveN] for nullable [bool] values.
///
/// It extends the [ReactiveN] class and provides specific functionality for nullable [bool] values.
/// Use this class when you need a reactive [bool] variable that supports null values and can be observed for changes.
class ReactiveBoolN extends ReactiveN<bool> {
  /// Creates a new instance of [ReactiveStringN] with the initial value.
  ///
  /// The initial [value] is set for the reactive [bool] variable.
  ReactiveBoolN([super.value]);
}
