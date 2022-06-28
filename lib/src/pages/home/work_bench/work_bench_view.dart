import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'work_bench_logic.dart';

class WorkbenchPage extends StatelessWidget {

  final logic = Get.find<WorkbenchLogic>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: PageStyle.c_FFFFFF,
      body: Obx(()=>Stack(
        children: [
          if(logic.stackList.length>0)
            Obx(()=>logic.stackList.value[logic.stackList.length-1])
        ],
      )),
    );
  }


}
