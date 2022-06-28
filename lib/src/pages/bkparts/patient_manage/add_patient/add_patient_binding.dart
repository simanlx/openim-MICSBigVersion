import 'package:get/get.dart';

import 'add_patient_logic.dart';

class AddPatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddPatientLogic());
  }
}
