import 'package:get/get.dart';

import 'message_read_logic.dart';

class GroupMessageReadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupMessageReadLogic());
  }
}
