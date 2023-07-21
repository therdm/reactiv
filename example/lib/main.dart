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
            return const CounterScreen();
          }));
        },
        child: const Text('Next Page'),
      ),
    );
  }
}

class CounterController extends ReactiveController {
  final count = ReactiveInt(0);

  void increment() {
    count.value++;
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  void initState() {
    super.initState();

    ///Inject Dependency => Controller instance
    Dependency.put(CounterController());
  }

  final redScaffold = ReactiveBool(false);

  @override
  Widget build(BuildContext context) {
    ///Find Dependency => Controller instance
    final controller = Dependency.find<CounterController>();
    return Observer(
        listenable: redScaffold,
        listener: (isRedScaffold) {
          return Scaffold(
            backgroundColor: isRedScaffold ? Colors.red : null,
            appBar: AppBar(
              title: const Text('Reactiv Counter'),
            ),
            body: Center(
              child: Observer(
                listenable: controller.count, // Listen to the reactive variable
                listener: (count) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          suffix: isRedScaffold ? Icon(Icons.delete) : null,
                          // suffixIcon: IconButton(
                          //     icon: isRedScaffold ? Icon(Icons.delete) : Icon(Icons.arrow_right_outlined),
                          //     onPressed: () {})
                        ),
                      ),
                      Text(
                        'Count: $count',
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                controller.increment();
              },
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}
