
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_live/flutter_openim_live.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:mics_big_version/src/core/controller/SpeechServiceController.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common/apis.dart';
import '../../core/controller/im_controller.dart';
import '../im_widget.dart';

class SpeechListeningWidget extends StatefulWidget {
  const SpeechListeningWidget({Key? key}) : super(key: key);

  @override
  State<SpeechListeningWidget> createState() => _SpeechListeningWidgetState();
}

class _SpeechListeningWidgetState extends State<SpeechListeningWidget> with TickerProviderStateMixin {

  var imLogic = Get.find<IMController>();
  final logic = Get.find<SpeechServiceController>();
  late final AnimationController _controller;
  late Animation<int> _animation;

  var start = 0.1;
  var stop = 0.5;
  @override
  void initState() {

    _controller = AnimationController(vsync: this)
      ..value = 0.5
    ..addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return GestureDetector(

      onLongPressStart: (LongPressStartDetails details) async{
        //检查权限
        var status = await Permission.microphone.status;
        _controller.forward();
        _controller.repeat(min: start,max: stop,period: _controller.duration! * (stop - start));
        if(status.isGranted){
          logic.startRecord();
        }else{
          IMWidget.showToast("请打开麦克风权限");
        }
      },

      onLongPressEnd: (LongPressEndDetails details){
        print("长按结束");
        _controller.value = 0;
        _controller.stop();
        logic.stopRecord();
      },
      child:
      Lottie.asset('assets/anim/voice_state.json',repeat: true,animate: true,onLoaded: (LottieComposition lo){
        _controller.duration = lo.duration;
        _controller.value = 0;
      },controller: _controller,height: 150.w,width: 150.w),
    );
  }
}
