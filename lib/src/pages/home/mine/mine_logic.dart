import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/core/controller/im_controller.dart';
import 'package:mics_big_version/src/core/controller/jpush_controller.dart';
import 'package:mics_big_version/src/models/call_records.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/widgets/custom_dialog.dart';
import 'package:mics_big_version/src/widgets/loading_view.dart';

import '../../../routes/app_navigator.dart';
import '../../../utils/data_persistence.dart';
import '../../../widgets/im_widget.dart';


class MineLogic extends GetxController {

  final imLogic = Get.find<IMController>();
  final jPushLogic = Get.find<JPushController>();
  var index = 0.obs;
  var callIndex = 0.obs;

  void switchIndex(int i) {
    index.value = i;
  }

  void logout() async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.confirmLogout,
    ));
    if (confirm == true) {
      try {
        await LoadingView.singleton.wrap(asyncFunction: () async {
          await imLogic.logout();
          // await DataPersistence.removeAccountInfo();
          await DataPersistence.removeLoginCertificate();
          await jPushLogic.logout();
        });
        AppNavigator.startLogin();
      } catch (e) {
        // AppNavigator.startLogin();
        IMWidget.showToast('e:$e');
      }
    }
  }

  switchCallTab(int i) {
    callIndex.value = i;
  }

}
