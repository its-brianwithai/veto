import 'package:flutter/material.dart';
import 'package:gherkin_integration_test/integration_test.dart';
import 'package:veto/data/models/base_view_model.dart';

import '../../models/base_view_model_implementation.dart';

class RebuildIsNotNullScenario extends IntegrationScenario {
  RebuildIsNotNullScenario()
      : super(
          description: 'Testing the rebuild method initialisation of the ViewModelBuilder',
          steps: [
            Given(
              'The BaseViewModel is built',
              (tester, log, box, mocks, [example, binding]) async {
                log.info('Building the BaseViewModel..');
                final baseViewModel = BaseViewModelImplementation(isMock: false);
                log.success('BaseViewModel built!');
                box.write(#baseViewModel, baseViewModel);
              },
            ),
            When(
              'the ViewModelBuilder is initialised',
              (tester, log, box, mocks, [example, binding]) async {
                await tester.pumpWidget(
                  ViewModelBuilder<BaseViewModelImplementation>(
                    builder: (context, model, isInitialised, child) => const SizedBox(),
                    viewModelBuilder: () => box.read(#baseViewModel),
                  ),
                );
                await tester.pumpAndSettle();
              },
            ),
            Then(
              'The BaseViewModel.rebuild should be initialised and not be null',
              (tester, log, box, mocks, [example, binding]) {
                box.read<BaseViewModelImplementation>(#baseViewModel).rebuild();
                log.success('Method did not throw!');
              },
            ),
          ],
        );
}
