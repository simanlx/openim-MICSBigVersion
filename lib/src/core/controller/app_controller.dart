import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as im;
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../res/strings.dart';
import '../../utils/data_persistence.dart';
import '../../utils/upgrade_manager.dart';

class AppController extends GetxController with UpgradeManger {
  var isRunningBackground = false;
  var backgroundSubject = PublishSubject<bool>();
  var isAppBadgeSupported = false;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final initializationSettingsIOS = IOSInitializationSettings(
      // requestAlertPermission: true,
      // requestBadgePermission: true,
      // requestSoundPermission: true,
      onDidReceiveLocalNotification: (
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {});

  void runningBackground(bool run) {
    print('-----App running background : $run-------------');
    if (isRunningBackground && !run) {
      OpenIM.iMManager.wakeUp();
    }
    isRunningBackground = run;
    backgroundSubject.sink.add(run);
    if (!run) {
      _cancelAllNotifications();
    }
  }

  @override
  void onInit() async {
    _requestPermissions();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
      },
    );
    // _startForegroundService();
    isAppBadgeSupported = await FlutterAppBadger.isAppBadgeSupported();
    super.onInit();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(im.Message message) async {
    if (message.attachedInfoElem?.notSenderNotificationPush == true) {
      return;
    }
    // var id = 0;
    final id = message.seq!;
    // 排除typing消息
    var showing = message.contentType != im.MessageType.typing;

    if (isRunningBackground && showing && Platform.isAndroid) {
      // await getAppInfo();

      // 开启免打扰的不提示
      var sourceID =
          message.sessionType == 1 ? message.sendID : message.groupID;
      if (sourceID != null && message.sessionType != null) {
        var cInfo =
            await OpenIM.iMManager.conversationManager.getOneConversation(
          sourceID: sourceID,
          sessionType: message.sessionType!,
        );
        var status = cInfo.recvMsgOpt;
        var noDisturb = status != 0;
        if (noDisturb) return;
      }

      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'chat', 'OpenIM聊天消息',
          channelDescription: '来自OpenIM的信息',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(id, StrRes.notificationTitle,
          StrRes.notificationBody, platformChannelSpecifics,
          payload: '');
    }
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _startForegroundService() async {
    await getAppInfo();
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'pro', 'OpenIM后台进程',
        channelDescription: '保证app能收到信息',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(
            1, packageInfo!.appName, StrRes.serviceNotificationBody,
            notificationDetails: androidPlatformChannelSpecifics, payload: '');
  }

  Future<void> _stopForegroundService() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.stopForegroundService();
  }

  void showBadge(count) {
    if (isAppBadgeSupported) {
      if (count == 0) {
        removeBadge();
      } else {
        FlutterAppBadger.updateBadgeCount(count);
      }
    }
  }

  void removeBadge() {
    FlutterAppBadger.removeBadge();
  }

  @override
  void onClose() {
    backgroundSubject.close();
    // _stopForegroundService();
    closeSubject();
    super.onClose();
  }

  Locale? getLocale() {
    var local = Get.locale;
    var index = DataPersistence.getLanguage() ?? 0;
    switch (index) {
      case 1:
        local = Locale('zh', 'CN');
        break;
      case 2:
        local = Locale('en', 'US');
        break;
    }
    return local;
  }

  @override
  void onReady() {
    // _startForegroundService();
    _cancelAllNotifications();
    // autoCheckVersionUpgrade();
    super.onReady();
  }
}
