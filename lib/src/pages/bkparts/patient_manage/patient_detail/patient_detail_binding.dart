import 'package:get/get.dart';

import 'patient_detail_logic.dart';

class PatientDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PatientDetailLogic());
  }
}
