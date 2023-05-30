part of '../../reactive_types.dart';

/// A generic class representing a reactive variable.
/// It allows tracking and updating the value of the variable.
class Reactive<T> {
  late T _value;
  late final StreamController<T> _streamController;

  /// Constructs a [Reactive] object with the initial [value].
  Reactive(T value) {
    this._value = value;
    _streamController = StreamController<T>();
    _streamController.sink.add(value);
  }

  /// Retrieves the current value of the reactive variable.
  T get value => this._value;

  /// Updates the value of the reactive variable to [value].
  set value(T value) {
    this._value = value;
    _streamController.sink.add(this._value);
  }

  /// Returns a [ReactiveNotifier] object associated with this [Reactive] instance.
  /// The [ReactiveNotifier] allows listening to changes in the reactive variable.
  ReactiveNotifier<T> get notifier {
    return ReactiveNotifier(_streamController.stream);
  }

  /// Closes the underlying stream controller.
  void close() {
    _streamController.close();
  }
}

/// A specialized version of [Reactive] that supports nullable values.
class ReactiveN<T> extends Reactive<T?> {
  ReactiveN([T? value]) : super(value);
}
