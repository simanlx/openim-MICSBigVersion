import 'package:azlistview/azlistview.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/models/zskjs/DepartFriendListRes.dart';

class DepartListFriendLogic extends GetxController {

  var aa = "".obs;

  var departName = "";
  var departmentId = "";

  searchFriend() {

  }

  DepartListFriendLogic({this.departName = "",this.departmentId = ""});

  @override
  void onInit() {
    super.onInit();
  }


  var list = <DepartFriendListRes>[].obs;

  @override
  void onReady() {
    Apis.getDepartFriend(departmentId).then((value){
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
