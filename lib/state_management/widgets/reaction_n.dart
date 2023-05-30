part of 'reaction.dart';

class Reaction2<A, B> extends StatelessWidget {
  const Reaction2({
    Key? key,
    required this.cause,
    required this.cause2,
    required this.effect,
  }) : super(key: key);

  final Reactive<A> cause;
  final Reactive<B> cause2;
  final Widget Function(A data1, B data2) effect;

  @override
  Widget build(BuildContext context) {
    return Reaction(
      cause: cause,
      effect: (data1) {
        return Reaction(
          cause: cause2,
          effect: (data2) {
            return effect(data1, data2);
          },
        );
      },
    );
  }
}

class Reaction3<A, B, C> extends StatelessWidget {
  const Reaction3({
    Key? key,
    required this.cause,
    required this.cause2,
    required this.cause3,
    required this.effect,
  }) : super(key: key);

  final Reactive<A> cause;
  final Reactive<B> cause2;
  final Reactive<C> cause3;
  final Widget Function(A data1, B data2, C data3) effect;

  @override
  Widget build(BuildContext context) {
    return Reaction(
      cause: cause,
      effect: (data1) {
        return Reaction(
          cause: cause2,
          effect: (data2) {
            return Reaction(
              cause: cause3,
              effect: (data3) {
                return effect(data1, data2, data3);
              },
            );
          },
        );
      },
    );
  }
}
