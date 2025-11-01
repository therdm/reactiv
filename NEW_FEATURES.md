# Reactiv 1.0.0+ - New Features Guide

This document describes all the improvements and new features added to the Reactiv package.

## Table of Contents

1. [Bug Fixes](#bug-fixes)
2. [Performance Improvements](#performance-improvements)
3. [New Features](#new-features)
4. [API Improvements](#api-improvements)
5. [Migration Guide](#migration-guide)

---

## Bug Fixes

### 1. Fixed Memory Leak in `addListener`
Previously, listeners were stored but never called when values changed. Now they work correctly:

```dart
final count = ReactiveInt(0);

count.addListener((value) {
  print('Count changed to: $value');
}, listenerName: 'myListener');

count.value = 5; // Now prints: "Count changed to: 5"
```

### 2. Fixed Memory Leak in `bindStream`
Stream subscriptions are now properly managed and cancelled:

```dart
final stream = Stream.periodic(Duration(seconds: 1), (count) => count);
final subscription = reactive.bindStream(stream);

// Later, when closing:
reactive.close(); // Automatically cancels the subscription
```

### 3. Fixed Observer Widget Performance
Observer now uses the correct `value` parameter from `ValueListenableBuilder`:

```dart
Observer(
  listenable: myReactive,
  listener: (value) => Text('$value'), // Now uses the optimized value
)
```

---

## Performance Improvements

### 4. Batched Updates for ReactiveList and ReactiveSet
Mutations are now batched to avoid multiple rebuilds in a single frame:

```dart
final list = ReactiveList<int>([]);
list.add(1);
list.add(2);
list.add(3);
// Only triggers ONE rebuild instead of three
```

---

## New Features

### 5. Undo/Redo Support
Enable history tracking for any reactive variable:

```dart
final text = ReactiveString('Hello', enableHistory: true, maxHistorySize: 50);

text.value = 'World';
text.value = 'Flutter';

print(text.canUndo); // true
text.undo();
print(text.value); // 'World'

print(text.canRedo); // true
text.redo();
print(text.value); // 'Flutter'

text.clearHistory(); // Clear all history
```

### 6. Computed Reactive Values
Automatically recompute values when dependencies change:

```dart
final firstName = 'John'.reactiv;
final lastName = 'Doe'.reactiv;

final fullName = ComputedReactive<String>(
  () => '${firstName.value} ${lastName.value}',
  dependencies: [firstName, lastName],
);

print(fullName.value); // 'John Doe'
firstName.value = 'Jane';
print(fullName.value); // 'Jane Doe' (auto-updated!)
```

### 7. Debounce & Throttle Support
Delay or limit updates:

```dart
final searchQuery = ReactiveString('');
searchQuery.setDebounce(Duration(milliseconds: 500));

// Updates will wait 500ms after last change
searchQuery.updateDebounced('flutter');
```

```dart
final scrollPosition = ReactiveInt(0);
scrollPosition.setThrottle(Duration(milliseconds: 100));

// Updates limited to once per 100ms
scrollPosition.updateThrottled(150);
```

### 8. Ever & Once Utilities
Convenient listener methods:

```dart
final count = ReactiveInt(0);

// Called every time value changes
count.ever((value) {
  print('Count is now: $value');
});

// Called only once, then auto-removed
count.once((value) {
  print('Count changed for the first time!');
});
```

### 9. Lazy Dependency Injection
Dependencies are created only when first accessed:

```dart
// Register lazy builder
Dependency.lazyPut<MyController>(() => MyController());

// Controller is created here, not before
final controller = Dependency.find<MyController>();
```

### 10. Put with Overwrite
Control dependency registration:

```dart
// Overwrites existing dependency (with warning)
Dependency.put(MyController());

// Only registers if not exists
Dependency.putIfAbsent(() => MyController());

// Check if registered
if (Dependency.isRegistered<MyController>()) {
  // ...
}
```

### 11. Fenix Mode (Auto-Recreation)
Dependencies that recreate themselves after deletion:

```dart
Dependency.put(MyController(), fenix: true);

Dependency.delete<MyController>();
// Controller is removed

final controller = Dependency.find<MyController>();
// Controller is automatically recreated!
```

---

## API Improvements

### 12. Configurable Logging
Control logging in production:

```dart
// Disable all logging
Logger.enabled = false;

// Re-enable
Logger.enabled = true;
```

### 13. Custom Exceptions
Better error handling:

```dart
try {
  Dependency.find<MyController>();
} on DependencyNotFoundException catch (e) {
  print(e.toString()); // Clear, helpful error message
}
```

### 14. Return Types Added
All methods now have explicit return types:

```dart
void removeAllListeners() { ... } // Was missing return type
void removeListener({required String listenerName}) { ... }
```

### 15. Dependency Reset
Clear all dependencies at once:

```dart
Dependency.reset(); // Calls onClose() on all ReactiveControllers
```

---

## Migration Guide

### Breaking Changes
None! All changes are backward compatible.

### Deprecations
None.

### Recommended Updates

1. **Remove async from sync methods** (if you extended Reactive):
   ```dart
   // Old
   removeListener({required String listenerName}) async { ... }
   
   // New
   void removeListener({required String listenerName}) { ... }
   ```

2. **Use new exception handling**:
   ```dart
   // Old
   try {
     Dependency.find<MyController>();
   } catch (e) {
     print(e); // String exception
   }
   
   // New
   try {
     Dependency.find<MyController>();
   } on DependencyNotFoundException catch (e) {
     print(e.toString()); // Typed exception
   }
   ```

3. **Disable logging in production**:
   ```dart
   void main() {
     if (kReleaseMode) {
       Logger.enabled = false;
     }
     runApp(MyApp());
   }
   ```

---

## Examples

See `example/lib/advanced_features_example.dart` for a comprehensive demonstration of all new features.

---

## Performance Tips

1. **Use computed values** instead of manually updating multiple reactive variables
2. **Enable history** only when needed (uses memory)
3. **Use debounce** for expensive operations like API calls
4. **Use throttle** for high-frequency updates like scrolling
5. **Use lazyPut** to defer controller creation until needed

---

## Questions?

Check the [API documentation](https://pub.dev/documentation/reactiv/latest/) or create an issue on [GitHub](https://github.com/therdm/reactiv).
