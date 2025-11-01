# Quick Reference: New Features

## 🎯 Most Useful New Features

### 1. History (Undo/Redo)
```dart
final text = ReactiveString('Hello', enableHistory: true);
text.value = 'World';
text.undo(); // Back to 'Hello'
text.redo(); // Forward to 'World'
```

### 2. Computed Values
```dart
final firstName = 'John'.reactiv;
final lastName = 'Doe'.reactiv;
final fullName = ComputedReactive(
  () => '${firstName.value} ${lastName.value}',
  [firstName, lastName],
);
// Auto-updates when firstName or lastName change!
```

### 3. Debounce (Great for search)
```dart
final search = ReactiveString('');
search.setDebounce(Duration(milliseconds: 500));
search.updateDebounced(query); // Waits 500ms before updating
```

### 4. Ever & Once
```dart
count.ever((value) => print('Changed to $value')); // Every time
count.once((value) => print('First change')); // Only once
```

### 5. Lazy Dependencies
```dart
Dependency.lazyPut(() => MyController()); // Not created yet
final ctrl = Dependency.find<MyController>(); // Created here!
```

### 6. Better Error Handling
```dart
try {
  Dependency.find<MyController>();
} on DependencyNotFoundException catch (e) {
  print(e); // Clear, helpful message
}
```

### 7. Disable Logging in Production
```dart
void main() {
  Logger.enabled = false; // Disable all logs
  runApp(MyApp());
}
```

### 8. Working Listeners
```dart
// NOW WORKS! (was broken before)
count.addListener((value) {
  print('Count: $value');
});
```

## 🔧 Breaking Changes

**None!** All changes are backward compatible.

## 📝 Migration Tips

1. **Enable features gradually** - Start with logging control
2. **Use history sparingly** - It uses memory
3. **Debounce expensive operations** - Like API calls
4. **Use computed for derived state** - Instead of manual updates
5. **Lazy load controllers** - For better performance

## 🚀 Performance Tips

- Use `ComputedReactive` instead of manually syncing multiple reactives
- Enable `enableHistory` only when needed
- Use `debounce` for text inputs
- Use `throttle` for scroll/drag events
- Use `lazyPut` for rarely-used controllers

## 📚 Full Documentation

See `NEW_FEATURES.md` for complete documentation.
See `example/lib/advanced_features_example.dart` for working examples.
