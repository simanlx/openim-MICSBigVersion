import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';

import '../res/strings.dart';
import '../res/styles.dart';
import '../utils/im_util.dart';
import 'avatar_view.dart';

class PreviewMergeMsg extends StatelessWidget {
  PreviewMergeMsg({Key? key, required this.messageList, required this.title})
      : super(key: key);
  final List<Message> messageList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: title,
        showShadow: false,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: ListView.builder(
        itemCount: messageList.length,
        shrinkWrap: true,
        itemBuilder: (_, index) => _buildItemView(index),
      ),
    );
  }

  Widget _buildItemView(int index) {
    var message = messageList.elementAt(index);
    var atMap = <String, String>{};
    var text;
    var child;
    switch (message.contentType) {
      case MessageType.text:
        {
          text = message.content;
        }
        break;
      case MessageType.at_text:
        {
          try {
            Map map = json.decode(message.content!);
            text = map['text'];
            var list = message.atElem!.atUsersInfo;
            list?.forEach((element) {
              atMap[element.atUserID!] = element.groupNickname!;
            });
          } catch (e) {}
        }
        break;
      case MessageType.picture:
        {
          text = '[${StrRes.picture}]';
        }
        break;
      case MessageType.voice:
        {
          text = '[${StrRes.voice}]';
        }
        break;
      case MessageType.video:
        {
          text = '[${StrRes.video}]';
        }
        break;
      case MessageType.file:
        {
          text = '[${StrRes.file}]';
        }
        break;
      case MessageType.location:
        {
          text = '[${StrRes.location}]';
        }
        break;
      case MessageType.quote:
        {
          text = message.quoteElem?.text ?? '';
        }
        break;
      case MessageType.card:
        {
          text = '[${StrRes.carte}]';
        }
        break;
      case MessageType.merger:
        child = Container(
          // margin: EdgeInsets.only(left: 12.w),
          padding: EdgeInsets.only(left: 16.w, top: 4.h),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(4),
          //   color: PageStyle.c_979797,
          // ),
          child: ChatMergeMsgView(
            title: message.mergeElem!.title!,
            summaryList: message.mergeElem!.abstractList!,
          ),
        );
        break;
      default:
        {
          text = "";
        }
        break;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => IMUtil.parseClickEvent(message, messageList: messageList),
      child: Container(
        padding: EdgeInsets.only(
          left: 22.w,
          right: 22.w,
          top: 16.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarView(
              size: 42.h,
              url: message.senderFaceUrl,
              text: message.senderNickname,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 12.w),
                padding: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: Color(0xFFDFDFDF),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.senderNickname!,
                            style: PageStyle.ts_666666_12sp,
                          ),
                          if (text != null && child == null)
                            ChatAtText(
                              text: text,
                              textStyle: PageStyle.ts_333333_14sp,
                              allAtMap: atMap,
                              patterns: <MatchPattern>[
                                MatchPattern(
                                  type: PatternType.AT,
                                  style: PageStyle.ts_999999_14sp,
                                ),
                                MatchPattern(
                                  type: PatternType.EMAIL,
                                  style: PageStyle.ts_999999_14sp,
                                ),
                                MatchPattern(
                                  type: PatternType.URL,
                                  style: PageStyle.ts_999999_14sp,
                                ),
                                MatchPattern(
                                  type: PatternType.MOBILE,
                                  style: PageStyle.ts_999999_14sp,
                                ),
                                MatchPattern(
                                  type: PatternType.TEL,
                                  style: PageStyle.ts_999999_14sp,
                                ),
                              ],
                            ),
                          if (child != null) child!,
                        ],
                      ),
                    ),
                    Text(
                      IMUtil.getChatTimeline(message.sendTime!),
                      style: PageStyle.ts_999999_12sp,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
