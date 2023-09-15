import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef ValueWidgetBuilder<T> = Widget Function(
    BuildContext context, T state, Widget? child);

typedef ValueWidgetListener<T> = void Function(BuildContext context, T state);

typedef ValueBuilderCondition<T> = bool Function(T state);

class ValueNotifierConsumer<T> extends StatefulWidget {
  const ValueNotifierConsumer({
    Key? key,
    required this.valueListenable,
    required this.builder,
    this.buildWhen,
    this.listener,
    this.listenWhen,
    this.child,
  })  : assert(
          !(listenWhen != null && listener == null),
          'listener is required if listenWhen is configured.',
        ),
        super(key: key);

  final ValueListenable<T> valueListenable;
  final ValueWidgetBuilder<T> builder;
  final ValueBuilderCondition<T>? buildWhen;

  final ValueWidgetListener<T>? listener;
  final ValueBuilderCondition<T>? listenWhen;

  final Widget? child;

  @override
  State<ValueNotifierConsumer> createState() =>
      _ValueNotifierConsumerState<T>();
}

class _ValueNotifierConsumerState<T> extends State<ValueNotifierConsumer<T>> {
  late T currentState;

  @override
  void initState() {
    super.initState();
    currentState = widget.valueListenable.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(covariant ValueNotifierConsumer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      currentState = widget.valueListenable.value;
      widget.valueListenable.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    // se for do tipo listener, avisar o listenerBuilder
    final state = widget.valueListenable.value;
    if ((widget.listener != null) &&
        (widget.listenWhen?.call(state) ?? false)) {
      widget.listener!(context, state);
    }

    if (widget.buildWhen?.call(state) ?? true) {
      // se for do tipo builder, avisar o builder
      setState(() {
        currentState = state;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, currentState, widget.child);
  }
}
