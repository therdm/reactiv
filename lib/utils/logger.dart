import 'dart:developer';

class Logger {

  static void info(dynamic data, {String tag = 'Reactive'}) {
    log('$data', name: tag);
  }

}