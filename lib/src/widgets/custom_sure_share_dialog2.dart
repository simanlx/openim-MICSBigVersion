import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/styles.dart';
import '../models/contacts_info.dart';
import 'avatar_view.dart';
import 'custom_sure_share_dialog.dart';

class CustomSureShareDialog2 extends StatelessWidget {
   CustomSureShareDialog2({
    Key? key,
    this.checkList,
    this.title = "",
    this.checkGroupList,
    this.content = "",
    this.timeStr = "",
    this.type = CustomSureShareDialogType.HZXQ,
  }) : super(key: key);
   List<ContactsInfo>? checkList;
   List<GroupInfo>? checkGroupList;
   List<dynamic> all = [];
  final CustomSureShareDialogType type;
  String title;
  String content;
  String timeStr;

  @override
  Widget build(BuildContext context) {
    if (checkList == null) {
      checkList = [];
    }
    if (checkGroupList == null) {
      checkGroupList = [];
    }
    all.clear();
    all.addAll(checkGroupList!);
    all.addAll(checkList!);
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: EdgeInsets.all(15.w),
            width: 280.w,
            color: PageStyle.c_FFFFFF,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("发送给：",style: TextStyle(color:Colors.black,fontSize: 18.sp,fontWeight: FontWeight.bold),),
                ConstrainedBox(constraints: BoxConstraints(maxHeight: 180.h),
                  child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child:
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: all.length,
                      itemBuilder: (BuildContext context,int index){
                        var item = all[index];
                        var url = "";
                        var name = "";
                        if(item is ContactsInfo){
                          url = item.faceURL??"";
                          name = item.nickname??"";
                        }else if(item is GroupInfo){
                          url = item.faceURL??"";
                          name = item.groupName??"";
                        }
                        return Padding(padding: EdgeInsets.only(bottom: 10.h),child: Row(
                          children: [
                            AvatarView(
                              url: url,
                              size: 34.h,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              name,
                              style: PageStyle.ts_333333_16sp,
                            )
                          ],
                        ),);
                      }),
                ),),
                SizedBox(height: 20.w),
                Row(
                  children: [
                    Expanded(child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        Get.back(result: true);
                      },
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: PageStyle.c_57AD55
                        ),
                        child: Center(child: Text("确认",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)),
                      ),
                    )),
                    SizedBox(width: 10.w,),
                    Expanded(child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                            color: PageStyle.c_D3D3D3
                        ),
                        child: Center(child: Text("取消",textAlign: TextAlign.center,style: TextStyle(color: PageStyle.c_57AD55))),
                      ),
                    )),
                  ],
                )
            ],),
          ),
        ),
      ),
    );
  }

  Widget _button({
    required Color bgColor,
    required String text,
    required TextStyle textStyle,
    Function()? onTap,
  }) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(6),
              color: bgColor,
            ),
            height: 46.h,
            alignment: Alignment.center,
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ),
      );
}
