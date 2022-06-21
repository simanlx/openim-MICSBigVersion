import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/images.dart';

import '../../res/styles.dart';
import 'mine_logic.dart';

class MinePage extends StatelessWidget {


  final logic = Get.find<MineLogic>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: PageStyle.c_FFFFFF,
      body: Obx(()=>Row(
        children: [
          buildLeft(),
          Container(width: 2.w,color: PageStyle.c_e8e8e8,margin: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h)),
          SizedBox(width: 20.w),
          Expanded(child: buildRight())
        ],
      )),
    );
  }

  buildLeft() {
    return Container(
      width: 200.w,
      child:Column(
        children: [
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
                Image.asset(ImageRes.ic_phone,height: 50.w,width: 50.w),
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
                Image.asset(ImageRes.ic_phone,height: 50.w,width: 50.w),
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
                Image.asset(ImageRes.ic_phone,height: 50.w,width: 50.w),
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

  buildRight() {
    return Stack(
      children: [
        IndexedStack(
          index: logic.index.value,
          children: [
            buildPersonInfo(),
            buildCallLogInfo()
          ],
        )
      ],
    );
  }
  buildCallLogInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("通话记录",style: PageStyle.ts_333333_18sp,),
        SizedBox(height: 10.h),
        Container(height: 2.w,color: PageStyle.c_e8e8e8,margin: EdgeInsets.fromLTRB(0, 0, 20.h,0)),

      ],
    );
  }
  buildPersonInfo() {
    return Column(
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
    );
  }
}
