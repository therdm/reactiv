import 'package:flutter/material.dart';
import '../dependency_management/dependency.dart';

/// An abstract class for creating reactive views.
///
/// Extend the `ReactiveView` class to create a reactive view that depends on a specific controller type.
/// The controller instance can be accessed using the `controller` getter.
abstract class ReactiveView<T> extends StatelessWidget {
  /// Creates a reactive view.
  ///
  /// The [key] parameter is an optional identifier for this widget.
  const ReactiveView({Key? key}) : super(key: key);

  /// Retrieves the controller instance from the dependency registry.
  ///
  /// Use this getter to access the controller instance associated with the reactive view.
  T get controller => Dependency.find<T>();

  @override
  Widget build(BuildContext context);
}
