import 'package:flutter/material.dart';

import '../utils/logger.dart';

abstract class ReactiveController {
  ReactiveController() {
    Logger.info('$runtimeType initialized', tag: 'ReactiveController');
    onInit();
  }

  @mustCallSuper
  void onInit() {
    Logger.info('onInit of $runtimeType called', tag: 'ReactiveController');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onReady();
    });
  }

  @mustCallSuper
  void onReady() {
    Logger.info('onReady of $runtimeType called', tag: 'ReactiveController');
  }

  @mustCallSuper
  void onClose() {
    Logger.info('onClose of $runtimeType called', tag: 'ReactiveController');
  }
}
