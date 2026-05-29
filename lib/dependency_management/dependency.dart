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
/// // Conditional registration
/// Dependency.putIfAbsent<CacheService>(() => CacheService());
///
/// // Lazy conditional registration
/// Dependency.lazyPutIfAbsent<ApiClient>(() => ApiClient());
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

  /// Internal storage for fenix mode tracking.
  static final Set<String> _fenixKeys = {};

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
  ///
  /// Returns the registered instance.
  ///
  /// Example:
  /// ```dart
  /// final controller = Dependency.put(MyController());
  ///
  /// // With tag
  /// Dependency.put(AuthService(), tag: 'primary');
  /// ```
  static T put<T>(
    T dependency, {
    String? tag,
  }) {
    final key = _getKey(dependency.runtimeType, tag: tag);

    if (_dependencyStore[key] != null) {
      Logger.warn(
        'Dependency of type ${dependency.runtimeType} is being overwritten',
        tag: 'Dependency',
      );
    }

    _dependencyStore[key] = dependency;

    // // Note: fenix mode for put() is currently not fully implemented
    // // For phoenix behavior with recreation, use lazyPut() instead
    // if (fenix) {
    //   // Reserved for future implementation
    // }

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
      _fenixKeys.add(key);
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

  /// Registers a lazy dependency builder only if it doesn't already exist.
  ///
  /// If a dependency with the same type and tag exists (either instantiated
  /// or as a lazy builder), this method does nothing. Otherwise, it registers
  /// the lazy builder. The dependency instance is created only when [find] is
  /// called for the first time.
  ///
  /// This combines the benefits of [lazyPut] (deferred initialization) and
  /// [putIfAbsent] (conditional registration).
  ///
  /// Parameters:
  /// - [builder]: Function that creates the dependency instance
  /// - [tag]: Optional identifier for multiple instances
  /// - [fenix]: If `true`, rebuilds the dependency after deletion
  ///
  /// Example:
  /// ```dart
  /// // First call registers the lazy builder
  /// Dependency.lazyPutIfAbsent<DatabaseService>(
  ///   () => DatabaseService(),
  /// );
  ///
  /// // Second call does nothing (builder already registered)
  /// Dependency.lazyPutIfAbsent<DatabaseService>(
  ///   () => DatabaseService(),
  /// );
  ///
  /// // With tag and phoenix mode
  /// Dependency.lazyPutIfAbsent<CacheService>(
  ///   () => CacheService(),
  ///   tag: 'primary',
  ///   fenix: true,
  /// );
  ///
  /// // Instance is created only when first accessed
  /// final db = Dependency.find<DatabaseService>();
  /// ```
  static void lazyPutIfAbsent<T>(
    T Function() builder, {
    String? tag,
    bool fenix = false,
  }) {
    final key = _getKey(T, tag: tag);

    // Check if dependency already exists (either instantiated or lazy)
    if (_dependencyStore[key] != null || _lazyBuilders[key] != null) {
      return;
    }

    _lazyBuilders[key] = builder;

    if (fenix) {
      _fenixKeys.add(key);
    }
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

    // Only remove lazy builder if NOT in fenix mode
    if (_lazyBuilders[key] != null && !_fenixKeys.contains(key)) {
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
    _fenixKeys.clear();
    Logger.info('All dependencies have been reset', tag: 'Dependency');
  }
}
