import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/utils/data_persistence.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'zhp_webview_logic.dart';
import 'package:webview_flutter/webview_flutter.dart' as aa;

class ZhpWebviewPage extends StatelessWidget {

  final logic = Get.find<ZhpWebviewLogic>();

  @override
  Widget build(BuildContext context) {
    var data = {

    };
    var token = DataPersistence.getLoginCertificate()!.token;
    // json.codeUnits;
    return Scaffold(
      // appBar: EnterpriseTitleBar.back(
      //   onTap: (){
      //     Get.back();
      //   },
      // ),
      body:
        InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse("https://ting.raisound.com/mics?token=${token}")
          )
        )
        // aa.WebView(
        //   initialUrl: "https://ting.raisound.com/mics",
        //
        // )
      // WebView(
      //   initialUrl: "https://ting.raisound.com/mics",
      //   // initialUrl: "https://www.baidu.com",
      // ),
    );
  }
}
