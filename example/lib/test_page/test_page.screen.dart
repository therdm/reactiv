import 'package:example/test_page/second_page.dart';
import 'package:example/test_page/test_page.controller.dart';
import 'package:flutter/material.dart';
import 'package:reactiv/dependency_injection/dependency.dart';
import 'package:reactiv/state_management/widgets/reaction.dart';


class TestPageScreen extends StatelessWidget {
  const TestPageScreen({Key? key}) : super(key: key);

  TestPageController get controller => Dependency.find<TestPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Reaction2(
          cause: controller.count,
          cause2: controller.title,
          effect: (count, title) {
            return Scaffold(
              body: Column(
                children: [
                  Text('Count: $count'),
                  TextField(
                    onChanged: (value) {
                      controller.title.value = value;
                    },
                  ),
                  Text('Title : $title'),
                  FilledButton(
                    onPressed: () {
                      // showDialog(context: context, builder: (_) {
                      //   return Text('Dialog');
                      // });
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Test SnackBar')),
                      // );
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                        return const SecondPage();
                      }));
                    },
                    child: const Text('Show SnackBar'),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Dependency.delete<TestPageController>();
                  controller.increment();
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            );
          },
        ),
      ),
    );
  }
}
