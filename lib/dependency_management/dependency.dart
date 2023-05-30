import 'dart:developer';
import '../controllers/reactive_controller.dart';
import '../utils/logger.dart';

/// A class that manages dependency injection by storing and retrieving singleton instances of classes.
class Dependency {
  /// A private map that stores the singleton instances of classes.
  static final Map<String, dynamic> _dependencyStore = {};

  /// Inserts a singleton instance of a class into the dependency store.
  ///
  /// The [dependency] parameter is the singleton instance to be inserted.
  ///
  /// Returns the inserted singleton instance.
  static T put<T>(T dependency) {
    final key = dependency.runtimeType.toString();
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
  static T find<T>() {
    final key = T.toString();
    if (_dependencyStore[key] == null) {
      throw 'class $T is not registered';
    }
    return _dependencyStore[key];
  }

  /// Deletes a singleton instance of a class from the dependency store.
  ///
  /// Returns `true` if the deletion is successful, `false` otherwise.
  ///
  /// If the class is not found in the dependency store, a log message will be printed.
  /// If the deleted class is a [ReactiveController], its `onClose()` method will be called before deletion.
  static bool delete<T>() {
    final key = T.toString();
    if (_dependencyStore[key] == null) {
      Logger.info('class $T is tried to delete but not present in the registry');
      return false;
    } else {
      Logger.info('class $T is being deleted from the registry');
      if (_dependencyStore[key] is ReactiveController) {
        log('$key onDelete() method called');
        (_dependencyStore[key] as ReactiveController).onClose();
      }

      _dependencyStore[key] = null;
      return true;
    }
  }
}
