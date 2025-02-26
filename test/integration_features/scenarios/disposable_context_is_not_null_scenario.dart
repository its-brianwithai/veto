import 'package:flutter/widgets.dart';
import 'package:gherkin_integration_test/integration_test.dart';
import 'package:veto/data/models/base_view_model.dart';

import '../../models/base_view_model_implementation.dart';

class DisposableContextIsNotNullScenario extends IntegrationScenario {
  DisposableContextIsNotNullScenario()
      : super(
          description: 'Testing the context method initialisation of the ViewModelBuilder',
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
              'The BaseViewModel.isDisposableContext method should return true',
              (tester, log, box, mocks, [example, binding]) {
                box.read<BaseViewModelImplementation>(#baseViewModel).context;
                log.success('BaseViewModel did not throw upon requesting context!');
              },
            ),
          ],
        );
}
