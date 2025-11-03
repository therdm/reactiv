import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

/// Example demonstrating the new ReactiveBuilder and MultiReactiveBuilder widgets
/// This replaces the deprecated Observer widget

class ReactiveBuilderExample extends StatefulWidget {
  const ReactiveBuilderExample({super.key});

  @override
  State<ReactiveBuilderExample> createState() => _ReactiveBuilderExampleState();
}

class _ReactiveBuilderExampleState extends State<ReactiveBuilderExample> {
  @override
  void initState() {
    super.initState();
    Dependency.put<ExampleController>(ExampleController());
  }

  @override
  void dispose() {
    Dependency.delete<ExampleController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Dependency.find<ExampleController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ReactiveBuilder Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Counter with ReactiveBuilder:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // New ReactiveBuilder widget for single reactive
            ReactiveBuilder<int>(
              reactiv: controller.count,
              builder: (context, count) {
                return Text(
                  'Count: $count',
                  style: Theme.of(context).textTheme.headlineLarge,
                );
              },
              listener: (count) {
                debugPrint('Count changed to $count');
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Multiple reactives with MultiReactiveBuilder:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // MultiReactiveBuilder for multiple reactive variables
            MultiReactiveBuilder(
              reactives: [controller.name, controller.age, controller.city],
              builder: (context) {
                return Text(
                  '${controller.name.value}, ${controller.age.value} years old, from ${controller.city.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                );
              },
              listener: () {
                debugPrint('User info changed');
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Nullable reactive with ReactiveBuilder:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // ReactiveBuilder works with nullable types too
            ReactiveBuilder<String?>(
              reactiv: controller.username,
              builder: (context, username) {
                return Text(
                  username ?? 'No username set',
                  style: Theme.of(context).textTheme.titleLarge,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: controller.increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: controller.updateUserInfo,
            tooltip: 'Update User Info',
            child: const Icon(Icons.person),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: controller.toggleUsername,
            tooltip: 'Toggle Username',
            child: const Icon(Icons.swap_horiz),
          ),
        ],
      ),
    );
  }
}

class ExampleController extends ReactiveController {
  final count = ReactiveInt(0);
  final name = Reactive<String>('John');
  final age = Reactive<int>(25);
  final city = Reactive<String>('NYC');
  final username = ReactiveN<String>(null);

  void increment() {
    count.value++;
  }

  void updateUserInfo() {
    final names = ['John', 'Jane', 'Alice', 'Bob', 'Charlie'];
    final cities = ['NYC', 'LA', 'Chicago', 'Boston', 'Seattle'];

    name.value = names[count.value % names.length];
    age.value = 20 + (count.value % 50);
    city.value = cities[count.value % cities.length];
  }

  void toggleUsername() {
    if (username.value == null) {
      username.value = 'user_${count.value}';
    } else {
      username.value = null;
    }
  }
}
