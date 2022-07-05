

//消息详情
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'SystemNoticeDetailLogic.dart';

class SystemNoticeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SystemNoticeDetailLogic());
  }
}
