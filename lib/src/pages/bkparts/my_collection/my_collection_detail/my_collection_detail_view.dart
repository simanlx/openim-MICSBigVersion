import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mics_big_version/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:mics_big_version/src/res/images.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:mics_big_version/src/routes/app_pages.dart';
import 'package:mics_big_version/src/utils/VoiceTimeUtil.dart';
import 'package:mics_big_version/src/utils/im_util.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';
import 'package:flutter_openim_sdk/src/models/message.dart' as mess;

import 'my_collection_detail_logic.dart';

class MyCollectionDetailPage extends StatelessWidget {

  final logic = Get.find<MyCollectionDetailLogic>();

  @override
  Widget build(BuildContext context) {

    return
      Obx(()=>
          Scaffold(
              backgroundColor: PageStyle.c_FFFFFF,
              body: Container(
                height: 1.sh,
                child: Column(
                  children: [
                    // Obx(()=>buildHead()),
                    buildHead(),
                    Expanded(child: SingleChildScrollView(
                      child: buildContent(),
                    ))
                  ],
                ),
              )
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
          //     ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w)),onTap: (){
          //       //返回
          //       logic.back();
          //     },
          //     )),
          Align(
            alignment: Alignment.center,
            child:  Text(logic.title.value,textAlign: TextAlign.center,style: PageStyle.ts_333333_18sp),
          ),
          Align(
            alignment: Alignment.centerRight,
            child:  Visibility(
              visible: true,
              child: InkWell(child: Text("分享",textAlign: TextAlign.center,style: PageStyle.ts_333333_18sp),onTap: () async {
                //分享患者详情 分享医疗备忘
                if (logic.item.type == 6) {
                  //患者详情
                  Get.toNamed(AppRoutes.SELECT_CONTACTS,arguments: {
                    'action': SelAction.MyFORWARD,
                    'patientItem':logic.item.content?.patient,
                    'sharePath':AppRoutes.HOME
                  });
                }else if(logic.item.type == 8){
                  //医疗备忘
                  Get.toNamed(AppRoutes.SELECT_CONTACTS,arguments: {
                    'action': SelAction.MyFORWARD,
                    'ylbwItem':logic.item.content?.note,
                    'sharePath':AppRoutes.HOME
                  });
                }else if(logic.item.type == 1){
                  //文字
                  if (logic.item.content?.message !=null) {
                    //创建一个转发消息
                    var message = await OpenIM.iMManager.messageManager.createForwardMessage(
                      message: (logic.item.content?.message)!,
                    );
                    Get.toNamed(AppRoutes.SELECT_CONTACTS,arguments: {
                      'action': SelAction.MyFORWARD,
                      'message':message,
                      'sharePath':AppRoutes.HOME
                    });
                  }
                }else if(logic.item.type == 2){
                  //语音
                  if (logic.item.content?.message !=null) {
                    //创建一个转发消息
                    var message = await OpenIM.iMManager.messageManager.createForwardMessage(
                      message: (logic.item.content?.message)!,
                    );
                    Get.toNamed(AppRoutes.SELECT_CONTACTS,arguments: {
                      'action': SelAction.MyFORWARD,
                      'message':message,
                      'sharePath':AppRoutes.HOME
                    });
                  }
                }else if(logic.item.type == 3){
                  //文件
                  if (logic.item.content?.message !=null) {
                    //创建一个转发消息
                    var message = await OpenIM.iMManager.messageManager.createForwardMessage(
                      message: (logic.item.content?.message)!,
                    );
                    Get.toNamed(AppRoutes.SELECT_CONTACTS,arguments: {
                      'action': SelAction.MyFORWARD,
                      'message':message,
                      'sharePath':AppRoutes.HOME
                    });
                  }
                }else if(logic.item.type == 4){
                  //图片
                  print("图片地址 ${logic.item.content?.image_path??""}");
                  if (logic.item.content?.message !=null) {
                    //创建一个转发消息
                    var message = await OpenIM.iMManager.messageManager.createForwardMessage(
                      message: (logic.item.content?.message)!,
                    );
                    Get.toNamed(AppRoutes.SELECT_CONTACTS,arguments: {
                      'action': SelAction.MyFORWARD,
                      'message':message,
                      'sharePath':AppRoutes.HOME
                    });
                  }
                }else if(logic.item.type == 5){
                  //视频
                  if (logic.item.content?.message !=null) {
                    //创建一个转发消息
                    var message = await OpenIM.iMManager.messageManager.createForwardMessage(
                      message: (logic.item.content?.message)!,
                    );
                    Get.toNamed(AppRoutes.SELECT_CONTACTS,arguments: {
                      'action': SelAction.MyFORWARD,
                      'message':message,
                      'sharePath':AppRoutes.HOME
                    });
                  }
                }
              },),
            ),
          ),
        ],
      ),
    );
  }

  buildContent() {
    // 1 聊天
    // 2 语音
    // 3 file
    // 4 图片
    // 5 视频
    // 6 患者管理
    if(logic.item.type == 1){
      //文字
      return _buildSingleChat();
    }else if(logic.item.type == 2){
      return _buildSingleVoice();
      // return Obx(()=>_buildSingleVoice());
    }else if(logic.item.type == 3){
      return _buildSingleFile();
    }else if(logic.item.type == 4){
      return _buildSinglePic();
    }else if(logic.item.type == 5){
      return _buildSingleVideo();
    }else if(logic.item.type == 6){
      return _buildSinglePatient();
    }else if(logic.item.type == 8){
      return  _buildSingleYlbw();
      // return  Obx(()=>_buildSingleYlbw());
    }
    return Container();
  }

  _createNoteView(){
    var list = <Widget>[];
    if (logic.item.content?.note?.noteData!=null) {
      for (var value in logic.item.content!.note!.noteData!) {
        if(value.type == "text" ){
          var ele = Row(children: [
            Expanded(child: Text(value.data))
          ]);
          list.add(SizedBox(height: 20.h));
          list.add(ele);
        } else if(value.type == "img"){
          var ele = Image.network(value.data,errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
              ){
            return Container();
          });
          list.add(SizedBox(height: 20.h));
          list.add(ele);
        }    else if(value.type == "radio"){
          try{
            value.voiceLength = num.parse(value.property).toInt();
          }catch(e){

          }
          var ele = Visibility(visible:(value.voiceLength??0)>0,child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10.w),child: Image.asset(logic.isPlayingUrl.value == value.data && logic.isVideoPlaying.value?ImageRes.ic_pause:ImageRes.ic_play,
                    color: Colors.blue,width: 26.w,height: 26.w),),onTap: (){
                  //播放 暂停
                  //逻辑 点击的是自己
                  //点击的是自己
                  if (logic.isPlayingUrl.value == value.data) {
                    if (logic.isVideoPlaying.value) {
                      logic.isVideoPlaying.value = false;
                      logic.audioPlayer.stop();
                    }else{
                      logic.audioPlayer.setUrl(value.data);
                      logic.audioPlayer.seek(Duration(seconds: logic.playSecond.value));
                      logic.audioPlayer.play();
                    }
                  }else{
                    logic.isVideoPlaying.value = false;
                    logic.playSecond.value = 0;
                    logic.audioPlayer.stop();
                    logic.audioPlayer.setUrl(value.data);
                    logic.audioPlayer.seek(Duration(seconds: logic.playSecond.value));
                    logic.audioPlayer.play();
                  }

                  logic.audioPlayer.playerStateStream.listen((event) {
                    print("播放状态改变${event.processingState.name}");
                    if (event.processingState == ProcessingState.ready) {
                      logic.isVideoPlaying.value = true;
                      logic.isPlayingUrl.value = value.data;
                    }else if(event.processingState == ProcessingState.completed){
                      logic.playSecond.value = 0;
                      logic.isVideoPlaying.value = false;
                      logic.isPlayingUrl.value = "";
                    }else if(event.processingState == ProcessingState.idle){
                      logic.isVideoPlaying.value = false;
                    }
                  });

                  logic.audioPlayer.positionStream.listen((event) {
                    if (logic.isVideoPlaying.value) {
                      logic.playSecond.value = event.inSeconds;
                    }
                  });


                }
                ),
                SizedBox(width: 5.w),
                Text(VoiceTimeUtil.transferSec(logic.isPlayingUrl.value == value.data?logic.playSecond.value:0)),
                SizedBox(width: 5.w),
                Expanded(
                  child:
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color:Colors.grey,
                        ),
                        width: 340.w,
                        height: 3.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.r),bottomLeft: Radius.circular(5.r)),
                          color:Colors.blue,
                        ),
                        height: 3.h,
                        width: logic.isPlayingUrl.value == value.data?(logic.playSecond.value / (value.voiceLength??-1)) * 340.w:0,
                      )
                    ],
                  ),),
                SizedBox(width: 5.w),
                Text(VoiceTimeUtil.transferSec(value.voiceLength??0)),
              ]));
          list.add(SizedBox(height: 20.h));
          list.add(ele);
        }
      }
    }
    return list;
  }

  _buildSingleYlbw(){
    var timeStr = DateUtil.formatDateMs(int.parse(logic.item.extraInfo?.createTime??""), format: 'yyyy-MM-dd HH:mm:ss');
    return Padding(padding: EdgeInsets.all(20.w),child: Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
            SizedBox(width: 10.w),
            Text("来自 ${logic.item.extraInfo?.createUserName} $timeStr",style: TextStyle(fontSize: 12.sp)),
            SizedBox(width: 10.w),
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
          ],
        ),
        SizedBox(height: 20.w),
        //
        Column(
          children: _createNoteView(),
        ),
        //
        SizedBox(height: 20.w),
        Divider(height: 1.w,color: PageStyle.c_e8e8e8)
      ],
    ));
  }

  _buildSingleVideo() {
    // logic.item.content.video_path;
    var timeStr = DateUtil.formatDateMs(int.parse(logic.item.extraInfo?.createTime??""), format: 'yyyy-MM-dd HH:mm:ss');
    return Padding(padding: EdgeInsets.all(20.w),child: Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
            SizedBox(width: 10.w),
            Text("来自 ${logic.item.extraInfo?.createUserName} $timeStr",style: TextStyle(fontSize: 12.sp)),
            SizedBox(width: 10.w),
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
          ],
        ),
        SizedBox(height: 20.w),
        //
        InkWell(child: Icon(Icons.play_arrow),onTap: (){
          // var msg =  Message.fromJson("");
          var msg = mess.Message();
          var ele = mess.VideoElem();
          ele.videoUrl = logic.item.content?.video_path??"";
          ele.snapshotUrl = "";
          // ele.videoUrl = "";
          msg.videoElem = ele;
          IMUtil.openVideo(msg);
        },),
        //
        SizedBox(height: 20.w),
        Divider(height: 1.w,color: PageStyle.c_e8e8e8)
      ],
    ));
  }

  _buildSingleVoice() {
    var voiceUrl = logic.item.content?.voice??"";
    var voiceLength = 0;
    try{
      voiceLength = int.parse(logic.item.content?.voice_length??"0");
    }catch(e){
      IMWidget.showToast("语音文件错误");
    }
    var timeStr = DateUtil.formatDateMs(int.parse(logic.item.extraInfo?.createTime??""), format: 'yyyy-MM-dd HH:mm:ss');
    return Padding(padding: EdgeInsets.all(20.w),child: Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
            SizedBox(width: 10.w),
            Text("来自 ${logic.item.extraInfo?.createUserName} $timeStr",style: TextStyle(fontSize: 12.sp)),
            SizedBox(width: 10.w),
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
          ],
        ),
        SizedBox(height: 20.w),
        //
        Visibility(visible:voiceLength>0,child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10.w),child: Image.asset(logic.isVideoPlaying.value?ImageRes.ic_pause:ImageRes.ic_play,
                  color: Colors.blue,width: 26.w,height: 26.w),),onTap: (){
                //播放 暂停
                //逻辑 点击的是自己
                //点击的是自己
                if (logic.isVideoPlaying.value) {
                  logic.isVideoPlaying.value = false;
                  logic.audioPlayer.stop();
                }else{
                  logic.audioPlayer.setUrl(voiceUrl);
                  logic.audioPlayer.seek(Duration(seconds: logic.playSecond.value));
                  logic.audioPlayer.play();
                  logic.audioPlayer.playerStateStream.listen((event) {
                    if (event.processingState == ProcessingState.ready) {
                      logic.isVideoPlaying.value = true;
                    }else if(event.processingState == ProcessingState.completed){
                      logic.playSecond.value = 0;
                      logic.isVideoPlaying.value = false;
                    }
                  });

                  logic.audioPlayer.positionStream.listen((event) {
                    if (logic.isVideoPlaying.value) {
                      logic.playSecond.value = event.inSeconds;
                    }
                  });
                }
              }
              ),
              SizedBox(width: 5.w),
              Text(VoiceTimeUtil.transferSec(logic.playSecond.value)),
              SizedBox(width: 5.w),
              Expanded(
                child:
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color:Colors.grey,
                      ),
                      width: 340.w,
                      height: 3.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5.r),bottomLeft: Radius.circular(5.r)),
                        color:Colors.blue,
                      ),
                      height: 3.h,
                      width: (logic.playSecond.value / voiceLength) * 340.w,
                    )
                  ],
                ),),
              SizedBox(width: 5.w),
              Text(VoiceTimeUtil.transferSec(voiceLength)),
            ])),
        // SizedBox(width: 5.w),
        // SizedBox(width: 10.w))],
        //
        SizedBox(height: 20.w),
        Divider(height: 1.w,color: PageStyle.c_e8e8e8)
      ],
    ));
  }



  _buildSingleFile() {
    var fileName = logic.item.content?.file_name??"";
    var timeStr = DateUtil.formatDateMs(int.parse(logic.item.extraInfo?.createTime??""), format: 'yyyy-MM-dd HH:mm:ss');
    return Padding(padding: EdgeInsets.all(20.w),child: Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
            SizedBox(width: 10.w),
            Text("来自 ${logic.item.extraInfo?.createUserName} $timeStr",style: TextStyle(fontSize: 12.sp)),
            SizedBox(width: 10.w),
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
          ],
        ),
        SizedBox(height: 20.w),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            // var msg = mess.Message();
            // var ele = mess.FileElem();
            // ele.sourceUrl = logic.item.content?.file_path??"";
            // msg.fileElem = ele;
            // IMUtil.openFile(msg);
            //下载
            logic.downloadFile();
          },
          child: Column(
            children: [
              FaIcon(
                CommonUtil.fileIcon(fileName),
                size: 28,
                color: Color(0xFF1b6bed),
              ),
              SizedBox(height: 20.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(children: [
                    Text(
                      fileName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF333333),
                      ),
                    )
                  ],)
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20.w),
        Divider(height: 1.w,color: PageStyle.c_e8e8e8)
      ],
    ));
  }

  _buildSinglePic() {
    var timeStr = DateUtil.formatDateMs(int.parse(logic.item.extraInfo?.createTime??""), format: 'yyyy-MM-dd HH:mm:ss');
    return Padding(padding: EdgeInsets.all(20.w),child: Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
            SizedBox(width: 10.w),
            Text("来自 ${logic.item.extraInfo?.createUserName} $timeStr",style: TextStyle(fontSize: 12.sp)),
            SizedBox(width: 10.w),
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
          ],
        ),
        SizedBox(height: 20.w),
        Image.network(logic.item.content?.image_path??"",fit: BoxFit.fill,errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ){
          return Container();
        },),
        SizedBox(height: 20.w),
        Divider(height: 1.w,color: PageStyle.c_e8e8e8)
      ],
    ));
  }

  _buildSingleChat() {
    var timeStr = DateUtil.formatDateMs(int.parse(logic.item.extraInfo?.createTime??""), format: 'yyyy-MM-dd HH:mm:ss');
    return Padding(padding: EdgeInsets.all(20.w),child: Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
            SizedBox(width: 10.w),
            Text("来自 ${logic.item.extraInfo?.createUserName} $timeStr",style: TextStyle(fontSize: 12.sp)),
            SizedBox(width: 10.w),
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
          ],
        ),
        SizedBox(height: 20.w),
        Row(
          children: [
            Text(logic.item.content?.txt??"",textAlign: TextAlign.start,style: TextStyle(fontSize: 14.sp))
          ],
        ),
        SizedBox(height: 20.w),
        Divider(height: 1.w,color: PageStyle.c_e8e8e8)
      ],
    ));
  }

  _buildSinglePatient() {
    var timeStr = DateUtil.formatDateMs(int.parse(logic.item.extraInfo?.createTime??""), format: 'yyyy-MM-dd HH:mm:ss');
    var inTime = DateUtil.formatDateMs((logic.item.content?.patient?.hospitalizedStartTime??0).toInt()*1000, format: 'yyyy-MM-dd HH:mm:ss');
    var outTime = DateUtil.formatDateMs((logic.item.content?.patient?.hospitalizedEndTime??0).toInt()*1000, format: 'yyyy-MM-dd HH:mm:ss');
    return Padding(padding: EdgeInsets.all(20.w),child: Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
            SizedBox(width: 10.w),
            Text("来自 ${logic.item.extraInfo?.createUserName} $timeStr",style: TextStyle(fontSize: 12.sp)),
            SizedBox(width: 10.w),
            Expanded(child: Divider(height: 1.w,color: PageStyle.c_e8e8e8)),
          ],
        ),
        SizedBox(height: 20.w),
        Column(
          children: [
            Row(children: [
              Text("姓名"),
              Expanded(child: Text(logic.item.content?.patient?.name??"",textAlign: TextAlign.end))
            ],),
            SizedBox(height: 10.w),
            Row(children: [
              Text("头像"),
              Image.network(logic.item.content?.patient?.avatar??"",height: 20.w,width: 20.w,errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                  ){
                return Container();
              },)
            ],),
            SizedBox(height: 10.w),
            Row(children: [
              Text("性别"),
              Expanded(child: Text(logic.item.content?.patient?.sex??"",textAlign: TextAlign.end))
            ],),
            SizedBox(height: 10.w),
            Row(children: [
              Text("年龄"),
              Expanded(child: Text(logic.item.content?.patient?.age??"",textAlign: TextAlign.end))
            ],),
            SizedBox(height: 10.w),
            Row(children: [
              Text("住院号"),
              Expanded(child: Text(logic.item.content?.patient?.inpatientNumber??"",textAlign: TextAlign.end))
            ],),
            SizedBox(height: 10.w),
            Row(children: [
              Text("所在病房"),
              Expanded(child: Text(logic.item.content?.patient?.bedNumber??"",textAlign: TextAlign.end))
            ],),
            SizedBox(height: 10.w),
            Row(children: [
              Text("所在病床"),
              Expanded(child: Text(logic.item.content?.patient?.patientRoomName??"",textAlign: TextAlign.end))
            ],),
            SizedBox(height: 10.w),
            Row(children: [
              Text("入院时间"),
              Expanded(child: Text(inTime,textAlign: TextAlign.end))
            ],),
            SizedBox(height: 10.w),

            Row(children: [
              Text("出院时间"),
              Expanded(child: Text(outTime,textAlign: TextAlign.end))
            ],),
            SizedBox(height: 10.w),
            Row(children: [
              Text("医护群"),
              Expanded(child: Text(logic.item.content?.patient?.groupNumber??"",textAlign: TextAlign.end))
            ],),
            SizedBox(height: 10.w),
            Row(children: [
              Text("病情简介"),
              Expanded(child: Text(logic.item.content?.patient?.illnessDesc??"",textAlign: TextAlign.end))
            ],),
            SizedBox(height: 10.w),
          ],
        ),
        SizedBox(height: 20.w),
        Divider(height: 1.w,color: PageStyle.c_e8e8e8)
      ],
    ));
  }
}
