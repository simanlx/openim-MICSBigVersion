import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/home/contacts/tag_group/tag_group_logic.dart';

class TagGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TagGroupLogic());
  }
}
