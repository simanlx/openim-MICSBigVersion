import 'package:get/get.dart';

import 'bkrs_group_list_view/bkrs_group_list_view_logic.dart';
import 'select_contacts_logic.dart';

class SelectContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectContactsLogic());
    Get.lazyPut(() => BkrsGroupListViewLogic());
  }
}
