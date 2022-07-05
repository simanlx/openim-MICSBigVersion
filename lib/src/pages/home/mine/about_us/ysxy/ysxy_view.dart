import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';

import 'ysxy_logic.dart';

class YsxyPage extends StatelessWidget {

  final logic = Get.find<YsxyLogic>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        onTap: (){
          Get.back();
        },
        title: "隐私协议",
      ),
      body: Obx(()=>SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(10.w),child: Text(logic.content.value),),
      )),
    );
  }
}
