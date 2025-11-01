import 'package:flutter_test/flutter_test.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  group('ReactiveBool', () {
    test('should create with initial value', () {
      final reactive = ReactiveBool(true);
      expect(reactive.value, isTrue);
    });

    test('should update value', () {
      final reactive = ReactiveBool(false);
      reactive.value = true;
      expect(reactive.value, isTrue);

      reactive.value = false;
      expect(reactive.value, isFalse);
    });

    test('should notify listeners on change', () {
      final reactive = ReactiveBool(false);
      bool notifiedValue = false;

      reactive.addListener((value) => notifiedValue = value);

      reactive.value = true;
      expect(notifiedValue, isTrue);
    });
  });

  group('ReactiveInt', () {
    test('should create with initial value', () {
      final reactive = ReactiveInt(5);
      expect(reactive.value, equals(5));
    });

    test('should increment value', () {
      final reactive = ReactiveInt(0);
      reactive.value++;
      expect(reactive.value, equals(1));

      reactive.value++;
      expect(reactive.value, equals(2));
    });

    test('should decrement value', () {
      final reactive = ReactiveInt(5);
      reactive.value--;
      expect(reactive.value, equals(4));

      reactive.value--;
      expect(reactive.value, equals(3));
    });
  });

  group('ReactiveDouble', () {
    test('should create with initial value', () {
      final reactive = ReactiveDouble(3.14);
      expect(reactive.value, equals(3.14));
    });

    test('should update value', () {
      final reactive = ReactiveDouble(0.0);
      reactive.value = 1.5;
      expect(reactive.value, equals(1.5));
    });
  });

  group('ReactiveNum', () {
    test('should create with initial value', () {
      final reactive = ReactiveNum(42);
      expect(reactive.value, equals(42));
    });

    test('should update value', () {
      final reactive = ReactiveNum(10);
      reactive.value = 20;
      expect(reactive.value, equals(20));
    });
  });

  group('ReactiveString', () {
    test('should create with initial value', () {
      final reactive = ReactiveString('hello');
      expect(reactive.value, equals('hello'));
    });

    test('should update value', () {
      final reactive = ReactiveString('hello');
      reactive.value = 'world';
      expect(reactive.value, equals('world'));
    });

    test('should check if empty', () {
      final reactive1 = ReactiveString('');
      final reactive2 = ReactiveString('hello');

      expect(reactive1.value.isEmpty, isTrue);
      expect(reactive2.value.isEmpty, isFalse);
    });

    test('should check if not empty', () {
      final reactive1 = ReactiveString('hello');
      final reactive2 = ReactiveString('');

      expect(reactive1.value.isNotEmpty, isTrue);
      expect(reactive2.value.isNotEmpty, isFalse);
    });
  });

  group('Type Conversions', () {
    test('should convert int to reactive', () {
      final reactive = 5.reactiv;
      expect(reactive, isA<ReactiveInt>());
      expect(reactive.value, equals(5));
    });

    test('should convert double to reactive', () {
      final reactive = 3.14.reactiv;
      expect(reactive, isA<ReactiveDouble>());
      expect(reactive.value, equals(3.14));
    });

    test('should convert bool to reactive', () {
      final reactive = true.reactiv;
      expect(reactive, isA<ReactiveBool>());
      expect(reactive.value, isTrue);
    });

    test('should convert string to reactive', () {
      final reactive = 'hello'.reactiv;
      expect(reactive, isA<ReactiveString>());
      expect(reactive.value, equals('hello'));
    });

    test('should convert list to reactive', () {
      final reactive = [1, 2, 3].reactiv;
      expect(reactive, isA<ReactiveList<int>>());
      expect(reactive.length, equals(3));
    });

    test('should convert set to reactive', () {
      final reactive = {1, 2, 3}.reactiv;
      expect(reactive, isA<Reactive<Set<int>>>());
      expect(reactive.value.length, equals(3));
    });
  });
}
