/// Configuration for binding a controller to a [ReactiveState].
///
/// [BindController] specifies how a controller should be created and managed
/// within a widget's lifecycle. It controls lazy initialization, automatic
/// disposal, and provides the factory function for controller creation.
///
/// Example:
/// ```dart
/// class _MyPageState extends ReactiveState<MyPage, MyController> {
///   @override
///   BindController<MyController> bindController() {
///     return BindController(
///       controller: () => MyController(),
///       autoDispose: true,  // Dispose when widget is removed
///       lazyBind: false,    // Create immediately, not on first use
///     );
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Observer(
///       listenable: controller.data,
///       listener: (value) => Text(value),
///     );
///   }
/// }
/// ```
class BindController<S> {
  /// Factory function that creates the controller instance.
  final S Function() controller;

  /// Whether to automatically dispose the controller when the widget is disposed.
  ///
  /// Defaults to `true`. Set to `false` if you want to keep the controller
  /// alive after the widget is removed (e.g., for navigation back scenarios).
  final bool autoDispose;

  /// Whether to create the controller lazily on first access.
  ///
  /// Defaults to `true`. If `true`, the controller is created when first accessed.
  /// If `false`, the controller is created immediately during widget initialization.
  final bool lazyBind;

  /// Creates a [BindController] configuration.
  ///
  /// Parameters:
  /// - [controller]: Factory function for creating the controller instance
  /// - [autoDispose]: Auto-dispose on widget removal (default: `true`)
  /// - [lazyBind]: Lazy initialization (default: `true`)
  ///
  /// Example:
  /// ```dart
  /// // Eager creation, auto-dispose
  /// BindController(
  ///   controller: () => MyController(),
  ///   lazyBind: false,
  /// );
  ///
  /// // Lazy creation, manual management
  /// BindController(
  ///   controller: () => SharedController(),
  ///   autoDispose: false,
  ///   lazyBind: true,
  /// );
  /// ```
  BindController({
    required this.controller,
    this.autoDispose = true,
    this.lazyBind = true,
  });
}
