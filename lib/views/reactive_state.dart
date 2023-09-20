import 'package:flutter/material.dart';
import 'package:reactiv/controllers/reactive_controller.dart';
import 'package:reactiv/dependency_management/dependency.dart';

import 'bind_controller.dart';

export 'bind_controller.dart';

abstract class ReactiveState<T extends StatefulWidget, S extends ReactiveController> extends State<T> {
  final String? tag;

  ReactiveState({this.tag});

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

  BindController<S>? bindController() => null;

  bool _autoDispose = false;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    final dep = bindController();
    if (dep != null) {
      Dependency.put<S>(dep.controller.call(), tag: tag);
      _autoDispose = dep.autoDispose;
    }
  }

  @override
  Widget build(BuildContext context);

  @override
  @mustCallSuper
  void dispose() {
    if (_autoDispose) Dependency.delete<S>();
    super.dispose();
  }
}
