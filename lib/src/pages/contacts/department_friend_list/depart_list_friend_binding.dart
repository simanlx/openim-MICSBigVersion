import 'package:get/get.dart';

import 'depart_list_friend_logic.dart';

class DepartListFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DepartListFriendLogic());
  }
}
