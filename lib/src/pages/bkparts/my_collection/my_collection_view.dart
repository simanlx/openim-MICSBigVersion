import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/models/zskjs/CollectListRes.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:mics_big_version/src/widgets/search_box.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'my_collection_logic.dart';

class MyCollectionPage extends StatelessWidget {

  final logic = Get.find<MyCollectionLogic>();
  MyCollectionPage({Key? key}) : super(key: key);

  Widget buildSearch(){
    return Visibility(
        visible: logic.showSearch.value,
        child: SearchBox(
          enabled: true,
          margin: EdgeInsets.fromLTRB(5.w, 11.h, 5.w, 5.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          onSubmitted: (String key){
            logic.search(key);
          },
        ));
  }

  ActionPane _buildActionPane(Data item) => ActionPane(
    motion: ScrollMotion(),
    extentRatio: .2,
    children: [
      SlidableAction(
        flex: 1,
        onPressed: (_) => {
          //删除
          logic.deleteItem(item)
        },
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: StrRes.delete,
      ),
    ],
  );

  Widget buildHead(){

    return  Container(
      height: 40.h,
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
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
          Align(
              alignment: Alignment.centerLeft,
              child: InkWell(child: Padding(child: Image.asset(
                ImageRes.ic_back,
                width: 10.w,
                height: 16.h,
              ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w)),onTap: (){
                //返回
                logic.back();
              },
              )),
          Align(
            alignment: Alignment.center,
            child:  Text(StrRes.myCollection,textAlign: TextAlign.center,style: PageStyle.ts_333333_16sp),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleImageButton(
                  imageStr: ImageRes.ic_searchGrey,
                  imageWidth: 18.h,
                  imageHeight: 18.h,
                  color: Color(0xFF333333),
                  onTap: (){
                    logic.showSearch.value = true;
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Obx(()=>
          Scaffold(
              backgroundColor: PageStyle.c_FFFFFF,
              body: Row(
                children: [
                  Container(
                    height: 1.sh,
                    width: 280.w,
                    child: Column(
                      children: [
                        buildHead(),
                        buildSearch(),
                        Expanded(child: buildContent(context))
                      ],
                    ),
                  ),
                  Container(width: 2.w,color: PageStyle.c_e8e8e8,),
                  Expanded(child: Obx(()=>Column(
                    children: [
                      Expanded(child: Stack(
                        children: [
                          if(logic.stackList.length>0)
                          // logic.stackList.value[logic.stackList.length-1]
                            Obx(()=>logic.stackList.value[logic.stackList.length-1])
                        ],
                      ))
                    ],
                  )))
                ],
              )
          ));
  }



  buildContent(BuildContext context) {
    return Column(
      children: [
        Expanded(child:Row(
          children: [
            Container(width: 60.w,child:
            MediaQuery.removePadding(
              removeTop: true,
              context: context,child:
            ListView.builder(
                itemCount: logic.titleList.length,
                controller: logic.scrollController,
                itemBuilder: (BuildContext context,int index){
                  return
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          logic.selPos.value = index;
                          logic.list.clear();
                          logic.getList();
                        },
                        child: Obx(()=>Container(width: 100,height: 50.h,child: Align(child: Text(logic.titleList[index],style: TextStyle(
                            color: logic.selPos.value==index?Colors.blue:PageStyle.c_81838F,fontSize: 14.sp
                        ),),alignment: Alignment.center,),
                            decoration: logic.selPos.value==index?BoxDecoration(border: Border(right: BorderSide(color:Colors.blue,width: 3.w))):null))
                    );
                }),
            )
            ),
            SizedBox(width: 20.w),
            Expanded(child:
            SmartRefresher(controller: logic.smartRefresh,
              enablePullDown: true,
              enablePullUp: true,
              header: IMWidget.buildHeader(),
              footer: IMWidget.buildFooter(),
              onRefresh: logic.getList,
              onLoading: logic.getListMore,
              child: ListView.builder(
                  controller: logic.scrollController2,
                  itemCount: logic.list.length,
                  itemBuilder: (BuildContext context,int index){
                    //通知 备忘 归档 聊天
                    //文件 图片 备忘
                    var item = logic.list[index];
                    return itemWithPic(item);
                    // if(index == 0 || index == 1){
                    //   return itemWithoutPic();
                    // }else{
                    //   return itemWithPic();
                    // }
                  }),

            )
            ),
            SizedBox(width: 4.w)
          ],
        ),),
      ],
    );
  }


  Widget itemWithoutPic(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 6.h),
        Text("有关五一放假轮休安排的通知有关五一放假轮休排的通知有关五一放假轮",maxLines: 1,textAlign: TextAlign.start,style: TextStyle(overflow:TextOverflow.ellipsis,color: PageStyle.c_333333,fontSize: 16.sp)),
        SizedBox(height: 5.h),
        Row(children: [
          Text("通知",style: TextStyle(overflow:TextOverflow.ellipsis,color: PageStyle.c_999999,fontSize: 16.sp)),
          Text(" | ",style: TextStyle(overflow:TextOverflow.ellipsis,color: PageStyle.c_999999,fontSize: 16.sp)),
          Expanded(child: Text("章北海 2022-5-7 12:57:05",style: TextStyle(overflow:TextOverflow.ellipsis,color: PageStyle.c_999999,fontSize: 16.sp))),
        ],),
        SizedBox(height: 10.h),
        Divider(height: 4.h,color: PageStyle.c_e8e8e8)
      ],
    );
  }

  Widget itemWithPic(Data item){
    var type = item.type??0;
    var typeStr = "";
    switch(type){
      case 1:
        typeStr = "聊天";
        break;
      case 2:
        typeStr = "语音";
        break;
      case 3:
        typeStr = "文件";
        break;
      case 4:
        typeStr = "图片";
        break;
      case 5:
        typeStr = "视频";
        break;
      case 6:
        typeStr = "归档";
        break;
      case 8:
        typeStr = "备忘";
        break;
    }
    var timeStr = DateUtil.formatDateMs(int.parse(item.extraInfo?.createTime??""), format: 'yyyy-MM-dd HH:mm:ss');
    // 1 聊天
    // 2 语音
    // 3 file
    // 4 图片
    // 5 视频
    // 6 患者管理
    return
      Slidable(key: ValueKey(item.id),child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          logic.switchToDetail(item);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            Row(
              children: [
                // Image.network("src",width: 40.w,height: 40.h),
                // Icon(Icons.insert_drive_file_outlined,size: 40.h,),
                // SizedBox(width: 10.w),
                Expanded(child:
                Text(item.title??"",maxLines: 2,textAlign: TextAlign.start,style: TextStyle(overflow:TextOverflow.ellipsis,color: PageStyle.c_333333,fontSize: 14.sp)),
                )
              ],
            ),
            SizedBox(height: 5.h),
            Row(children: [
              // Text("通知",style: TextStyle(overflow:TextOverflow.ellipsis,color: PageStyle.c_999999,fontSize: 16.sp)),
              // Text(" | ",style: TextStyle(overflow:TextOverflow.ellipsis,color: PageStyle.c_999999,fontSize: 16.sp)),
              Expanded(child: Text("$typeStr | ${item.extraInfo?.createUserName} $timeStr",style: TextStyle(overflow:TextOverflow.ellipsis,color: PageStyle.c_999999,fontSize: 12.sp))),
            ],),
            SizedBox(height: 10.h),
            Divider(height: 2.h,color: PageStyle.c_e8e8e8)
          ],
        ),
      ),endActionPane: _buildActionPane(item),);
  }
}
