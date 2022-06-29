import 'package:get/get.dart';

import 'zhp_webview_logic.dart';

class ZhpWebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ZhpWebviewLogic());
  }
}
