# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

Veto is a lightweight MVVM (Model-View-ViewModel) state management solution for Flutter. It was inspired by the FilledStacks [stacked](https://pub.dev/packages/stacked) package and provides utilities to simplify managing view logic, state, and lifecycle in Flutter applications.

## Commands

### Development

```bash
# Get dependencies
flutter pub get

# Analyze project
flutter analyze

# Format code
dart format .
```

### Testing

```bash
# Run all tests
flutter test

# Run unit tests
flutter test test/veto_unit_test.dart

# Run widget tests
flutter test test/veto_widget_test.dart

# Run a specific test file
flutter test test/path/to/test_file.dart
```

### Example App

```bash
# Run the example app
cd example
flutter pub get
flutter run
```

## Architecture

### Core Components

1. **BaseViewModel**: Abstract class for creating ViewModels
   - Manages lifecycle (initialize, dispose)
   - Provides access to BuildContext
   - Handles initialization state
   - Contains rebuild mechanism to update UI

2. **ViewModelBuilder**: Widget that connects the ViewModel to the View
   - Creates and provides the ViewModel
   - Handles lifecycle
   - Rebuilds on ViewModel changes
   - Passes arguments to the ViewModel

3. **Mixins**: Utility mixins for common functionality
   - **BusyManagement**: Manages loading states with optional messages
   - **ErrorManagement**: Manages error states with optional messages
   - **ViewModelHelpers**: Provides utility methods (wait, postFrameCallback)
   - **BusyServiceManagement**: Integrates with the global BusyService

4. **BusyService**: Singleton for managing application-wide busy states
   - Used to show global loading indicators
   - Configurable with default messages and timeouts

### Key Features

- **Reactive UI Updates**: Widgets rebuild when ViewModel state changes using `rebuild()` or `ValueNotifier`
- **State Management**: Built-in support for `isInitialised`, `isBusy`, and `hasError` states
- **Context Access**: Safe access to `BuildContext` within ViewModels
- **Argument Passing**: Simple mechanism to pass arguments to ViewModels during initialization
- **Global Busy Indicator**: Centralized `BusyService` for managing application-wide busy states

### Data Flow

1. View creates a ViewModelBuilder with a viewModelBuilder function
2. ViewModelBuilder creates the ViewModel and calls initialise()
3. ViewModel performs setup logic and calls setInitialised(true)
4. ViewBuilder rebuilds with the initialized ViewModel
5. View uses ViewModel methods to update state
6. When state changes, ViewModel calls rebuild() or updates ValueNotifiers
7. ViewModelBuilder rebuilds with the updated state

## Testing Structure

The package uses a Gherkin-style testing approach:

- **Unit Tests**: Test individual components (BaseViewModel, mixins)
  - Located in `test/unit_features/`
  - Uses `gherkin_unit_test` package

- **Widget Tests**: Test the ViewModelBuilder and integration
  - Located in `test/integration_features/`
  - Uses `gherkin_integration_test` package

## Working with Files

When adding new functionality:

1. Create new model classes in `lib/data/models/`
2. Create new mixins in `lib/data/mixins/`
3. Create new services in `lib/services/`
4. Create new widgets in `lib/widgets/`
5. Export public APIs in `lib/veto.dart`
6. Add corresponding tests

Remember to maintain backward compatibility with existing APIs.