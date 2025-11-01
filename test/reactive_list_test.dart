import 'package:flutter_test/flutter_test.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  group('ReactiveList', () {
    test('should create with initial values', () {
      final list = ReactiveList<int>([1, 2, 3]);
      expect(list.length, equals(3));
      expect(list[0], equals(1));
      expect(list[1], equals(2));
      expect(list[2], equals(3));
    });

    test('should add elements', () {
      final list = ReactiveList<int>([]);
      list.add(1);
      list.add(2);
      
      expect(list.length, equals(2));
      expect(list, equals([1, 2]));
    });

    test('should add all elements', () {
      final list = ReactiveList<int>([1, 2]);
      list.addAll([3, 4, 5]);
      
      expect(list.length, equals(5));
      expect(list, equals([1, 2, 3, 4, 5]));
    });

    test('should insert elements at index', () {
      final list = ReactiveList<int>([1, 3]);
      list.insertAll(1, [2]);
      
      expect(list, equals([1, 2, 3]));
    });

    test('should remove elements', () {
      final list = ReactiveList<int>([1, 2, 3, 2]);
      final removed = list.remove(2);
      
      expect(removed, isTrue);
      expect(list, equals([1, 3, 2]));
    });

    test('should remove element at index', () {
      final list = ReactiveList<String>(['a', 'b', 'c']);
      final removed = list.removeAt(1);
      
      expect(removed, equals('b'));
      expect(list, equals(['a', 'c']));
    });

    test('should remove last element', () {
      final list = ReactiveList<int>([1, 2, 3]);
      final removed = list.removeLast();
      
      expect(removed, equals(3));
      expect(list, equals([1, 2]));
    });

    test('should remove range of elements', () {
      final list = ReactiveList<int>([1, 2, 3, 4, 5]);
      list.removeRange(1, 3);
      
      expect(list, equals([1, 4, 5]));
    });

    test('should remove where condition is met', () {
      final list = ReactiveList<int>([1, 2, 3, 4, 5]);
      list.removeWhere((n) => n % 2 == 0);
      
      expect(list, equals([1, 3, 5]));
    });

    test('should sort elements', () {
      final list = ReactiveList<int>([3, 1, 2]);
      list.sort();
      
      expect(list, equals([1, 2, 3]));
    });

    test('should sort with custom comparator', () {
      final list = ReactiveList<String>(['apple', 'Banana', 'cherry']);
      list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      
      expect(list, equals(['apple', 'Banana', 'cherry']));
    });

    test('should filter with where', () {
      final list = ReactiveList<int>([1, 2, 3, 4, 5]);
      final evens = list.where((n) => n % 2 == 0);
      
      expect(evens, equals([2, 4]));
    });

    test('should find index with indexWhere', () {
      final list = ReactiveList<int>([1, 2, 3, 4]);
      final index = list.indexWhere((n) => n > 2);
      
      expect(index, equals(2));
    });

    test('should convert to set', () {
      final list = ReactiveList<int>([1, 2, 2, 3]);
      final set = list.toSet();
      
      expect(set, equals({1, 2, 3}));
    });

    test('should create sublist', () {
      final list = ReactiveList<int>([1, 2, 3, 4, 5]);
      final sub = list.sublist(1, 4);
      
      expect(sub, equals([2, 3, 4]));
    });

    test('should update element by index', () {
      final list = ReactiveList<int>([1, 2, 3]);
      list[1] = 10;
      
      expect(list, equals([1, 10, 3]));
    });

    test('should change length', () {
      final list = ReactiveList<int>([1, 2, 3]);
      list.length = 2;
      
      expect(list.length, equals(2));
      expect(list, equals([1, 2]));
    });

    test('should support + operator', () {
      final list = ReactiveList<int>([1, 2]);
      list + [3, 4];
      
      expect(list, equals([1, 2, 3, 4]));
    });

    test('should notify listeners on add', () async {
      final list = ReactiveList<int>([1, 2]);
      int notificationCount = 0;
      
      list.addListener((value) => notificationCount++);
      
      list.add(3);
      
      await Future.delayed(Duration(milliseconds: 10));
      expect(notificationCount, greaterThan(0));
    });

    test('should batch refresh for multiple operations', () async {
      final list = ReactiveList<int>([]);
      int notificationCount = 0;
      
      list.addListener((value) => notificationCount++);
      
      // Multiple operations in quick succession
      list.add(1);
      list.add(2);
      list.add(3);
      
      await Future.delayed(Duration(milliseconds: 10));
      // Should batch into fewer notifications than operations
      expect(notificationCount, lessThan(3));
    });
  });
}
