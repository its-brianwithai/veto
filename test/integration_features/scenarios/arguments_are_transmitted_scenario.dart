import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_integration_test/integration_test.dart';
import 'package:veto/data/models/base_view_model.dart';

import '../../models/base_view_model_implementation.dart';

class ArgumentsAreTransmittedScenario extends IntegrationScenario {
  static const _argument = 'Cookie';

  ArgumentsAreTransmittedScenario()
      : super(
          description: 'Testing the arguments functionality of the ViewModelBuilder',
          steps: [
            Given(
              'The BaseViewModel is built',
              (tester, log, box, mocks, [example, binding]) async {
                log.info('Building the BaseViewModel..');
                final baseViewModel = BaseViewModelImplementation<_DummyArguments>(isMock: false);
                log.success('BaseViewModel built!');
                box.write(#baseViewModel, baseViewModel);
              },
            ),
            When(
              'The ViewModelBuilder is initialised with a String argument called \'$_argument\'',
              (tester, log, box, mocks, [example, binding]) async {
                await tester.pumpWidget(
                  ViewModelBuilder<BaseViewModelImplementation>(
                    argumentBuilder: () => const _DummyArguments(cookieType: _argument),
                    builder: (context, model, isInitialised, child) => const SizedBox(),
                    viewModelBuilder: () => box.read<BaseViewModelImplementation>(#baseViewModel),
                  ),
                );
                await tester.pumpAndSettle();
              },
            ),
            Then(
              'The BaseViewModel.arguments should be $_argument',
              (tester, log, box, mocks, [example, binding]) {
                expect(
                  box
                      .read<BaseViewModelImplementation<_DummyArguments>>(#baseViewModel)
                      .arguments
                      .cookieType,
                  _argument,
                );
                log.success('The argument was $_argument!');
              },
            ),
          ],
        );
}

class _DummyArguments {
  const _DummyArguments({
    required this.cookieType,
  });

  final String cookieType;
}
