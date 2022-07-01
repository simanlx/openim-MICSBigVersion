import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../res/strings.dart';
import '../../res/styles.dart';
import 'splash_logic.dart';

class SplashPage extends StatelessWidget {
  final logic = Get.find<SplashLogic>();

  @override
  Widget build(BuildContext context) {
    return
      // Container(child: Text("启动页"),);
      Material(
      child: Stack(
        children: [
          Positioned(
            top: 200.h,
            width: 812.w,
            child: Center(
              child: Container(
                child: Image.asset(
                  "assets/images/app_mics.png",
                  width: 52.w,
                  height: 53.h,
                ),
              ),
            ),
          ),
          Positioned(
            top: 300.h,
            width: 812.w,
            child: Center(
              child: Text(
                "安全稳定的智能医疗通讯",
                style: PageStyle.ts_333333_16sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
