import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

class MyCounterController extends ReactiveController {
  final count = ReactiveInt(0);

  Future<void> increment() async {
    await Future.delayed(Duration(seconds: 1));
    count.value++;
  }
}

class CounterScreen extends ReactiveStateWidget<MyCounterController> {
  const CounterScreen({super.key});

  @override
  BindController<MyCounterController>? bindController() {
    return BindController(
        controller: () => MyCounterController(), lazyBind: false);
  }

  @override
  void initStateWithContext(BuildContext context) {
    // TODO: implement initStateWithContext
    super.initStateWithContext(context);
    controller.increment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactiv Counter'),
      ),
      body: CounterScreenBody(),
      floatingActionButton: ReactiveBuilder(
          reactiv: controller.count,
          builder: (context, count) {
            return FloatingActionButton.extended(
              label: Text('Count: $count'),
              onPressed: () async {
                if (count % 2 == 0) {
                  // Simulate a longer operation on even counts
                  await Future.delayed(Duration(seconds: 1), () {
                    controller.increment();
                  });
                } else {}
              },
              // child: const Icon(Icons.add),
            );
          }),
    );
  }
}

class CounterScreenBody extends ReactiveStateWidget<MyCounterController> {
  const CounterScreenBody({super.key});

  @override
  BindController<MyCounterController>? bindController() {
    return BindController(controller: () => MyCounterController());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ReactiveBuilder(
        reactiv: controller.count, // Listen to the reactive variable
        builder: (ctx, count) {
          return Text(
            'Count: $count',
            style: const TextStyle(fontSize: 24),
          );
        },
      ),
    );
  }
}
