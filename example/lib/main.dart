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
            return CounterScreen();
          }));
        },
        child: const Text('Next Page'),
      ),
    );
  }
}

class CounterController extends ReactiveController {
  final count = ReactiveList<int>([0]);
  final testCount = ReactiveInt(0);



  void increment() {
    count.add(count.length);
  }

  void incrementTestCount() {
    testCount.value++;
  }
}

class CounterScreen extends StatelessWidget {
  CounterScreen({super.key});

  final controller = Dependency.put(CounterController());
  final testCount = '0'.reactiv;
  final redScaffold = ReactiveBool(false);

  @override
  Widget build(BuildContext context) {
    ///Find Dependency => Controller instance
    // final controller = Dependency.find<CounterController>();
    return Observer(
        listenable: redScaffold,
        listener: (isRedScaffold) {
          return Scaffold(
            backgroundColor: isRedScaffold ? Colors.red : null,
            appBar: AppBar(
              title: const Text('Reactiv Counter'),
            ),
            body: Center(
              child: ObserverN(
                listenable: <Reactive>[controller.count, controller.testCount, testCount],
                listener: () {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          suffix: isRedScaffold ? const Icon(Icons.delete) : null,
                        ),
                      ),
                      Text(
                        'Count controller.count: ${controller.count}',
                        style: const TextStyle(fontSize: 24),
                      ),
                      Text(
                        'Count testCount: ${testCount.value}',
                        style: const TextStyle(fontSize: 24),
                      ),
                      Text(
                        'Count controller.testCount: ${controller.testCount.value}',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  );
                },
              ),
            ),
            bottomNavigationBar: ElevatedButton(
                onPressed: () {
                  redScaffold.value = !redScaffold.value;
                },
                child: Text('Change Scaffold')),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    controller.increment();
                  },
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () {
                    testCount.value = (int.parse(testCount.value) + 1).toString();
                  },
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () {
                    controller.incrementTestCount();
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          );
        });
  }
}
