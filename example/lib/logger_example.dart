import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

void main() {
  // Configure logger for development
  Logger.config = LoggerConfig.development;

  runApp(const LoggerDemoApp());
}

class LoggerDemoApp extends StatelessWidget {
  const LoggerDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logger Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoggerDemoScreen(),
    );
  }
}

class LoggerDemoScreen extends StatelessWidget {
  const LoggerDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logger Framework Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection('Basic Logging', [
              ElevatedButton(
                onPressed: () => Logger.verbose('This is a verbose message'),
                child: const Text('Verbose (V)'),
              ),
              ElevatedButton(
                onPressed: () => Logger.debug('This is a debug message'),
                child: const Text('Debug (D)'),
              ),
              ElevatedButton(
                onPressed: () => Logger.info('This is an info message'),
                child: const Text('Info (I)'),
              ),
              ElevatedButton(
                onPressed: () => Logger.warn('This is a warning'),
                child: const Text('Warning (W)'),
              ),
              ElevatedButton(
                onPressed: () => Logger.error('This is an error'),
                child: const Text('Error (E)'),
              ),
              ElevatedButton(
                onPressed: () => Logger.wtf('This should never happen!'),
                child: const Text('WTF'),
              ),
            ]),
            const Divider(height: 32),
            _buildSection('JSON Logging', [
              ElevatedButton(
                onPressed: () {
                  Logger.json({
                    'user': {
                      'name': 'John Doe',
                      'email': 'john@example.com',
                      'age': 30,
                    },
                    'preferences': {
                      'theme': 'dark',
                      'notifications': true,
                    },
                  });
                },
                child: const Text('Log JSON Object'),
              ),
            ]),
            const Divider(height: 32),
            _buildSection('Error with Stack Trace', [
              ElevatedButton(
                onPressed: () {
                  try {
                    throw Exception('Simulated error');
                  } catch (e, stackTrace) {
                    Logger.error(
                      'An error occurred',
                      tag: 'ErrorDemo',
                      error: e,
                      stackTrace: stackTrace,
                    );
                  }
                },
                child: const Text('Log Error + Stack Trace'),
              ),
            ]),
            const Divider(height: 32),
            _buildSection('Performance Timing', [
              ElevatedButton(
                onPressed: () async {
                  await Logger.timed(
                    () async {
                      // Simulate API call
                      await Future.delayed(const Duration(seconds: 2));
                      return 'Data loaded';
                    },
                    label: 'API Call',
                    tag: 'Performance',
                  );
                },
                child: const Text('Time Async Function'),
              ),
              ElevatedButton(
                onPressed: () {
                  Logger.timedSync(
                    () {
                      // Simulate processing
                      var sum = 0;
                      for (var i = 0; i < 1000000; i++) {
                        sum += i;
                      }
                      return sum;
                    },
                    label: 'Heavy Computation',
                    tag: 'Performance',
                  );
                },
                child: const Text('Time Sync Function'),
              ),
            ]),
            const Divider(height: 32),
            _buildSection('Table Logging', [
              ElevatedButton(
                onPressed: () {
                  Logger.table([
                    {'name': 'John', 'age': 30, 'city': 'New York'},
                    {'name': 'Jane', 'age': 25, 'city': 'Los Angeles'},
                    {'name': 'Bob', 'age': 35, 'city': 'San Francisco'},
                  ], tag: 'Users');
                },
                child: const Text('Log Table'),
              ),
            ]),
            const Divider(height: 32),
            _buildSection('Headers & Dividers', [
              ElevatedButton(
                onPressed: () {
                  Logger.header('USER REGISTRATION');
                  Logger.info('Processing user data...');
                  Logger.divider();
                  Logger.info('User registered successfully!');
                },
                child: const Text('Log with Headers'),
              ),
            ]),
            const Divider(height: 32),
            _buildSection('Configuration', [
              ElevatedButton(
                onPressed: () {
                  Logger.config = LoggerConfig.development;
                  Logger.info('Switched to Development mode');
                },
                child: const Text('Development Mode'),
              ),
              ElevatedButton(
                onPressed: () {
                  Logger.config = LoggerConfig.production;
                  Logger.info('This won\'t show - production mode');
                },
                child: const Text('Production Mode'),
              ),
              ElevatedButton(
                onPressed: () {
                  Logger.config = LoggerConfig.testing;
                  Logger.info('This won\'t show - testing mode');
                  Logger.warn('But warnings will show');
                },
                child: const Text('Testing Mode'),
              ),
              ElevatedButton(
                onPressed: () {
                  Logger.config = const LoggerConfig(
                    enabled: true,
                    minLevel: LogLevel.warning,
                    showTimestamp: false,
                    prettyJson: false,
                  );
                  Logger.info('This won\'t show');
                  Logger.warn('Only warnings and above');
                },
                child: const Text('Custom Config'),
              ),
            ]),
            const Divider(height: 32),
            _buildSection('Custom Tags', [
              ElevatedButton(
                onPressed: () {
                  Logger.info('User logged in', tag: 'Auth');
                  Logger.info('Payment processed', tag: 'Payment');
                  Logger.debug('Cache updated', tag: 'Cache');
                },
                child: const Text('Log with Tags'),
              ),
            ]),
            const Divider(height: 32),
            const Text(
              'Check your console/terminal to see the log outputs!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children.map((child) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: child,
            )),
      ],
    );
  }
}
