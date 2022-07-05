import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/core/controller/SpeechServiceController.dart';
import 'package:mics_big_version/src/core/controller/app_controller.dart';
import 'package:mics_big_version/src/core/controller/cache_controller.dart';
import 'package:mics_big_version/src/core/controller/im_controller.dart';

class HomeLogic extends GetxController {

  final cacheLogic = Get.find<CacheController>();
  final imLogic = Get.find<IMController>();
  final speechServiceController = Get.find<SpeechServiceController>();


  final initLogic = Get.find<AppController>();
  var index = 0.obs;
  var unreadMsgCount = 0.obs;
  var unhandledFriendApplicationCount = 0.obs;
  var unhandledGroupApplicationCount = 0.obs;
  var unhandledCount = 0.obs;

  void switchTab(int i) {
    index.value = i;
  }

  @override
  void onReady() {
    getUnreadMsgCount();
    getUnhandledFriendApplicationCount();
    getUnhandledGroupApplicationCount();
    cacheLogic.initCallRecords();
    cacheLogic.initFavoriteEmoji();
    super.onReady();
  }
  /// 获取好友申请未处理数
  void getUnhandledFriendApplicationCount() {
    var i = 0;
    OpenIM.iMManager.friendshipManager
        .getRecvFriendApplicationList()
        .then((list) {
      for (var info in list) {
        if (info.handleResult == 0) i++;
      }
      unhandledFriendApplicationCount.value = i;
      unhandledCount.value = unhandledGroupApplicationCount.value + i;
    });
  }
  /// 获取群申请未处理数
  void getUnhandledGroupApplicationCount() {
    OpenIM.iMManager.groupManager.getRecvGroupApplicationList().then((list) {
      var i = list.where((e) => e.handleResult == 0).length;
      print('getUnhandledGroupApplicationCount-----------$i}');
      unhandledGroupApplicationCount.value = i;
      unhandledCount.value = unhandledFriendApplicationCount.value + i;
    });
  }


  /// 获取消息未读数
  void getUnreadMsgCount() {
    OpenIM.iMManager.conversationManager.getTotalUnreadMsgCount().then((count) {
      unreadMsgCount.value = int.tryParse(count) ?? 0;
      initLogic.showBadge(unreadMsgCount.value);
    });
  }

  @override
  void onInit() {
    imLogic.groupApplicationChangedSubject.listen((value) {
      getUnhandledGroupApplicationCount();
    });
    speechServiceController.initSpeechSdk();
    super.onInit();
  }

  @override
  void onClose() {
    print("首页退出....");
    super.onClose();
  }

}
