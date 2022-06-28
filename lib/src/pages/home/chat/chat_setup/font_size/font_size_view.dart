import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/avatar_view.dart';
import 'package:mics_big_version/src/widgets/fontsize_slider.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import 'font_size_logic.dart';

class FontSizePage extends StatelessWidget {
  final logic = Get.find<FontSizeLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.fontSize,
        actions: [
          _buildConfirmButton(),
        ],
      ),
      backgroundColor: PageStyle.c_F6F6F6,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 42.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarView(
                  size: 42.h,
                ),
                ChatBubble(
                  constraints: BoxConstraints(minHeight: 42.h),
                  backgroundColor: PageStyle.c_F0F0F0,
                  bubbleType: BubbleType.send,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 214.w),
                    child: Obx(() => Text(
                          '预览字体大小',
                          style: PageStyle.ts_333333_14sp,
                          textScaleFactor: logic.factor.value,
                        )),
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          FontSizeSlider(
            onChanged: logic.changed,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: logic.saveFactor,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Text(
            StrRes.sure,
            style: PageStyle.ts_333333_14sp,
          ),
        ),
      );
}
