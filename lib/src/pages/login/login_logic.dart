import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/apis.dart';
import '../../core/controller/im_controller.dart';
import '../../core/controller/jpush_controller.dart';
import '../../res/strings.dart';
import '../../routes/app_navigator.dart';
import '../../utils/data_persistence.dart';
import '../../utils/im_util.dart';
import '../../widgets/im_widget.dart';
import '../../widgets/loading_view.dart';

class LoginLogic extends GetxController {


  var phoneCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var pwdCtrl = TextEditingController();
  var phoneFocusNode = FocusNode();
  var emailFocusNode = FocusNode();
  var showAccountClearBtn = false.obs;
  var showPwdClearBtn = false.obs;
  var obscureText = true.obs;
  var agreedProtocol = true.obs;
  var imLogic = Get.find<IMController>();
  var jPushLogic = Get.find<JPushController>();
  var enabledLoginButton = false.obs;
  var index = 0.obs;
  var areaCode = "+86".obs;

  void toggleEye() {
    obscureText.value = !obscureText.value;
  }

  void _changeLoginButtonStatus() {
    enabledLoginButton.value = pwdCtrl.text.isNotEmpty &&
        phoneCtrl.text.isNotEmpty;
  }


  @override
  void onReady() {

    phoneCtrl.addListener(() {
      _changeLoginButtonStatus();
    });

    pwdCtrl.addListener(() {
      showPwdClearBtn.value = pwdCtrl.text.isNotEmpty;
      _changeLoginButtonStatus();
    });

    super.onReady();
  }

  login() async {
    if (index.value == 0 && !IMUtil.isMobile(phoneCtrl.text)) {
      IMWidget.showToast(StrRes.plsInputRightPhone);
      return;
    }
    if (index.value == 1 && !GetUtils.isEmail(emailCtrl.text)) {
      IMWidget.showToast(StrRes.plsInputRightEmail);
      return;
    }
    LoadingView.singleton.wrap(asyncFunction: () async {
      var suc = await _login();
      if (suc) {
        AppNavigator.startMain();
      }
    });
  }

  Future<bool> _login() async {
    try {
      var data = await Apis.login(
        areaCode: areaCode.value,
        phoneNumber: index.value == 0 ? phoneCtrl.text : null,
        email: index.value == 1 ? emailCtrl.text : null,
        password: pwdCtrl.text,
      );
      await DataPersistence.putLoginCertificate(data);
      print(
          '---------login---------- uid: ${data.userID}, token: ${data.token}');
      await imLogic.login(data.userID, data.token);
      print('---------im login success-------');
      jPushLogic.login(data.userID);
      print('---------jpush login success----');
      return true;
    } catch (e) {
      print('login e: $e');
    } finally {}
    return false;
  }
}
