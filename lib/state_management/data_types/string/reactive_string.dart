import '../base/reactive.dart';

class ReactiveString extends Reactive<String> {
  ReactiveString(super.value);
}


class ReactiveStringN extends ReactiveN<String> {
  ReactiveStringN([super.value]);
}
