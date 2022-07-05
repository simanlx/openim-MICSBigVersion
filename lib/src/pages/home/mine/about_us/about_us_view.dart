import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';


import 'about_us_logic.dart';

class AboutUsPage extends StatelessWidget {
  final logic = Get.find<AboutUsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        showBackArrow: false,
        showTopPadding: false,
        title: StrRes.aboutUs,
        style: PageStyle.ts_333333_14sp,
        height: 36.h,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            Image.asset(
              "assets/images/app_mics.png",
              width: 36.h,
              height: 36.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(() => Text(
              'V${logic.version.value}',
              style: PageStyle.ts_333333_14sp,
            )),
            SizedBox(
              height: 24.h,
            ),
            // _buildItemView(
            //   label: StrRes.goToRate,
            // ),
            _buildItemView(
              label: StrRes.checkVersion,
              onTap: logic.checkUpdate,
            ),
            // _buildItemView(
            //   label: StrRes.newFuncIntroduction,
            // ),
            // _buildItemView(
            //   label: StrRes.appServiceAgreement,
            // ),
            _buildItemView(
                label: StrRes.appPrivacyPolicy,
                onTap: logic.toYsxy
            ),
            // _buildItemView(
            //   label: StrRes.copyrightInformation,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView({required String label, Function()? onTap}) => Ink(
        color: PageStyle.c_FFFFFF,
        height: 40.h,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(
                  color: PageStyle.c_999999_opacity40p,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  label,
                  style: PageStyle.ts_333333_12sp,
                ),
                Spacer(),
                Image.asset(
                  ImageRes.ic_next,
                  width: 8.w,
                  height: 16.h,
                )
              ],
            ),
          ),
        ),
      );
}
