import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../res/images.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../widgets/TabBarView.dart';
import '../../widgets/bottombar.dart';
import '../contacts/contacts_view.dart';
import '../conversation/conversation_view.dart';
import '../mine/mine_view.dart';
import '../work_bench/work_bench_view.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {

  final logic = Get.find<HomeLogic>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: PageStyle.c_FFFFFF,
      body: Obx(() => Column(
        children: [
          SizedBox(height: 20.h,),
          Container(width: 812.w,color:Colors.blue ,child: Stack(
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
              )),alignment: Alignment.centerRight,)
            ],
          ),),
          Expanded(
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
        ],
      )),
    );
  }
}
