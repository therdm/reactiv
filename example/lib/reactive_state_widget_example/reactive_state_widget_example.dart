import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

class MyCounterController extends ReactiveController {
  final count = ReactiveInt(0);

  void increment() {
    count.value++;
  }
}

class CounterScreen extends ReactiveStateWidget<MyCounterController> {
  const CounterScreen({super.key});

  @override
  BindController<MyCounterController>? bindController() {
    return BindController(
      controller: MyCounterController(),
      autoDispose: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactiv Counter'),
      ),
      body: Center(
        child: Observer(
          listenable: controller.count, // Listen to the reactive variable
          listener: (count) {
            return Text(
              'Count: $count',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
