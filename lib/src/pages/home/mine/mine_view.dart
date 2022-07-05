import 'package:flutter/material.dart';
import 'package:flutter_openim_live/flutter_openim_live.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/core/controller/cache_controller.dart';
import 'package:mics_big_version/src/core/controller/im_controller.dart';
import 'package:mics_big_version/src/models/call_records.dart';
import 'package:mics_big_version/src/pages/home/mine/about_us/about_us_logic.dart';
import 'package:mics_big_version/src/pages/home/mine/about_us/about_us_view.dart';
import 'package:mics_big_version/src/pages/home/mine/account_setup/account_setup_logic.dart';
import 'package:mics_big_version/src/pages/home/mine/account_setup/account_setup_view.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/utils/data_persistence.dart';
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
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.r)),color: Colors.white),
        child: Row(
          children: [
            buildLeft(),
            // Container(width: 2.w,color: PageStyle.c_e8e8e8,margin: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h)),
            Container(width: 2.w,color: PageStyle.c_e8e8e8),
            SizedBox(width: 0.w),
            Expanded(child: buildRight(context))
          ],
        ),
      )),
    );
  }
  var loginInfo = DataPersistence.getLoginCertificate();
  buildLeft() {
    return Container(
      width: 200.w,
      child:Column(
        children: [
          SizedBox(height: 10.h),
          // Text("个人信息",style: PageStyle.ts_333333_18sp,),
          // SizedBox(height: 10.h),
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   onTap: (){
          //     logic.switchIndex(0);
          //   },
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Image.asset(ImageRes.ic_myInfo,height: 50.w,width: 50.w),
          //       SizedBox(height: 5.h),
          //       Text("身份信息"),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 10.h),
          //
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   onTap: (){
          //     logic.switchIndex(1);
          //   },
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Image.asset(ImageRes.ic_tabContactsNor,color: PageStyle.c_418AE5,height: 50.w,width: 50.w),
          //       SizedBox(height: 5.h),
          //       Text("通话记录"),
          //     ],
          //   ),
          // ),
          //
          // SizedBox(height: 10.h),
          //
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   onTap: (){
          //     logic.logout();
          //   },
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Image.asset(ImageRes.ic_logout,height: 50.w,width: 50.w),
          //       SizedBox(height: 5.h),
          //       Text("登出"),
          //       Text("切换账号"),
          //     ],
          //   ),
          // ),

          Container(padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:BorderRadius.all(Radius.circular(3.r)),
                child: Image.network(loginInfo?.headUrl??"",width: 30.h,height: 30.h, errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                    ){
                  return Container();
                },),
              ),
              SizedBox(width: 10.w),
              Text(loginInfo?.realName??"",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
              Padding(padding: EdgeInsets.only(top: 1.h),child: Text(" | ${loginInfo?.job}",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold)),),
            ],
          ),),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              logic.index.value = 0;
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("我的信息",style: TextStyle(fontSize: 12.sp,color: PageStyle.c_333333,fontWeight: FontWeight.bold)),
                  Image.asset(
                    ImageRes.ic_moreArrow,
                    width: 16.w,
                    height: 16.h,
                  )
                ],
              ),
            )
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              logic.index.value = 1;
            },
            child:
            Container(
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("账号设置",style: TextStyle(fontSize: 12.sp,color: PageStyle.c_333333,fontWeight: FontWeight.bold)),
                  Image.asset(
                    ImageRes.ic_moreArrow,
                    width: 16.w,
                    height: 16.h,
                  )
                ],
              ),
            )
          ),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              logic.index.value = 2;
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("关于我们",style: TextStyle(fontSize: 12.sp,color: PageStyle.c_333333,fontWeight: FontWeight.bold)),
                  Image.asset(
                    ImageRes.ic_moreArrow,
                    width: 16.w,
                    height: 16.h,
                  )
                ],
              ),
            )
          ),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              logic.logout();
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("退出登录",style: TextStyle(fontSize: 12.sp,color: PageStyle.c_333333,fontWeight: FontWeight.bold)),
                  Image.asset(
                    ImageRes.ic_moreArrow,
                    width: 16.w,
                    height: 16.h,
                  )
                ],
              ),
            ),
          )
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
            // buildCallLogInfo(context)
            buildAccountSet(),
            buildAboutUs(),
          ],
        )
      ],
    );
  }
  // buildCallLogInfo(BuildContext context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Center(child: MyTabBarView(
  //         fontColor: Colors.black,
  //         index: logic.callIndex.value,
  //         items: [
  //           "所有通话",
  //           "未接通话",
  //         ],
  //         onTap: (i) => logic.switchCallTab(i),
  //       ),),
  //
  //       Container(
  //         constraints: BoxConstraints(maxHeight: 250.h),
  //         child: Padding(
  //         padding: EdgeInsets.only(left: 15.w,right: 15.w),
  //         child: Stack(
  //           children: [
  //             IndexedStack(
  //               index: logic.callIndex.value,
  //               children: [
  //                 _buildAllCallView(context),
  //                 _buildMissCallView(context),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),)
  //       // Text("通话记录",style: PageStyle.ts_333333_18sp,),
  //       // SizedBox(height: 10.h),
  //       // Container(height: 2.w,color: PageStyle.c_e8e8e8,margin: EdgeInsets.fromLTRB(0, 0, 20.h,0)),
  //
  //     ],
  //   );
  // }
  buildPersonInfo() {
    return Padding(padding: EdgeInsets.only(left: 20.w),child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text("个人信息",style: TextStyle(fontSize: 15.sp,color: PageStyle.c_333333,fontWeight: FontWeight.bold),),
        // SizedBox(height: 20.h,),
        // Row(
        //   children: [
        //     Container(
        //       width: 50.w,
        //       child: Text("登录账号"),
        //     ),
        //     SizedBox(width: 10.w),
        //     Container(
        //       color: PageStyle.c_F7F7F7,
        //       width: 300.w,
        //       padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
        //       child: Text("156556222222"),
        //     )
        //   ],
        // ),
        SizedBox(height: 20.h,),
        Row(
          children: [
            Container(
              width: 70.w,
              child: Text("管理员姓名",style: PageStyle.ts_666666_12sp),
            ),
            SizedBox(width: 10.w),
            Container(
              color: PageStyle.c_F7F7F7,
              width: 300.w,
              padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
              child: Text(loginInfo?.realName??"",style: PageStyle.ts_333333_12sp),
            )
          ],
        ),
        SizedBox(height: 20.h,),
        Row(
          children: [
            Container(
              width: 70.w,
              child: Text("所在部门",style: PageStyle.ts_666666_12sp),
            ),
            SizedBox(width: 10.w),
            Container(
              color: PageStyle.c_F7F7F7,
              width: 300.w,
              padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
              child: Text(loginInfo?.departmentName??"",style: PageStyle.ts_333333_12sp),
            )
          ],
        ),
        SizedBox(height: 20.h,),
        Row(
          children: [
            Container(
              width: 70.w,
              child: Text("手机号",style: PageStyle.ts_666666_12sp),
            ),
            SizedBox(width: 10.w),
            Container(
              color: PageStyle.c_F7F7F7,
              width: 300.w,
              padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
              child: Text(loginInfo?.userID??"",style: PageStyle.ts_333333_12sp),
            )
          ],
        )
        // SizedBox(height: 10.h),
        // Container(height: 2.w,color: PageStyle.c_e8e8e8,margin: EdgeInsets.fromLTRB(0, 0, 20.h,0)),
        // SizedBox(height: 10.h),
        // Text("登录账号:${logic.imLogic.userInfo.value.phoneNumber}",style: TextStyle(fontSize: 14.sp),),
        // SizedBox(height: 10.h),
        // Text("管理员姓名:${logic.imLogic.userInfo.value.nickname}",style: TextStyle(fontSize: 14.sp)),
        // SizedBox(height: 10.h),
        // Text("所在部门:",style: TextStyle(fontSize: 14.sp)),
        // SizedBox(height: 10.h),
        // Text("手机号:${logic.imLogic.userInfo.value.phoneNumber}",style: TextStyle(fontSize: 14.sp)),
        // SizedBox(height: 10.h),
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

  buildAboutUs() {
    Get.delete<AboutUsLogic>();
    Get.put<AboutUsLogic>(AboutUsLogic());
    return AboutUsPage();
  }

  buildAccountSet() {
    Get.delete<AccountSetupLogic>();
    Get.put<AccountSetupLogic>(AccountSetupLogic());
    return AccountSetupPage();
  }
}
