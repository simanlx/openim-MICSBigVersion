import 'package:get/get.dart';

import 'ysxy_logic.dart';

class YsxyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YsxyLogic());
  }
}
