import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_openim_live/flutter_openim_live.dart';
import 'package:flutter_openim_live_alert/flutter_openim_live_alert.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mics_big_version/src/sdk_extension/message_manager.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../models/call_records.dart';
import '../res/strings.dart';
import 'controller/app_controller.dart';
import 'controller/cache_controller.dart';

/// 信令
mixin OpenLive {
  final signalingSubject = PublishSubject<CallEvent>();
  final insertSignalingMessageSubject = PublishSubject<CallEvent>();
  final signalingMessageSubject = PublishSubject<SignalingMessageEvent>();
  final appController = Get.find<AppController>();

  /// 退到后台不会弹出拨号界面，切到前台后才会弹出界面。
  /// 如果存在值，表示收到了来电邀请，启动后需要恢复拨号界面
  CallEvent? beCalledEvent;

  /// true:点击了系统桌面的接受按钮，恢复拨号界面后自动接听
  bool autoPickup = false;

  final ring = 'assets/audio/live_ring.wav';
  final audioPlayer = AudioPlayer(
    // Handle audio_session events ourselves for the purpose of this demo.
    handleInterruptions: false,
    // androidApplyAudioAttributes: false,
    // handleAudioSessionActivation: false,
  );

  onInitLive() {
    _signalingListener();
    _insertSignalingMessageListener();
    appController.backgroundSubject.listen((isRunningBackground) {
      // 从后台切换到前台，如果还在被call，则拉起通话页面
      if (!isRunningBackground) {
        // 恢复拨号界面
        if (beCalledEvent != null) {
          signalingSubject.add(beCalledEvent!);
        }
        // 关闭系统弹框
        FlutterOpenimLiveAlert.closeLiveAlert();
      }
    });
    // 桌面浮窗
    FlutterOpenimLiveAlert.buttonEvent(
      onAccept: () {
        // 自动接听
        autoPickup = true;
      },
      onReject: () async {
        // 点击系统桌面浮窗的拒绝按钮
        await onTapReject(
          SignalingInfo(
            opUserID: OpenIM.iMManager.uid,
            invitation: (beCalledEvent!.data as SignalingInfo).invitation,
          ),
        );
        // 重置拨号状态
        beCalledEvent = null;
      },
    );
  }

  onCloseLive() {
    signalingSubject.close();
    insertSignalingMessageSubject.close();
    signalingMessageSubject.close();
    _stopSound();
    FlutterOpenimLiveAlert.closeLiveAlert();
  }

  /// 拦截其他干扰信令
  Stream<CallEvent> get _stream => signalingSubject.stream
      .where((event) => LiveClient.dispatchSignaling(event));

  void _signalingListener() {
    _stream.listen(
      (event) async {
        beCalledEvent = null;
        if (event.state == CallState.beCalled) {
          _playSound();
          var iInfo = (event.data as SignalingInfo).invitation;
          var type =
              iInfo?.mediaType == 'audio' ? CallType.audio : CallType.video;
          var obj = iInfo?.sessionType == 2 ? CallObj.group : CallObj.single;
          if (appController.isRunningBackground) {
            // 记录拨号状态
            beCalledEvent = event;
            // 如果当前处于后台，显示系统浮窗并拦截拨号界面
            var list = await OpenIM.iMManager.userManager.getUsersInfo(
              uidList: [iInfo!.inviterUserID!],
            );
            FlutterOpenimLiveAlert.showLiveAlert(
              title:
                  '${list.firstOrNull?.nickname} 邀请你进行${type == CallType.audio ? StrRes.callVoice : StrRes.callVideo}通话...',
            );
            return;
          }
          // 重置
          beCalledEvent = null;
          LiveClient.call(
            ctx: Get.overlayContext!,
            eventChangedSubject: signalingSubject,
            roomID: iInfo!.roomID!,
            inviteeUserIDList: iInfo.inviteeUserIDList!,
            inviterUserID: iInfo.inviterUserID!,
            groupID: iInfo.groupID,
            type: type,
            obj: obj,
            initState: CallState.beCalled,
            syncUserInfo: syncUserInfo,
            syncGroupInfo: syncGroupInfo,
            syncGroupMemberInfo: syncGroupMemberInfo,
            autoPickup: autoPickup,
            onTapPickup: () => onTapPickup(
              SignalingInfo(
                opUserID: OpenIM.iMManager.uid,
                invitation: iInfo,
              ),
            ),
            onTapReject: () => onTapReject(
              SignalingInfo(
                opUserID: OpenIM.iMManager.uid,
                invitation: iInfo,
              ),
            ),
            onTapHangup: (duration, isPositive) => onTapHangup(
              SignalingInfo(
                opUserID: OpenIM.iMManager.uid,
                invitation: iInfo,
              ),
              duration,
              isPositive,
            ),
          );
        } else if (event.state == CallState.beRejected) {
          // 被拒绝
          _stopSound();
          insertSignalingMessageSubject.add(event);
        } else if (event.state == CallState.beHangup) {
          // 被挂断
          _stopSound();
          insertSignalingMessageSubject.add(event);
        } else if (event.state == CallState.beCanceled) {
          // 超时被取消
          if (appController.isRunningBackground) {
            FlutterOpenimLiveAlert.closeLiveAlert();
          }
          _stopSound();
          insertSignalingMessageSubject.add(event);
        } else if (event.state == CallState.beAccepted) {
          // 被接听
          _stopSound();
        } else if (event.state == CallState.noReply) {
          // 被其他设备接听
          _stopSound();
        } else if (event.state == CallState.timeout) {
          // 超时无响应
          onTimeoutCancelled(event);
        }
      },
    );
  }

  _insertSignalingMessageListener() {
    insertSignalingMessageSubject.listen((value) {
      _insertMessage(
        state: value.state,
        signalingInfo: value.data,
        duration: value.fields ?? 0,
      );
    });
  }

  call(
    CallObj obj,
    CallType type,
    String? groupID,
    List<String> inviteeUserIDList,
  ) {
    var mediaType = type == CallType.audio ? 'audio' : 'video';
    var signal = SignalingInfo(
      opUserID: OpenIM.iMManager.uid,
      invitation: InvitationInfo(
        inviterUserID: OpenIM.iMManager.uid,
        inviteeUserIDList: inviteeUserIDList,
        roomID: Uuid().v4(),
        timeout: 30,
        mediaType: mediaType,
        sessionType: obj == CallObj.single ? 1 : 2,
        platformID: Platform.isAndroid ? 2 : 1,
        groupID: groupID,
      ),
    );

    LiveClient.call(
      ctx: Get.overlayContext!,
      eventChangedSubject: signalingSubject,
      inviterUserID: OpenIM.iMManager.uid,
      groupID: groupID,
      inviteeUserIDList: inviteeUserIDList,
      obj: obj,
      type: type,
      initState: CallState.call,
      onDialSingle: () => onDialSingle(signal),
      onDialGroup: () => onDialGroup(signal),
      onTapCancel: () => onTapCancel(signal),
      onTapHangup: (duration, isPositive) => onTapHangup(
        signal,
        duration,
        isPositive,
      ),
      syncUserInfo: syncUserInfo,
      syncGroupInfo: syncGroupInfo,
      syncGroupMemberInfo: syncGroupMemberInfo,
      // onWaitingAccept: () {
      //   if (obj == CallObj.single) _playSound();
      // },
    );
  }

  /// 拨向单人
  onDialSingle(SignalingInfo signaling) async {
    var info = await OpenIM.iMManager.signalingManager.signalingInvite(
      info: signaling,
    );
    return info.toJson();
  }

  /// 拨向多人
  onDialGroup(SignalingInfo signaling) async {
    var info = await OpenIM.iMManager.signalingManager.signalingInviteInGroup(
      info: signaling..invitation?.timeout = 1 * 60 * 60,
    );
    return info.toJson();
  }

  /// 接听
  onTapPickup(SignalingInfo signaling) async {
    beCalledEvent = null; // ios bug
    autoPickup = false;
    _stopSound();
    var info = await OpenIM.iMManager.signalingManager.signalingAccept(
      info: signaling,
    );
    return info.toJson();
  }

  /// 拒绝
  onTapReject(SignalingInfo signaling) async {
    _stopSound();
    insertSignalingMessageSubject.add(CallEvent(CallState.reject, signaling));
    return OpenIM.iMManager.signalingManager.signalingReject(
      info: signaling,
    );
  }

  /// 取消
  onTapCancel(SignalingInfo signaling) async {
    _stopSound();
    insertSignalingMessageSubject.add(CallEvent(CallState.cancel, signaling));
    return OpenIM.iMManager.signalingManager.signalingCancel(
      info: signaling,
    );
  }

  /// 超时取消
  onTimeoutCancelled(CallEvent event) {
    _stopSound();
    insertSignalingMessageSubject.add(event);
    return OpenIM.iMManager.signalingManager.signalingCancel(
      info: SignalingInfo(
        opUserID: OpenIM.iMManager.uid,
        invitation: (event.data as SignalingInfo).invitation,
      ),
    );
  }

  /// 挂断
  onTapHangup(SignalingInfo signaling, int duration, bool isPositive) async {
    _stopSound();
    insertSignalingMessageSubject.add(CallEvent(
      CallState.hangup,
      signaling,
      fields: duration,
    ));
    // if (isPositive) {
    //   return OpenIM.iMManager.signalingManager.signalingHungUp(
    //     info: SignalingInfo(
    //       opUserID: OpenIM.iMManager.uid,
    //       invitation: signaling.invitation,
    //     ),
    //   );
    // }
  }

  /// 同步用户信息
  Future<Map?> syncUserInfo(userID) async {
    var list = await OpenIM.iMManager.userManager.getUsersInfo(
      uidList: [userID],
    );
    return list.map((e) => e.toJson()).firstOrNull;
  }

  /// 同步组信息
  Future<Map?> syncGroupInfo(groupID) async {
    var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
      gidList: [groupID],
    );
    return list.map((e) => e.toJson()).firstOrNull;
  }

  /// 同步群成员信息
  Future<List<Map>?> syncGroupMemberInfo(groupID, userIDList) async {
    var list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
      groupId: groupID,
      uidList: userIDList,
    );
    return list.map((e) => e.toJson()).toList();
  }

  /// 自定义通话消息
  void _insertMessage({
    required CallState state,
    required SignalingInfo signalingInfo,
    // required CallType type,
    // required CallObj obj,
    // required String inviterUserID,
    // List<String>? inviteeUserIDList,
    // String? groupID,
    int duration = 0,
  }) async {
    (() async {
      var invitation = signalingInfo.invitation;
      var mediaType = invitation!.mediaType;
      var inviterUserID = invitation.inviterUserID;
      var inviteeUserID = invitation.inviteeUserIDList!.first;
      var groupID = invitation.groupID;
      print('----------state:${state.name}');
      print('----------mediaType:$mediaType');
      print('----------inviterUserID:$inviterUserID');
      print('----------inviteeUserIDList:$inviteeUserID');
      print('----------groupID:$groupID');
      _recordCall(state: state, signaling: signalingInfo, duration: duration);
      var message = await OpenIM.iMManager.messageManager.createCallMessage(
        state: state.name,
        type: mediaType!,
        duration: duration,
      );
      switch (invitation.sessionType) {
        case 1:
          {
            var receiverID;
            if (inviterUserID != OpenIM.iMManager.uid) {
              receiverID = inviterUserID;
            } else {
              receiverID = inviteeUserID;
            }

            var msg = await OpenIM.iMManager.messageManager
                .insertSingleMessageToLocalStorage(
              receiverID: inviteeUserID,
              senderID: inviterUserID,
              // receiverID: receiverID,
              // senderID: OpenIM.iMManager.uid,
              message: message
                ..status = 2
                ..isRead = true,
            );

            signalingMessageSubject.add(
              SignalingMessageEvent(msg, 1, receiverID, null),
            );
          }
          break;
        case 2:
          {
            // signalingMessageSubject.add(
            //   SignalingMessageEvent(message, 2, null, groupID),
            // );
            // OpenIM.iMManager.messageManager.insertGroupMessageToLocalStorage(
            //   groupID: groupID!,
            //   senderID: inviterUserID,
            //   message: message..status = 2,
            // );
          }
          break;
      }
    })();
  }

  /// 播放提示音
  void _playSound() async {
    if (!audioPlayer.playerState.playing) {
      audioPlayer.setAsset(ring);
      audioPlayer.setLoopMode(LoopMode.one);
      audioPlayer.setVolume(1.0);
      audioPlayer.play();
    }
  }

  /// 关闭提示音
  void _stopSound() async {
    if (audioPlayer.playerState.playing) {
      audioPlayer.stop();
    }
  }

  void _recordCall({
    required CallState state,
    required SignalingInfo signaling,
    int duration = 0,
  }) async {
    var invitation = signaling.invitation;
    if (invitation!.sessionType != 1) return;
    var mediaType = invitation.mediaType;
    var inviterUserID = invitation.inviterUserID;
    var inviteeUserID = invitation.inviteeUserIDList!.first;
    var groupID = invitation.groupID;
    var isMeCall = inviterUserID == OpenIM.iMManager.uid;
    var userID = isMeCall ? inviteeUserID : inviterUserID!;
    var incomingCall = isMeCall ? false : true;
    var userInfo =
        (await OpenIM.iMManager.userManager.getUsersInfo(uidList: [userID]))
            .first;
    final cache = Get.find<CacheController>();
    cache.addCallRecords(CallRecords(
      userID: userID,
      nickname: userInfo.nickname!,
      faceURL: userInfo.faceURL,
      success: state == CallState.hangup || state == CallState.beHangup,
      date: DateTime.now().millisecondsSinceEpoch,
      type: mediaType!,
      incomingCall: incomingCall,
      duration: duration,
    ));
  }
}

class SignalingMessageEvent {
  Message message;
  String? userID;
  String? groupID;
  int sessionType;

  SignalingMessageEvent(
    this.message,
    this.sessionType,
    this.userID,
    this.groupID,
  );
}
