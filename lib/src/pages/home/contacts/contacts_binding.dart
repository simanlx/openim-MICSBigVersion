import 'package:get/get.dart';

import 'contacts_logic.dart';
import 'friend_list/friend_list_logic.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactsLogic());
  }
}
