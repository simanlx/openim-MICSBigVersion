

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/home/work_bench/work_bench_logic.dart';
import 'package:mics_big_version/src/pages/system_notice/system_notice_detail/SystemNoticeDetailLogic.dart';
import 'package:mics_big_version/src/pages/system_notice/system_notice_detail/SystemNoticeDetailPage.dart';


class SystemNoticeListLogic extends GetxController {

  var stackList = <Widget>[].obs;


  var workbenchLogic = Get.find<WorkbenchLogic>();

  void back() {
    workbenchLogic.toWorkbenchLogicMain();
  }

  @override
  void onReady() {
    super.onReady();
    stackList.clear();
    Get.delete<SystemNoticeDetailLogic>();
    Get.put(SystemNoticeDetailLogic());
    stackList.add(SystemNoticeDetailPage());
  }

  void toDetail() {
    // Get.toNamed(AppRoutes.SYSTEM_NOTICE_DETAIL);
  }
}
