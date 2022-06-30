import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/models/contacts_info.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/avatar_view.dart';
import 'package:mics_big_version/src/widgets/search_box.dart';
import 'package:mics_big_version/src/widgets/tabbar.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import 'package:sprintf/sprintf.dart';

import 'bkrs_group_list_view/bkrs_group_list_view_view.dart';
import 'friend_list/friend_list_view.dart';
import 'select_contacts_logic.dart';

class SelectContactsPage extends StatelessWidget {
  final logic = Get.find<SelectContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(title: logic.showTitle.value,),
      backgroundColor: PageStyle.c_FFFFFF,
      body: SafeArea(
        child: Obx(() => Column(
              children: [
                // SearchBox(
                //   enabled: false,
                //   margin: EdgeInsets.fromLTRB(22.w, 10.h, 22.w, 0),
                //   padding: EdgeInsets.symmetric(horizontal: 13.w),
                // ),
                if (!logic.isMultiModel())
                  Container(height: 20.h,color: Colors.white),
                  // CustomTabBar(
                  //   labels: [StrRes.selectByFriends, StrRes.selectByGroup],
                  //   index: logic.index.value,
                  //   onTabChanged: (i) => logic.switchTab(i),
                  // ),
                  Visibility(visible: logic.isMultiModel() && logic.action == SelAction.MyFORWARD,child:
                  CustomTabBar2(
                    index: logic.index.value,
                    onTabChanged: (i) => logic.switchTab(i),
                    margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
                    tabs: [
                      TabInfo(
                        label: StrRes.selectByFriends,
                        styleSel: PageStyle.ts_333333_14sp,
                        styleUnsel: PageStyle.ts_333333_14sp,
                        iconSel: ImageRes.ic_tabSelFriend,
                        iconUnsel: ImageRes.ic_tabUnselFriend,
                        iconHeight: 30.h,
                        iconWidth: 30.h,
                      ),
                      TabInfo(
                        // label: StrRes.selectByGroup,
                        label: "按群聊选",
                        styleSel: PageStyle.ts_333333_14sp,
                        styleUnsel: PageStyle.ts_333333_14sp,
                        iconSel: ImageRes.ic_tabSelGroup,
                        iconUnsel: ImageRes.ic_tabUnselGroup,
                        iconHeight: 30.h,
                        iconWidth: 30.h,
                      ),
                    ],
                  ),),
                Visibility(visible: !(logic.isMultiModel() && logic.action == SelAction.MyFORWARD),child:
                Container(height: 20.h,color: Colors.white),),
                Expanded(
                  child: IndexedStack(
                    index: logic.index.value,
                    children: [
                      FriendListView(),
                      BkrsGroupListViewPage(),
                      // GetBuilder<OrganizationListLogic>(
                      //   init: OrganizationListLogic(),
                      //   builder: (logic) => OrganizationListView(),
                      // )
                    ],
                  ),
                ),
                if (logic.isMultiModel()) ContactCountView(),
              ],
            )),
      ),
    );
  }
}

class ContactCountView extends StatelessWidget {
  ContactCountView({Key? key}) : super(key: key);
  final logic = Get.find<SelectContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 47.h,
        color: PageStyle.c_FFFFFF,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (logic.checkedList.isNotEmpty || logic.checkedGroupList.isNotEmpty) {
                  Get.to(() => SelectedContactsView());
                }
              },
              behavior: HitTestBehavior.translucent,
              child: RichText(
                text: TextSpan(
                  text: sprintf(StrRes.selectedNum, [logic.checkedList.length+logic.checkedGroupList.length]),
                  style: PageStyle.ts_1B72EC_14sp,
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.only(left: 7.w),
                        child: Image.asset(
                          ImageRes.ic_arrowUpBlue,
                          width: 12.w,
                          height: 12.h,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => logic.confirmSelected(),
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.only(
                  left: 6.w,
                  right: 3.w,
                  top: 4.h,
                  bottom: 5.h,
                ),
                decoration: BoxDecoration(
                    color: PageStyle.c_1B72EC.withOpacity(
                      1
                      // logic.checkedList.isNotEmpty ? 1 : 0.7,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: PageStyle.c_000000_opacity15p,
                        blurRadius: 4,
                      ),
                    ]),
                child: Text(
                  sprintf(StrRes.confirmNum, [logic.checkedList.length+logic.checkedGroupList.length, 998]),
                  style: PageStyle.ts_FFFFFF_14sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedContactsView extends StatelessWidget {
  final logic = Get.find<SelectContactsLogic>();

  SelectedContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle.c_F6F6F6,
      appBar: EnterpriseTitleBar.back(
        showBackArrow: false,
        showShadow: false,
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: 35.h,
              width: 52.w,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                color: PageStyle.c_1B72EC,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                StrRes.sure,
                style: PageStyle.ts_FFFFFF_16sp,
              ),
            ),
          )
        ],
      ),
      body: Obx((){
        var allList = [];
        allList.clear();
        allList.addAll(logic.checkedGroupList);
        allList.addAll(logic.checkedList);
        return ListView.builder(
          padding: EdgeInsets.only(top: 10.h),
          itemCount: allList.length,
          itemBuilder: (_, index) =>
              _buildItemView(allList[index]),
        );
      }),
    );
  }

  Widget _buildItemView(dynamic info){

    var url = "";
    var text = "";
    var showName = "";

    if(info is ContactsInfo){
      url = info.faceURL??"";
      text = info.nickname??"";
      showName = info.getShowName();
    }else if(info is GroupInfo){
      url = info.faceURL??"";
      text = info.groupName??"";
      showName = info.groupName??"";
    }
    return Container(
      color: PageStyle.c_FFFFFF,
      height: 75.h,
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Row(
        children: [
          AvatarView(
            size: 44.h,
            url: url,
            text: text,
          ),
          Expanded(
            child: Container(
              height: 75.h,
              margin: EdgeInsets.only(left: 14.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(
                    color: PageStyle.c_F0F0F0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    showName,
                    style: PageStyle.ts_333333_16sp,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      if(info is ContactsInfo){
                        logic.removeContacts(info);
                      }else if(info is GroupInfo){
                        logic.removeGroup(info);
                      }
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      height: 75.h,
                      alignment: Alignment.center,
                      child: Text(
                        StrRes.remove,
                        style: PageStyle.ts_E80000_16sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
