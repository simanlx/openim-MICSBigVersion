
//患者详情界面

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:mics_big_version/src/models/zskjs/PatientRoomRes.dart';
import 'package:mics_big_version/src/pages/bkparts/patient_manage/patient_detail/patient_detail_logic.dart';
import 'package:mics_big_version/src/pages/home/conversation/conversation_logic.dart';
import 'package:mics_big_version/src/utils/EventBusBkrs.dart';
import 'package:mics_big_version/src/widgets/OverScrollBehavior.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../common/apis.dart';
import '../../../../models/zskjs/PatientDetailRes.dart';
import '../../../../res/images.dart';
import '../../../../res/strings.dart';
import '../../../../res/styles.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/im_util.dart';
import '../../../../widgets/bottom_sheet_view.dart';
import '../../../../widgets/im_widget.dart';
import '../../../../widgets/titlebar.dart';
import '../../../select_contacts/select_contacts_logic.dart';

class PatientDetailPage extends StatefulWidget {
  PatientDetailPage({Key? key,this.id = ""}) : super(key: key);
  var id = "";
  @override
  State<PatientDetailPage> createState()=>_PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage>{

  @override
  void dispose() {
    print("患者详情页面 销毁");
    super.dispose();
  }


  var logic = Get.find<PatientDetailLogic>();
  var conversationLogic = Get.find<ConversationLogic>();

  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var zyhController = TextEditingController();
  var szbcController = TextEditingController();
  var bqjjController = TextEditingController();

  // var sex = "";
  // var patientRoomStr = "";

  PatientDetailRes? item;

  List<PatientRoomRes> roomList = [];

  void loadData(){
    // var id = Get.arguments["id"];
    Apis.patientDetail(widget.id).then((value){
      if (value!=null) {
        setState(() {
          item = value;
          isLoadSuccess = true;
          checkImInGroup();
          //赋值
          // nameController.text = value.name??"";
          // ageController.text = value.age??"";
          // zyhController.text = value.inpatientNumber??"";
          // szbcController.text = value.bedNumber??"";
          // bqjjController.text = value.illnessDesc??"";
          // sex = value.sex??"";
          // patientRoomStr = value.patientRoomName??"";
        });
      }
    });
    //获取病房列表
    Apis.getPatientRoomList().then((value){
      if(value!=null){
        roomList.clear();
        roomList.addAll(value);
      }
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  bool isLoadSuccess = false;
  var popControl = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PageStyle.c_FFFFFF,
        body: Container(
            height: 1.sh,
            child:buildList()
        )
    );
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
          // Align(
          //     alignment: Alignment.centerLeft,
          //     child: InkWell(child: Padding(child: Image.asset(
          //       ImageRes.ic_back,
          //       width: 12.w,
          //       height: 20.h,
          //     ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w),),onTap: (){
          //       //返回
          //       // logic.back();
          //     },
          //     )),
          Align(
            alignment: Alignment.center,
            child:  Text("患者详情",textAlign: TextAlign.center,style: PageStyle.ts_333333_18sp),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopButton(
                  popCtrl: popControl,
                  menuBgColor: Color(0xFFFFFFFF),
                  showArrow: false,
                  menuBgShadowColor: Color(0xFF000000).withOpacity(0.16),
                  menuBgShadowBlurRadius: 6,
                  menuBgShadowSpreadRadius: 2,
                  menuItemTextStyle: PageStyle.ts_333333_14sp,
                  menuItemHeight: 44.h,
                  // menuItemWidth: 170.w,
                  menuItemPadding: EdgeInsets.only(left: 20.w, right: 30.w),
                  menuBgRadius: 6,
                  // menuItemIconSize: 24.h,
                  menus: [
                    PopMenuInfo(
                      text: "分享",
                      icon: ImageRes.ic_popAddFriends,
                      onTap: (){
                        Get.toNamed(AppRoutes.SELECT_CONTACTS,arguments: {
                          'action': SelAction.MyFORWARD,
                          'patientItem':item,
                          'sharePath':AppRoutes.HOME
                        });

                      },
                    ),
                    PopMenuInfo(
                      text: "收藏",
                      icon: ImageRes.ic_popScan,
                      onTap: (){
                        //保存并收藏
                        // var id = Get.arguments["id"];
                        Apis.patientDetail(widget.id).then((value){
                          print("回来的数据 $value");
                          if (value!=null) {
                            var content = {
                              "title":"[${value.name??""}]的患者档案",
                              "from":"[患者管理]",
                              "type":6,
                              "data": {
                                "patient":value.toJson()
                              },
                            };
                            Apis.addLike(OpenIM.iMManager.uInfo.userID??"", OpenIM.iMManager.uInfo.nickname??"", OpenIM.iMManager.uInfo.faceURL??"", DateTime.now().millisecondsSinceEpoch.toString(), content).then((value){
                              IMWidget.showToast("收藏成功");
                            });
                          }
                        });
                      },
                    ),

                  ],
                  child: TitleImageButton(
                    imageStr: ImageRes.ic_more,
                    imageHeight: 24.h,
                    imageWidth: 23.w,
                    // onTap: (){},
                    // onTap: onClickAddBtn,
                    // height: 50.h,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void selectGender() {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrRes.man,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            onTap: (){
              Apis.updatePatient(item?.id.toString()??"",sex: "男").then((value){
                setState(() {
                  item?.sex = "男";
                  busBkrs.emit("updatePatientManage","");
                });
              });
            },
          ),
          SheetItem(
            label: StrRes.woman,
            onTap: (){
              Apis.updatePatient(item?.id.toString()??"",sex: "女").then((value){
                setState(() {
                  item?.sex = "女";
                  busBkrs.emit("updatePatientManage","");
                });
              });
            },
          ),
        ],
      ),
    );
  }

