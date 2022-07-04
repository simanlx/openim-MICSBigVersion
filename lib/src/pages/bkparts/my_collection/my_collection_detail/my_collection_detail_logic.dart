import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mics_big_version/src/models/zskjs/CollectListRes.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';

class MyCollectionDetailLogic extends GetxController {

  late Data item;
  late Rx<Data> itemTest;
  var isVideoPlaying = false.obs;
  var isPlayingUrl = "".obs;
  var playSecond = 0.obs;
  var audioPlayer = AudioPlayer(
    // Handle audio_session events ourselves for the purpose of this demo.
    handleInterruptions: false,
    // androidApplyAudioAttributes: false,
    // handleAudioSessionActivation: false,
  );

  var title = "".obs;

  @override
  void onClose() {
    if(audioPlayer.playing){
      audioPlayer.stop();
    }
    super.onClose();
  }

  MyCollectionDetailLogic({item:Data}){
    this.item = item;
  }

  @override
  void onInit() {
    super.onInit();
    // item = Get.arguments["item"];
    switch(item.type){
      case 1:
      case 4:
        title.value = "详情";
        break;
      case 2:
        title.value = "语音";
        break;
      case 3:
        title.value = "文件";
        break;
      case 5:
        title.value = "视频";
        break;
      case 6:
        title.value = "患者档案";
        break;
      case 8:
        title.value = "医疗备忘";
        break;
    }
  }

  void back() {
    Get.back();
  }

  //下载
  void downloadFile() async {
    var url = item.content?.file_path ?? "";
    var fileName = item.content?.file_name ?? "";
    Dio dio = Dio();
    var cachePath =
        '${(await getTemporaryDirectory()).path}/$fileName';
    print('cachePath:$cachePath');

    IMWidget.showToast("正在下载,请稍候...");
    await dio.download(
        url,
        cachePath,
        options: Options(receiveTimeout: 60 * 1000),
        cancelToken: CancelToken(),
        onReceiveProgress: (int count, int total) async {
          if (count == total) {
            IMWidget.showToast(sprintf(StrRes.fileSaveToPath, [cachePath]));
          }
        });
  }
}
