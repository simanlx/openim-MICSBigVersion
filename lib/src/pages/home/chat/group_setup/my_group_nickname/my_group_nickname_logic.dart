import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:mics_big_version/src/widgets/loading_view.dart';

class MyGroupNicknameLogic extends GetxController {
  var nicknameCtrl = TextEditingController();
  var enabled = false.obs;
  late GroupInfo groupInfo;
  late GroupMembersInfo membersInfo;

  @override
  void onInit() {
    groupInfo = Get.arguments['groupInfo'];
    membersInfo = Get.arguments['membersInfo'];
    nicknameCtrl.text = membersInfo.nickname!;
    nicknameCtrl.addListener(() {
      enabled.value = nicknameCtrl.text.trim().isNotEmpty;
    });
    super.onInit();
  }

  void clear() {
    nicknameCtrl.clear();
  }

  void modifyMyNickname() {
    if (nicknameCtrl.text.isNotEmpty) {
      LoadingView.singleton.wrap(asyncFunction: () async {
        await OpenIM.iMManager.groupManager.setGroupMemberNickname(
          groupID: groupInfo.groupID,
          userID: OpenIM.iMManager.uid,
          groupNickname: nicknameCtrl.text,
        );
        membersInfo.nickname = nicknameCtrl.text;
        IMWidget.showToast(StrRes.setSuccessfully);
        Get.back();
      });
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    nicknameCtrl.dispose();
    super.onClose();
  }
}
