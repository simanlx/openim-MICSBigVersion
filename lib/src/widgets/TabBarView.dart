

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mics_big_version/src/res/styles.dart';

class MyTabBarView extends StatelessWidget{

  var index = 0;
  var items = [];
  Function(int index)? onTap;
  Color? fontColor;
  MyTabBarView({required this.index,required this.items,this.onTap,this.fontColor});

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Container(width: 300.w,height: 44.h,child:
            ListView.builder(
              itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context,int index){
              return  GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  onTap?.call(index);
                },
                child: Padding(padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(items[index],style: TextStyle(fontSize: 18.sp,color:fontColor?? PageStyle.c_FFFFFF),),
                    SizedBox(height: 3.h,),
                    Visibility(visible: this.index == index,child: Container(width: 20.w,height: 1.h,color:fontColor?? PageStyle.c_FFFFFF))
                  ],),
                ),
              );
            })
        ),
      );
  }
}