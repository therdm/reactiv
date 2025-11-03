# Release v1.1.0 - ReactiveBuilder Widgets with Conditional Rebuilds

## 🎉 Overview

This PR introduces the new **ReactiveBuilder** and **MultiReactiveBuilder** widgets, providing a cleaner and more powerful API for reactive UI updates. These widgets replace the deprecated Observer family while maintaining full backward compatibility.

## ✨ New Features

### 1. ReactiveBuilder<T> Widget

A modern replacement for Observer with enhanced capabilities:

```dart
ReactiveBuilder<int>(
  reactiv: controller.count,
  builder: (context, count) => Text('Count: $count'),
  listener: (count) => debugPrint('Changed: $count'),
  buildWhen: (prev, current) => current % 2 == 0,  // 🆕 Conditional rebuild
  listenWhen: (prev, current) => current > 10,      // 🆕 Conditional listener
)
```

**Key Improvements:**
- ✅ `reactiv` parameter (more descriptive than `listenable`)
- ✅ Builder receives unwrapped value directly
- ✅ Optional `listener` for side effects
- ✅ **NEW**: `buildWhen` - Control when to rebuild
- ✅ **NEW**: `listenWhen` - Control when to invoke listener
- ✅ Works with nullable and non-nullable types

### 2. MultiReactiveBuilder Widget

Observe multiple reactive variables with conditional logic:

```dart
MultiReactiveBuilder(
  reactives: [name, age, city],
  builder: (context) => Text('${name.value}, ${age.value}, ${city.value}'),
  listener: () => debugPrint('User info changed'),
  buildWhen: () => age.value >= 18,           // 🆕 Only rebuild when adult
  listenWhen: () => name.value.isNotEmpty,    // 🆕 Only listen when name set
)
```

**Benefits:**
- ✅ Replaces Observer2, Observer3, Observer4, and ObserverN
- ✅ Single widget for any number of reactives
- ✅ **NEW**: Conditional rebuild and listener logic
- ✅ Cleaner than nested observers

### 3. Enhanced Nullable Types Documentation

Complete documentation and examples for nullable reactive types:

```dart
// Nullable reactive types
final username = ReactiveN<String>(null);
final age = ReactiveIntN(null);
final price = ReactiveDoubleN(null);
final isEnabled = ReactiveBoolN(null);

// Use with ReactiveBuilder
ReactiveBuilder<String?>(
  reactiv: username,
  builder: (context, name) => Text(name ?? 'Anonymous'),
)
```

## ⚠️ Deprecations

The following widgets are now deprecated but continue to work:

| Deprecated | Replacement |
|------------|-------------|
| `Observer<T>` | `ReactiveBuilder<T>` |
| `Observer2<A, B>` | `MultiReactiveBuilder` |
| `Observer3<A, B, C>` | `MultiReactiveBuilder` |
| `Observer4<A, B, C, D>` | `MultiReactiveBuilder` |
| `ObserverN` | `MultiReactiveBuilder` |

**Important Notes:**
- ⚠️ Deprecated widgets show warnings but work normally
- ✅ No breaking changes - existing code continues to function
- 📅 Deprecated widgets will be removed in v2.0.0
- 📖 [Migration Guide](MIGRATION_GUIDE.md) available

## 📚 Documentation

### New Documentation Files
- ✅ **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Complete step-by-step migration guide
- ✅ **[RELEASE_v1.1.0.md](RELEASE_v1.1.0.md)** - Detailed release notes
- ✅ **[DOCUMENTATION_UPDATE_SUMMARY.md](DOCUMENTATION_UPDATE_SUMMARY.md)** - List of updated files
- ✅ **[RELEASE_CHECKLIST_v1.1.0.md](RELEASE_CHECKLIST_v1.1.0.md)** - Pre-flight checklist

### Updated Documentation
- ✅ **README.md** - All examples updated + conditional rebuilds section + nullable types
- ✅ **CHANGELOG.md** - Complete v1.1.0 entry with examples
- ✅ **doc/GETTING_STARTED.md** - Updated quick start guide
- ✅ **doc/ADVANCED.md** - Updated advanced patterns
- ✅ **doc/API_REFERENCE.md** - Updated API documentation
- ✅ **example/README.md** - Updated examples documentation
- ✅ **NEW_FEATURES.md** - Updated feature documentation

## ✅ Testing

### Test Coverage
- **Total Tests**: 113/113 passing (100%)
- **New Tests**: 13 for ReactiveBuilder/MultiReactiveBuilder
  - 5 tests for ReactiveBuilder basic functionality
  - 2 tests for buildWhen
  - 2 tests for listenWhen
  - 4 tests for MultiReactiveBuilder
- **Zero Breaking Changes**: All existing tests pass

### Test Highlights
```dart
// buildWhen prevents unnecessary rebuilds
testWidgets('ReactiveBuilder buildWhen controls rebuild', ...);
testWidgets('ReactiveBuilder listenWhen controls listener', ...);
testWidgets('MultiReactiveBuilder buildWhen controls rebuild', ...);
testWidgets('MultiReactiveBuilder listenWhen controls listener', ...);
```

## 📦 Package Changes

### Modified Files (21 total)

**Core Files:**
- `pubspec.yaml` - Version bumped to 1.1.0
- `lib/reactiv.dart` - Added export for reactive_builder.dart

