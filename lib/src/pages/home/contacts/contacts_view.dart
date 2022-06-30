import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/home/home_logic.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/avatar_view.dart';
import 'contacts_logic.dart';

class ContactsPage extends StatelessWidget {

  final logic = Get.find<ContactsLogic>();
  final homeLogic = Get.find<HomeLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(borderRadius: BorderRadius.circular(10.r),child:
      Obx(()=>Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: Row(
            children: [
              Container(width: 220.w,color: Colors.transparent,child: CustomScrollView(
                slivers: [
                  _buildGroupItem(
                    icon: ImageRes.ic_newFriend,
                    label: "常用联系人",
                    onTap: (){
                      logic.showFrequentFriend();
                    },
                  ),
                  _buildGroupItem(
                    icon: ImageRes.ic_newFriend,
                    label: StrRes.newFriend,
                    onTap: (){},
                    count: homeLogic.unhandledFriendApplicationCount.value,
                  ),
                  _buildGroupItem(
                    icon: ImageRes.ic_groupApplicationNotification,
                    label: StrRes.groupApplicationNotification,
                    onTap: () {},
                    count: homeLogic.unhandledGroupApplicationCount.value,
                  ),
                  _buildGroupItem(
                    icon: ImageRes.ic_myFriend,
                    label: StrRes.myFriend,
                    onTap: () {
                      logic.showMyFriend();
                    },
                  ),
                  _buildGroupItem(
                    icon: ImageRes.ic_myGroup,
                    label: StrRes.myGroup,
                    onTap: () {
                      logic.toMyGroup();
                    },
                    showUnderline: true,
                  ),
                  _buildGroupItem(
                    icon: ImageRes.ic_tag,
                    label: StrRes.tag,
                    showUnderline: false,
                    onTap: (){},
                  ),
                  _buildOrganizationView(),
                  // _buildSubTitle(),
                  // SliverList(
                  //   delegate: SliverChildBuilderDelegate(
                  //         (context, index) => _buildContactsItem(
                  //         logic.frequentContacts.elementAt(index)),
                  //     childCount: logic.frequentContacts.length,
                  //   ),
                  // ),
                ],
              ),),
              Container(width: 2.w,color: PageStyle.c_e8e8e8,),
              Expanded(child: Obx(()=>Stack(
                children: [
                  if(logic.stackList.length>0)
                    Obx(()=>logic.stackList.value[logic.stackList.length-1])
                ],
              )))
            ],
          )
      )),),
    );
  }
  Widget _buildSubTitle() => SliverToBoxAdapter(
    child: Container(
      color: PageStyle.c_F8F8F8,
      // color: Color(0xFF1B72EC).withOpacity(0.12),
      padding: EdgeInsets.only(left: 22.w),
      height: 33.h,
      child: Row(
        children: [
          Text(
            StrRes.oftenContacts,
            style: PageStyle.ts_999999_12sp,
          )
        ],
      ),
    ),
  );
  Widget _buildOrganizationView() => SliverToBoxAdapter(
    child: Column(
      children: [
        Container(
          height: 12.h,
          color: PageStyle.c_F8F8F8,
        ),
        _buildItemView(
            icon: ImageRes.ic_myGroup,
            label: '深圳市人民医院',
            viewType: 0,
            showUnderline: false,
            showUnreadCount: false,
            showRightArrow: true,
            onTap: (){
              logic.showDepartPage("","深圳市人民医院");
            }
        ),
        Container(
          height: 200.h,
          child: ListView.builder(itemCount:logic.departList.length,itemBuilder: (BuildContext context,int index){
            var bean = logic.departList[index];
            return   _buildItemView(
              icon: ImageRes.ic_tree,
              label: bean.name??"",
              viewType: 1,
              showUnderline: false,
              showUnreadCount: false,
              showRightArrow: true,
              onTap: (){
                logic.showDepartPage(bean.id.toString(),bean.name??"");
              },
            );
          }),
        )
        // _buildItemView(
        //   icon: ImageRes.ic_tree,
        //   label: '组织架构',
        //   viewType: 1,
        //   showUnderline: false,
        //   showUnreadCount: false,
        //   showRightArrow: true,
        //   onTap: () => logic.viewOrganization(),
        // ),
        // _buildItemView(
        //   icon: ImageRes.ic_tree,
        //   label: '技术部',
        //   viewType: 1,
        //   showUnderline: false,
        //   showUnreadCount: false,
        //   showRightArrow: true,
        // )
      ],
    ),
  );

  Widget _buildGroupItem({
    required String icon,
    required String label,
    int count = 0,
    Function()? onTap,
    bool showUnderline = true,
  }) =>
      SliverToBoxAdapter(
        child: _buildItemView(
            icon: icon,
            label: label,
            showUnderline: showUnderline,
            showUnreadCount: true,
            showRightArrow: true,
            viewType: 0,
            count: count,
            onTap: onTap),
      );

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
              iconWidget ?? AvatarView(size: 44.h, url: icon, text: label),
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
