import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/avatar_view.dart';
import 'frequent_contacts_logic.dart';

class FrequentContactsPage extends StatelessWidget {

  final logic = Get.find<FrequentContactsLogic>();

  @override
  Widget build(BuildContext context) {

    print("常用联系人长度 ${logic.contactsLogic.frequentContacts.length}");

    return Scaffold(
      backgroundColor: PageStyle.c_FFFFFF,
      body: Obx(() =>  CustomScrollView(
        slivers: [
          _buildSubTitle(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildContactsItem(
                  logic.contactsLogic.frequentContacts.elementAt(index)),
              childCount: logic.contactsLogic.frequentContacts.length,
            ),
          ),
        ],
      )),
    );
  }
  Widget _buildSubTitle() => SliverToBoxAdapter(
    child: Container(
      color: PageStyle.c_F8F8F8,
      // color: Color(0xFF1B72EC).withOpacity(0.12),
      padding: EdgeInsets.fromLTRB(20.w,0,20.w,0),
      height: 33.h,
      child: Obx(()=>Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            StrRes.oftenContacts,
            style: PageStyle.ts_333333_16sp,
          ),
          Text(
            "${logic.contactsLogic.frequentContacts.length}",
            style: PageStyle.ts_333333_16sp,
          )
        ],
      )),
    ),
  );

  Widget _buildContactsItem(UserInfo info) => Obx(() => _buildItemView(
    icon: info.faceURL,
    label: info.getShowName(),
    showUnderline: true,
    showUnreadCount: false,
    showRightArrow: false,
    viewType: 2,
    key: info.userID,
    onlineStatus: logic.contactsLogic.onlineStatusDesc[info.userID],
    onTap: () => logic.contactsLogic.viewContactsInfo(info),
    onDismiss: () => logic.contactsLogic.removeFrequentContacts(info),
  ));

  Widget _buildItemView({
    Widget? iconWidget,
    String? icon,
    required String label,
    String? onlineStatus,
    int count = 0,
    Function()? onTap,
    bool showUnderline = true,
    bool showUnreadCount = true,
    bool showRightArrow = true,
    int viewType = 0,
    String? key,
    bool Function()? onDismiss,
  }) =>
      Ink(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: viewType == 2
              ? Dismissible(
            key: Key(key!),
            confirmDismiss: (direction) async {
              return onDismiss!.call();
            },
            child: _buildChildView(
              iconWidget: iconWidget,
              icon: icon,
              label: label,
              onlineStatus: onlineStatus,
              count: count,
              onTap: onTap,
              showUnderline: showUnderline,
              showRightArrow: showRightArrow,
              showUnreadCount: showUnreadCount,
              viewType: viewType,
            ),
          )
              : _buildChildView(
            iconWidget: iconWidget,
            icon: icon,
            label: label,
            onlineStatus: onlineStatus,
            count: count,
            onTap: onTap,
            showUnderline: showUnderline,
            showRightArrow: showRightArrow,
            showUnreadCount: showUnreadCount,
            viewType: viewType,
          ),
        ),
      );

  Widget _buildChildView({
    Widget? iconWidget,
    String? icon,
    required String label,
    String? onlineStatus,
    int count = 0,
    Function()? onTap,
    bool showUnderline = true,
    bool showUnreadCount = true,
    bool showRightArrow = true,
    int viewType = 0,
  }) =>
      Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Row(
          children: [
            if (viewType == 2)
              iconWidget ?? AvatarView(size: 26.h, url: icon, text: label),
            if (viewType == 1 && icon != null)
              Container(
                width: 42.h,
                height: 42.h,
                child: Center(
                  child: iconWidget ??
                      Image.asset(icon, width: 20.h, height: 20.h),
                ),
              ),
            if (viewType == 0 && icon != null)
              iconWidget ?? Image.asset(icon, width: 20.h, height: 20.h),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: viewType == 2 ? 16.w : 18.w,
                ),
                alignment: Alignment.centerLeft,
                decoration: showUnderline
                    ? BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: Color(0xFFF1F1F1),
                      width: 1,
                    ),
                  ),
                )
                    : null,
                child: Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: viewType == 2
                              ? PageStyle.ts_333333_12sp
                              : PageStyle.ts_333333_14sp,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (viewType == 2 && null != onlineStatus)
                          Text(
                            onlineStatus,
                            style: PageStyle.ts_999999_12sp,
                          ),
                      ],
                    ))
                    ,
                    // Spacer(),
                    if (showUnreadCount)
                      Container(
                        margin: EdgeInsets.only(right: 5.w),
                        child: UnreadCountView(count: count),
                      ),
                    if (showRightArrow)
                      Image.asset(
                        ImageRes.ic_moreArrow,
                        width: 16.w,
                        height: 16.h,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
