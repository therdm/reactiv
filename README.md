<div align="center">

# Reactiv

**Production-Ready Reactive State Management for Flutter**

[![pub package](https://img.shields.io/pub/v/reactiv.svg)](https://pub.dev/packages/reactiv)
[![CI](https://github.com/therdm/reactiv/workflows/CI/badge.svg)](https://github.com/therdm/reactiv/actions)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Stars](https://img.shields.io/github/stars/therdm/reactiv?style=social)](https://github.com/therdm/reactiv)

*Lightweight • Powerful • Type-Safe • Production-Ready*

[Get Started](#-quick-start) • [Documentation](#-documentation) • [Examples](#-examples) • [Features](#-key-features)

</div>

---

## 🚀 What is Reactiv?

Reactiv is a **production-ready reactive state management** solution for Flutter that combines simplicity with powerful features. Built with developer experience in mind, it offers:

- ✅ **Zero boilerplate** - Write less code, do more
- ✅ **Type-safe** - Compile-time checks prevent runtime errors
- ✅ **Zero memory leaks** - Smart dependency injection with automatic cleanup
- ✅ **Undo/Redo** - Built-in history tracking
- ✅ **Computed values** - Auto-updating derived state
- ✅ **Debounce/Throttle** - Performance optimization built-in
- ✅ **Robust Logger** - Production-ready logging framework
- ✅ **100% tested** - Battle-tested in production apps

### Why Choose Reactiv?

| Feature | Reactiv | GetX | Provider | Riverpod | BLoC |
|---------|---------|------|----------|----------|------|
| **Lines of Code** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Learning Curve** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Type Safety** | ✅ | ⚠️ | ✅ | ✅ | ✅ |
| **Dependency Injection** | ✅ | ✅ | ❌ | ⚠️ | ❌ |
| **Undo/Redo** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Computed Values** | ✅ | ❌ | ❌ | ✅ | ❌ |
| **Logger Framework** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Package Size** | ~150 APIs | 2400+ APIs | Medium | Large | Large |

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  reactiv: ^1.0.1
```

Then run:

```bash
flutter pub get
```

---

## ⚡ Quick Start

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

### Step 3: Use Observer Widget

Use the `Observer` widget to listen to reactive variables and rebuild the UI when they change:

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
        child: Observer(
          listenable: controller.count,
          listener: (count) {
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

3. **Observer Widget**: The `Observer` widget listens to the `count` reactive variable. Whenever `count.value` changes, only the Observer widget rebuilds—not the entire screen.

4. **State Update**: When you call `controller.increment()`, it updates `count.value`, which automatically triggers the Observer to rebuild with the new value.

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
        child: Observer(
          listenable: controller.count,
          listener: (count) {
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
        child: Observer(
          listenable: controller.count,
          listener: (count) {
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

## 🌟 Key Features

### 1️⃣ Undo/Redo Support (NEW in v1.0.0)

```dart
final text = ReactiveString('Hello', enableHistory: true);

text.value = 'World';
text.value = 'Flutter';

text.undo(); // Back to 'World'
text.redo(); // Forward to 'Flutter'

print(text.canUndo); // true
print(text.canRedo); // false
```

### 2️⃣ Computed Values (NEW in v1.0.0)

Auto-updating derived state:

```dart
final firstName = 'John'.reactiv;
final lastName = 'Doe'.reactiv;

final fullName = ComputedReactive(
  () => '${firstName.value} ${lastName.value}',
  dependencies: [firstName, lastName],
);

firstName.value = 'Jane';
// fullName automatically updates to 'Jane Doe'!
```

### 3️⃣ Debounce & Throttle (NEW in v1.0.0)

Perfect for search inputs and scroll events:

```dart
// Debounce - wait for user to stop typing
final searchQuery = ReactiveString('');
searchQuery.setDebounce(Duration(milliseconds: 500));
searchQuery.updateDebounced('flutter'); // Waits 500ms

// Throttle - limit update frequency
final scrollPosition = ReactiveInt(0);
scrollPosition.setThrottle(Duration(milliseconds: 100));
scrollPosition.updateThrottled(150); // Max once per 100ms
```

### 4️⃣ Lazy Dependency Injection (NEW in v1.0.0)

Controllers created only when needed:

```dart
// Register lazy builder - controller NOT created yet
Dependency.lazyPut(() => ExpensiveController());

// Controller created here, on first access
final controller = Dependency.find<ExpensiveController>();
```

### 5️⃣ Ever & Once Listeners (NEW in v1.0.0)

```dart
// Called on every change
count.ever((value) => print('New value: $value'));

// Called only once, then auto-removed
count.once((value) => showWelcomeDialog());
```

### 6️⃣ Multiple Observer Support

Observe multiple reactive variables:

```dart
Observer2(
  listenable: firstName,
  listenable2: lastName,
  listener: (first, last) => Text('$first $last'),
)

// Or for any number of variables:
ObserverN(
  listenable: [firstName, lastName, age, city],
  listener: () => Text('${firstName.value} ${lastName.value}'),
)
```

### 7️⃣ Type-Safe Reactive Types

Built-in types for common use cases:

```dart
final name = ReactiveString('John');
final age = ReactiveInt(25);
final score = ReactiveDouble(98.5);
final isActive = ReactiveBool(true);
final items = ReactiveList<String>(['A', 'B', 'C']);
final tags = ReactiveSet<String>({'flutter', 'dart'});

// Or use generic for custom types
final user = Reactive<User>(User());
```

### 8️⃣ Smart Dependency Management

```dart
// Register with overwrite warning
Dependency.put(MyController());

// Conditional registration
Dependency.putIfAbsent(() => MyController());

// Check if registered
if (Dependency.isRegistered<MyController>()) {
  // Use it
}

// Fenix mode - auto-recreate after deletion
Dependency.put(MyController(), fenix: true);

// Reset all dependencies
Dependency.reset();
```

### 9️⃣ Robust Logger Framework (NEW in v1.0.1)

Production-ready logging with multiple levels, JSON formatting, and performance tracking:

```dart
// Configure for your environment
Logger.config = kReleaseMode 
    ? LoggerConfig.production   // Minimal logging
    : LoggerConfig.development; // Verbose logging

// Multiple log levels
Logger.v('Verbose trace information');
Logger.d('Debug diagnostic info');
Logger.i('General information');
Logger.w('Warning - potential issue');
Logger.e('Error occurred', error: e, stackTrace: stack);
Logger.wtf('Critical failure!');

// Pretty JSON logging
Logger.json({
  'user': 'John',
  'preferences': {'theme': 'dark'},
});

// Performance timing
final data = await Logger.timed(
  () => api.fetchUsers(),
  label: 'API Call',
);

// Table formatting
Logger.table([
  {'name': 'John', 'age': 30},
  {'name': 'Jane', 'age': 25},
]);

// Headers and dividers
Logger.header('USER REGISTRATION');
Logger.divider();
```

**Logger Features:**
- 🎨 **6 Log Levels**: Verbose, Debug, Info, Warning, Error, WTF
- 📊 **Pretty JSON**: Automatic indentation and formatting
- ⏱️ **Performance Timing**: Measure async/sync function execution
- 📋 **Table Formatting**: Display structured data beautifully
- 🎯 **Stack Traces**: Full error debugging support
- 🌈 **ANSI Colors**: Color-coded terminal output
- ⚙️ **Configurable**: Dev/Production/Testing presets
- 🔌 **Custom Handlers**: Integrate with analytics services

**Quick Configuration:**
```dart
Logger.config = LoggerConfig(
  enabled: true,
  minLevel: LogLevel.debug,
  showTimestamp: true,
  prettyJson: true,
);
```

📚 [Full Logger Documentation](doc/LOGGER.md)

---

## 📚 Documentation

### Core Concepts

- 📖 [Getting Started Guide](doc/GETTING_STARTED.md) - Step-by-step tutorial
- 📚 [API Reference](doc/API_REFERENCE.md) - Complete API documentation
- 🚀 [Advanced Patterns](doc/ADVANCED.md) - Best practices & patterns
- ⚡ [Quick Reference](QUICK_REFERENCE.md) - Cheat sheet
- 🆕 [What's New in v1.0.0](NEW_FEATURES.md) - New features guide
- 📝 [Logger Framework](doc/LOGGER.md) - Complete logging documentation

### Migration & Upgrading

- ✅ **From 0.3.x to 1.0.0**: No changes needed! 100% backward compatible
- ✅ **From GetX**: Similar API, easier to learn
- ✅ **From Provider/Riverpod**: Less boilerplate, same power

---

## 💡 Examples

### Basic Counter
```dart
final count = ReactiveInt(0);

Observer(
  listenable: count,
  listener: (value) => Text('Count: $value'),
)
```

### Search with Debounce
```dart
class SearchController extends ReactiveController {
  final searchQuery = ReactiveString('');
  final results = ReactiveList<String>([]);

  SearchController() {
    searchQuery.setDebounce(Duration(milliseconds: 500));
    searchQuery.ever((query) => _performSearch(query));
  }

  void updateQuery(String query) {
    searchQuery.updateDebounced(query);
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      results.clear();
      return;
    }
    final data = await api.search(query);
    results.value = data;
  }
}
```

### Form with Undo/Redo
```dart
class FormController extends ReactiveController {
  final name = ReactiveString('', enableHistory: true);
  final email = ReactiveString('', enableHistory: true);

  bool get canUndo => name.canUndo || email.canUndo;
  
  void undoAll() {
    if (name.canUndo) name.undo();
    if (email.canUndo) email.undo();
  }
}
```

### Shopping Cart with Computed Total
```dart
class CartController extends ReactiveController {
  final items = ReactiveList<CartItem>([]);
  late final ComputedReactive<double> total;

  CartController() {
    total = ComputedReactive(
      () => items.fold(0.0, (sum, item) => sum + item.price),
      dependencies: [items],
    );
  }
}
```

### Logger with Performance Tracking
```dart
class ApiController extends ReactiveController {
  final users = ReactiveList<User>([]);
  
  Future<void> fetchUsers() async {
    // Automatically logs execution time
    await Logger.timed(
      () async {
        Logger.i('Fetching users from API', tag: 'Network');
        
        try {
          final response = await api.getUsers();
          
          // Log response as pretty JSON
          Logger.json(response, tag: 'Network');
          
          users.value = response.users;
          Logger.i('Successfully loaded ${users.length} users');
        } catch (e, stack) {
          // Log error with full stack trace
          Logger.e(
            'Failed to fetch users',
            tag: 'Network',
            error: e,
            stackTrace: stack,
          );
        }
      },
      label: 'Fetch Users API',
      tag: 'Network',
    );
  }
}
```

**📁 [See Full Examples](example/)**

---

## ✅ GetX alternative that does it right

1. **Explicit Listening** - Observer knows exactly what it's listening to (no magic)
2. **Compile-Time Safety** - Red lines if you forget to specify what to listen to
3. **Optimized by Design** - Encourages writing performant code
4. **Focused Package** - ~150 APIs vs GetX's 2400+ APIs
5. **Better Performance** - Batched updates, optimized rebuilds
6. **Production Features** - Undo/redo, computed values, debounce built-in

### Code Comparison

**Reactiv:**
```dart
Observer(
  listenable: controller.count, // Explicit - you know what updates this
  listener: (count) => Text('$count'),
)
```

**GetX:**
```dart
Obx(() {
  // Implicit - any reactive var here triggers rebuild
  final count = controller.count.value;
  return Text('$count');
})
```

---

## 🎯 Best Practices

### ✅ Do's

```dart
// ✅ Use specific observers
Observer(listenable: count, listener: (val) => Text('$val'))

// ✅ Enable history only when needed
final text = ReactiveString('', enableHistory: true);

// ✅ Use computed for derived state
final total = ComputedReactive(() => items.sum(), [items]);

// ✅ Debounce expensive operations
searchQuery.setDebounce(Duration(milliseconds: 500));

// ✅ Use lazy loading for heavy controllers
Dependency.lazyPut(() => HeavyController());

// ✅ Configure Logger for production
Logger.config = kReleaseMode 
    ? LoggerConfig.production 
    : LoggerConfig.development;

// ✅ Use appropriate log levels
Logger.d('User navigated to screen');
Logger.e('Error occurred', error: e, stackTrace: stack);
```

### ❌ Don'ts

```dart
// ❌ Don't use Observer at root of entire page
Observer(
  listenable: controller.anything,
  listener: (_) => EntirePageWidget(), // Rebuilds everything!
)

// ❌ Don't enable history on everything
final x = ReactiveInt(0, enableHistory: true); // Unless you need it

// ❌ Don't forget to dispose
// Always call Dependency.delete() or use autoDispose

// ❌ Don't log sensitive data
Logger.info('User password: $password'); // NEVER!

// ❌ Don't use verbose logging in production
Logger.config = LoggerConfig.development; // In release builds
```

---

## 🔧 Configuration

### Logger Configuration for Different Environments

```dart
import 'package:flutter/foundation.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  // Configure logger based on environment
  if (kReleaseMode) {
    Logger.config = LoggerConfig.production;  // Minimal logging
  } else if (kProfileMode) {
    Logger.config = LoggerConfig.testing;     // Warnings & errors
  } else {
    Logger.config = LoggerConfig.development; // Full logging
  }
  
  runApp(MyApp());
}
```

### Custom Logger Configuration

```dart
Logger.config = LoggerConfig(
  enabled: true,
  minLevel: LogLevel.debug,
  showTimestamp: true,
  showLevel: true,
  prettyJson: true,
  customHandler: (level, message, {tag}) {
    // Send to your analytics service
    if (level.index >= LogLevel.error.index) {
      crashlytics.log(message);
    }
  },
);
```
```

---

## 📊 Performance

Reactiv is designed for performance:

- ✅ **Batched Updates**: Multiple mutations = single rebuild
- ✅ **Optimized Observers**: No unnecessary widget rebuilds
- ✅ **Smart Memory Management**: Automatic cleanup, zero leaks
- ✅ **Lazy Loading**: Create controllers only when needed
- ✅ **Debounce/Throttle**: Built-in performance optimization

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Contributors

Thanks to all contributors! ❤️

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

## 🌟 Show Your Support

If you like Reactiv, please:

- ⭐ Star the repo on [GitHub](https://github.com/therdm/reactiv)
- 👍 Like the package on [pub.dev](https://pub.dev/packages/reactiv)
- 📢 Share with the Flutter community
- 🐛 Report issues or suggest features

---

## 📞 Support & Community

- 🐛 [Issue Tracker](https://github.com/therdm/reactiv/issues)
- 💬 [Discussions](https://github.com/therdm/reactiv/discussions)
- 📧 Email: [Your Email]
- 🐦 Twitter: [Your Twitter]

---

<div align="center">

**Made with ❤️ for the Flutter Community**

[Get Started](#-quick-start) • [View on GitHub](https://github.com/therdm/reactiv) • [pub.dev](https://pub.dev/packages/reactiv)

</div>


