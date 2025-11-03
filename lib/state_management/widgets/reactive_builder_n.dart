part of 'reactive_builder.dart';

/// A widget that observes changes in multiple reactive variables and triggers a rebuild when any variable changes.
///
/// [ReactiveBuilderN] listens to a list of reactive variables and rebuilds
/// whenever any of them changes. This is useful when your UI depends on multiple
/// reactive state values.
///
/// Example:
/// ```dart
/// final name = Reactive<String>('John');
/// final age = Reactive<int>(25);
/// final city = Reactive<String>('NYC');
///
/// ReactiveBuilderN(
///   reactives: [name, age, city],
///   builder: (context) {
///     return Text('${name.value}, ${age.value}, ${city.value}');
///   },
///   listener: () {
///     debugPrint('One of the values changed');
///   },
///   buildWhen: () => age.value >= 18,  // Only rebuild when age >= 18
///   listenWhen: () => name.value.isNotEmpty,  // Only listen when name is not empty
/// );
/// ```
class ReactiveBuilderN extends StatelessWidget {
  /// Creates a [ReactiveBuilderN] widget.
  ///
  /// The [reactives] parameter is a list of reactive variables to observe.
  /// The [builder] callback builds the widget tree and is called whenever
  /// any of the reactive variables changes.
  /// The optional [listener] callback is invoked for side effects.
  /// The optional [buildWhen] callback determines whether to rebuild the widget.
  /// The optional [listenWhen] callback determines whether to invoke the listener.
  const ReactiveBuilderN({
    Key? key,
    required this.reactives,
    required this.builder,
    this.listener,
    this.buildWhen,
    this.listenWhen,
  }) : super(key: key);

  /// The list of reactive variables to listen to for changes.
  final List<Reactive> reactives;

  /// Builder function called whenever any reactive variable changes.
  ///
  /// This function should return the widget tree to display.
  /// Access reactive values using `.value` property inside the builder.
  final Widget Function(BuildContext context) builder;

  /// Optional listener function called whenever any reactive variable changes.
  ///
  /// This function is invoked before the builder and can be used for
  /// side effects like logging, navigation, or showing snackbars.
  final void Function()? listener;

  /// Optional condition to determine whether the widget should rebuild.
  ///
  /// If provided, the widget will only rebuild when this function returns true.
  /// The function is called whenever any reactive variable changes.
  ///
  /// Example:
  /// ```dart
  /// buildWhen: () => age.value >= 18,  // Only rebuild when adult
  /// buildWhen: () => items.value.isNotEmpty,  // Only rebuild when has items
  /// ```
  final bool Function()? buildWhen;

  /// Optional condition to determine whether the listener should be invoked.
  ///
  /// If provided, the listener will only be called when this function returns true.
  /// The function is called whenever any reactive variable changes.
  ///
  /// Example:
  /// ```dart
  /// listenWhen: () => count.value > 10,  // Only listen when count > 10
  /// listenWhen: () => isValid.value,     // Only listen when valid
  /// ```
  final bool Function()? listenWhen;

  Widget _buildObserver(BuildContext context, int index) {
    if (reactives.length <= index) {
      return builder(context);
    }
    
    return ReactiveBuilder(
      reactiv: reactives[index],
      builder: (ctx, _) {
        return _buildObserver(ctx, index + 1);
      },
      listener: listener != null ? (_) {
        // Check listenWhen condition
        if (listenWhen != null && !listenWhen!()) {
          return; // Don't call listener if condition is false
        }
        listener!();
      } : null,
      buildWhen: buildWhen != null ? (_, __) => buildWhen!() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildObserver(context, 0);
  }
}
