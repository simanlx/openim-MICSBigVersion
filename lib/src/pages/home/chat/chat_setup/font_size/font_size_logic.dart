import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_logic.dart';

class FontSizeLogic extends GetxController {
  var chatLogic = Get.find<ChatLogic>();
  var factor = 1.0.obs;

  void changed(double fac) {
    factor.value = fac;
  }

  void saveFactor() async {
    await chatLogic.changeFontSize(factor.value);
    Get.back();
  }
}
