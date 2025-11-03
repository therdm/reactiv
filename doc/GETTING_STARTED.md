# Getting Started with Reactiv

This guide will help you get up and running with Reactiv in your Flutter application.

## Installation

Add Reactiv to your `pubspec.yaml`:

```yaml
dependencies:
  reactiv: ^1.1.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Step 1: Create a Reactive Controller

Create a controller that extends `ReactiveController` and define reactive variables:

```dart
import 'package:reactiv/reactiv.dart';

class CounterController extends ReactiveController {
  // Define a reactive integer variable
  final count = ReactiveInt(0);

  // Method to increment the counter
  void increment() {
    count.value++;
  }
}
```

### Step 2: Inject the Controller

In your widget's `initState` method, inject the controller using the dependency injection system:

```dart
@override
void initState() {
  super.initState();
  // Inject the controller instance
  Dependency.put<CounterController>(CounterController());
}
```

### Step 3: Use ReactiveBuilder Widget

Use the `ReactiveBuilder` widget to listen to reactive variables and rebuild the UI when they change:

```dart
import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  void initState() {
    super.initState();
    Dependency.put<CounterController>(CounterController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Dependency.find<CounterController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Center(
        child: ReactiveBuilder<int>(
          reactiv: controller.count,
          builder: (context, count) {
            return Text(
              'Count: $count',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### What Just Happened?

1. **ReactiveController**: You created a controller that manages your application state. The `ReactiveInt` variable automatically notifies listeners when its value changes.

2. **Dependency Injection**: You used `Dependency.put()` to register the controller instance and `Dependency.find()` to retrieve it. This ensures you're using the same instance throughout your app.

3. **ReactiveBuilder Widget**: The `ReactiveBuilder` widget listens to the `count` reactive variable. Whenever `count.value` changes, only the ReactiveBuilder widget rebuilds—not the entire screen. The builder receives the unwrapped value directly.

4. **State Update**: When you call `controller.increment()`, it updates `count.value`, which automatically triggers the ReactiveBuilder to rebuild with the new value.

## Alternative: Using ReactiveStateWidget

Reactiv provides `ReactiveStateWidget` as a convenient alternative to `StatefulWidget` that handles controller lifecycle management automatically.

### With ReactiveStateWidget (Recommended)

```dart
import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

class CounterScreen extends ReactiveStateWidget<CounterController> {
  const CounterScreen({super.key});

  @override
  BindController<CounterController>? bindController() {
    // Automatically injects and disposes the controller
    return BindController(controller: () => CounterController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Center(
        child: ReactiveBuilder<
          reactiv: controller.count,
          builder: (count) {
            return Text(
              'Count: $count',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Benefits**:
- Controller is automatically injected via `bindController()`
- Controller is automatically disposed when the widget is removed
- Access controller via `controller` getter (no need for `Dependency.find()`)
- Cleaner, less boilerplate code

### Using ReactiveState with StatefulWidget

If you prefer `StatefulWidget`, you can use `ReactiveState`:

```dart
import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends ReactiveState<CounterScreen, CounterController> {
  @override
  BindController<CounterController>? bindController() {
    return BindController(controller: () => CounterController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Center(
        child: ReactiveBuilder<
          reactiv: controller.count,
          builder: (count) {
            return Text(
              'Count: $count',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**When to use ReactiveState**:
- When you need StatefulWidget lifecycle methods
- When you need to manage additional local state
- When integrating with existing StatefulWidget code

## Next Steps

- Check out the [API Reference](API_REFERENCE.md) to learn about all available reactive types and features
- Explore [Advanced Patterns](ADVANCED.md) for complex state management scenarios
- See the [example app](../example) for a complete working implementation
