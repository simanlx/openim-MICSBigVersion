
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mics_big_version/src/models/zskjs/ZskjsListContentListItem.dart';
import 'package:mics_big_version/src/pages/bkparts/zskjs/ZskjsMainLogic.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:mics_big_version/src/widgets/search_box.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ZskjsMainPage extends StatelessWidget{

  var logic = Get.find<ZskjsMainLogic>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: PageStyle.c_FFFFFF,
      body: Obx(() => Row(
        children: [
          Container(width: 300.w,child: _buildLeft(context),),
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
      )),
    );
  }

  _buildLeft(BuildContext context) {
    return Column(
      children: [
        buildHead(),
        buildSearch(),
        Expanded(child: buildContent(context))
      ],
    );
  }
  Widget buildSearch(){
    return Visibility(
        visible: logic.showSearch.value,
        child:
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: SearchBox(
            enabled: true,
            onSubmitted: (string){
              //搜索了
              logic.selPos.value = 0;
              logic.secondList.clear();
              logic.getLisById(string);
            },
            margin: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
            padding: EdgeInsets.symmetric(horizontal: 13.w),
          ),
        ));
  }

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
              child: InkWell(
                child: Padding(child: Image.asset(
                  ImageRes.ic_back,
                  width: 15.h,
                  height: 15.h,
                ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w)),onTap: (){
                //返回
                logic.back();
              },
              )),
          Align(
            alignment: Alignment.center,
            child:  Text(StrRes.knowledgeBaseSearch,textAlign: TextAlign.center,style: PageStyle.ts_333333_16sp),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleImageButton(
                  imageStr: ImageRes.ic_searchGrey,
                  imageWidth: 16.h,
                  imageHeight: 16.h,
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

  buildContent(context) {
    return Column(
      children: [
        Expanded(
          child:Row(
            children: [
              Container(width: 50.w,child:
              MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child:ListView.builder(
                      itemCount: logic.titleList.length,
                      controller: logic.scrollController,
                      itemBuilder: (BuildContext context,int index){
                        return
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: (){
                                if (logic.selPos.value == index) {
                                  return;
                                }
                                logic.selPos.value = index;
                                logic.secondList.value.clear();
                                logic.getLisById("");
                              },
                              child: Obx(()=>Container(width: 100,height: 50.h,child: Align(child: Text(logic.titleList[index].name??"",style: TextStyle(
                                  color: logic.selPos.value==index?Colors.blue:PageStyle.c_81838F,fontSize: 14.sp
                              ),),alignment: Alignment.center,),
                                  decoration: logic.selPos.value==index?BoxDecoration(border: Border(right: BorderSide(color:Colors.blue,width: 3.w))):null))
                          );
                      }))
              ),
              SizedBox(width: 20.w),
              Expanded(child:
              Stack(
                children: [
                  MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child:
                    SmartRefresher(
                        controller: logic.refreshController,
                        header: WaterDropMaterialHeader(),
                        footer: IMWidget.buildFooter(),
                        onLoading: logic.onLoad,
                        onRefresh: logic.onRefresh,
                        enablePullDown: true,
                        enablePullUp: true,
                        child: ListView.builder(
                            controller: logic.scrollController2,
                            itemCount: logic.secondList.length,
                            itemBuilder: (BuildContext context,int index){
                              var item = logic.secondList[index];
                              return buildItem(item);
                            }
                        )),
                  ),
                  Stack(
                    children: [
                      Align(alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            //智能机器人聊天页面
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child:  Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 6.h),
                                // Icon(Icons.sync_problem),
                                Image.asset("assets/images/pic_jiqiren.png",height: 48.w,width: 48.w,),
                                SizedBox(height: 6.h),
                                Text("智能机器人",style: TextStyle(color: Colors.blue),),
                                SizedBox(height: 6.h),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )

              ),
              SizedBox(width: 20.w)
            ],
          ),),
        // Stack(
        //   children: [
        //     Align(alignment: Alignment.topRight,
        //       child: Padding(
        //         padding: EdgeInsets.only(right: 10.w),
        //         child:  Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             SizedBox(height: 10.h),
        //             // Icon(Icons.sync_problem),
        //             Image.asset("assets/images/pic_jiqiren.png",height: 48.w,width: 48.w,),
        //             SizedBox(height: 10.h),
        //             Text("智能机器人",style: TextStyle(color: Colors.blue),),
        //             SizedBox(height: 10.h),
        //           ],
        //         ),
        //       ),
        //     )
        //   ],
        // )

      ],
    );
  }

  Widget buildItem(ZskjsListContentListItemData item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        logic.changeContentTo(item);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(child: Text(item.name??"",style: TextStyle(color: PageStyle.c_333333,fontSize: 12.sp))),
              Container(decoration: BoxDecoration(
                  border: Border.all(color: PageStyle.c_7ac756,width: 1.r),
                  color: PageStyle.c_eef8e8,
                  borderRadius: BorderRadius.all(Radius.circular(5.r))
              ),
                  child: Padding(padding: EdgeInsets.fromLTRB(3.w, 4.w, 3.w, 4.w),
                    child:  Text(item.labelName??"",style: TextStyle(color: PageStyle.c_7ac756,fontSize: 12.sp),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 6.h),
          Text("CYBS22054896",style: TextStyle(color: PageStyle.c_999999,fontSize: 12.sp),),
          SizedBox(height: 6.h),
          Divider(height: 2.h,color: PageStyle.c_e8e8e8,)
        ],
      ),
    );
  }


}