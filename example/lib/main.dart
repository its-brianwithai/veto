import 'dart:async';

import 'package:example/views/second/second_veto_view.dart';
import 'package:example/views/second/second_veto_view_arguments.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:veto/data/mixins/busy_management.dart';
import 'package:veto/data/mixins/error_management.dart';
import 'package:veto/data/mixins/view_model_helpers.dart';
import 'package:veto/data/models/base_view_model.dart';

import 'data/constants/const_durations.dart';
import 'data/enums/mounted_status.dart';

void main() {
  runApp(const MyApp());
}

class FirstVetoView extends StatelessWidget {
  const FirstVetoView({Key? key}) : super(key: key);
  static const String route = 'first-veto-view';

  /// Original width of the fictional design file that we got from our designer.
  ///
  /// Play around with this value to demonstrate the [BaseViewModel.scaledWidth] property.
  static const _originalDesignWidth = 390.0;

  /// Original height of the fictional design file that we got from our designer.
  ///
  /// Play around with this value to demonstrate the [BaseViewModel.scaledHeight] property.
  static const _originalDesignHeight = 844.0;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FirstVetoViewModel>(
      builder: (context, model, isInitialised, child) => MediaQuery(
        data: model.media.copyWith(
          textScaler: TextScaler.linear(model.textScaleFactor.clamp(1, 1.35)),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Veto Test App'),
          ),
          body: GestureDetector(
            onTap: model.focusNode.unfocus,
            child: Stack(
              children: [
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) => AnimatedSwitcher(
                      duration: ConstDurations.defaultAnimationDuration,
                      child: isInitialised
                          ? ValueListenableBuilder<bool>(
                              valueListenable: model.isBusy,
                              builder: (context, isBusy, child) => AnimatedSwitcher(
                                duration: ConstDurations.defaultAnimationDuration,
                                child: isBusy
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ValueListenableBuilder<int>(
                                            valueListenable: model.busySeconds,
                                            builder: (context, busySeconds, child) => Text(
                                              'This model is busy for another $busySeconds seconds...',
                                              style: model.textTheme.titleMedium!
                                                  .copyWith(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          const CircularProgressIndicator(),
                                        ],
                                      )
                                    : ValueListenableBuilder<bool>(
                                        valueListenable: model.hasError,
                                        builder: (context, hasError, child) => AnimatedContainer(
                                          height: constraints.maxHeight,
                                          curve: Curves.decelerate,
                                          duration: ConstDurations.defaultAnimationDuration,
                                          decoration: BoxDecoration(
                                            color: hasError ? Colors.red : Colors.transparent,
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: model.theme.canvasColor,
                                              borderRadius: BorderRadius.circular(32),
                                            ),
                                            child: SingleChildScrollView(
                                              physics: const BouncingScrollPhysics(),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: model.textScaled(
                                                      value: 40,
                                                      context: context,
                                                    ),
                                                  ),
                                                  Text(
                                                    'First Veto View',
                                                    style: model.textTheme.headlineSmall!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Made by Yyhwach_ and me',
                                                    style: model.textTheme.titleSmall!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: model.textScaled(
                                                      value: 16,
                                                      context: context,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Flexible(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'ViewModel',
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              Text(
                                                                '${model.modelCounter}',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .headlineMedium,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        ValueListenableBuilder<int>(
                                                          valueListenable:
                                                              model.valueListenableCounter,
                                                          builder: (
                                                            context,
                                                            valueListenableCounter,
                                                            child,
                                                          ) =>
                                                              Flexible(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'ValueNotifier',
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  valueListenableCounter.toString(),
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .headlineMedium,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: model.textScaled(
                                                      value: 16,
                                                      context: context,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 16),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        FloatingActionButton(
                                                          onPressed: model.incrementModelCounter,
                                                          backgroundColor: Colors.red,
                                                          heroTag: '1',
                                                          child: const Icon(Icons.add),
                                                        ),
                                                        FloatingActionButton(
                                                          onPressed:
                                                              model.incrementValueNotifierCounter,
                                                          backgroundColor: Colors.blue,
                                                          heroTag: '2',
                                                          child: const Icon(Icons.add),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(vertical: 16),
                                                    child: ElevatedButton(
                                                      onPressed: model.reset,
                                                      child: const Text('Reset'),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        FloatingActionButton(
                                                          onPressed: model.decrementModelCounter,
                                                          backgroundColor: Colors.red,
                                                          heroTag: '3',
                                                          child: const Icon(Icons.remove),
                                                        ),
                                                        FloatingActionButton(
                                                          onPressed:
                                                              model.decrementValueNotifierCounter,
                                                          backgroundColor: Colors.blue,
                                                          heroTag: '4',
                                                          child: const Icon(Icons.remove),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStateProperty.all(Colors.pink)),
                                                    onPressed: model.pushSecondView,
                                                    child: const Text('Push Arguments'),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 16),
                                                    child: Row(
                                                      children: [
                                                        ValueListenableBuilder<MountedStatus>(
                                                          valueListenable: model.mountedStatus,
                                                          builder:
                                                              (context, mountedStatus, child) =>
                                                                  Expanded(
                                                            child: Text(
                                                              'Mounted: ${mountedStatus.name.capitalizeFirstLetter}',
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  WidgetStateProperty.all(
                                                                      Colors.orange)),
                                                          onPressed: model.updateMountedStatus,
                                                          child: const Text('Check status'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStateProperty.all(Colors.yellow)),
                                                    onPressed: model.triggerBusy,
                                                    child: Text(
                                                      'Trigger Busy',
                                                      style: model.textTheme.bodyLarge!
                                                          .copyWith(color: Colors.black),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 16),
                                                    child: ValueListenableBuilder<bool>(
                                                      valueListenable: model.hasError,
                                                      builder: (context, hasError, child) => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          AnimatedOpacity(
                                                            duration: ConstDurations
                                                                .defaultAnimationDuration,
                                                            opacity: hasError ? 0.3 : 1,
                                                            child: IgnorePointer(
                                                              ignoring: hasError,
                                                              child: ElevatedButton(
                                                                style: ButtonStyle(
                                                                  backgroundColor:
                                                                      WidgetStateProperty.all(
                                                                    Colors.black,
                                                                  ),
                                                                ),
                                                                onPressed: model.triggerError,
                                                                child: const Text('Trigger Error'),
                                                              ),
                                                            ),
                                                          ),
                                                          AnimatedOpacity(
                                                            duration: ConstDurations
                                                                .defaultAnimationDuration,
                                                            opacity: !hasError ? 0.3 : 1,
                                                            child: IgnorePointer(
                                                              ignoring: !hasError,
                                                              child: ElevatedButton(
                                                                style: ButtonStyle(
                                                                  backgroundColor:
                                                                      WidgetStateProperty.all(
                                                                    Colors.black,
                                                                  ),
                                                                ),
                                                                onPressed: model.removeError,
                                                                child: const Text('Remove Error'),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  AnimatedContainer(
                                                    duration:
                                                        ConstDurations.defaultAnimationDuration,
                                                    margin: const EdgeInsets.only(top: 16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blueAccent,
                                                      borderRadius: BorderRadius.circular(32),
                                                    ),
                                                    width: model.scaledWidth(
                                                      value: 200,
                                                      originalDesignWidth: _originalDesignWidth,
                                                    ),
                                                    height: model.scaledHeight(
                                                      value: 20,
                                                      originalDesignHeight: _originalDesignHeight,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Scaled Container',
                                                            textAlign: TextAlign.center,
                                                            style: model.textTheme.titleSmall!
                                                                .copyWith(color: Colors.white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => FirstVetoViewModel.locate,
    );
  }
}

class FirstVetoViewModel extends BaseViewModel
    with BusyManagement, ErrorManagement, ViewModelHelpers {
  int _modelCounter = 0;
  int get modelCounter => _modelCounter;

  final ValueNotifier<int> _valueNotifierCounter = ValueNotifier(0);
  ValueListenable<int> get valueListenableCounter => _valueNotifierCounter;

  final ValueNotifier<MountedStatus> _mountedStatus = ValueNotifier(MountedStatus.unknown);
  ValueListenable<MountedStatus> get mountedStatus => _mountedStatus;

  final ValueNotifier<int> _busySeconds = ValueNotifier(0);
  ValueListenable<int> get busySeconds => _busySeconds;

  Timer? _busyTimer;

  @override
  Future<void> initialise() async {
    _log('Initialising..');
    _log('Calling addPostFrameCallback with dummy log to showcase usage!');
    await wait(1000);
    addPostFrameCallback((timeStamp) {
      _log('addPostFrameCallback dummy log!');
    });
    _log('Logging the media value to showcase it\'s usage:');
    _log('model.media: $media');
    super.initialise();
    _log('Initialised!');
  }

  @override
  Future<void> dispose() async {
    _valueNotifierCounter.dispose();
    super.dispose();
  }

  /// Increments the [modelCounter], and then rebuilds the UI.
  void incrementModelCounter() {
    _modelCounter++;
    rebuild();
  }

  /// If the [modelCounter] is greater than 0, decrement the [modelCounter] and rebuild the UI.
  void decrementModelCounter() {
    if (modelCounter > 0) {
      _modelCounter--;
      rebuild();
    }
  }

  /// Increments the value of the [_valueNotifierCounter] by one.
  void incrementValueNotifierCounter() => _valueNotifierCounter.value++;

  /// If the value of the [_valueNotifierCounter] is greater than 0 decrement the counter.
  void decrementValueNotifierCounter() {
    if (_valueNotifierCounter.value > 0) {
      _valueNotifierCounter.value--;
    }
  }

  /// Resets both counters and mounted status to zero.
  void reset() {
    _valueNotifierCounter.value = 0;
    _modelCounter = 0;
    _mountedStatus.value = MountedStatus.unknown;
    setError(false);
    rebuild();
  }

  /// Pushes the second view with counter arguments.
  void pushSecondView() {
    Navigator.of(context!).push(
      MaterialPageRoute(
        builder: (context) => SecondVetoView(
          secondVetoViewArguments: SecondVetoViewArguments(
            firstCounterValue: _modelCounter,
            secondCounterValue: _valueNotifierCounter.value,
          ),
        ),
      ),
    );
  }

  /// Updates the current mounted status to [_mountedStatus] for demonstration purposes.
  void updateMountedStatus() =>
      _mountedStatus.value = isMounted ? MountedStatus.mounted : MountedStatus.unmounted;

  /// Triggers the busy state for demonstration purposes.
  void triggerBusy() {
    _busySeconds.value = 3;
    setBusy(true);
    _busyTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _busySeconds.value--;
        if (busySeconds.value == 0) {
          _busyTimer!.cancel();
          _busyTimer = null;
          setBusy(false);
        }
      },
    );
  }

  /// Triggers the error state for demonstration purposes.
  void triggerError() => setError(true);

  /// Removes the busy state for demonstration purposes.
  void removeError() => setError(false);

  void _log(Object message) => debugPrint('💡 [INFO] $message');

  /// Provides the current [ViewModelBuilderState]'s [ThemeData].
  ThemeData get theme => Theme.of(context!);

  /// Provides the current [ViewModelBuilderState]'s [TextTheme].
  TextTheme get textTheme => Theme.of(context!).textTheme;

  /// Provides the current [ViewModelBuilderState]'s [MediaQueryData].
  MediaQueryData get media => MediaQuery.of(context!);

  /// Provides the current [ViewModelBuilderState]'s [MediaQueryData.textScaleFactor].
  double get textScaleFactor => MediaQuery.of(context!).textScaleFactor;

  /// Provides a scaled value based on given [value] and [textScaleFactor].
  double textScaled({required double value, BuildContext? context}) =>
      value * (context == null ? textScaleFactor : MediaQuery.textScaleFactorOf(context));

  /// Provides the current [ViewModelBuilderState]'s [FocusNode].
  FocusNode get focusNode => FocusScope.of(context!);

  /// Provides the current [ViewModelBuilderState]'s [MediaQueryData]'s [Size.width].
  double get width => MediaQuery.of(context!).size.width;

  /// Provides the current [ViewModelBuilderState]'s [MediaQueryData]'s [Size.height].
  double get height => MediaQuery.of(context!).size.height;

  /// Provides a design scaled value based on given [value], [width] and given [originalDesignWidth].
  ///
  /// Where [originalDesignWidth] is the width of the screen in your original UI design file.
  double scaledWidth({
    required double value,
    required double originalDesignWidth,
  }) =>
      value * (width / originalDesignWidth);

  /// Provides a design scaled value based on given [value], [height] and given [originalDesignHeight].
  ///
  /// Where [originalDesignHeight] is the height of the screen in your original UI design file.
  double scaledHeight({
    required double value,
    required double originalDesignHeight,
  }) =>
      value * (height / originalDesignHeight);

  static FirstVetoViewModel get locate => FirstVetoViewModel();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veto',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const FirstVetoView(),
    );
  }
}

extension on String {
  String get capitalizeFirstLetter => '${this[0].toUpperCase()}${substring(1)}';
}
