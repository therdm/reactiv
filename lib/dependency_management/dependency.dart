import '../controllers/reactive_controller.dart';
import '../utils/logger.dart';
import '../utils/exceptions.dart';

/// A class that manages dependency injection by storing and retrieving singleton instances of classes.
class Dependency {
  /// A private map that stores the singleton instances of classes.
  static final Map<String, dynamic> _dependencyStore = {};

  /// A private map that stores lazy builders for dependencies.
  static final Map<String, dynamic Function()> _lazyBuilders = {};

  static String _getKey(Type dependencyClass, {String? tag}) {
    return dependencyClass.toString() + (tag ?? '');
  }

  /// Inserts a singleton instance of a class into the dependency store.
  ///
  /// If a dependency with the same type and tag already exists, it will be overwritten
  /// and a warning will be logged.
  ///
  /// The [dependency] parameter is the singleton instance to be inserted.
  /// [fenix] - If true, the dependency will be recreated after being deleted.
  ///
  /// Returns the inserted singleton instance.
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

  /// Lazily registers a dependency builder that will be called when the dependency is first accessed.
  ///
  /// The dependency instance is created only when [find] is called for the first time.
  /// Subsequent calls to [find] will return the same instance.
  ///
  /// [builder] - Function that creates the dependency instance
  /// [tag] - Optional tag to differentiate multiple instances of the same type
  /// [fenix] - If true, the dependency will be recreated after being deleted
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

  /// Inserts a singleton instance only if it doesn't already exist.
  ///
  /// Returns the instance (either existing or newly created).
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

  /// Retrieves a singleton instance of a class from the dependency store.
  ///
  /// If the dependency was registered with [lazyPut], it will be created on first access.
  ///
  /// Returns the singleton instance of the class.
  ///
  /// Throws [DependencyNotFoundException] if the class is not registered.
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

  /// Checks if a dependency is registered (either instantiated or lazy).
  static bool isRegistered<T>({String? tag}) {
    final key = _getKey(T, tag: tag);
    return _dependencyStore[key] != null || _lazyBuilders[key] != null;
  }

  /// Deletes a singleton instance of a class from the dependency store.
  ///
  /// Returns `true` if the deletion is successful, `false` otherwise.
  ///
  /// If the class is not found in the dependency store, a log message will be printed.
  /// If the deleted class is a [ReactiveController], its `onClose()` method will be called before deletion.
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

  /// Removes all dependencies from the store.
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
