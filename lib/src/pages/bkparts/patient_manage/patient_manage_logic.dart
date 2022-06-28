import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/models/zskjs/PatientListRes.dart';
import 'package:mics_big_version/src/models/zskjs/PatientRoomRes.dart';
import 'package:mics_big_version/src/pages/bkparts/patient_manage/add_patient/add_patient_logic.dart';
import 'package:mics_big_version/src/pages/bkparts/patient_manage/add_patient/add_patient_view.dart';
import 'package:mics_big_version/src/pages/bkparts/patient_manage/patient_detail/patient_detail_logic.dart';
import 'package:mics_big_version/src/pages/bkparts/patient_manage/patient_detail/patient_detail_view.dart';
import 'package:mics_big_version/src/pages/home/work_bench/work_bench_logic.dart';
import 'package:mics_big_version/src/utils/EventBusBkrs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PatientManageLogic extends GetxController {

  var stackList = <Widget>[].obs;

  var refreshController = RefreshController();

  var showSearch = false.obs;

  void onLoading() {
    Apis.getPatientList(pageIndex+1,pageSize,keyword,hospitalized,patient_room_id).then((value){
      if(value!=null && value.data!=null){
        list.addAll(value.data!);
        if (value.data!.length>0) {
          pageIndex++;
        }
        if (value.data!.length<pageSize) {
          refreshController.loadNoData();
        }else{
          refreshController.loadComplete();
        }
      }
    });
  }

  var list = <PatientListResData>[].obs;

  var pageIndex = 1;
  var pageSize = 10;


  var hospitalized = "";
  var patient_room_id = "";
  var patient_room_name = "";

  var keyword = "";

  void search(String value) {
    keyword = value;
    getList(value,hospitalized,patient_room_id);
  }

  EventCallback? callback;

  @override
  void onReady() {
    //获取列表
    EasyLoading.show(status: "加载中");
    getList("",hospitalized,patient_room_id,isFirstLoad: true);
    getRoomList();

    callback = (args){
      getList("",hospitalized,patient_room_id);
      getRoomList();
    };
    busBkrs.on("updatePatientManage",callback!);
    //加入资源
    super.onReady();
  }


  void switchToDetail(PatientListResData item) {
    stackList.clear();
    Get.delete<PatientDetailLogic>();
    Get.put<PatientDetailLogic>(PatientDetailLogic());
    var patientPage = PatientDetailPage(key: UniqueKey(),id: item.id.toString());
    stackList.add(patientPage);
  }

  void getList(String word,String hospitalized,String patient_room,{bool isFirstLoad = false}){
    pageIndex = 1;
    Apis.getPatientList(pageIndex,pageSize,word,hospitalized,patient_room).then((value){
      EasyLoading.dismiss(animation: true);
      if(value!=null && value.data!=null){
        list.clear();
        list.addAll(value.data!);
        if (isFirstLoad) {
          if (value.data!.length>0) {
            switchToDetail(value.data![0]);
          }
        }
      }
      refreshController.refreshCompleted(resetFooterState: true);
    });
  }

  var roomList = <PatientRoomRes>[];

  void getRoomList() {
    Apis.getPatientRoomList().then((value){
      if (value!=null) {
        roomList.clear();
        roomList.insert(0,PatientRoomRes(id: 9999999,name: "全部"));
        roomList.addAll(value);
      }
    });
  }

  void onRefresh() {
    getList(keyword,hospitalized,patient_room_id);
  }

  var workbenchLogic = Get.find<WorkbenchLogic>();

  void back() {
    workbenchLogic.toWorkbenchLogicMain();
  }

  void addPatient() {
    stackList.clear();
    Get.delete<AddPatientLogic>();
    Get.put(AddPatientLogic());
    stackList.add(AddPatientPage());
  }

  void toMain() {
    stackList.clear();
  }



}
