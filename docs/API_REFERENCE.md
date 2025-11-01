# API Reference

This document provides a high-level overview of Reactiv's public API and core concepts.

## Core Concepts

### ReactiveController

The base class for all controllers in Reactiv. Extend this class to create your own controllers.

```dart
class MyController extends ReactiveController {
  // Your reactive variables and methods
}
```

**Lifecycle Methods:**
- `onInit()`: Called after the controller is initialized
- `onReady()`: Called when the widget tree is fully built
- `onClose()`: Called when the controller is being disposed

### Observer Widget

A widget that observes changes in a reactive variable and rebuilds when the variable changes.

```dart
Observer<T>(
  listenable: reactiveVariable,
  listener: (value) => Widget,
)
```

**Parameters:**
- `listenable`: The reactive variable to observe
- `listener`: Callback function that returns the widget to build with the current value

### Reactive Types

Reactiv provides several built-in reactive types for common data types:

| Type | Description | Example |
|------|-------------|---------|
| `Reactive<T>` | Generic reactive type for any data type | `Reactive<String>('hello')` |
| `ReactiveInt` | Reactive integer | `ReactiveInt(0)` |
| `ReactiveDouble` | Reactive double | `ReactiveDouble(0.0)` |
| `ReactiveString` | Reactive string | `ReactiveString('')` |
| `ReactiveBool` | Reactive boolean | `ReactiveBool(false)` |
| `ReactiveNum` | Reactive num | `ReactiveNum(0)` |
| `ReactiveList<T>` | Reactive list | `ReactiveList<int>([])` |
| `ReactiveSet<T>` | Reactive set | `ReactiveSet<int>({})` |

**Common Operations:**

```dart
// Create a reactive variable
final count = ReactiveInt(0);

// Read the value
print(count.value); // 0

// Update the value
count.value = 10;

// Listen to changes
count.addListener(() {
  print('Value changed: ${count.value}');
});
```

### Dependency Injection

Reactiv includes a built-in dependency injection system via the `Dependency` class.

**Methods:**

```dart
// Register a singleton instance
Dependency.put<MyController>(MyController());

// Retrieve the instance
final controller = Dependency.find<MyController>();

// Remove the instance when no longer needed
Dependency.delete<MyController>();
```

### ReactiveStateWidget

A convenience base class that replaces `StatefulWidget` and automatically handles controller lifecycle management.

**Usage:**

```dart
class MyScreen extends ReactiveStateWidget<MyController> {
  const MyScreen({super.key});

  @override
  BindController<MyController>? bindController() {
    // Controller is auto-injected and auto-disposed
    return BindController(controller: () => MyController());
  }

  @override
  Widget build(BuildContext context) {
    // Access controller directly via 'controller' getter
    return Observer(
      listenable: controller.someValue,
      listener: (value) => Text('$value'),
    );
  }
}
```

**Features:**
- Automatically calls `Dependency.put()` in `initState()`
- Automatically calls `Dependency.delete()` in `dispose()` (when `autoDispose: true`)
- Access controller via `controller` getter without calling `Dependency.find()`
- Supports `tag` parameter for multiple instances of same controller type

**BindController Options:**

```dart
BindController(
  controller: () => MyController(),
  autoDispose: true,  // Default: automatically dispose controller
)
```

**Lifecycle Methods:**

```dart
class MyScreen extends ReactiveStateWidget<MyController> {
  @override
  void initState() {
    super.initState();
    // Called when widget is initialized
  }

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    // Called one frame after initState with context
  }

  @override
  void dispose() {
    super.dispose();
    // Called when widget is disposed
  }
}
```

### ReactiveState

A convenience base class that extends `State` for use with `StatefulWidget`, providing automatic controller lifecycle management.

**Usage:**

```dart
class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ReactiveState<MyScreen, MyController> {
  @override
  BindController<MyController>? bindController() {
    return BindController(controller: () => MyController());
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      listenable: controller.someValue,
      listener: (value) => Text('$value'),
    );
  }
}
```

**When to Use:**
- Use `ReactiveStateWidget` for most cases (simpler, less boilerplate)
- Use `ReactiveState` when you need access to all `StatefulWidget` lifecycle methods
- Use `ReactiveState` when integrating with existing `StatefulWidget` code

**Tagged Controllers:**

Both `ReactiveStateWidget` and `ReactiveState` support tags for multiple instances:

```dart
class MyScreen extends ReactiveStateWidget<MyController> {
  const MyScreen({super.key, String? tag}) : super(tag: tag);
  
  @override
  BindController<MyController>? bindController() {
    return BindController(controller: () => MyController());
  }
}

// Usage
MyScreen(tag: 'instance1')
MyScreen(tag: 'instance2')
```

## Advanced Features

### Selectors

While Reactiv doesn't have built-in selectors like some other state management solutions, you can create derived reactive values:

```dart
class UserController extends ReactiveController {
  final firstName = ReactiveString('John');
  final lastName = ReactiveString('Doe');
  
  // Computed property (not reactive by default)
  String get fullName => '${firstName.value} ${lastName.value}';
}
```

For reactive computed values, create a separate reactive variable and update it when dependencies change:

```dart
class UserController extends ReactiveController {
  final firstName = ReactiveString('John');
  final lastName = ReactiveString('Doe');
  final fullName = ReactiveString('');
  
  UserController() {
    _updateFullName();
    firstName.addListener(_updateFullName);
    lastName.addListener(_updateFullName);
  }
  
  void _updateFullName() {
    fullName.value = '${firstName.value} ${lastName.value}';
  }
}
```

### ReactiveList and ReactiveSet

These collections are reactive versions of Dart's List and Set:

```dart
final items = ReactiveList<String>([]);

// Add items (triggers observers)
items.add('item1');
items.addAll(['item2', 'item3']);

// Remove items (triggers observers)
items.remove('item1');
items.clear();

// Access items
print(items.value); // prints the list
print(items[0]); // access by index
```

## Full Documentation

For complete API documentation with all methods and parameters, use Dart's built-in documentation:

```bash
# Generate API documentation
dart doc .
```

The generated documentation will be available in the `doc/api` directory.

## See Also

- [Getting Started Guide](GETTING_STARTED.md) - Step-by-step quickstart
- [Advanced Patterns](ADVANCED.md) - Complex scenarios and best practices
- [Example App](../example) - Working code examples
