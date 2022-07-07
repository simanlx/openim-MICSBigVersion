
import 'dart:io';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZhpWebviewLogic extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  var url = "";

  @override
  void onReady() {
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
    url = Get.arguments["url"];
    print("ZhpWebviewLogic"  + url);
    super.onReady();
  }

}