  // PatientRoomRes? selRoom;

  void showRoomList(){
    Get.dialog(Center(child: Container(margin: EdgeInsets.symmetric(horizontal: 40.w),width: 1.sw,height: 150.h,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.r)),child: ListView.builder(itemBuilder: (BuildContext context,int index){
        var item2 =  roomList[index];
        return Row(children: [
          InkWell(child: Container(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(item2.name??"",style: TextStyle(fontSize: 18.sp),),),onTap: (){
            Apis.updatePatient(item?.id.toString()??"",patient_room:item2.id.toString()).then((value){
              setState(() {
                busBkrs.emit("updatePatientManage","");
                item?.patientRoom = item2.id;
                item?.patientRoomName = item2.name;
                // selRoom = item2;
                // patientRoomStr = item2.name??"";
              });
            });
            Get.back();
          },)],mainAxisAlignment: MainAxisAlignment.center,);
      },itemCount: roomList.length,),),));
  }

  // //更新
  // void updateInfo(){
  //   if (verifyInput()) {
  //     //调用更新了
  //     // Apis.updatePatient();
  //   }
  // }
  //
  //
  // bool verifyInput(){
  //   var nameStr = nameController.text;
  //   var ageStr = ageController.text;
  //   var szbcStr = szbcController.text;
  //   var zyhStr = zyhController.text;
  //   var bqjjStr = bqjjController.text;
  //
  //   if(nameStr.isEmpty){
  //     IMWidget.showToast("请输入姓名");
  //     return false;
  //   }
  //
  //   if(ageStr.isEmpty){
  //     IMWidget.showToast("请输入年龄");
  //     return false;
  //   }
  //
  //   if(patientRoomStr.isEmpty){
  //     IMWidget.showToast("请选择所在病房");
  //     return false;
  //   }
  //
  //   // if(szbcStr.isEmpty){
  //   //   IMWidget.showToast("请输入所在病床");
  //   //   return false;
  //   // }
  //
  //
  //   if(zyhStr.isEmpty){
  //     IMWidget.showToast("请输入住院号");
  //     return false;
  //   }
  //
  //   return true;
  // }

  void showNameDialog(){
    nameController.text = item?.name??"";
    Get.dialog(
        Material(color: Colors.transparent,child: Center(child:      Container(margin: EdgeInsets.symmetric(horizontal: 40.w),
          width: 1.sw,height: 110.h,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Text("修改姓名",textAlign: TextAlign.center),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(child: TextField(autofocus: true,controller: nameController,)),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: (){
                      if (nameController.text.isEmpty) {
                        IMWidget.showToast("请输入姓名");
                        return;
                      }
                      var txt = nameController.text;
                      Apis.updatePatient(item?.id.toString()??"",name: txt).then((value){
                        setState(() {
                          item?.name = txt;
                          busBkrs.emit("updatePatientManage","");
                        });
                      });
                      Get.back();
                    },
                    child: Container(
                      // height: 28.h,
                      padding: EdgeInsets.only(
                        top: 3.h,
                        bottom: 4.5.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      height: 30.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: PageStyle.c_1B72EC,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        StrRes.save,
                        style: PageStyle.ts_FFFFFF_16sp,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),),)
    );
  }

  void showzyhDialog(){
    zyhController.text = item?.inpatientNumber??"";
    Get.dialog(
        Material(color: Colors.transparent,child: Center(child:      Container(margin: EdgeInsets.symmetric(horizontal: 40.w),
          width: 1.sw,height: 110.h,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Text("修改住院号",textAlign: TextAlign.center),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(child: TextField(autofocus: true,controller: zyhController,)),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: (){
                      if (zyhController.text.isEmpty) {
                        IMWidget.showToast("请输入住院号");
                        return;
                      }
                      var txt = zyhController.text;
                      Apis.updatePatient(item?.id.toString()??"",inpatient_number: txt).then((value){
                        setState(() {
                          item?.inpatientNumber = txt;
                          busBkrs.emit("updatePatientManage","");
                        });
                      });
                      Get.back();
                    },
                    child: Container(
                      // height: 28.h,
                      padding: EdgeInsets.only(
                        top: 3.h,
                        bottom: 4.5.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      height: 30.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: PageStyle.c_1B72EC,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        StrRes.save,
                        style: PageStyle.ts_FFFFFF_16sp,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),),)

    );
  }

  void showszbcDialog(){
    szbcController.text = item?.bedNumber??"";
    Get.dialog(
        Material(color: Colors.transparent,child: Center(child:      Container(margin: EdgeInsets.symmetric(horizontal: 40.w),
          width: 1.sw,height: 110.h,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Text("修改所在病床",textAlign: TextAlign.center),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(child: TextField(autofocus: true,controller: szbcController,)),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: (){
                      if (szbcController.text.isEmpty) {
                        IMWidget.showToast("请输入所在病床");
                        return;
                      }
                      var txt = szbcController.text;
                      Apis.updatePatient(item?.id.toString()??"",bed_number: szbcController.text).then((value){
                        setState(() {
                          item?.bedNumber = txt;
                          busBkrs.emit("updatePatientManage","");
                        });
                      });
                      Get.back();
                    },
                    child: Container(
                      // height: 28.h,
                      padding: EdgeInsets.only(
                        top: 3.h,
                        bottom: 4.5.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      height: 30.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: PageStyle.c_1B72EC,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        StrRes.save,
                        style: PageStyle.ts_FFFFFF_16sp,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),),)

    );
  }

  void showbqjjDialog(){
    bqjjController.text = item?.illnessDesc??"";
    Get.dialog(
        Material(color: Colors.transparent,child: Center(child:Container(margin: EdgeInsets.symmetric(horizontal: 20.w),
          width: 1.sw,height: 280.h,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Text("修改病情简介",textAlign: TextAlign.center),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(child: TextField(decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r),borderSide: BorderSide(color: PageStyle.c_e8e8e8,width: 1.w)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r),borderSide: BorderSide(color: PageStyle.c_e8e8e8,width: 1.w)))
                    ,autofocus: true,maxLines: 5,controller: bqjjController,)),
                  SizedBox(width: 10.w),
                ],
              ),
              SizedBox(height: 10.w),
              GestureDetector(
                onTap: (){
                  if (bqjjController.text.isEmpty) {
                    IMWidget.showToast("请输入病情简介");
                    return;
                  }
                  var txt = bqjjController.text;
                  Apis.updatePatient(item?.id.toString()??"",Illness_desc: txt).then((value){
                    setState(() {
                      item?.illnessDesc = txt;
                      busBkrs.emit("updatePatientManage","");
                    });
                  });
                  Get.back();
                },
                child: Container(
                  // height: 28.h,
                  padding: EdgeInsets.only(
                    top: 3.h,
                    bottom: 4.5.h,
                    left: 10.w,
                    right: 10.w,
                  ),
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: PageStyle.c_1B72EC,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    StrRes.save,
                    style: PageStyle.ts_FFFFFF_16sp,
                  ),
                ),
              ),
            ],
          ),
        ),),)

    );
  }

  void showAgeDialog(){
    ageController.text = item?.age??"";
    Get.dialog(
        Center(child: Container(margin: EdgeInsets.symmetric(horizontal: 40.w),width: 1.sw,height: 110.h,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Text("修改年龄",textAlign: TextAlign.center),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(child: TextField(autofocus: true,keyboardType:TextInputType.number,inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],controller: ageController,decoration: InputDecoration(hintText: "请输入年龄",hintStyle: TextStyle(fontSize: 16.sp)))),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: (){
                      if (ageController.text.isEmpty) {
                        IMWidget.showToast("请输入年龄");
                        return;
                      }
                      var txt = ageController.text;
                      Apis.updatePatient(item?.id.toString()??"",age: txt);
                      setState(() {
                        item?.age = txt;
                        busBkrs.emit("updatePatientManage","");
                      });
                      Get.back();
                    },
                    child: Container(
                      // height: 28.h,
                      padding: EdgeInsets.only(
                        top: 3.h,
                        bottom: 4.5.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      height: 30.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: PageStyle.c_1B72EC,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        StrRes.save,
                        style: PageStyle.ts_FFFFFF_16sp,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ))
    );
  }

  /// 打开相册
  void onTapAlbum() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(

      Get.context!,
      pickerConfig: const AssetPickerConfig(requestType: RequestType.image,maxAssets: 1),
    );
    if (null != assets) {
      for (var asset in assets) {
        var rawFile = await asset.file;
        if (rawFile == null) {
          continue;
        }
        //压缩图片
        var pressedFile =await IMUtil.compressAndGetPic(rawFile);
        var filePath = "";
        var fileSize = 0;
        var filename = "";
        if (pressedFile == null) {
          filePath = rawFile.path;
          fileSize = await rawFile.length();
        }else{
          filePath = pressedFile.path;
          fileSize = await pressedFile.length();
        }
        print("图片信息 ${pressedFile}  ${fileSize}");
        Apis.ylbwUploadImage(filePath).then((value) => {
          if (value != null) {
            setState(() {
              item?.avatar = value.showUrl;
            }),
            Apis.updatePatient(item?.id.toString()??"",avatar: value.showUrl).then((value){
              busBkrs.emit("updatePatientManage","");
            })
          }
        });
      }
    }
  }

  buildList() {
    var isGuiDang = ((item?.isArchive??"") != "0");
    return Column(
      children: [
        buildHead(),
        Expanded(child:
        Visibility(visible: isLoadSuccess,child:
        ScrollConfiguration( behavior: OverScrollBehavior(),child: SingleChildScrollView(
            child:Column(
              children: [
                Container(
                  height: 40.h,
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child: Row(children: [
                      Text("姓名"),
                      Expanded(child: InkWell(child: Text(item?.name??"",textAlign: TextAlign.end,),onTap: showNameDialog,)),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],),
                  ),
                ),

                Divider(height: 2,color: PageStyle.c_e8e8e8,),
                Container(
                  height: 40.h,
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child: InkWell(child: Row(children: [
                      Text("头像"),
                      Expanded(child: Container()),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(item?.avatar??"",width: 44.w,height:44.w,fit:BoxFit.cover,errorBuilder: (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                            ){
                          return Container(width: 48.w,height:48.w);}),
                      ),
                      // Image.network(item?.avatar??"",width: 40.h,height: 40.h,fit: BoxFit.fill,errorBuilder:(  BuildContext context,
                      // Object error,
                      // StackTrace? stackTrace){
                      // return Container();
                      // }),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],),onTap: onTapAlbum,),
                  ),
                ),

                Divider(height: 2,color: PageStyle.c_e8e8e8,),
                Container(
                  height: 40.h,
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child:Row(children: [
                      Text("性别"),
                      Expanded(child: Container()),
                      Expanded(child: InkWell(child: Text(item?.sex??"",textAlign:TextAlign.end,),onTap: selectGender,),),
                      // Text(item?.sex??"",style:TextStyle(color: Colors.grey)),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],),
                  ),
                ),

                Divider(height: 2,color: PageStyle.c_e8e8e8,),
                Container(
                  height: 40.h,
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child: Row(children: [
                      Text("年龄"),
                      Expanded(child: Container()),
                      Expanded(child: InkWell(child: Text(item?.age??"",textAlign: TextAlign.end,),onTap: showAgeDialog)),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],),
                  ),
                ),


                Divider(height: 2,color: PageStyle.c_e8e8e8,),
                Container(
                  height: 40.h,
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child: Row(children: [
                      Text("住院号"),
                      Expanded(child: InkWell(child: Text(item?.inpatientNumber??"",textAlign: TextAlign.end,),onTap: showzyhDialog)),
                      // Expanded(child:TextField(textAlign: TextAlign.end,controller: zyhController,decoration: InputDecoration(hintText: "请输入住院号",hintStyle: TextStyle(fontSize: 16.sp),border: InputBorder.none))),
                      // Expanded(child: Text(item?.inpatientNumber??"",style:TextStyle(color: Colors.grey),textAlign: TextAlign.end,overflow:TextOverflow.ellipsis,maxLines: 1)),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],),
                  ),
                ),


                Divider(height: 2,color: PageStyle.c_e8e8e8,),
                Container(
                  height: 40.h,
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child: Row(children: [
                      Text("所在病房"),
                      Expanded(child: InkWell(child: Text(item?.patientRoomName??"",textAlign:TextAlign.end,),onTap: showRoomList),),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],),
                  ),
                ),


                Divider(height: 2,color: PageStyle.c_e8e8e8,),
                Container(
                  height: 40.h,
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child: Row(children: [
                      Text("所在病床"),
                      Expanded(child: InkWell(child: Text(item?.bedNumber??"",textAlign: TextAlign.end,),onTap: showszbcDialog)),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],),
                  ),
                ),


                Divider(height: 2,color: PageStyle.c_e8e8e8,),
                Container(
                  height: 40.h,
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child: Row(children: [
                      Text("入院时间"),
                      Expanded(child: Text(DateUtil.formatDateMs((item?.hospitalizedStartTime??0).toInt() * 1000,format: 'yyyy-MM-dd HH:mm:ss'),textAlign: TextAlign.end,overflow:TextOverflow.ellipsis,maxLines: 1)),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],),
                  ),
                ),

                Visibility(child:
                Divider(height: 2,color: PageStyle.c_e8e8e8,),visible: item?.hospitalized==2,),
                Visibility(child: Container(
                  height: 40.h,
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child: Row(children: [
                      Text("出院时间"),
                      Expanded(child: Text(DateUtil.formatDateMs((item?.hospitalizedEndTime??0).toInt()* 1000, format: 'yyyy-MM-dd HH:mm:ss'),textAlign: TextAlign.end,overflow:TextOverflow.ellipsis,maxLines: 1)),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],),
                  ),
                ),visible: item?.hospitalized==2,),

                Divider(height: 2,color: PageStyle.c_e8e8e8,),
                Container(
                  height: 40.h,
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child:Row(children: [
                      Text("医护群"),
                      Expanded(child:  GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Text(isGuiDang?"医护群已超时自动解散 查看归档记录":(item?.groupName??""),style: TextStyle(color: isGuiDang?Colors.blue:Colors.black),textAlign: TextAlign.end,overflow:TextOverflow.ellipsis,maxLines: 1),
                        onTap: (){
                          if (isGuiDang) {
                            //查看归档记录
                            Get.toNamed(AppRoutes.PATIENT_GDJL_PAGE,arguments: {"id":item?.groupNumber??""});
                          }
                        },
                      )),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],),
                  ),
                ),
                Divider(height: 2,color: PageStyle.c_e8e8e8,),
                Container(
                  child:
                  Padding(padding: EdgeInsets.fromLTRB(20.w,10.h, 20.w, 10.h),
                    child:Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("病情简介"),
                        SizedBox(width: 20.w),
                        Expanded(child: InkWell(child: Text(item?.illnessDesc??"",textAlign: TextAlign.end,),onTap: showbqjjDialog)),
                        // Expanded(child:TextField(textAlign: TextAlign.end,controller: bqjjController,decoration: InputDecoration(hintText: "请输入病情简介",hintStyle: TextStyle(fontSize: 16.sp),border: InputBorder.none))),
                        // Expanded(child: Text(item?.illnessDesc??"",style:TextStyle(color: Colors.grey))),
                        Icon(Icons.keyboard_arrow_right_sharp)
                      ],),
                  ),
                ),

              ],
            ))),

        )
        ),

        // SizedBox(height: 20.w),
        Visibility(child: Container(
          height: 80.h,
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
          child:
          Padding(padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
            child: Column(
              children: [
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50.w,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Image.asset(ImageRes.ic_patient_hh,width: 25.w,height: 25.w),),
                          ),
                          SizedBox(height: 5.h),
                          Text("进入医护群",style: TextStyle(color: Colors.blue),)
                        ],
                      ),
                      onTap: (){
                        conversationLogic.toChatBigScreenOther(
                          type: 1,
                          groupID: item?.groupNumber,
                          nickname: item?.groupName,
                          // faceURL: info.faceURL,
                        );
                        // conversationLogic.sta
                      },
                    ),visible: isIamInGroup),
                    SizedBox(width: 30),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50.w,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Image.asset(ImageRes.ic_patient_exit,width: 25.w,height: 25.w),),
                          ),
                          SizedBox(height: 5.h),
                          Text("办理离院",style: TextStyle(color: Colors.blue))
                        ],
                      ),
                      onTap: () async {
                        await Apis.patientBlly(item?.id.toString()??"");
                        IMWidget.showToast("操作成功");
                        busBkrs.emit("updatePatientManage","");
                        // Get.back(result: true);
                        loadData();
                      },
                    ),
                  ],),
                SizedBox(height: 4.h),
                Visibility(visible: isLoadSuccess,child: Row(children: [
                  Expanded(child: Text("档案创建时间：${item?.createTime} ${item?.createUserName}",style:TextStyle(color: Colors.grey,fontSize: 10.sp),textAlign: TextAlign.center))
                ],)),
              ],
            ),
          ),
        ),visible: item?.hospitalized==1),
        Visibility(visible: isLoadSuccess && item?.hospitalized!=1,child: Column(
          children: [
            SizedBox(height: 10.h),
            Row(children: [
              Expanded(child: Text("档案创建时间：${item?.createTime} ${item?.createUserName}",style:TextStyle(color: Colors.grey,fontSize: 10.sp),textAlign: TextAlign.center))
            ],),
            SizedBox(height: 10.h),
          ],
        )),
        // Expanded(child:  Text("档案创建时间：2022年5月6日11:22:54 陈华",textAlign: TextAlign.center))
      ],
    );
  }

  var isIamInGroup = false;

  void checkImInGroup() async{
    if (item == null || item!.groupNumber == null || item!.groupNumber == "") {
      return;
    }
    isIamInGroup = await OpenIM.iMManager.groupManager
        .isJoinedGroup(gid: item!.groupNumber??"");
    setState(() {

    });
  }

}
