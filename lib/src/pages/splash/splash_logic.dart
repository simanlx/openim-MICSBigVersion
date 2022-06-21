import 'package:get/get.dart';

import '../../core/controller/im_controller.dart';
import '../../core/controller/jpush_controller.dart';
import '../../routes/app_navigator.dart';
import '../../utils/data_persistence.dart';
import '../../widgets/im_widget.dart';

class SplashLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final jPushLogic = Get.find<JPushController>();

  var loginCertificate = DataPersistence.getLoginCertificate();

  bool get isExistLoginCertificate => loginCertificate != null;

  String? get uid => loginCertificate?.userID;

  String? get token => loginCertificate?.token;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    imLogic.initializedSubject.listen((value) async {
      print('---------------------initialized---------------------');
      if (isExistLoginCertificate) {
        await _login();
      } else {
        AppNavigator.startLogin();
      }
    });
    super.onReady();
  }

  _login() async {
    try {
      if(token == null || uid == null){
        AppNavigator.startLogin();
        return;
      }
      print('---------login---------- uid: $uid, token: $token');
      await imLogic.login(uid!, token!);
      print('---------im login success-------');
      jPushLogic.login(uid!);
      print('---------jpush login success----');
      AppNavigator.startMain();
    } catch (e) {
      // IMWidget.showToast('$e');
      AppNavigator.startLogin();
    }
  }
}
