import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/models/zskjs/YlbwListBean.dart';
import 'package:mics_big_version/src/pages/home/work_bench/work_bench_logic.dart';
import 'package:mics_big_version/src/pages/ylbw/ylbw_main/ylbw_detail/MedicalMemoDetailPage.dart';
import 'package:mics_big_version/src/utils/EventBusBkrs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class YlbwMainLogic extends GetxController {

  var stackList = <Widget>[].obs;


  var showSearch = false.obs;
  var nickname = "".obs;
  var keyword = "";

  var controller = RefreshController();

  var workbenchLogic = Get.find<WorkbenchLogic>();

  void back() {
    workbenchLogic.toWorkbenchLogicMain();
  }

  var pageIndex = 1;
  var pageSize = 10;

  EventCallback? callback;

  var isLoaded = false;

  @override
  void onReady() async{
    //调用接口获取列表
    getList("",isFirstLoad: true);
    var a = await OpenIM.iMManager.userManager.getSelfUserInfo();
    nickname.value = a.nickname??"";
    callback = (arg){
      getList("");
    };
    busBkrs.on("updateYlbw",callback!);
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var list = <YlbwListBeanData>[].obs;
  var allCount = 0.obs;

  void getList(String type_id,{bool isFirstLoad = false}) async{
    pageIndex = 1;
    await Apis.getYlbwList(pageIndex,pageSize,keyword,type_id).then((value) => {
      isLoaded = true,
      if(value!=null && value.data!=null){
        allCount.value =  value.total??0,
        list.clear(),
        list.addAll(value.data!),
        if(value.data!.length>0 && isFirstLoad){
          toDetail(value.data![0])
        }
      }
    });
    controller.refreshCompleted(resetFooterState: true);
  }

  void getMore(String type_id) async{
    await Apis.getYlbwList(pageIndex+1,pageSize,keyword,type_id).then((value) => {
      if(value!=null && value.data!=null){
        allCount.value =  value.total??0,
        if (value.data!.length>0) {
          pageIndex++,
          list.addAll(value.data!),
        },
        print("这是结果 ${list.length}"),
        if (value.data!.length<pageSize) {
          controller.loadNoData()
        }else{
          controller.loadComplete()
        }
      },
    });
  }


  void globalSearch() {

  }

  void toAdd(){
    stackList.clear();
    stackList.add(new MedicalMemoDetailPage(key: UniqueKey()));
  }

  void toDetail(YlbwListBeanData item) {
    stackList.clear();
    stackList.add(new MedicalMemoDetailPage(key: UniqueKey(),rawData: item));
  }
  deleteItem(YlbwListBeanData info) {
    print("删除第一个info ${info.id}");
    Apis.removeYlbw(info.id.toString()).then((value){
      //删除成功
      list.remove(info);
      allCount--;
    });
  }


}
