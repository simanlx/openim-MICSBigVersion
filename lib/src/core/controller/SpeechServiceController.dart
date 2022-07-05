
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_openim_live/flutter_openim_live.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mics_big_version/src/pages/home/contacts/contacts_logic.dart';
import 'package:mics_big_version/src/pages/home/home_logic.dart';
import 'package:mics_big_version/src/pages/home/work_bench/work_bench_logic.dart';
import 'package:mics_big_version/src/utils/ChannelManage.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/apis.dart';
import '../../routes/app_navigator.dart';
import '../../routes/app_pages.dart';
import 'im_controller.dart';

class SpeechServiceController extends GetxController{


  var speechText = "".obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

  }
  
  @override
  void onInit() {
    audioPlayer = AudioPlayer(
      // Handle audio_session events ourselves for the purpose of this demo.
      handleInterruptions: false,
      // androidApplyAudioAttributes: false,
      // handleAudioSessionActivation: false,
    );


    ChannelManage().eventChannel.receiveBroadcastStream().listen((event) {
      try{
        var workLogic = Get.find<WorkbenchLogic>();
        final homeLogic = Get.find<HomeLogic>();
        speechText.value = event.toString().trim();
        if(speechText.value.startsWith("呼叫")
            ||speechText.value.startsWith("语音呼叫") || speechText.value.startsWith("视频呼叫")){
          //上传接口
          var index = 0;
          if (speechText.value.contains("语音呼叫")) {
            index = 0;
          }else if(speechText.value.contains("视频呼叫")){
            index = 1;
          }

          var finalText = speechText.replaceAll("语音呼叫", "").replaceAll("视频呼叫", "").replaceAll("呼叫", "").replaceAll(",", "").replaceAll("。", "");
          if (finalText.trim().length == 0) {
            return;
          }
          Apis.userMatch(finalText).then((value){
            if (value == null) {
              IMWidget.showToast("没有找到联系人 $finalText");
            }else{
              //打电话
              imLogic.call(
                CallObj.single,
                index == 0 ? CallType.audio : CallType.video,
                null,
                ["${value.account}"],
              );
            }
          });

        }else if(speechText.value.startsWith("新建医疗备忘")){
          if (homeLogic.index!=0) {
            homeLogic.switchTab(0);
          }
          workLogic.skipYlbw(autoAdd: true);
        }else if(speechText.value.startsWith("新建语音备忘")){
          if (homeLogic.index!=0) {
            homeLogic.switchTab(0);
          }
          workLogic.skipYlbw(autoAddAndRecord: true);
        }else if(speechText.value.startsWith("打开系统通知")){
          if (homeLogic.index!=0) {
            homeLogic.switchTab(0);
          }
          workLogic.skipXttz();
        }else if(speechText.value.startsWith("打开通讯录")){
          final logic = Get.find<ContactsLogic>();
          if (homeLogic.index!=2) {
            homeLogic.switchTab(2);
          }
          logic.showDepartPage("","深圳市人民医院");
        }else if(speechText.value.startsWith("打开医疗备忘")){
          if (homeLogic.index!=0) {
            homeLogic.switchTab(0);
          }
          workLogic.skipYlbw();
        }else if(speechText.value.startsWith("打开患者管理")){
          if (homeLogic.index!=0) {
            homeLogic.switchTab(0);
          }
          workLogic.skipHzgl();
        }else if(speechText.value.startsWith("打开收藏")){
          if (homeLogic.index!=0) {
            homeLogic.switchTab(0);
          }
          workLogic.skipWdsc();
        }else{
          IMWidget.showToast("不能识别的指令 ${speechText.value}");
        }
        speechText.value = "";
      }catch(e){

      }

    });
    super.onInit();
  }
  
  //开启服务
  void startSpeechService(){
    ChannelManage().methodChannel.invokeMethod("start_speech_service").then((value){
      IMWidget.showToast(value);
    });
  }
  
  //初始化SDK
  void initSpeechSdk(){
    ChannelManage().methodChannel.invokeMethod("init_speech").then((value){
      print("initSpeechSdk成功"+value.toString());
      IMWidget.showToast(value);
    },onError: (obj){
      print("initSpeechSdk错误"+obj.toString());
    });
  }


  AudioPlayer? audioPlayer;


  void startRecord() {
    //开启提示音频
    audioPlayer?.stop();
    audioPlayer?.setAsset("assets/audio/listen_start.wav");
    // audioPlayer?.setLoopMode(LoopMode.off);
    audioPlayer?.setVolume(1.0);
    audioPlayer?.play();
    ChannelManage().methodChannel.invokeMethod("start_speech_record").then((value){
      print("方方 start_speech_record");
    });

  }
  void stopRecord() {

    ChannelManage().methodChannel.invokeMethod("stop_speech_record").then((value){
      print("方方 stop_speech_record");
    });
  }
  final imLogic = Get.find<IMController>();
  void callFang() {

    imLogic.call(
      CallObj.single,
      CallType.audio,
      // index == 0 ? CallType.audio : CallType.video,
      null,
      ["13965823802"],
    );

  }

  void stopService() {
    ChannelManage().methodChannel.invokeMethod("stop_speech_service").then((value){

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer?.stop();
    audioPlayer = null;
    super.dispose();
  }

}