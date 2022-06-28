

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mics_big_version/src/res/styles.dart';

class DefaultAvatar extends StatelessWidget {

  DefaultAvatar(this.title,{Key? key,this.height,this.width}) : super(key: key);
  double? height;
  double? width;
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height??48.w,
      width: width??48.w,
      decoration: BoxDecoration(
        color:PageStyle.c_10AEFF,
        borderRadius: BorderRadius.all(Radius.circular(8.r))
      ),
      child: Center(
        child: Text(title,style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
