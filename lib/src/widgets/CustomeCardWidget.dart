import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/custom_sure_share_dialog.dart';

class CustomCardWidget extends StatelessWidget {

   CustomCardWidget(this.type,this.title,this.content, {Key? key,this.width,this.height,this.onClick,this.timeStr}) : super(key: key);

  String? title;
  double? width;
  double? height;

  String? content;
  String? timeStr;
  CustomSureShareDialogType type;

  Function? onClick;

  @override
  Widget build(BuildContext context) {

    var typeStr = "";
    var showImage = ImageRes.ic_card_hzda;
    if(type == CustomSureShareDialogType.HZXQ){
      typeStr = "患者档案";
      showImage = ImageRes.ic_card_hzda;
    }else  if(type == CustomSureShareDialogType.YLBW){
      typeStr = "医疗备忘";
      showImage = ImageRes.ic_card_ylbw;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        if (null != onClick) onClick!();
      },
      child: Container(
        // height: height??210.w,
        width: width??200.w,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
            color: PageStyle.c_F2F2F2,
            borderRadius: BorderRadius.all(Radius.circular(5.r))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image.asset(showImage,height: 20.w,width: 20.w,),
                SizedBox(width: 10.w),
                Expanded(child: Text(title??"",maxLines: 1,overflow: TextOverflow.ellipsis,))
              ],
            ),
            // ConstrainedBox(
            //   constraints: BoxConstraints(
            //     maxHeight: 100.h,
            //   ) ,
            //   child: Row(children: [
            //     SizedBox(width: 10.w),
            //     Expanded(child: Text(content??"",maxLines: 3,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start))
            //
            //   ],),
            // ),
            SizedBox(height: 5.h,),
            Container(
                constraints: BoxConstraints(maxHeight: 80.h),
                child:
                Row(children: [
                  Expanded(child: Text(content??"",maxLines: 3,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,style: TextStyle(color: PageStyle.c_999999)))

                ],),
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                Expanded(child: Text(timeStr??"",textAlign: TextAlign.end,style: TextStyle(color: PageStyle.c_999999),))
              ],
            ),
            SizedBox(height: 5.h),
            Divider(height: 2,color: PageStyle.c_e8e8e8),
            SizedBox(height: 5.h),
            Row(
              children: [
                Expanded(child: Text(typeStr,textAlign: TextAlign.end,style: TextStyle(color: PageStyle.c_999999)))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
