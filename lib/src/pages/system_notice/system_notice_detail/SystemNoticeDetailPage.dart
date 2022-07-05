//消息详情
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'SystemNoticeDetailLogic.dart';

class SystemNoticeDetailPage extends StatelessWidget {
   SystemNoticeDetailPage({Key? key}) : super(key: key);

   var logic = Get.find<SystemNoticeDetailLogic>();

  @override
  Widget build(BuildContext context) {
    return
      // Obx(()=>
      Scaffold(
          backgroundColor: PageStyle.c_FFFFFF,
          body: Container(
            height: 1.sh,
            child: Column(
              children: [
                buildHead(),
                Expanded(child: buildContent(context))
              ],
            ),
          )
      );
    // );
  }

  buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(padding: EdgeInsets.all(10.w),
        child: Text("内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......"
            "内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......"
            "内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......"
            "内容......内容......内容......内容......内容......内容......内容......内容......内容......"
            "内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......"
            "内容......内容......内容......内容......内容......内容......内容......内容......内容......内容......"
            ),
      ),
    );
  }

  buildHead() {
    return  Container(
      height: 40.h,
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      decoration: BoxDecoration(
          color: PageStyle.c_FFFFFF,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.15),
              offset: Offset(0, 1),
              spreadRadius: 0,
              blurRadius: 4,
            )
          ]
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Align(
          //     alignment: Alignment.centerLeft,
          //     child: InkWell(child: Padding(child: Image.asset(
          //       ImageRes.ic_back,
          //       width: 12.w,
          //       height: 20.h,
          //     ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w)),onTap: (){
          //       //返回
          //       logic.back();
          //     },
          //     )),
          Align(
            alignment: Alignment.center,
            child:  Text("消息标题",textAlign: TextAlign.center,style: PageStyle.ts_333333_18sp),
          ),
        ],
      ),
    );
  }
}