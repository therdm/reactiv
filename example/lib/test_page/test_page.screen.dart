import 'package:example/test_page/test_page.controller.dart';
import 'package:flutter/material.dart';
import 'package:reactiv/dependency_injection/dependency.dart';
import 'package:reactiv/state_management/widgets/observer.dart';

class TestPageScreen extends StatelessWidget {
  const TestPageScreen({Key? key}) : super(key: key);

  TestPageController get controller => Dependency.find<TestPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Observer(
          listen: controller.count,
          update: (count) {
            return Center(child: Text('Count: $count'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
