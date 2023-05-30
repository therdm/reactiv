import 'package:flutter/material.dart';
import 'package:reactiv/state_management/reactive_types.dart';

part 'observer_n.dart';

/// A widget that observes changes in a reactive variable and triggers a rebuild when the variable changes.
class Observer<T> extends StatelessWidget {
  /// Constructs an [Observer] widget.
  ///
  /// The [listen] parameter is the reactive variable to listen to.
  ///
  /// The [update] parameter is a callback function that defines the widget to rebuild whenever the [listen] variable changes.
  const Observer({
    Key? key,
    required this.listen,
    required this.update,
  }) : super(key: key);

  /// The reactive variable to listen to for changes.
  final Reactive<T> listen;

  /// A callback function that defines the widget to rebuild whenever the [listen] variable changes.
  final Widget Function(T data) update;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: listen.notifier.stream,
      builder: (context, snapshot) {
        return update(snapshot.data ?? listen.value);
      },
    );
  }
}


// class Reaction<T> extends StatefulWidget {
//   const Reaction({
//     Key? key,
//     required this.cause,
//     required this.effect,
//   }) : super(key: key);
//
//   final Reactive<T> cause;
//   final Widget Function(T data) effect;
//
//   @override
//   State<Reaction<T>> createState() => _ReactionState<T>();
// }
//
// class _ReactionState<T> extends State<Reaction<T>> {
//   late StreamSubscription subs;
//
//   @override
//   void initState() {
//     super.initState();
//     subs = widget.cause.notifier.stream.listen((event) {
//       log('initState $mounted');
//       _refresh();
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant Reaction<T> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     subs.onData((data) {
//       log('didUpdateWidget $mounted');
//       _refresh();
//     });
//   }
//
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     subs.onData((data) {
//       log('didChangeDependencies $mounted');
//       _refresh();
//     });
//   }
//
//   _refresh() {
//     if(mounted) {
//       setState(() {});
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     subs.cancel();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.effect(widget.cause.value);
//   }
// }
