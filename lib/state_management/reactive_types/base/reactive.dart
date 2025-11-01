part of '../../reactive_types.dart';

/// Internal class to store listener functions with optional names.
///
/// This class wraps callback functions and associates them with optional
/// identifiers for easy removal and management.
class ListenerFunction {
  /// The callback function to be executed.
  final Function function;

  /// Optional name to identify this listener.
  final String? functionName;

  /// Creates a [ListenerFunction] with the given [function] and optional [functionName].
  ListenerFunction({required this.function, this.functionName});
}

/// A custom [ValueNotifier] that exposes [notifyListeners] publicly.
///
/// This class extends Flutter's [ValueNotifier] to provide a public method
/// for manually triggering notifications to all listeners, even when the
/// value hasn't changed. This is particularly useful for collections like
/// Lists and Sets where internal modifications don't trigger automatic updates.
///
/// Example:
/// ```dart
/// final notifier = ReactiveValueNotifier<List<int>>([1, 2, 3]);
/// notifier.value.add(4); // Internal modification
/// notifier.notifyListenersPublic(); // Manually trigger update
/// ```
class ReactiveValueNotifier<T> extends ValueNotifier<T> {
  /// Creates a [ReactiveValueNotifier] with the given initial [value].
  ReactiveValueNotifier(super.value);

  /// Publicly accessible method to notify listeners without changing the value.
  ///
  /// This method calls the protected [notifyListeners] method from [ChangeNotifier],
  /// allowing external code to trigger notifications manually.
  void notifyListenersPublic() {
    super.notifyListeners();
  }
}

/// A generic reactive variable that automatically notifies listeners when its value changes.
///
/// [Reactive] is the core building block of the reactiv state management system.
/// It wraps any value and provides reactive capabilities including:
/// - Automatic notification of value changes
/// - Listener management with named callbacks
/// - Stream binding for reactive data flows
/// - Debounce and throttle for performance optimization
/// - Undo/redo functionality with history tracking
/// - Integration with Flutter's Observer widgets
///
/// Example:
/// ```dart
/// // Create a reactive variable
/// final counter = Reactive<int>(0);
///
/// // Listen to changes
/// counter.addListener((value) => print('Counter: $value'));
///
/// // Update the value
/// counter.value = 1; // Prints: Counter: 1
///
/// // Use with Observer widget
/// Observer(
///   builder: (context) => Text('${counter.value}'),
/// );
/// ```
///
/// For nullable types, use [ReactiveN] instead.
class Reactive<T> {
  /// The underlying [ReactiveValueNotifier] that manages state changes.
  late final ReactiveValueNotifier<T> _valueNotifier;

  /// List of registered listener functions.
  final List<ListenerFunction> _listOfListeners = [];

  /// Subscription to bound stream, if any.
  StreamSubscription<T>? _streamSubscription;

  /// Whether history tracking is enabled for undo/redo.
  final bool _historyEnabled;

  /// List storing historical values for undo/redo.
  final List<T> _history = [];

  /// Current position in history.
  int _historyIndex = -1;

  /// Maximum number of history entries to keep.
  final int _maxHistorySize;

  /// Timer for debounce functionality.
  Timer? _debounceTimer;

  /// Timer for throttle functionality.
  Timer? _throttleTimer;

  /// Duration for debounce delay.
  Duration? _debounceDuration;

  /// Duration for throttle interval.
  Duration? _throttleDuration;

  /// Flag indicating if throttle is currently active.
  bool _isThrottling = false;

