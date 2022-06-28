import 'package:get/get.dart';

import 'workbench_main_logic.dart';

class WorkbenchMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkbenchMainLogic());
  }
}
