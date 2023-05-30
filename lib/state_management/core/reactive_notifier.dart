

class ReactiveNotifier<T> {
  final Stream<T> stream;

  ReactiveNotifier(this.stream);
}