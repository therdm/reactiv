import '../controllers/reactive_controller.dart';
import '../utils/logger.dart';

/// A class that manages dependency injection by storing and retrieving singleton instances of classes.
class Dependency {
  /// A private map that stores the singleton instances of classes.
  static final Map<String, dynamic> _dependencyStore = {};


  static String _getKey(Type dependencyClass, {String? tag}){
    return dependencyClass.toString() + (tag ?? '');
  }

  /// Inserts a singleton instance of a class into the dependency store.
  ///
  /// The [dependency] parameter is the singleton instance to be inserted.
  ///
  /// Returns the inserted singleton instance.
  static T put<T>(T dependency, {String? tag}) {
    final key = _getKey(dependency.runtimeType, tag: tag);
    if (_dependencyStore[key] == null) {
      _dependencyStore[key] = dependency;
    }
    return _dependencyStore[key];
  }

  /// Retrieves a singleton instance of a class from the dependency store.
  ///
  /// Returns the singleton instance of the class.
  ///
  /// Throws an error if the class is not registered in the dependency store.
  static T find<T>({String? tag}) {
    final key = _getKey(T, tag: tag);
    if (_dependencyStore[key] == null) {
      throw 'Please use \nDependency.put($T()) \nbefore using \nDependency.find<$T>()'
          '\nException : class $T is not present in the Dependency store';
    }
    return _dependencyStore[key];
  }

  /// Deletes a singleton instance of a class from the dependency store.
  ///
  /// Returns `true` if the deletion is successful, `false` otherwise.
  ///
  /// If the class is not found in the dependency store, a log message will be printed.
  /// If the deleted class is a [ReactiveController], its `onClose()` method will be called before deletion.
  static bool delete<T>({String? tag}) {
    final key = _getKey(T, tag: tag);
    if (_dependencyStore[key] == null) {
      Logger.info('class $T is tried to delete but not present in the Dependency store');
      return false;
    } else {
      if (_dependencyStore[key] is ReactiveController) {
        Logger.info('$T onClose() method called');
        (_dependencyStore[key] as ReactiveController).onClose();
      }
      _dependencyStore[key] = null;
      Logger.info('class $T is deleted from the Dependency store');
      return true;
    }
  }
}
