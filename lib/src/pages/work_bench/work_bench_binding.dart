import 'package:get/get.dart';

import 'work_bench_logic.dart';

class WorkbenchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkbenchLogic());
  }
}
