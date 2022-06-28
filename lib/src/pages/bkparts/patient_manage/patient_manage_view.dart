import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/widgets/DefaultAvatar.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:mics_big_version/src/widgets/search_box.dart';
import 'package:mics_big_version/src/widgets/titlebar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'patient_manage_logic.dart';

//患者管理主页面
class PatientManagePage extends StatelessWidget {

  final logic = Get.find<PatientManageLogic>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: PageStyle.c_FFFFFF,
      body: Obx(() => Row(
        children: [
          Container(width: 250.w,child: _buildLeft(),),
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

  _buildLeft() {
    return Column(
      children: [
        buildHead(),

        Expanded(child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: buildSearch()
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index){
                    var bean = logic.list[index];
                    var isYly = (bean.hospitalized??0) == 2;
                    var days = bean.hospitalizedDays??0;
                    return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          logic.switchToDetail(bean);
                        },child:Padding(padding: EdgeInsets.fromLTRB(20,10.h, 20,0),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(bean.avatar??"",width: 36.w,height:36.w,fit:BoxFit.cover,errorBuilder: (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                  ){
                                var title = "";
                                try{
                                  if (bean.name!.length>2) {
                                    title = bean.name!.substring(0,2);
                                  }else{
                                    title = bean.name!;
                                  }
                                }catch(e){

                                }
                                return DefaultAvatar(title,height: 36.w,width: 36.w,);}),
                            ),
                            SizedBox(width: 18.w),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${bean.name}·${bean.sex}·${bean.age}·${bean.bedNumber}",style: TextStyle(color: PageStyle.c_333333)),
                                    SizedBox(height: 6.h),
                                    Text("${bean.illnessDesc}",style: TextStyle(color: PageStyle.c_999999),maxLines: 2,overflow: TextOverflow.ellipsis),
                                  ],
                                )),
                            SizedBox(width: 10.w),
                            Container(
                              decoration: BoxDecoration(color: isYly?PageStyle.c_eef8e8:PageStyle.c_E9F3FF,border: Border.all(width: 1,color: isYly?PageStyle.c_7ac756:PageStyle.c_3894FF),borderRadius: BorderRadius.all(Radius.circular(5))),
                              padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
                              child:Text(isYly?"已离院":"入院$days天",style: TextStyle(color:  isYly?PageStyle.c_7ac756:PageStyle.c_3894FF,fontSize: 10.sp),),
                            )
                          ],),
                        SizedBox(height: 10.h),
                        Divider(height: 2,color: PageStyle.c_e8e8e8,),
                      ],),
                    ));
                  },
                  childCount:logic.list.length,
                ))
          ],

        )),
        // SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       buildSearch(),
        //       Container(
        //         height: 200.h,
        //         child: SmartRefresher(
        //           controller: logic.refreshController,
        //           header: IMWidget.buildHeader(),
        //           footer: IMWidget.buildFooter(),
        //           enablePullDown: true,
        //           enablePullUp: true,
        //           onRefresh: logic.onRefresh,
        //           onLoading: logic.onLoading,
        //           child:  ListView.builder(
        //               itemCount: logic.list.length,
        //               itemBuilder: (BuildContext context,int index){
        //                 var bean = logic.list[index];
        //                 var isYly = (bean.hospitalized??0) == 2;
        //                 var days = bean.hospitalizedDays??0;
        //                 return GestureDetector(
        //                     behavior: HitTestBehavior.opaque,
        //                     onTap: (){
        //                       // logic.toPatientDetail(bean.id.toString());
        //                     },child:Padding(padding: EdgeInsets.fromLTRB(20,10.h, 20,0),
        //                   child: Column(children: [
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.start,
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         ClipRRect(
        //                           borderRadius: BorderRadius.circular(8.r),
        //                           child: Image.network(bean.avatar??"",width: 48.w,height:48.w,fit:BoxFit.cover,errorBuilder: (
        //                               BuildContext context,
        //                               Object error,
        //                               StackTrace? stackTrace,
        //                               ){
        //                             var title = "";
        //                             try{
        //                               if (bean.name!.length>2) {
        //                                 title = bean.name!.substring(0,2);
        //                               }else{
        //                                 title = bean.name!;
        //                               }
        //                             }catch(e){
        //
        //                             }
        //                             return DefaultAvatar(title);}),
        //                         ),
        //                         SizedBox(width: 20.w),
        //                         Expanded(
        //                             child: Column(
        //                               crossAxisAlignment: CrossAxisAlignment.start,
        //                               children: [
        //                                 Text("${bean.name}·${bean.sex}·${bean.age}·${bean.bedNumber}",style: TextStyle(color: PageStyle.c_333333)),
        //                                 SizedBox(height: 10.h),
        //                                 Text("${bean.illnessDesc}",style: TextStyle(color: PageStyle.c_999999),maxLines: 2,overflow: TextOverflow.ellipsis),
        //                               ],
        //                             )),
        //                         SizedBox(width: 10.w),
        //                         Container(
        //                           decoration: BoxDecoration(color: isYly?PageStyle.c_eef8e8:PageStyle.c_E9F3FF,border: Border.all(width: 1,color: isYly?PageStyle.c_7ac756:PageStyle.c_3894FF),borderRadius: BorderRadius.all(Radius.circular(5))),
        //                           padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
        //                           child:Text(isYly?"已离院":"入院$days天",style: TextStyle(color:  isYly?PageStyle.c_7ac756:PageStyle.c_3894FF,fontSize: 14.sp),),
        //                         )
        //                       ],),
        //                     SizedBox(height: 10.h),
        //                     Divider(height: 2,color: PageStyle.c_e8e8e8,),
        //                   ],),
        //                 ));
        //               }),
        //         ),
        //       )
        //     ],
        //   ),
        // )
      ],
    );
  }

  Widget buildSearch(){
    return Visibility(
        visible: logic.showSearch.value,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: SearchBox(
            height: 25.h,
            enabled: true,
            onSubmitted: (value){
              logic.search(value);
            },
            margin: EdgeInsets.fromLTRB(10.w, 11.h, 10.w, 0),
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
              child: InkWell(child: Padding(child: Image.asset(
                ImageRes.ic_back,
                width: 12.w,
                height: 20.h,
              ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w),),onTap: (){
                //返回
                logic.back();
              },
              )),
          Align(
            alignment: Alignment.center,
            child:  Text(StrRes.patientManage,textAlign: TextAlign.center,style: PageStyle.ts_333333_16sp),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleImageButton(
                  padding:EdgeInsets.all(0),
                  imageStr: ImageRes.ic_searchGrey,
                  imageWidth: 16.h,
                  imageHeight: 16.h,
                  color: Color(0xFF333333),
                  onTap: (){
                    logic.showSearch.value = true;
                  },
                ),
                TitleImageButton(
                  imageStr: ImageRes.ic_addBlack,
                  imageWidth: 16.h,
                  imageHeight: 16.h,
                  color: Color(0xFF333333),
                  onTap: (){
                    logic.addPatient();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
