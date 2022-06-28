import 'package:get/get.dart';

import 'patient_manage_logic.dart';

class PatientManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PatientManageLogic());
  }
}
