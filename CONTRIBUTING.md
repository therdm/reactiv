# Contributing to Reactiv

Thank you for your interest in contributing to Reactiv! We welcome contributions from the community.

## How to Contribute

### Reporting Issues

If you find a bug or have a feature request:

1. Check if the issue already exists in the [Issues](https://github.com/therdm/reactiv/issues) section
2. If not, create a new issue with a clear title and description
3. For bugs, include:
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Flutter and Dart versions
   - Code samples if applicable

### Submitting Pull Requests

1. **Fork the repository** and create a new branch from `master`
2. **Make your changes** following the code style guidelines
3. **Add tests** for any new functionality
4. **Run tests** to ensure everything works
5. **Format your code** using `dart format`
6. **Commit your changes** with clear, descriptive commit messages
7. **Push to your fork** and submit a pull request

### Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/therdm/reactiv.git
   cd reactiv
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run tests:
   ```bash
   flutter test
   ```

4. Run the example app:
   ```bash
   cd example
   flutter run
   ```

### Code Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format your code before committing
- Run `dart analyze` to check for linting issues
- Keep code clean, readable, and well-documented

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Running Analysis

```bash
# Run static analysis
dart analyze

# Check formatting
dart format --set-exit-if-changed .
```

### Commit Messages

- Use clear and descriptive commit messages
- Start with a verb in present tense (e.g., "Add", "Fix", "Update")
- Reference issue numbers when applicable (e.g., "Fix #123")

Examples:
- `Add support for async state updates`
- `Fix memory leak in Observer widget`
- `Update documentation for ReactiveController`

## Code of Conduct

Please note that this project is released with a [Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project, you agree to abide by its terms.

## Questions?

If you have questions about contributing, feel free to:
- Open a discussion in the [Discussions](https://github.com/therdm/reactiv/discussions) section
- Ask in an issue
- Reach out to the maintainers

Thank you for contributing to Reactiv! 🎉
