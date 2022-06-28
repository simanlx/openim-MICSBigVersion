import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as im;
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/routes/app_navigator.dart';
import 'package:mics_big_version/src/utils/im_util.dart';
import 'package:mics_big_version/src/widgets/custom_dialog.dart';
import 'package:sprintf/sprintf.dart';
import 'package:mics_big_version/src/models/group_member_info.dart' as me;

enum OpAction { DELETE, ADMIN_TRANSFER, GROUP_CALL, AT }

class GroupMemberListLogic extends GetxController {
  var memberList = <me.GroupMembersInfo>[].obs;
  var currentCheckedList = <me.GroupMembersInfo>[].obs;
  var defaultCheckedUidList = <String>[];
  var action = OpAction.DELETE;
  late String gid;
  var maxCount = 9;
  var curCount = 0.obs;

  @override
  void onInit() {
    gid = Get.arguments['gid'];
    var allList = Get.arguments['list'];
    var checkedList = Get.arguments['defaultCheckedUidList'];
    var ac = Get.arguments['action'];
    if (null != ac) action = ac;
    memberList.addAll(allList ?? []);
    defaultCheckedUidList.addAll(checkedList ?? []);
    if (memberList.isNotEmpty) {
      IMUtil.convertToAZList(memberList);
    } else {
      _queryGroupMembers();
    }
    super.onInit();
  }

  void _queryGroupMembers() async {
    var list = await im.OpenIM.iMManager.groupManager.getGroupMemberListMap(
      groupId: gid,
    );
    var l = list.map((e) => me.GroupMembersInfo.fromJson(e));
    memberList.addAll(l);
    if (memberList.isNotEmpty && action == OpAction.AT) {
      memberList
          .removeWhere((element) => element.userID == im.OpenIM.iMManager.uid);
    }
    IMUtil.convertToAZList(memberList);
  }

  void selectedMember(index) async {
    var info = memberList.elementAt(index);
    if (action == OpAction.DELETE ||
        action == OpAction.GROUP_CALL ||
        action == OpAction.AT) {
      if (currentCheckedList.contains(info)) {
        currentCheckedList.remove(info);
      } else {
        if (action == OpAction.GROUP_CALL && curCount.value == maxCount) {
          return;
        }
        currentCheckedList.add(info);
      }
      curCount.value = currentCheckedList.length;
    } else if (action == OpAction.ADMIN_TRANSFER) {
      var confirm = await Get.dialog(CustomDialog(
        title: sprintf(StrRes.confirmTransferGroupToUser, [info.nickname]),
      ));
      if (confirm == true) {
        Get.back(result: info);
      }
    }
  }

  void confirmSelected() async {
    if (curCount.value == 0) return;
    if (action == OpAction.DELETE) {
      var confirm = await Get.dialog(CustomDialog(
        title: StrRes.confirmDelMember,
        rightText: StrRes.sure,
      ));
      if (confirm == true) {
        Get.back(result: currentCheckedList.value);
      }
    } else if (action == OpAction.GROUP_CALL) {
      Get.back(result: currentCheckedList.map((e) => e.userID!).toList());
    } else if (action == OpAction.AT) {
      Get.back(result: currentCheckedList);
    }
  }

  void removeContacts(me.GroupMembersInfo info) {
    currentCheckedList.remove(info);
  }

  bool isMultiModel() {
    return action == OpAction.DELETE ||
        action == OpAction.GROUP_CALL ||
        action == OpAction.AT;
  }

  bool isMultiModelConfirm() {
    return action == OpAction.GROUP_CALL || action == OpAction.AT;
  }

  void search() async {
    var info = await AppNavigator.startSearchMember(list: memberList.value);
    if (null != info) {
      if (!currentCheckedList.contains(info)) {
        currentCheckedList.add(info);
      }
      curCount.value = currentCheckedList.length;
      if (action == OpAction.ADMIN_TRANSFER) {
        var confirm = await Get.dialog(CustomDialog(
          title: sprintf(StrRes.confirmTransferGroupToUser, [info.nickName]),
        ));
        if (confirm == true) {
          Get.back(result: info);
        }
      }
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
