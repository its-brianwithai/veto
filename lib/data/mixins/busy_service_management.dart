import 'package:flutter/foundation.dart';
import 'package:veto/data/constants/k_values.dart';
import 'package:veto/services/busy_service.dart';
import 'package:veto/data/models/busy_model.dart';
import 'package:veto/data/enums/busy_type.dart';

/// Mixin to manage the busy state using [BusyService].
///
/// Provides utilities to set the busy state with optional title, message,
/// minimum duration and busy type. Also exposes getters for busy title,
/// busy message and busy state itself.
mixin BusyServiceManagement {
  /// Instance of [BusyService].
  final BusyService _busyService = BusyService.instance();

  /// Sets the busy state.
  ///
  /// [isBusy] The new busy state.
  /// [busyTitle] Optional title for the busy state.
  /// [busyMessage] Optional message for the busy state.
  /// [minBusyDuration] Minimum duration to remain in busy state. Default is [kValuesMinBusyDuration].
  /// [busyType] Optional busy type. Default is `null`.
  void setBusy(
    bool isBusy, {
    String? busyTitle,
    String? busyMessage,
    Duration minBusyDuration = kValuesMinBusyDuration,
    BusyType? busyType,
    Duration? timeoutDuration,
    VoidCallback? onTimeout,
    dynamic payload,
  }) =>
      _busyService.setBusy(
        isBusy,
        busyTitle: busyTitle,
        busyMessage: busyMessage,
        minBusyDuration: minBusyDuration,
        busyType: busyType,
        timeoutDuration: timeoutDuration,
        onTimeout: onTimeout,
        payload: payload,
      );

  /// Sets the busy state to idle.
  void setIdle() => _busyService.setBusy(false);

  /// Getter for the busy title.
  String? get busyTitle => _busyService.isBusyListenable.value.busyTitle;

  /// Getter for the busy message.
  String? get busyMessage => _busyService.isBusyListenable.value.busyMessage;

  /// ValueListenable for the busy state.
  ValueListenable<BusyModel> get isBusyListenable => _busyService.isBusyListenable;

  /// Getter for the busy state.
  bool get isBusy => _busyService.isBusy;

  /// Dispose the [BusyService] used in this mixin.
  void disposeBusyManagement() => _busyService.dispose();
}
