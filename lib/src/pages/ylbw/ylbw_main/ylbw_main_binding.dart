import 'package:get/get.dart';

import 'ylbw_main_logic.dart';

class YlbwMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YlbwMainLogic());
  }
}
