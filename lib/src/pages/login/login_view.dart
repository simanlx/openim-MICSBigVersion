import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../widgets/button.dart';
import '../../widgets/debounce_button.dart';
import '../../widgets/pwd_input_box.dart';
import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logic = Get.find<LoginLogic>();

    return  Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Container(
          width: 200.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // onDoubleTap: () => logic.toServerConfig(),
              // Image.asset(
              //   "assets/images/app_mics.png",
              //   width: 52.w,
              //   height: 53.h,
              // ),
              GestureDetector(
                onDoubleTap: () => logic.toServerConfig(),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  "深圳市人民医院MICS",
                  style: TextStyle(fontSize: 18.sp),
                ),
              ),
              SizedBox(height: 20.h),
              Row(children: [
                Text(
                  "账号",
                  style: PageStyle.ts_333333_12sp,
                )
              ],),
              TextField(
                controller: logic.phoneCtrl,
                decoration: InputDecoration(
                  hintText: "请输入手机号",
                  hintStyle: PageStyle.ts_333333_opacity40p_12sp,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                  // FilteringTextInputFormatter.digitsOnly
                ],

                maxLength: 11,),
              SizedBox(height: 20.h),
              Obx(() => PwdInputBox(
                controller: logic.pwdCtrl,
                labelStyle: PageStyle.ts_333333_12sp,
                hintStyle: PageStyle.ts_333333_opacity40p_12sp,
                textStyle: PageStyle.ts_333333_12sp,
                showClearBtn: logic.showPwdClearBtn.value,
                obscureText: logic.obscureText.value,
                onClickEyesBtn: () => logic.toggleEye(),
                clearBtnColor: PageStyle.c_333333,
                eyesBtnColor: PageStyle.c_333333,
              )),
              SizedBox(height: 20.h),
              DebounceButton(
                onTap: () async => await logic.login(),
                // your tap handler moved here
                builder: (context, onTap) {
                  return Obx(() => Button(
                    height: 26.h,
                    textStyle: PageStyle.ts_FFFFFF_14sp,
                    disabledTextStyle: PageStyle.ts_898989_14sp,
                    enabled: logic.enabledLoginButton.value,
                    text: StrRes.login,
                    onTap: onTap,
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
