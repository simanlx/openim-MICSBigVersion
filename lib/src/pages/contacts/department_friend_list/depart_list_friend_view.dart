import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/zskjs/DepartFriendListRes.dart';
import '../../../res/strings.dart';
import '../../../res/styles.dart';
import '../../../routes/app_navigator.dart';
import '../../../widgets/azlist_view.dart';
import '../../../widgets/search_box.dart';
import '../../../widgets/titlebar.dart';
import '../contacts_logic.dart';
import 'depart_list_friend_logic.dart';

class DepartListFriendPage extends StatelessWidget {

  final logic = Get.find<DepartListFriendLogic>();
  final contactLogic = Get.find<ContactsLogic>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: EnterpriseTitleBar.back(
      //   title: logic.departName,
      // ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 10.w, 10.w, 10.w),
            child: Obx(()=>Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${logic.departName}",style: PageStyle.ts_333333_16sp,),
                Text("${logic.list.length}",style: PageStyle.ts_333333_16sp,),
              ],)),
          ),
          // GestureDetector(
          //   onTap: () => logic.searchFriend(),
          //   behavior: HitTestBehavior.translucent,
          //   child: Container(
          //     // color: PageStyle.listViewItemBgColor,
          //     child: SearchBox(
          //       hintText: StrRes.searchFriend,
          //       margin:
          //       EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          //       padding: EdgeInsets.symmetric(horizontal: 13.w),
          //       enabled: false,
          //     ),
          //   ),
          // ),
          Expanded(
            child: Obx(
                  () => WrapAzListView<DepartFriendListRes>(
                  data: logic.list.value,
                  itemBuilder: (_, data, index){
                    var showName = "";
                    var positionName =  data.positionName;
                    if (positionName == null || positionName.isEmpty) {
                      showName = data.realName??"";
                    }else{
                      showName = "${data.realName??""} (${data.positionName??""})";
                    }
                    return buildAzListItemView(
                      name: showName,
                      url: data.headImageUrl,
                      onTap: (){
                        var userInfo = UserInfo();
                        userInfo.userID = data.account;
                        userInfo.nickname = data.realName;
                        userInfo.faceURL = data.headImageUrl;
                        AppNavigator.startFriendInfo(userInfo: userInfo);
                      },
                    );
                  }

              ),
            ),
          ),
        ],
      ),
    );
  }
}
