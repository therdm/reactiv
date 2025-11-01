import 'dart:developer';

/// A utility class for logging information.
///
/// Use the `Logger` class to output log information with a specified tag.
class Logger {
  /// Controls whether logging is enabled. Set to false in production.
  static bool enabled = true;

  /// Logs the provided [data] with an optional [tag].
  ///
  /// The [data] parameter represents the information to be logged.
  /// The [tag] parameter specifies the tag to associate with the log.
  /// By default, the tag is set to 'Reactive'.
  static void info(dynamic data, {String tag = 'Reactive'}) {
    if (!enabled) return;
    log('$data', name: tag);
  }

  /// Logs a warning message
  static void warn(dynamic data, {String tag = 'Reactive'}) {
    if (!enabled) return;
    log('⚠️ $data', name: tag);
  }

  /// Logs an error message
  static void error(dynamic data, {String tag = 'Reactive'}) {
    if (!enabled) return;
    log('❌ $data', name: tag);
  }
}
