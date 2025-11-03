import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

part 'reactive_builder_n.dart';

/// A widget that rebuilds when a reactive variable changes.
///
/// [ReactiveBuilder] automatically listens to a [Reactive] variable and rebuilds
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
/// ReactiveBuilder<int>(
///   reactiv: counter,
///   builder: (context, count) {
///     return Text('Count: $count');
///   },
///   listener: (count) {
///     debugPrint('Count changed to $count');
///   },
///   buildWhen: (prev, current) => current % 2 == 0, // Only rebuild on even numbers
///   listenWhen: (prev, current) => current > 10,     // Only listen when > 10
/// );
///
/// // Updates automatically when counter changes
/// counter.value++;
/// ```
///
/// For multiple reactive variables, use [ReactiveBuilderN] instead.
class ReactiveBuilder<T> extends StatefulWidget {
  /// Creates a [ReactiveBuilder] widget.
  ///
  /// The [reactiv] parameter specifies which reactive variable to observe.
  /// The [builder] callback builds the widget tree using the current value.
  /// The optional [listener] callback is invoked whenever the value changes.
  /// The optional [buildWhen] callback determines whether to rebuild the widget.
  /// The optional [listenWhen] callback determines whether to invoke the listener.
  ///
  /// Example:
  /// ```dart
  /// final username = Reactive<String>('Guest');
  ///
  /// ReactiveBuilder<String>(
  ///   reactiv: username,
  ///   builder: (context, name) => Text('Welcome, $name!'),
  ///   listener: (name) => debugPrint('Username changed to $name'),
  ///   buildWhen: (prev, current) => prev != current,
  ///   listenWhen: (prev, current) => current.isNotEmpty,
  /// );
  /// ```
  const ReactiveBuilder({
    Key? key,
    required this.reactiv,
    required this.builder,
    this.listener,
    this.buildWhen,
    this.listenWhen,
  }) : super(key: key);

  /// The reactive variable to observe for changes.
  final Reactive<T> reactiv;

  /// Builder function called with the current value whenever it changes.
  ///
  /// This function should return the widget tree to display based on [value].
  final Widget Function(BuildContext context, T value) builder;

  /// Optional listener function called whenever the value changes.
  ///
  /// This function is invoked before the builder and can be used for
  /// side effects like logging, navigation, or showing snackbars.
  final void Function(T value)? listener;

  /// Optional condition to determine whether the widget should rebuild.
  ///
  /// If provided, the widget will only rebuild when this function returns true.
  /// Receives the previous and current values.
  ///
  /// Example:
  /// ```dart
  /// buildWhen: (prev, current) => prev != current, // Only rebuild if value changed
  /// buildWhen: (prev, current) => current > 0,     // Only rebuild if positive
  /// ```
  final bool Function(T previous, T current)? buildWhen;

  /// Optional condition to determine whether the listener should be invoked.
  ///
  /// If provided, the listener will only be called when this function returns true.
  /// Receives the previous and current values.
  ///
  /// Example:
  /// ```dart
  /// listenWhen: (prev, current) => current > 10,        // Only listen when > 10
  /// listenWhen: (prev, current) => prev != current,     // Only on actual changes
  /// ```
  final bool Function(T previous, T current)? listenWhen;

  @override
  State<ReactiveBuilder<T>> createState() => _ReactiveBuilderState<T>();
}

/// Internal state for [ReactiveBuilder] widget.
class _ReactiveBuilderState<T> extends State<ReactiveBuilder<T>> {
  T? _previousValue;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.reactiv.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: widget.reactiv.valueNotifier,
      builder: (BuildContext context, T value, Widget? child) {
        final previous = _previousValue ?? value;
        
        // Check if listener should be called (not on first build)
        if (widget.listener != null && !_isFirstBuild) {
          final shouldListen = widget.listenWhen?.call(previous, value) ?? true;
          if (shouldListen) {
            // Use post-frame callback to avoid calling listener during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.listener!(value);
            });
          }
        }
        
        // Check if widget should rebuild (not on first build)
        final shouldBuild = _isFirstBuild || (widget.buildWhen?.call(previous, value) ?? true);
        
        // Update state
        _previousValue = value;
        _isFirstBuild = false;
        
        // Return builder or previous child
        if (shouldBuild) {
          return widget.builder(context, value);
        } else {
          // Return child to avoid rebuild
          return child!;
        }
      },
      child: widget.builder(context, widget.reactiv.value),
    );
  }
}
