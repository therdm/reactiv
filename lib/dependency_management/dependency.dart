import '../controllers/reactive_controller.dart';
import '../utils/logger.dart';
import '../utils/exceptions.dart';

/// A lightweight dependency injection system for managing singleton instances.
///
/// [Dependency] provides a centralized store for managing object lifecycles
/// in your application. It supports both eager and lazy initialization,
/// optional tagging for multiple instances, and automatic cleanup.
///
/// Key features:
/// - Singleton pattern enforcement
/// - Lazy initialization support
/// - Tagged instances for multiple controllers
/// - Automatic [ReactiveController] lifecycle management
/// - Phoenix mode for auto-recreation after deletion
///
/// Example:
/// ```dart
/// // Register a controller
/// final controller = Dependency.put(MyController());
///
/// // Retrieve it anywhere
/// final ctrl = Dependency.find<MyController>();
///
/// // Lazy registration
/// Dependency.lazyPut<DataService>(() => DataService());
///
/// // With tags for multiple instances
/// Dependency.put(UserController(), tag: 'admin');
/// Dependency.put(UserController(), tag: 'guest');
/// final admin = Dependency.find<UserController>(tag: 'admin');
/// ```
class Dependency {
  /// Internal storage for instantiated dependencies.
  static final Map<String, dynamic> _dependencyStore = {};

  /// Internal storage for lazy dependency builders.
  static final Map<String, dynamic Function()> _lazyBuilders = {};

  /// Generates a unique key for dependency storage.
  ///
  /// Combines type name with optional tag to allow multiple instances
  /// of the same type.
  static String _getKey(Type dependencyClass, {String? tag}) {
    return dependencyClass.toString() + (tag ?? '');
  }

  /// Registers a singleton instance in the dependency store.
  ///
  /// If a dependency with the same type and tag already exists, it will be
  /// overwritten with a warning logged.
  ///
  /// Parameters:
  /// - [dependency]: The instance to register
  /// - [tag]: Optional identifier for multiple instances of the same type
  /// - [fenix]: If `true`, the dependency will auto-recreate after deletion
  ///
  /// Returns the registered instance.
  ///
  /// Example:
  /// ```dart
  /// final controller = Dependency.put(MyController());
  ///
  /// // With tag
  /// Dependency.put(AuthService(), tag: 'primary');
  ///
  /// // Phoenix mode - auto-recreates
  /// Dependency.put(CacheService(), fenix: true);
  /// ```
  static T put<T>(
    T dependency, {
    String? tag,
    bool fenix = false,
  }) {
    final key = _getKey(dependency.runtimeType, tag: tag);

    if (_dependencyStore[key] != null) {
      Logger.warn(
        'Dependency of type ${dependency.runtimeType} is being overwritten',
        tag: 'Dependency',
      );
    }

    _dependencyStore[key] = dependency;

    if (fenix) {
      _lazyBuilders[key] = () => dependency;
    }

    return _dependencyStore[key];
  }

  /// Registers a lazy dependency builder.
  ///
  /// The dependency instance is created only when [find] is called for the
  /// first time. Subsequent calls return the same instance.
  ///
  /// This is useful for expensive objects that may not be needed immediately.
  ///
  /// Parameters:
  /// - [builder]: Function that creates the dependency instance
  /// - [tag]: Optional identifier for multiple instances
  /// - [fenix]: If `true`, rebuilds the dependency after deletion
  ///
  /// Example:
  /// ```dart
  /// // Basic lazy registration
  /// Dependency.lazyPut<DatabaseService>(() => DatabaseService());
  ///
  /// // With tag
  /// Dependency.lazyPut<ApiClient>(
  ///   () => ApiClient(baseUrl: 'https://api.example.com'),
  ///   tag: 'production',
  /// );
  ///
  /// // Phoenix mode
  /// Dependency.lazyPut<CacheManager>(
  ///   () => CacheManager(),
  ///   fenix: true,
  /// );
  /// ```
  static void lazyPut<T>(
    T Function() builder, {
    String? tag,
    bool fenix = false,
  }) {
    final key = _getKey(T, tag: tag);

    if (_lazyBuilders[key] != null) {
      Logger.warn(
        'Lazy builder for type $T is being overwritten',
        tag: 'Dependency',
      );
    }

    _lazyBuilders[key] = builder;

    if (fenix) {
      // Fenix lazy dependencies will recreate themselves
    }
  }

  /// Registers a dependency only if it doesn't already exist.
  ///
  /// If a dependency with the same type and tag exists, returns the existing
  /// instance. Otherwise, creates and registers a new instance using [builder].
  ///
  /// Parameters:
  /// - [builder]: Function that creates the dependency if needed
  /// - [tag]: Optional identifier for multiple instances
  ///
  /// Returns either the existing or newly created instance.
  ///
  /// Example:
  /// ```dart
  /// // First call creates the instance
  /// final service1 = Dependency.putIfAbsent<DataService>(
  ///   () => DataService(),
  /// );
  ///
  /// // Second call returns the same instance
  /// final service2 = Dependency.putIfAbsent<DataService>(
  ///   () => DataService(),
  /// );
  ///
  /// print(identical(service1, service2)); // true
  /// ```
  static T putIfAbsent<T>(
    T Function() builder, {
    String? tag,
  }) {
    final key = _getKey(T, tag: tag);

    if (_dependencyStore[key] != null) {
      return _dependencyStore[key];
    }

    final dependency = builder();
    _dependencyStore[key] = dependency;
    return dependency;
  }

