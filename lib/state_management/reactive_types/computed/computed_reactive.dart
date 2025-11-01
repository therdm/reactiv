part of '../../reactive_types.dart';

/// A reactive value that automatically recomputes when its dependencies change.
///
/// Example:
/// ```dart
/// final firstName = 'John'.reactiv;
/// final lastName = 'Doe'.reactiv;
///
/// final fullName = ComputedReactive<String>(
///   () => '${firstName.value} ${lastName.value}',
///   dependencies: [firstName, lastName],
/// );
///
/// print(fullName.value); // 'John Doe'
/// firstName.value = 'Jane';
/// print(fullName.value); // 'Jane Doe'
/// ```
class ComputedReactive<T> extends Reactive<T> {
  final T Function() _compute;
  final List<Reactive> _dependencies;
  final List<void Function(dynamic)> _listeners = [];

  /// Creates a computed reactive value.
  ///
  /// [compute] - Function that computes the value based on dependencies
  /// [dependencies] - List of reactive variables this computed value depends on
  ComputedReactive(
    T Function() compute,
    List<Reactive> dependencies,
  )   : _compute = compute,
        _dependencies = dependencies,
        super(compute()) {
    _setupListeners();
  }

  void _setupListeners() {
    for (var dependency in _dependencies) {
      void listener(dynamic _) {
        value = _compute();
      }

      _listeners.add(listener);
      dependency.addListener(listener);
    }
  }

  @override
  void close() {
    // Remove listeners from dependencies
    for (var i = 0; i < _dependencies.length; i++) {
      _dependencies[i].removeAllListeners();
    }
    _listeners.clear();
    super.close();
  }
}
