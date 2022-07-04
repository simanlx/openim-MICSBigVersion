import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sp_util/sp_util.dart';

import '../utils/data_persistence.dart';
import '../utils/http_util.dart';

class Config {
  //初始化全局信息
  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();
    cachePath = (await getApplicationDocumentsDirectory()).path;
    await SpUtil.getInstance();
    await Hive.initFlutter(cachePath);
    // await SpeechToTextUtil.instance.initSpeech();
    HttpUtil.init();
    runApp();
    // // 设置屏幕方向
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    // 状态栏透明（Android）
    var brightness = Platform.isAndroid ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));

    FlutterBugly.init(androidAppId: "4103e474e9", iOSAppId: "28849b1ca6");
  }

  static late String cachePath;

  // static const UI_W = 375.0;
  // static const UI_H = 812.0;

  static const UI_W = 812.0;
  static const UI_H = 375.0;

  /// 秘钥
  static const secret = 'tuoyun';

  /// ip
  static const defaultIp = "101.43.113.42"; //43.128.5.63"; //121.37.25.71 //101.43.113.42(汪群的)
  // static const defaultIp = "https://jialai-voip.raisound.com"; //43.128.5.63"; //121.37.25.71 //101.43.113.42(汪群的)

  /// 服务器IP
  static String serverIp() {
    var ip;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      ip = server['serverIP'];
      print('缓存serverIP: $ip');
    }
    return ip ?? defaultIp;
  }

  /// 登录注册手机验 证服务器地址
  static String appAuthUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['authUrl'];
      print('缓存authUrl: $url');
    }
    return url ?? "http://$defaultIp:10004";
    // return url ?? "https://jialai-voip.raisound.com/demo";
  }

  /// IM sdk api地址
  static String imApiUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['apiUrl'];
      print('缓存apiUrl: $url');
    }
    return url ?? "http://$defaultIp:10002";
    // return url ?? 'https://jialai-voip.raisound.com';
  }

  /// IM ws 地址
  static String imWsUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['wsUrl'];
      print('缓存wsUrl: $url');
    }
    return url ?? 'ws://$defaultIp:10001';
    // return url ?? 'wss://jialai-voip.raisound.com/msg_gateway';
  }

  /// 音视频通话地址
  static String callUrl() {
    var url;
    var server =  DataPersistence.getServerConfig();
    if (null != server) {
      url = server['callUrl'];
      print('缓存callUrl: $url');
    }
    return url ?? 'ws://$defaultIp:7880';
    // return url ?? 'wss://jialai-voip.raisound.com';
  }


  //北科瑞声自己的接口
  static String bkrsApiUrl() {
    return "https://mics-dev.raisound.com/vserver";
  }

  /// 默认公司配置
  static final String deptName = "托云信息技术（成都）有限公司";
  static final String deptID = '0';
}
