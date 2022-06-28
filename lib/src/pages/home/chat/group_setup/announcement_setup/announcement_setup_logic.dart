import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/widgets/custom_dialog.dart';

class GroupAnnouncementSetupLogic extends GetxController {
  var enabled = false.obs;
  var focus = false.obs;
  var onlyRead = false.obs;
  var showFcBtn = false.obs;
  var inputCtrl = TextEditingController();
  var focusNode = FocusNode();
  late Rx<GroupInfo> info;

  void setAnnouncement() async {
    var publish = await Get.dialog(CustomDialog(
      title: StrRes.announcementHint,
      rightText: StrRes.publish,
    ));
    if (publish == true) {
      await OpenIM.iMManager.groupManager.setGroupInfo(
        groupID: info.value.groupID,
        notification: inputCtrl.text,
      );
      info.update((val) {
        val?.notification = inputCtrl.text;
      });

      Get.back();
    }
  }

  @override
  void onInit() {
    info = Rx(Get.arguments);
    inputCtrl.text = info.value.notification ?? '';
    focus.value = inputCtrl.text.isEmpty;
    onlyRead.value = inputCtrl.text.isNotEmpty;
    showFcBtn.value = info.value.ownerUserID == OpenIM.iMManager.uid;
    inputCtrl.addListener(() {
      if (!onlyRead.value) enabled.value = inputCtrl.text.trim().isNotEmpty;
    });
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  editing() {
    onlyRead.value = false;
    enabled.value = true;
    focus.value = true;
    focusNode.requestFocus();
  }
}
