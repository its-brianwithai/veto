part of '../data/models/ake_base_view_model.dart';

/// Used to build and provide a [AkeBaseViewModel] to the widget tree.
class AkeViewModelBuilder<T extends AkeBaseViewModel> extends StatefulWidget {
  const AkeViewModelBuilder({
    this.child,
    required Widget Function(
      BuildContext context,
      T model,
      bool isInitialised,
      Widget? child,
    ) builder,
    required T Function() viewModelBuilder,
    Object? Function()? argumentBuilder,
    this.isReactive = true,
    this.shouldDispose = true,
    this.onDispose,
    Key? key,
    final bool keepAlive = true,
  })  : _builder = builder,
        _viewModelBuilder = viewModelBuilder,
        _argumentBuilder = argumentBuilder,
        _keepAlive = keepAlive,
        super(key: key);

  /// Child widget that will not rebuild when notifyListeners is called.
  final Widget? child;

  /// Builder method that builds the widget tree.
  final Widget Function(BuildContext context, T model, bool isInitialised, Widget? child) _builder;

  /// Builder method that provides the [AkeBaseViewModel].
  final T Function() _viewModelBuilder;

  /// Builder method that provides the [AkeBaseViewModel.initialise] with arguments.
  final dynamic Function()? _argumentBuilder;

  /// Whether the [BaseViewModel] should listen to [BaseViewModel.notifyListeners] for rebuilds.
  final bool isReactive;

  /// Whether the [ChangeNotifierProvider] should dispose the [BaseViewModel] when it's removed from the widget tree.
  final bool shouldDispose;

  /// Fires when [ViewModelBuilder] is removed from the widget tree.
  final Function(T model)? onDispose;

  final bool _keepAlive;

  @override
  AkeViewModelBuilderState<T> createState() => AkeViewModelBuilderState<T>();
}

class AkeViewModelBuilderState<T extends AkeBaseViewModel> extends State<AkeViewModelBuilder<T>>
    with AutomaticKeepAliveClientMixin {
  /// The current [AkeBaseViewModel].
  late final T _viewModel;

  /// Initialises the [AkeBaseViewModel] and its needed methods.
  @override
  void initState() {
    _viewModel = widget._viewModelBuilder()
      ..disposableBuildContext = DisposableBuildContext(this)
      .._mounted = (() => mounted)
      ..arguments = widget._argumentBuilder?.call();
    _viewModel.initialise();
    super.initState();
  }

  /// Disposes the [AkeBaseViewModel] and its given methods.
  @override
  void dispose() {
    widget.onDispose?.call(_viewModel);
    if (widget.shouldDispose) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: _viewModel.isInitialised,
      child: widget.child,
      builder: (context, isInitialised, child) {
        if (widget.isReactive) {
          ChangeNotifierProvider<T>.value(
            value: _viewModel,
            child: Consumer<T>(
              child: child,
              builder: (context, value, child) => widget._builder(
                context,
                value,
                isInitialised,
                child,
              ),
            ),
          );
        }
        return ChangeNotifierProvider<T>.value(
          value: _viewModel,
          child: child,
          builder: (context, child) => widget._builder(
            context,
            _viewModel,
            isInitialised,
            child,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => widget._keepAlive;
}
