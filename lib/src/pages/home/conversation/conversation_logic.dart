import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/core/controller/app_controller.dart';
import 'package:mics_big_version/src/core/controller/im_controller.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_logic.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_view.dart';
import 'package:mics_big_version/src/pages/home/home_logic.dart';
import 'package:mics_big_version/src/pages/home/work_bench/work_bench_logic.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/routes/app_navigator.dart';
import 'package:mics_big_version/src/routes/app_pages.dart';
import 'package:mics_big_version/src/utils/EventBusBkrs.dart';
import 'package:mics_big_version/src/utils/data_persistence.dart';
import 'package:mics_big_version/src/utils/im_util.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ConversationLogic extends GetxController {
  var popCtrl = CustomPopupMenuController();
  var list = <ConversationInfo>[].obs;
  var imLogic = Get.find<IMController>();
  var homeLogic = Get.find<HomeLogic>();
  var appLogic = Get.find<AppController>();
  var workbenchLogic = Get.find<WorkbenchLogic>();
  final refreshController = RefreshController(initialRefresh: false);
  var tempDraftText = <String, String>{};
  final _pageSize = 40;

  var stackList = <Widget>[].obs;

  @override
  void onInit() {
    imLogic.conversationAddedSubject.listen((newList) {
      // getConversationListSplit();
      // getAllConversationList();
      // list.addAll(newList);
      for (var newValue in newList) {
        list.remove(newValue);
      }
      list.insertAll(0, newList);
      _sortConversationList();
      // _parseDoNotDisturb(newList);
    });
    imLogic.conversationChangedSubject.listen((newList) {
      for (var newValue in newList) {
        list.remove(newValue);
      }
      list.insertAll(0, newList);
      _sortConversationList();
      // getConversationListSplit();
      // getAllConversationList();
      // list.assignAll(newList);
      // _parseDoNotDisturb(newList);
    });
    super.onInit();
  }

  @override
  void onReady() {
    onRefresh();
    busBkrs.on("on_key_read", (arg) {
      oneKeyRead();
    });
    //页面
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getConversationId(int index) {
    var info = list.elementAt(index);
    return info.conversationID;
  }

  /// 标记会话已读
  void markMessageHasRead(int index) {
    var info = list.elementAt(index);
    _markMessageHasRead(
      conversationType: info.conversationType!,
      conversationID: info.conversationID,
      uid: info.userID,
      gid: info.groupID,
      unreadCount: info.unreadCount!,
    );
  }

  /// 置顶会话
  void pinConversation(int index) async {
    var info = list.elementAt(index);
    OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: info.conversationID,
      isPinned: !info.isPinned!,
    );
  }

  /// 删除会话
  void deleteConversation(int index) async {
    var info = list.elementAt(index);
    await OpenIM.iMManager.conversationManager
        .deleteConversationFromLocalAndSvr(
      conversationID: info.conversationID,
    );
    list.removeAt(index);
  }

  /// 设置草稿
  void setConversationDraft({required String cid, required String draftText}) {
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: cid,
      draftText: draftText,
    );
  }

  String? getPrefixText(int index) {
    var info = list.elementAt(index);
    String? prefix;
    try {
      // 草稿
      if (null != info.draftText && '' != info.draftText) {
        var map = json.decode(info.draftText!);
        String text = map['text'];
        if (text.isNotEmpty) {
          prefix = '[${StrRes.draftText}]';
        }
      } else if (info.latestMsg?.contentType == MessageType.at_text) {
        // @ 消息
        Map map = json.decode(info.latestMsg!.content!);
        String text = map['text'];
        // bool isAtSelf = map['isAtSelf'];
        bool isAtSelf = text.contains('@${OpenIM.iMManager.uid} ');
        if (isAtSelf == true) {
          prefix = '[@${StrRes.you}]';
        }
      }
    } catch (e) {}

    return prefix;
  }

  /// 解析消息内容
  String getMsgContent(int index) {
    var info = list.elementAt(index);
    try {
      if (null != info.draftText && '' != info.draftText) {
        var map = json.decode(info.draftText!);
        String text = map['text'];
        if (text.isNotEmpty) {
          return text;
        }
      }

      if (null == info.latestMsg) return "";

      final text = IMUtil.parseNotification(info.latestMsg!);
      if (text != null) return text;

      return IMUtil.parseMsg(info.latestMsg!, isConversation: true);

      /*if (info.latestMsg?.contentType == MessageType.picture) {
        return '[${StrRes.picture}]';
      } else if (info.latestMsg?.contentType == MessageType.video) {
        return '[${StrRes.video}]';
      } else if (info.latestMsg?.contentType == MessageType.voice) {
        return '[${StrRes.voice}]';
      } else if (info.latestMsg?.contentType == MessageType.file) {
        return '[${StrRes.file}]';
      } else if (info.latestMsg?.contentType == MessageType.location) {
        return '[${StrRes.location}]';
      } else if (info.latestMsg?.contentType == MessageType.merger) {
        return '[${StrRes.chatRecord}]';
      } else if (info.latestMsg?.contentType == MessageType.card) {
        return '[${StrRes.carte}]';
      } else if (info.latestMsg?.contentType == MessageType.revoke) {
        if (info.latestMsg?.sendID == OpenIM.iMManager.uid) {
          return '[${StrRes.you} ${StrRes.revokeMsg}]';
        } else {
          return '[${info.latestMsg!.senderNickname} ${StrRes.revokeMsg}]';
        }
      } else if (info.latestMsg?.contentType == MessageType.at_text) {
        String text = info.latestMsg!.content!;
        Map map = json.decode(text);
        text = map['text'] ?? '';
        return text;
      } else if (info.latestMsg?.contentType == MessageType.quote) {
        return info.latestMsg?.quoteElem?.text ?? "";
      } else if (info.latestMsg?.contentType == MessageType.text) {
        return info.latestMsg?.content?.trim() ?? '';
      } else if (info.latestMsg?.contentType == MessageType.custom_face) {
        return '[${StrRes.customEmoji}]';
      } else if (info.latestMsg?.contentType == MessageType.oaNotification) {
        // OA通知
        String detail = info.latestMsg!.notificationElem!.detail!;
        var oa = OANotification.fromJson(json.decode(detail));
        return oa.text!;
      } else if (info.latestMsg?.contentType == MessageType.custom) {
        // 自定义消息
        var data = info.latestMsg?.customElem!.data;
        var map = json.decode(data!);
        var customType = map['customType'];
        var customData = map['data'];
        switch (customType) {
          case CustomMessageType.call:
            {
              var type = map['data']['type'];
              return '[${type == 'video' ? StrRes.callVideo : StrRes.callVoice}]';
            }
          case CustomMessageType.custom_emoji:
            {
              return '[${StrRes.customEmoji}]';
            }
          case CustomMessageType.tag_message:
            {
              final text = customData['text'];
              final duration = customData['duration'];
              final url = customData['url'];
              if (text != null) {
                return text!;
              } else if (url != null) {
                return '[${StrRes.voice}]';
              } else {
                return '[${StrRes.unsupportedMessage}]';
              }
            }
          default:
            {
              return '[${StrRes.unsupportedMessage}]';
            }
        }
      } else {
        var content = json.decode(info.latestMsg!.content!);
        var text = content['defaultTips'] ?? '[${StrRes.unsupportedMessage}]';
        return text;
      }*/
    } catch (e) {
      print('------e:$e');
    }
    return '[${StrRes.unsupportedMessage}]';
  }

  Map<String, String> getAtUserMap(int index) {
    var info = list.elementAt(index);
    if (null != info.draftText && '' != info.draftText) {
      var map = json.decode(info.draftText!);
      var atMap = map['at'];
      if (atMap.isNotEmpty && atMap is Map) {
        var v = <String, String>{};
        atMap.forEach((key, value) {
          v.addAll({'$key': "$value"});
        });
        return v;
      }
    }
    if (info.isGroupChat) {
      Map<String, String> map =
          DataPersistence.getAtUserMap(info.groupID!)?.cast() ?? {};
      var message = info.latestMsg;
      if (message?.contentType == MessageType.at_text) {
        var list = message!.atElem!.atUsersInfo;
        list?.forEach((e) {
          map[e.atUserID!] = e.groupNickname!;
          // map.putIfAbsent(e.atUserID!, () => e.groupNickname!);
        });
      }
      return map;
    }
    return {};
  }

  /// 头像
  String? getAvatar(int index) {
    var info = list.elementAt(index);
    return info.faceURL;
  }

  bool isGroupChat(int index) {
    var info = list.elementAt(index);
    return info.isGroupChat;
  }

  /// 显示名
  String getShowName(int index) {
    var info = list.elementAt(index);
    if (info.showName == null || info.showName.isBlank!) {
      return info.userID!;
    }
    return info.showName!;
  }

  /// 时间
  String getTime(int index) {
    var info = list.elementAt(index);
    return IMUtil.getChatTimeline(info.latestMsgSendTime!);
  }

  /// 未读数
  int getUnreadCount(int index) {
    var info = list.elementAt(index);
    return info.unreadCount ?? 0;
  }

  bool existUnreadMsg(int index) {
    return getUnreadCount(index) > 0;
  }

  /// 判断置顶
  bool isPinned(int index) {
    var info = list.elementAt(index);
    return info.isPinned!;
  }

  bool isNotDisturb(int index) {
    var info = list.elementAt(index);
    return info.recvMsgOpt != 0;
  }

  void toAddFriend() {
    AppNavigator.startAddFriend();
  }

  void toAddGroup() {
    AppNavigator.startAddGroupBySearch();
  }

  void createGroup() {
    AppNavigator.createGroup();
  }

  void toScanQrcode() {
    AppNavigator.startScanQrcode();
  }

  void toViewCallRecords() {
    AppNavigator.startCallRecords();
  }

  /// 聊天
  void toChat(int index) async {
    var info = list.elementAt(index);
    if (info.conversationType == ConversationType.notification) {
      // OA系统通知
      await AppNavigator.startOANotificationList(info: info);
      // 标记已读
      _markMessageHasRead(
        conversationType: info.conversationType!,
        conversationID: info.conversationID,
        uid: info.userID,
        gid: info.groupID,
        unreadCount: info.unreadCount,
      );
    } else {
      startChat(
        userID: info.userID,
        groupID: info.groupID,
        nickname: info.showName,
        faceURL: info.faceURL,
        conversationInfo: info,
      );
    }
  }


  /// 聊天
  void toChatBigScreen(int index) async {
    var info = list.elementAt(index);
    if (info.conversationType == ConversationType.notification) {
      // OA系统通知
      await AppNavigator.startOANotificationList(info: info);
      // 标记已读
      _markMessageHasRead(
        conversationType: info.conversationType!,
        conversationID: info.conversationID,
        uid: info.userID,
        gid: info.groupID,
        unreadCount: info.unreadCount,
      );
    } else {
      toChatBigScreenOther(
        userID: info.userID,
        groupID: info.groupID,
        nickname: info.showName,
        faceURL: info.faceURL,
        conversationInfo: info,
      );
    }
  }

  /// 从其他界面进入聊天界面（非会话界面进入聊天界面）
  void toChatBigScreenOther({
    int type = 0,
    String? userID,
    String? groupID,
    String? nickname,
    String? faceURL,
    ConversationInfo? conversationInfo,
    Message? searchMessage,
    // int? unreadCount,
  }) async {
    // 获取会话信息，若不存在则创建
    conversationInfo ??=
    await OpenIM.iMManager.conversationManager.getOneConversation(
      sourceID: userID == null || userID.isEmpty ? groupID! : userID,
      sessionType: userID == null || userID.isEmpty ? 2 : 1,
    );

    print("明明 startChat conversationInfo ${json.encode(conversationInfo)}");

    // 保存旧草稿
    updateDartText(
      conversationID: conversationInfo.conversationID,
      uid: userID,
      gid: groupID,
      text: conversationInfo.draftText ?? '',
    );

    if (type == 1) {
      while(Get.currentRoute != AppRoutes.HOME){
        print(Get.currentRoute+"循环里面结束的路由！！！");
        Get.back();
      }
    }

    if(homeLogic.index!=1){
      homeLogic.switchTab(1);
    }

    //聊天
    // FocusScope.of(Get.context!).requestFocus(FocusNode());
    stackList.clear();
    Get.delete<ChatLogic>();
    Get.delete<ChatPage>(tag: "conversation");
    Get.put(ChatLogic(
      uid: userID,
      gid: groupID,
      name: nickname,
      icon: faceURL,
      draftText:conversationInfo.draftText??"",
      isValidChat:
        conversationInfo.conversationType == ConversationType.single ||
            conversationInfo.conversationType == ConversationType.group &&
                !conversationInfo.isNotInGroup!,
    ),);
    var page = ChatPage();
    Get.put(page,tag: "conversation");
    print("===========标识符 ${page.hashCode}=============");
    stackList.add(page);

    // 打开聊天窗口，关闭返回草稿
    /*var newDraftText = */
    // await AppNavigator.startChat(
    //   type: type,
    //   uid: userID,
    //   gid: groupID,
    //   name: nickname,
    //   icon: faceURL,
    //   draftText: conversationInfo.draftText,
    //   isValidChat:
    //   conversationInfo.conversationType == ConversationType.single ||
    //       conversationInfo.conversationType == ConversationType.group &&
    //           !conversationInfo.isNotInGroup!,
    //   conversationInfo: conversationInfo,
    //   searchMessage: searchMessage,
    // );
    //
    // // 读取草稿
    // var newDraftText = tempDraftText[conversationInfo.conversationID];

    int? count;
    var l =
    list.where((e) => e.conversationID == conversationInfo!.conversationID);
    if (l.isNotEmpty) {
      count = l.first.unreadCount;
    }
    // count ??= unreadCount ?? info!.unreadCount!;

    // 标记已读
    _markMessageHasRead(
      conversationType: conversationInfo.conversationType!,
      conversationID: conversationInfo.conversationID,
      uid: userID,
      gid: groupID,
      unreadCount: count,
    );

    // 记录草稿
    // _setupDraftText(
    //   conversationID: conversationInfo.conversationID,
    //   oldDraftText: conversationInfo.draftText ?? '',
    //   newDraftText: newDraftText!,
    // );
    // 回到会话列表
    // homeLogic.switchTab(0);
  }


  bool isUserGroup(int index) => list.elementAt(index).conversationType == 2;

  /// 从其他界面进入聊天界面（非会话界面进入聊天界面）
  void startChat({
    int type = 0,
    String? userID,
    String? groupID,
    String? nickname,
    String? faceURL,
    ConversationInfo? conversationInfo,
    Message? searchMessage,
    // int? unreadCount,
  }) async {
    // 获取会话信息，若不存在则创建
    conversationInfo ??=
    await OpenIM.iMManager.conversationManager.getOneConversation(
      sourceID: userID == null ? groupID! : userID,
      sessionType: userID == null ? 2 : 1,
    );

    print("明明 startChat conversationInfo ${json.encode(conversationInfo)}");

    // 保存旧草稿
    updateDartText(
      conversationID: conversationInfo.conversationID,
      uid: userID,
      gid: groupID,
      text: conversationInfo.draftText ?? '',
    );

    // 打开聊天窗口，关闭返回草稿
    /*var newDraftText = */
    await AppNavigator.startChat(
      type: type,
      uid: userID,
      gid: groupID,
      name: nickname,
      icon: faceURL,
      draftText: conversationInfo.draftText,
      isValidChat:
      conversationInfo.conversationType == ConversationType.single ||
          conversationInfo.conversationType == ConversationType.group &&
              !conversationInfo.isNotInGroup!,
      conversationInfo: conversationInfo,
      searchMessage: searchMessage,
    );

    // 读取草稿
    var newDraftText = tempDraftText[conversationInfo.conversationID];

    int? count;
    var l =
    list.where((e) => e.conversationID == conversationInfo!.conversationID);
    if (l.isNotEmpty) {
      count = l.first.unreadCount;
    }
    // count ??= unreadCount ?? info!.unreadCount!;

    // 标记已读
    _markMessageHasRead(
      conversationType: conversationInfo.conversationType!,
      conversationID: conversationInfo.conversationID,
      uid: userID,
      gid: groupID,
      unreadCount: count,
    );

    // 记录草稿
    _setupDraftText(
      conversationID: conversationInfo.conversationID,
      oldDraftText: conversationInfo.draftText ?? '',
      newDraftText: newDraftText!,
    );
    // 回到会话列表
    // homeLogic.switchTab(0);
  }

  /// 草稿
  /// 聊天页调用，不在通过onWillPop事件返回，因为该事件会拦截ios的右滑返回上一页。
  void updateDartText({
    String? conversationID,
    String? uid,
    String? gid,
    required String text,
  }) {
    print(
        '----conversationID:$conversationID uid:$uid   gid:$gid   text:$text');
    if (null == conversationID || conversationID.isEmpty) {
      if (null != uid && uid.isNotEmpty) {
        conversationID = 'single_$uid';
      } else if (null != gid && gid.isNotEmpty) {
        conversationID = 'group_$gid';
      }
    }
    if (null != conversationID) tempDraftText[conversationID] = text;
  }

  /// 清空未读消息数
  void _markMessageHasRead({
    required int conversationType,
    String? conversationID,
    String? uid,
    String? gid,
    int? unreadCount,
  }) {
    if (unreadCount != null && unreadCount > 0) {
      print('-------_markMessageHasRead: $conversationID---$uid---$gid');
      if (conversationType == ConversationType.single) {
        OpenIM.iMManager.messageManager.markC2CMessageAsRead(
          userID: uid!,
          messageIDList: [],
        );
      } else if (conversationType == ConversationType.group) {
        OpenIM.iMManager.conversationManager.markGroupMessageHasRead(
          groupID: gid!,
        );
      } else if (conversationType == ConversationType.notification) {
        OpenIM.iMManager.messageManager.markMessageAsReadByConID(
          conversationID: conversationID!,
          messageIDList: [],
        );
      }
    }
  }

  /// 设置草稿
  void _setupDraftText({
    required String conversationID,
    required String oldDraftText,
    required String newDraftText,
  }) {
    if (oldDraftText.isEmpty && newDraftText.isEmpty) {
      return;
    }

    /// 保存草稿
    print('draftText:$newDraftText');
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: conversationID,
      draftText: newDraftText,
    );
  }

  /// 自定义会话列表排序规则
  void _sortConversationList() =>
      OpenIM.iMManager.conversationManager.simpleSort(list);

  void onRefresh() async {
    var list;
    try {
      list = await _request(0);
      busBkrs.emit("all_conversation_data",list);
      this.list..assignAll(list);
      if (this.list.length>0) {
        toChatBigScreen(0);
      }
      if (null == list || list.isEmpty || list.length < _pageSize) {
        refreshController.loadNoData();
      }
    } finally {
      refreshController.refreshCompleted();
    }
  }

  void onLoading() async {
    var list;
    try {
      list = await _request(this.list.length);
      this.list..addAll(list);
    } finally {
      if (null == list || list.isEmpty || list.length < _pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }

  _request(int offset) =>
      OpenIM.iMManager.conversationManager.getAllConversationList(
          operationID: DateTime.now().millisecondsSinceEpoch.toString()
      );
  // OpenIM.iMManager.conversationManager.getConversationListSplit(
  //   offset: offset,
  //   count: _pageSize,
  // );

  bool isValidConversation(index) {
    var info = list.elementAt(index);
    return info.conversationType == ConversationType.single ||
        info.conversationType == ConversationType.group && !info.isNotInGroup!;
  }

  void globalSearch() {
    AppNavigator.startGlobalSearch();
  }

  //一键已读
  void oneKeyRead() {
    var unReadList = list.where((item){
      if (item.unreadCount == null) {
        return false;
      }
      if (item.unreadCount!>0) {
        return true;
      }
      return false;
    }).toList();

    for (var value in unReadList) {
      _markMessageHasRead(conversationType: value.conversationType!,conversationID: value.conversationID,
          uid: value.userID,gid: value.groupID,unreadCount: value.unreadCount);
    }
    if (unReadList.length == 0) {
      IMWidget.showToast("暂无未读消息");
    }else{
      Future.delayed(Duration(seconds: 1),(){
        IMWidget.showToast("操作完成");
      });
    }
  }
}
