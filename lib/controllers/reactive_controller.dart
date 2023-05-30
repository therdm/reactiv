import 'package:flutter/material.dart';

import '../utils/logger.dart';

/// An abstract class that serves as the base for reactive controllers.
///
/// Implement this class to create custom reactive controllers.
abstract class ReactiveController {
  /// Initializes the reactive controller.
  ///
  /// This method is called when the reactive controller is instantiated.
  ///
  /// It is recommended to perform initialization tasks in this method.
  ReactiveController() {
    Logger.info('$runtimeType initialized', tag: 'ReactiveController');
    onInit();
  }

  /// Called after the reactive controller has been initialized.
  ///
  /// This method is typically used to perform tasks that require the widget tree to be fully built.
  ///
  /// It is recommended to use this method to perform setup tasks.
  @mustCallSuper
  void onInit() {
    Logger.info('onInit of $runtimeType called', tag: 'ReactiveController');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onReady();
    });
  }

  /// Called when the widget is ready and the widget tree is fully built.
  ///
  /// This method is typically used to perform tasks that require the widget tree to be fully built and ready for interaction.
  ///
  /// It is recommended to use this method to subscribe to reactive variables and perform other initialization tasks.
  @mustCallSuper
  void onReady() {
    Logger.info('onReady of $runtimeType called', tag: 'ReactiveController');
  }

  /// Called when the reactive controller is being disposed.
  ///
  /// This method is typically used to perform cleanup tasks such as disposing of subscriptions and freeing resources.
  ///
  /// It is recommended to use this method to perform cleanup tasks before the reactive controller is no longer needed.
  @mustCallSuper
  void onClose() {
    Logger.info('onClose of $runtimeType called', tag: 'ReactiveController');
  }
}
