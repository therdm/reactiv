import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  group('ReactiveBuilder Tests', () {
    testWidgets('ReactiveBuilder rebuilds when reactive value changes', (WidgetTester tester) async {
      final counter = Reactive<int>(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReactiveBuilder<int>(
              reactiv: counter,
              builder: (context, value) {
                return Text('Count: $value');
              },
            ),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      counter.value = 5;
      await tester.pump();

      expect(find.text('Count: 5'), findsOneWidget);
      expect(find.text('Count: 0'), findsNothing);

      counter.close();
    });

    testWidgets('ReactiveBuilder calls listener when value changes', (WidgetTester tester) async {
      final counter = Reactive<int>(0);
      final List<int> listenerValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReactiveBuilder<int>(
              reactiv: counter,
              builder: (context, value) {
                return Text('Count: $value');
              },
              listener: (value) {
                listenerValues.add(value);
              },
            ),
          ),
        ),
      );

      // Initial build should NOT trigger listener
      await tester.pumpAndSettle();
      expect(listenerValues, []);

      counter.value = 1;
      await tester.pumpAndSettle();

      expect(listenerValues, [1]);

      counter.value = 2;
      await tester.pumpAndSettle();

      expect(listenerValues, [1, 2]);

      counter.close();
    });

    testWidgets('ReactiveBuilder works with different types', (WidgetTester tester) async {
      final message = Reactive<String>('Hello');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReactiveBuilder<String>(
              reactiv: message,
              builder: (context, value) {
                return Text(value);
              },
            ),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);

      message.value = 'World';
      await tester.pump();

      expect(find.text('World'), findsOneWidget);
      expect(find.text('Hello'), findsNothing);

      message.close();
    });

    testWidgets('ReactiveBuilder works with nullable values', (WidgetTester tester) async {
      final name = ReactiveN<String>(null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReactiveBuilder<String?>(
              reactiv: name,
              builder: (context, value) {
                return Text(value ?? 'No name');
              },
            ),
          ),
        ),
      );

      expect(find.text('No name'), findsOneWidget);

      name.value = 'John';
      await tester.pump();

      expect(find.text('John'), findsOneWidget);
      expect(find.text('No name'), findsNothing);

      name.value = null;
      await tester.pump();

      expect(find.text('No name'), findsOneWidget);
      expect(find.text('John'), findsNothing);

      name.close();
    });

    testWidgets('Multiple ReactiveBuilders on same reactive variable', (WidgetTester tester) async {
      final counter = Reactive<int>(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ReactiveBuilder<int>(
                  reactiv: counter,
                  builder: (context, value) {
                    return Text('First: $value');
                  },
                ),
                ReactiveBuilder<int>(
                  reactiv: counter,
                  builder: (context, value) {
                    return Text('Second: $value');
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('First: 0'), findsOneWidget);
      expect(find.text('Second: 0'), findsOneWidget);

      counter.value = 10;
      await tester.pump();

      expect(find.text('First: 10'), findsOneWidget);
      expect(find.text('Second: 10'), findsOneWidget);

      counter.close();
    });
  });

  group('MultiReactiveBuilder Tests', () {
    testWidgets('MultiReactiveBuilder rebuilds when any reactive value changes', (WidgetTester tester) async {
      final name = Reactive<String>('John');
      final age = Reactive<int>(25);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiReactiveBuilder(
              reactives: [name, age],
              builder: (context) {
                return Text('${name.value}, ${age.value}');
              },
            ),
          ),
        ),
      );

      expect(find.text('John, 25'), findsOneWidget);

      name.value = 'Jane';
      await tester.pump();

      expect(find.text('Jane, 25'), findsOneWidget);

      age.value = 30;
      await tester.pump();

      expect(find.text('Jane, 30'), findsOneWidget);

      name.close();
      age.close();
    });

    testWidgets('ReactiveBuilder buildWhen controls rebuild', (WidgetTester tester) async {
      final counter = Reactive<int>(0);
      int buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReactiveBuilder<int>(
              reactiv: counter,
              builder: (context, value) {
                buildCount++;
                return Text('Count: $value');
              },
              buildWhen: (prev, current) => current % 2 == 0, // Only rebuild on even numbers
            ),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);
      final initialBuildCount = buildCount;

      counter.value = 1; // Odd - should not rebuild
      await tester.pump();
      expect(find.text('Count: 0'), findsOneWidget); // Should still show 0
      expect(buildCount, initialBuildCount); // Build count should not increase

      counter.value = 2; // Even - should rebuild
      await tester.pump();
      expect(find.text('Count: 2'), findsOneWidget);
      expect(buildCount, initialBuildCount + 1); // Build count should increase

      counter.close();
    });

    testWidgets('ReactiveBuilder listenWhen controls listener', (WidgetTester tester) async {
      final counter = Reactive<int>(0);
      final List<int> listenerValues = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReactiveBuilder<int>(
              reactiv: counter,
              builder: (context, value) {
                return Text('Count: $value');
              },
              listener: (value) {
                listenerValues.add(value);
              },
              listenWhen: (prev, current) => current > 5, // Only listen when > 5
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(listenerValues, []); // Initial 0 should not trigger (not > 5)

      counter.value = 3; // Should not trigger listener
      await tester.pumpAndSettle();
      expect(listenerValues, []);

      counter.value = 6; // Should trigger listener (> 5)
      await tester.pumpAndSettle();
      expect(listenerValues, [6]);

      counter.value = 10; // Should trigger listener
      await tester.pumpAndSettle();
      expect(listenerValues, [6, 10]);

      counter.close();
    });

    testWidgets('MultiReactiveBuilder calls listener when any value changes', (WidgetTester tester) async {
      final name = Reactive<String>('John');
      final age = Reactive<int>(25);
      int listenerCallCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiReactiveBuilder(
              reactives: [name, age],
              builder: (context) {
                return Text('${name.value}, ${age.value}');
              },
              listener: () {
                listenerCallCount++;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(listenerCallCount, 0); // Should not call on initial build
      final initialCount = listenerCallCount;

      name.value = 'Jane';
      await tester.pumpAndSettle();

      expect(listenerCallCount, greaterThan(initialCount));

      name.close();
      age.close();
    });

    testWidgets('MultiReactiveBuilder works with three reactive variables', (WidgetTester tester) async {
      final name = Reactive<String>('John');
      final age = Reactive<int>(25);
      final city = Reactive<String>('NYC');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiReactiveBuilder(
              reactives: [name, age, city],
              builder: (context) {
                return Text('${name.value}, ${age.value}, ${city.value}');
              },
            ),
          ),
        ),
      );

      expect(find.text('John, 25, NYC'), findsOneWidget);

      city.value = 'LA';
      await tester.pump();

      expect(find.text('John, 25, LA'), findsOneWidget);

      name.close();
      age.close();
      city.close();
    });

    testWidgets('MultiReactiveBuilder works with empty list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiReactiveBuilder(
              reactives: [],
              builder: (context) {
                return const Text('No reactives');
              },
            ),
          ),
        ),
      );

      expect(find.text('No reactives'), findsOneWidget);
    });

    testWidgets('MultiReactiveBuilder buildWhen controls rebuild', (WidgetTester tester) async {
      final name = Reactive<String>('John');
      final age = Reactive<int>(25);
      int buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiReactiveBuilder(
              reactives: [name, age],
              builder: (context) {
                buildCount++;
                return Text('${name.value}, ${age.value}');
              },
              buildWhen: () => age.value >= 18, // Only rebuild when adult
            ),
          ),
        ),
      );

      expect(find.text('John, 25'), findsOneWidget);
      final initialBuildCount = buildCount;

      age.value = 15; // Under 18 - should not rebuild
      await tester.pump();
      expect(find.text('John, 25'), findsOneWidget); // Should still show old value
      expect(buildCount, initialBuildCount);

      age.value = 20; // Adult - should rebuild
      await tester.pump();
      expect(find.text('John, 20'), findsOneWidget);
      expect(buildCount, greaterThan(initialBuildCount));

      name.close();
      age.close();
    });

    testWidgets('MultiReactiveBuilder listenWhen controls listener', (WidgetTester tester) async {
      final name = Reactive<String>('');
      final age = Reactive<int>(25);
      int listenerCallCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiReactiveBuilder(
              reactives: [name, age],
              builder: (context) {
                return Text('${name.value}, ${age.value}');
              },
              listener: () {
                listenerCallCount++;
              },
              listenWhen: () => name.value.isNotEmpty, // Only listen when name is not empty
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final initialCount = listenerCallCount;

      age.value = 30; // Name still empty - should not call listener
      await tester.pumpAndSettle();
      expect(listenerCallCount, initialCount);

      name.value = 'John'; // Name not empty - should call listener
      await tester.pumpAndSettle();
      expect(listenerCallCount, greaterThan(initialCount));

      name.close();
      age.close();
    });
  });
}
