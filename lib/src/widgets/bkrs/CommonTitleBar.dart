import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/images.dart';
import '../../res/styles.dart';

class CommonTitleBar extends StatelessWidget implements PreferredSizeWidget {


  const CommonTitleBar({Key? key,this.height,this.bgColor,this.title,this.onBack}) : super(key: key);
  final double? height;
  final Color? bgColor;
  final String? title;
  final Function? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.w),
      decoration: BoxDecoration(
          color: bgColor??PageStyle.c_FFFFFF,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.15),
              offset: Offset(0, 1),
              spreadRadius: 0,
              blurRadius: 4,
            )
          ]
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                child: Padding(child: Image.asset(
                  ImageRes.ic_back,
                  width: 12.w,
                  height: 20.h,
                ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w)),onTap: (){
                //返回
                onBack?.call();
              },
              )),
          Align(
            alignment: Alignment.center,
            child:  Text(title??"",textAlign: TextAlign.center,style: PageStyle.ts_333333_18sp),
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       TitleImageButton(
          //         imageStr: ImageRes.ic_searchGrey,
          //         imageWidth: 24.w,
          //         imageHeight: 24.h,
          //         color: Color(0xFF333333),
          //         onTap: (){
          //           logic.showSearch.value = true;
          //         },
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>  Size.fromHeight(height ?? 50.h);
}
