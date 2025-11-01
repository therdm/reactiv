import 'package:flutter/material.dart';
import 'package:reactiv/controllers/reactive_controller.dart';
import 'package:reactiv/dependency_management/dependency.dart';

import 'bind_controller.dart';

export 'bind_controller.dart';

/// Base state class for widgets with reactive controllers.
///
/// [ReactiveState] provides automatic controller lifecycle management with
/// dependency injection. It handles controller creation, registration, and
/// disposal, allowing you to focus on building your UI.
///
/// Example:
/// ```dart
/// class CounterController extends ReactiveController {
///   final count = Reactive<int>(0);
///   void increment() => count.value++;
/// }
///
/// class CounterPage extends StatefulWidget {
///   @override
///   State<CounterPage> createState() => _CounterPageState();
/// }
///
/// class _CounterPageState extends ReactiveState<CounterPage, CounterController> {
///   @override
///   BindController<CounterController> bindController() {
///     return BindController(() => CounterController());
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Observer(
///       listenable: controller.count,
///       listener: (value) => Text('$value'),
///     );
///   }
/// }
/// ```
abstract class ReactiveState<T extends StatefulWidget,
    S extends ReactiveController> extends State<T> {
  /// Optional tag for distinguishing multiple instances of the same controller.
  final String? tag;

  /// Creates a [ReactiveState] with an optional [tag].
  ///
  /// The [tag] allows multiple instances of the same controller type to coexist
  /// in the dependency system.
  ReactiveState({this.tag});

  /// Access the controller instance.
  ///
  /// The controller is retrieved from the dependency store. If not found,
  /// an exception is thrown with instructions on how to bind it.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   controller.someMethod();
  ///   return Observer(
  ///     listenable: controller.someReactive,
  ///     listener: (value) => Text('$value'),
  ///   );
  /// }
  /// ```
  S get controller {
    try {
      return Dependency.find<S>(tag: tag);
    } catch (e) {
      throw 'Exception : Can\'t find $S\n'
          'Please add the following code inside $runtimeType:\n\n'
          '@override\n'
          '$S bindController() => () => $S();\n'
          '\nException: class $S is not present in the Dependency store\n';
    }
  }

  /// Binds a controller to this state.
  ///
  /// Override this method to provide your controller instance and configuration.
  /// Return `null` if you're managing the controller lifecycle manually.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// BindController<MyController> bindController() {
  ///   return BindController(
  ///     () => MyController(),
  ///     autoDispose: true,  // Auto-dispose when widget is removed
  ///     lazyBind: false,    // Create immediately
  ///   );
  /// }
  /// ```
  BindController<S>? bindController() => null;

  /// Flag indicating if controller should be disposed automatically.
  bool _autoDispose = false;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    final dep = bindController();
    if (dep != null) {
      if (dep.lazyBind) {
        Dependency.lazyPut<S>(() => dep.controller.call(), tag: tag);
      } else {
        Dependency.put<S>(dep.controller.call(), tag: tag);
      }

      _autoDispose = dep.autoDispose;
    }
  }

  /// Build your widget tree here using [controller].
  @override
  Widget build(BuildContext context);

  @override
  @mustCallSuper
  void dispose() {
    if (_autoDispose) Dependency.delete<S>();
    super.dispose();
  }
}