  /// Creates a [Reactive] variable with the initial [value].
  ///
  /// Optional parameters:
  /// - [enableHistory]: Set to `true` to enable undo/redo functionality (default: `false`)
  /// - [maxHistorySize]: Maximum number of history entries to keep (default: `50`)
  ///
  /// Example:
  /// ```dart
  /// // Simple reactive variable
  /// final name = Reactive<String>('John');
  ///
  /// // With history enabled
  /// final counter = Reactive<int>(0, enableHistory: true);
  /// counter.value = 1;
  /// counter.value = 2;
  /// counter.undo(); // Back to 1
  /// ```
  Reactive(
    T value, {
    bool enableHistory = false,
    int maxHistorySize = 50,
  })  : _historyEnabled = enableHistory,
        _maxHistorySize = maxHistorySize {
    _valueNotifier = ReactiveValueNotifier<T>(value);
    if (_historyEnabled) {
      _addToHistory(value);
    }
  }

  /// Updates the value of the reactive variable.
  ///
  /// Setting the value triggers notifications to all registered listeners
  /// and updates any [Observer] widgets that depend on this reactive variable.
  /// If history is enabled, the value is added to the history stack.
  ///
  /// Example:
  /// ```dart
  /// final counter = Reactive<int>(0);
  /// counter.addListener((val) => print('New value: $val'));
  /// counter.value = 5; // Prints: New value: 5
  /// ```
  set value(T value) {
    _valueNotifier.value = value;

    // Add to history
    if (_historyEnabled) {
      _addToHistory(value);
    }

    // Call registered listeners (copy list to avoid concurrent modification)
    final listeners = List<ListenerFunction>.from(_listOfListeners);
    for (var listener in listeners) {
      listener.function.call(value);
    }
  }

  /// Manually triggers an update to all listeners and [Observer] widgets.
  ///
  /// This method is useful when you modify the internal state of a collection
  /// (like adding items to a List) without reassigning the value. It forces
  /// all listeners and widgets to rebuild with the current value.
  ///
  /// Example:
  /// ```dart
  /// final items = ReactiveList<String>(['a', 'b']);
  /// items.add('c'); // Internal modification
  /// items.refresh(); // Force UI update
  /// ```
  void refresh() {
    // Use the custom notifier method to force notification
    _valueNotifier.notifyListenersPublic();

    // Call registered listeners (copy list to avoid concurrent modification)
    final listeners = List<ListenerFunction>.from(_listOfListeners);
    for (var listener in listeners) {
      listener.function.call(_valueNotifier.value);
    }
  }

  /// Gets the current value of the reactive variable.
  ///
  /// When accessed inside an [Observer] widget's builder, it automatically
  /// registers the widget as a dependent, ensuring it rebuilds when the value changes.
  ///
  /// Example:
  /// ```dart
  /// final counter = Reactive<int>(0);
  /// print(counter.value); // Prints: 0
  /// ```
  T get value => _valueNotifier.value;

  /// Provides access to the underlying [ValueNotifier].
  ///
  /// This allows direct integration with Flutter's built-in [ValueListenableBuilder]
  /// or other APIs that accept [ValueNotifier].
  ///
  /// Example:
  /// ```dart
  /// final reactive = Reactive<String>('Hello');
  /// ValueListenableBuilder(
  ///   valueListenable: reactive.valueNotifier,
  ///   builder: (context, value, child) => Text(value),
  /// );
  /// ```
  ValueNotifier<T> get valueNotifier => _valueNotifier;

  /// Returns a list of all registered listener functions.
  ///
  /// This getter provides access to the raw listener functions for inspection
  /// or advanced use cases.
  List<Function> get listeners =>
      _listOfListeners.map((e) => e.function).toList();

  /// Removes all registered listeners from this reactive variable.
  ///
  /// After calling this method, no listeners will be notified of value changes.
  /// This is useful for cleanup or resetting listener state.
  ///
  /// Example:
  /// ```dart
  /// final counter = Reactive<int>(0);
  /// counter.addListener((val) => print(val));
  /// counter.removeAllListeners();
  /// counter.value = 5; // No output
  /// ```
  void removeAllListeners() {
    _listOfListeners.clear();
  }

