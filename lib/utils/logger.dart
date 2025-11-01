import 'dart:convert';
import 'dart:developer' as developer;

/// Log levels for categorizing log messages
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf, // What a Terrible Failure
}

/// Configuration for the Logger
class LoggerConfig {
  /// Enable/disable logging globally
  final bool enabled;

  /// Minimum log level to display
  final LogLevel minLevel;

  /// Show timestamps in logs
  final bool showTimestamp;

  /// Show log level in logs
  final bool showLevel;

  /// Show file and line number
  final bool showLocation;

  /// Show stack trace for errors
  final bool showStackTrace;

  /// Pretty print JSON objects
  final bool prettyJson;

  /// Maximum length for log messages (0 = unlimited)
  final int maxLength;

  /// Custom log handler
  final void Function(LogLevel level, String message, {String? tag})?
      customHandler;

  const LoggerConfig({
    this.enabled = true,
    this.minLevel = LogLevel.verbose,
    this.showTimestamp = true,
    this.showLevel = true,
    this.showLocation = false,
    this.showStackTrace = true,
    this.prettyJson = true,
    this.maxLength = 0,
    this.customHandler,
  });

  /// Default configuration for development
  static const development = LoggerConfig(
    enabled: true,
    minLevel: LogLevel.verbose,
    showTimestamp: true,
    showLevel: true,
    showLocation: true,
    showStackTrace: true,
    prettyJson: true,
  );

  /// Default configuration for production
  static const production = LoggerConfig(
    enabled: false,
    minLevel: LogLevel.error,
    showTimestamp: false,
    showLevel: false,
    showLocation: false,
    showStackTrace: false,
    prettyJson: false,
  );

  /// Minimal configuration for testing
  static const testing = LoggerConfig(
    enabled: true,
    minLevel: LogLevel.warning,
    showTimestamp: false,
    showLevel: true,
    showLocation: false,
    showStackTrace: true,
    prettyJson: false,
  );
}

/// A robust logging framework for Reactiv
///
/// Features:
/// - Multiple log levels (verbose, debug, info, warning, error, wtf)
/// - Pretty JSON formatting
/// - Stack trace support
/// - Configurable output
/// - File/line number tracking
/// - Custom handlers
/// - Production/Development modes
/// - Performance timing
/// - Table formatting
///
/// Example:
/// ```dart
/// // Configure logger
/// Logger.config = LoggerConfig.development;
///
/// // Basic logging
/// Logger.info('User logged in');
/// Logger.error('Failed to fetch data');
///
/// // With custom tag
/// Logger.d('Debug message', tag: 'MyFeature');
///
/// // Log JSON
/// Logger.json({'user': 'John', 'age': 30});
///
/// // Log with stack trace
/// Logger.error('Something went wrong', error: exception, stackTrace: stack);
///
/// // Measure performance
/// final result = await Logger.timed(() => fetchData(), label: 'API Call');
///
/// // Log table
/// Logger.table([
///   {'name': 'John', 'age': 30},
///   {'name': 'Jane', 'age': 25},
/// ]);
/// ```
class Logger {
  /// Current configuration
  static LoggerConfig config = LoggerConfig.development;

  /// Backward compatibility: enable/disable logging
  static bool get enabled => config.enabled;
  static set enabled(bool value) {
    config = LoggerConfig(
      enabled: value,
      minLevel: config.minLevel,
      showTimestamp: config.showTimestamp,
      showLevel: config.showLevel,
      showLocation: config.showLocation,
      showStackTrace: config.showStackTrace,
      prettyJson: config.prettyJson,
      maxLength: config.maxLength,
      customHandler: config.customHandler,
    );
  }

  // ANSI color codes for terminal
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _cyan = '\x1B[36m';
  static const String _magenta = '\x1B[35m';
  static const String _gray = '\x1B[90m';

