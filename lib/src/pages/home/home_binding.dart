import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/home/mine/mine_logic.dart';

import './contacts/contacts_logic.dart';
import './conversation/conversation_logic.dart';
import './work_bench/work_bench_logic.dart';
import 'home_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());
    Get.lazyPut(() => ConversationLogic());
    Get.lazyPut(() => ContactsLogic());
    Get.lazyPut(() => MineLogic());
    Get.lazyPut(() => WorkbenchLogic());
  }
}
