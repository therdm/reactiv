import 'package:flutter/material.dart';
import '../data_types/base/reactive.dart';

part 'reaction_n.dart';

class Reaction<T> extends StatelessWidget {
  const Reaction({
    Key? key,
    required this.cause,
    required this.effect,
  }) : super(key: key);

  final Reactive<T> cause;
  final Widget Function(T data) effect;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: cause.notifier.stream,
      builder: (context, snapshot) {
        return effect(snapshot.data ?? cause.value);
      }
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
