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
| **Package Size** | ~150 APIs | 2400+ APIs | Medium | Large | Large |

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  reactiv: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## ⚡ Quick Start

### 1. Create a Controller

```dart
import 'package:reactiv/reactiv.dart';

class CounterController extends ReactiveController {
  // Define reactive variables
  final count = ReactiveInt(0);
  
  // Add business logic
  void increment() => count.value++;
  void decrement() => count.value--;
}
```

### 2. Inject & Use

```dart
class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  void initState() {
    super.initState();
    // Inject the controller
    Dependency.put(CounterController());
  }

  @override
  void dispose() {
    // Clean up
    Dependency.delete<CounterController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Dependency.find<CounterController>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Reactiv Counter')),
      body: Center(
        // Observer automatically rebuilds when count changes
        child: Observer(
          listenable: controller.count,
          listener: (count) => Text(
            'Count: $count',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
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

**That's it!** 🎉 You have a fully functional reactive counter with automatic memory management.

---

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

---

## 📚 Documentation

### Core Concepts

- 📖 [Getting Started Guide](docs/GETTING_STARTED.md) - Step-by-step tutorial
- 📚 [API Reference](docs/API_REFERENCE.md) - Complete API documentation
- 🚀 [Advanced Patterns](docs/ADVANCED.md) - Best practices & patterns
- ⚡ [Quick Reference](QUICK_REFERENCE.md) - Cheat sheet
- 🆕 [What's New in v1.0.0](NEW_FEATURES.md) - New features guide

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

**📁 [See Full Examples](example/)**

---

## 🆚 Comparison with GetX

Reactiv is inspired by GetX but with key improvements:

### ✅ Advantages over GetX

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
```

---

## 🔧 Configuration

### Disable Logging in Production

```dart
import 'package:flutter/foundation.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  // Disable logging in release mode
  if (kReleaseMode) {
    Logger.enabled = false;
  }
  
  runApp(MyApp());
}
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


