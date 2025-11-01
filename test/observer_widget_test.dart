import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  group('Observer Widget', () {
    testWidgets('should rebuild when reactive value changes', (tester) async {
      final counter = Reactive<int>(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Observer<int>(
              listenable: counter,
              listener: (value) => Text('Count: $value'),
            ),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      counter.value = 1;
      await tester.pump();

      expect(find.text('Count: 1'), findsOneWidget);
      expect(find.text('Count: 0'), findsNothing);
    });

    testWidgets('should rebuild multiple times', (tester) async {
      final counter = Reactive<int>(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Observer<int>(
              listenable: counter,
              listener: (value) => Text('$value'),
            ),
          ),
        ),
      );

      for (int i = 1; i <= 5; i++) {
        counter.value = i;
        await tester.pump();
        expect(find.text('$i'), findsOneWidget);
      }
    });

    testWidgets('should work with different types', (tester) async {
      final message = Reactive<String>('Hello');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Observer<String>(
              listenable: message,
              listener: (value) => Text(value),
            ),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);

      message.value = 'World';
      await tester.pump();

      expect(find.text('World'), findsOneWidget);
      expect(find.text('Hello'), findsNothing);
    });

    testWidgets('should support complex widgets', (tester) async {
      final isLoading = Reactive<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Observer<bool>(
              listenable: isLoading,
              listener: (value) => value
                  ? const CircularProgressIndicator()
                  : const Text('Loaded'),
            ),
          ),
        ),
      );

      expect(find.text('Loaded'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      isLoading.value = true;
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loaded'), findsNothing);
    });
  });

  group('Observer with ReactiveList', () {
    testWidgets('should rebuild when list changes', (tester) async {
      final items = ReactiveList<String>(['a', 'b']);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Observer<List<String>>(
              listenable: items,
              listener: (value) => Column(
                children: value.map((item) => Text(item)).toList(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);

      items.add('c');
      await tester.pumpAndSettle();

      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
      expect(find.text('c'), findsOneWidget);
    });

    testWidgets('should rebuild when list item is removed', (tester) async {
      final items = ReactiveList<String>(['a', 'b', 'c']);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Observer<List<String>>(
              listenable: items,
              listener: (value) => Column(
                children: value.map((item) => Text(item)).toList(),
              ),
            ),
          ),
        ),
      );

      items.remove('b');
      await tester.pumpAndSettle();

      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsNothing);
      expect(find.text('c'), findsOneWidget);
    });
  });

  group('Multiple Observers', () {
    testWidgets('should handle multiple observers independently',
        (tester) async {
      final counter1 = Reactive<int>(0);
      final counter2 = Reactive<int>(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Observer<int>(
                  listenable: counter1,
                  listener: (value) => Text('Counter1: $value'),
                ),
                Observer<int>(
                  listenable: counter2,
                  listener: (value) => Text('Counter2: $value'),
                ),
              ],
            ),
          ),
        ),
      );

      counter1.value = 5;
      await tester.pump();

      expect(find.text('Counter1: 5'), findsOneWidget);
      expect(find.text('Counter2: 0'), findsOneWidget);

      counter2.value = 10;
      await tester.pump();

      expect(find.text('Counter1: 5'), findsOneWidget);
      expect(find.text('Counter2: 10'), findsOneWidget);
    });

    testWidgets('should share same reactive variable', (tester) async {
      final counter = Reactive<int>(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Observer<int>(
                  listenable: counter,
                  listener: (value) => Text('First: $value'),
                ),
                Observer<int>(
                  listenable: counter,
                  listener: (value) => Text('Second: $value'),
                ),
              ],
            ),
          ),
        ),
      );

      counter.value = 5;
      await tester.pump();

      expect(find.text('First: 5'), findsOneWidget);
      expect(find.text('Second: 5'), findsOneWidget);
    });
  });

  group('Observer with user interactions', () {
    testWidgets('should update on button press', (tester) async {
      final counter = Reactive<int>(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Observer<int>(
                  listenable: counter,
                  listener: (value) => Text('Count: $value'),
                ),
                ElevatedButton(
                  onPressed: () => counter.value++,
                  child: const Text('Increment'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Count: 1'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Count: 2'), findsOneWidget);
    });

    testWidgets('should handle text input', (tester) async {
      final text = Reactive<String>('');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextField(
                  onChanged: (value) => text.value = value,
                ),
                Observer<String>(
                  listenable: text,
                  listener: (value) => Text('Input: $value'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();

      expect(find.text('Input: Hello'), findsOneWidget);
    });
  });
}
