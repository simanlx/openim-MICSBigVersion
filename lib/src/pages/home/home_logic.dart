import 'package:get/get.dart';

class HomeLogic extends GetxController {

  var index = 0.obs;
  var unreadMsgCount = 0.obs;
  var unhandledFriendApplicationCount = 0.obs;
  var unhandledGroupApplicationCount = 0.obs;
  var unhandledCount = 0.obs;

  void switchTab(int i) {
    index.value = i;
  }


}
