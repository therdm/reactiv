## About reactiv [Reactive (reactive/rx)] 

Reactive (reactive/rx) state management approach and dependency injection  inspired by GetX

## Getting started

This package offers a comprehensive set of functionalities for state management through a reactive approach. Users can define reactive variables by utilizing the `Reactive<T>` class. For example, a user can define a reactive variable like `Reactive<int> data;`, where `data` represents a reactive variable of type `int`.

Within the user interface, developers can leverage the `Observer` widget provided by the package. By using the `listen` parameter of the `Observer` widget and specifying `controller.data`, developers can establish a connection between the widget and the reactive variable. Whenever changes occur in the `data` variable, the corresponding `update` functionality will be triggered, causing the widget to be rebuilt and reflecting the updated state. This ensures that the user interface remains synchronized with the changes in the reactive variable, providing a seamless and reactive user experience.

Alongside state management, this package includes a powerful dependency injection system facilitated by the `Dependency` class. Users can easily inject singleton instances of classes into their application using the `Dependency.put<T>(T dependency)` method. This method allows developers to register and associate a singleton instance of class `T` with the dependency injection system.

To retrieve the registered singleton instance, users can simply use the `Dependency.find<T>()` method. This enables convenient access to the desired dependencies within the application, allowing for efficient and modular code design.

Furthermore, this package offers the flexibility to remove singleton instances from the dependency registry when they are no longer needed. Developers can achieve this by utilizing the `Dependency.delete<T>()` method, which effectively deletes the singleton instance associated with class `T` from the dependency registry.

By combining state management through reactive variables with seamless dependency injection management, this package empowers developers to build highly reactive, modular, and maintainable applications.

## Usage


Controller
```dart
class TestPageController extends ReactiveController {
  final count = ReactiveInt(0);

  @override
  void onInit() {
    super.onInit();
  }

  increment() {
    count.value = (count.value ?? 0) + 1;
  }
}

```

View
```dart
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
```

## Additional information

Stay tuned more to come
