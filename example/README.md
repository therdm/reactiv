# Reactiv Examples

This directory contains example applications demonstrating the Reactiv state management package.

## 📁 Examples Overview

### Basic Examples

1. **Counter Example** (`main.dart`)
   - Simple counter using ReactiveBuilder
   - Basic dependency injection
   - Demonstrates reactive state updates

2. **ReactiveBuilder Example** (`reactive_builder_example.dart`) 
   - Shows the new ReactiveBuilder widget
   - ReactiveBuilderN for multiple reactives
   - Side effects with listener parameter
   - Nullable reactive variables

3. **Advanced Features** (`advanced_features_example.dart`)
   - Undo/Redo functionality
   - Computed reactive values
   - Debounce and throttle
   - Stream binding
   - Ever and once listeners

4. **ReactiveStateWidget Example** (`reactive_state_widget_example/`)
   - Automatic controller lifecycle management
   - Clean code with less boilerplate
   - Best practices for production apps

## 🚀 Running the Examples

```bash
# Navigate to example directory
cd example

# Get dependencies
flutter pub get

# Run on your device
flutter run
```

## 📚 Key Concepts Demonstrated

### ReactiveBuilder

The new recommended way to observe reactive state:

```dart
ReactiveBuilder<int>(
  reactiv: controller.count,
  builder: (context, count) {
    return Text('Count: $count');
  },
  listener: (count) {
    // Optional side effects
    debugPrint('Count changed to $count');
  },
)
```

### ReactiveBuilderN

For observing multiple reactive variables:

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

### Reactive Controllers

Clean separation of business logic:

```dart
class CounterController extends ReactiveController {
  final count = ReactiveInt(0);
  
  void increment() => count.value++;
  void decrement() => count.value--;
}
```

## 💡 Learn More

- [Main Documentation](../README.md)
- [API Reference](../doc/API_REFERENCE.md)
- [Migration Guide](../MIGRATION_GUIDE.md) - Migrating from Observer to ReactiveBuilder
- [Advanced Patterns](../doc/ADVANCED.md)
