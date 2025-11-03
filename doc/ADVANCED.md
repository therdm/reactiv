# Advanced Patterns and Best Practices

This guide covers advanced usage patterns, testing strategies, debugging techniques, and performance optimization for Reactiv.

## Advanced Patterns

### Derived State

Create reactive values that depend on other reactive values:

```dart
class ShoppingCartController extends ReactiveController {
  final items = ReactiveList<CartItem>([]);
  final taxRate = ReactiveDouble(0.08);
  final total = ReactiveDouble(0.0);
  
  ShoppingCartController() {
    items.addListener(_calculateTotal);
    taxRate.addListener(_calculateTotal);
  }
  
  void _calculateTotal() {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.price);
    total.value = subtotal * (1 + taxRate.value);
  }
  
  void addItem(CartItem item) {
    items.add(item);
  }
  
  @override
  void onClose() {
    items.removeListener(_calculateTotal);
    taxRate.removeListener(_calculateTotal);
    super.onClose();
  }
}
```

### Multiple Observers for Complex UI

Use multiple `Observer` widgets to optimize rebuilds by only updating the parts of your UI that need to change:

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Dependency.find<ProfileController>();
    
    return Scaffold(
      appBar: AppBar(
        title: ReactiveBuilder(
          reactiv: controller.username,
          builder: (context, name) => Text(name),
        ),
      ),
      body: Column(
        children: [
          ReactiveBuilder(
            reactiv: controller.avatarUrl,
            builder: (context, url) => CircleAvatar(
              backgroundImage: NetworkImage(url),
            ),
          ),
          ReactiveBuilder(
            reactiv: controller.bio,
            builder: (context, bio) => Text(bio),
          ),
        ],
      ),
    );
  }
}
```

### Using ReactiveStateWidget for Automatic Controller Management

The recommended approach for binding controllers to widgets is using `ReactiveStateWidget`:

```dart
class SettingsScreen extends ReactiveStateWidget<SettingsController> {
  const SettingsScreen({super.key});
  
  @override
  BindController<SettingsController>? bindController() {
    // Controller is automatically injected and disposed
    return BindController(
      controller: () => SettingsController(),
      autoDispose: true, // Automatically cleaned up when widget is disposed
    );
  }
  
  @override
  void initState() {
    super.initState();
    // Access controller here if needed for initialization
    controller.loadSettings();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ReactiveBuilder(
        reactiv: controller.theme,
        builder: (context, theme) => Text('Current theme: $theme'),
      ),
    );
  }
}
```

**Benefits:**
- No manual `Dependency.put()` or `Dependency.delete()` calls
- Automatic cleanup prevents memory leaks
- Cleaner, more maintainable code
- Direct access to controller via `controller` getter

### Using ReactiveState with StatefulWidget

When you need full `StatefulWidget` lifecycle control:

```dart
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ReactiveState<SettingsScreen, SettingsController> {
  @override
  BindController<SettingsController>? bindController() {
    return BindController(controller: () => SettingsController());
  }
  
  @override
  void initState() {
    super.initState();
    // Full StatefulWidget lifecycle available
    controller.loadSettings();
  }
  
  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Access to all StatefulWidget lifecycle methods
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ReactiveBuilder(
        reactiv: controller.theme,
        builder: (context, theme) => Text('Current theme: $theme'),
      ),
    );
  }
}
```

### Multiple Controllers with Tags

When you need multiple instances of the same controller type:

```dart
class ChatView extends ReactiveStateWidget<ChatController> {
  final String chatId;
  
  const ChatView({super.key, required this.chatId}) : super(tag: chatId);
  
  @override
  BindController<ChatController>? bindController() {
    return BindController(
      controller: () => ChatController(chatId: chatId),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return ReactiveBuilder(
      reactiv: controller.messages,
        builder: (context, messages) => ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) => Text(messages[index]),
      ),
    );
  }
}

