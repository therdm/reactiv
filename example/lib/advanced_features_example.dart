import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  // Enable/disable logging
  Logger.enabled = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reactiv Advanced Features Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AdvancedFeaturesDemo(),
    );
  }
}

/// Controller demonstrating all the new features
class AdvancedController extends ReactiveController {
  // Basic reactive variables
  final count = ReactiveInt(0);
  final name = ReactiveString('John');

  // Reactive with history (undo/redo)
  final textWithHistory = ReactiveString('Edit me!', enableHistory: true);

  // Reactive list
  final items = ReactiveList<String>(['Item 1', 'Item 2', 'Item 3']);

  // Computed reactive value
  late final ComputedReactive<String> greeting;

  // Debounced reactive value
  final searchQuery = ReactiveString('');

  AdvancedController() {
    // Setup computed value
    greeting = ComputedReactive<String>(
      () => 'Hello, ${name.value}! Count: ${count.value}',
      [name, count],
    );

    // Setup debounced search (simulating API call)
    searchQuery.setDebounce(const Duration(milliseconds: 500));

    // Add listeners
    count.ever((value) {
      Logger.info('Count changed to: $value', tag: 'AdvancedController');
    });

    // One-time listener
    count.once((value) {
      Logger.info('Count changed for the first time to: $value',
          tag: 'AdvancedController');
    });
  }

  void increment() {
    count.value++;
  }

  void changeName() {
    name.value = name.value == 'John' ? 'Jane' : 'John';
  }

  void addItem() {
    items.add('Item ${items.length + 1}');
  }

  void removeLastItem() {
    if (items.isNotEmpty) {
      items.removeLast();
    }
  }

  void updateSearchDebounced(String query) {
    searchQuery.updateDebounced(query);
  }

  @override
  void onClose() {
    count.close();
    name.close();
    textWithHistory.close();
    items.close();
    greeting.close();
    searchQuery.close();
    super.onClose();
  }
}

class AdvancedFeaturesDemo extends StatefulWidget {
  const AdvancedFeaturesDemo({super.key});

  @override
  State<AdvancedFeaturesDemo> createState() => _AdvancedFeaturesDemoState();
}

class _AdvancedFeaturesDemoState extends State<AdvancedFeaturesDemo> {
  @override
  void initState() {
    super.initState();
    // Using lazyPut - controller will be created when first accessed
    Dependency.lazyPut<AdvancedController>(() => AdvancedController());
    final controller = Dependency.find<AdvancedController>();
    controller.changeName();
  }

  @override
  void dispose() {
    Dependency.delete<AdvancedController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Controller is created here on first access
    final controller = Dependency.find<AdvancedController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactiv Advanced Features'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic ReactiveBuilder
            _buildSection(
              'Basic ReactiveBuilder',
              ReactiveBuilder<int>(
                reactiv: controller.count,
                builder: (context, count) {
                  return Text(
                    'Count: ${controller.count.value}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
              ElevatedButton(
                onPressed: controller.increment,
                child: const Text('Increment'),
              ),
            ),
            _buildSection(
              'Basic ReactiveBuilder String',
              ReactiveBuilder<String>(
                reactiv: controller.name,
                builder: (context, name) {
                  return Text(
                    'Name: ${controller.name.value}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
              ElevatedButton(
                onPressed: controller.changeName,
                child: const Text('Change Name'),
              ),
            ),

            const Divider(height: 32),

            // Computed Reactive
            _buildSection(
              'Computed Reactive (Auto-updates)',
              ReactiveBuilder<String>(
                reactiv: controller.greeting,
                builder: (context, greeting) {
                  return Text(
                    greeting,
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: controller.increment,
                    child: const Text('Increment'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: controller.changeName,
                    child: const Text('Toggle Name'),
                  ),
                ],
              ),
            ),

            const Divider(height: 32),

            // History (Undo/Redo)
            _buildSection(
              'History (Undo/Redo)',
              ReactiveBuilder<String>(
                reactiv: controller.textWithHistory,
                builder: (context, text) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Text: $text'),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          controller.textWithHistory.value = value;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Type here...',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: controller.textWithHistory.canUndo
                                ? () => setState(
                                    () => controller.textWithHistory.undo())
                                : null,
                            child: const Text('Undo'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: controller.textWithHistory.canRedo
                                ? () => setState(
                                    () => controller.textWithHistory.redo())
                                : null,
                            child: const Text('Redo'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              null,
            ),

            const Divider(height: 32),

            // Reactive List
            _buildSection(
              'Reactive List',
              ReactiveBuilder<List<String>>(
                reactiv: controller.items,
                builder: (context, items) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Items count: ${items.length}'),
                      const SizedBox(height: 8),
                      ...items.map((item) => Chip(label: Text(item))),
                    ],
                  );
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: controller.addItem,
                    child: const Text('Add Item'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: controller.removeLastItem,
                    child: const Text('Remove Last'),
                  ),
                ],
              ),
            ),

            const Divider(height: 32),

            // Debounced Search
            _buildSection(
              'Debounced Search (500ms)',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: controller.updateSearchDebounced,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type to search...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ReactiveBuilder<String>(
                    reactiv: controller.searchQuery,
                    builder: (context, query) {
                      return Text(
                        query.isEmpty
                            ? 'No search query'
                            : 'Searching for: "${controller.searchQuery.value}"',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      );
                    },
                  ),
                ],
              ),
              null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content, Widget? actions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        content,
        if (actions != null) ...[
          const SizedBox(height: 12),
          actions,
        ],
      ],
    );
  }
}
