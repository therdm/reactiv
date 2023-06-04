import 'package:flutter/material.dart';
import '../dependency_management/dependency.dart';


/// An abstract class for creating reactive views.
///
/// Extend the `ReactiveView` class to create a reactive view that depends on a specific controller type.
/// The controller instance can be accessed using the `controller` getter.
abstract class ReactiveWidget<T> extends StatefulWidget {
  /// Creates a reactive view.
  ///
  /// The [key] parameter is an optional identifier for this widget.
  const ReactiveWidget({Key? key, this.autoDispose = false, this.tag}) : super(key: key);

  /// Specifies whether the widget should automatically dispose of its resources when unmounted.
  final bool autoDispose;

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
          '$T bindController() {\n'
          '    return $T();\n'
          '}\n'
          '\nException: class $T is not present in the Dependency store\n';
    }
  }

  /// Binds a controller instance to this widget.
  ///
  /// Override this method in the subclass to provide an instance of the controller associated with this widget.
  /// Return the instance of the controller that corresponds to the specified type [T].
  T? bindController() {
    return null;
  }

  /// Called when the widget is first created.
  ///
  /// Override this method to perform any initialization logic for the widget.
  void initState() {}

  /// Called when the widget is about to be disposed.
  ///
  /// Override this method to perform any cleanup logic for the widget.
  void dispose() {}

  /// Called after the widget is built.
  ///
  /// Override this method to perform any post-build logic for the widget.
  void onBuildCompleted(BuildContext context) {}

  /// Builds the widget's user interface.
  ///
  /// Override this method to provide the widget's UI representation.
  /// The [context] parameter provides the current build context.
  Widget build(BuildContext context);

  @override
  State<ReactiveWidget<T>> createState() => _ReactiveWidgetState<T>();
}


class _ReactiveWidgetState<T> extends State<ReactiveWidget<T>> {

  @override
  void initState() {
    super.initState();
    final dep = widget.bindController();
    if (dep != null) {
      Dependency.put<T>(dep, tag: widget.tag);
    }
    widget.initState();
  }

  @override
  void dispose() {
    widget.dispose();
    if (widget.autoDispose) {
      Dependency.delete<T>(tag: widget.tag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onBuildCompleted(context);
    });
    return widget.build(context);
  }
}
