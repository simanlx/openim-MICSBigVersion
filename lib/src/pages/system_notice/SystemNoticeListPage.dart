

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mics_big_version/src/pages/system_notice/SystemNoticeListLogic.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';

class SystemNoticeListPage extends StatelessWidget {

  SystemNoticeListPage({Key? key}) : super(key: key);
  var logic = Get.find<SystemNoticeListLogic>();

  @override
  Widget build(BuildContext context) {
    return

      // Obx(()=>
      // Scaffold(
      //     backgroundColor: PageStyle.c_FFFFFF,
      //     body: Container(
      //       height: 1.sh,
      //       child: Column(
      //         children: [
      //           buildHead(),
      //           Expanded(child: buildContent(context))
      //         ],
      //       ),
      //     )
      // );


    // Obx(()=>
        Scaffold(
            backgroundColor: PageStyle.c_FFFFFF,
            body: Row(
              children: [
                Container(
                  height: 1.sh,
                  width: 280.w,
                  child: Column(
                    children: [
                      buildHead(),
                      Expanded(child: buildContent(context))
                    ],
                  ),
                ),
                Container(width: 2.w,color: PageStyle.c_e8e8e8,),
                Expanded(child: Obx(()=>Column(
                  children: [
                    Expanded(child: Stack(
                      children: [
                        if(logic.stackList.length>0)
                        // logic.stackList.value[logic.stackList.length-1]
                          Obx(()=>logic.stackList.value[logic.stackList.length-1])
                      ],
                    ))
                  ],
                )))
              ],
            )
        );
    // );
  }


  Widget buildHead() {

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
          Align(
              alignment: Alignment.centerLeft,
              child: InkWell(child: Padding(child: Image.asset(
                ImageRes.ic_back,
                width: 12.w,
                height: 20.h,
              ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w)),onTap: (){
                //返回
                logic.back();
              },
              )),
          Align(
            alignment: Alignment.center,
            child:  Text(StrRes.noticeList,textAlign: TextAlign.center,style: PageStyle.ts_333333_18sp),
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       TitleImageButton(
          //         imageStr: ImageRes.ic_searchGrey,
          //         imageWidth: 24.w,
          //         imageHeight: 24.h,
          //         color: Color(0xFF333333),
          //         onTap: (){
          //           logic.showSearch.value = true;
          //         },
          //       ),
          //       TitleImageButton(
          //         imageStr: ImageRes.ic_addBlack,
          //         imageWidth: 24.w,
          //         imageHeight: 24.h,
          //         color: Color(0xFF333333),
          //         onTap: (){
          //           logic.addPatient();
          //         },
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  buildContent(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child:
        ListView.builder(itemCount: 1,itemBuilder: (BuildContext context,int index){
          return InkWell(
            onTap: logic.toDetail,
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SizedBox(width: 10.h),
                    Container(height: 10.w,width: 10.w,decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(10.r)))),
                    SizedBox(width: 10.h),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text("标题",maxLines: 1,
                              style: TextStyle(overflow: TextOverflow.ellipsis,color: PageStyle.c_333333),),),
                            Text("2022-10-12 16:22:14",textAlign: TextAlign.center,),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text("文本内容",maxLines: 1,
                            style: TextStyle(overflow: TextOverflow.ellipsis,color: PageStyle.c_999999)),
                      ],
                    ),),
                    Icon(Icons.arrow_forward_ios_rounded),
                    SizedBox(width: 10.h),
                  ],),
                SizedBox(height: 5.h),
                Divider(height: 2.h,color: PageStyle.c_e8e8e8,)
              ],
            ),
          );
        })
    );
  }
}
