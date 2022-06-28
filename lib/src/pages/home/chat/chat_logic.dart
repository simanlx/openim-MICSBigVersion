import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_live/flutter_openim_live.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/core/controller/cache_controller.dart';
import 'package:mics_big_version/src/core/controller/im_controller.dart';
import 'package:mics_big_version/src/models/contacts_info.dart';
import 'package:mics_big_version/src/models/zskjs/PatientDetailRes.dart';
import 'package:mics_big_version/src/models/zskjs/YlbwListBean.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_member_manager/member_list/member_list_logic.dart';
import 'package:mics_big_version/src/pages/home/conversation/conversation_logic.dart';
import 'package:mics_big_version/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/routes/app_navigator.dart';
import 'package:mics_big_version/src/routes/app_pages.dart';
import 'package:mics_big_version/src/sdk_extension/message_manager.dart';
import 'package:mics_big_version/src/utils/VoiceTimeUtil.dart';
import 'package:mics_big_version/src/utils/data_persistence.dart';
import 'package:mics_big_version/src/utils/im_util.dart';
import 'package:mics_big_version/src/widgets/bottom_sheet_view.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:uri_to_file/uri_to_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ChatLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final conversationLogic = Get.find<ConversationLogic>();
  final cacheLogic = Get.find<CacheController>();
  final inputCtrl = TextEditingController();
  final focusNode = FocusNode();
  final scrollController = ScrollController();

  final refreshController = RefreshController();

  /// Click on the message to process voice playback, video playback, picture preview, etc.
  final clickSubject = rx.PublishSubject<int>();

  ///
  final forceCloseToolbox = rx.PublishSubject<bool>();

  /// The status of message sending,
  /// there are two kinds of success or failure, true success, false failure
  final msgSendStatusSubject = rx.PublishSubject<MsgStreamEv<bool>>();

  /// The progress of sending messages, such as the progress of uploading pictures, videos, and files
  final msgSendProgressSubject = rx.PublishSubject<MsgStreamEv<int>>();

  /// Download progress of pictures, videos, and files
  // final downloadProgressSubject = rx.PublishSubject<MsgStreamEv<double>>();

  bool get isSingleChat => null != uid && uid!.trim().isNotEmpty;

  bool get isGroupChat => null != gid && gid!.trim().isNotEmpty;

  String? uid;
  String? gid;
  var name = ''.obs;
  var icon = ''.obs;
  var messageList = <Message>[].obs;
  var lastTime;
  Timer? typingTimer;
  var typing = false.obs;
  var intervalSendTypingMsg = IntervalDo();
  Message? quoteMsg;
  var quoteContent = "".obs;
  var multiSelMode = false.obs;
  var multiSelList = <Message>[].obs;
  var _borderRadius = BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  );

  var atUserNameMappingMap = <String, String>{};
  var atUserInfoMappingMap = <String, UserInfo>{};
  var curMsgAtUser = <String>[];

  var _isFirstLoad = true;
  var _lastCursorIndex = -1;
  var onlineStatus = false.obs;
  var onlineStatusDesc = ''.obs;
  // Timer? onlineStatusTimer;

  var favoriteList = <String>[].obs;

  var scaleFactor = 1.0.obs;
  var background = "".obs;

  ///  更新过自己的资料的成员
  var memberUpdateInfoMap = <String, GroupMembersInfo>{};

  /// 每条消息应该阅读的人列表
  var groupMessageReadMembers = <String, List<String>>{};

  /// 开启群禁言
  var isGroupMuted = false.obs;

  /// 单人被禁言时长
  var muteEndTime = 0.obs;
  GroupInfo? groupInfo;
  GroupMembersInfo? groupMembersInfo;
  var isValidChat = true;
  var memberCount = 0.obs;

  // var memberCount = 0.obs;

  var privateMessageList = <Message>[];

  var isInBlacklist = false.obs;

  final _audioPlayer = AudioPlayer();
  var _currentPlayClientMsgID = "".obs;

  var _isShowPopMenu = false;
  final _cacheMessageList = <Message>[];

  var chatListViewKey = UniqueKey();

  var chatVoiceRecordLayoutKey = UniqueKey();

  var chatInputBoxViewKey = UniqueKey();

  bool isCurrentChat(Message message) {
    var senderId = message.sendID;
    var receiverId = message.recvID;
    var groupId = message.groupID;
    var sessionType = message.sessionType;
    var isCurSingleChat = sessionType == 1 &&
        isSingleChat &&
        (senderId == uid ||
            // 其他端当前登录用户向uid发送的消息
            senderId == OpenIM.iMManager.uid && receiverId == uid);
    var isCurGroupChat = sessionType == 2 && isGroupChat && gid == groupId;
    return isCurSingleChat || isCurGroupChat;
  }

  void scrollBottom() {
    // 重置listview替代滚动效果
    // if (autoCtrl.offset != 0) {
    //   listViewKey.value = _uuid.v4();
    // }
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(0);
    });
  }

  // Future scrollToBottom() async {
  //   WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
  //     while (scrollController.position.pixels !=
  //         scrollController.position.maxScrollExtent) {
  //       scrollController.jumpTo(scrollController.position.maxScrollExtent);
  //       await SchedulerBinding.instance!.endOfFrame;
  //     }
  //   });
  // }

  @override
  void onReady() {
    print("================chatLogic onReady ==================");
    _checkInBlacklist();
    _getMyMemberInfo();
    queryGroupMuteStatus();
    queryMuteEndTime();
    getAtMappingMap();
    readDraftText();
    queryUserOnlineStatus();
    super.onReady();
  }
  // 'uid': uid,
  // 'gid': gid,
  // 'name': name,
  // 'icon': icon,
  // 'draftText': draftText,
  // 'isValidChat': isValidChat,
  // 'conversationInfo': conversationInfo,
  // 'searchMessage': searchMessage,
  ChatLogic(
  {
    this.uid,
    this.gid,
    String? name,
    String? icon,
    this.draftText,
    this.isValidChat = true,
}
      ){
    this.name.value = name??"";
    if (null != icon) this.icon.value = icon;
    print("================chatLogic 构造 ==================");
  }

  @override
  void onInit() {
    print("================chatLogic onInit ==================");
    // var arguments = Get.arguments;
    // uid = arguments['uid'];
    // gid = arguments['gid'];
    // name.value = arguments['name'];
    // isValidChat = arguments['isValidChat'];
    // if (null != arguments['icon']) icon.value = arguments['icon'];
    // cacheLogic.initFavoriteEmoji();
    _initChatConfig();
    _initPlayListener();
    // 获取在线状态
    // _startQueryOnlineStatus();
    // 新增消息监听
    imLogic.onRecvNewMessage = (Message message) {
      // 如果是当前窗口的消息
      if (isCurrentChat(message)) {
        // 对方正在输入消息
        if (message.contentType == MessageType.typing) {
          if (message.content == 'yes') {
            // 对方正在输入
            if (null == typingTimer) {
              typing.value = true;
              typingTimer = Timer.periodic(Duration(seconds: 2), (timer) {
                // 两秒后取消定时器
                typing.value = false;
                typingTimer?.cancel();
                typingTimer = null;
              });
            }
          } else {
            // 对方停止输入
            typing.value = false;
            typingTimer?.cancel();
            typingTimer = null;
          }
        } else {
          if (!messageList.contains(message)) {
            if (_isShowPopMenu) {
              _cacheMessageList.add(message);
            } else {
              messageList.add(message);
            }

            // ios 退到后台再次唤醒消息乱序
            // messageList.sort((a, b) {
            //   if (a.sendTime! > b.sendTime!) {
            //     return 1;
            //   } else if (a.sendTime! > b.sendTime!) {
            //     return -1;
            //   } else {
            //     return 0;
            //   }
            // });
          }
        }
      }
    };
    // 已被撤回消息监听
    imLogic.onRecvMessageRevoked = (String msgId) {
      messageList.removeWhere((e) => e.clientMsgID == msgId);
    };
    // 消息已读回执监听
    imLogic.onRecvC2CReadReceipt = (List<ReadReceiptInfo> list) {
      try {
        // var info = list.firstWhere((read) => read.uid == uid);
        list.forEach((readInfo) {
          if (readInfo.userID == uid) {
            messageList.forEach((e) {
              if (readInfo.msgIDList?.contains(e.clientMsgID) == true) {
                e.isRead = true;
                e.hasReadTime = _timestamp;
                // e.hasReadTime = readInfo.readTime;
                // e.attachedInfoElem!.hasReadTime = readInfo.readTime;
              }
            });
            messageList.refresh();
          }
        });
      } catch (e) {}
    };
    // 消息已读回执监听
    imLogic.onRecvGroupReadReceipt = (List<ReadReceiptInfo> list) {
      try {
        list.forEach((readInfo) {
          if (readInfo.groupID == gid) {
            messageList.forEach((e) {
              var uidList =
                  e.attachedInfoElem?.groupHasReadInfo?.hasReadUserIDList;
              if (null != uidList &&
                  !uidList.contains(readInfo.userID!) &&
                  (readInfo.msgIDList?.contains(e.clientMsgID) == true)) {
                uidList.add(readInfo.userID!);
              }
            });
          }
        });
        messageList.refresh();
      } catch (e) {}
    };
    // 消息发送进度
    imLogic.onMsgSendProgress = (String msgId, int progress) {
      msgSendProgressSubject.addSafely(
        MsgStreamEv<int>(msgId: msgId, value: progress),
      );
    };

    // 有新成员进入
    imLogic.memberAddedSubject.stream.listen((info) {
      var groupId = info.groupID;
      if (groupId == gid) {
        _putMemberInfo([info]);
      }
    });

    // 成员信息改变
    imLogic.memberInfoChangedSubject.listen((info) {
      var groupId = info.groupID;
      if (groupId == gid) {
        if (info.userID == OpenIM.iMManager.uid) {
          muteEndTime.value = info.muteEndTime ?? 0;
        }
        _putMemberInfo([info]);
      }
    });

    // 自定义消息点击事件
    clickSubject.listen((index) {
      print('index:$index');
      parseClickEvent(indexOfMessage(index, calculate: false));
    });

    // 输入框监听
    inputCtrl.addListener(() {
      intervalSendTypingMsg.run(
        fuc: () => sendTypingMsg(focus: true),
        milliseconds: 2000,
      );
      clearCurAtMap();
      _updateDartText(createDraftText());
    });

    // 输入框聚焦
    focusNode.addListener(() {
      _lastCursorIndex = inputCtrl.selection.start;
      focusNodeChanged(focusNode.hasFocus);
    });

    // 群信息变化
    imLogic.groupInfoUpdatedSubject.listen((value) {
      if (gid == value.groupID) {
        name.value = value.groupName ?? '';
        icon.value = value.faceURL ?? '';
        isGroupMuted.value =
            value.status == 3 && groupInfo?.ownerUserID != OpenIM.iMManager.uid;
      }
    });

    // 好友信息变化
    imLogic.friendInfoChangedSubject.listen((value) {
      if (uid == value.userID) {
        name.value = value.nickname!;
        icon.value = value.faceURL ?? '';
      }
    });

    // 通话消息处理
    imLogic.signalingMessageSubject.listen((value) {
      if (value.sessionType == 1) {
        if (value.userID == uid) {
          messageList.add(value.message);
          scrollBottom();
        }
      } else if (value.sessionType == 2) {
        if (value.groupID == gid) {
          messageList.add(value.message);
          scrollBottom();
        }
      }
    });

    // imLogic.conversationChangedSubject.listen((newList) {
    //   for (var newValue in newList) {
    //     if (newValue.conversationID == info?.conversationID) {
    //       burnAfterReading.value = newValue.isPrivateChat!;
    //       break;
    //     }
    //   }
    // });
    super.onInit();
  }

  void chatSetup() {
    if (null != uid && uid!.isNotEmpty) {
      AppNavigator.startChatSetup(
        uid: uid!,
        name: name.value,
        icon: icon.value,
      );
    } else if (null != gid && gid!.isNotEmpty) {
      // ok = 0 blocked = 1 Dismissed = 2 Muted  = 3
      AppNavigator.startGroupSetup(
        gid: gid!,
        name: name.value,
        icon: icon.value,
      );
    }
  }

  void clearCurAtMap() {
    curMsgAtUser.removeWhere((uid) => !inputCtrl.text.contains('@$uid '));
  }

  // 用户id/用户名映射表
  // 获取组成员，并保存id跟name
  void getAtMappingMap() async {
    // if (isGroupChat) {
    //   var list = await OpenIM.iMManager.groupManager.getGroupMemberList(
    //     groupId: gid!,
    //   );
    //
    //   _putMemberInfo(list);
    // }
  }

  /// 记录群成员信息
  void _putMemberInfo(List<GroupMembersInfo>? list) {
    list?.forEach((member) {
      _setAtMapping(
        userID: member.userID!,
        nickname: member.nickname!,
        faceURL: member.faceURL,
      );
      memberUpdateInfoMap[member.userID!] = member;
    });
    // 更新群成员信息
    messageList.refresh();
    atUserNameMappingMap[OpenIM.iMManager.uid] = StrRes.you;
    atUserInfoMappingMap[OpenIM.iMManager.uid] = OpenIM.iMManager.uInfo;

    DataPersistence.putAtUserMap(gid!, atUserNameMappingMap);
  }

  /// 获取历史聊天记录
  Future<bool> getHistoryMsgList() async {
    var list = await OpenIM.iMManager.messageManager.getHistoryMessageList(
      userID: uid,
      groupID: gid,
      count: 40,
      startMsg: _isFirstLoad ? null : messageList.first,
    );
    if (_isFirstLoad) {
      _isFirstLoad = false;
      messageList..assignAll(list);
      scrollBottom();
    } else {
      messageList.insertAll(0, list);
    }
    return list.length == 40;
  }

  /// 发送文字内容，包含普通内容，引用回复内容，@内容
  void sendTextMsg() async {
    var content = inputCtrl.text;
    if (content.isEmpty) return;
    var message;
    if (curMsgAtUser.isNotEmpty) {
      // 发送 @ 消息
      message = await OpenIM.iMManager.messageManager.createTextAtMessage(
        text: content,
        atUserIDList: curMsgAtUser,
        atUserInfoList: curMsgAtUser
            .map((e) => AtUserInfo(
                  atUserID: e,
                  groupNickname: atUserNameMappingMap[e],
                ))
            .toList(),
        quoteMessage: quoteMsg,
      );
    } else if (quoteMsg != null) {
      // 发送引用消息
      message = await OpenIM.iMManager.messageManager.createQuoteMessage(
        text: content,
        quoteMsg: quoteMsg!,
      );
    } else {
      // 发送普通消息
      message = await OpenIM.iMManager.messageManager.createTextMessage(
        text: content,
      );
    }
    _sendMessage(message);
  }

  /// 发送图片
  void sendPicture({required String path}) async {
    var message =
        await OpenIM.iMManager.messageManager.createImageMessageFromFullPath(
      imagePath: path,
    );
    _sendMessage(message);
  }

  /// 发送语音
  void sendVoice({required int duration, required String path}) async {
    var message =
        await OpenIM.iMManager.messageManager.createSoundMessageFromFullPath(
      soundPath: path,
      duration: duration,
    );
    _sendMessage(message);
  }

  ///  发送视频
  void sendVideo({
    required String videoPath,
    required String mimeType,
    required int duration,
    required String thumbnailPath,
  }) async {
    var message =
        await OpenIM.iMManager.messageManager.createVideoMessageFromFullPath(
      videoPath: videoPath,
      videoType: mimeType,
      duration: duration,
      snapshotPath: thumbnailPath,
    );
    _sendMessage(message);
  }

  /// 发送文件
  void sendFile({required String filePath, required String fileName}) async {
    var message =
        await OpenIM.iMManager.messageManager.createFileMessageFromFullPath(
      filePath: filePath,
      fileName: fileName,
    );
    _sendMessage(message);
  }

  /// 发送位置
  void sendLocation({
    required dynamic location,
  }) async {
    var message = await OpenIM.iMManager.messageManager.createLocationMessage(
      latitude: location['latitude'],
      longitude: location['longitude'],
      description: location['description'],
    );
    _sendMessage(message);
  }

  /// 转发
  void sendForwardMsg(
    Message originalMessage, {
    String? userId,
    String? groupId,
  }) async {
    var message = await OpenIM.iMManager.messageManager.createForwardMessage(
      message: originalMessage,
    );
    _sendMessage(message, userId: userId, groupId: groupId);
  }

  /// 合并转发
  void sendMergeMsg({
    String? userId,
    String? groupId,
  }) async {
    var summaryList = <String>[];
    var title;
    for (var msg in multiSelList) {
      summaryList.add(
          '${msg.senderNickname}：${IMUtil.parseMsg(msg, replaceIdToNickname: true)}');
      if (summaryList.length >= 2) break;
    }
    if (isGroupChat) {
      title = "群聊${StrRes.chatRecord}";
    } else {
      var partner1 = OpenIM.iMManager.uInfo.getShowName();
      var partner2 = name.value;
      title = "$partner1和$partner2${StrRes.chatRecord}";
    }
    var message = await OpenIM.iMManager.messageManager.createMergerMessage(
      messageList: multiSelList,
      title: title,
      summaryList: summaryList,
    );
    _sendMessage(message, userId: userId, groupId: groupId);
  }

  /// 提示对方正在输入
  void sendTypingMsg({bool focus = false}) async {
    if (isSingleChat) {
      OpenIM.iMManager.messageManager.typingStatusUpdate(
        userID: uid!,
        msgTip: focus ? 'yes' : 'no',
      );
    }
  }

  /// 发送名片
  void sendCarte({required String uid, String? name, String? icon}) async {
    var message = await OpenIM.iMManager.messageManager.createCardMessage(
      data: {"userID": uid, 'nickname': name, 'faceURL': icon},
    );
    _sendMessage(message);
  }

  /// 发送自定义消息
  void sendCustomMsg({
    required String data,
    required String extension,
    required String description,
  }) async {
    var message = await OpenIM.iMManager.messageManager.createCustomMessage(
      data: data,
      extension: extension,
      description: description,
    );
    _sendMessage(message);
  }

  void _sendMessage(
    Message message, {
    String? userId,
    String? groupId,
    bool addToUI = true,
  }) {
    log('send : ${json.encode(message)}');
    // null == userId && null == groupId || userId == uid --> 当前页面消息
    if (null == userId && null == groupId || userId == uid) {
      if (addToUI) {
        // 失败重复不需要添加到ui
        messageList.add(message);
        scrollBottom();
      }
    }
    print('uid:$uid  userId:$userId  gid:$gid    groupId:$groupId');
    _reset(message);
    OpenIM.iMManager.messageManager
        .sendMessage(
          message: message,
          userID: userId ?? uid,
          groupID: groupId ?? gid,
          offlinePushInfo: OfflinePushInfo(
            title: "你收到了一条消息",
            desc: "",
            iOSBadgeCount: true,
            iOSPushSound: '+1',
          ),
        )
        .then((value) => _sendSucceeded(message, value))
        .catchError((e) => _senFailed(message, e))
        .whenComplete(() => _completed());
  }

  ///  消息发送成功
  void _sendSucceeded(Message oldMsg, Message newMsg) {
    print('message send success----');
    // message.status = MessageStatus.succeeded;
    oldMsg.update(newMsg);
    msgSendStatusSubject.addSafely(MsgStreamEv<bool>(
      msgId: oldMsg.clientMsgID!,
      value: true,
    ));
  }

  ///  消息发送失败
  void _senFailed(Message message, e) {
    print('message send failed e :$e');
    message.status = MessageStatus.failed;
    msgSendStatusSubject.addSafely(MsgStreamEv<bool>(
      msgId: message.clientMsgID!,
      value: false,
    ));
  }

  void _reset(Message message) {
    if (message.contentType == MessageType.text ||
        message.contentType == MessageType.at_text ||
        message.contentType == MessageType.quote) {
      inputCtrl.clear();
      setQuoteMsg(null);
    }
    closeMultiSelMode();
  }

  /// todo
  void _completed() {
    messageList.refresh();
    // setQuoteMsg(-1);
    // closeMultiSelMode();
    // inputCtrl.clear();
  }

  /// 设置被回复的消息体
  void setQuoteMsg(Message? message) {
    if (message == null) {
      quoteMsg = null;
      quoteContent.value = '';
    } else {
      quoteMsg = message;
      var name = quoteMsg!.senderNickname;
      quoteContent.value = "$name：${IMUtil.parseMsg(quoteMsg!)}";
      focusNode.requestFocus();
    }
  }

  /// 删除消息
  void deleteMsg(Message message) async {
    _deleteMessage(message);
  }

  /// 批量删除
  void _deleteMultiMsg() {
    multiSelList.forEach((e) {
      _deleteMessage(e);
    });
    closeMultiSelMode();
  }

  _deleteMessage(Message message) async {
    try {
      await OpenIM.iMManager.messageManager
          .deleteMessageFromLocalAndSvr(
            message: message,
          )
          .then((value) => privateMessageList.remove(message))
          .then((value) => messageList.remove(message));
    } catch (e) {
      await OpenIM.iMManager.messageManager
          .deleteMessageFromLocalStorage(
            message: message,
          )
          .then((value) => privateMessageList.remove(message))
          .then((value) => messageList.remove(message));
    }
  }

  /// 撤回消息
  void revokeMsg(Message message) async {
    await OpenIM.iMManager.messageManager.revokeMessage(
      message: message,
    );
    message.contentType = MessageType.revoke;
    messageList.refresh();
  }

  /// 转发
  void forward(Message message) async {
    // IMWidget.showToast('调试中，敬请期待!');
    var result = await AppNavigator.startSelectContacts(
      action: SelAction.FORWARD,
    );
    if (null != result) {
      sendForwardMsg(
        message,
        userId: result['userID'],
        groupId: result['groupID'],
      );
    }
  }

  /// 大于1000为通知类消息
  void markMessageAsRead(Message message, bool visible) async {
    print('------------markMessageAsRead---------');
    if (visible && message.contentType! < 1000) {
      var data = IMUtil.parseCustomMessage(message);
      if (null != data && data['viewType'] == CustomMessageType.call) {
        return;
      }
      if (isSingleChat) {
        _markC2CMessageAsRead(message, visible);
      } else {
        _markGroupMessageAsRead(message, visible);
      }
    }
  }

  /// 标记消息为已读
  _markC2CMessageAsRead(Message message, bool visible) async {
    if (!message.isRead! && message.sendID != OpenIM.iMManager.uid) {
      print('mark as read：${message.clientMsgID!} ${message.isRead}');
      // 多端同步问题
      try {
        await OpenIM.iMManager.messageManager.markC2CMessageAsRead(
          userID: uid!,
          messageIDList: [message.clientMsgID!],
        );
      } catch (_) {}
      message.isRead = true;
      message.hasReadTime = _timestamp;
      messageList.refresh();
      // message.attachedInfoElem!.hasReadTime = _timestamp;
    }
  }

  /// 标记消息为已读
  _markGroupMessageAsRead(Message message, bool visible) async {
    if (!message.isRead! && message.sendID != OpenIM.iMManager.uid) {
      print('mark as read：${message.clientMsgID!} ${message.isRead}');
      // 多端同步问题
      try {
        await OpenIM.iMManager.messageManager.markGroupMessageAsRead(
          groupID: gid!,
          messageIDList: [message.clientMsgID!],
        );
      } catch (_) {}
      message.isRead = true;
      message.hasReadTime = _timestamp;
      messageList.refresh();
      // message.attachedInfoElem!.hasReadTime = _timestamp;
    }
  }

  /// 合并转发
  void mergeForward() {
    // IMWidget.showToast('调试中，敬请期待!');
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrRes.mergeForward,
            borderRadius: _borderRadius,
            onTap: () async {
              var result = await AppNavigator.startSelectContacts(
                action: SelAction.FORWARD,
              );
              if (null != result) {
                sendMergeMsg(
                  userId: result['userID'],
                  groupId: result['groupID'],
                );
              }
            },
          ),
        ],
      ),
      barrierColor: Colors.transparent,
    );
  }

  /// 多选删除
  void mergeDelete() {
    Get.bottomSheet(
      BottomSheetView(items: [
        SheetItem(
          label: StrRes.delete,
          borderRadius: _borderRadius,
          onTap: _deleteMultiMsg,
        ),
      ]),
      barrierColor: Colors.transparent,
    );
  }

  void multiSelMsg(Message message, bool checked) {
    if (checked) {
      // 合并最多五条限制
      if (multiSelList.length >= 20) return;
      multiSelList.add(message);
      multiSelList.sort((a, b) {
        if (a.createTime! > b.createTime!) {
          return 1;
        } else if (a.createTime! < b.createTime!) {
          return -1;
        } else {
          return 0;
        }
      });
    } else {
      multiSelList.remove(message);
    }
  }

  void openMultiSelMode(Message message) {
    multiSelMode.value = true;
    multiSelMsg(message, true);
  }

  void closeMultiSelMode() {
    multiSelMode.value = false;
    multiSelList.clear();
  }

  /// 触摸其他地方强制关闭工具箱
  void closeToolbox() {
    forceCloseToolbox.addSafely(true);
  }

  /// 打开地图
  void onTapLocation() async {
    var location = await Get.to(ChatWebViewMap());
    print(location);
    if (null != location) {
      sendLocation(location: location);
    }
  }

  /// 打开相册
  void onTapAlbum() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      Get.context!,
    );
    if (null != assets) {
      for (var asset in assets) {
        _handleAssets(asset);
      }
    }
  }

  /// 打开相机
  void onTapCamera() async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      Get.context!,
      pickerConfig: CameraPickerConfig(
        enableAudio: true,
        enableRecording: true,
      ),
    );
    _handleAssets(entity);
  }

  /// 打开系统文件浏览器
  void onTapFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      // type: FileType.custom,
      // allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      for (var file in result.files) {
        // String? mimeType = mime(file.name);
        // if (mimeType != null) {
        //   if (mimeType.contains('image/')) {
        //     sendPicture(path: file.path!);
        //     return;
        //   } else if (mimeType.contains('video/')) {
        //     try {
        //       final videoPath = file.path!;
        //       var info = await _videoInfo.getVideoInfo(videoPath);
        //       final int w = info!.width!;
        //       final int h = info.height!;
        //       final int duration = info.duration! ~/ 1000;
        //       var path = (await getApplicationDocumentsDirectory()).path;
        //       final target = '$path/temp.png';
        //       if (!(await File(target).exists())) {
        //         File(target).create(recursive: true);
        //       }
        //       final fileName = await VideoThumbnail.thumbnailFile(
        //         video: videoPath,
        //         thumbnailPath: target,
        //         quality: 100,
        //       );
        //       sendVideo(
        //         videoPath: videoPath,
        //         mimeType: mimeType,
        //         duration: duration,
        //         thumbnailPath: target,
        //       );
        //       return;
        //     } catch (e) {}
        //   }
        // }
        sendFile(filePath: file.path!, fileName: file.name);
      }
    } else {
      // User canceled the picker
    }
  }

  /// 名片
  void onTapCarte() async {
    var result = await AppNavigator.startSelectContacts(
      action: SelAction.CARTE,
    );
    if (null != result) {
      sendCarte(
        uid: result['userID'],
        name: result['nickname'],
        icon: result['faceURL'],
      );
    }
  }

  void _handleAssets(AssetEntity? asset) async {
    if (null != asset) {
      print('--------assets type-----${asset.type}');
      var path = (await asset.file)!.path;
      print('--------assets path-----$path');
      switch (asset.type) {
        case AssetType.image:
          sendPicture(path: path);
          break;
        case AssetType.video:
          var trulyW = asset.width;
          var trulyH = asset.height;
          var scaleW = 100.w;
          var scaleH = scaleW * trulyH / trulyW;
          var data = await asset.thumbnailDataWithSize(
            ThumbnailSize(scaleW.toInt(), scaleH.toInt()),
          );
          print('-----------video thumb build success----------------');
          final result = await ImageGallerySaver.saveImage(
            data!,
            isReturnImagePathOfIOS: true,
          );
          var thumbnailPath = result['filePath'];
          print('-----------gallery saver : ${json.encode(result)}---------');
          var filePrefix = 'file://';
          var uriPrefix = 'content://';
          if ('$thumbnailPath'.contains(filePrefix)) {
            thumbnailPath = thumbnailPath.substring(filePrefix.length);
          } else if ('$thumbnailPath'.contains(uriPrefix)) {
            // Uri uri = Uri.parse(thumbnailPath); // Parsing uri string to uri
            File file = await toFile(thumbnailPath);
            thumbnailPath = file.path;
          }
          sendVideo(
            videoPath: path,
            mimeType: asset.mimeType ?? CommonUtil.getMediaType(path) ?? '',
            duration: asset.duration,
            thumbnailPath: thumbnailPath,
          );
          // sendVoice(duration: asset.duration, path: path);
          break;
        default:
          break;
      }
    }
  }

  /// 处理消息点击事件
  void parseClickEvent(Message msg) async {
    if (msg.contentType == MessageType.custom) {
      var data = msg.customElem!.data;
      var map = json.decode(data!);
      var customType = map['customType'];
      if (CustomMessageType.call == customType && !isInBlacklist.value) {
        var type = map['data']['type'];
        imLogic.call(
          CallObj.single,
          type == "audio" ? CallType.audio : CallType.video,
          gid,
          [if (isSingleChat) uid!],
        );
      }
      return;
    }
    if (msg.contentType == MessageType.voice) {
      _playVoiceMessage(msg);
      return;
    }
    IMUtil.parseClickEvent(msg, messageList: messageList);
    // log("message:${json.encode(msg)}");
    // if (msg.contentType == MessageType.picture) {
    //   var list = messageList
    //       .where((p0) => p0.contentType == MessageType.picture)
    //       .toList();
    //   var index = list.indexOf(msg);
    //   if (index == -1) {
    //     IMUtil.openPicture([msg], index: 0, tag: msg.clientMsgID);
    //   } else {
    //     IMUtil.openPicture(list, index: index, tag: msg.clientMsgID);
    //   }
    // } else if (msg.contentType == MessageType.video) {
    //   IMUtil.openVideo(msg);
    // } else if (msg.contentType == MessageType.file) {
    //   IMUtil.openFile(msg);
    // } else if (msg.contentType == MessageType.card) {
    //   var info = ContactsInfo.fromJson(json.decode(msg.content!));
    //   AppNavigator.startFriendInfo(userInfo: info);
    // } else if (msg.contentType == MessageType.merger) {
    //   Get.to(
    //     () => PreviewMergeMsg(
    //       title: msg.mergeElem!.title!,
    //       messageList: msg.mergeElem!.multiMessage!,
    //     ),
    //     preventDuplicates: false,
    //   );
    // } else if (msg.contentType == MessageType.location) {
    //   var location = msg.locationElem;
    //   Map detail = json.decode(location!.description!);
    //   Get.to(() => MapView(
    //         latitude: location.latitude!,
    //         longitude: location.longitude!,
    //         addr1: detail['name'],
    //         addr2: detail['addr'],
    //       ));
    // }
  }

  /// 点击引用消息
  void onTapQuoteMsg(Message message) {
    if (message.contentType == MessageType.quote) {
      parseClickEvent(message.quoteElem!.quoteMessage!);
    } else if (message.contentType == MessageType.at_text) {
      parseClickEvent(message.atElem!.quoteMessage!);
    }
  }

  /// 群聊天长按头像为@用户
  void onLongPressLeftAvatar(Message message) {
    if (isGroupChat) {
      // 不查询群成员列表
      _setAtMapping(
        userID: message.sendID!,
        nickname: message.senderNickname!,
        faceURL: message.senderFaceUrl,
      );
      var uid = message.sendID!;
      // var uname = msg.senderNickName;
      if (curMsgAtUser.contains(uid)) return;
      curMsgAtUser.add(uid);
      // 在光标出插入内容
      // 先保存光标前和后内容
      var cursor = inputCtrl.selection.base.offset;
      if (!focusNode.hasFocus) {
        focusNode.requestFocus();
        cursor = _lastCursorIndex;
      }
      if (cursor < 0) cursor = 0;
      print('========cursor:$cursor   _lastCursorIndex:$_lastCursorIndex');
      // 光标前面的内容
      var start = inputCtrl.text.substring(0, cursor);
      print('===================start:$start');
      // 光标后面的内容
      var end = inputCtrl.text.substring(cursor);
      print('===================end:$end');
      var at = ' @$uid ';
      inputCtrl.text = '$start$at$end';
      inputCtrl.selection = TextSelection.collapsed(offset: '$start$at'.length);
      // inputCtrl.selection = TextSelection.fromPosition(TextPosition(
      //   offset: '$start$at'.length,
      // ));
      _lastCursorIndex = inputCtrl.selection.start;
      print('$curMsgAtUser');
    }
  }

  void onTapLeftAvatar(Message message) {
    var info = ContactsInfo.fromJson({
      'userID': message.sendID!,
      'nickname': message.senderNickname,
      'faceURL': message.senderFaceUrl,
    });
    viewUserInfo(info);
    // AppNavigator.startFriendInfo(
    //   userInfo: info,
    //   showMuteFunction: havePermissionMute,
    //   groupID: gid!,
    // );
  }

  void clickAtText(id) {
    if (null != atUserInfoMappingMap[id]) {
      viewUserInfo(atUserInfoMappingMap[id]!);
      // AppNavigator.startFriendInfo(
      //   userInfo: atUserInfoMappingMap[id]!,
      //   showMuteFunction: havePermissionMute,
      //   groupID: gid!,
      // );
    } else {
      viewUserInfo(UserInfo(userID: id));
    }
  }

  void viewUserInfo(UserInfo info) {
    AppNavigator.startFriendInfo(
      userInfo: info,
      showMuteFunction: havePermissionMute,
      groupID: gid,
    );
  }

  void clickLinkText(url, type) async {
    print('--------link  type:$type-------url: $url---');
    if (type == PatternType.AT) {
      clickAtText(url);
      return;
    }
    if (await canLaunch(url)) {
      await launch(url);
    }
    // await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  var draftText;

  /// 读取草稿
  void readDraftText() {
    // var draftText = Get.arguments['draftText'];
    print('readDraftText:$draftText');
    if (null != draftText && "" != draftText) {
      var map = json.decode(draftText!);
      String text = map['text'];
      // String? quoteMsgId = map['quoteMsgId'];
      Map<String, dynamic> atMap = map['at'];
      print('text:$text  atMap:$atMap');
      atMap.forEach((key, value) {
        if (!curMsgAtUser.contains(key)) curMsgAtUser.add(key);
        atUserNameMappingMap.putIfAbsent(key, () => value);
      });
      inputCtrl.text = text;
      inputCtrl.selection = TextSelection.fromPosition(TextPosition(
        offset: text.length,
      ));
      // if (null != quoteMsgId) {
      //   var index = messageList.indexOf(Message()..clientMsgID = quoteMsgId);
      //   print('quoteMsgId index:$index  length:${messageList.length}');
      //   setQuoteMsg(index);
      //   print('quoteMsgId index:$index  length:${messageList.length}');
      // }
      if (text.isNotEmpty) {
        focusNode.requestFocus();
      }
    }
  }

  /// 生成草稿draftText
  String createDraftText() {
    var atMap = <String, dynamic>{};
    curMsgAtUser.forEach((uid) {
      atMap[uid] = atUserNameMappingMap[uid];
    });
    if (inputCtrl.text.isEmpty) {
      return "";
    }
    return json.encode({
      'text': inputCtrl.text,
      'at': atMap,
      // 'quoteMsgId': quoteMsg?.clientMsgID,
    });
  }

  /// 退出界面前处理
  exit() async {
    if (multiSelMode.value) {
      closeMultiSelMode();
      return false;
    }
    Get.back(result: createDraftText());
    return true;
  }

  void _updateDartText(String text) {
    conversationLogic.updateDartText(
      text: text,
      uid: uid,
      gid: gid,
    );
  }

  void focusNodeChanged(bool hasFocus) {
    sendTypingMsg(focus: hasFocus);
    if (hasFocus) {
      print('focus:$hasFocus');
      scrollBottom();
    }
  }

  void copy(Message message) {
    IMUtil.copy(text: message.content!);
  }

  Message indexOfMessage(int index, {bool calculate = true}) =>
      IMUtil.calChatTimeInterval(
        messageList,
        calculate: calculate,
      ).reversed.elementAt(index);

  ValueKey itemKey(Message message) => ValueKey(message.clientMsgID!);

  @override
  void onClose() {
    // inputCtrl.dispose();
    // focusNode.dispose();
    print("方方  ChatBinding  绑定  onClose");
    _audioPlayer.dispose();
    clickSubject.close();
    forceCloseToolbox.close();
    msgSendStatusSubject.close();
    msgSendProgressSubject.close();
    // downloadProgressSubject.close();
    // onlineStatusTimer?.cancel();
    destroyMsg();
    super.onClose();
  }

  String? getShowTime(Message message) {
    if (message.ext == true) {
      return IMUtil.getChatTimeline(message.sendTime!);
    }
    return null;
  }

  void clearAllMessage() {
    messageList.clear();
  }

  void onStartVoiceInput() {
    // SpeechToTextUtil.instance.startListening((result) {
    //   inputCtrl.text = result.recognizedWords;
    // });
  }

  void onStopVoiceInput() {
    // SpeechToTextUtil.instance.stopListening();
  }

  /// 添加表情
  void onAddEmoji(String emoji) {
    var input = inputCtrl.text;
    if (_lastCursorIndex != -1 && input.isNotEmpty) {
      var part1 = input.substring(0, _lastCursorIndex);
      var part2 = input.substring(_lastCursorIndex);
      inputCtrl.text = '$part1$emoji$part2';
      _lastCursorIndex = _lastCursorIndex + emoji.length;
    } else {
      inputCtrl.text = '$input$emoji';
      _lastCursorIndex = emoji.length;
    }
    inputCtrl.selection = TextSelection.fromPosition(TextPosition(
      offset: _lastCursorIndex,
    ));
  }

  /// 删除表情
  void onDeleteEmoji() {
    final input = inputCtrl.text;
    final regexEmoji = emojiFaces.keys
        .toList()
        .join('|')
        .replaceAll('[', '\\[')
        .replaceAll(']', '\\]');
    final list = [regexAt, regexEmoji];
    final pattern = '(${list.toList().join('|')})';
    final atReg = RegExp(regexAt);
    final emojiReg = RegExp(regexEmoji);
    var reg = RegExp(pattern);
    var cursor = _lastCursorIndex;
    if (cursor == 0) return;
    Match? match;
    if (reg.hasMatch(input)) {
      for (var m in reg.allMatches(input)) {
        var matchText = m.group(0)!;
        var start = m.start;
        var end = start + matchText.length;
        if (end == cursor) {
          match = m;
          break;
        }
      }
    }
    var matchText = match?.group(0);
    if (matchText != null) {
      var start = match!.start;
      var end = start + matchText.length;
      if (atReg.hasMatch(matchText)) {
        String id = matchText.replaceFirst("@", "").trim();
        if (curMsgAtUser.remove(id)) {
          inputCtrl.text = input.replaceRange(start, end, '');
          cursor = start;
        } else {
          inputCtrl.text = input.replaceRange(cursor - 1, cursor, '');
          --cursor;
        }
      } else if (emojiReg.hasMatch(matchText)) {
        inputCtrl.text = input.replaceRange(start, end, "");
        cursor = start;
      } else {
        inputCtrl.text = input.replaceRange(cursor - 1, cursor, '');
        --cursor;
      }
    } else {
      inputCtrl.text = input.replaceRange(cursor - 1, cursor, '');
      --cursor;
    }
    _lastCursorIndex = cursor;
  }

  /// 用户在线状态
  // void _getOnlineStatus(List<String> uidList) {
  //   Apis.queryOnlineStatus(
  //     uidList: uidList,
  //     onlineStatusCallback: (map) {
  //       onlineStatus.value = map[uidList.first]!;
  //     },
  //     onlineStatusDescCallback: (map) {
  //       onlineStatusDesc.value = map[uidList.first]!;
  //     },
  //   );
  // }

  // void _startQueryOnlineStatus() {
  //   if (null != uid && uid!.isNotEmpty && onlineStatusTimer == null) {
  //     _getOnlineStatus([uid!]);
  //     onlineStatusTimer = Timer.periodic(Duration(seconds: 5), (timer) {
  //       _getOnlineStatus([uid!]);
  //     });
  //   }
  // }

  String getSubTile() => typing.value ? StrRes.typing : onlineStatusDesc.value;

  bool showOnlineStatus() => !typing.value && onlineStatusDesc.isNotEmpty;

  /// 语音视频通话信息不显示读状态
  bool enabledReadStatus(Message message) {
    try {
      // 通知类消息不显示
      if (message.contentType! > 1000) {
        return false;
      }
      switch (message.contentType) {
        case MessageType.custom:
          {
            var data = message.customElem!.data;
            var map = json.decode(data!);
            switch (map['customType']) {
              case CustomMessageType.call:
                return false;
            }
          }
      }
    } catch (e) {}
    return true;
  }

  bool isCallMessage(Message message) {
    switch (message.contentType) {
      case MessageType.custom:
        {
          var data = message.customElem!.data;
          var map = json.decode(data!);
          var customType = map['customType'];
          switch (customType) {
            case CustomMessageType.call:
              return true;
          }
        }
    }
    return false;
  }

  /// 处理输入框输入@字符
  String? openAtList() {
    if (gid != null && gid!.isNotEmpty) {
      var cursor = inputCtrl.selection.baseOffset;
      AppNavigator.startGroupMemberList(
        gid: gid!,
        action: OpAction.AT,
      )?.then((memberList) {
        //GroupMembersInfo
        if (memberList is List<GroupMembersInfo>) {
          var buffer = StringBuffer();
          memberList.forEach((e) {
            _setAtMapping(
              userID: e.userID!,
              nickname: e.nickname ?? '',
              faceURL: e.faceURL,
            );
            if (!curMsgAtUser.contains(e.userID)) {
              curMsgAtUser.add(e.userID!);
              buffer.write(' @${e.userID} ');
            }
          });
          // for (var uid in uidList) {
          //   if (curMsgAtUser.contains(uid)) continue;
          //   curMsgAtUser.add(uid);
          //   buffer.write(' @$uid ');
          // }
          if (cursor < 0) cursor = 0;
          // 光标前面的内容
          var start = inputCtrl.text.substring(0, cursor);
          // 光标后面的内容
          var end = inputCtrl.text.substring(cursor + 1);
          inputCtrl.text = '$start$buffer$end';
          inputCtrl.selection = TextSelection.fromPosition(TextPosition(
            offset: '$start$buffer'.length,
          ));
          _lastCursorIndex = inputCtrl.selection.start;
        } else {}
      });
      return "@";
    }
    return null;
  }

  void emojiManage() {
    AppNavigator.startEmojiManage();
  }

  void addEmoji(Message message) {
    if (message.contentType == MessageType.picture) {
      var url = message.pictureElem?.sourcePicture?.url;
      var width = message.pictureElem?.sourcePicture?.width;
      var height = message.pictureElem?.sourcePicture?.height;
      cacheLogic.addFavoriteFromUrl(url, width, height);
      IMWidget.showToast(StrRes.addSuccessfully);
    } else if (message.contentType == MessageType.custom_face) {
      var index = message.faceElem?.index;
      var data = message.faceElem?.data;
      if (-1 != index) {
      } else if (null != data) {
        var map = json.decode(data);
        var url = map['url'];
        var width = map['width'];
        var height = map['height'];
        cacheLogic.addFavoriteFromUrl(url, width, height);
        IMWidget.showToast(StrRes.addSuccessfully);
      }
    }
  }

  /// 发送自定表情
  void sendCustomEmoji(int index, String url) async {
    var emoji = cacheLogic.favoriteList.elementAt(index);
    var message = await OpenIM.iMManager.messageManager.createFaceMessage(
      data: json.encode({
        'url': emoji.url,
        'width': emoji.width,
        'height': emoji.height,
      }),
    );
    _sendMessage(message);
  }

  void _initChatConfig() async {
    scaleFactor.value = DataPersistence.getChatFontSizeFactor() ?? 1.0;
    var path = DataPersistence.getChatBackground() ?? '';
    if (path.isNotEmpty && (await File(path).exists())) {
      background.value = path;
    }
  }

  /// 修改聊天字体
  changeFontSize(double factor) async {
    await DataPersistence.putChatFontSizeFactor(factor);
    scaleFactor.value = factor;
    IMWidget.showToast(StrRes.setSuccessfully);
  }

  /// 修改聊天背景
  changeBackground(String path) async {
    await DataPersistence.putChatBackground(path);
    background.value = path;
    IMWidget.showToast(StrRes.setSuccessfully);
  }

  /// 清除聊天背景
  clearBackground() async {
    await DataPersistence.clearChatBackground();
    background.value = '';
    IMWidget.showToast(StrRes.setSuccessfully);
  }

  /// 拨视频或音频
  void call() {
    if (isGroupChat) {
      IMWidget.openIMGroupCallSheet(
        groupID: gid!,
        onTap: (index, list) {
          imLogic.call(
            CallObj.group,
            index == 0 ? CallType.audio : CallType.video,
            gid,
            list,
          );
        },
      );
    } else {
      IMWidget.openIMCallSheet(name.value, (index) {
        imLogic.call(
          CallObj.single,
          index == 0 ? CallType.audio : CallType.video,
          gid,
          [if (isSingleChat) uid!],
        );
      });
    }
  }

  /// 群消息已读预览
  void viewGroupMessageReadStatus(Message message) {
    AppNavigator.startGroupHaveRead(
      haveReadUserIDList:
          message.attachedInfoElem!.groupHasReadInfo!.hasReadUserIDList!,
      needReadUserIDList: groupMessageReadMembers[message.clientMsgID] ?? [],
      groupID: gid!,
    );
  }

  /// 失败重发
  void failedResend(Message message) {
    _sendMessage(message, addToUI: false);
  }

  /// 计算这条消息应该被阅读的人数
  // int getNeedReadCount(Message message) {
  //   if (isSingleChat) return 0;
  //   return groupMessageReadMembers[message.clientMsgID!]?.length ??
  //       _calNeedReadCount(message);
  // }

  /// 1，排除自己
  /// 2，获取比消息发送时间早的入群成员数
  // int _calNeedReadCount(Message message) {
  //   memberList.values.forEach((element) {
  //     if (element.userID != OpenIM.iMManager.uid) {
  //       if ((element.joinTime! * 1000) < message.sendTime!) {
  //         var list = groupMessageReadMembers[message.clientMsgID!] ?? [];
  //         if (!list.contains(element.userID)) {
  //           groupMessageReadMembers[message.clientMsgID!] = list
  //             ..add(element.userID!);
  //         }
  //       }
  //     }
  //   });
  //   return groupMessageReadMembers[message.clientMsgID!]?.length ?? 0;
  // }

  /// 是否是阅后即焚消息
  bool isPrivateChat(Message message) {
    return message.attachedInfoElem?.isPrivateChat ?? false;
  }

  int readTime(Message message) {
    var isPrivate = message.attachedInfoElem?.isPrivateChat ?? false;
    if (isPrivate) {
      privateMessageList.addIf(
        () => !privateMessageList.contains(message),
        message,
      );
      // var hasReadTime = message.attachedInfoElem!.hasReadTime ?? 0;
      var hasReadTime = message.hasReadTime ?? 0;
      if (hasReadTime > 0) {
        var end = hasReadTime + 30 * 1000;
        var diff = (end - _timestamp) ~/ 1000;
        return diff < 0 ? 0 : diff;
      }
    }
    return 0;
  }

  static int get _timestamp => DateTime.now().millisecondsSinceEpoch;

  /// 退出页面即把所有当前已展示的私聊消息删除
  void destroyMsg() {
    privateMessageList.forEach((message) {
      OpenIM.iMManager.messageManager.deleteMessageFromLocalAndSvr(
        message: message,
      );
    });
  }

  /// 获取个人禁言状态
  void queryMuteEndTime() async {
    if (isGroupChat) {
      var list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
        groupId: gid!,
        uidList: [OpenIM.iMManager.uid],
      );
      groupMembersInfo = list.firstOrNull;
      muteEndTime.value = groupMembersInfo?.muteEndTime ?? 0;
    }
  }

  /// 获取组禁言状态
  void queryGroupMuteStatus() async {
    if (isGroupChat) {
      var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
        gidList: [gid!],
      );
      groupInfo = list.firstOrNull;
      var count = groupInfo?.memberCount ?? 0;
      memberCount.value = count > 0 ? count - 1 : count;
      // 不包含群主本人
      isGroupMuted.value = groupInfo?.status == 3 &&
          groupInfo?.ownerUserID != OpenIM.iMManager.uid;
    }
  }

  /// 禁言权限
  /// 1普通成员, 2群主，3管理员
  bool get havePermissionMute =>
      isGroupChat &&
      (groupInfo?.ownerUserID ==
          OpenIM
              .iMManager.uid /*||
          groupMembersInfo?.roleLevel == 2*/
      );

  /// 通知类型消息
  bool isNotificationType(Message message) => message.contentType! >= 1000;

  Map<String, String> getAtMapping(Message message) {
    if (isGroupChat) {
      final map = <String, String>{};
      if (message.contentType == MessageType.at_text) {
        var list = message.atElem!.atUsersInfo;
        list?.forEach((e) {
          map[e.atUserID!] = e.groupNickname!;
          if (e.atUserID == OpenIM.iMManager.uid) {
            atUserNameMappingMap[e.atUserID!] = StrRes.you;
          } else {
            atUserNameMappingMap[e.atUserID!] = e.groupNickname!;
          }
          // atUserNameMappingMap.putIfAbsent(e.atUserID!, () => e.groupNickname!);
        });
      }
      return atUserNameMappingMap;
    }
    return {};
  }

  void queryUserOnlineStatus() {
    if (isSingleChat) {
      Apis.queryUserOnlineStatus(
        uidList: [uid!],
        onlineStatusCallback: (map) {
          onlineStatus.value = map[uid]!;
        },
        onlineStatusDescCallback: (map) {
          onlineStatusDesc.value = map[uid]!;
        },
      );
    }
  }

  /// 搜索定位消息位置
  void lockMessageLocation(Message message) {
    // var upList = list.sublist(0, 15);
    // var downList = list.sublist(15);
    // messageList.assignAll(downList);
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   scrollController.jumpTo(scrollController.position.maxScrollExtent - 50);
    //   messageList.insertAll(0, upList);
    // });
  }

  void _checkInBlacklist() async {
    if (uid != null) {
      var list = await OpenIM.iMManager.friendshipManager.getBlacklist();
      var user = list.firstWhereOrNull((e) => e.userID == uid);
      isInBlacklist.value = user != null;
    }
  }

  void _setAtMapping({
    required String userID,
    required String nickname,
    String? faceURL,
  }) {
    atUserNameMappingMap[userID] = nickname;
    atUserInfoMappingMap[userID] = UserInfo(
      userID: userID,
      nickname: nickname,
      faceURL: faceURL,
    );
    DataPersistence.putAtUserMap(gid!, atUserNameMappingMap);
  }

  /// 未超过24小时
  bool isExceed24H(Message message) {
    int milliseconds = message.sendTime!;
    return !DateUtil.isToday(milliseconds);
  }

  bool isPlaySound(Message message) {
    return _currentPlayClientMsgID.value == message.clientMsgID!;
  }

  void _initPlayListener() {
    _audioPlayer.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          _currentPlayClientMsgID.value = "";
          break;
      }
    });
  }

  /// 播放语音消息
  void _playVoiceMessage(Message message) async {
    var isClickSame = _currentPlayClientMsgID.value == message.clientMsgID;
    if (_audioPlayer.playerState.playing) {
      _currentPlayClientMsgID.value = "";
      _audioPlayer.stop();
    }
    if (!isClickSame) {
      bool isValid = await _initVoiceSource(message);
      if (isValid) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
        _currentPlayClientMsgID.value = message.clientMsgID!;
      }
    }
  }

  /// 语音消息资源处理
  Future<bool> _initVoiceSource(Message message) async {
    bool isReceived = message.sendID != OpenIM.iMManager.uid;
    String? path = message.soundElem?.soundPath;
    String? url = message.soundElem?.sourceUrl;
    bool isExistSource = false;
    if (isReceived) {
      if (null != url && url.trim().isNotEmpty) {
        isExistSource = true;
        _audioPlayer.setUrl(url);
      }
    } else {
      var _existFile = false;
      if (path != null && path.trim().isNotEmpty) {
        var file = File(path);
        _existFile = await file.exists();
      }
      if (_existFile) {
        isExistSource = true;
        _audioPlayer.setFilePath(path!);
      } else if (null != url && url.trim().isNotEmpty) {
        isExistSource = true;
        _audioPlayer.setUrl(url);
      }
    }
    return isExistSource;
  }

  /// 显示菜单屏蔽消息插入
  void onPopMenuShowChanged(show) {
    _isShowPopMenu = show;
    if (!show) {
      messageList.addAll(_cacheMessageList);
      _cacheMessageList.clear();
    }
  }

  /// 获取自己的群成员资料
  void _getMyMemberInfo() async {
    if (gid == null) return;
    var list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
      groupId: gid!,
      uidList: [OpenIM.iMManager.uid],
    );
    var info = list.firstOrNull;
    if (null != info) {
      memberUpdateInfoMap[OpenIM.iMManager.uid] = info;
    }
  }

  String? newestNickname(Message message) {
    if (isSingleChat) return null;
    return memberUpdateInfoMap[message.sendID]?.nickname;
  }

  //添加收藏
  void addLike(Message message,bool isSingleChat) {
    //文字
    var content;
    if (message.contentType == MessageType.text) {
      var title = "";
      if(message.content !=null){
        if (message.content!.length>=10) {
          title = message.content!.substring(0,10);
        }else{
          title = message.content!;
        }
      }
      content = {
        "title":"[${name.value}]:$title",
        "from":"[${name.value}]${isSingleChat?"的会话":"的群聊"}",
        "type":1,
        "data": {
          "txt":message.content??"",
          "message":message,
        },
      };
      Apis.addLike(message.sendID??"", message.senderNickname??"", message.senderFaceUrl??"", DateTime.now().millisecondsSinceEpoch.toString(), content).then((value){
        IMWidget.showToast("收藏成功");
      });
    }else if(message.contentType == MessageType.voice){
      var durationStr = VoiceTimeUtil.transferSec(message.soundElem?.duration??0);
      content = {
        "title":"[${name.value}]:语音消息${durationStr}",
        "from":"[${name.value}]${isSingleChat?"的会话":"的群聊"}",
        "type":2,
        "data": {
          "voice":message.soundElem?.sourceUrl,
          "voice_length": message.soundElem?.duration??0,
          "message":message,
        },
      };
      Apis.addLike(message.sendID??"", message.senderNickname??"", message.senderFaceUrl??"", DateTime.now().millisecondsSinceEpoch.toString(), content).then((value){
        IMWidget.showToast("收藏成功");
      });
    }else if(message.contentType == MessageType.file){

      content = {
        "title":"[${message.fileElem?.fileName??""}]",
        "from":"[${name.value}]${isSingleChat?"的会话":"的群聊"}",
        "type":3,
        "data": {
          "file_name":message.fileElem?.fileName??"",
          "file_path":message.fileElem?.filePath??"",
          "message":message,
        },
      };
      Apis.addLike(message.sendID??"", message.senderNickname??"", message.senderFaceUrl??"", DateTime.now().millisecondsSinceEpoch.toString(), content).then((value){
        IMWidget.showToast("收藏成功");
      });

    } else if(message.contentType == MessageType.picture){
      content = {
        "title":"[${name.value}]:图片消息",
        "from":"[${name.value}]${isSingleChat?"的会话":"的群聊"}",
        "type":4,
        "data": {
          "image_path":message.pictureElem?.sourcePicture?.url??"",
          "message":message,
        },
      };
      Apis.addLike(message.sendID??"", message.senderNickname??"", message.senderFaceUrl??"", DateTime.now().millisecondsSinceEpoch.toString(), content).then((value){
        IMWidget.showToast("收藏成功");
      });
    }else if(message.contentType == MessageType.video){
      content = {
        "title":"[${name.value}]:视频消息",
        "from":"[${name.value}]${isSingleChat?"的会话":"的群聊"}",
        "type":5,
        "data": {
          "video_path":message.videoElem?.videoUrl??"",
          "message":message
        },
      };
      Apis.addLike(message.sendID??"", message.senderNickname??"", message.senderFaceUrl??"", DateTime.now().millisecondsSinceEpoch.toString(), content).then((value){
        IMWidget.showToast("收藏成功");
      });
    }else if(message.contentType == MessageType.custom){
      try{
        var data = message.customElem!.data;
        var map = json.decode(data!);
        var type = map['type'];
        if (type.toString() == "patient") {
          //患者
          var patient =PatientDetailRes.fromJson(map["content"]);
          content = {
            "title":"[${patient.name}]的患者档案",
            "from":"[${name.value}]${isSingleChat?"的会话":"的群聊"}",
            "type":6,
            "data": {
              "patient":patient,
            },
          };
          Apis.addLike(message.sendID??"", message.senderNickname??"", message.senderFaceUrl??"", DateTime.now().millisecondsSinceEpoch.toString(), content).then((value){
            IMWidget.showToast("收藏成功");
          });
        }else if(type.toString() == "note"){
          //医疗备忘
          var noteItem = YlbwListBeanData.fromJson(map["content"]);
          content = {
            "title":"[${noteItem.title}]",
            "from":"[${name.value}]${isSingleChat?"的会话":"的群聊"}",
            "type":8,
            "data": {
              "note":noteItem
            },
          };
          Apis.addLike(message.sendID??"", message.senderNickname??"", message.senderFaceUrl??"", DateTime.now().millisecondsSinceEpoch.toString(), content).then((value){
            IMWidget.showToast("收藏成功");
          });

        }

      }catch(e){



      }


    }
  }

  //去患者详情
  void toHzxq(String string) {
    Get.toNamed(AppRoutes.PATIENT_DETAIL,arguments: {"id":string});
  }

  void toYlbw(YlbwListBeanData noteItem) {
    Get.toNamed(AppRoutes.MEDICAL_MEMO_DETAIL,arguments: {"item":noteItem});
  }

  leftBubbleColor(Message message) {
    if (message.contentType == MessageType.custom) {
      var data = message.customElem!.data;
      var map = json.decode(data!);
      var type = map['type'];
      if (type.toString() == "patient" || type.toString() == "note") {
        return Colors.transparent;
      }
    }
    return Color(0xFFF0F0F0);
  }
  rightBubbleColor(Message message) {
    if (message.contentType == MessageType.custom) {
      try{
        var data = message.customElem!.data;
        var map = json.decode(data!);
        var type = map['type'];
        if (type.toString() == "patient" || type.toString() == "note") {
          return Colors.transparent;
        }
      }catch(e){

      }
    }
    return Color(0xFFDCEBFE);
  }
}
