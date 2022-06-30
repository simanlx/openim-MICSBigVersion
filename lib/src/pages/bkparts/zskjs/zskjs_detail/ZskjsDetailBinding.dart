

import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/bkparts/zskjs/zskjs_detail/ZskjsDetailLogic.dart';


class ZskjsDetailBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ZskjsDetailLogic());
  }

}