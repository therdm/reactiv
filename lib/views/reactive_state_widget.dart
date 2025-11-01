import 'package:flutter/material.dart';
import '../dependency_management/dependency.dart';
import 'bind_controller.dart';

export 'bind_controller.dart';

/// An abstract class for creating reactive views.
///
/// Extend the `ReactiveWidget` class to create a reactive view that depends on a specific controller type.
/// The controller instance can be accessed using the `controller` getter.
abstract class ReactiveStateWidget<T> extends StatefulWidget {
  /// Creates a reactive view.
  ///
  /// The [key] parameter is an optional identifier for this widget.
  const ReactiveStateWidget({Key? key, this.tag}) : super(key: key);

  /// A tag that can be used to differentiate between multiple instances of the same controller type.
  final String? tag;

  /// Retrieves the controller instance associated with this widget.
  ///
  /// Returns the instance of the controller that corresponds to the specified type [T].
  /// If the controller is not found, an exception is thrown.
  T get controller {
    try {
      return Dependency.find<T>(tag: tag);
    } catch (e) {
      throw 'Exception : Can\'t find $T\n'
          'Please add the following code inside $runtimeType:\n\n'
          '@override\n'
          'BindController<$T>? bindController() {\n'
          '   return BindController(controller: $T());\n'
          '}\n\n'
          '\nException: class $T is not present in the Dependency store\n';
    }
  }

  /// Binds a controller instance to this widget.
  ///
  /// Override this method in the subclass to provide an instance of the controller associated with this widget.
  /// Return the instance of the controller that corresponds to the specified type [T].
  BindController<T>? bindController() => null;

  /// Called when the widget is first created.
  ///
  /// Override this method to perform any initialization logic for the widget.
  void initState() {}

  /// Called one frame after [initState].
  ///
  /// Override this method to perform any initialization logic for the widget.
  void initStateWithContext(BuildContext context) {}

  /// Called when the widget is about to be disposed.
  ///
  /// Override this method to perform any cleanup logic for the widget.
  void dispose() {}

  /// Builds the widget's user interface.
  ///
  /// Override this method to provide the widget's UI representation.
  /// The [context] parameter provides the current build context.
  Widget build(BuildContext context);

  @override
  State<ReactiveStateWidget<T>> createState() => _ReactiveStateWidgetState<T>();
}

class _ReactiveStateWidgetState<T> extends State<ReactiveStateWidget<T>> {
  bool _autoDispose = false;

  @override
  void initState() {
    super.initState();
    final dep = widget.bindController();
    if (dep != null) {
      Dependency.put<T>(dep.controller.call(), tag: widget.tag);
      _autoDispose = dep.autoDispose;
    }
    widget.initState();
    widget.initStateWithContext(context);
  }

  @override
  void dispose() {
    widget.dispose();
    if (_autoDispose) Dependency.delete<T>(tag: widget.tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
}