  /// Verbose logging (detailed information)
  static void verbose(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.verbose,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Shorthand for verbose
  static void v(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      verbose(message, tag: tag, error: error, stackTrace: stackTrace);

  /// Debug logging (diagnostic information)
  static void debug(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.debug,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Shorthand for debug
  static void d(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      debug(message, tag: tag, error: error, stackTrace: stackTrace);

  /// Info logging (general information)
  static void info(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.info,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Shorthand for info
  static void i(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      info(message, tag: tag, error: error, stackTrace: stackTrace);

  /// Warning logging (potential issues)
  static void warn(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.warning,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Shorthand for warning
  static void w(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      warn(message, tag: tag, error: error, stackTrace: stackTrace);

  /// Error logging (error conditions)
  static void error(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Shorthand for error
  static void e(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) {
    Logger.error(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// WTF logging (What a Terrible Failure - should never happen)
  static void wtf(
    dynamic message, {
    String tag = 'Reactiv',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.wtf,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a JSON object with pretty formatting
  static void json(
    Object? object, {
    String tag = 'Reactiv',
    LogLevel level = LogLevel.debug,
  }) {
    if (!config.enabled || level.index < config.minLevel.index) return;

    try {
      final prettyString = config.prettyJson
          ? const JsonEncoder.withIndent('  ').convert(object)
          : jsonEncode(object);

      _log(level, prettyString, tag: tag);
    } catch (e) {
      _log(
        LogLevel.error,
        'Failed to encode JSON: $e\nObject: $object',
        tag: tag,
      );
    }
  }

  /// Log a divider line
  static void divider({
    String tag = 'Reactiv',
    String char = '─',
    int length = 80,
  }) {
    if (!config.enabled) return;
    _log(LogLevel.info, char * length, tag: tag);
  }

  /// Log a header with borders
  static void header(
    String message, {
    String tag = 'Reactiv',
    String char = '═',
    int length = 80,
  }) {
    if (!config.enabled) return;
    final border = char * length;
    _log(LogLevel.info, border, tag: tag);
    _log(
      LogLevel.info,
      message.toUpperCase().padLeft((length + message.length) ~/ 2),
      tag: tag,
    );
    _log(LogLevel.info, border, tag: tag);
  }

  /// Log a table (list of maps)
  static void table(
    List<Map<String, dynamic>> data, {
    String tag = 'Reactiv',
  }) {
    if (!config.enabled || data.isEmpty) return;

    final keys = data.first.keys.toList();
    final columnWidths = <String, int>{};

    // Calculate column widths
    for (final key in keys) {
      columnWidths[key] = key.length;
      for (final row in data) {
        final value = row[key]?.toString() ?? '';
        if (value.length > columnWidths[key]!) {
          columnWidths[key] = value.length;
        }
      }
    }

    // Print header
    final header = keys.map((k) => k.padRight(columnWidths[k]!)).join(' │ ');
    final separator = columnWidths.values.map((w) => '─' * w).join('─┼─');

    _log(LogLevel.info, '┌─$separator─┐', tag: tag);
    _log(LogLevel.info, '│ $header │', tag: tag);
    _log(LogLevel.info, '├─$separator─┤', tag: tag);

    // Print rows
    for (final row in data) {
      final rowStr = keys.map((k) {
        final value = row[k]?.toString() ?? '';
        return value.padRight(columnWidths[k]!);
      }).join(' │ ');
      _log(LogLevel.info, '│ $rowStr │', tag: tag);
    }

    _log(LogLevel.info, '└─$separator─┘', tag: tag);
  }

  /// Log execution time of a function
  static Future<T> timed<T>(
    Future<T> Function() function, {
    String? label,
    String tag = 'Reactiv',
  }) async {
    final stopwatch = Stopwatch()..start();
    final functionLabel = label ?? 'Function';

    _log(LogLevel.debug, '⏱️  $functionLabel started...', tag: tag);

    try {
      final result = await function();
      stopwatch.stop();
      _log(
        LogLevel.debug,
        '✅ $functionLabel completed in ${stopwatch.elapsedMilliseconds}ms',
        tag: tag,
      );
      return result;
    } catch (e, stack) {
      stopwatch.stop();
      _log(
        LogLevel.error,
        '❌ $functionLabel failed after ${stopwatch.elapsedMilliseconds}ms',
        tag: tag,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Log execution time of a synchronous function
  static T timedSync<T>(
    T Function() function, {
    String? label,
    String tag = 'Reactiv',
  }) {
    final stopwatch = Stopwatch()..start();
    final functionLabel = label ?? 'Function';

    _log(LogLevel.debug, '⏱️  $functionLabel started...', tag: tag);

    try {
      final result = function();
      stopwatch.stop();
      _log(
        LogLevel.debug,
        '✅ $functionLabel completed in ${stopwatch.elapsedMilliseconds}ms',
        tag: tag,
      );
      return result;
    } catch (e, stack) {
      stopwatch.stop();
      _log(
        LogLevel.error,
        '❌ $functionLabel failed after ${stopwatch.elapsedMilliseconds}ms',
        tag: tag,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  // Internal logging method
  static void _log(
    LogLevel level,
    dynamic message, {
    required String tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!config.enabled || level.index < config.minLevel.index) return;

    final buffer = StringBuffer();

    // Add timestamp
    if (config.showTimestamp) {
      final now = DateTime.now();
      buffer.write('${now.hour.toString().padLeft(2, '0')}:');
      buffer.write('${now.minute.toString().padLeft(2, '0')}:');
      buffer.write('${now.second.toString().padLeft(2, '0')}.');
      buffer.write('${now.millisecond.toString().padLeft(3, '0')} ');
    }

    // Add level with color
    if (config.showLevel) {
      buffer.write(_getLevelPrefix(level));
    }

    // Add message
    buffer.write(message);

    // Add error if provided
    if (error != null) {
      buffer.write('\n${_red}Error: $error$_reset');
    }

    // Add stack trace if provided and enabled
    if (stackTrace != null && config.showStackTrace) {
      buffer.write('\n$_gray$stackTrace$_reset');
    } else if (error != null && config.showStackTrace && config.showLocation) {
      // Get current stack trace
      final trace = StackTrace.current;
      final frames = trace.toString().split('\n');
      if (frames.length > 3) {
        buffer.write('\n$_gray${frames[3]}$_reset');
      }
    }

    var finalMessage = buffer.toString();

    // Truncate if needed
    if (config.maxLength > 0 && finalMessage.length > config.maxLength) {
      finalMessage =
          '${finalMessage.substring(0, config.maxLength)}... (truncated)';
    }

    // Use custom handler if provided
    if (config.customHandler != null) {
      config.customHandler!(level, finalMessage, tag: tag);
      return;
    }

    // Use dart:developer log
    developer.log(
      finalMessage,
      name: tag,
      level: _getDeveloperLogLevel(level),
    );
  }

  // Get colored level prefix
  static String _getLevelPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return '$_gray[V]$_reset ';
      case LogLevel.debug:
        return '$_cyan[D]$_reset ';
      case LogLevel.info:
        return '$_green[I]$_reset ';
      case LogLevel.warning:
        return '$_yellow[W]$_reset ';
      case LogLevel.error:
        return '$_red[E]$_reset ';
      case LogLevel.wtf:
        return '$_magenta[WTF]$_reset ';
    }
  }

  // Convert LogLevel to dart:developer log level
  static int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return 500;
      case LogLevel.debug:
        return 700;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.wtf:
        return 1200;
    }
  }
}
