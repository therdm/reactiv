import 'package:flutter_test/flutter_test.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  group('ReactiveSet', () {
    test('should create with initial values', () {
      final set = ReactiveSet<int>({1, 2, 3});
      expect(set.length, equals(3));
      expect(set.contains(1), isTrue);
      expect(set.contains(2), isTrue);
      expect(set.contains(3), isTrue);
    });

    test('should add elements', () {
      final set = ReactiveSet<int>({});
      final added1 = set.add(1);
      final added2 = set.add(2);
      final added3 = set.add(1); // Duplicate

      expect(added1, isTrue);
      expect(added2, isTrue);
      expect(added3, isFalse);
      expect(set.length, equals(2));
    });

    test('should add all elements', () {
      final set = ReactiveSet<int>({1, 2});
      set.addAll({3, 4, 5});

      expect(set.length, equals(5));
      expect(set, equals({1, 2, 3, 4, 5}));
    });

    test('should remove elements', () {
      final set = ReactiveSet<int>({1, 2, 3});
      final removed1 = set.remove(2);
      final removed2 = set.remove(5);

      expect(removed1, isTrue);
      expect(removed2, isFalse);
      expect(set, equals({1, 3}));
    });

    test('should remove where condition is met', () {
      final set = ReactiveSet<int>({1, 2, 3, 4, 5});
      set.removeWhere((n) => n % 2 == 0);

      expect(set, equals({1, 3, 5}));
    });

    test('should check contains', () {
      final set = ReactiveSet<String>({'apple', 'banana'});

      expect(set.contains('apple'), isTrue);
      expect(set.contains('cherry'), isFalse);
    });

    test('should lookup elements', () {
      final set = ReactiveSet<String>({'Apple', 'Banana'});

      expect(set.lookup('Apple'), equals('Apple'));
      expect(set.lookup('apple'), isNull);
    });

    test('should filter with where', () {
      final set = ReactiveSet<int>({1, 2, 3, 4, 5});
      final evens = set.where((n) => n % 2 == 0);

      expect(evens, equals([2, 4]));
    });

    test('should convert to set', () {
      final set = ReactiveSet<int>({1, 2, 3});
      final copy = set.toSet();

      expect(copy, equals({1, 2, 3}));
      expect(identical(set, copy), isFalse);
    });

    test('should iterate over elements', () {
      final set = ReactiveSet<int>({1, 2, 3});
      final elements = <int>[];

      for (var element in set) {
        elements.add(element);
      }

      expect(elements.length, equals(3));
      expect(elements.toSet(), equals({1, 2, 3}));
    });

    test('should notify listeners on add', () async {
      final set = ReactiveSet<int>({1, 2});
      int notificationCount = 0;

      set.addListener((value) => notificationCount++);

      set.add(3);

      await Future.delayed(const Duration(milliseconds: 10));
      expect(notificationCount, greaterThan(0));
    });

    test('should not notify on duplicate add', () async {
      final set = ReactiveSet<int>({1, 2});
      int notificationCount = 0;

      set.addListener((value) => notificationCount++);

      set.add(1); // Duplicate

      await Future.delayed(const Duration(milliseconds: 10));
      expect(notificationCount, equals(0));
    });

    test('should batch refresh for multiple operations', () async {
      final set = ReactiveSet<int>({});
      int notificationCount = 0;

      set.addListener((value) => notificationCount++);

      set.add(1);
      set.add(2);
      set.add(3);

      await Future.delayed(const Duration(milliseconds: 10));
      expect(notificationCount, lessThan(3));
    });
  });
}
