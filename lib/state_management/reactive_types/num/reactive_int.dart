part of '../../reactive_types.dart';

/// A specialized version of [Reactive] specifically for integers.
class ReactiveInt extends Reactive<int> {
  /// Constructs a [ReactiveInt] object with the initial [value].
  /// Set [enableHistory] to true to enable undo/redo functionality.
  /// [maxHistorySize] controls how many history states to keep (default: 50).
  ReactiveInt(
    super.value, {
    super.enableHistory,
    super.maxHistorySize,
  });
}

/// A specialized version of [ReactiveN] specifically for nullable integers.
class ReactiveIntN extends ReactiveN<int> {
  /// Constructs a [ReactiveIntN] object with the optional initial [value].
  /// Set [enableHistory] to true to enable undo/redo functionality.
  /// [maxHistorySize] controls how many history states to keep (default: 50).
  ReactiveIntN([
    super.value,
    super.enableHistory,
    super.maxHistorySize,
  ]);
}
