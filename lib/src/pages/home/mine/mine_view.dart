import 'package:flutter/material.dart';
import 'package:flutter_openim_live/flutter_openim_live.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/core/controller/cache_controller.dart';
import 'package:mics_big_version/src/core/controller/im_controller.dart';
import 'package:mics_big_version/src/models/call_records.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/utils/im_util.dart';
import 'package:mics_big_version/src/widgets/TabBarView.dart';
import 'package:mics_big_version/src/widgets/avatar_view.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'mine_logic.dart';

class MinePage extends StatelessWidget {


  final logic = Get.find<MineLogic>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(()=>Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6.r)),color: Colors.white),
        child: Row(
          children: [
            buildLeft(),
            Container(width: 2.w,color: PageStyle.c_e8e8e8,margin: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h)),
            SizedBox(width: 0.w),
            Expanded(child: buildRight(context))
          ],
        ),
      )),
    );
  }

  buildLeft() {
    return Container(
      width: 200.w,
      child:Column(
        children: [
          SizedBox(height: 10.h),
          Text("个人信息",style: PageStyle.ts_333333_18sp,),
          SizedBox(height: 10.h),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              logic.switchIndex(0);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ImageRes.ic_myInfo,height: 50.w,width: 50.w),
                SizedBox(height: 5.h),
                Text("身份信息"),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              logic.switchIndex(1);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ImageRes.ic_tabContactsNor,color: PageStyle.c_418AE5,height: 50.w,width: 50.w),
                SizedBox(height: 5.h),
                Text("通话记录"),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              logic.logout();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ImageRes.ic_logout,height: 50.w,width: 50.w),
                SizedBox(height: 5.h),
                Text("登出"),
                Text("切换账号"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildRight(BuildContext context) {
    return Stack(
      children: [
        IndexedStack(
          index: logic.index.value,
          children: [
            buildPersonInfo(),
            buildCallLogInfo(context)
          ],
        )
      ],
    );
  }
  buildCallLogInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: MyTabBarView(
          fontColor: Colors.black,
          index: logic.callIndex.value,
          items: [
            "所有通话",
            "未接通话",
          ],
          onTap: (i) => logic.switchCallTab(i),
        ),),

        Container(
          constraints: BoxConstraints(maxHeight: 250.h),
          child: Padding(
          padding: EdgeInsets.only(left: 15.w,right: 15.w),
          child: Stack(
            children: [
              IndexedStack(
                index: logic.callIndex.value,
                children: [
                  _buildAllCallView(context),
                  _buildMissCallView(context),
                ],
              ),
            ],
          ),
        ),)
        // Text("通话记录",style: PageStyle.ts_333333_18sp,),
        // SizedBox(height: 10.h),
        // Container(height: 2.w,color: PageStyle.c_e8e8e8,margin: EdgeInsets.fromLTRB(0, 0, 20.h,0)),

      ],
    );
  }
  buildPersonInfo() {
    return Padding(padding: EdgeInsets.only(left: 20.w),child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("个人信息",style: PageStyle.ts_333333_18sp,),
        SizedBox(height: 10.h),
        Container(height: 2.w,color: PageStyle.c_e8e8e8,margin: EdgeInsets.fromLTRB(0, 0, 20.h,0)),
        SizedBox(height: 10.h),
        Text("登录账号:${logic.imLogic.userInfo.value.phoneNumber}"),
        SizedBox(height: 10.h),
        Text("管理员姓名:${logic.imLogic.userInfo.value.nickname}"),
        SizedBox(height: 10.h),
        Text("所在部门:"),
        SizedBox(height: 10.h),
        Text("手机号:${logic.imLogic.userInfo.value.phoneNumber}"),
        SizedBox(height: 10.h),
      ],
    ),);
  }

  var cacheLogic = Get.find<CacheController>();

  _buildAllCallView(BuildContext context) {
    print(cacheLogic.callRecordList.length);
    return
      MediaQuery.removePadding(
        removeTop: true,
        context: context,child:
          ListView.builder(
            itemCount: cacheLogic.callRecordList.length,
            cacheExtent: 70.h,
            itemBuilder: (_, index) => _buildItemView(
                cacheLogic.callRecordList.elementAt(index)),
          )
      );
  }

  _buildMissCallView(BuildContext context) {

    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child:ListView.builder(
              itemCount: cacheLogic.callRecordList
                  .where((e) => !e.success)
                  .length,
              cacheExtent: 70.h,
              itemBuilder: (_, index) => _buildItemView(cacheLogic.callRecordList
                  .where((e) => !e.success)
                  .elementAt(index)),
            )
    );


    return ListView.builder(
      itemCount: cacheLogic.callRecordList
          .where((e) => !e.success)
          .length,
      cacheExtent: 70.h,
      itemBuilder: (_, index) => _buildItemView(cacheLogic.callRecordList
          .where((e) => !e.success)
          .elementAt(index)),
    );
  }
  var imLogic = Get.find<IMController>();

  Widget _buildItemView(CallRecords records) => Dismissible(
    key: Key('${records.userID}_${records.date}'),
    confirmDismiss: (direction) async {
      await cacheLogic.deleteCallRecords(records);
      return true;;
    },
    child: GestureDetector(
      onTap: () {
        IMWidget.openIMCallSheet(records.nickname, (index) {
          imLogic.call(
            CallObj.single,
            index == 0 ? CallType.audio : CallType.video,
            null,
            [records.userID],
          );
        });
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            AvatarView(
              size: 30.h,
              url: records.faceURL,
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    records.nickname,
                    style: records.success
                        ? PageStyle.ts_333333_15sp
                        : PageStyle.ts_F33E37_15sp,
                  ),
                  Text(
                    '[${records.type == 'video' ? StrRes.video : StrRes.voice}]${IMUtil.getChatTimeline(records.date)}',
                    style: records.success
                        ? PageStyle.ts_666666_13sp
                        : PageStyle.ts_F33E37_13sp,
                  ),
                ],
              ),
            ),
            Text(
              records.success
                  ? IMUtil.seconds2HMS(records.duration)
                  : (records.incomingCall
                  ? StrRes.incomingCall
                  : StrRes.outgoingCall),
              style: records.success
                  ? PageStyle.ts_666666_13sp
                  : PageStyle.ts_F33E37_13sp,
            ),
          ],
        ),
      ),
    ),
  );
}
