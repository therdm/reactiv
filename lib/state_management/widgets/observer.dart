import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reactiv/reactiv.dart';

part 'observer_n.dart';
//
// /// A widget that observes changes in a reactive variable and triggers a rebuild when the variable changes.
// class Observer<T> extends StatelessWidget {
//   /// Constructs an [Observer] widget.
//   ///
//   /// The [listenable] parameter is the reactive variable to listen to.
//   ///
//   /// The [update] parameter is a callback function that defines the widget to rebuild whenever the [listenable] variable changes.
//   const Observer({
//     Key? key,
//     required this.listenable,
//     required this.listener,
//   }) : super(key: key);
//
//   /// The reactive variable to listen to for changes.
//   final Reactive<T> listenable;
//
//   /// A callback function that defines the widget to rebuild whenever the [listenable] variable changes.
//   final Widget Function(T data) listener;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<T>(
//       stream: listenable.notifier.stream,
//       builder: (context, snapshot) {
//         return listener(snapshot.data ?? listenable.value);
//       },
//     );
//   }
// }

class Observer<T> extends StatefulWidget {
  const Observer({
    Key? key,
    required this.listenable,
    required this.listener,
  }) : super(key: key);

  final Reactive<T> listenable;
  final Widget Function(T data) listener;

  @override
  State<Observer<T>> createState() => _ObserverState<T>();
}

class _ObserverState<T> extends State<Observer<T>> {
  late StreamSubscription subs;

  @override
  void initState() {
    super.initState();
    subs = widget.listenable.notifier.stream.listen((event) {
      _refresh();
    });
  }

  _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    subs.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.listener(widget.listenable.value);
  }
}
