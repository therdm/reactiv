import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

part 'observer_n.dart';

/// A widget that rebuilds when a reactive variable changes.
///
/// [Observer] automatically listens to a [Reactive] variable and rebuilds
/// its child widget whenever the variable's value changes. This provides
/// a declarative way to create reactive UI without manually managing listeners.
///
/// The widget is lightweight and efficient, using Flutter's [ValueListenableBuilder]
/// internally for optimal performance.
///
/// Example:
/// ```dart
/// final counter = Reactive<int>(0);
///
/// Observer<int>(
///   listenable: counter,
///   listener: (value) => Text('Count: $value'),
/// );
///
/// // Updates automatically when counter changes
/// counter.value++;
/// ```
///
/// For nullable types, use [ObserverN] instead.
class Observer<T> extends StatefulWidget {
  /// Creates an [Observer] widget.
  ///
  /// The [listenable] parameter specifies which reactive variable to observe.
  /// The [listener] callback builds the widget tree using the current value.
  ///
  /// Example:
  /// ```dart
  /// final username = Reactive<String>('Guest');
  ///
  /// Observer<String>(
  ///   listenable: username,
  ///   listener: (name) => Text('Welcome, $name!'),
  /// );
  /// ```
  const Observer({
    Key? key,
    required this.listenable,
    required this.listener,
  }) : super(key: key);

  /// The reactive variable to observe for changes.
  final Reactive<T> listenable;

  /// Builder function called with the current value whenever it changes.
  ///
  /// This function should return the widget tree to display based on [value].
  final Widget Function(T value) listener;

  @override
  State<Observer<T>> createState() => _ObserverState<T>();
}

/// Internal state for [Observer] widget.
class _ObserverState<T> extends State<Observer<T>> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: widget.listenable.valueNotifier,
      builder: (BuildContext context, T value, Widget? child) {
        return widget.listener(value);
      },
    );
  }
}