  /// Removes a specific listener by its [listenerName].
  ///
  /// Only listeners that were registered with a name can be removed this way.
  /// If multiple listeners have the same name, all matching listeners are removed.
  ///
  /// Example:
  /// ```dart
  /// final counter = Reactive<int>(0);
  /// counter.addListener(
  ///   (val) => print('Logger: $val'),
  ///   listenerName: 'logger',
  /// );
  /// counter.removeListener(listenerName: 'logger');
  /// ```
  void removeListener({required String listenerName}) {
    _listOfListeners
        .removeWhere((element) => element.functionName == listenerName);
  }

  /// Registers a [listener] that will be called whenever the value changes.
  ///
  /// The listener receives the new value as a parameter. Optionally, you can
  /// provide a [listenerName] to allow later removal of this specific listener.
  ///
  /// Example:
  /// ```dart
  /// final counter = Reactive<int>(0);
  ///
  /// // Anonymous listener
  /// counter.addListener((value) => print('Value: $value'));
  ///
  /// // Named listener for later removal
  /// counter.addListener(
  ///   (value) => print('Named: $value'),
  ///   listenerName: 'myListener',
  /// );
  /// ```
  void addListener(void Function(T value) listener, {String? listenerName}) {
    _listOfListeners
        .add(ListenerFunction(function: listener, functionName: listenerName));
  }

  /// Registers a [callback] that executes every time the value changes.
  ///
  /// This is an alias for [addListener] with a more semantic name for
  /// reactive programming patterns. The callback persists until manually removed.
  ///
  /// Example:
  /// ```dart
  /// final username = Reactive<String>('');
  /// username.ever((value) {
  ///   print('Username changed to: $value');
  ///   validateUsername(value);
  /// });
  /// ```
  void ever(void Function(T value) callback) {
    addListener(callback);
  }

  /// Registers a [callback] that executes only once on the next value change.
  ///
  /// After the callback is executed, it is automatically removed from the
  /// listener list. This is useful for one-time reactions to state changes.
  ///
  /// Example:
  /// ```dart
  /// final isLoading = Reactive<bool>(true);
  /// isLoading.once((value) {
  ///   if (!value) {
  ///     print('Loading completed!');
  ///     showWelcomeMessage();
  ///   }
  /// });
  /// ```
  void once(void Function(T value) callback) {
    late String listenerName;
    listenerName = 'once_${DateTime.now().millisecondsSinceEpoch}';

    addListener((value) {
      callback(value);
      removeListener(listenerName: listenerName);
    }, listenerName: listenerName);
  }

  /// Binds a [stream] to this reactive variable.
  ///
  /// Whenever the stream emits a new value, this reactive variable's [value]
  /// is automatically updated, triggering all listeners and dependent widgets.
  /// Any previous stream binding is cancelled before binding the new stream.
  ///
  /// Returns the [StreamSubscription] for external management if needed.
  ///
  /// Example:
  /// ```dart
  /// final serverData = Reactive<String>('');
  /// final dataStream = Stream.periodic(
  ///   Duration(seconds: 1),
  ///   (i) => 'Data $i',
  /// );
  /// serverData.bindStream(dataStream);
  /// ```
  StreamSubscription<T> bindStream(Stream<T> stream) {
    _streamSubscription?.cancel();
    _streamSubscription = stream.listen((value) => this.value = value);
    return _streamSubscription!;
  }

  /// Configures debounce behavior for value updates.
  ///
  /// When debounce is set, value updates are delayed until the specified
  /// [duration] has passed without any new updates. This is useful for
  /// reducing excessive updates from rapid input changes.
  ///
  /// Use [updateDebounced] to apply debounced updates.
  ///
  /// Example:
  /// ```dart
  /// final searchQuery = Reactive<String>('');
  /// searchQuery.setDebounce(Duration(milliseconds: 500));
  ///
  /// // In a text field's onChanged:
  /// searchQuery.updateDebounced(newText);
  /// // API call only happens 500ms after user stops typing
  /// ```
  void setDebounce(Duration duration) {
    _debounceDuration = duration;
  }

