import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/avatar_view.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import '../friend_info_logic.dart';

class PersonalInfoPage extends StatelessWidget {
  final logic = Get.find<FriendInfoLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle.c_F8F8F8,
      appBar: EnterpriseTitleBar.back(title: "个人资料",),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 12.h,
              ),
              _buildItemView(
                label: StrRes.avatar,
                url: logic.userInfo.value.faceURL,
                showAvatar: true,
                name: logic.userInfo.value.getShowName(),
              ),
              _buildItemView(
                label: StrRes.nickname,
                value: logic.userInfo.value.getShowName(),
              ),
              _buildItemView(
                label: StrRes.gender,
                value: logic.userInfo.value.isMale ? StrRes.man : StrRes.woman,
              ),
              _buildItemView(
                label: StrRes.birthday,
                value: '${logic.userInfo.value.birth}',
              ),
              if (null != logic.userInfo.value.phoneNumber &&
                  logic.userInfo.value.phoneNumber!.isNotEmpty)
                _buildItemView(
                  label: StrRes.phoneNum,
                  value: logic.userInfo.value.phoneNumber,
                ),
              if (null != logic.userInfo.value.email &&
                  logic.userInfo.value.email!.isNotEmpty)
                _buildItemView(
                  label: StrRes.email,
                  value: logic.userInfo.value.email,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    String? name,
    String? value,
    String? url,
    bool showAvatar = false,
    bool showQrIcon = false,
    bool showArrow = false,
    Function()? onTap,
  }) =>
      Ink(
        height: 58.h,
        color: PageStyle.c_FFFFFF,
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
            )),
            child: Row(
              children: [
                Text(
                  label,
                  style: PageStyle.ts_333333_18sp,
                ),
                Spacer(),
                if (showAvatar)
                  AvatarView(
                    size: 40.h,
                    url: url,
                    text: name,
                    enabledPreview: true,
                  ),
                if (showQrIcon)
                  Image.asset(
                    ImageRes.ic_mineQrCode,
                    width: 22.w,
                    height: 22.h,
                    color: PageStyle.c_999999,
                  ),
                if (null != value && value.isNotEmpty)
                  Text(
                    value,
                    style: PageStyle.ts_999999_16sp,
                  ),
                if (showArrow)
                  Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: Image.asset(
                      ImageRes.ic_next,
                      width: 10.w,
                      height: 17.h,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
