import 'package:flutter/material.dart';

import '../utils/logger.dart';

/// Base class for reactive controllers with lifecycle management.
///
/// [ReactiveController] provides a structured lifecycle for managing business
/// logic and state in your application. It integrates with [ReactiveState] for
/// automatic dependency injection and cleanup.
///
/// Lifecycle methods:
/// 1. Constructor - Controller is created
/// 2. [onInit] - Called immediately after construction
/// 3. [onReady] - Called when widget tree is fully built (after first frame)
/// 4. [onClose] - Called before controller disposal
///
/// Example:
/// ```dart
/// class CounterController extends ReactiveController {
///   final count = Reactive<int>(0);
///   late StreamSubscription _subscription;
///
///   @override
///   void onInit() {
///     super.onInit();
///     print('Controller initialized');
///   }
///
///   @override
///   void onReady() {
///     super.onReady();
///     // Safe to access context-dependent resources here
///     _subscription = someStream.listen((data) {
///       count.value = data;
///     });
///   }
///
///   void increment() => count.value++;
///
///   @override
///   void onClose() {
///     _subscription.cancel();
///     count.close();
///     super.onClose();
///   }
/// }
/// ```
abstract class ReactiveController {
  /// Creates a [ReactiveController] and calls [onInit].
  ///
  /// The constructor is called when the controller is registered in the
  /// dependency system via [Dependency.put] or created through [ReactiveState].
  ReactiveController() {
    Logger.info('$runtimeType initialized', tag: 'ReactiveController');
    onInit();
  }

  /// Lifecycle method called immediately after controller creation.
  ///
  /// Override this to perform early initialization tasks that don't require
  /// the widget tree to be built yet. This is called synchronously during
  /// controller construction.
  ///
  /// Always call `super.onInit()` when overriding.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void onInit() {
  ///   super.onInit();
  ///   // Initialize reactive variables
  ///   user.value = loadCachedUser();
  ///   // Setup listeners
  ///   count.addListener((value) => saveToStorage(value));
  /// }
  /// ```
  @mustCallSuper
  void onInit() {
    Logger.info('onInit of $runtimeType called', tag: 'ReactiveController');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onReady();
    });
  }

  /// Lifecycle method called after the widget tree is fully built.
  ///
  /// Override this to perform tasks that require the widget tree to be ready,
  /// such as showing dialogs, accessing inherited widgets, or starting animations.
  /// This is called asynchronously after the first frame is rendered.
  ///
  /// Always call `super.onReady()` when overriding.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void onReady() {
  ///   super.onReady();
  ///   // Fetch initial data
  ///   loadUserData();
  ///   // Start periodic tasks
  ///   Timer.periodic(Duration(seconds: 30), (_) => refreshData());
  /// }
  /// ```
  @mustCallSuper
  void onReady() {
    Logger.info('onReady of $runtimeType called', tag: 'ReactiveController');
  }

  /// Lifecycle method called before controller disposal.
  ///
  /// Override this to perform cleanup such as cancelling subscriptions,
  /// disposing reactive variables, closing streams, or releasing resources.
  /// This is called automatically when using [ReactiveState] with auto-dispose.
  ///
  /// Always call `super.onClose()` when overriding.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void onClose() {
  ///   // Cancel subscriptions
  ///   _streamSubscription.cancel();
  ///   _timer.cancel();
  ///
  ///   // Dispose reactive variables
  ///   count.close();
  ///   userData.close();
  ///
  ///   super.onClose();
  /// }
  /// ```
  @mustCallSuper
  void onClose() {
    Logger.info('onClose of $runtimeType called', tag: 'ReactiveController');
  }
}
