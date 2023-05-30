part of 'observer.dart';

class Observer2<A, B> extends StatelessWidget {
  const Observer2({
    Key? key,
    required this.listen,
    required this.listen2,
    required this.update,
  }) : super(key: key);

  final Reactive<A> listen;
  final Reactive<B> listen2;
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

class Observer3<A, B, C> extends StatelessWidget {
  const Observer3({
    Key? key,
    required this.listen,
    required this.listen2,
    required this.listen3,
    required this.update,
  }) : super(key: key);

  final Reactive<A> listen;
  final Reactive<B> listen2;
  final Reactive<C> listen3;
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
