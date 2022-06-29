import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ChatRecordVoiceViewBkrs extends StatelessWidget {
  const ChatRecordVoiceViewBkrs(
      {Key? key,
        required this.selectedCancelArea,
        required this.selectedSoundToWordArea,
        required this.selectedPressArea,
        required this.showSpeechRecognizing,
        required this.showRecognizeFailed,
        this.onCancel,
        this.onConfirm})
      : super(key: key);

  final bool selectedCancelArea;
  final bool selectedSoundToWordArea;
  final bool selectedPressArea;
  final bool showSpeechRecognizing;
  final bool showRecognizeFailed;
  final Function()? onCancel;
  final Function()? onConfirm;

  // 360.h 360.h 360.h 360.h 541.h 541.h 563.h 563.h 563.h 563.h 576.h 576.h 588.h 588.h 651.h 719.h 最底部

  //80.h 80.h 80.h 80.h 190.h 190.h 260.h 260.h 260.h 260.h 270.h 270.h 280.h 280.h 300.h 350.h  最底部
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF000000).withOpacity(0.6),
      child: Stack(
        children: [
          Positioned(
            top: 30.h,
            left: 220.w,
            width: 100.w,
            child: _selectedPressAreaAnimationView(), //正在录音的动画
          ),
          Positioned(
            top: 30.h,
            left: 29.w,
            child: _selectedCancelAreaAnimationView(),//按住取消时候的 正在录音的动画
          ),
          Positioned(
            top: 170.h,
            left: 35.w,
            child: _unselectedCancelAreaView(), //X  白色
          ),
          Positioned(
            top: 160.h,
            left: 30.w,
            child: _selectedCancelAreaView(), //X 白色
          ),
          Positioned(
            top: 170.h,
            right: 35.w,
            child: _unselectedSoundToWordAreaView(), //文  灰色
          ),
          Positioned(
            top: 160.h,
            right: 30.w,
            child: _selectedSoundToWordAreaView(), //文  白色
          ),
          Positioned(
            top: 160.h,
            right: 30.w,
            child: _recognizingProgressView(), //语音转文字 进行中view
          ),
          Positioned(
            top: 150.h,
            left: 53.w,
            child: _selectedCancelAreaText(), //松开取消
          ),
          Positioned(
            top: 150.h,
            right: 60.w,
            child: _selectedSoundToWordAreaText(), //转文字
          ),
          Positioned(
            top: 240.h,
            left: 0,
            width: 500.w,
            child: _selectedPressAreaReleaseText(), //松开发送
          ),
          Align(
            alignment: Alignment.bottomCenter, //最下面的背景
            child: _bottomBg(),
          ),
          Positioned(
            top: 265.h,
            left: 0,
            width: 500.w,
            child: _speakerIcon(), //speach icon
          ),
          Positioned(
            top: 30.h,
            left: 22.w,
            width: 331.w,
            child: _soundToWordAnimationView(),//语音转文字 正在进行中
          ),
          Positioned(
            top: 190.h,
            left: 54.w,
            child: _cancelSendView(),//取消上面的图片
          ),
          Positioned(
            top: 190.h,
            left: 0,
            child: _confirmSendView(),//发送原语音 上面图片
          ),
          Positioned(
            top: 160.h,
            right: 30.w,
            child: _convertFailBtnView(),  //语音转文字 失败view
          ),
          Positioned(
            top: 30.h,
            left: 65.w,
            child: _convertFailTipsView(), //未识别到文字
          ),
        ],
      ),
    );
  }

  Widget _convertFailBtnView() => Visibility(
    visible: showRecognizeFailed,
    child: ImageUtil.assetImage(
      'ic_voice_convert_fail',
      width: 102.w,
      height: 102.h,
    ),
  );

  Widget _convertFailTipsView() => Visibility(
    visible: showRecognizeFailed,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 400.w,
          height: 95.h,
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 27.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Color(0xFFFA5251),
          ),
          child: Text(
            UILocalizations.convertFailTips,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          width: 331.w,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 60.w),
          child: ClipPath(
            child: Container(
              width: 10.w,
              height: 10.w,
              color: Color(0xFFFA5251),
            ),
            clipper: _ArrowClipper(),
          ),
        )
      ],
    ),
  );

  Widget _cancelSendView() => Visibility(
    visible: showSpeechRecognizing || showRecognizeFailed,
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onCancel,
      child: Column(
        children: [
          ImageUtil.assetImage(
            'ic_voice_cancel',
            width: 18.w,
            height: 24.h,
          ),
          Text(
            UILocalizations.cancelVoiceSend,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
            ),
          )
        ],
      ),
    ),
  );

  Widget _confirmSendView() => Container(
    alignment: Alignment.center,
    width: 375.w,
    child: Visibility(
      visible: showSpeechRecognizing || showRecognizeFailed,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onConfirm,
        child: Column(
          children: [
            ImageUtil.assetImage(
              'ic_voice_confirm',
              width: 24.w,
              height: 24.h,
            ),
            Text(
              UILocalizations.confirmVoiceSend,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    ),
  );

  Widget _recognizingProgressView() => Visibility(
    visible: showSpeechRecognizing,
    child: Container(
      width: 102.w,
      height: 102.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFFFFFFF),
        ),
        child: Center(
          child: SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _bottomBg() => Visibility(
    visible: !showSpeechRecognizing && !showRecognizeFailed,
    child: ImageUtil.assetImage(
      selectedPressArea ? 'ic_voice_record_bg1' : 'ic_voice_record_bg2',
      width: 600.w,
      height: 50.h,
      fit: BoxFit.fill,
    ),
  );

  Widget _speakerIcon() => Visibility(
    visible: !showSpeechRecognizing && !showRecognizeFailed,
    child: Container(
      alignment: Alignment.center,
      child: ImageUtil.assetImage(
        'ic_voice_record_speaker',
        width: 36.w,
        height: 36.h,
        // color: Colors.blue,
      ),
    ),
  );

  Widget _selectedPressAreaReleaseText() => Visibility(
    visible: selectedPressArea,
    child: Text(
      UILocalizations.releaseSend,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFBEBEBE),
        fontSize: 14.sp,
      ),
    ),
  );

  Widget _selectedSoundToWordAreaText() => Visibility(
    visible: selectedSoundToWordArea,
    child: Text(
      UILocalizations.soundToWord,
      style: TextStyle(
        color: Color(0xFFBEBEBE),
        fontSize: 14.sp,
      ),
    ),
  );

  Widget _selectedCancelAreaText() => Visibility(
    visible: selectedCancelArea,
    child: Text(
      UILocalizations.releaseCancel,
      style: TextStyle(
        color: Color(0xFFBEBEBE),
        fontSize: 14.sp,
      ),
    ),
  );

  Widget _selectedSoundToWordAreaView() => Visibility(
    visible: selectedSoundToWordArea,
    child: ImageUtil.assetImage(
      'ic_voice_record_zi_white',
      width: 102.w,
      height: 102.h,
    ),
  );

  Widget _unselectedSoundToWordAreaView() => Visibility(
    visible: !selectedSoundToWordArea,
    child: ImageUtil.assetImage(
      'ic_voice_record_zi_grey',
      width: 82.w,
      height: 82.h,
    ),
  );

  Widget _selectedCancelAreaView() => Visibility(
    visible: selectedCancelArea,
    child: ImageUtil.assetImage(
      'ic_voice_record_cancel_white',
      width: 102.w,
      height: 102.h,
    ),
  );

  Widget _unselectedCancelAreaView() => Visibility(
    visible: !selectedCancelArea &&
        !showSpeechRecognizing &&
        !showRecognizeFailed,
    child: ImageUtil.assetImage(
      'ic_voice_record_cancel_grey',
      width: 82.w,
      height: 82.h,
    ),
  );

  Widget _selectedCancelAreaAnimationView() => Visibility(
    visible: selectedCancelArea,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 95.h,
          width: 104.w,
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 27.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Color(0xFFFA5251),
          ),
          child: Lottie.asset(
            'assets/anim/voice_record.json',
            width: 60.w,
            height: 25.h,
            fit: BoxFit.contain,
            package: 'flutter_openim_widget',
          ),
        ),
        ClipPath(
          child: Container(
            width: 10.w,
            height: 10.w,
            color: Color(0xFFFA5251),
          ),
          clipper: _ArrowClipper(),
        )
      ],
    ),
  );

  Widget _selectedPressAreaAnimationView() => Visibility(
    visible: selectedPressArea,
    child: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 194.w,
            height: 60.h,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 27.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(0xFFFFFFFF),
            ),
            child: Lottie.asset(
              'assets/anim/voice_record.json',
              width: 140.w,
              height: 35.h,
              fit: BoxFit.contain,
              package: 'flutter_openim_widget',
            ),
          ),
          ClipPath(
            child: Container(
              width: 10.w,
              height: 10.w,
              color: Color(0xFFFFFFFF),
            ),
            clipper: _ArrowClipper(),
          )
        ],
      ),
    ),
  );

  Widget _soundToWordAnimationView() => Visibility(
    visible: selectedSoundToWordArea,
    child: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 311.w,
            height: 95.h,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(0xFFFFFFFF),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Lottie.asset(
                    'assets/anim/voice_record.json',
                    width: 45.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                    package: 'flutter_openim_widget',
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    UILocalizations.converting,
                    style: TextStyle(
                      color: Color(0xFFBEBEBE),
                      fontSize: 14.sp,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 311.w,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 50.w),
            child: ClipPath(
              child: Container(
                width: 10.w,
                height: 10.w,
                color: Color(0xFFFFFFFF),
              ),
              clipper: _ArrowClipper(),
            ),
          )
        ],
      ),
    ),
  );
}

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, -2);
    path.lineTo(size.width, -2);
    path.lineTo(size.width / 2, size.height * 2 / 4);

    // path.moveTo(0, size.height);
    // path.lineTo(size.width / 2, size.height / 2);
    // path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
