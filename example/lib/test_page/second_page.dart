import 'package:example/test_page/test_page.controller.dart';
import 'package:flutter/material.dart';
import 'package:reactiv/dependency_management/dependency.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TestPageController controller = Dependency.find<TestPageController>();
    return Scaffold(
      appBar: AppBar(),

    );
  }
}
