part of '../../reactive_types.dart';

/// A specialized implementation of [Reactive] for double values.
///
/// It extends the [Reactive] class and provides specific functionality for double values.
/// Use this class when you need a reactive double variable that can be observed for changes.
class ReactiveDouble extends Reactive<double> {
  /// Creates a new instance of [ReactiveDouble] with the initial value.
  ///
  /// The initial [value] is set for the reactive double variable.
  /// Set [enableHistory] to true to enable undo/redo functionality.
  /// [maxHistorySize] controls how many history states to keep (default: 50).
  ReactiveDouble(
    super.value, {
    super.enableHistory,
    super.maxHistorySize,
  });
}

/// A specialized implementation of [ReactiveN] for nullable [double] values.
///
/// It extends the [ReactiveN] class and provides specific functionality for nullable [double] values.
/// Use this class when you need a reactive [double] variable that supports null values and can be observed for changes.
class ReactiveDoubleN extends ReactiveN<double> {
  /// Creates a new instance of [ReactiveDoubleN] with the initial value.
  ///
  /// The initial [value] is set for the reactive double variable.
  /// Set [enableHistory] to true to enable undo/redo functionality.
  /// [maxHistorySize] controls how many history states to keep (default: 50).
  ReactiveDoubleN([
    super.value,
    super.enableHistory,
    super.maxHistorySize,
  ]);
}