**New Widget Files:**
- `lib/state_management/widgets/reactive_builder.dart`
- `lib/state_management/widgets/reactive_builder_n.dart`

**Deprecated (but functional):**
- `lib/state_management/widgets/observer.dart` - Added @Deprecated
- `lib/state_management/widgets/observer_n.dart` - Added @Deprecated

**Tests:**
- `test/reactive_builder_test.dart` - 13 new comprehensive tests

**Examples:**
- `example/lib/reactive_builder_example.dart` - Working examples

**Documentation:**
- 11 markdown files updated
- 4 new release documentation files

## 🚀 Migration Path

Users can migrate gradually:

1. **Immediate**: Start using ReactiveBuilder in new code
2. **Gradual**: Migrate existing Observer code at your own pace
3. **Future**: Observer widgets will be removed in v2.0.0

See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for detailed instructions.

## 🔄 Before/After Comparison

### Single Reactive Variable

**Before (Observer):**
```dart
Observer(
  listenable: controller.count,
  listener: (count) => Text('Count: $count'),
)
```

**After (ReactiveBuilder):**
```dart
ReactiveBuilder<int>(
  reactiv: controller.count,
  builder: (context, count) => Text('Count: $count'),
  buildWhen: (prev, current) => current % 2 == 0,  // Optional optimization
)
```

### Multiple Reactive Variables

**Before (Observer2):**
```dart
Observer2(
  listenable: firstName,
  listenable2: lastName,
  listener: (first, last) => Text('$first $last'),
)
```

**After (MultiReactiveBuilder):**
```dart
MultiReactiveBuilder(
  reactives: [firstName, lastName],
  builder: (context) => Text('${firstName.value} ${lastName.value}'),
  buildWhen: () => firstName.value.isNotEmpty,  // Optional optimization
)
```

## 💡 Use Cases

### Performance Optimization

Only rebuild when specific conditions are met:

```dart
ReactiveBuilder<int>(
  reactiv: scrollPosition,
  builder: (context, pos) => ScrollIndicator(pos),
  buildWhen: (prev, current) => (current - prev).abs() > 50, // Only update every 50px
)
```

### Conditional Side Effects

Only show dialogs/snackbars when certain thresholds are reached:

```dart
ReactiveBuilder<int>(
  reactiv: errorCount,
  builder: (context, count) => ErrorBadge(count),
  listenWhen: (prev, current) => current > 5,
  listener: (count) => showDialog(...), // Only show when errors > 5
)
```

### Form Validation

Only trigger validation when form is complete:

```dart
MultiReactiveBuilder(
  reactives: [email, password, agreeToTerms],
  builder: (context) => SubmitButton(isValid),
  buildWhen: () => email.value.isNotEmpty && password.value.isNotEmpty,
  listenWhen: () => isFormValid,
  listener: () => enableSubmit(),
)
```

## 🎯 Performance Benefits

The new `buildWhen` and `listenWhen` parameters provide:

- ⚡ **Reduced rebuilds** - Only rebuild when necessary
- 🎯 **Fine-grained control** - Precise control over UI updates
- 💡 **Better UX** - Prevent unnecessary animations/transitions
- 🚀 **Improved performance** - Less widget tree rebuilds

## ✨ Breaking Changes

**NONE** - This release is 100% backward compatible.

## 📋 Checklist

### Code Quality
- [x] All tests passing (113/113)
- [x] No breaking changes
- [x] Code follows project style guidelines
- [x] All new code has inline documentation
- [x] Examples provided and tested

### Documentation
- [x] README updated
- [x] CHANGELOG updated
- [x] Migration guide created
- [x] API reference updated
- [x] Getting started guide updated
- [x] Release notes created

### Testing
- [x] Unit tests added (13 new tests)
- [x] Integration tests passing
- [x] Example app updated and tested
- [x] No regressions in existing functionality

### Release Preparation
- [x] Version bumped to 1.1.0
- [x] CHANGELOG entry complete
- [x] Migration guide complete
- [x] Release notes prepared
- [x] All documentation updated

## 🔗 Related Issues

This PR addresses the need for:
- More intuitive widget naming
- Conditional rebuild capabilities
- Better performance optimization options
- Cleaner API for multiple observables

## 📸 Screenshots

N/A - This is a library package (no UI screenshots needed)

## 👥 Reviewers

@therdm - Please review the implementation, tests, and documentation.

## 📝 Notes for Reviewers

1. **Focus Areas:**
   - ReactiveBuilder implementation with buildWhen/listenWhen
   - Test coverage for conditional logic
   - Documentation clarity and completeness

2. **Key Files to Review:**
   - `lib/state_management/widgets/reactive_builder.dart`
   - `lib/state_management/widgets/reactive_builder_n.dart`
   - `test/reactive_builder_test.dart`
   - `MIGRATION_GUIDE.md`
   - `CHANGELOG.md`

3. **What to Look For:**
   - Correct implementation of buildWhen/listenWhen
   - No memory leaks or performance issues
   - Clear and accurate documentation
   - Comprehensive test coverage

## 🚀 Post-Merge Actions

- [ ] Create GitHub Release with RELEASE_v1.1.0.md content
- [ ] Publish to pub.dev
- [ ] Announce on social media/forums
- [ ] Monitor for any issues

---

**Ready to merge**: ✅ YES

All tests passing, documentation complete, zero breaking changes.