// Usage: Each instance gets its own controller
ChatView(chatId: 'chat1')
ChatView(chatId: 'chat2')
```

### Manual Controller Management (Advanced)

Only when you need fine-grained control over controller lifecycle:

```dart
class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsController controller;
  
  @override
  void initState() {
    super.initState();
    controller = SettingsController();
    Dependency.put<SettingsController>(controller);
  }
  
  @override
  void dispose() {
    controller.onClose();
    Dependency.delete<SettingsController>();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Your UI here
  }
}
```

**Note:** This approach is more verbose and error-prone. Use `ReactiveStateWidget` or `ReactiveState` instead when possible.

### Working with Streams

Bind streams to reactive variables using the `bindStream` method:

```dart
class LocationController extends ReactiveController {
  final location = Reactive<Position?>(null);
  
  @override
  void onInit() {
    super.onInit();
    // Bind a stream to a reactive variable
    Geolocator.getPositionStream().listen((position) {
      location.value = position;
    });
  }
}
```

## Testing

### Unit Testing Controllers

Test your controllers in isolation:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  group('CounterController', () {
    late CounterController controller;
    
    setUp(() {
      controller = CounterController();
    });
    
    tearDown(() {
      controller.onClose();
    });
    
    test('initial count should be 0', () {
      expect(controller.count.value, 0);
    });
    
    test('increment should increase count by 1', () {
      controller.increment();
      expect(controller.count.value, 1);
    });
    
    test('count should notify listeners on change', () {
      var notified = false;
      controller.count.addListener(() {
        notified = true;
      });
      
      controller.increment();
      expect(notified, true);
    });
  });
}
```

### Widget Testing with ReactiveStateWidget

Test widgets that use `ReactiveStateWidget`:

```dart
testWidgets('Counter increments when button is pressed', (tester) async {
  // ReactiveStateWidget handles controller injection automatically
  await tester.pumpWidget(
    MaterialApp(home: CounterScreen()),
  );
  
  // Verify initial state
  expect(find.text('0'), findsOneWidget);
  
  // Tap the increment button
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  // Verify the count increased
  expect(find.text('1'), findsOneWidget);
  
  // No manual cleanup needed - ReactiveStateWidget handles it
});
```

### Testing ReactiveState

```dart
testWidgets('Settings screen updates theme', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: SettingsScreen()),
  );
  
  // Controller is automatically bound via ReactiveState
  final controller = Dependency.find<SettingsController>();
  
  expect(find.text('Light'), findsOneWidget);
  
  controller.toggleTheme();
  await tester.pump();
  
  expect(find.text('Dark'), findsOneWidget);
});
```

### Testing Manual Dependency Injection

When using manual `Dependency.put()`:

```dart
testWidgets('Counter increments when button is pressed', (tester) async {
  // Inject the controller manually
  Dependency.put<CounterController>(CounterController());
  
  await tester.pumpWidget(
    MaterialApp(home: CounterScreen()),
  );
  
  // Verify initial state
  expect(find.text('Count: 0'), findsOneWidget);
  
  // Tap the increment button
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  // Verify the count increased
  expect(find.text('Count: 1'), findsOneWidget);
  
  // Clean up manually
  Dependency.delete<CounterController>();
});
```

**Best Practice:** Prefer `ReactiveStateWidget` or `ReactiveState` in tests to avoid manual cleanup and reduce boilerplate.

## Debugging

### Enable Logging

Reactiv includes built-in logging for debugging. Check the console output to see controller lifecycle events:

- Controller initialization
- `onInit()` calls
- `onReady()` calls
- `onClose()` calls

### Common Issues and Solutions

**Issue: Observer not rebuilding**
- Ensure you're updating the `.value` property of the reactive variable
- Verify the Observer's `listenable` parameter references the correct reactive variable

**Issue: Memory leaks**
- Use `ReactiveStateWidget` or `ReactiveState` for automatic controller cleanup
- When using manual injection, always call `Dependency.delete<T>()` when controllers are no longer needed
- Remove listeners in the `onClose()` method
- Set `autoDispose: true` in `BindController` (default behavior)

