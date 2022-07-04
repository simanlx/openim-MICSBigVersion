import 'package:get/get.dart';

import 'my_collection_logic.dart';

class MyCollectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCollectionLogic());
  }
}
