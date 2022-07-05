import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/common/config.dart';
import 'package:mics_big_version/src/utils/data_persistence.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';

class ServerConfigLogic extends GetxController {
  var checked = true.obs;
  var index = 0.obs;
  var ipCtrl = TextEditingController();
  var imApiCtrl = TextEditingController();
  var imWsCtrl = TextEditingController();

  @override
  void onInit() {
    ipCtrl.text = Config.serverIp();
    imApiCtrl.text = Config.imApiUrl();
    imWsCtrl.text = Config.imWsUrl();
    super.onInit();
  }

  @override
  void onClose() {
    imApiCtrl.dispose();
    imWsCtrl.dispose();
    ipCtrl.dispose();
    super.onClose();
  }

  void toggleRadio() {
    checked.value = !checked.value;
  }

  void confirm() async {
    await DataPersistence.putServerConfig({
      'serverIP': ipCtrl.text,
      'apiUrl': imApiCtrl.text,
      'wsUrl': imWsCtrl.text,
    });
    IMWidget.showToast('重启app后配置生效');
    // Get.reset();
  }

  void toggleTab(i) {
    index.value = i;
  }
}
