import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// A generic widget for view model-driven architecture.
abstract class ViewModelWidget<T> extends Widget {
  /// Constructs the ViewModelWidget.
  ///
  /// [isReactive] determines if the widget rebuilds when the view model changes.
  const ViewModelWidget({Key? key, this.isReactive = true}) : super(key: key);

  /// Determines whether the widget should rebuild when changes occur in [T].
  final bool isReactive;

  /// Builds the UI from the given [model].
  @protected
  Widget build(BuildContext context, T model);

  /// Creates a new [DataProviderElement].
  @override
  DataProviderElement<T> createElement() => DataProviderElement<T>(this);
}

/// An element that uses a [ViewModelWidget].
class DataProviderElement<T> extends ComponentElement {
  /// Constructs the DataProviderElement.
  DataProviderElement(ViewModelWidget widget) : super(widget);

  /// Returns the underlying [ViewModelWidget].
  @override
  ViewModelWidget get widget => super.widget as ViewModelWidget<dynamic>;

  /// Builds the widget.
  ///
  /// Listens to [Provider] for changes if [isReactive] is `true`.
  @override
  Widget build() => widget.build(this, Provider.of<T>(this, listen: widget.isReactive));

  /// Updates the widget.
  ///
  /// Rebuilds when a new [ViewModelWidget] is provided.
  @override
  void update(ViewModelWidget newWidget) {
    super.update(newWidget);
    rebuild(force: true);
  }
}
