import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/home/contacts/contacts_logic.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/avatar_view.dart';
import 'package:mics_big_version/src/widgets/switch_button.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import 'package:sprintf/sprintf.dart';
import 'friend_info_logic.dart';

class FriendInfoPage extends StatelessWidget {
  final logic = Get.find<FriendInfoLogic>();
  final contactLogic = Get.find<ContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle.c_F6F6F6,
      appBar: EnterpriseTitleBar.back(title: "账号信息",),
      body: SingleChildScrollView(
        child: Container(
          // height: 728.h,
          child: Obx(
            () => Column(
              children: [
                if (null == logic.groupID || logic.groupID!.isEmpty)
                  _buildFriendHeader(),
                if (null != logic.groupID && logic.groupID!.isNotEmpty)
                  _buildGroupMemberHeader(),
                _buildLine(),
                _buildItemView(
                  label: StrRes.idCode,
                  onTap: () => logic.toCopyId(),
                  showArrowBtn: true,
                  showLine: true,
                ),
                if (logic.userInfo.value.isFriendship == true)
                  _buildItemView(
                    label: StrRes.remark,
                    onTap: () => logic.toSetupRemark(),
                    showArrowBtn: true,
                    showLine: true,
                  ),
                if (logic.userInfo.value.isFriendship == true)
                  _buildItemView(
                    label: StrRes.personalInfo,
                    onTap: () => logic.viewPersonalInfo(),
                    showArrowBtn: true,
                    showLine: true,
                  ),
                if (logic.userInfo.value.isFriendship == true)
                  _buildItemView(
                    label: StrRes.recommendToFriends,
                    onTap: () => logic.recommendFriend(),
                    showArrowBtn: true,
                    showLine: true,
                  ),
                if (logic.showMuteFunction.value)
                  _buildItemView(
                    label: StrRes.setMute,
                    value:
                        logic.mutedTime.isEmpty ? null : logic.mutedTime.value,
                    onTap: () => logic.setMute(),
                    showArrowBtn: true,
                    showLine: true,
                  ),
                if (logic.userInfo.value.isFriendship == true)
                  _buildItemView(
                    label: StrRes.addBlacklist,
                    showSwitchBtn: true,
                    switchOn: logic.userInfo.value.isBlacklist == true,
                    onTap: () => logic.toggleBlacklist(),
                  ),
                if (logic.userInfo.value.isFriendship == true)
                  _buildItemView(
                    label: StrRes.relieveRelationship,
                    alignment: Alignment.center,
                    style: PageStyle.ts_D9350D_18sp,
                    onTap: () => logic.deleteFromFriendList(),
                    margin: EdgeInsets.only(top: 58.h),
                  ),
                SizedBox(
                  height:
                      logic.userInfo.value.isFriendship == true ? 44.h : 300.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBtn(
                      icon: ImageRes.ic_sendMsg,
                      label: StrRes.sendMsg,
                      style: PageStyle.ts_1D6BED_14sp,
                      onTap: () => logic.toChat(),
                    ),
                    _buildBtn(
                      icon: ImageRes.ic_appCall,
                      label: StrRes.appCall,
                      style: PageStyle.ts_1D6BED_14sp,
                      onTap: () => logic.toCall(),
                    ),
                    if (logic.userInfo.value.isFriendship == false)
                      _buildBtn(
                        icon: ImageRes.ic_sendAddFriendMsg,
                        label: StrRes.addFriend,
                        style: PageStyle.ts_1D6BED_14sp,
                        onTap: () => logic.addFriend(),
                      ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupMemberHeader() => Container(
        height: 127.h,
        color: PageStyle.c_FFFFFF,
        child: Stack(
          children: [
            Positioned(
              top: 24.h,
              left: 22.w,
              child: AvatarView(
                size: 48.h,
                url: logic.userInfo.value.faceURL,
                text: logic.userInfo.value.nickname,
                textStyle: PageStyle.ts_FFFFFF_18sp,
                enabledPreview: true,
              ),
            ),
            Positioned(
              top: 22.h,
              left: 88.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        logic.userInfo.value.nickname ?? '',
                        style: PageStyle.ts_333333_20sp,
                      ),
                      if (logic.onlineStatusDesc.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(
                            right: 4.w,
                            top: 2.h,
                            left: 10.w,
                          ),
                          width: 6.h,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: logic.onlineStatus.value
                                ? PageStyle.c_10CC64
                                : PageStyle.c_959595,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (logic.onlineStatusDesc.isNotEmpty)
                        Text(
                          logic.onlineStatusDesc.value,
                          style: PageStyle.ts_333333_12sp,
                        )
                    ],
                  ),
                  if (logic.groupMembersInfo?.nickname != null)
                    Text(
                      sprintf(StrRes.groupNicknameIs,
                          [logic.groupMembersInfo?.nickname]),
                      style: PageStyle.ts_999999_12sp,
                    ),
                  if (null != logic.groupMembersInfo?.joinTime)
                    Text(
                      sprintf(StrRes.joinGroupTimeIs, [
                        DateUtil.formatDateMs(
                          logic.groupMembersInfo!.joinTime! * 1000,
                          format: DateFormats.zh_y_mo_d,
                        )
                      ]),
                      style: PageStyle.ts_999999_12sp,
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildFriendHeader() => Container(
        height: 127.h,
        color: PageStyle.c_FFFFFF,
        child: Stack(
          children: [
            Positioned(
              top: 40.h,
              left: 22.w,
              child: Text(
                logic.userInfo.value.getShowName(),
                style: PageStyle.ts_333333_24sp,
              ),
            ),
            Positioned(
              top: 20.h,
              right: 22.w,
              child: AvatarView(
                size: 72.h,
                url: logic.userInfo.value.faceURL,
                text: logic.userInfo.value.nickname,
                textStyle: PageStyle.ts_FFFFFF_24sp,
                enabledPreview: true,
              ),
            )
          ],
        ),
      );

  Widget _buildBtn({
    required String icon,
    required String label,
    required TextStyle style,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Column(
          children: [
            Image.asset(
              icon,
              width: 50.w,
              height: 50.h,
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              label,
              style: style,
            ),
          ],
        ),
      );

  Widget _buildItemView({
    required String label,
    String? value,
    TextStyle? style,
    AlignmentGeometry alignment = Alignment.centerLeft,
    Function()? onTap,
    bool showArrowBtn = false,
    bool showSwitchBtn = false,
    bool switchOn = false,
    bool showLine = false,
    EdgeInsetsGeometry? margin,
  }) =>
      Container(
        margin: margin,
        child: Ink(
          color: PageStyle.c_FFFFFF,
          height: 55.h,
          child: InkWell(
            onTap: showSwitchBtn ? null : onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              decoration: showLine
                  ? BoxDecoration(
                      border: BorderDirectional(
                        bottom: BorderSide(
                          width: .5,
                          color: PageStyle.c_999999_opacity40p,
                        ),
                      ),
                    )
                  : null,
              alignment: alignment,
              child: showArrowBtn || showSwitchBtn
                  ? Row(
                      children: [
                        Text(
                          label,
                          style: style ?? PageStyle.ts_333333_18sp,
                        ),
                        Spacer(),
                        if (null != value)
                          Text(
                            value,
                            style: style ?? PageStyle.ts_1B61D6_16sp,
                          ),
                        SizedBox(
                          width: 5.w,
                        ),
                        if (showArrowBtn)
                          Image.asset(
                            ImageRes.ic_next,
                            width: 7.w,
                            height: 13.h,
                          ),
                        if (showSwitchBtn)
                          SwitchButton(
                            width: 51.w,
                            height: 31.h,
                            on: switchOn,
                            onTap: onTap,
                          ),
                      ],
                    )
                  : Text(
                      label,
                      style: style ?? PageStyle.ts_333333_18sp,
                    ),
            ),
          ),
        ),
      );

  Widget _buildLine() => Container(
        height: 0.5,
        color: PageStyle.c_999999_opacity40p,
      );


  // Widget _buildTitle() {
  //   return Container(
  //     height: 80.h,
  //     padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.w),
  //     decoration: BoxDecoration(
  //         color: PageStyle.c_FFFFFF,
  //         boxShadow: [
  //           BoxShadow(
  //             color: Color(0xFF000000).withOpacity(0.15),
  //             offset: Offset(0, 1),
  //             spreadRadius: 0,
  //             blurRadius: 4,
  //           )
  //         ]
  //     ),
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         Align(
  //             alignment: Alignment.centerLeft,
  //             child: InkWell(child: Padding(child: Image.asset(
  //               ImageRes.ic_back,
  //               width: 12.w,
  //               height: 20.h,
  //             ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w),),onTap: (){
  //               //返回
  //               logic.back();
  //             },
  //             )),
  //         Align(
  //           alignment: Alignment.center,
  //           child:  Text("个人信息",textAlign: TextAlign.center,style: PageStyle.ts_333333_18sp),
  //         ),
  //         // Align(
  //         //   alignment: Alignment.centerRight,
  //         //   child: Row(
  //         //     mainAxisSize: MainAxisSize.min,
  //         //     children: [
  //         //       InkWell(onTap:logic.addPatient,
  //         //           child: Container(child: Padding(padding:EdgeInsets.fromLTRB(10.w,4.w,10.w,4.w),child: Text("确认",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),),decoration: BoxDecoration(
  //         //               color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5.r),))))
  //         //     ],
  //         //   ),
  //         // )
  //       ],
  //     ),
  //   );
  // }


}