  /// Configures throttle behavior for value updates.
  ///
  /// When throttle is set, value updates are limited to once per [duration].
  /// Additional updates within the duration are ignored. This is useful for
  /// rate-limiting high-frequency events like scroll or mouse movements.
  ///
  /// Use [updateThrottled] to apply throttled updates.
  ///
  /// Example:
  /// ```dart
  /// final scrollPosition = Reactive<double>(0.0);
  /// scrollPosition.setThrottle(Duration(milliseconds: 100));
  ///
  /// // In a scroll listener:
  /// scrollPosition.updateThrottled(newPosition);
  /// // Updates at most once per 100ms
  /// ```
  void setThrottle(Duration duration) {
    _throttleDuration = duration;
  }

  /// Updates the value with debounce applied.
  ///
  /// If debounce is configured via [setDebounce], the update is delayed until
  /// the debounce duration has passed without new updates. If debounce is not
  /// configured, the value is updated immediately.
  ///
  /// Example:
  /// ```dart
  /// final input = Reactive<String>('');
  /// input.setDebounce(Duration(milliseconds: 300));
  ///
  /// input.updateDebounced('a');    // Waits 300ms
  /// input.updateDebounced('ab');   // Cancels previous, waits 300ms
  /// input.updateDebounced('abc');  // Cancels previous, waits 300ms
  /// // Final value 'abc' set after 300ms of inactivity
  /// ```
  void updateDebounced(T value) {
    if (_debounceDuration == null) {
      this.value = value;
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration!, () {
      this.value = value;
    });
  }

  /// Updates the value with throttle applied.
  ///
  /// If throttle is configured via [setThrottle], updates are limited to once
  /// per throttle duration. Additional updates during the throttle period are
  /// ignored. If throttle is not configured, the value is updated immediately.
  ///
  /// Example:
  /// ```dart
  /// final position = Reactive<int>(0);
  /// position.setThrottle(Duration(milliseconds: 100));
  ///
  /// position.updateThrottled(10);  // Updates immediately
  /// position.updateThrottled(20);  // Ignored (within 100ms)
  /// position.updateThrottled(30);  // Ignored (within 100ms)
  /// // After 100ms, next update will be allowed
  /// ```
  void updateThrottled(T value) {
    if (_throttleDuration == null) {
      this.value = value;
      return;
    }

    if (_isThrottling) return;

    this.value = value;
    _isThrottling = true;
    _throttleTimer = Timer(_throttleDuration!, () {
      _isThrottling = false;
    });
  }

