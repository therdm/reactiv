part of '../../reactive_types.dart';

/// A specialized version of [Reactive] specifically for num values.
class ReactiveNum extends Reactive<num> {
  /// Constructs a [ReactiveNum] object with the initial [value].
  /// Set [enableHistory] to true to enable undo/redo functionality.
  /// [maxHistorySize] controls how many history states to keep (default: 50).
  ReactiveNum(
    super.value, {
    super.enableHistory,
    super.maxHistorySize,
  });
}

/// A specialized version of [ReactiveN] specifically for nullable num values.
class ReactiveNumN extends ReactiveN<num> {
  /// Constructs a [ReactiveNumN] object with the optional initial [value].
  /// Set [enableHistory] to true to enable undo/redo functionality.
  /// [maxHistorySize] controls how many history states to keep (default: 50).
  ReactiveNumN([
    super.value,
    super.enableHistory,
    super.maxHistorySize,
  ]);
}
