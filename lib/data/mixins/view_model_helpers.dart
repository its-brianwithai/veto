import 'package:flutter/scheduler.dart';

/// Mixin to provide utility methods for ViewModel.
///
/// Includes functionalities like adding a delay, or adding a post-frame callback.
mixin ViewModelHelpers {
  /// Waits for a specified number of milliseconds.
  ///
  /// [milliseconds] Time to wait in milliseconds.
  Future<void> wait(int milliseconds) async =>
      await Future.delayed(Duration(milliseconds: milliseconds));

  /// Adds a post-frame callback using Flutter's [SchedulerBinding].
  ///
  /// [frameCallback] The callback function to be executed.
  void addPostFrameCallback(FrameCallback frameCallback) =>
      _asNullable(SchedulerBinding.instance)!.addPostFrameCallback(frameCallback);

  /// Helper method to explicitly specify nullability of a variable.
  ///
  /// [value] The value to check.
  T? _asNullable<T>(T? value) => value;
}
