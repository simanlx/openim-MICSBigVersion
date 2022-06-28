import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/models/contacts_info.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/azlist_view.dart';
import 'friend_list_logic.dart';

class MyFriendListPage extends StatelessWidget {
  final logic = Get.find<MyFriendListLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: EnterpriseTitleBar.back(
      //   title: StrRes.myFriend,
      // ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: Column(
        children: [
          // GestureDetector(
          //   onTap: () => logic.searchFriend(),
          //   behavior: HitTestBehavior.translucent,
          //   child: Container(
          //     // color: PageStyle.listViewItemBgColor,
          //     child: SearchBox(
          //       hintText: StrRes.searchFriend,
          //       margin:
          //           EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          //       padding: EdgeInsets.symmetric(horizontal: 13.w),
          //       enabled: false,
          //     ),
          //   ),
          // ),
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 10.w, 10.w, 10.w),
            child: Obx(()=>Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("我的好友",style:PageStyle.ts_333333_16sp,),
                Text("${logic.friendList.length}",style: TextStyle(fontSize: 16.sp)),
              ],)),
          ),
          Expanded(
            child: Obx(
                  () => WrapAzListView<ContactsInfo>(
                data: logic.friendList.value,
                itemBuilder: (_, data, index) =>
                    Obx(() => buildAzListItemView(
                      name: data.getShowName(),
                      url: data.faceURL,
                      onTap: () => logic.viewFriendInfo(index),
                      onlineStatus: logic.onlineStatus[data.userID],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
