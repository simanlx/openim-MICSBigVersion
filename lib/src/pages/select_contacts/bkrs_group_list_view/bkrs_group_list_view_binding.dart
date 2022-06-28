import 'package:get/get.dart';

import 'bkrs_group_list_view_logic.dart';

class BkrsGroupListViewBinding extends Bindings {


  @override
  void dependencies() {
    Get.lazyPut(() => BkrsGroupListViewLogic());
  }
}