**Issue: Controller not found**
- When using `ReactiveStateWidget` or `ReactiveState`, ensure `bindController()` returns a valid `BindController`
- When using manual injection, ensure `Dependency.put()` is called before accessing the controller
- Check that controller type matches exactly (generics matter)

**Issue: Multiple rebuilds**
- Use multiple small Observer widgets instead of one large one
- Ensure you're not creating new reactive variables in the build method

## Performance Best Practices

### 1. Minimize Observer Scope

Place Observer widgets as deep in the widget tree as possible:

```dart
// ❌ Bad: Entire screen rebuilds
ReactiveBuilder(
  reactiv: controller.count,
  builder: (context, count) => Scaffold(
    body: ComplexWidget(),
  ),
)

// ✅ Good: Only the Text widget rebuilds
Scaffold(
  body: ComplexWidget(
    child: ReactiveBuilder(
      reactiv: controller.count,
      builder: (context, count) => Text('Count: $count'),
    ),
  ),
)
```

### 2. Use Specific Reactive Types

Prefer specific types over generic `Reactive<T>` when possible:

```dart
// ✅ Preferred
final count = ReactiveInt(0);

// ⚠️ Less optimal
final count = Reactive<int>(0);
```

### 3. Batch Updates

When updating multiple reactive variables, consider batching to reduce rebuilds:

```dart
void updateUser(String name, String email, int age) {
  // Each line triggers observers
  username.value = name;
  userEmail.value = email;
  userAge.value = age;
}

// Consider using a single reactive object instead:
final user = Reactive<User>(User());

void updateUser(User newUser) {
  user.value = newUser; // Single update
}
```

### 4. Clean Up Listeners

Always remove listeners when they're no longer needed:

```dart
class MyController extends ReactiveController {
  final data = ReactiveInt(0);
  
  void _onDataChanged() {
    // Handle change
  }
  
  @override
  void onInit() {
    super.onInit();
    data.addListener(_onDataChanged);
  }
  
  @override
  void onClose() {
    data.removeListener(_onDataChanged);
    super.onClose();
  }
}
```

### 5. Avoid Creating Reactive Variables in Build

Never create reactive variables inside the build method:

```dart
// ❌ Bad: Creates new variable on every build
@override
Widget build(BuildContext context) {
  final count = ReactiveInt(0); // Wrong!
  return ReactiveBuilder<...);
}

// ✅ Good: Create in controller or state
class _MyWidgetState extends State<MyWidget> {
  late final count = ReactiveInt(0);
  
  @override
  Widget build(BuildContext context) {
    return ReactiveBuilder(reactiv: count, ...);
  }
}
```

## Architecture Recommendations

### Separation of Concerns

Keep your controllers focused on business logic:

```dart
// ✅ Good: Controller handles logic
class TodoController extends ReactiveController {
  final todos = ReactiveList<Todo>([]);
  
  void addTodo(String title) {
    todos.add(Todo(title: title));
  }
  
  void toggleTodo(int index) {
    final todo = todos[index];
    todos[index] = todo.copyWith(completed: !todo.completed);
  }
}

// UI handles presentation
class TodoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Dependency.find<TodoController>();
    return ReactiveBuilder(
      reactiv: controller.todos,
      builder: (context, todos) => ListView.builder(...),
    );
  }
}
```

### Dependency Management

Use dependency injection for testability and modularity:

```dart
class ApiService {
  Future<List<User>> fetchUsers() async { ... }
}

class UserController extends ReactiveController {
  final ApiService api;
  final users = ReactiveList<User>([]);
  
  UserController(this.api);
  
  Future<void> loadUsers() async {
    final data = await api.fetchUsers();
    users.value = data;
  }
}

// Inject dependencies
Dependency.put<ApiService>(ApiService());
Dependency.put<UserController>(
  UserController(Dependency.find<ApiService>())
);
```

## See Also

- [Getting Started Guide](GETTING_STARTED.md)
- [API Reference](API_REFERENCE.md)
- [Example App](../example)
