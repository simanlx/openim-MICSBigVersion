import 'package:get/get.dart';

import '../../core/controller/im_controller.dart';
import '../../core/controller/jpush_controller.dart';
import '../../res/strings.dart';
import '../../routes/app_navigator.dart';
import '../../utils/data_persistence.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/im_widget.dart';
import '../../widgets/loading_view.dart';

class MineLogic extends GetxController {

  final imLogic = Get.find<IMController>();
  final jPushLogic = Get.find<JPushController>();
  var index = 0.obs;

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


}
