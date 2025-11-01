import 'package:flutter_test/flutter_test.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  group('Reactive', () {
    test('should create with initial value', () {
      final reactive = Reactive<int>(5);
      expect(reactive.value, equals(5));
    });

    test('should update value and notify listeners', () {
      final reactive = Reactive<int>(0);
      int notifiedValue = 0;
      
      reactive.addListener((value) {
        notifiedValue = value;
      });
      
      reactive.value = 10;
      expect(reactive.value, equals(10));
      expect(notifiedValue, equals(10));
    });

    test('should support multiple listeners', () {
      final reactive = Reactive<int>(0);
      int listener1Value = 0;
      int listener2Value = 0;
      
      reactive.addListener((value) => listener1Value = value);
      reactive.addListener((value) => listener2Value = value);
      
      reactive.value = 5;
      expect(listener1Value, equals(5));
      expect(listener2Value, equals(5));
    });

    test('should remove named listener', () {
      final reactive = Reactive<int>(0);
      int listenerValue = 0;
      
      reactive.addListener(
        (value) => listenerValue = value,
        listenerName: 'test',
      );
      
      reactive.value = 5;
      expect(listenerValue, equals(5));
      
      reactive.removeListener(listenerName: 'test');
      reactive.value = 10;
      expect(listenerValue, equals(5)); // Should not update
    });

    test('should remove all listeners', () {
      final reactive = Reactive<int>(0);
      int listener1Value = 0;
      int listener2Value = 0;
      
      reactive.addListener((value) => listener1Value = value);
      reactive.addListener((value) => listener2Value = value);
      
      reactive.removeAllListeners();
      reactive.value = 10;
      
      expect(listener1Value, equals(0));
      expect(listener2Value, equals(0));
    });

    test('should support ever callback', () {
      final reactive = Reactive<int>(0);
      final values = <int>[];
      
      reactive.ever((value) => values.add(value));
      
      reactive.value = 1;
      reactive.value = 2;
      reactive.value = 3;
      
      expect(values, equals([1, 2, 3]));
    });

    test('should support once callback', () {
      final reactive = Reactive<int>(0);
      int callCount = 0;
      int lastValue = 0;
      
      reactive.once((value) {
        callCount++;
        lastValue = value;
      });
      
      reactive.value = 1;
      reactive.value = 2;
      reactive.value = 3;
      
      expect(callCount, equals(1));
      expect(lastValue, equals(1)); // Only first value
    });

    test('should bind to stream', () async {
      final reactive = Reactive<int>(0);
      final stream = Stream.fromIterable([1, 2, 3]);
      
      reactive.bindStream(stream);
      
      await Future.delayed(Duration(milliseconds: 100));
      expect(reactive.value, equals(3));
    });

    test('should support debounce', () async {
      final reactive = Reactive<int>(0);
      reactive.setDebounce(Duration(milliseconds: 100));
      
      reactive.updateDebounced(1);
      reactive.updateDebounced(2);
      reactive.updateDebounced(3);
      
      expect(reactive.value, equals(0)); // Not updated yet
      
      await Future.delayed(Duration(milliseconds: 150));
      expect(reactive.value, equals(3)); // Only last value
    });

    test('should support throttle', () async {
      final reactive = Reactive<int>(0);
      reactive.setThrottle(Duration(milliseconds: 100));
      
      reactive.updateThrottled(1);
      expect(reactive.value, equals(1)); // First update goes through
      
      reactive.updateThrottled(2);
      reactive.updateThrottled(3);
      expect(reactive.value, equals(1)); // Throttled
      
      await Future.delayed(Duration(milliseconds: 150));
      reactive.updateThrottled(4);
      expect(reactive.value, equals(4)); // After throttle period
    });

    test('should support refresh', () {
      final reactive = Reactive<int>(5);
      int refreshCount = 0;
      
      reactive.addListener((value) => refreshCount++);
      
      reactive.refresh();
      expect(refreshCount, equals(1));
      expect(reactive.value, equals(5));
    });

    test('should dispose properly', () {
      final reactive = Reactive<int>(0);
      reactive.addListener((value) {});
      
      reactive.close();
      expect(reactive.listeners.isEmpty, isTrue);
    });
  });

  group('ReactiveN', () {
    test('should create with null value', () {
      final reactive = ReactiveN<int>();
      expect(reactive.value, isNull);
    });

    test('should create with non-null value', () {
      final reactive = ReactiveN<int>(5);
      expect(reactive.value, equals(5));
    });

    test('should accept null assignments', () {
      final reactive = ReactiveN<int>(5);
      reactive.value = null;
      expect(reactive.value, isNull);
    });
  });

  group('Reactive with History', () {
    test('should enable undo/redo', () {
      final reactive = Reactive<int>(0, enableHistory: true);
      
      reactive.value = 1;
      reactive.value = 2;
      reactive.value = 3;
      
      expect(reactive.value, equals(3));
      expect(reactive.canUndo, isTrue);
      expect(reactive.canRedo, isFalse);
    });

    test('should undo changes', () {
      final reactive = Reactive<int>(0, enableHistory: true);
      
      reactive.value = 1;
      reactive.value = 2;
      
      reactive.undo();
      expect(reactive.value, equals(1));
      
      reactive.undo();
      expect(reactive.value, equals(0));
    });

    test('should redo changes', () {
      final reactive = Reactive<int>(0, enableHistory: true);
      
      reactive.value = 1;
      reactive.value = 2;
      
      reactive.undo();
      reactive.undo();
      
      reactive.redo();
      expect(reactive.value, equals(1));
      
      reactive.redo();
      expect(reactive.value, equals(2));
    });

    test('should limit history size', () {
      final reactive = Reactive<int>(0, 
        enableHistory: true,
        maxHistorySize: 3,
      );
      
      reactive.value = 1;
      reactive.value = 2;
      reactive.value = 3;
      reactive.value = 4;
      
      reactive.undo();
      reactive.undo();
      reactive.undo();
      
      expect(reactive.canUndo, isFalse);
      expect(reactive.value, equals(2)); // Can't go back to 0 or 1
    });

    test('should clear history', () {
      final reactive = Reactive<int>(0, enableHistory: true);
      
      reactive.value = 1;
      reactive.value = 2;
      
      reactive.clearHistory();
      
      expect(reactive.canUndo, isFalse);
      expect(reactive.canRedo, isFalse);
    });
  });
}
