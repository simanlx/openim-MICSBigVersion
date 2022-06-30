

import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/bkparts/zskjs/ZskjsMainLogic.dart';


class ZskjsMainBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ZskjsMainLogic());
  }

}