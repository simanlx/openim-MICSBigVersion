
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/models/zskjs/ZskjsListContentListItem.dart';
import 'package:mics_big_version/src/models/zskjs/ZskjsListItem.dart';
import 'package:mics_big_version/src/pages/bkparts/zskjs/zskjs_detail/ZskjsDetailPage.dart';
import 'package:mics_big_version/src/pages/home/work_bench/work_bench_logic.dart';
import 'package:mics_big_version/src/routes/app_navigator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ZskjsMainLogic extends GetxController{

  var stackList = <Widget>[].obs;

  var showSearch = false.obs;

  var workbenchLogic = Get.find<WorkbenchLogic>();

  void back() {
    workbenchLogic.toWorkbenchLogicMain();
  }
  final refreshController = RefreshController(initialRefresh: false);

  var titleList = <ZskjsListItem>[].obs;
  var secondList = <ZskjsListContentListItemData>[].obs;

  var selPos = 0.obs;

  var  scrollController = ScrollController();
  var  scrollController2 = ScrollController();


  @override
  void onReady() {
    getList();
    super.onReady();
  }


  var pageIndex = 1;
  var pageSize = 10;


  void getList() async{
    var res =await Apis.getZskjsList();
    if(res!=null){
      titleList.clear();
      titleList.add(ZskjsListItem(name: "全部"));
      titleList.addAll(res);
      //自动获取第一个标签列表
      getLisById("");
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  void getLisById(String keyWord) async{
    var typeId = (titleList[selPos.value].id == null?"":titleList[selPos.value].id.toString());
    pageIndex = 1;
    var seList = await Apis.getZskjsListByFilter(1, pageSize, keyWord, typeId);
    print("seList  $seList");
    if (seList != null && seList.data!=null) {
      var realData = seList.data as List<ZskjsListContentListItemData>;
      secondList.clear();
      secondList.addAll(realData);
      //自动获取第一个内容
      if (secondList.length>0) {
        changeContentTo(secondList[0]);
      }
    }
    refreshController.refreshCompleted(resetFooterState: true);
  }

  void getLisByIdMore(String keyWord) async{
    var typeId = titleList[selPos.value].id??0;
    var seList = await Apis.getZskjsListByFilter(pageIndex+1, pageSize, keyWord, typeId.toString());
    if (seList != null && seList.data!=null && seList.data!.length>0) {
      var realData = seList.data as List<ZskjsListContentListItemData>;
      pageIndex++;
      secondList.addAll(realData);
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }



  void onLoad() async{
    //加载更多
    getLisByIdMore("");
  }

  void onRefresh() async{
    //刷新
    getLisById("");
    // print("下拉刷新");
  }

  // void skipDetail(ZskjsListContentListItemData item) {
  //   AppNavigator.startZskjsDetail(data: item);
  // }

  void changeContentTo(ZskjsListContentListItemData secondList) {
    stackList.clear();
    stackList.add(ZskjsDetailPage(key: UniqueKey(),item: secondList));
  }

}