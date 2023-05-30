## About Reactiv [A Reactive approach (reactive/rx)]

Reactive (reactive/rx) state management approach and dependency injection  inspired by GetX

[![picture1.png](https://i.postimg.cc/zf6xrgHv/picture1.png)](https://postimg.cc/XZKfKX86)

## Getting started

This package offers a comprehensive set of functionalities for state management through a reactive approach. Users can define reactive variables by utilizing the `Reactive<T>` class. For example, a user can define a reactive variable like `Reactive<int> data;`, where `data` represents a reactive variable of type `int`.

Within the user interface, developers can leverage the `Observer` widget provided by the package. By using the `listen` parameter of the `Observer` widget and specifying `controller.data`, developers can establish a connection between the widget and the reactive variable. Whenever changes occur in the `data` variable, the corresponding `update` functionality will be triggered, causing the widget to be rebuilt and reflecting the updated state. This ensures that the user interface remains synchronized with the changes in the reactive variable, providing a seamless and reactive user experience.

Alongside state management, this package includes a powerful dependency injection system facilitated by the `Dependency` class. Users can easily inject singleton instances of classes into their application using the `Dependency.put<T>(T dependency)` method. This method allows developers to register and associate a singleton instance of class `T` with the dependency injection system.

To retrieve the registered singleton instance, users can simply use the `Dependency.find<T>()` method. This enables convenient access to the desired dependencies within the application, allowing for efficient and modular code design.

Furthermore, this package offers the flexibility to remove singleton instances from the dependency registry when they are no longer needed. Developers can achieve this by utilizing the `Dependency.delete<T>()` method, which effectively deletes the singleton instance associated with class `T` from the dependency registry.

By combining state management through reactive variables with seamless dependency injection management, this package empowers developers to build highly reactive, modular, and maintainable applications.

## Usage

### With reactiv

#### Controller
```dart
class TestPageController extends ReactiveController {
  final count = ReactiveInt(0);

  increment() {
    count.value++;
  }
}
```

#### View
```dart
class TestPageScreen extends StatelessWidget {
  const TestPageScreen({Key? key}) : super(key: key);

  TestPageController get controller => Dependency.find<TestPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        listen: controller.count,
        update: (count) {
          return Center(child: Text('Count: $count'));
        },
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

### Same functionality With GetX (Rx/Obx)

#### Controller
```dart
class TestPageController extends GetxController {
  final count = RxInt(0);

  increment() {
    count.value++;
  }
}
```

#### View
```dart
class TestPageScreen extends StatelessWidget {
  const TestPageScreen({Key? key}) : super(key: key);

  TestPageController get controller => Get.find<TestPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          final count = controller.count.value;
          return Center(child: Text('Count: $count'));
        },
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

## Advantages of reactiv over GetX

Working with reactiv package is as simple as working with GetX, yet having many advantages over GetX

✅ reactiv (Reactive/Observer):
The Observer in reactiv is aware of the specific cause for its refresh. It listens to a reactive variable, and whenever changes occur in that variable, it updates or refreshes accordingly.
In contrast, GetX(Rx/Obx)'s Obx automatically detects any reactive variable within it and refreshes whenever any of those variables change. However, it doesn't explicitly identify the cause, which can sometimes lead to confusion.

✅ reactiv (Reactive/Observer): It will give you compile time red lines if you do not provide what to listen in a Observer, So, No more relying on run time exception : Improper use of Obx like in GetX

✅ reactiv (Reactive/Observer):
With reactiv, developers tend to write more optimized code as they have explicit control over what to listen to and what to update.
In GetX(Rx/Obx), developers often place the Obx variable at the top of the widget tree of a page, which refreshes the entire page. This approach may result in less optimized code, as it provides more room for writing unoptimized code.

✅ reactiv:
If you are seeking a state management tool with dependency injection capabilities, reactiv focuses solely on those features. It provides a concise API, with fewer than 100 exposed methods, which is standard compared to other state management tools like provider, riverpod, bloc, mobx, etc.
On the other hand, GetX exposes over 2000 APIs which includes various other features like context free route management(I like GoRouter for route management), several widgets, internationalization, GetConnect for network api calls etc, even if you only require state management with dependency injection. Importing such a heavy package might lead to considerations regarding the necessity and impact on your project.