  /// Adds a value to the history stack for undo/redo functionality.
  ///
  /// This internal method manages the history list, removing future entries
  /// when adding from a middle position, and limiting the size to [_maxHistorySize].
  void _addToHistory(T value) {
    if (!_historyEnabled) return;

    // Remove any future history if we're in the middle of the history
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    _history.add(value);
    _historyIndex = _history.length - 1;

    // Limit history size
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
      _historyIndex--;
    }
  }

  /// Returns `true` if undo is available.
  ///
  /// Undo is available when history is enabled and there are previous states
  /// to revert to.
  ///
  /// Example:
  /// ```dart
  /// final counter = Reactive<int>(0, enableHistory: true);
  /// print(counter.canUndo); // false (no previous state)
  /// counter.value = 1;
  /// print(counter.canUndo); // true
  /// ```
  bool get canUndo => _historyEnabled && _historyIndex > 0;

  /// Returns `true` if redo is available.
  ///
  /// Redo is available when history is enabled and there are undone states
  /// that can be reapplied.
  ///
  /// Example:
  /// ```dart
  /// final counter = Reactive<int>(0, enableHistory: true);
  /// counter.value = 1;
  /// counter.undo();
  /// print(counter.canRedo); // true
  /// ```
  bool get canRedo => _historyEnabled && _historyIndex < _history.length - 1;

  /// Reverts to the previous value in history.
  ///
  /// Returns `true` if the undo was successful, `false` if there's no
  /// previous state to revert to. This operation does not add to history,
  /// allowing you to redo the change.
  ///
  /// Example:
  /// ```dart
  /// final text = Reactive<String>('', enableHistory: true);
  /// text.value = 'Hello';
  /// text.value = 'Hello World';
  /// text.undo(); // Back to 'Hello'
  /// print(text.value); // 'Hello'
  /// ```
  bool undo() {
    if (!canUndo) return false;

    _historyIndex--;
    _valueNotifier.value = _history[_historyIndex];

    // Call listeners without adding to history
    for (var listener in _listOfListeners) {
      listener.function.call(_history[_historyIndex]);
    }

    return true;
  }

  /// Reapplies a previously undone value.
  ///
  /// Returns `true` if the redo was successful, `false` if there's no
  /// future state to reapply. This operation does not add to history.
  ///
  /// Example:
  /// ```dart
  /// final counter = Reactive<int>(0, enableHistory: true);
  /// counter.value = 1;
  /// counter.value = 2;
  /// counter.undo();           // Back to 1
  /// counter.redo();           // Forward to 2
  /// print(counter.value);     // 2
  /// ```
  bool redo() {
    if (!canRedo) return false;

    _historyIndex++;
    _valueNotifier.value = _history[_historyIndex];

    // Call listeners without adding to history
    for (var listener in _listOfListeners) {
      listener.function.call(_history[_historyIndex]);
    }

    return true;
  }

  /// Clears all history and resets to the current value.
  ///
  /// This removes all undo/redo history while keeping the current value.
  /// The current value becomes the only entry in the history.
  ///
  /// Example:
  /// ```dart
  /// final data = Reactive<int>(0, enableHistory: true);
  /// data.value = 1;
  /// data.value = 2;
  /// data.clearHistory();
  /// print(data.canUndo); // false
  /// ```
  void clearHistory() {
    if (!_historyEnabled) return;
    _history.clear();
    _historyIndex = -1;
    _addToHistory(_valueNotifier.value);
  }

  /// Disposes of all resources used by this reactive variable.
  ///
  /// This method cancels stream subscriptions, timers, and disposes the
  /// underlying [ValueNotifier]. Call this when the reactive variable is
  /// no longer needed to prevent memory leaks.
  ///
  /// Example:
  /// ```dart
  /// final temp = Reactive<int>(0);
  /// // ... use temp ...
  /// temp.close(); // Clean up when done
  /// ```
  void close() {
    _streamSubscription?.cancel();
    _debounceTimer?.cancel();
    _throttleTimer?.cancel();
    _valueNotifier.dispose();
    _listOfListeners.clear();
    _history.clear();
  }
}

/// A reactive variable that supports nullable values.
///
/// [ReactiveN] extends [Reactive] to allow `null` as a valid value.
/// All features from [Reactive] are available, including listeners,
/// history tracking, and debounce/throttle.
///
/// Example:
/// ```dart
/// // String that can be null
/// final username = ReactiveN<String>(null);
/// username.value = 'John';
/// username.value = null; // Valid
///
/// // With type inference
/// final age = ReactiveN<int>(); // Defaults to null
///
/// // With history
/// final data = ReactiveN<String>(
///   'initial',
///   enableHistory: true,
/// );
/// ```
class ReactiveN<T> extends Reactive<T?> {
  /// Creates a [ReactiveN] variable with an optional initial [value].
  ///
  /// Parameters:
  /// - [value]: Initial value (defaults to `null` if not provided)
  /// - [enableHistory]: Enable undo/redo functionality (default: `false`)
  /// - [maxHistorySize]: Maximum history entries to keep (default: `50`)
  ///
  /// Example:
  /// ```dart
  /// final name = ReactiveN<String>(); // null by default
  /// final age = ReactiveN<int>(25);   // Initial value 25
  /// ```
  ReactiveN([
    T? value,
    bool enableHistory = false,
    int maxHistorySize = 50,
  ]) : super(
          value,
          enableHistory: enableHistory,
          maxHistorySize: maxHistorySize,
        );
}
