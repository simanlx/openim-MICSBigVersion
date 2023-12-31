import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/home/conversation/conversation_logic.dart';
import 'package:mics_big_version/src/pages/home/work_bench/work_bench_logic.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/avatar_view.dart';
import 'package:mics_big_version/src/widgets/bkrs/ConversationItemViewBkrs.dart' as conversationItemViewBkrs;
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'workbench_main_logic.dart';

class WorkbenchMainPage extends StatelessWidget {

  final logic = Get.find<WorkbenchLogic>();
  final conversationLogic = Get.find<ConversationLogic>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
        ClipRRect(borderRadius: BorderRadius.circular(10.r),
    child:  Obx(() =>
        Container(
          color: Colors.white,
          child:Row(
            children: [
              Container(
                // decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(6.r),bottomLeft: Radius.circular(6.r)),color: Colors.blue),
                width: 250.w,child: _buildLeft(),),
              Container(width: 2.w,color: PageStyle.c_e8e8e8,),
              Expanded(child: Obx(()=>Column(
                children: [
                  SizedBox(height: 20.h,),
                  Expanded(child:

                  SmartRefresher(controller: logic.refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    header: IMWidget.buildHeader(),
                    footer: IMWidget.buildFooter(),
                    onRefresh: logic.onRefresh,
                    child:  GridView.builder(
                        itemCount: logic.list2.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.0,
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (_, index){
                          return _buildCommonPart(index);
                        }),

                  )
                  // GridView.builder(
                  //     itemCount: logic.list2.length,
                  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       childAspectRatio: 1.0,
                  //       crossAxisCount: 4,
                  //     ),
                  //     itemBuilder: (_, index){
                  //       return _buildCommonPart(index);
                  //     })

                  )
                ],
              )))
            ],
          ),
        )

    ),)
    );
  }

  _buildLeft() {
    return CustomScrollView(

      slivers: [
        // SliverToBoxAdapter(
        //   child: GestureDetector(
        //     behavior: HitTestBehavior.translucent,
        //     onTap: logic.globalSearch,
        //     child: SearchBox(
        //       enabled: false,
        //       margin: EdgeInsets.fromLTRB(22.w, 11.h, 22.w, 10.h),
        //       padding: EdgeInsets.symmetric(horizontal: 13.w),
        //     ),
        //   ),
        // ),
        SliverToBoxAdapter(
          child: SizedBox(height: 10.h)
        ),

        SliverToBoxAdapter(
          child: Row(children: [
            SizedBox(
              width: 14.w,
            ),
            Text(logic.unreadMsgCount == 0?"未读消息":"未读消息(${logic.unreadMsgCount})",style: TextStyle(fontSize: 14.sp,color: Colors.black),),
            SizedBox(
              width: 22.w,
            ),
            Expanded(child: Container()),
            // TextButton(onPressed: (){
            //   logic.homeLogic.switchTab(1);
            // }, child: Text("更多",style: TextStyle(fontSize: 14.sp)))
          ],),

        ),

        SliverToBoxAdapter(
            child: Visibility(child: Padding(child: Image.asset("assets/images/pic_no_unread.png",width: 100.w,height: 150.w),padding: EdgeInsets.only(top: 50.h),),visible: logic.list.length ==0,)
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) => conversationItemViewBkrs.ConversationItemViewBkrs(
              onTap: () {
                var userInfo = logic.list[index];
                conversationLogic.toChatBigScreenOther(
                  userID: userInfo.userID,
                  groupID: userInfo.groupID,
                  nickname: userInfo.showName,
                  faceURL: userInfo.faceURL,
                  type: 1,
                );
                // conversationLogic.toChatBigScreen(index);
              },
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
              avatarSize: 20.h,
              underline: false,
              titleStyle: PageStyle.ts_333333_12sp,
              contentStyle: PageStyle.ts_666666_10sp,
              contentPrefixStyle: PageStyle.ts_F44038_13sp,
              timeStyle: PageStyle.ts_999999_10sp,
              extentRatio: logic.existUnreadMsg(index) ? 0.6 : 0.4,
              isUserGroup: logic.isUserGroup(index),
              slideActions: [
                if (logic.isValidConversation(index))
                  conversationItemViewBkrs.SlideItemInfo(
                    flex: logic.isPinned(index) ? 3 : 2,
                    text:
                    logic.isPinned(index) ? StrRes.cancelTop : StrRes.top,
                    colors: pinColors,
                    textStyle: PageStyle.ts_FFFFFF_16sp,
                    width: 77.w,
                    onTap: () => logic.pinConversation(index),
                  ),
                if (logic.existUnreadMsg(index))
                  conversationItemViewBkrs.SlideItemInfo(
                    flex: 3,
                    text: StrRes.markRead,
                    colors: haveReadColors,
                    textStyle: PageStyle.ts_FFFFFF_16sp,
                    width: 77.w,
                    onTap: () => logic.markMessageHasRead(index),
                  ),
                conversationItemViewBkrs.SlideItemInfo(
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
            childCount: logic.list.length>=5?5:logic.list.length,
          ),
        ),
      ],
    );
  }

  /// 系统通知自定义头像
  /// 系统通知自定义头像
  Widget? _buildCustomAvatar(index) {
    var info = logic.list.elementAt(index);
    if (info.conversationType == ConversationType.notification) {
      return Container(
        color: PageStyle.c_5496EB,
        height: 26.h,
        width: 26.h,
        alignment: Alignment.center,
        child: FaIcon(
          FontAwesomeIcons.solidBell,
          color: PageStyle.c_FFFFFF,
        ),
      );
    } else {
      return AvatarView(
        size: 26.h,
        url: info.faceURL,
        isUserGroup: logic.isUserGroup(index),
        text: info.showName,
        textStyle: PageStyle.ts_FFFFFF_16sp,
      );
    }
    // return null;
  }

  Widget _buildCommonPart(int index){
    // CommonPartInfo a = logic.list2[index];
    // print("索引 $index");
    var item = logic.list2[index];
    return GestureDetector(
      onTap: (){
        if (item.appUrl == "hzgl") {
          //患者管理
          logic.skipHzgl();
        }else if(item.appUrl == "zskjs"){
          //知识库检索
          logic.skipZskjs();
        }else if(item.appUrl == "ylbw"){
          //医疗备忘
          logic.skipYlbw();
        }else if(item.appUrl == "wdsc"){
          //我的收藏
          logic.skipWdsc();
        }else if(item.appUrl == "xttz"){
          //系统通知
          logic.skipXttz();
        }else if(item.appUrl == "zndw"){
          //智能定位
          // logic.skipHzgl();
        }else if(item.appUrl == "zhp"){
          logic.skipZhp();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if(item.appUrl == "zhp")
          Container(
            // padding: EdgeInsets.all(4.h),
            child: Image.asset(logic.list2[index].icon??"",width: 52.h,height: 52.h,errorBuilder: (BuildContext context,
                Object error,
                StackTrace? stackTrace){
              return Container(width: 52.h,height: 52.h);
            }),
          ),
          if(item.appUrl != "zhp")
          Image.network(logic.list2[index].icon??"",width: 52.h,height: 52.h,errorBuilder: (BuildContext context,
              Object error,
              StackTrace? stackTrace){
            return Container(width: 52.h,height: 52.h);
          }),
          Padding(padding: EdgeInsets.only(top: 8.w),child:
          Text(logic.list2[index].name??"",style: TextStyle(fontSize: 14.sp),)
            ,)
        ],
      ),
    );
  }
}
