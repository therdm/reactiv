part of 'observer.dart';

/// A widget that observes changes in two reactive variables and triggers a rebuild when either variable changes.
class Observer2<A, B> extends StatelessWidget {
  /// Constructs an [Observer2] widget.
  ///
  /// The [listenable] parameter is the first reactive variable to listen to.
  ///
  /// The [listenable2] parameter is the second reactive variable to listen to.
  ///
  /// The [listener] parameter is a callback function that defines the widget to rebuild whenever either of the reactive variables changes.
  const Observer2({
    Key? key,
    required this.listenable,
    required this.listenable2,
    required this.listener,
  }) : super(key: key);

  /// The first reactive variable to listen to for changes.
  final Reactive<A> listenable;

  /// The second reactive variable to listen to for changes.
  final Reactive<B> listenable2;

  /// A callback function that defines the widget to rebuild whenever either of the reactive variables changes.
  final Widget Function(A data1, B data2) listener;

  @override
  Widget build(BuildContext context) {
    return Observer(
      listenable: listenable,
      listener: (data1) {
        return Observer(
          listenable: listenable2,
          listener: (data2) {
            return listener(data1, data2);
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
  /// The [listenable] parameter is the first reactive variable to listen to.
  ///
  /// The [listenable2] parameter is the second reactive variable to listen to.
  ///
  /// The [listenable3] parameter is the third reactive variable to listen to.
  ///
  /// The [listener] parameter is a callback function that defines the widget to rebuild whenever any of the reactive variables changes.
  const Observer3({
    Key? key,
    required this.listenable,
    required this.listenable2,
    required this.listenable3,
    required this.listener,
  }) : super(key: key);

  /// The first reactive variable to listen to for changes.
  final Reactive<A> listenable;

  /// The second reactive variable to listen to for changes.
  final Reactive<B> listenable2;

  /// The third reactive variable to listen to for changes.
  final Reactive<C> listenable3;

  /// A callback function that defines the widget to rebuild whenever any of the reactive variables changes.
  final Widget Function(A data1, B data2, C data3) listener;

  @override
  Widget build(BuildContext context) {
    return Observer(
      listenable: listenable,
      listener: (data1) {
        return Observer(
          listenable: listenable2,
          listener: (data2) {
            return Observer(
              listenable: listenable3,
              listener: (data3) {
                return listener(data1, data2, data3);
              },
            );
          },
        );
      },
    );
  }
}

/// A widget that observes changes in four reactive variables and triggers a rebuild when any of the variables changes.
class Observer4<A, B, C, D> extends StatelessWidget {
  /// Constructs an [Observer4] widget.
  ///
  /// The [listenable] parameter is the first reactive variable to listen to.
  ///
  /// The [listenable2] parameter is the second reactive variable to listen to.
  ///
  /// The [listener] parameter is a callback function that defines the widget to rebuild whenever either of the reactive variables changes.
  const Observer4({
    Key? key,
    required this.listenable,
    required this.listenable2,
    required this.listenable3,
    required this.listenable4,
    required this.listener,
  }) : super(key: key);

  /// The first reactive variable to listen to for changes.
  final Reactive<A> listenable;

  /// The second reactive variable to listen to for changes.
  final Reactive<B> listenable2;

  /// The third reactive variable to listen to for changes.
  final Reactive<C> listenable3;

  /// The fourth reactive variable to listen to for changes.
  final Reactive<D> listenable4;

  /// A callback function that defines the widget to rebuild whenever any of the reactive variables changes.
  final Widget Function(A data1, B data2, C data3, D data4) listener;

  @override
  Widget build(BuildContext context) {
    return Observer2(
      listenable: listenable,
      listenable2: listenable2,
      listener: (data1, data2) {
        return Observer2(
          listenable: listenable3,
          listenable2: listenable4,
          listener: (data3, data4) {
            return listener(data1, data2, data3, data4);
          },
        );
      },
    );
  }
}

/// A widget that observes changes in multiple reactive variables and triggers a rebuild when any variable changes.
class ObserverN extends StatelessWidget {
  /// Constructs an [ObserverN] widget.
  ///
  /// The [listenable] parameter is a list of reactive variables to listen to.
  ///
  /// The [listener] parameter is a callback function that defines the widget to rebuild whenever any of the reactive variables changes.
  const ObserverN({
    Key? key,
    required this.listenable,
    required this.listener,
  }) : super(key: key);

  /// The list of reactive variables to listen to for changes.
  final List<Reactive> listenable;

  /// A callback function that defines the widget to rebuild whenever any of the reactive variables changes.
  final Widget Function() listener;

  Widget observer(int toBeAccessedIndex) {
    if (listenable.length <= toBeAccessedIndex) return listener();
    return Observer(
      listenable: listenable[toBeAccessedIndex],
      listener: (e) {
        return observer(toBeAccessedIndex + 1);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return observer(0);
  }
}
