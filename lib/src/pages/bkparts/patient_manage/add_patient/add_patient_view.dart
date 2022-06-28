import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/OverScrollBehavior.dart';

import 'add_patient_logic.dart';

class AddPatientPage extends StatelessWidget {

  final logic = Get.find<AddPatientLogic>();
  
  @override
  Widget build(BuildContext context) {
    
    return

      Obx(()=>
          Scaffold(
              backgroundColor: PageStyle.c_FFFFFF,
              body: Container(
                height: 800.h,
                child: Column(
                  children: [
                    buildHead(),
                    Expanded(child: SingleChildScrollView(child: buildList()))
                  ],
                ),
              )
          )
      );
  }

  Widget buildHead(){
    return  Container(
      height: 40.h,
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 5.h),
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
              ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w),),onTap: (){
                //返回
                // logic.back();
              },
              )),
          Align(
            alignment: Alignment.center,
            child:  Text("新添患者",textAlign: TextAlign.center,style: PageStyle.ts_333333_16sp),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(onTap:logic.addPatient,
                    child: Container(child: Padding(padding:EdgeInsets.fromLTRB(10.w,4.w,10.w,4.w),child: Text("确认",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),),decoration: BoxDecoration(
                        color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5.r),))))
              ],
            ),
          )
        ],
      ),
    );
  }

  buildList() {
    return ScrollConfiguration( behavior: OverScrollBehavior(),child: SingleChildScrollView(
        child:Column(
          children: [
            Container(
              height: 40.h,
              child:
              Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                child: Row(children: [
                  Text("姓名"),
                  Expanded(child: TextField(maxLength: 10,textAlign: TextAlign.end,controller: logic.nameController,decoration: InputDecoration(hintText: "请输入姓名",counterText: "",border: InputBorder.none,),),),
                  Icon(Icons.keyboard_arrow_right_sharp)
                ],),
              ),
            ),

            Divider(height: 2.h,color: PageStyle.c_e8e8e8),

            Container(
              height: 40.h,
              child:
              Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                child:
                Row(children: [
                  Text("性别"),
                  Expanded(child: InkWell(child: Text(logic.sex.value,textAlign:TextAlign.end,),onTap: logic.selectGender,),),
                  Icon(Icons.keyboard_arrow_right_sharp)
                ],),
              ),
            ),



            Divider(height: 2.h,color: PageStyle.c_e8e8e8),
            Container(
              height: 40.h,
              child:
              Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                child: Row(children: [
                  Text("年龄"),
                  Expanded(child:TextField(keyboardType:TextInputType.number,inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],textAlign: TextAlign.end,controller: logic.ageController,decoration: InputDecoration(hintText: "请输入年龄",border: InputBorder.none))),
                  // Text("57",style:TextStyle(color: Colors.grey)),
                  Icon(Icons.keyboard_arrow_right_sharp)
                ],),
              ),
            ),


            Divider(height: 2.h,color: PageStyle.c_e8e8e8),

            Container(
              height: 40.h,
              child:
              Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                child: Row(children: [
                  Text("所在病房"),
                  Expanded(child: InkWell(child: Text(logic.patientRoomStr.value,textAlign:TextAlign.end,),onTap: logic.showRoomList),),
                  Icon(Icons.keyboard_arrow_right_sharp)
                ],),
              ),
            ),


            Divider(height: 2.h,color: PageStyle.c_e8e8e8),
            Container(
              height: 40.h,
              child:
              Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                child: Row(children: [
                  Text("所在病床"),
                  Expanded(child:TextField(textAlign: TextAlign.end,controller: logic.szbcController,decoration: InputDecoration(hintText: "请输入所在病床",border: InputBorder.none))),
                  Icon(Icons.keyboard_arrow_right_sharp)
                ],),
              ),
            ),

            Divider(height: 2.h,color: PageStyle.c_e8e8e8),
            Container(
              height: 40.h,
              child:
              Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                child: Row(children: [
                  Text("住院号"),
                  Expanded(child:TextField(textAlign: TextAlign.end,controller: logic.zyhController,decoration: InputDecoration(hintText: "请输入住院号",border: InputBorder.none))),
                  Icon(Icons.keyboard_arrow_right_sharp)
                ],),
              ),
            ),
            Divider(height: 2.h,color: PageStyle.c_e8e8e8),

            Container(
              child:
              Padding(padding: EdgeInsets.fromLTRB(20.w,10.w, 20.w, 10.w),
                child:Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("病情简介"),
                    SizedBox(width: 20.w),
                    Expanded(child:TextField(maxLines:2,textAlign: TextAlign.end,controller: logic.bqjjController,decoration: InputDecoration(hintText: "请输入病情简介",border: InputBorder.none))),
                    Icon(Icons.keyboard_arrow_right_sharp)
                  ],),
              ),
            ),
          ],
        )));
    // return Expanded(child:
    //
    //
    // );
  }
}
