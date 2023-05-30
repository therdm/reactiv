

import 'package:reactiv/controllers/reactive_controller.dart';
import 'package:reactiv/state_management/data_types/base/reactive.dart';
import 'package:reactiv/state_management/data_types/iterator/reactive_list.dart';
import 'package:reactiv/state_management/data_types/num/reactive_int.dart';

class TestPageController extends ReactiveController {
  final count = ReactiveInt(0);
  final title = ReactiveN<String>();

  ReactiveList<String> list = ReactiveList<String>([]);
  ReactiveListN<String> list2 = ReactiveListN<String>();

  @override
  void onInit() {
    super.onInit();
  }

  increment() {
    count.value = (count.value ?? 0) + 1;
  }
}
