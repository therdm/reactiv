part of '../../reactive_types.dart';

/// A specialized version of [Reactive] specifically for integers.
class ReactiveInt extends Reactive<int> {
  /// Constructs a [ReactiveInt] object with the initial [value].
  ReactiveInt(int value) : super(value);
}

/// A specialized version of [ReactiveN] specifically for nullable integers.
class ReactiveIntN extends ReactiveN<int> {
  /// Constructs a [ReactiveIntN] object with the optional initial [value].
  ReactiveIntN([int? value]) : super(value);
}


/// Extension methods for the [int] class to enable reactive capabilities.
extension IntExtension on int {

  /// Converts a standard [int] into a [ReactiveInt] with reactive capabilities.
  ReactiveInt get reactiv => ReactiveInt(this);

}


