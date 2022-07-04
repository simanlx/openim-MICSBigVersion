import 'package:get/get.dart';

import 'my_collection_detail_logic.dart';

class MyCollectionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCollectionDetailLogic());
  }
}
