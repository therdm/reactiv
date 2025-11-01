import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactiv/reactiv.dart';

class TestController extends ReactiveController {
  final count = Reactive<int>(0);
  bool initCalled = false;
  bool readyCalled = false;
  bool closeCalled = false;

  @override
  void onInit() {
    super.onInit();
    initCalled = true;
  }

  @override
  void onReady() {
    super.onReady();
    readyCalled = true;
  }

  @override
  void onClose() {
    closeCalled = true;
    count.close();
    super.onClose();
  }

  void increment() {
    count.value++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Reset dependency store before each test
    Dependency.reset();
  });

  group('Dependency', () {
    test('should put and find dependency', () {
      final controller = TestController();
      Dependency.put(controller);
      
      final found = Dependency.find<TestController>();
      expect(identical(controller, found), isTrue);
    });

    test('should support tagged dependencies', () {
      final controller1 = TestController();
      final controller2 = TestController();
      
      Dependency.put(controller1, tag: 'first');
      Dependency.put(controller2, tag: 'second');
      
      final found1 = Dependency.find<TestController>(tag: 'first');
      final found2 = Dependency.find<TestController>(tag: 'second');
      
      expect(identical(controller1, found1), isTrue);
      expect(identical(controller2, found2), isTrue);
    });

    test('should lazy put dependency', () {
      Dependency.lazyPut<TestController>(() => TestController());
      
      expect(Dependency.isRegistered<TestController>(), isTrue);
      
      final controller = Dependency.find<TestController>();
      expect(controller, isNotNull);
      expect(controller.initCalled, isTrue);
    });

    test('should put if absent - first call creates', () {
      final controller = Dependency.putIfAbsent<TestController>(
        () => TestController(),
      );
      
      expect(controller, isNotNull);
    });

    test('should put if absent - second call returns existing', () {
      final controller1 = Dependency.putIfAbsent<TestController>(
        () => TestController(),
      );
      
      final controller2 = Dependency.putIfAbsent<TestController>(
        () => TestController(),
      );
      
      expect(identical(controller1, controller2), isTrue);
    });

    test('should check if registered', () {
      expect(Dependency.isRegistered<TestController>(), isFalse);
      
      Dependency.put(TestController());
      expect(Dependency.isRegistered<TestController>(), isTrue);
    });

    test('should delete dependency', () {
      final controller = TestController();
      Dependency.put(controller);
      
      final deleted = Dependency.delete<TestController>();
      expect(deleted, isTrue);
      expect(Dependency.isRegistered<TestController>(), isFalse);
    });

    test('should call onClose when deleting controller', () {
      final controller = TestController();
      Dependency.put(controller);
      
      Dependency.delete<TestController>();
      expect(controller.closeCalled, isTrue);
    });

    test('should return false when deleting non-existent dependency', () {
      final deleted = Dependency.delete<TestController>();
      expect(deleted, isFalse);
    });

    test('should reset all dependencies', () {
      Dependency.put(TestController(), tag: 'first');
      Dependency.put(TestController(), tag: 'second');
      
      Dependency.reset();
      
      expect(Dependency.isRegistered<TestController>(tag: 'first'), isFalse);
      expect(Dependency.isRegistered<TestController>(tag: 'second'), isFalse);
    });

    test('should call onClose on all controllers when resetting', () {
      final controller1 = TestController();
      final controller2 = TestController();
      
      Dependency.put(controller1, tag: 'first');
      Dependency.put(controller2, tag: 'second');
      
      Dependency.reset();
      
      expect(controller1.closeCalled, isTrue);
      expect(controller2.closeCalled, isTrue);
    });

    test('should throw when finding non-existent dependency', () {
      expect(
        () => Dependency.find<TestController>(),
        throwsA(isA<DependencyNotFoundException>()),
      );
    });

    test('should support phoenix mode', () {
      Dependency.put(TestController(), fenix: true);
      
      Dependency.delete<TestController>();
      
      // Phoenix dependencies can be recreated
      // Note: Current implementation stores builder, not recreates automatically
      expect(Dependency.isRegistered<TestController>(), isFalse);
    });
  });

  group('ReactiveController', () {
    test('should call onInit on construction', () {
      final controller = TestController();
      expect(controller.initCalled, isTrue);
    });

    test('should call onReady after frame', () async {
      final controller = TestController();
      
      expect(controller.readyCalled, isFalse);
      
      // Manually trigger frame callback
      WidgetsBinding.instance.handleBeginFrame(Duration.zero);
      WidgetsBinding.instance.handleDrawFrame();
      
      await Future.delayed(Duration(milliseconds: 10));
      expect(controller.readyCalled, isTrue);
    });

    test('should call onClose on disposal', () {
      final controller = TestController();
      controller.onClose();
      
      expect(controller.closeCalled, isTrue);
    });

    test('should manage reactive state', () {
      final controller = TestController();
      
      expect(controller.count.value, equals(0));
      
      controller.increment();
      expect(controller.count.value, equals(1));
      
      controller.increment();
      expect(controller.count.value, equals(2));
    });
  });
}
