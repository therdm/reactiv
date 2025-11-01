# Logger Framework Documentation

## Overview

The Reactiv Logger is a robust, production-ready logging framework.

Features:
- ✅ Multiple log levels (verbose, debug, info, warning, error, wtf)
- ✅ Pretty JSON formatting
- ✅ Stack trace support
- ✅ Performance timing
- ✅ Table formatting
- ✅ Configurable output
- ✅ Custom handlers
- ✅ ANSI color support

## Quick Start

```dart
import 'package:reactiv/reactiv.dart';

// Use default configuration
Logger.info('Application started');
Logger.error('Something went wrong');
```

## Configuration

### Predefined Configurations

```dart
// Development mode (verbose logging)
Logger.config = LoggerConfig.development;

// Production mode (minimal logging)
Logger.config = LoggerConfig.production;

// Testing mode (warnings and errors only)
Logger.config = LoggerConfig.testing;
```

See docs/LOGGER.md for complete documentation.
