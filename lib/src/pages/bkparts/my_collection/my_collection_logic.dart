import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/models/zskjs/CollectListRes.dart';
import 'package:mics_big_version/src/pages/bkparts/my_collection/my_collection_detail/my_collection_detail_logic.dart';
import 'package:mics_big_version/src/pages/bkparts/my_collection/my_collection_detail/my_collection_detail_view.dart';
import 'package:mics_big_version/src/pages/home/work_bench/work_bench_logic.dart';
import 'package:mics_big_version/src/routes/app_pages.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyCollectionLogic extends GetxController {

  var selPos = 0.obs;
  var showSearch = false.obs;
  var  scrollController = ScrollController();
  var  scrollController2 = ScrollController();

  var titleList = <String>[];

  var smartRefresh = RefreshController();

  var stackList = <Widget>[].obs;

  @override
  void onInit() {
    titleList.add("全部");
    titleList.add("文件");
    titleList.add("图片");
    titleList.add("视频");
    titleList.add("语音");
    titleList.add("聊天");
    titleList.add("已归档");
    titleList.add("患者");
    titleList.add("备忘");
    super.onInit();
  }

  var pageIndex = 1;
  var pageSize = 10;
  var keyword = "";

  @override
  void onReady() {
    getList();
    super.onReady();
  }

  var workbenchLogic = Get.find<WorkbenchLogic>();

  void back() {
    workbenchLogic.toWorkbenchLogicMain();
  }

  void globalSearch() {

  }

  void switchToDetail(Data item){
    stackList.clear();
    Get.delete<MyCollectionDetailLogic>();
    Get.put(MyCollectionDetailLogic(item: item));
    stackList.add(MyCollectionDetailPage());
  }

  var list = <Data>[].obs;

  void getList() {
    Apis.getLikeList("1", pageSize.toString(), keyword, selPos.value).then((value){
      if (value!=null) {
        if (value.data!=null) {
          list.clear();
          list.addAll(value.data!);
          if (list.length>0) {
            switchToDetail(list[0]);
          }
          pageIndex = 1;
        }
      }
      smartRefresh.refreshCompleted(resetFooterState: true);
    });
  }

  void getListMore(){
    Apis.getLikeList((pageIndex+1).toString(), pageSize.toString(), keyword, selPos.value).then((value){
      if (value!=null) {
        if (value.data!=null) {
          pageIndex++;
          list.addAll(value.data!);
          if (value.data!.length<pageSize) {
            smartRefresh.loadNoData();
          }else{
            smartRefresh.loadComplete();
          }
        }
      }
    });
  }

  search(String key) {
    selPos.value = 0;
    list.clear();
    keyword = key;
    getList();
  }

  deleteItem( Data item) {
    Apis.deleteLike(item.id).then((value){
      IMWidget.showToast("删除成功");
      list.remove(item);
    });
  }
}
