import 'package:veto/data/models/base_view_model.dart';
import 'package:veto/data/mixins/busy_management.dart';
import 'package:veto/data/mixins/error_management.dart';

class BaseViewModelImplementation<T> extends BaseViewModel<T> with ErrorManagement, BusyManagement {
  BaseViewModelImplementation({
    required bool isMock,
  }) : _isMock = isMock;

  final bool _isMock;
  late double stubbedTextScaleFactor;
  late double stubbedCurrentWidth;
  late double stubbedCurrentHeight;

  @override
  void rebuild() {
    if (!_isMock) {
      super.rebuild();
    }
  }
}
