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

  @override
  State<ReactiveWidget<T>> createState() => _ReactiveWidgetState<T>();

  T? bindController() {
    return null;
  }

  final bool autoDispose;

  final String? tag;

  Widget build(BuildContext context);

  void onBuildCompleted(BuildContext context) {}

  void initState() {}

  void dispose() {}

  T get controller {
    try {
      return Dependency.find<T>(tag: tag);
    } catch (e) {
      throw 'Exception : Can\'t find $T\n'
          'Please add following code inside $runtimeType \n\n'
          '@override\n'
          '$T bindController() {\n'
          '    return $T();\n'
          '}'
          '\n\nException : class $T is not present in the Dependency store\n';
    }
  }
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
