import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_openim_live/flutter_openim_live.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/core/controller/im_controller.dart';
import 'package:mics_big_version/src/models/WebGiveCallBean.dart';
import 'package:mics_big_version/src/utils/data_persistence.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'zhp_webview_logic.dart';
import 'package:webview_flutter/webview_flutter.dart' as aa;

class ZhpWebviewPage extends StatelessWidget {

  final logic = Get.find<ZhpWebviewLogic>();
  final imLogic = Get.find<IMController>();

  var htmlData = '''
  <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script type="text/javascript">
        console.log("js的代码 页面刚出来")
        document.write("直接打印")

        function useNative(){
            console.log("点击了按钮")
            
            if(window.flutter_inappwebview.callHandler){
              window.flutter_inappwebview.callHandler('call',"aaaa");
                 document.getElementById("h1").textContent = "进了上面222"
            }else{
             window.flutter_inappwebview.callHandler('call',setTimeout(function(){}),JSON.stringify("参数"));
              document.getElementById("h1").textContent = "进了下面"
            }
        
        }

        function sum(a,b){
            return a+b;
        }
    </script>
</head>
<body>
    <div>测试交互2222</div>
    <h1 id="h1">原来的内容</h1>
    <button onclick="useNative()">点击调用native方法</button>
</body>
</html>
  
  ''';


  @override
  Widget build(BuildContext context) {
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
          onCreateWindow: (InAppWebViewController controller,
              CreateWindowAction createWindowAction)async{
            // print("InAppWebView 这边接收到的参数是 call onCreateWindow");
            // controller.addJavaScriptHandler(handlerName: "call", callback: (args)async{
            //   print("InAppWebView 这边接收到的参数是 call $args");
            // });
            // controller.javaScriptHandlersMap = {
            //   "":<String>[]
            // };
          },
            onLoadStart: (InAppWebViewController controller, Uri? url){
              controller.addJavaScriptHandler(handlerName: "call", callback: (args){
                if (args.length>0) {
                  try{
                    var arg = args[0];
                    var webGiveCallBean = WebGiveCallBean.fromJson(json.decode(arg.toString()));
                    var uidList = <String>[];
                    webGiveCallBean.callList!.forEach((element) {
                      uidList.add(element.account??"");
                    });
                    //视频通话
                    imLogic.call(
                      uidList.length>1?CallObj.group:CallObj.single,
                      ((webGiveCallBean.type??false)?CallType.video:CallType.audio),
                      null,
                      uidList,
                    );
                  }catch(e){
                    print("呼叫错误 $e");
                  }
                }
              });
            },
            // initialData: InAppWebViewInitialData(data: htmlData),
          initialUrlRequest: URLRequest(url: Uri.parse(Get.arguments["url"])),
            androidOnPermissionRequest:(
                InAppWebViewController controller,
                String origin,
                List<String> resources) async{
              print("webview 请求的权限  ${resources}");
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            }
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
