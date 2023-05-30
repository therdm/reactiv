import 'package:reactiv/controllers/reactive_controller.dart';
import 'package:reactiv/state_management/data_types/num/reactive_int.dart';

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
