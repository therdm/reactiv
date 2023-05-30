import 'package:flutter/material.dart';
import '../dependency_management/dependency.dart';

abstract class ReactiveView<T> extends StatelessWidget {
  const ReactiveView({Key? key}) : super(key: key);


  T get controller => Dependency.find<T>();

  @override
  Widget build(BuildContext context);
}