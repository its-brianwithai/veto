import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

import '../models/base_view_model_implementation.dart';

class HasErrorFeature extends UnitFeature {
  HasErrorFeature()
      : super(
          description: 'BaseViewModel.isError',
          scenarios: [
            UnitScenario<BaseViewModelImplementation, UnitExample>(
              description: 'Setting error status on the BaseViewModel',
              systemUnderTest: (mocks) => BaseViewModelImplementation(isMock: true),
              steps: [
                Given(
                  'The BaseViewModel has no error',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.hasError, false);
                    log.success('BaseViewModel did not have an error');
                  },
                ),
                When(
                  'we call the setError method with true',
                  (systemUnderTest, log, box, mocks, [example]) {
                    systemUnderTest.setError(true);
                  },
                ),
                Then(
                  'the BaseViewModel should have an error',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.hasError, true);
                    log.success('Error status was true!');
                  },
                ),
                When(
                  'we call the setError method with false',
                  (systemUnderTest, log, box, mocks, [example]) async {
                    systemUnderTest.setError(false);
                  },
                ),
                Then(
                  'the BaseViewModel should no longer have an error',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.hasError, false);
                    log.success('BaseViewModel did not have an error!');
                  },
                )
              ],
            )
          ],
        );
}