  /// Retrieves a registered dependency instance.
  ///
  /// If the dependency was registered with [lazyPut], it will be instantiated
  /// on first access. Subsequent calls return the cached instance.
  ///
  /// Parameters:
  /// - [tag]: Optional identifier if multiple instances exist
  ///
  /// Returns the dependency instance.
  ///
  /// Throws [DependencyNotFoundException] if not registered.
  ///
  /// Example:
  /// ```dart
  /// // Basic retrieval
  /// final controller = Dependency.find<MyController>();
  ///
  /// // With tag
  /// final admin = Dependency.find<UserService>(tag: 'admin');
  ///
  /// // Use in widgets
  /// class MyWidget extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final controller = Dependency.find<CounterController>();
  ///     return Observer(
  ///       listenable: controller.count,
  ///       listener: (value) => Text('$value'),
  ///     );
  ///   }
  /// }
  /// ```
  static T find<T>({String? tag}) {
    final key = _getKey(T, tag: tag);

    // Check if already instantiated
    if (_dependencyStore[key] != null) {
      return _dependencyStore[key];
    }

    // Check if lazy builder exists
    if (_lazyBuilders[key] != null) {
      final instance = _lazyBuilders[key]!();
      _dependencyStore[key] = instance;
      return instance;
    }

    throw DependencyNotFoundException(T, tag: tag);
  }

  /// Checks if a dependency is registered.
  ///
  /// Returns `true` if the dependency exists (either instantiated or lazy).
  ///
  /// Example:
  /// ```dart
  /// if (Dependency.isRegistered<AuthService>()) {
  ///   final auth = Dependency.find<AuthService>();
  ///   auth.checkSession();
  /// } else {
  ///   // Handle missing dependency
  /// }
  /// ```
  static bool isRegistered<T>({String? tag}) {
    final key = _getKey(T, tag: tag);
    return _dependencyStore[key] != null || _lazyBuilders[key] != null;
  }

  /// Removes a dependency from the store.
  ///
  /// If the dependency is a [ReactiveController], its [onClose] method is
  /// called before removal to perform cleanup.
  ///
  /// Parameters:
  /// - [tag]: Optional identifier if multiple instances exist
  ///
  /// Returns `true` if deletion was successful, `false` if not found.
  ///
  /// Note: Phoenix dependencies will be recreated on next [find] call.
  ///
  /// Example:
  /// ```dart
  /// // Delete a controller
  /// Dependency.delete<UserController>();
  ///
  /// // Delete tagged instance
  /// Dependency.delete<ApiClient>(tag: 'staging');
  ///
  /// // In a widget's dispose:
  /// @override
  /// void dispose() {
  ///   Dependency.delete<MyController>();
  ///   super.dispose();
  /// }
  /// ```
  static bool delete<T>({String? tag}) {
    final key = _getKey(T, tag: tag);

    if (_dependencyStore[key] == null && _lazyBuilders[key] == null) {
      Logger.info(
        'class $T is tried to delete but not present in the Dependency store',
        tag: 'Dependency',
      );
      return false;
    }

    // Call onClose if it's a ReactiveController
    if (_dependencyStore[key] != null &&
        _dependencyStore[key] is ReactiveController) {
      Logger.info('$T onClose() method called', tag: 'Dependency');
      (_dependencyStore[key] as ReactiveController).onClose();
    }

    _dependencyStore[key] = null;

    // Don't remove lazy builder if fenix mode is enabled
    final builder = _lazyBuilders[key];
    if (builder != null) {
      _lazyBuilders.remove(key);
    }

    Logger.info('class $T is deleted from the Dependency store',
        tag: 'Dependency');
    return true;
  }

  /// Removes all dependencies and resets the store.
  ///
  /// Calls [onClose] on all [ReactiveController] instances before clearing.
  /// This is useful for app-wide cleanup, testing, or logout scenarios.
  ///
  /// Example:
  /// ```dart
  /// // On app logout
  /// void logout() {
  ///   Dependency.reset(); // Clean up all controllers
  ///   Navigator.pushReplacementNamed(context, '/login');
  /// }
  ///
  /// // In tests
  /// tearDown(() {
  ///   Dependency.reset();
  /// });
  /// ```
  static void reset() {
    // Call onClose on all ReactiveControllers
    _dependencyStore.forEach((key, value) {
      if (value is ReactiveController) {
        value.onClose();
      }
    });

    _dependencyStore.clear();
    _lazyBuilders.clear();
    Logger.info('All dependencies have been reset', tag: 'Dependency');
  }
}
