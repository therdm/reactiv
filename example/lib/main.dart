import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const LaunchPage(),
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
            return const TestPageScreen();
          }));
        },
        child: const Text('Next Page'),
      ),
    );
  }
}




class TestPageController extends ReactiveController {
  final ReactiveInt outerCount = 0.reactiv;
  final innerCount = 0.reactiv;
  // List<int> testList = List<int>.empty();

  @override
  void onInit() {
    super.onInit();
    // innerCount.bindStream(outerCount.notifier.stream);
    innerCount.addListener((value) {
      Logger.info(value, tag: 'Listener 1');
    });
    innerCount.addListener((value) {
      Logger.info(value, tag: 'Listener 2');
    });
  }

  incrementOuterCount() {
    outerCount.value++;
  }

  incrementInnerCount() {
    innerCount.value++;
  }
}

class TestPageScreen extends ReactiveStateWidget<TestPageController> {
  const TestPageScreen({Key? key}) : super(key: key, autoDispose: false);

  @override
  TestPageController bindController() => TestPageController();

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
                    listenable: controller.innerCount,
                    listener: (count) {
                      return Center(child: Text('Inner Count : $count'));
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.incrementOuterCount();
                    },
                    child: const Text('+ outer count'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text('hello world'),
                            );
                          });
                    },
                    child: const Text('Dialogue'),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.incrementInnerCount();
        },
        tooltip: 'Increment',
        label: const Text('Inner Count'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
