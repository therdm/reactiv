import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';
import 'advanced_features_example.dart' as afe;

void main() {
  runApp(const afe.MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reactiv Counter Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CounterScreen(),
    );
  }
}

/// A simple counter controller demonstrating Reactiv state management
class CounterController extends ReactiveController {
  // Define a reactive integer variable
  final count = ReactiveInt(0);

  // Method to increment the counter
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
    // Inject the controller instance
    Dependency.put<CounterController>(CounterController());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    Dependency.delete<CounterController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Find the controller instance
    final controller = Dependency.find<CounterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactiv Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Observer widget listens to the reactive variable
            Observer(
              listenable: controller.count,
              listener: (count) {
                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.headlineLarge,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
