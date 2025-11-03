# Release Notes - Reactiv v1.1.0

**Release Date**: November 3, 2024

## 🎉 What's New in v1.1.0

Version 1.1.0 introduces the new **ReactiveBuilder** widget family, providing a cleaner and more intuitive API for reactive UI updates. This release marks a significant improvement in developer experience while maintaining full backward compatibility.

---

## ✨ New Features

### ReactiveBuilder Widget

A modern replacement for the Observer widget with a cleaner API:

```dart
ReactiveBuilder<int>(
  reactiv: controller.count,
  builder: (context, count) {
    return Text('Count: $count');
  },
  listener: (count) {
    // Optional: Handle side effects
    debugPrint('Count changed to $count');
  },
)
```

**Key Benefits:**
- ✅ More descriptive parameter name: `reactiv` instead of `listenable`
- ✅ Builder receives unwrapped value directly
- ✅ Optional `listener` parameter for side effects
- ✅ Works with both nullable and non-nullable types
- ✅ Better type inference

### ReactiveBuilderN Widget

Observe multiple reactive variables simultaneously:

```dart
ReactiveBuilderN(
  reactives: [name, age, city],
  builder: (context) {
    return Text('${name.value}, ${age.value}, ${city.value}');
  },
  listener: () {
    debugPrint('User info changed');
  },
)
```

**Replaces:**
- Observer2
- Observer3
- Observer4
- ObserverN

**Benefits:**
- ✅ Single widget for any number of reactives
- ✅ Cleaner than nested observers
- ✅ More maintainable code
- ✅ Better performance

### Enhanced Nullable Type Support

Full documentation and examples for nullable reactive types:

```dart
// Nullable reactive types
final username = ReactiveN<String>(null);
final age = ReactiveIntN(null);
final price = ReactiveDoubleN(null);
final isEnabled = ReactiveBoolN(null);

// Use with ReactiveBuilder
ReactiveBuilder<String?>(
  reactiv: username,
  builder: (context, name) => Text(name ?? 'Anonymous'),
)
```

---

## ⚠️ Deprecations

The following widgets are now deprecated but will continue to work:

- `Observer<T>` → Use `ReactiveBuilder<T>`
- `Observer2<A, B>` → Use `ReactiveBuilderN`
- `Observer3<A, B, C>` → Use `ReactiveBuilderN`
- `Observer4<A, B, C, D>` → Use `ReactiveBuilderN`
- `ObserverN` → Use `ReactiveBuilderN`

**Important Notes:**
- ⚠️ Deprecated widgets show warnings but work normally
- ✅ No breaking changes - existing code continues to function
- 📅 Deprecated widgets will be removed in v2.0.0
- 📖 Migration guide available: [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)

---

## 📚 Documentation Updates

### New Documentation
- **[Migration Guide](MIGRATION_GUIDE.md)** - Complete step-by-step migration guide
- **[Changes Summary](CHANGES_SUMMARY.md)** - Technical overview of changes
- **[Documentation Update Summary](DOCUMENTATION_UPDATE_SUMMARY.md)** - List of updated files

### Updated Documentation
All documentation has been updated to use ReactiveBuilder:
- ✅ README.md - All examples updated
- ✅ GETTING_STARTED.md - Quick start guide
- ✅ ADVANCED.md - Advanced patterns
- ✅ API_REFERENCE.md - API documentation
- ✅ Example app - New examples added

---

## 🔧 Migration Guide

### Quick Migration Examples

**Simple Observer → ReactiveBuilder**
```dart
// Before (v1.0.x)
Observer(
  listenable: controller.count,
  builder: (context, value) => Text('$value'),
)

// After (v1.1.0)
ReactiveBuilder<int>(
  reactiv: controller.count,
  builder: (context, value) => Text('$value'),
)
```

**Multiple Observers → ReactiveBuilderN**
```dart
// Before (v1.0.x)
Observer2(
  listenable: firstName,
  listenable2: lastName,
  builder: (context, first, last) => Text('$first $last'),
)

// After (v1.1.0)
ReactiveBuilderN(
  reactives: [firstName, lastName],
  builder: (context) => Text('${firstName.value} ${lastName.value}'),
)
```

**See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for complete migration instructions.**

---

## ✅ Testing & Quality

- **109 tests passing** - All tests green
- **9 new tests** - ReactiveBuilder and ReactiveBuilderN coverage
- **Zero breaking changes** - Full backward compatibility
- **22 deprecation warnings** - Expected from deprecated Observer usage
- **Production ready** - Battle-tested patterns

---

## 🚀 Getting Started

### Installation

Update your `pubspec.yaml`:

```yaml
dependencies:
  reactiv: ^1.1.0
```

Then run:

```bash
flutter pub get
```

### Quick Example

```dart
import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

class CounterController extends ReactiveController {
  final count = ReactiveInt(0);
  void increment() => count.value++;
}

class CounterScreen extends ReactiveStateWidget<CounterController> {
  const CounterScreen({super.key});

  @override
  BindController<CounterController>? bindController() {
    return BindController(controller: () => CounterController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: ReactiveBuilder<int>(
          reactiv: controller.count,
          builder: (context, count) {
            return Text(
              'Count: $count',
              style: Theme.of(context).textTheme.headlineLarge,
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

---

## 📦 What's Included

- ✅ ReactiveBuilder widget
- ✅ ReactiveBuilderN widget
- ✅ Full nullable types support
- ✅ Comprehensive tests
- ✅ Complete documentation
- ✅ Migration guide
- ✅ Working examples
- ✅ Backward compatibility

---

## 🔮 Roadmap

### v1.1.x
- Bug fixes and improvements
- Additional examples
- Documentation enhancements

### v2.0.0 (Future)
- Remove deprecated Observer widgets
- Breaking changes properly documented
- Major feature additions

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

Thanks to all contributors and users who provided feedback to make this release possible!

---

## 🔗 Resources

- **GitHub Repository**: https://github.com/therdm/reactiv
- **pub.dev Package**: https://pub.dev/packages/reactiv
- **Issue Tracker**: https://github.com/therdm/reactiv/issues
- **Migration Guide**: [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)
- **Documentation**: [README.md](README.md)

---

**Enjoy building with Reactiv v1.1.0! 🎉**
