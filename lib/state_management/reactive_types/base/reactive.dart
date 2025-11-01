part of '../../reactive_types.dart';

class ListenerFunction {
  final Function function;
  final String? functionName;

  ListenerFunction({required this.function, this.functionName});
}

/// A generic class representing a reactive variable.
/// It allows tracking and updating the value of the variable.
class Reactive<T> {
  // late T _value;
  // late final StreamController<T> _streamController;
  
  late final ValueNotifier<T> _valueNotifier;
  
  
  /// Constructs a [Reactive] object with the initial [value].
  Reactive(T value) {
    // this._value = value;
    _valueNotifier = ValueNotifier<T>(value);
    // _streamController = StreamController<T>.broadcast();
    // refresh();
  }

  /// Updates the value of the reactive variable to [value].
  set value(T value) {
    this._valueNotifier.value = value;
    // refresh();
  }

  /// Triggers an update by emitting the current value and help update Observer widget.
  void refresh() {
    // Trigger notification by reassigning the current value
    _valueNotifier.value = _valueNotifier.value;
    // if (_listOfListeners.isNotEmpty) {
    //   for (var element in _listOfListeners) {
    //     element.function.call(value);
    //   }
    // }
  }

  List<ListenerFunction> _listOfListeners = <ListenerFunction>[];

  List<Function> get listeners => _listOfListeners.map((e) => e.function).toList();

  ///Removes all the listeners from a Reactive variable
  removeAllListeners() {
    _listOfListeners = <ListenerFunction>[];
  }

  ///remove a particular listener with name specified previously
  removeListener({required String listenerName}) async {
    _listOfListeners.removeWhere((element) => element.functionName == listenerName);
  }

  ///Adds a listener to the list of listeners to a Reactive variable
  ///The listener function will be called with the current value gets changed.
  ///@param [listener] The listener function to add.
  addListener(Function(T value) listener, {String? listenerName}) async {
    _listOfListeners.add(ListenerFunction(function: listener, functionName: listenerName));
  }

  /// `destinationReactive.bindStream(sourceStream)`
  /// here, the [value] of [Reactive] variable [destination] will be updated and refresh the dependent Observers,
  /// whenever a new value is emitted from [sourceStream].
  void bindStream(Stream<T> stream) {
    stream.listen((value) => this.value = value);
  }

  /// Retrieves the current value of the reactive variable.
  T get value => this._valueNotifier.value;

  ValueNotifier<T> get valueNotifier => _valueNotifier;



  /// Returns a [ReactiveNotifier] object associated with this [Reactive] instance.
  /// The [ReactiveNotifier] allows listening to changes in the reactive variable.
  // ReactiveNotifier<T> get notifier {
  //   return ReactiveNotifier(_valueNotifier.stream);
  // }

  /// Closes the underlying stream controller.
  void close() {
    _valueNotifier.dispose();
  }
}

/// A specialized version of [Reactive] that supports nullable values.
class ReactiveN<T> extends Reactive<T?> {
  /// Constructs a [ReactiveN] object with an optional initial [value].
  ReactiveN([T? value]) : super(value);
}
