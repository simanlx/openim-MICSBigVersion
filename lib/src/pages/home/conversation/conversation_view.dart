import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/avatar_view.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:mics_big_version/src/widgets/search_box.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'conversation_logic.dart';

class ConversationPage extends StatelessWidget {

  final logic = Get.find<ConversationLogic>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() => Row(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6.r)),color: Colors.red),
            width: 230.w,child: SlidableAutoCloseBehavior(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              header: IMWidget.buildHeader(),
              footer: IMWidget.buildFooter(),
              controller: logic.refreshController,
              onRefresh: logic.onRefresh,
              onLoading: logic.onLoading,
              child: _buildListView(),
            ),
          ),),
          Container(width: 2.w,color: PageStyle.c_e8e8e8,),
          Expanded(child: Obx(()=>Stack(
            children: [
              if(logic.stackList.length>0)
                Obx(()=>logic.stackList.value[logic.stackList.length-1])
            ],
          )))
        ],
      )),
    );
  }

  Widget _buildListView() => CustomScrollView(
    slivers: [
      // SliverToBoxAdapter(
      //   child: GestureDetector(
      //     behavior: HitTestBehavior.translucent,
      //     onTap: logic.globalSearch,
      //     child: SearchBox(
      //       enabled: false,
      //       margin: EdgeInsets.fromLTRB(22.w, 11.h, 22.w, 5.h),
      //       padding: EdgeInsets.symmetric(horizontal: 13.w),
      //     ),
      //   ),
      // ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => ConversationItemView(
            onTap: () => logic.toChatBigScreen(index),
            avatarUrl: logic.getAvatar(index),
            avatarBuilder: () => _buildCustomAvatar(index),
            title: logic.getShowName(index),
            content: logic.getMsgContent(index),
            allAtMap: logic.getAtUserMap(index),
            contentPrefix: logic.getPrefixText(index),
            timeStr: logic.getTime(index),
            unreadCount: logic.getUnreadCount(index),
            notDisturb: logic.isNotDisturb(index),
            backgroundColor: logic.isPinned(index)
                ? PageStyle.c_F3F3F3
                : Colors.transparent,
            height: 50.h,
            contentWidth: 100.w,
            avatarSize: 20.w,
            underline: false,
            titleStyle: PageStyle.ts_333333_12sp,
            contentStyle: PageStyle.ts_666666_10sp,
            contentPrefixStyle: PageStyle.ts_F44038_13sp,
            timeStyle: PageStyle.ts_999999_10sp,
            extentRatio: logic.existUnreadMsg(index) ? 0.6 : 0.4,
            isUserGroup: logic.isUserGroup(index),
            slideActions: [
              if (logic.isValidConversation(index))
                SlideItemInfo(
                  flex: logic.isPinned(index) ? 3 : 2,
                  text:
                  logic.isPinned(index) ? StrRes.cancelTop : StrRes.top,
                  colors: pinColors,
                  textStyle: PageStyle.ts_FFFFFF_16sp,
                  width: 77.w,
                  onTap: () => logic.pinConversation(index),
                ),
              if (logic.existUnreadMsg(index))
                SlideItemInfo(
                  flex: 3,
                  text: StrRes.markRead,
                  colors: haveReadColors,
                  textStyle: PageStyle.ts_FFFFFF_16sp,
                  width: 77.w,
                  onTap: () => logic.markMessageHasRead(index),
                ),
              SlideItemInfo(
                flex: 2,
                text: StrRes.remove,
                colors: deleteColors,
                textStyle: PageStyle.ts_FFFFFF_16sp,
                width: 77.w,
                onTap: () => logic.deleteConversation(index),
              ),
            ],
            patterns: <MatchPattern>[
              MatchPattern(
                type: PatternType.AT,
                style: PageStyle.ts_666666_13sp,
              ),
            ],
            // isCircleAvatar: false,
          ),
          childCount: logic.list.length,
        ),
      ),
    ],
  );

  /// 系统通知自定义头像
  Widget? _buildCustomAvatar(index) {
    var info = logic.list.elementAt(index);
    if (info.conversationType == ConversationType.notification) {
      return Container(
        color: PageStyle.c_5496EB,
        height: 28.h,
        width: 28.h,
        alignment: Alignment.center,
        child: FaIcon(
          FontAwesomeIcons.solidBell,
          color: PageStyle.c_FFFFFF,
        ),
      );
    } else {
      return AvatarView(
        size: 28.h,
        url: info.faceURL,
        isUserGroup: logic.isUserGroup(index),
        text: info.showName,
        textStyle: PageStyle.ts_FFFFFF_16sp,
      );
    }
    // return null;
  }
}
