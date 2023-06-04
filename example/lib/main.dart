import 'package:example/test_page/second_page.dart';
import 'package:flutter/material.dart';
import 'package:reactiv/controllers/reactive_controller.dart';
import 'package:reactiv/dependency_management/dependency.dart';
import 'package:reactiv/reactiv.dart';
import 'package:reactiv/state_management/reactive_types.dart';

import 'package:reactiv/state_management/widgets/observer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Dependency.put<TestPageController>(TestPageController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LaunchPage(),
    );
  }
}

class LaunchPage extends StatelessWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return TestPageScreen();
          }));
        },
        child: const Text('Next Page'),
      ),
    );
  }
}

class TestPageController extends ReactiveController {
  final count = 0.reactiv;
  final outerCount = 0.reactiv;
  String counterTitle = 'The value of counter : ';

  // final  data = <String>[].reactiv;

  @override
  void onInit() {
    // data[2] = '';
    super.onInit();
  }

  increment() {
    count.value++;
  }
}

class TestPageScreen extends ReactiveView<TestPageController> {
  TestPageScreen({Key? key}) : super(key: key, put: () => TestPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Observer(
            listenable: controller.outerCount,
            listener: (outerCount) {
              return Column(
                children: [
                  Center(child: Text('outer count : $outerCount')),
                  Observer(
                    listenable: controller.count,
                    listener: (value) {
                      return Center(child: Text('1. ${controller.counterTitle} : ${controller.count.value}'));
                    },
                  ),
                  SizedBox(height: 20),
                  Observer(
                    listenable: controller.count,
                    listener: (value) {
                      return Center(child: Text('2. ${controller.counterTitle} : ${controller.count.value}'));
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.outerCount.value++;
                      controller.counterTitle = 'outer count clicked';
                    },
                    child: const Text('Increment'),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          content: Text('hello world'),
                        );
                      });
                    },
                    child: const Text('Dialogue'),
                  ),
                  SizedBox(height: 20),

                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.increment();

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
