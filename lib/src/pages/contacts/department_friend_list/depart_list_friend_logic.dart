import 'package:azlistview/azlistview.dart';
import 'package:get/get.dart';

import '../../../common/apis.dart';
import '../../../models/zskjs/DepartFriendListRes.dart';

class DepartListFriendLogic extends GetxController {

  var aa = "".obs;

  var departName = "";
  var departmentId = "";

  searchFriend() {

  }

  DepartListFriendLogic({this.departName = "",this.departmentId = ""});

  @override
  void onInit() {
    // departName = Get.arguments["departmentName"];
    print("看一下数据 $departName  $departmentId");
    super.onInit();
  }


  var list = <DepartFriendListRes>[].obs;

  @override
  void onReady() {
    // var departmentId = Get.arguments["departmentId"];
    Apis.getDepartFriend(departmentId).then((value){
      print("拿到数据了 $value");
      if (value!=null) {
        list.clear();
        list.addAll(value);
        // A-Z sort.
        SuspensionUtil.sortListBySuspensionTag(list);

        // show sus tag.
        SuspensionUtil.setShowSuspensionStatus(list);
      }
    });
    super.onReady();
  }

}
