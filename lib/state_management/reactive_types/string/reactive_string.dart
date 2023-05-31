part of '../../reactive_types.dart';

class ReactiveString extends Reactive<String> {
  ReactiveString(super.value);
}


class ReactiveStringN extends ReactiveN<String> {
  ReactiveStringN([super.value]);
}


extension StringExtension on String {
  ReactiveString get reactiv => ReactiveString(this);
}


