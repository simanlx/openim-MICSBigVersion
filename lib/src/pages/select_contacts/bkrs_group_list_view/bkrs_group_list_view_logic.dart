import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';

class BkrsGroupListViewLogic extends GetxController {


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  var list = <GroupInfo>[].obs;

  @override
  void onReady() {
    //获取数据
     OpenIM.iMManager.groupManager.getJoinedGroupList().then((value){
      list.assignAll(value);
      });
      super.onReady();
  }

}
