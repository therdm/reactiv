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


extension IntExtension on int {
  ReactiveInt get reactiv => ReactiveInt(this);
}


