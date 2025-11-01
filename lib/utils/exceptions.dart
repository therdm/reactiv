/// Custom exceptions for the Reactiv package
library;

/// Exception thrown when a dependency is not found in the dependency store
class DependencyNotFoundException implements Exception {
  final Type type;
  final String? tag;

  DependencyNotFoundException(this.type, {this.tag});

  @override
  String toString() {
    final tagInfo = tag != null ? ' with tag "$tag"' : '';
    return 'DependencyNotFoundException: Dependency of type $type$tagInfo is not registered.\n'
        'Please use Dependency.put<$type>($type()) before using Dependency.find<$type>()';
  }
}

/// Exception thrown when attempting to register a dependency that already exists
class DependencyAlreadyExistsException implements Exception {
  final Type type;
  final String? tag;

  DependencyAlreadyExistsException(this.type, {this.tag});

  @override
  String toString() {
    final tagInfo = tag != null ? ' with tag "$tag"' : '';
    return 'DependencyAlreadyExistsException: Dependency of type $type$tagInfo is already registered.\n'
        'Use Dependency.delete<$type>() first or use lazyPut() instead.';
  }
}
