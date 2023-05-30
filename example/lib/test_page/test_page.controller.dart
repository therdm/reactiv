import 'package:reactiv/controllers/reactive_controller.dart';
import 'package:reactiv/state_management/reactive_types.dart';

class TestPageController extends ReactiveController {
  final count = ReactiveInt(0);

  @override
  void onInit() {
    super.onInit();
  }

  increment() {
    count.value = (count.value ?? 0) + 1;
  }
}
