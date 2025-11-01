# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-01

🎉 **Major Release** - Production-ready with comprehensive improvements and new features!

### 🔴 Fixed (Critical)

- **Fixed memory leak in `addListener`**: Listeners are now properly invoked when reactive values change
- **Fixed memory leak in `bindStream`**: Stream subscriptions are now properly managed and cancelled
- **Fixed `Observer` widget performance**: Now uses optimized `value` parameter instead of redundant lookups
- **Removed unnecessary `async` keywords**: Methods `addListener()` and `removeListener()` are now synchronous

### ⚡ Performance

- **Batched updates for `ReactiveList`**: Multiple mutations in the same frame trigger only one rebuild
- **Batched updates for `ReactiveSet`**: Same batching strategy to prevent excessive rebuilds
- **Optimized Observer rebuilds**: Eliminated unnecessary value access in widget builders

### ✨ New Features

#### State Management
- **Undo/Redo support**: Enable history tracking with `enableHistory: true` parameter
  - Methods: `undo()`, `redo()`, `canUndo`, `canRedo`, `clearHistory()`
  - Configurable history size with `maxHistorySize` parameter (default: 50)
- **Computed reactive values**: New `ComputedReactive<T>` class for auto-updating derived state
- **Debounce support**: Delay updates with `setDebounce()` and `updateDebounced()` methods
- **Throttle support**: Limit update frequency with `setThrottle()` and `updateThrottled()` methods
- **Ever & Once utilities**: Convenient listener methods
  - `ever(callback)` - called on every value change
  - `once(callback)` - called once then auto-removed

#### Dependency Management
- **Lazy dependency injection**: `Dependency.lazyPut<T>()` for deferred instantiation
- **Put with overwrite**: `put()` now overwrites existing dependencies with warning
- **Conditional registration**: New `putIfAbsent()` method
- **Dependency checking**: New `isRegistered<T>()` method
- **Global reset**: New `reset()` method to clear all dependencies
- **Fenix mode**: Auto-recreation after deletion with `fenix: true` parameter

### 🛠️ Improvements

#### Code Quality
- **Custom exceptions**: New exception classes with helpful error messages
  - `DependencyNotFoundException`
  - `DependencyAlreadyExistsException`
- **Explicit return types**: All methods now have proper return type declarations
- **Fixed typo**: Corrected "associa ted" to "associated" in documentation

#### Developer Experience
- **Configurable logging**: Control logging with `Logger.enabled` flag
- **Warning and error logs**: New `Logger.warn()` and `Logger.error()` methods
- **Better error messages**: All exceptions provide clear, actionable information
- **Stream subscription management**: `bindStream()` now returns `StreamSubscription` for external control

### 📚 Documentation

- **NEW_FEATURES.md**: Comprehensive guide to all new features with examples
- **QUICK_REFERENCE.md**: Quick-start guide for common use cases
- **IMPLEMENTATION_SUMMARY.md**: Technical implementation details
- **Advanced example**: New `advanced_features_example.dart` demonstrating all features

### 🔄 Changed

- All reactive types (`ReactiveInt`, `ReactiveString`, etc.) now support optional parameters:
  - `enableHistory` - Enable undo/redo functionality
  - `maxHistorySize` - Configure history buffer size
- `ReactiveN` class updated to support new optional parameters
- `Dependency.put()` behavior changed to overwrite with warning (previously silently ignored)
- `bindStream()` now returns `StreamSubscription` instead of `void`

### ⚠️ Deprecated

None - All changes are backward compatible!

### 🚫 Breaking Changes

**None!** Version 1.0.0 maintains full backward compatibility with 0.3.x versions.

### 📦 Migration Guide

No migration needed! All new features are opt-in. To use them:

1. **Enable logging control**:
   ```dart
   Logger.enabled = false; // Disable in production
   ```

2. **Use history tracking**:
   ```dart
   final text = ReactiveString('Hello', enableHistory: true);
   ```

3. **Create computed values**:
   ```dart
   final fullName = ComputedReactive(
     () => '${firstName.value} ${lastName.value}',
     [firstName, lastName],
   );
   ```

4. **Use lazy dependencies**:
   ```dart
   Dependency.lazyPut(() => MyController());
   ```

### 📊 Statistics

- **Files changed**: 20
- **Lines added**: 1,457
- **Lines removed**: 118
- **New features**: 8
- **Bug fixes**: 4
- **Performance improvements**: 3
- **Code quality improvements**: 7

---

## [0.3.6] - Previous Release

New widget ObserverN that accepts List of Reactive variables

## [0.3.5]

Implement un-implemented methods in ReactiveSet

## [0.3.4]

1. New method added `initStateWithContext(BuildContext context)`

## [0.3.3]

1. Now bind controller needs to be through Function(). e.g, `BindController(controller: () => MyCounterController())`

## [0.3.2]

1. Now bind controller needs to be through Function(). e.g, `BindController(controller: () => MyCounterController())`

## [0.3.1]

1. Added listeners getter
2. Added option for remove all listeners

## [0.3.0]

1. Introduced BindController Class to bind the controllers with the screen smart and seamlessly

## [0.2.6]

1. Added support for `.reactiv` for bool and num types
2. Update readme.md

## [0.2.5]

Update readme.md

## [0.2.4]

1. ReactiveBool, ReactiveNum, ReactiveMap, ReactiveSet

## [0.2.3]

1. addListener method for Reactive variables
2. Update ReadMe

## [0.2.2]

1. New method in Reactive types, bindStream to deal with streams
2. ReactiveStateWidget and ReactiveState

## [0.2.1]

1. Update readme

## [0.2.0]

1. Breaking Change: params change
   1. listen => listenable
   2. update => listener

## [0.1.3]

1. Stream change to broadcast stream
2. Params change
   1. listen => listenable
   2. update => listener
3. ReactiveWidget major update:
   1. Auto dispose the controller functionality
   2. bindDependency method to Dependency.put() the dependency
   3. Life-cycle methods void initState(), void dispose(), methods added in ReactiveWidget

## [0.1.2]

1. `.reactiv` extension added
2. ReactiveList all the methods added for add new element and remove element from the list

## [0.1.1]

Update documentation

## [0.1.0]

Update documentation

## [0.0.3]

Update example and readme

## [0.0.2]

Name change:
1. Reaction => Observer
2. cause => listen
3. effect => update
4. Import file optimisations

## [0.0.1]

Initial release. A new Reactive state management approach and dependency injection inspired by GetX
