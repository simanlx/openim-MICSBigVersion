import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/models/zskjs/PatientRoomRes.dart';
import 'package:mics_big_version/src/pages/bkparts/patient_manage/patient_manage_logic.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/utils/EventBusBkrs.dart';
import 'package:mics_big_version/src/widgets/bottom_sheet_view.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';

class AddPatientLogic extends GetxController {

  var  a = false.obs;
  var nameController = TextEditingController();
  var genderController = TextEditingController();
  var ageController = TextEditingController();
  var szbcController = TextEditingController();
  var zyhController = TextEditingController();
  var bqjjController = TextEditingController();

  var sex = "男".obs;

  void selectGender() {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            height: 34.h,
            label: StrRes.man,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            onTap: (){
              sex.value = "男";
            },
          ),
          SheetItem(
            height: 34.h,
            label: StrRes.woman,
            onTap: (){
              sex.value = "女";
            },
          ),
        ],
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
  }

  PatientRoomRes? selRoom;

  var patientRoomStr = "".obs;
  void showRoomList(){
    Get.dialog(Center(child: Container(margin: EdgeInsets.symmetric(horizontal: 240.w),width: 1.sw,height: 150.h,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.r)),child: ListView.builder(itemBuilder: (BuildContext context,int index){
        var item =  roomList[index];
        return Row(children: [InkWell(child: Padding(padding: EdgeInsets.all(8.w),child: Text(item.name??""),),onTap: (){
          selRoom = item;
          patientRoomStr.value = item.name??"";
          Get.back();
        },)],mainAxisAlignment: MainAxisAlignment.center,);
      },itemCount: roomList.length,),),));
  }

  var roomList = <PatientRoomRes>[];

  @override
  void onReady() {
    //获取列表
    Apis.getPatientRoomList().then((value){
      if (value!=null) {
        roomList.addAll(value);
      }
    });
  }

  void back() {
    Get.back();
  }

  var patientManageLogic = Get.find<PatientManageLogic>();

  //添加患者
  void addPatient() {
    if (verifyInput()) {
      //发送请求
      var nameStr = nameController.text;
      var ageStr = ageController.text;
      var szbcStr = szbcController.text;
      var zyhStr = zyhController.text;
      var bqjjStr = bqjjController.text;

      Apis.addPatient(nameStr, sex.value, ageStr, zyhStr, szbcStr, bqjjStr, "",selRoom!.id.toString()).then((value){
        IMWidget.showToast("保存成功");
        busBkrs.emit("updatePatientManage","");
        // Get.back();
        patientManageLogic.toMain();
      });
    }
  }


  bool verifyInput(){
    var nameStr = nameController.text;
    var ageStr = ageController.text;
    var szbcStr = szbcController.text;
    var zyhStr = zyhController.text;
    var bqjjStr = bqjjController.text;

    if(nameStr.isEmpty){
      IMWidget.showToast("请输入姓名");
      return false;
    }

    if(ageStr.isEmpty){
      IMWidget.showToast("请输入年龄");
      return false;
    }

    if(patientRoomStr.isEmpty){
      IMWidget.showToast("请选择所在病房");
      return false;
    }

    // if(szbcStr.isEmpty){
    //   IMWidget.showToast("请输入所在病床");
    //   return false;
    // }


    if(zyhStr.isEmpty){
      IMWidget.showToast("请输入住院号");
      return false;
    }

    // if(bqjjStr.isEmpty){
    //   IMWidget.showToast("请输入病情简介");
    //   return false;
    // }

    return true;
  }
}
