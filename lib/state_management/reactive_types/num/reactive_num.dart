part of '../../reactive_types.dart';

/// A specialized version of [Reactive] specifically for integers.
class ReactiveNum extends Reactive<num> {
  /// Constructs a [ReactiveInt] object with the initial [value].
  ReactiveNum(num value) : super(value);
}

/// A specialized version of [ReactiveN] specifically for nullable integers.
class ReactiveNumN extends ReactiveN<num> {
  /// Constructs a [ReactiveIntN] object with the optional initial [value].
  ReactiveNumN([num? value]) : super(value);
}

