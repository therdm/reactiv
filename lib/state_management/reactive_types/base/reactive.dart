part of '../../reactive_types.dart';

class ListenerFunction {
  final Function function;
  final String? functionName;

  ListenerFunction({required this.function, this.functionName});
}

/// A generic class representing a reactive variable.
/// It allows tracking and updating the value of the variable.
class Reactive<T> {
  late final ValueNotifier<T> _valueNotifier;
  final List<ListenerFunction> _listOfListeners = [];
  StreamSubscription<T>? _streamSubscription;

  // History tracking for undo/redo
  final bool _historyEnabled;
  final List<T> _history = [];
  int _historyIndex = -1;
  final int _maxHistorySize;

  // Debounce/Throttle
  Timer? _debounceTimer;
  Timer? _throttleTimer;
  Duration? _debounceDuration;
  Duration? _throttleDuration;
  bool _isThrottling = false;

  /// Constructs a [Reactive] object with the initial [value].
  ///
  /// Set [enableHistory] to true to enable undo/redo functionality.
  /// [maxHistorySize] controls how many history states to keep (default: 50).
  Reactive(
    T value, {
    bool enableHistory = false,
    int maxHistorySize = 50,
  })  : _historyEnabled = enableHistory,
        _maxHistorySize = maxHistorySize {
    _valueNotifier = ValueNotifier<T>(value);
    if (_historyEnabled) {
      _addToHistory(value);
    }
  }

  /// Updates the value of the reactive variable to [value].
  set value(T value) {
    _valueNotifier.value = value;

    // Add to history
    if (_historyEnabled) {
      _addToHistory(value);
    }

    // Call registered listeners
    for (var listener in _listOfListeners) {
      listener.function.call(value);
    }
  }

  /// Triggers an update by emitting the current value and help update Observer widget.
  void refresh() {
    final currentValue = _valueNotifier.value;
    _valueNotifier.value = currentValue;

    // Call registered listeners
    for (var listener in _listOfListeners) {
      listener.function.call(currentValue);
    }
  }

  /// Retrieves the current value of the reactive variable.
  T get value => _valueNotifier.value;

  ValueNotifier<T> get valueNotifier => _valueNotifier;

  List<Function> get listeners =>
      _listOfListeners.map((e) => e.function).toList();

  /// Removes all the listeners from a Reactive variable
  void removeAllListeners() {
    _listOfListeners.clear();
  }

  /// Remove a particular listener with name specified previously
  void removeListener({required String listenerName}) {
    _listOfListeners
        .removeWhere((element) => element.functionName == listenerName);
  }

  /// Adds a listener to the list of listeners to a Reactive variable.
  /// The listener function will be called with the current value when it changes.
  ///
  /// @param [listener] The listener function to add.
  /// @param [listenerName] Optional name to identify this listener for removal.
  void addListener(void Function(T value) listener, {String? listenerName}) {
    _listOfListeners
        .add(ListenerFunction(function: listener, functionName: listenerName));
  }

  /// Calls the callback every time the value changes.
  void ever(void Function(T value) callback) {
    addListener(callback);
  }

  /// Calls the callback only once when the value changes, then removes the listener.
  void once(void Function(T value) callback) {
    late String listenerName;
    listenerName = 'once_${DateTime.now().millisecondsSinceEpoch}';

    addListener((value) {
      callback(value);
      removeListener(listenerName: listenerName);
    }, listenerName: listenerName);
  }

  /// `destinationReactive.bindStream(sourceStream)`
  /// here, the [value] of [Reactive] variable [destination] will be updated and refresh the dependent Observers,
  /// whenever a new value is emitted from [sourceStream].
  ///
  /// Returns the [StreamSubscription] so it can be managed externally if needed.
  StreamSubscription<T> bindStream(Stream<T> stream) {
    _streamSubscription?.cancel();
    _streamSubscription = stream.listen((value) => this.value = value);
    return _streamSubscription!;
  }

  /// Sets a debounce duration. Updates will be delayed until the duration has passed
  /// since the last value change.
  void setDebounce(Duration duration) {
    _debounceDuration = duration;
  }

  /// Sets a throttle duration. Updates will be limited to once per duration.
  void setThrottle(Duration duration) {
    _throttleDuration = duration;
  }

  /// Updates the value with debounce applied if configured.
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

  /// Updates the value with throttle applied if configured.
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

  // History management
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

  /// Returns true if undo is available
  bool get canUndo => _historyEnabled && _historyIndex > 0;

  /// Returns true if redo is available
  bool get canRedo => _historyEnabled && _historyIndex < _history.length - 1;

  /// Undo the last change. Returns true if successful.
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

  /// Redo the last undone change. Returns true if successful.
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

  /// Clears the history
  void clearHistory() {
    if (!_historyEnabled) return;
    _history.clear();
    _historyIndex = -1;
    _addToHistory(_valueNotifier.value);
  }

  /// Closes the underlying stream controller and cancels timers.
  void close() {
    _streamSubscription?.cancel();
    _debounceTimer?.cancel();
    _throttleTimer?.cancel();
    _valueNotifier.dispose();
    _listOfListeners.clear();
    _history.clear();
  }
}

/// A specialized version of [Reactive] that supports nullable values.
class ReactiveN<T> extends Reactive<T?> {
  /// Constructs a [ReactiveN] object with an optional initial [value].
  /// Set [enableHistory] to true to enable undo/redo functionality.
  /// [maxHistorySize] controls how many history states to keep (default: 50).
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
