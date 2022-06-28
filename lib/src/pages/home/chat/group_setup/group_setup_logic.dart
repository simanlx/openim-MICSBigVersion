import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/core/controller/app_controller.dart';
import 'package:mics_big_version/src/core/controller/im_controller.dart';
import 'package:mics_big_version/src/models/group_member_info.dart' as en;
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_member_manager/member_list/member_list_logic.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/routes/app_navigator.dart';
import 'package:mics_big_version/src/widgets/custom_dialog.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:mics_big_version/src/widgets/loading_view.dart';


import '../chat_logic.dart';

class GroupSetupLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  var chatLogic = Get.find<ChatLogic>();
  var appLogic = Get.find<AppController>();
  late Rx<GroupInfo> info;
  var memberList = <en.GroupMembersInfo>[].obs;
  var myGroupNickname = "".obs;
  var topContacts = false.obs;
  var noDisturb = false.obs;
  var noDisturbIndex = 0.obs;
  ConversationInfo? conversationInfo;

  getGroupMembers() async {
    var list = await OpenIM.iMManager.groupManager.getGroupMemberListMap(
      groupId: info.value.groupID,
    );

    var l = list.map((e) => en.GroupMembersInfo.fromJson(e));
    memberList.assignAll(l);
    info.update((val) {
      val?.memberCount = l.length;
    });
  }

  getGroupInfo() async {
    var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
      gidList: [info.value.groupID],
    );
    if (list.isEmpty) return;
    var value = list.first;
    info.update((val) {
      val?.groupName = value.groupName;
      val?.faceURL = value.faceURL;
      val?.notification = value.notification;
      val?.introduction = value.introduction;
      val?.memberCount = value.memberCount;
      val?.ownerUserID = value.ownerUserID;
      val?.status = value.status;
      print('群组id:${value.ownerUserID}');
    });
  }

  getMemberInfo() async {
    var list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
      groupId: info.value.groupID,
      uidList: [OpenIM.iMManager.uid],
    );
    if (list.length > 0) {
      myGroupNickname.value = list.first.nickname ?? '';
    }
  }

  void modifyAvatar() {
    IMWidget.openPhotoSheet(
      onData: (path, url) async {
        if (url != null) {
          await _updateGroupInfo(faceUrl: url);
          info.update((val) {
            val?.faceURL = url;
          });
        }
      },
    );
  }

  void modifyMyGroupNickname() {
    AppNavigator.startModifyMyNicknameInGroup(
      groupInfo: info.value,
      membersInfo:
          memberList.where((p0) => p0.userID == OpenIM.iMManager.uid).first,
    );
  }

  void modifyGroupName() {
    if (info.value.ownerUserID != OpenIM.iMManager.uid) {
      IMWidget.showToast(StrRes.onlyTheOwnerCanModify);
      return;
    }
    AppNavigator.startGroupNameSet(info: info.value);
  }

  void editGroupAnnouncement() {
    AppNavigator.startEditAnnouncement(info: info.value);
  }

  void viewGroupQrcode() {
    AppNavigator.startViewGroupQrcode(info: info.value);
  }

  void viewGroupMembers() async {
    print('群组id:${info.value.ownerUserID}');
    AppNavigator.startGroupMemberManager(info: info.value);
  }

  void transferGroup() async {
    var list = memberList;
    list.removeWhere((e) => e.userID == info.value.ownerUserID);
    var result = await AppNavigator.startGroupMemberList(
      gid: info.value.groupID,
      list: list,
      action: OpAction.ADMIN_TRANSFER,
    );
    if (null != result) {
      GroupMembersInfo member = result;
      await OpenIM.iMManager.groupManager.transferGroupOwner(
        gid: info.value.groupID,
        uid: member.userID!,
      );

      info.update((val) {
        val?.ownerUserID = member.userID;
      });
    }
  }

  void quitGroup() async {
    if (isMyGroup()) {
      var confirm = await Get.dialog(CustomDialog(
        title: StrRes.dismissGroupHint,
        rightText: StrRes.sure,
      ));
      if (confirm == true) {
        // transferGroup();
        await OpenIM.iMManager.groupManager.dismissGroup(
          groupID: info.value.groupID,
        );
      } else {
        return;
      }
    } else {
      var confirm = await Get.dialog(CustomDialog(
        title: StrRes.quitGroupHint,
        rightText: StrRes.sure,
      ));
      if (confirm == true) {
        // 退群
        await OpenIM.iMManager.groupManager.quitGroup(
          gid: info.value.groupID,
        );
        // 删除群会话
        // await OpenIM.iMManager.conversationManager
        //     .deleteConversationFromLocalAndSvr(
        //   conversationID: conversationInfo!.conversationID,
        // );
      } else {
        return;
      }
    }
    AppNavigator.startBackMain();
  }

  void memberListChanged(list) {
    memberList.assignAll(list);
    info.update((val) {
      val?.memberCount = list.length;
    });
  }

  void copyGroupID() {
    AppNavigator.startViewGroupId(info: info.value);
    // Get.toNamed(AppRoutes.GROUP_ID, arguments: info.value);
  }

  bool isMyGroup() {
    return info.value.ownerUserID == OpenIM.iMManager.uid;
  }

  _updateGroupInfo({
    String? groupName,
    String? notification,
    String? introduction,
    String? faceUrl,
  }) {
    return OpenIM.iMManager.groupManager.setGroupInfo(
      groupID: info.value.groupID,
      groupName: groupName,
      notification: notification,
      introduction: introduction,
      faceUrl: faceUrl,
    );
  }

  @override
  void onInit() {
    info = GroupInfo(
      groupID: Get.arguments['gid'],
      groupName: Get.arguments['name'],
      faceURL: Get.arguments['icon'],
      memberCount: 0,
    ).obs;
    imLogic.groupInfoUpdatedSubject.listen((value) {
      if (value.groupID == info.value.groupID) {
        info.update((val) {
          // val?.ownerId = value.ownerId;
          val?.groupName = value.groupName;
          val?.faceURL = value.faceURL;
          val?.notification = value.notification;
          val?.introduction = value.introduction;
          val?.memberCount = value.memberCount;
          val?.status = value.status;
        });
      }
    });
    imLogic.memberAddedSubject.listen((e) {
      var i = en.GroupMembersInfo.fromJson(e.toJson());
      memberList.add(i);
      info.update((val) {
        val?.memberCount = memberList.length;
      });
    });
    imLogic.memberDeletedSubject.listen((e) {
      memberList.removeWhere((element) => element.userID == e.userID);
      info.update((val) {
        val?.memberCount = memberList.length;
      });
    });
    super.onInit();
  }

  @override
  void onReady() {
    getGroupInfo();
    getConversationInfo();
    getGroupMembers();
    // getConversationRecvMessageOpt();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  int length() {
    int buttons = isMyGroup() ? 2 : 1;
    return (memberList.length + buttons) > 7
        ? 7
        : (memberList.length + buttons);
  }

  Widget itemBuilder({
    required int index,
    required Widget Function(GroupMembersInfo info) builder,
    required Widget Function() addButton,
    required Widget Function() delButton,
  }) {
    var length = isMyGroup() ? 5 : 6;
    if (memberList.length > length) {
      if (index < length) {
        var info = memberList.elementAt(index);
        return builder(info);
      } else if (index == length) {
        return addButton();
      } else {
        return delButton();
      }
    } else {
      if (index < memberList.length) {
        var info = memberList.elementAt(index);
        return builder(info);
      } else if (index == memberList.length) {
        return addButton();
      } else {
        return delButton();
      }
    }
  }

  void getConversationInfo() async {
    conversationInfo =
        await OpenIM.iMManager.conversationManager.getOneConversation(
      sourceID: info.value.groupID,
      sessionType: 2,
    );
    topContacts.value = conversationInfo!.isPinned!;

    var status = conversationInfo!.recvMsgOpt;
    noDisturb.value = status != 0;
    if (noDisturb.value) {
      noDisturbIndex.value = status == 1 ? 1 : 0;
    }
  }

  void toggleTopContacts() async {
    topContacts.value = !topContacts.value;
    if (conversationInfo == null) return;
    await OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: conversationInfo!.conversationID,
      isPinned: topContacts.value,
    );
  }

  void clearChatHistory() async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.confirmClearChatHistory,
      rightText: StrRes.clearAll,
    ));
    if (confirm == true) {
      await OpenIM.iMManager.messageManager
          .clearGroupHistoryMessageFromLocalAndSvr(
        gid: info.value.groupID,
      );
      chatLogic.clearAllMessage();
      IMWidget.showToast(StrRes.clearSuccess);
    }
  }

  void toggleNotDisturb() {
    noDisturb.value = !noDisturb.value;
    if (!noDisturb.value) noDisturbIndex.value = 0;
    setConversationRecvMessageOpt(status: noDisturb.value ? 2 : 0);
  }

  void noDisturbSetting() {
    IMWidget.openNoDisturbSettingSheet(
      isGroup: true,
      onTap: (index) {
        setConversationRecvMessageOpt(status: index == 0 ? 2 : 1);
        noDisturbIndex.value = index;
      },
    );
  }

  /// 消息免打扰
  /// 1: Do not receive messages, 2: Do not notify when messages are received; 0: Normal
  void setConversationRecvMessageOpt({int status = 2}) {
    LoadingView.singleton.wrap(
      asyncFunction: () =>
          OpenIM.iMManager.conversationManager.setConversationRecvMessageOpt(
        conversationIDList: ['group_${info.value.groupID}'],
        status: status,
      ),
    );
  }

  void searchHistoryMessage() {
    AppNavigator.startMessageSearch(info: conversationInfo!);
  }

  void toggleGroupMute() {
    // info.update((val) {
    //   val?.status = (info.value.status == 3) ? 0 : 3;
    // });
    LoadingView.singleton.wrap(asyncFunction: () async {
      await OpenIM.iMManager.groupManager.changeGroupMute(
        groupID: info.value.groupID,
        mute: !(info.value.status == 3),
      );
    });
  }
}
