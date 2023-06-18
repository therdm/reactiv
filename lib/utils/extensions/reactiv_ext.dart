import 'package:reactiv/state_management/reactive_types.dart';

extension ReactiveT<T> on T {
  /// Returns a `Reactive` instance with [this] `T` as initial value.
  Reactive<T> get reactiv => Reactive<T>(this);
}

/// Extension methods for the [List] class to enable reactive capabilities.
extension ListExtension<E> on List<E> {
  /// Converts a standard [List] into a [ReactiveList] with reactive capabilities.
  ReactiveList<E> get reactiv => ReactiveList<E>(this);
}


/// Extension methods for the [double] class to enable reactive capabilities.
extension DoubleExtension on double {

  /// Converts a standard [double] into a [ReactiveDouble] with reactive capabilities.
  ReactiveDouble get reactiv => ReactiveDouble(this);
}


/// Extension methods for the [int] class to enable reactive capabilities.
extension IntExtension on int {

  /// Converts a standard [int] into a [ReactiveInt] with reactive capabilities.
  ReactiveInt get reactiv => ReactiveInt(this);

}

/// Extension methods for the [bool] class to enable reactive capabilities.
extension BoolExtension on bool {

  /// Converts a standard [bool] into a [ReactiveBool] with reactive capabilities.
  ReactiveBool get reactiv => ReactiveBool(this);
}


/// Extension methods for the [num] class to enable reactive capabilities.
extension NumExtension on num {

  /// Converts a standard [num] into a [ReactiveNum] with reactive capabilities.
  ReactiveNum get reactiv => ReactiveNum(this);
}


/// Extension methods for the [String] class to enable reactive capabilities.
extension StringExtension on String {

  /// Converts a standard [String] into a [ReactiveString] with reactive capabilities.
  ReactiveString get reactiv => ReactiveString(this);
}

