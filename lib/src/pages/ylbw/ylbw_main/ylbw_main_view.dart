import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/models/zskjs/YlbwListBean.dart';
import 'package:mics_big_version/src/pages/ylbw/ylbw_main/ylbw_main_logic.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:mics_big_version/src/widgets/search_box.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'ylbw_main_logic.dart';

class YlbwMainPage extends StatelessWidget {

  final logic = Get.find<YlbwMainLogic>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: PageStyle.c_FFFFFF,
      body: Obx(() => Row(
        children: [
          Container(width: 250.w,child: _buildLeft(context),),
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

  Widget buildHead(){

    return  Container(
      height: 40.h,
      padding: EdgeInsets.only(left:10.w,right:10.w),
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
                width: 12.w,
                height: 20.h,
              ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w)),onTap: (){
                //返回
                logic.back();
              },
              )),
          Align(
            alignment: Alignment.center,
            child:  Text(StrRes.medicalMemo,textAlign: TextAlign.center,style: PageStyle.ts_333333_16sp),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleImageButton(
                  imageStr: ImageRes.ic_searchGrey,
                  imageWidth: 24.w,
                  imageHeight: 24.h,
                  color: Color(0xFF333333),
                  onTap: (){
                    logic.showSearch.value = true;
                  },
                ),
                // TitleImageButton(
                //   imageStr: ImageRes.ic_addBlack,
                //   imageWidth: 24.w,
                //   imageHeight: 24.h,
                //   color: Color(0xFF333333),
                //   onTap: (){
                //     logic.toAdd();
                //   },
                // )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSearch(){
    return Obx(()=>Visibility(
        visible: logic.showSearch.value,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: logic.globalSearch,
          child: SearchBox(
            height: 26.h,
            backgroundColor: Colors.white,
            enabled: true,
            margin: EdgeInsets.fromLTRB(10.w, 11.h,10.w , 0),
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            onSubmitted: (String value){
              logic.keyword = value;
              // logic.list.clear();
              logic.getList("");
            },
          ),
        )));
  }

  buildContent(BuildContext context) {
    return
      Container(
          margin: EdgeInsets.all(10.w),
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(10.r))),
          child:
          SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            header: IMWidget.buildHeader(),
            footer: IMWidget.buildFooter(),
            onLoading: (){
              logic.getMore("");
            },
            onRefresh: (){
              logic.getList("");
            },
            controller: logic.controller,
            child:
            ListView.builder(
                itemCount: logic.list.length,
                itemBuilder: (BuildContext context,int index){
                  var bean = logic.list[index];
                  //判断有没有包含图片
                  var picImgUrl = isContainPic(bean);
                  return _buildItem(picImgUrl,bean);
                }),
          )
      );

  }


  ActionPane _buildActionPane(YlbwListBeanData info) => ActionPane(
    motion: ScrollMotion(),
    extentRatio: .2,
    children: [
      SlidableAction(
        flex: 1,
        onPressed: (_) => logic.deleteItem(info),
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: StrRes.delete,
      ),
    ],
  );

  //是否带图片
  _buildItem(String picImgUrl, YlbwListBeanData bean) {

    return Slidable(key: ValueKey(bean.id),
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => logic.toDetail(bean),
          child:
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      SizedBox(width: 10.w),
                      Visibility(visible:picImgUrl.isNotEmpty,child: Padding(child: Image.network(picImgUrl,width: 40.w,height: 40.w,fit: BoxFit.fill),padding: EdgeInsets.only(right: 10.w))),
                      Expanded(child: Text("${bean.title??""}",style: TextStyle(color: PageStyle.c_333333,overflow: TextOverflow.ellipsis),maxLines: picImgUrl.isNotEmpty?2:1,)),
                      // Container(decoration: BoxDecoration(
                      //     border: Border.all(color: PageStyle.c_3894FF,width: 1.r),
                      //     color: PageStyle.c_E9F3FF,
                      //     borderRadius: BorderRadius.all(Radius.circular(5.r))
                      // ),
                      //     child: Padding(padding: EdgeInsets.fromLTRB(6.w, 4.w, 6.w, 4.w),
                      //       child:  Text(bean.typeName??"",style: TextStyle(color: PageStyle.c_3894FF,fontSize: 14.sp),
                      //       ),
                      //     )),
                      SizedBox(width: 10.w),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(children: [
                    SizedBox(width: 10.w),
                    Expanded(child: Text("${bean.typeName} | ${logic.nickname} ${bean.createTime}",style: TextStyle(color: PageStyle.c_999999)))
                  ],),
                  SizedBox(height: 10.h),
                  Divider(height: 2.h,color: PageStyle.c_e8e8e8)
                ],
              ),
              Align(child: Visibility(visible: bean.isTop==1,child: Image.asset(ImageRes.ic_flag_top,width: 15.w,height: 15.w)),alignment: Alignment.topRight)
            ],
          )
      ),
      endActionPane: _buildActionPane(bean),);
  }



  String isContainPic(YlbwListBeanData item){
    if(item.noteData!=null){
      for(var i in item.noteData!){
        if(i.type == "img" && i.data.isNotEmpty){
          return i.data;
        }
      }
    }

    return "";
  }
  Widget buildFooter() {
    return Container(height: 30.h,
      color: Colors.white,
      child: Stack(
        children: [
          Align(alignment: Alignment.center,child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Text(logic.allCount.value == 0?"":"${logic.allCount.value}个备忘录",textAlign: TextAlign.center,style: TextStyle(color: PageStyle.c_9b9b9b),)),
              // GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   child:Image.asset(ImageRes.ic_edit,width: 30.w,height: 30.w,),onTap: (){
              //   logic.toAdd();
              // },),
              // SizedBox(width: 20.w)
            ],
          )),
          Align(alignment: Alignment.centerRight,child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child:Padding(padding: EdgeInsets.only(right: 15.w),child: Image.asset(ImageRes.ic_edit,width: 26.w,height: 26.w,),),onTap: (){
            logic.toAdd();
          },),)
        ],
      ),
    );
  }

  _buildLeft(BuildContext context) {
    return  Scaffold(
        backgroundColor: PageStyle.c_EEEEEE,
        body: Container(
          height: 1.sh,
          child: Column(
            children: [
              buildHead(),
              buildSearch(),
              Expanded(child:
              Stack(
                children: [
                  Visibility(
                    visible: logic.list.length == 0 && logic.isLoaded, child: Align(alignment: Alignment.center,child: Column(
                    children: [
                      Image.asset(ImageRes.ic_no_data,width: 120.w,height: 120.w,),
                      SizedBox(height: 20.h),
                      Text("暂无备忘")
                    ],
                  ),),
                  ),
                  Visibility(
                      visible: logic.list.length > 0, child:
                  buildContent(context)
                    // SingleChildScrollView(child: Column(
                    //   children: [
                    //     ConstrainedBox(constraints: BoxConstraints(
                    //         minHeight: 280.h,
                    //         maxHeight: 600.h
                    //     ),
                    //       child: buildContent(context),
                    //     )
                    //     // Expanded(child:
                    //     // buildContent(context)
                    //     //   // Padding(child: buildContent(context),padding: EdgeInsets.symmetric(horizontal: 20.w))
                    //     // ),
                    //   ],
                    // ),
                  ),
                  // )
                  // ),
                ],
              )
              ),
              buildFooter()
            ],
          ),
        ));
  }
}
