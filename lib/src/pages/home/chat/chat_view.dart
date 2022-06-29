import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/models/zskjs/PatientDetailRes.dart';
import 'package:mics_big_version/src/models/zskjs/YlbwListBean.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/sdk_extension/message_manager.dart';
import 'package:mics_big_version/src/utils/im_util.dart';
import 'package:mics_big_version/src/widgets/CustomeCardWidget.dart';
import 'package:mics_big_version/src/widgets/avatar_view.dart';
import 'package:mics_big_version/src/widgets/bkrs/ChatVoiceRecordLayoutBkrs.dart';
import 'package:mics_big_version/src/widgets/chat_listview.dart';
import 'package:mics_big_version/src/widgets/custom_sure_share_dialog.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import 'package:mics_big_version/src/widgets/water_mark_view.dart';
import 'package:rxdart/rxdart.dart';
import 'chat_logic.dart';

class ChatPage extends StatelessWidget {
  final logic = Get.find<ChatLogic>();

  Widget _itemView(int index, Message message) => ChatItemView(
        key: logic.itemKey(message),
        menus: _menusItem(message),
        index: index,
        message: message,
        avatarSize: 10.h,
        leftBubbleColor:logic.leftBubbleColor(message),
        rightBubbleColor:logic.rightBubbleColor(message),
        timeStr: logic.getShowTime(message),
        isSingleChat: logic.isSingleChat,
        clickSubject: logic.clickSubject,
        msgSendStatusSubject: logic.msgSendStatusSubject,
        msgSendProgressSubject: logic.msgSendProgressSubject,
        multiSelMode: logic.multiSelMode.value,
        multiList: logic.multiSelList.value,
        allAtMap: logic.getAtMapping(message),
        delaySendingStatus: true,
        textScaleFactor: logic.scaleFactor.value,
        needReadCount: logic.memberCount.value,
        // needReadCount: logic.getNeedReadCount(message),
        isPrivateChat: logic.isPrivateChat(message),
        readingDuration: logic.readTime(message),
        isPlayingSound: logic.isPlaySound(message),
        onFailedResend: () {
          logic.failedResend(message);
        },
        onDestroyMessage: () {
          logic.deleteMsg(message);
        },
        onViewMessageReadStatus: () {
          logic.viewGroupMessageReadStatus(message);
        },
        onMultiSelChanged: (checked) {
          logic.multiSelMsg(message, checked);
        },
        onTapCopyMenu: () {
          logic.copy(message);
        },
        onTapDelMenu: () {
          logic.deleteMsg(message);
        },
        onTapForwardMenu: () {
          logic.forward(message);
        },
        onTapReplyMenu: () {
          logic.setQuoteMsg(message);
        },
        onTapRevokeMenu: () {
          logic.revokeMsg(message);
        },
        onTapMultiMenu: () {
          logic.openMultiSelMode(message);
        },
        onTapAddEmojiMenu: () {
          logic.addEmoji(message);
        },
        visibilityChange: (context, index, message, visible) {
          logic.markMessageAsRead(message, visible);
        },
        onLongPressLeftAvatar: () {
          logic.onLongPressLeftAvatar(message);
        },
        onLongPressRightAvatar: () {},
        onTapLeftAvatar: () {
          logic.onTapLeftAvatar(message);
        },
        onTapRightAvatar: () {},
        onClickAtText: (uid) {
          logic.clickAtText(uid);
        },
        onTapQuoteMsg: () {
          logic.onTapQuoteMsg(message);
        },
        patterns: <MatchPattern>[
          MatchPattern(
            type: PatternType.AT,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.EMAIL,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.URL,
            style: PageStyle.ts_1B72EC_14sp_underline,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.MOBILE,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.TEL,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
        ],
        customItemBuilder: _buildCustomItemView,
        customMessageBuilder: _buildCustomMessageView,
        enabledReadStatus: logic.enabledReadStatus(message),
        isBubbleMsg: !logic.isNotificationType(message),
        customLeftAvatarBuilder: () => _buildCustomLeftAvatar(message),
        customRightAvatarBuilder: () => _buildCustomRightAvatar(message),
        // enabledTranslationMenu: false,
        enabledRevokeMenu:
            (logic.isCallMessage(message) || logic.isExceed24H(message))
                ? false
                : null,
        enabledReplyMenu: logic.isPrivateChat(message) ? false : null,
        enabledMultiMenu: logic.isPrivateChat(message) ? false : null,
        enabledForwardMenu: logic.isPrivateChat(message) ? false : null,
        enabledDelMenu: logic.isPrivateChat(message) ? false : null,
        enabledAddEmojiMenu: logic.isPrivateChat(message) ? false : null,
        onPopMenuShowChanged: logic.onPopMenuShowChanged,
        leftName: logic.newestNickname(message),
      );

  @override
  Widget build(BuildContext context) {
    print("=====================ChatView build ====================");
    return Obx(() => WillPopScope(
          onWillPop: logic.multiSelMode.value ? () async => logic.exit() : null,
          child: ChatVoiceRecordLayoutBkrs(
            key: logic.chatVoiceRecordLayoutKey,
            locale: Get.locale,
            builder: (bar) => Obx(() => Scaffold(
                  backgroundColor: PageStyle.c_FFFFFF,
                  appBar: EnterpriseTitleBar.chatTitle(
                    height: 34.h,
                    showTopPadding: false,
                    title: logic.name.value,
                    subTitle: logic.getSubTile(),
                    onClickCallBtn: () => logic.call(),
                    onClickMoreBtn: () => logic.chatSetup(),
                    leftButton: logic.multiSelMode.value ? StrRes.cancel : null,
                    onClose: () => logic.exit(),
                    showOnlineStatus: logic.showOnlineStatus(),
                    online: logic.onlineStatus.value,
                    showCallButton:
                        logic.isValidChat && !logic.isInBlacklist.value,
                    showMoreButton: logic.isValidChat,
                  ),
                  body: SafeArea(
                    child: WaterMarkBgView(
                      text: OpenIM.iMManager.uInfo.nickname!,
                      path: logic.background.value,
                      child: Column(
                        children: [
                          Expanded(
                            child: ChatListView(
                              key: logic.chatListViewKey,
                              onTouch: () => logic.closeToolbox(),
                              itemCount: logic.messageList.length,
                              controller: logic.scrollController,
                              onScrollDownLoad: () => logic.getHistoryMsgList(),
                              itemBuilder: (_, index) => Obx(
                                () => _itemView(
                                  index,
                                  logic.indexOfMessage(index),
                                ),
                              ),
                            ),
                          ),
                          ChatInputBoxView(
                            key: logic.chatInputBoxViewKey,
                            controller: logic.inputCtrl,
                            allAtMap: logic.atUserNameMappingMap,
                            toolbox: ChatToolsView(
                              onTapAlbum: () => logic.onTapAlbum(),
                              onTapCamera: () => logic.onTapCamera(),
                              onTapCarte: () => logic.onTapCarte(),
                              onTapFile: () => logic.onTapFile(),
                              onTapLocation: () => logic.onTapLocation(),
                              onTapVideoCall: () => logic.call(),
                              onStopVoiceInput: () => logic.onStopVoiceInput(),
                              onStartVoiceInput: () =>
                                  logic.onStartVoiceInput(),
                            ),
                            multiOpToolbox: ChatMultiSelToolbox(
                              onDelete: () => logic.mergeDelete(),
                              onMergeForward: () => logic.mergeForward(),
                            ),
                            emojiView: ChatEmojiView(
                              onAddEmoji: logic.onAddEmoji,
                              onDeleteEmoji: logic.onDeleteEmoji,
                              onAddFavorite: () => logic.emojiManage(),
                              favoriteList: logic.cacheLogic.urlList,
                              onSelectedFavorite: logic.sendCustomEmoji,
                            ),
                            onSubmitted: (v) => logic.sendTextMsg(),
                            forceCloseToolboxSub: logic.forceCloseToolbox,
                            voiceRecordBar: bar,
                            quoteContent: logic.quoteContent.value,
                            onClearQuote: () => logic.setQuoteMsg(null),
                            multiMode: logic.multiSelMode.value,
                            focusNode: logic.focusNode,
                            inputFormatters: [
                              AtTextInputFormatter(logic.openAtList)
                            ],
                            isGroupMuted: logic.isGroupMuted.value,
                            muteEndTime: logic.muteEndTime.value,
                            isInBlacklist: logic.isSingleChat
                                ? logic.isInBlacklist.value
                                : false,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            onCompleted: (sec, path) {
              logic.sendVoice(duration: sec, path: path);
            },
          ),
        ));
  }

  /// 自定义消息
  Widget? _buildCustomMessageView(
    BuildContext context,
    bool isReceivedMsg,
    int index,
    Message message,
    Map<String, String> allAtMap,
    double textScaleFactor,
    List<MatchPattern> patterns,
    Subject<MsgStreamEv<int>> msgSendProgressSubject,
    Subject<int> clickSubject,
  ) {
    var data = IMUtil.parseCustomMessage(message);
    if (null != data) {
      var viewType = data['viewType'];
      if (viewType == CustomMessageType.call) {
        return _buildCallItemView(type: data['type'], content: data['content']);
      } else if (viewType == CustomMessageType.tag_message) {
        final url = data['url'];
        final duration = data['duration'];
        final text = data['text'];
        if (text != null) {
          return ChatAtText(
            text: text,
            textScaleFactor: textScaleFactor,
            allAtMap: allAtMap,
            patterns: patterns,
          );
        } else if (url != null) {
          return ChatVoiceView(
            index: index,
            clickStream: clickSubject.stream,
            isReceived: isReceivedMsg,
            soundPath: null,
            soundUrl: url,
            duration: duration,
          );
        }
      }
    }
    return null;
  }

  /// custom item view
  Widget? _buildCustomItemView(
    BuildContext context,
    int index,
    Message message,
  ) {
    if (message.contentType == MessageType.custom) {
      var data = message.customElem!.data;
      var map = json.decode(data!);
      var type = map['type'];
      if(type.toString() == "patient"){
        try{
          var title = map["title"];
          var time = map["time"];
          var patient =PatientDetailRes.fromJson(map["content"]);

          // var patientMap = json.decode(patient);
          // var patientID = patientMap["patientID"];
          // var des = patientMap["illnessDesc"];
          return CustomCardWidget(CustomSureShareDialogType.HZXQ,title,patient.illnessDesc,height: 190.h,timeStr: DateUtil.formatDateMs(time, format: 'yyyy-MM-dd HH:mm:ss'),onClick: (){
            //进入患者详情页面
            print("患者id是 ${patient.id}");
            logic.toHzxq(patient.id.toString());
          },);
        }catch(e){
          print("患者档案数据解析失败  ${e.toString()}");
          return Text("[患者档案数据解析失败]");
        }
      }else if(type.toString() == "note"){
        try{
          var title = map["title"];
          var time = map["time"];
          var noteItem = YlbwListBeanData.fromJson(map["content"]);
          print("每一项的数据  ${noteItem.runtimeType}");
          var stringBuffer = StringBuffer();
          for (var value1 in noteItem.noteData!) {
            if (value1.type == "text") {
              stringBuffer.write(value1.data);
            }
          }
          return CustomCardWidget(CustomSureShareDialogType.YLBW,title,stringBuffer.toString(),height: 200.h,timeStr: DateUtil.formatDateMs(time, format: 'yyyy-MM-dd HH:mm:ss'),onClick: (){
            //进入医疗备忘详情
              logic.toYlbw(noteItem);
          },);
        }catch(e){
          print("医疗备忘数据解析失败  ${e.toString()}");
          return Text("[医疗备忘数据解析失败]");
        }
      }
    }
    final text = IMUtil.parseNotification(message);
    if (null != text) {
      print("自定义的 ${text}");
      return _buildNotificationTipsView(text);
    }
    return null;
  }

  Widget _buildNotificationTipsView(String text) => Container(
        alignment: Alignment.center,
        child: ChatAtText(
          text: text,
          textStyle: PageStyle.ts_999999_12sp,
          textAlign: TextAlign.center,
        ),
      );

  /// 通话item
  Widget _buildCallItemView({
    required String type,
    required String content,
  }) =>
      Row(
        children: [
          Image.asset(
            type == 'audio'
                ? ImageRes.ic_voiceCallMsg
                : ImageRes.ic_videoCallMsg,
            width: 20.h,
            height: 20.h,
          ),
          SizedBox(width: 6.w),
          Text(
            content,
            style: PageStyle.ts_333333_14sp,
          ),
        ],
      );

  /// 群公告item
  Widget _buildAnnouncementItemView(String content) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(ImageRes.ic_trumpet, width: 16.h, height: 16.h),
                SizedBox(width: 4.w),
                Text(
                  StrRes.groupAnnouncement,
                  style: PageStyle.ts_898989_13sp,
                )
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              content,
              style: PageStyle.ts_333333_13sp,
            ),
          ],
        ),
      );

  /// 自定义头像
  Widget? _buildCustomLeftAvatar(Message message) {
    String? nickname;
    String? faceUrl;
    if (logic.isSingleChat) {
      nickname = logic.name.value;
      faceUrl = logic.icon.value;
    } else {
      var info = logic.memberUpdateInfoMap[message.sendID];
      nickname = info?.nickname;
      faceUrl = info?.faceURL;
    }
    return AvatarView(
      size: 30.h,
      url: faceUrl ?? message.senderFaceUrl,
      text: nickname ?? message.senderNickname,
      textStyle: PageStyle.ts_FFFFFF_14sp,
      onTap: () {
        logic.onTapLeftAvatar(message);
      },
    );
  }

  Widget? _buildCustomRightAvatar(Message message) {
    String? nickname;
    String? faceUrl;
    if (logic.isGroupChat) {
      var info = logic.memberUpdateInfoMap[message.sendID];
      nickname = info?.nickname;
      faceUrl = info?.faceURL;
    }
    return AvatarView(
      size: 30.h,
      url: faceUrl ?? message.senderFaceUrl,
      text: nickname ?? message.senderNickname,
      textStyle: PageStyle.ts_FFFFFF_14sp,
    );
  }

  // bool get _showCopyMenu =>
  //     widget.enabledCopyMenu ?? widget.message.contentType == MessageType.text;

  //这里有一个是否显示的判断  enabledCopyMenu
  List<MenuInfo> _menusItem(Message message) => [
    MenuInfo(
      icon: ImageUtil.menuCopy(),
      text: UILocalizations.copy,
      enabled: message.contentType == MessageType.text,
      textStyle: PageStyle.ts_ffffff_10sp,
      onTap: (){
        logic.copy(message);
      },
    ),
    MenuInfo(
      icon: ImageUtil.menuDel(),
      text: UILocalizations.delete,
      enabled: (logic.isPrivateChat(message) ? false : null)??true,
      textStyle:  PageStyle.ts_ffffff_10sp,
      onTap: (){
        logic.deleteMsg(message);
      },
    ),

  // widget.enabledForwardMenu ??
  // widget.message.contentType != MessageType.voice;
    MenuInfo(
      icon: ImageUtil.menuForward(),
      text: UILocalizations.forward,
      enabled: (logic.isPrivateChat(message) ? false : null)??message.contentType != MessageType.voice,
      textStyle: PageStyle.ts_ffffff_10sp,
      onTap: (){
        logic.forward(message);
      },
    ),

  // widget.enabledReplyMenu ??
  // widget.message.contentType == MessageType.text ||
  // widget.message.contentType == MessageType.video ||
  // widget.message.contentType == MessageType.picture ||
  // widget.message.contentType == MessageType.location ||
  // widget.message.contentType == MessageType.quote;
    MenuInfo(
      icon: ImageUtil.menuReply(),
      text: UILocalizations.reply,
      enabled: (logic.isPrivateChat(message) ? false : null)??
          message.contentType == MessageType.text ||
              message.contentType == MessageType.video ||
              message.contentType == MessageType.picture ||
              message.contentType == MessageType.location ||
              message.contentType == MessageType.quote
      ,
      textStyle: PageStyle.ts_ffffff_10sp,
      onTap: (){
        logic.setQuoteMsg(message);
      },
    ),

    //widget.enabledRevokeMenu ?? widget.message.sendID == OpenIM.iMManager.uid;
    MenuInfo(
        icon: ImageUtil.menuRevoke(),
        text: UILocalizations.revoke,
        enabled: ((logic.isCallMessage(message) || logic.isExceed24H(message))
            ? false
            : null)??message.sendID == OpenIM.iMManager.uid,
        textStyle: PageStyle.ts_ffffff_10sp,
        onTap: (){
          logic.revokeMsg(message);
        }),

    //widget.enabledMultiMenu ?? true;
    MenuInfo(
      icon: ImageUtil.menuMultiChoice(),
      text: UILocalizations.multiChoice,
      enabled: ( logic.isPrivateChat(message) ? false : null)??true,
      textStyle: PageStyle.ts_ffffff_10sp,
      onTap: (){
        logic.openMultiSelMode(message);
      },
    ),

  // widget.enabledTranslationMenu ??
  // widget.message.contentType == MessageType.text;
    MenuInfo(
      icon: ImageUtil.menuTranslation(),
      text: UILocalizations.translation,
      enabled: message.contentType == MessageType.text,
      textStyle: PageStyle.ts_ffffff_10sp,
      onTap: (){

      },
    ),

  // widget.enabledAddEmojiMenu ??
  // widget.message.contentType == MessageType.picture ||
  // widget.message.contentType == MessageType.custom_face;
    MenuInfo(
      icon: ImageUtil.menuAddEmoji(),
      text: UILocalizations.add,
      enabled: (logic.isPrivateChat(message) ? false : null)??
          message.contentType == MessageType.picture ||
          message.contentType == MessageType.custom_face,
      textStyle: PageStyle.ts_ffffff_10sp,
      onTap: (){
        logic.addEmoji(message);
      },
    ),
    MenuInfo(
      icon: Image.asset(ImageRes.ic_collection_bkrs,width: 20.w,height: 20.w,color: Colors.white,),
      text: "收藏",
      enabled: true,
      textStyle: PageStyle.ts_ffffff_10sp,
      onTap: (){
        logic.addLike(message,logic.isSingleChat);
      },
    ),
  ];
}
