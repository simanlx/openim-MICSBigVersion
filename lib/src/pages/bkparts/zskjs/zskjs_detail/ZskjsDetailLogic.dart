
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/models/zskjs/ZskjsListContentListItem.dart';
import 'package:mics_big_version/src/models/zskjs/ZskjsListItem.dart';
import 'package:mics_big_version/src/pages/home/work_bench/work_bench_logic.dart';
import 'package:mics_big_version/src/routes/app_navigator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ZskjsDetailLogic extends GetxController{


  @override
  void onReady() {
    super.onReady();
  }
  late ZskjsListContentListItemData item;

  void back() {
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
  }


}