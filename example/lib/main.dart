import 'package:flutter/material.dart';
import 'package:reactiv/controllers/reactive_controller.dart';
import 'package:reactiv/dependency_management/dependency.dart';
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
      body: TestPageScreen(),
    );
  }
}

class TestPageController extends ReactiveController {
  final count = ReactiveInt(0);

  @override
  void onInit() {
    super.onInit();
  }

  increment() {
    count.value++;
  }
}

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
