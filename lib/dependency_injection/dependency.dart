import 'dart:developer';
import '../controllers/reactive_controller.dart';
import '../utils/logger.dart';

class Dependency {
  static final Map<String, dynamic> _dependencyStore = {};

  static T put<T>(T dependency) {
    final key = dependency.runtimeType.toString();
    if (_dependencyStore[key] == null) {
      _dependencyStore[key] = dependency;
    }
    return _dependencyStore[key];
  }

  static T find<T>() {
    final key = T.toString();
    if (_dependencyStore[key] == null) {
      throw 'class $T is not registered';
    }
    return _dependencyStore[key];
  }

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
