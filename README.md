# 📚 Veto - MVVM State Management for Flutter

[![Pub Version](https://img.shields.io/pub/v/veto?logo=dart&label=veto)](https://pub.dev/packages/veto)
[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![GitHub Stars](https://img.shields.io/github/stars/codaveto/veto?style=social)](https://github.com/codaveto/veto)

**Veto** is a lightweight and intuitive MVVM (Model-View-ViewModel) state management solution for Flutter, originally inspired by the [FilledStacks](https://www.filledstacks.com/) [stacked](https://pub.dev/packages/stacked) package. It simplifies managing view logic, state, and lifecycle in your Flutter applications.

![Veto Example Project Screenshot](veto_example_project.png)

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Core Concepts](#core-concepts)
  - [BaseViewModel](#baseviewmodel)
  - [ViewModelBuilder](#viewmodelbuilder)
  - [Mixins](#mixins)
  - [BusyService](#busyservice)
- [Usage Guide](#usage-guide)
  - [1. Create your ViewModel](#1-create-your-viewmodel)
  - [2. Connect ViewModel to your View](#2-connect-viewmodel-to-your-view)
  - [3. Accessing ViewModel Properties and Methods](#3-accessing-viewmodel-properties-and-methods)
  - [4. Managing Busy State](#4-managing-busy-state)
  - [5. Handling Errors](#5-handling-errors)
  - [6. Global Busy State with BusyService](#6-global-busy-state-with-busyservice)
  - [7. Passing Arguments to ViewModel](#7-passing-arguments-to-viewmodel)
- [Example Project](#example-project)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

## Features

- **Easy ViewModel Lifecycle Management**: Automatic handling of `initialise` and `dispose` methods.
- **Reactive UI Updates**: Widgets rebuild efficiently when ViewModel state changes using `rebuild()` or `ValueNotifier`.
- **State Management**: Built-in support for managing `isInitialised`, `isBusy`, and `hasError` states.
- **Context Access**: Safe access to `BuildContext` within ViewModels.
- **Argument Passing**: Simple mechanism to pass arguments to ViewModels during initialization.
- **Global Busy Indicator**: Centralized `BusyService` for managing application-wide busy states.
- **Helper Mixins**: Utility mixins like `BusyManagement`, `ErrorManagement`, and `ViewModelHelpers`.
- **Lightweight and Intuitive**: Designed to be easy to learn and integrate.

## Installation

1.  Add `veto` to your `pubspec.yaml` file:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      veto: ^latest_version # Replace with the latest version from pub.dev
    ```

2.  Install the package by running:

    ```bash
    flutter pub get
    ```

3.  Import the package in your Dart files:

    ```dart
    import 'package:veto/veto.dart';
    ```

## Core Concepts

### BaseViewModel
The heart of the Veto package. Your ViewModels should extend `BaseViewModel<A>`, where `A` is the type of arguments you want to pass to the ViewModel.

Key features:
- `initialise()`: Called once when the ViewModel is created. Ideal for setting up data, listeners, etc.
- `dispose()`: Called when the ViewModel is no longer needed. Clean up resources here.
- `rebuild()`: Notifies listeners (typically the `ViewModelBuilder`) to rebuild the UI.
- `isMounted`: A boolean getter to check if the associated View (widget) is currently in the widget tree.
- `context`: Provides safe access to the `BuildContext`.
- `arguments`: Holds arguments passed via `ViewModelBuilder`.
- `isInitialised`: A `ValueListenable<bool>` that indicates if `initialise()` has completed.

### ViewModelBuilder
A widget that builds and provides a `BaseViewModel` to the widget tree. It listens to the ViewModel and rebuilds its child widgets when `rebuild()` is called or when other `ValueNotifier`s within the ViewModel change.

Key parameters:
- `viewModelBuilder`: A function that returns an instance of your ViewModel.
- `builder`: A function that builds your UI, receiving the `context`, `model` (your ViewModel instance), `isInitialised` status, and an optional `child`.
- `argumentBuilder` (optional): A function to provide arguments to your ViewModel's `initialise` method.
- `isReactive` (default: `true`): If true, the builder will rebuild when `notifyListeners()` (called by `rebuild()`) is invoked on the ViewModel.
- `shouldDispose` (default: `true`): If true, the ViewModel's `dispose()` method will be called automatically.
- `onDispose` (optional): A callback executed when the ViewModel is disposed.

### Mixins
Veto provides several mixins to add common functionalities to your ViewModels:

- **`BusyManagement`**: Adds `isBusy` (`ValueListenable<bool>`), `busyTitle`, `busyMessage`, and `setBusy()` method for managing local busy states within a ViewModel.
- **`ErrorManagement`**: Adds `hasError` (`ValueListenable<bool>`), `errorTitle`, `errorMessage`, and `setError()` method for managing local error states.
- **`ViewModelHelpers`**: Provides utility methods like `wait()` (for delays) and `addPostFrameCallback()`.
- **`BusyServiceManagement`**: Integrates with the global `BusyService` to manage application-wide busy states.

### BusyService
A singleton service for managing a global busy state. This is useful for showing an overlay loading indicator across the entire app.

- `BusyService.instance()`: Access the singleton instance.
- `BusyService.initialise()`: Configure default busy message, title, type, and timeout.
- `setBusy(bool isBusy, ...)`: Sets the global busy state.
- `isBusyListenable`: A `ValueListenable<BusyModel>` to listen for changes in the global busy state.
- `BusyModel`: Contains `isBusy`, `busyTitle`, `busyMessage`, `busyType`, and `payload`.
- `BusyType`: Enum to control the appearance of the busy indicator (e.g., `indicator`, `indicatorBackdrop`).

## Usage Guide

Here’s a step-by-step guide to using Veto:

### 1. Create your ViewModel
Extend `BaseViewModel` and add your business logic, state variables, and any desired mixins.

```dart
import 'package:flutter/foundation.dart';
import 'package:veto/veto.dart';

class MyViewModel extends BaseViewModel<String> // String is the argument type
    with BusyManagement, ErrorManagement {
  
  final ValueNotifier<int> _counter = ValueNotifier(0);
  ValueListenable<int> get counter => _counter;

  String? _greeting;
  String? get greeting => _greeting;

  @override
  Future<void> initialise() async {
    _greeting = "Hello, ${arguments}!";
    setBusy(true, message: "Loading data...");
    await Future.delayed(const Duration(seconds: 2));
    _counter.value = 10;
    setBusy(false);
    super.initialise();
    debugPrint("MyViewModel Initialised with argument: $arguments");
  }

  void incrementCounter() {
    _counter.value++;
  }

  void performFailableOperation() async {
    setBusy(true);
    setError(false);
    try {
      await Future.delayed(const Duration(seconds: 1));
      throw Exception("Something went wrong!");
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      setError(true, title: "Error", message: e.toString());
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    _counter.dispose();
    disposeBusyManagement();
    disposeErrorManagement();
    debugPrint("MyViewModel Disposed");
    super.dispose();
  }
}
```

### 2. Connect ViewModel to your View
Use `ViewModelBuilder` in your widget to provide and react to your ViewModel.

```dart
import 'package:flutter/material.dart';
import 'package:veto/veto.dart';

class MyView extends StatelessWidget {
  const MyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyViewModel>(
      viewModelBuilder: () => MyViewModel(),
      argumentBuilder: () => "World",
      builder: (context, model, isInitialised, child) {
        if (!isInitialised) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(model.greeting ?? "Veto Example")),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ValueListenableBuilder<int>(
                  valueListenable: model.counter,
                  builder: (context, count, _) {
                    return Text('Counter: $count', style: Theme.of(context).textTheme.headlineMedium);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: model.incrementCounter,
                  child: const Text('Increment Counter'),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<bool>(
                  valueListenable: model.isBusy,
                  builder: (context, isBusy, _) {
                    if (isBusy) {
                      return Column(
                        children: [
                          const CircularProgressIndicator(),
                          if (model.busyMessage != null) ...[
                            const SizedBox(height: 8),
                            Text(model.busyMessage!),
                          ]
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<bool>(
                  valueListenable: model.hasError,
                  builder: (context, hasError, _) {
                    if (hasError) {
                      return Text(
                        model.errorMessage ?? 'An unknown error occurred.',
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: model.performFailableOperation,
                  child: const Text('Perform Failable Operation'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

### 3. Accessing ViewModel Properties and Methods
Inside the `builder` function of `ViewModelBuilder`, access your ViewModel directly and use `ValueListenableBuilder` for fine-grained updates.

### 4. Managing Busy State (Local)
The `BusyManagement` mixin provides:
- `isBusy`: A `ValueListenable<bool>` for the busy state.
- `setBusy(bool isBusy, {String? title, String? message})`: Call this to update the busy state.

### 5. Handling Errors (Local)
The `ErrorManagement` mixin provides:
- `hasError`: A `ValueListenable<bool>` for the error state.
- `setError(bool hasError, {String? title, String? message})`: Call this to update the error state.

### 6. Global Busy State with `BusyService`
For application-wide loading indicators:

```dart
void main() {
  BusyService.initialise(
    busyMessageDefault: "Please wait...",
    busyTypeDefault: BusyType.indicatorBackdrop,
    timeoutDurationDefault: const Duration(seconds: 30),
  );
  runApp(MyApp());
}
```

Use `BusyServiceManagement` mixin or `BusyService.instance()` in ViewModels, and listen in your root widget’s `builder`:

```dart
class MyApp extends StatelessWidget { ... }
```

### 7. Passing Arguments to ViewModel
Pass arguments with `argumentBuilder` and access via `arguments` in `initialise()`.

## Example Project

Check the `/example` directory for a complete Flutter application demonstrating Veto’s features.

## Dependencies

- `provider`: Used internally by `ViewModelBuilder` for efficient state propagation.

## Contributing

Contributions are welcome! Please open issues or pull requests on our [GitHub repository](https://github.com/codaveto/veto).

## License

This package is licensed under the BSD 3-Clause License. See the [LICENSE](LICENSE) file for details.

## Support

If you have any questions or need help, feel free to contact us through [codaveto.com](https://www.codaveto.com) or open an issue on GitHub.