import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

import '../models/base_view_model_implementation.dart';

class IsBusyFeature extends UnitFeature {
  IsBusyFeature()
      : super(
          description: 'BaseViewModel.isInitialised',
          scenarios: [
            UnitScenario<BaseViewModelImplementation, UnitExample>(
              description: 'Setting busy status on the BaseViewModel',
              systemUnderTest: (mocks) => BaseViewModelImplementation(isMock: true),
              steps: [
                Given(
                  'The BaseViewModel is not busy',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.isBusy, false);
                    log.success('BaseViewModel was not busy');
                  },
                ),
                When(
                  'we call the setBusy method with true',
                  (systemUnderTest, log, box, mocks, [example]) {
                    systemUnderTest.setBusy(true);
                  },
                ),
                Then(
                  'the BaseViewModel should be busy',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.isBusy, true);
                    log.success('Boolean status was busy!');
                  },
                ),
                When(
                  'we call the setBusy method with false',
                  (systemUnderTest, log, box, mocks, [example]) async {
                    systemUnderTest.setBusy(false);
                  },
                ),
                Then(
                  'the BaseViewModel should no longer be busy',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.isBusy, false);
                    log.success('BaseViewModel was not busy!');
                  },
                )
              ],
            )
          ],
        );
}
