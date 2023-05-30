import 'dart:async';

import '../../core/reactive_notifier.dart';

class Reactive<T> {
  late T _value;
  late final StreamController<T> _streamController;

  Reactive(T value) {
    this._value = value;
    _streamController = StreamController<T>();
    _streamController.sink.add(value);
  }

  T get value => this._value;

  set value(T value) {
    this._value = value;
    _streamController.sink.add(this._value);
  }

  ReactiveNotifier<T> get notifier {
    return ReactiveNotifier(_streamController.stream);
  }

  close() {
    _streamController.close();
  }
}


class ReactiveN<T> extends Reactive<T?>{
  ReactiveN([super.value]);
}

