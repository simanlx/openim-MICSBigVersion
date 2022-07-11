import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mics_big_version/src/pages/home/mine/mine_view.dart';
import 'package:mics_big_version/src/pages/home/work_bench/work_bench_logic.dart';
import 'package:mics_big_version/src/pages/home/work_bench/workbench_main/workbench_main_view.dart';
import 'package:mics_big_version/src/widgets/bkrs/MoveAbleWidget.dart';
import 'package:mics_big_version/src/widgets/bkrs/SpeechListeningWidget.dart';
import '../../res/images.dart';
import '../../res/styles.dart';
import '../../widgets/TabBarView.dart';
import './contacts/contacts_view.dart';
import './conversation/conversation_view.dart';
import './work_bench/work_bench_view.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {

  final logic = Get.find<HomeLogic>();
  final workbenchLogic = Get.find<WorkbenchLogic>();
  var glkey = GlobalKey();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(() => Stack(
        key: glkey,
        children: [
          Positioned(child: Container(
            width: 812.w,
            height: 375.h,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(ImageRes.ic_home_main_bg),fit: BoxFit.fill),
            ),
          ),top: 0,left: 0,),
          Positioned(child: Image.asset(ImageRes.ic_home_main_logo,),left: 20.w,top: 10.h,height: 40.h,width: 180.w,),
          Column(
            children: [
              SizedBox(height: 10.h,),
              Container(
                width: 812.w,child: Stack(
                children: [
                  Align(child: Obx(()=>MyTabBarView(
                    index: logic.index.value,
                    items: [
                      "工作台",
                      "会话",
                      "通讯录",
                      "个人信息"
                    ],
                    onTap: (i) => logic.switchTab(i),
                  )),alignment: Alignment.center,)
                ],
              ),),
              // Container(
              //   margin: EdgeInsets.only(left: 15.w,right: 15.w),
              //   height: 310.h,
              //   child: Stack(
              //     children: [
              //       IndexedStack(
              //         index: logic.index.value,
              //         children: [
              //           WorkbenchPage(),
              //           ConversationPage(),
              //           ContactsPage(),
              //           MinePage(),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w,right: 15.w),
                  child: Stack(
                    children: [
                      IndexedStack(
                        index: logic.index.value,
                        children: [
                          WorkbenchPage(),
                          ConversationPage(),
                          ContactsPage(),
                          MinePage(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h)
            ],
          ),
          Obx(()=>Visibility(
              visible: logic.index == 0?workbenchLogic.stackList.length == 1:true,
              child: MoveAbleWidget(child: SpeechListeningWidget(),key: UniqueKey(), stackKey: glkey,offsetX: 900.w,offsetY: 800.h)))
        ],
      )),
    );
  }
}
