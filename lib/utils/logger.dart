import 'dart:developer';

/// A utility class for logging information.
///
/// Use the `Logger` class to output log information with a specified tag.
class Logger {
  /// Logs the provided [data] with an optional [tag].
  ///
  /// The [data] parameter represents the information to be logged.
  /// The [tag] parameter specifies the tag to associate with the log.
  /// By default, the tag is set to 'Reactive'.
  static void info(dynamic data, {String tag = 'Reactive'}) {
    log('$data', name: tag);
  }
}
