import 'dart:io';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';

import '../../common/config.dart';
import '../callback/im_callback.dart';
import '../live.dart';


class IMController extends GetxController with IMCallback, OpenLive {
  late Rx<UserInfo> userInfo;

  @override
  void onClose() {
    super.close();
    // OpenIM.iMManager.unInitSDK();
    onCloseLive();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    onInitLive();
    // Initialize SDK
    await OpenIM.iMManager.initSDK(
      platform: Platform.isAndroid ? IMPlatform.android : IMPlatform.ios,
      apiAddr: Config.imApiUrl(),
      wsAddr: Config.imWsUrl(),
      dataDir: '${Config.cachePath}/',
      objectStorage: 'minio',
      listener: OnConnectListener(
        onConnecting: () {},
        onConnectFailed: (code, error) {},
        onConnectSuccess: () {},
        onKickedOffline: kickedOffline,
        onUserSigExpired: () {},
      ),
    );
    // Set listener
    OpenIM.iMManager
      //
      ..userManager.setUserListener(OnUserListener(
        onSelfInfoUpdated: (u) {
          userInfo.update((val) {
            val?.nickname = u.nickname;
            val?.faceURL = u.faceURL;
            val?.gender = u.gender;
            val?.birth = u.birth;
            val?.email = u.email;
            val?.remark = u.remark;
            val?.ex = u.ex;
          });
          // userInfo.value = u;
        },
      ))
      // Add message listener (remove when not in use)
      ..messageManager.setAdvancedMsgListener(OnAdvancedMsgListener(
        onRecvMessageRevoked: recvMessageRevoked,
        onRecvC2CMessageReadReceipt: recvC2CMessageReadReceipt,
        onRecvNewMessage: recvNewMessage,
        onRecvGroupMessageReadReceipt: recvGroupMessageReadReceipt,
      ))

      // Set up message sending progress listener
      ..messageManager.setMsgSendProgressListener(OnMsgSendProgressListener(
        onProgress: progressCallback,
      ))

      // Set up friend relationship listener
      ..friendshipManager.setFriendshipListener(OnFriendshipListener(
        onBlacklistAdded: blacklistAdded,
        onBlacklistDeleted: blacklistDeleted,
        onFriendApplicationAccepted: friendApplicationAccepted,
        onFriendApplicationAdded: friendApplicationAdded,
        onFriendApplicationDeleted: friendApplicationDeleted,
        onFriendApplicationRejected: friendApplicationRejected,
        onFriendInfoChanged: friendInfoChanged,
        onFriendAdded: friendAdded,
        onFriendDeleted: friendDeleted,
      ))

      // Set up conversation listener
      ..conversationManager.setConversationListener(OnConversationListener(
        onConversationChanged: conversationChanged,
        onNewConversation: newConversation,
        onTotalUnreadMessageCountChanged: totalUnreadMsgCountChanged,
        // totalUnreadMsgCountChanged: (i) => unreadMsgCountCtrl.addSafely(i),
        onSyncServerFailed: () {},
        onSyncServerFinish: () {},
        onSyncServerStart: () {},
      ))

      // Set up group listener
      ..groupManager.setGroupListener(OnGroupListener(
        onGroupApplicationAccepted: groupApplicationAccepted,
        onGroupApplicationAdded: groupApplicationAdded,
        onGroupApplicationDeleted: groupApplicationDeleted,
        onGroupApplicationRejected: groupApplicationRejected,
        onGroupInfoChanged: groupInfoChanged,
        onGroupMemberAdded: groupMemberAdded,
        onGroupMemberDeleted: groupMemberDeleted,
        onGroupMemberInfoChanged: groupMemberInfoChanged,
        onJoinedGroupAdded: joinedGroupAdded,
        onJoinedGroupDeleted: joinedGroupDeleted,
      ))
      // Set up signaling listener
      ..signalingManager.setSignalingListener(OnSignalingListener(
        onInvitationCancelled: invitationCancelled,
        onInvitationTimeout: invitationTimeout,
        onInviteeAccepted: inviteeAccepted,
        onInviteeRejected: inviteeRejected,
        onReceiveNewInvitation: receiveNewInvitation,
        onInviteeAcceptedByOtherDevice: inviteeAcceptedByOtherDevice,
        onInviteeRejectedByOtherDevice: inviteeRejectedByOtherDevice,
        onHangup: beHangup,
      ))
      ..workMomentsManager.setWorkMomentsListener(OnWorkMomentsListener(
        onRecvNewNotification: recvNewNotification,
      ));

    initializedSubject.sink.add(true);
  }

  Future login(String uid, String token) async {
    var user = await OpenIM.iMManager.login(uid: uid, token: token);
    return userInfo = user.obs;
  }

  Future logout() {
    return OpenIM.iMManager.logout();
  }
}
