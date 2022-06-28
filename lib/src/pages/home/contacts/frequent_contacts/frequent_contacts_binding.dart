import 'package:get/get.dart';

import 'frequent_contacts_logic.dart';

class FrequentContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrequentContactsLogic());
  }
}
