part of 'observer.dart';

/// A widget that observes changes in two reactive variables and triggers a rebuild when either variable changes.
class Observer2<A, B> extends StatelessWidget {
  /// Constructs an [Observer2] widget.
  ///
  /// The [listen] parameter is the first reactive variable to listen to.
  ///
  /// The [listen2] parameter is the second reactive variable to listen to.
  ///
  /// The [update] parameter is a callback function that defines the widget to rebuild whenever either of the reactive variables changes.
  const Observer2({
    Key? key,
    required this.listen,
    required this.listen2,
    required this.update,
  }) : super(key: key);

  /// The first reactive variable to listen to for changes.
  final Reactive<A> listen;

  /// The second reactive variable to listen to for changes.
  final Reactive<B> listen2;

  /// A callback function that defines the widget to rebuild whenever either of the reactive variables changes.
  final Widget Function(A data1, B data2) update;

  @override
  Widget build(BuildContext context) {
    return Observer(
      listen: listen,
      update: (data1) {
        return Observer(
          listen: listen2,
          update: (data2) {
            return update(data1, data2);
          },
        );
      },
    );
  }
}

/// A widget that observes changes in three reactive variables and triggers a rebuild when any of the variables changes.
class Observer3<A, B, C> extends StatelessWidget {
  /// Constructs an [Observer3] widget.
  ///
  /// The [listen] parameter is the first reactive variable to listen to.
  ///
  /// The [listen2] parameter is the second reactive variable to listen to.
  ///
  /// The [listen3] parameter is the third reactive variable to listen to.
  ///
  /// The [update] parameter is a callback function that defines the widget to rebuild whenever any of the reactive variables changes.
  const Observer3({
    Key? key,
    required this.listen,
    required this.listen2,
    required this.listen3,
    required this.update,
  }) : super(key: key);

  /// The first reactive variable to listen to for changes.
  final Reactive<A> listen;

  /// The second reactive variable to listen to for changes.
  final Reactive<B> listen2;

  /// The third reactive variable to listen to for changes.
  final Reactive<C> listen3;

  /// A callback function that defines the widget to rebuild whenever any of the reactive variables changes.
  final Widget Function(A data1, B data2, C data3) update;

  @override
  Widget build(BuildContext context) {
    return Observer(
      listen: listen,
      update: (data1) {
        return Observer(
          listen: listen2,
          update: (data2) {
            return Observer(
              listen: listen3,
              update: (data3) {
                return update(data1, data2, data3);
              },
            );
          },
        );
      },
    );
  }
}
