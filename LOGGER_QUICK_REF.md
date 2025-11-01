# Logger Quick Reference

## Setup
```dart
// Development
Logger.config = LoggerConfig.development;

// Production  
Logger.config = LoggerConfig.production;
```

## Log Levels
```dart
Logger.v('Verbose');    // Detailed traces
Logger.d('Debug');      // Diagnostics
Logger.i('Info');       // General info
Logger.w('Warning');    // Potential issues
Logger.e('Error');      // Errors
Logger.wtf('Critical'); // Should never happen
```

## Features
```dart
// JSON
Logger.json({'key': 'value'});

// Error + Stack
Logger.error('Failed', error: e, stackTrace: stack);

// Timing
await Logger.timed(() => api.call(), label: 'API');

// Table
Logger.table([{'name': 'John', 'age': 30}]);

// Header/Divider
Logger.header('TITLE');
Logger.divider();

// Custom Tag
Logger.info('Message', tag: 'MyTag');
```

## Configuration
```dart
Logger.config = LoggerConfig(
  enabled: true,
  minLevel: LogLevel.debug,
  showTimestamp: true,
  showLevel: true,
  prettyJson: true,
  maxLength: 1000,
);
```

## Production Setup
```dart
void main() {
  Logger.config = kReleaseMode
      ? LoggerConfig.production
      : LoggerConfig.development;
  runApp(MyApp());
}
```
