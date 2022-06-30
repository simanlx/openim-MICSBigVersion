
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mics_big_version/src/models/zskjs/ZskjsListContentListItem.dart';
import 'package:mics_big_version/src/pages/bkparts/zskjs/zskjs_detail/ZskjsDetailLogic.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/bkrs/CommonTitleBar.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';

class ZskjsDetailPage extends StatefulWidget {
   ZskjsDetailPage({Key? key,required this.item}) : super(key: key);

   ZskjsListContentListItemData item;

  @override
  State<ZskjsDetailPage> createState() => _ZskjsDetailPageState();
}

class _ZskjsDetailPageState extends State<ZskjsDetailPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: PageStyle.c_FFFFFF,
        appBar:EnterpriseTitleBar.back(style: PageStyle.ts_333333_16sp,showTopPadding:false,showBackArrow: false,title: widget.item.name??"",height: 40.h,),
        body: SingleChildScrollView(
            child:
            Padding(padding: EdgeInsets.all(10.w),child: Text(widget.item.content??"",style: TextStyle(fontSize: 14.sp),))
            // Html(data: widget.item.content,style: {
            //   "p": Style(
            // backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
            // )
            // },)
        )
    );
  }

  Widget buildHead(){

    return  Container(
      height: 80.h,
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.w),
      decoration: BoxDecoration(
          color: PageStyle.c_FFFFFF,
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
          // Align(
          //     alignment: Alignment.centerLeft,
          //     child: InkWell(
          //       child: Padding(child: Image.asset(
          //         ImageRes.ic_back,
          //         width: 12.w,
          //         height: 20.h,
          //       ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w)),onTap: (){
          //       //返回
          //       logic.back();
          //     },
          //     )),
          Align(
            alignment: Alignment.center,
            child:  Text(widget.item.name??"",textAlign: TextAlign.center,style: PageStyle.ts_333333_18sp),
          ),
        ],
      ),
    );
  }
}

//
// class ZskjsDetailPage extends StatelessWidget{
//
//   final logic = Get.find<ZskjsDetailLogic>();
//
//
//
//
// }