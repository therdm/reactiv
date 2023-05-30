## About reactiv [Reactive (reactive/rx)] 

Reactive (reactive/rx) state management approach and dependency injection  inspired by GetX

## Getting started

This package provides powerful state management capabilities through a reactive approach. 
Users can define reactive variables by utilizing the Reactive<T> class, 
allowing them to create instances of variables with automatic change tracking. 
For example, a user can define a reactive variable like Reactive<int> myVar;, 
where myVar represents a reactive variable of type int.

To consume and react to changes in the reactive variable within the user interface, 
this package offers the Reaction widget. 
By wrapping the desired widget or UI component with the Reaction widget and specifying controller.myVar as the cause, 
the widget will be rebuilt whenever changes occur in myVar. This ensures that the UI stays in sync with the state changes, 
providing a reactive and responsive user experience.

In addition to state management, this package also provides a comprehensive dependency injection system. 
Users can easily inject singleton instances of classes into their application using the provided dependency injection mechanisms. 
This enables the seamless integration of shared instances throughout the application, promoting code re-usability and modular design.

This package includes functionality to find and retrieve instances of singleton classes from the dependency registry. 
This allows users to access the desired dependencies whenever needed within their application. 
Furthermore, the package provides the capability to remove singleton instances from the dependency registry, 
allowing for dynamic management and disposal of dependencies when they are no longer required.

Overall, this package offers a cohesive and efficient solution for reactive state management along with dependency injection support, 
empowering developers to build robust and highly modular applications.

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
