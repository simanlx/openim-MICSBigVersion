import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_popup/easy_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/models/zskjs/YlbwElementNew.dart';
import 'package:mics_big_version/src/models/zskjs/YlbwType.dart';
import 'package:mics_big_version/src/routes/app_pages.dart';
import 'package:mics_big_version/src/utils/EventBusBkrs.dart';
import 'package:mics_big_version/src/utils/im_util.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../../models/zskjs/SaveYlbwRes.dart';
import '../../../../models/zskjs/YlbwListBean.dart';
import '../../../../res/images.dart';
import '../../../../res/strings.dart';
import '../../../../res/styles.dart';
import 'package:path/path.dart' as path;
import '../../../../widgets/im_widget.dart';
import '../../../../widgets/titlebar.dart';
import '../../../select_contacts/select_contacts_logic.dart';
import 'package:dotted_border/dotted_border.dart';

class MedicalMemoDetailPage extends StatefulWidget {
  MedicalMemoDetailPage({Key? key,this.rawData,this.autoRecord=false}) : super(key: key);

  YlbwListBeanData? rawData;
  bool autoRecord;


  @override
  State<MedicalMemoDetailPage> createState() => _MedicalMemoDetailPageState();

}

class _MedicalMemoDetailPageState extends State<MedicalMemoDetailPage> {

  // var logic = Get.find<MedicalMemoDetailLogic>();

  var isSetTop = false;
  List<YlbwType> labelList = <YlbwType>[];

  var typeId = "";
  var typeName = "";

  getLabelList() async{
    //获取医疗备忘标签列表
    var res = await Apis.getYlbwLabelList();
    if (res!=null) {
      labelList.addAll(res);
      for (var value in res) {
        if (value.name == "其他" && typeId == "") {
          typeId = value.id.toString();
          typeName = value.name??"";
          break;
        }
      }
    }
  }


  @override
  void initState() {
    // player.openPlayer()
    // recorder.openRecorder()
    super.initState();
    getLabelList();
    //获取参数
    // rawData = Get.arguments["item"];
    if (widget.rawData == null) {
      //新增
      // var autoRecord  = Get.arguments["autoRecord"] ?? false;
      if(widget.autoRecord){
        //开始录音
        elements.add(YlbwElementNew(type: "text",autoFocus: true));
        startRecord();
        Future.delayed(Duration(milliseconds: 500),(){

        });
        return;
      }else{
        elements.add(YlbwElementNew(type: "text",autoFocus: true));
      }
    }else{
      //编辑
      typeId = widget.rawData!.typeId??"";
      typeName = widget.rawData!.typeName??"";

      isSetTop = widget.rawData!.isTop == 1;
      if (widget.rawData!.noteData != null) {
        //处理数据
        var newList = (widget.rawData!.noteData)!.where((element){
          //有文字
          if (element.type == "text") {
            if (element.data != "") {
              element.textEditingController.text = element.data;
              return true;
            }
          }
          //上传成功了
          if (element.type == "radio") {
            if (element.data != "") {
              element.fileUrl = element.data;
              try{
                element.voiceLength = num.parse(element.property).toInt();
                print("转换成功");
              }catch(e){
                element.voiceLength = 0;
                print("转换失败");
              }
              return true;
            }
          }
          //上传成功了
          if (element.type == "img") {
            if (element.data != "") {
              return true;
            }
          }
          return false;
        }).toList();
        if (newList.length>0) {
          tempRawList = json.decode(json.encode(newList));
          elements.addAll(newList);
        }
      }
      doAfterAdd();
    }
  }

  var tempRawList; //没做修改退出不掉接口


  @override
  void dispose() {
    removeOverlay();
    if (isRecording) {
      // _record.stop();
      stopRecord();
    }
    audioPlayer.stop();
    if (_recordTimer!=null) {
      _recordTimer?.cancel();
      _recordTimer = null;
      _recordTimeInt = 0;
    }
    //保存
    saveYlbw(0);
    super.dispose();
  }

  //医疗备忘标签
  // var typeId = "3";
  // var typeName = "";
  var title = "暂时的标题";
  var globalNewList = <YlbwElementNew>[];

  // scence 5 //收藏
  void saveYlbw(int scence){
    //剔除无效的数据
    globalNewList = elements.where((element) {
      //有文字
      if (element.type == "text") {
        var inputTxt = element.textEditingController.text;
        if (inputTxt.trim() != "") {
          element.data = inputTxt;
          return true;
        }
      }
      //上传成功了
      if (element.type == "radio") {
        if (element.data != "") {
          return true;
        }
      }
      //上传成功了
      if (element.type == "img") {
        if (element.data != "") {
          return true;
        }
      }
      return false;
    }).toList();

    // if(globalNewList == widget.rawData!.noteData)
    if (globalNewList.length>0) {
      var first = globalNewList[0];
      if (first.type == "text" && first.data.trim().length>0) {
        if (first.data.length>10) {
          title = first.data.substring(0,10);
        }else{
          title = first.data;
        }
      }else{
        title = '[无文本内容]';
      }

      if (widget.rawData != null) {
        //编辑
        if (json.encode(globalNewList) == json.encode(tempRawList) && scence==0 &&widget.rawData?.typeName == typeName) {
          print("两次序列化一样");
          return;
        }
        print("两次序列化不一样  ${widget.rawData?.typeName }   ${typeName}");
        Apis.updateYlbw(globalNewList,typeId,title,widget.rawData!.id??0).then((value){
          busBkrs.emit("updateYlbw","");
          if(value == null){
            return;
          }
          if (scence == 5) {
            tempRawList = json.decode(json.encode(globalNewList));
            doCollect(value);
          }else if(scence == 4){
            //分享
            doShare();
          }
        });
      }else if(savedId.isNotEmpty){
        //编辑
        if (json.encode(globalNewList) == json.encode(widget.rawData!.noteData)) {
          return;
        }
        Apis.updateYlbw(globalNewList,typeId,title,int.parse(savedId)).then((value){
          busBkrs.emit("updateYlbw","");
          if(value == null){
            return;
          }
          if (scence == 5) {
            doCollect(value);
          }else if(scence == 4){
            //分享
            doShare();
          }
        });
      } else{
        //新增
        Apis.saveYlbw(globalNewList,typeId,title).then((value){
          busBkrs.emit("updateYlbw","");
          if(value == null){
            return;
          }
          if (scence == 5 ) {
            doCollect(value);
          }else if(scence == 4){
            //分享
            doShare();
          }
        });
      }
    }
  }

  void doCollect(SaveYlbwRes value){
    savedId = value.noteId??"";
    //收藏
    var content = {
      "title":"$title",
      "from":"[医疗备忘]",
      "type":8,
      "data": {
        "note":{
          "type_id": typeId,
          "title": title,
          "note_data": json.encode(globalNewList),
          "create_time":widget.rawData?.createTime
        }
      },
    };
    Apis.addLike(OpenIM.iMManager.uInfo.userID??"", OpenIM.iMManager.uInfo.nickname??"", OpenIM.iMManager.uInfo.faceURL??"", DateTime.now().millisecondsSinceEpoch.toString(), content).then((value){
      IMWidget.showToast("收藏成功");
    });
  }


  var overlayEntry;

  removeOverlay(){
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }
  var popControl = CustomPopupMenuController();
  var savedId = "";

  Widget buildHead(){

    return  Container(
      height: 80.h,
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.w),
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
        // alignment: Alignment.center,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: InkWell(child: Padding(child: Image.asset(
                ImageRes.ic_back,
                width: 12.w,
                height: 20.h,
              ),padding: EdgeInsets.only(left: 8.w,right: 20.w,top: 5.h,bottom: 5.w)),onTap: (){
                //返回
                if(isRecording){
                  IMWidget.showToast("正在录音,请完成录音后再尝试");
                  return;
                }
                //todo 保存数据
                // logic.back();
              },
              )),
          Align(
            alignment: Alignment.center,
            child:  Text(StrRes.medicalMemo,textAlign: TextAlign.center,style: PageStyle.ts_333333_18sp),
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
                      text: isSetTop?"取消置顶":"置顶",
                      icon: ImageRes.ic_to_top,
                      onTap: (){
                        if (isSetTop) {
                          if (widget.rawData!=null) {
                            Apis.cancelTopYlbw(widget.rawData!.id.toString()).then((value){
                              IMWidget.showToast("取消置顶成功");
                              busBkrs.emit("updateYlbw","");
                              setState(() {
                                isSetTop = false;
                              });
                            });
                          }else if(savedId.trim()!=""){
                            Apis.cancelTopYlbw(savedId).then((value){
                              IMWidget.showToast("取消置顶成功");
                              busBkrs.emit("updateYlbw","");
                              setState(() {
                                isSetTop = false;
                              });
                            });
                          }
                        }else{
                          if (widget.rawData!=null) {
                            Apis.setTopYlbw(widget.rawData!.id.toString()).then((value){
                              IMWidget.showToast("置顶成功");
                              busBkrs.emit("updateYlbw","");
                              setState(() {
                                isSetTop = true;
                              });
                            });
                          }else if(savedId.trim()!=""){
                            Apis.setTopYlbw(savedId).then((value){
                              IMWidget.showToast("置顶成功");
                              busBkrs.emit("updateYlbw","");
                              setState(() {
                                isSetTop = true;
                              });
                            });
                          }
                        }
                      },
                    ),
                    PopMenuInfo(
                      text: "收藏",
                      icon: ImageRes.ic_to_like,
                      onTap: (){
                        //保存并收藏
                        saveYlbw(5);
                      },
                    ),
                    PopMenuInfo(
                      text: "分享",
                      icon: ImageRes.ic_to_share,
                      onTap: (){
                        //判断是保存还是
                        //保存并分享
                        saveYlbw(4);
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

  var elements = <YlbwElementNew>[];

  var currentFocusIndex = 0;
  getElementViews(){
    var eles = <WidgetSpan>[];
    for(int i=0;i<elements.length;i++){
      var element = elements[i];
      if (element.type == "text") {
        var focusNode = element.focusNode;
        eles.add(WidgetSpan(child: TextField(
          autofocus: element.autoFocus??false,
          focusNode: focusNode,
          controller: element.textEditingController,maxLines: null,keyboardType: TextInputType.multiline,decoration: InputDecoration(border: InputBorder.none),)));
        focusNode.addListener(() {
          if(focusNode.hasFocus){
            currentFocusIndex = i;
          }
        });
        // element.textEditingController.text = element.data;
      }else if(element.type == "img"){
        eles.add(WidgetSpan(child: Padding(padding: EdgeInsets.only(bottom: 10.h),child:

        Slidable(child: element.fileUrl == null? Image.network(element.data):Image.file(File(element.fileUrl??"")),
        endActionPane: _buildActionPane(element),
        ),
        // Column(children: [
        //   InkWell(child: Icon(Icons.delete,color: Colors.red),onTap: (){
        //     setState(() {
        //       elements.remove(element);
        //     });
        //   }),
        //   ,
        // ],
        //
        )));
      }else if(element.type == "radio"){
        eles.add(WidgetSpan(child:
        Slidable(child: buildVoiceView(element,i),
          endActionPane: _buildActionPane(element),
        ),
        ));
      }else{
        eles.add(WidgetSpan(child: Container()));
      }
    }
    return eles;
  }

  ActionPane _buildActionPane(element) => ActionPane(
    motion: ScrollMotion(),
    extentRatio: .2,
    children: [
      SlidableAction(
        flex: 1,
        onPressed: (_){
              setState(() {
                elements.remove(element);
              });
        },
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: StrRes.delete,
      ),
    ],
  );


  buildVoiceView(YlbwElementNew element,int index){

    // var _voiceShowWidth = _voice_globalKey.currentContext?.size?.width;

    return Column(
      children: [
        Visibility(child: DottedBorder(
          color: PageStyle.c_BBBBBB,
          child: Container(
            height: 70.h,
            child: Row(
              children: [
                SizedBox(width: 10.w),
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.all(Radius.circular(10.r))),
                ),
                SizedBox(width: 10.w),
                Text("正在录音"),
                SizedBox(width: 20.w),
                Text(_recordTimeStr),
                Expanded(child: Container()),
                InkWell(child: Text("结束录音",textAlign: TextAlign.end,style: TextStyle(color: Colors.blue),),onTap: (){
                  if (_recordTimer !=null) {
                    _recordTimer?.cancel();
                    _recordTimer = null;
                  }
                  // _record.stop();
                  //
                  stopRecord();
                },),
                SizedBox(width: 10.w)
              ],
            ),
          ),
        ),visible: element.isRecording??false,),
        Visibility(visible: !(element.isRecording??false),
              child: Container(
                height: 70.h,
                margin: EdgeInsets.only(top: 10.h),
                decoration: BoxDecoration(color: PageStyle.c_EEEEEE),
                child: Row(
                  children: [
                    // SizedBox(width: 5.w),
                    Container(
                      width: 90.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10.w),child: Image.asset((currentPlayUri == element.fileUrl && (element.isPlaying??false))?ImageRes.ic_pause:ImageRes.ic_play,
                            color: Colors.blue,width: 26.w,height: 26.w),),onTap: (){
                            //播放 暂停
                            //逻辑 点击的是自己
                            //点击的是自己
                            if(currentPlayUri == element.fileUrl){
                              //点击的是正在播放的
                              if (audioPlayer.playerState.playing) {
                                audioPlayer.stop();
                              }else{
                                audioPlayer.setAudioSource(AudioSource.uri(path.toUri(element.fileUrl??"")));
                                audioPlayer.seek(Duration(seconds: element.currentSec));
                                audioPlayer.play();
                                currentPlayUri = element.fileUrl??"";
                              }
                            }else{
                              //点击的不是正在播放的
                              audioPlayer.stop();
                              for (var value in elements) {
                                // if(currentPlayUri != element.fileUrl){
                                value.currentSec = 0;
                                value.isPlaying = false;
                                // }
                              }
                              if (element.fileUrl?.startsWith("http")??true) {
                                audioPlayer.setUrl(element.data);
                              }else{
                                audioPlayer.setAudioSource(AudioSource.uri(path.toUri(element.fileUrl??"")));
                              }
                              audioPlayer.seek(Duration(seconds: element.currentSec));
                              audioPlayer.play();
                              currentPlayUri = element.fileUrl??"";
                            }

                            setState(() {

                            });

                            //   for (var value in elements) {
                            //     if(currentPlayUri != element.fileUrl){
                            //       value.currentSec = 0;
                            //       value.isPlaying = false;
                            //     }
                            //   }
                            //   setState(() {
                            //
                            //   });
                            // currentPlayUri = element.fileUrl??"";
                            // if (audioPlayer.playerState.playing) {
                            //   audioPlayer.stop();
                            // }else{
                            //   audioPlayer.setAudioSource(AudioSource.uri(path.toUri(element.fileUrl??"")));
                            //   audioPlayer.seek(Duration(seconds: element.currentSec));
                            //   audioPlayer.play();
                            // }

                            audioPlayer.playerStateStream.listen((event) {
                              element.isPlaying = audioPlayer.playerState.playing;
                              if (event.processingState == ProcessingState.completed) {
                                element.currentSec = 0;
                                currentPlayUri = "";
                              }
                              setState(() {

                              });
                            });
                            audioPlayer.positionStream.listen((event) {
                              if (event.inSeconds == element.voiceLength) {
                                return;
                              }
                              if(element.currentSec != event.inSeconds){
                                setState(() {
                                  // print("播放inSeconds ${event.inSeconds}");
                                  // print("播放inSeconds嘿嘿哈${element.currentSec}   ${element.voiceLength}");
                                  element.currentSec = event.inSeconds;
                                });
                              }
                              setState(() {

                              });
                            });
                          },),
                          // SizedBox(width: 5.w),
                          Text(currentPlayUri == element.fileUrl ?transferSec(element.currentSec) : "0:00"),
                      ],),
                    ),

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
                          width: 140.w,
                          height: 3.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5.r),bottomLeft: Radius.circular(5.r)),
                            color:Colors.blue,
                          ),
                          height: 3.h,
                          width: currentPlayUri == element.fileUrl ?(element.currentSec / (element.voiceLength??-1)) * 150.w:0,
                        )
                      ],
                    ),),
                    SizedBox(width: 5.w),
                    Text(transferSec(element.voiceLength??0)),
                    SizedBox(width: 5.w),
                    InkWell(child: Text(element.isZxExpand?"关闭转写":"查看转写",style: TextStyle(color: Colors.blue)),onTap: (){
                      if(element.isZxExpand){
                        setState(() {
                          element.isZxExpand = false;
                        });
                      }else{
                        if (element.upload_id == "") {
                          IMWidget.showToast("正在上传语音");
                        }else{
                          //查看转写
                          if (element.zxText == "") {
                            Apis.getYyzxText(element.upload_id).then((value){
                              if (value != null) {
                                if (value.status == "2" && value.lvsrData!=null) {
                                  //拿到结果
                                  StringBuffer sb = StringBuffer();
                                  for(var lvsrData in value.lvsrData!){
                                    sb.write(lvsrData.txt);
                                  }
                                  element.zxText = sb.toString();
                                  element.isZxExpand = true;
                                  setState(() {

                                  });
                                }else{
                                  IMWidget.showToast("正在转写中");
                                }
                              }
                            });
                          }else{
                            element.isZxExpand = true;
                            setState(() {

                            });
                          }
                        }
                      }
                    },),
                    SizedBox(width: 10.w)
                  ],
                ),
              ),
        ),
        Visibility(visible: element.isZxExpand,
          child: Container(
            margin: EdgeInsets.only(
                left: 20.w
            ),
            child: DottedBorder(
              color: PageStyle.c_BBBBBB,
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Row(
                  children: [
                    Expanded(child: Text(element.zxText)),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h)
    ],
    );
  }



  buildContent2(BuildContext context){
    return RichText(text: TextSpan(children: getElementViews()));
    return KeyboardActions(
      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
      config: _buildConfig(context),
      child: RichText(text: TextSpan(children: getElementViews())),
    );
    // return SingleChildScrollView(child: RichText(text: TextSpan(children: getElementViews())));
  }


  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        child:
        Scaffold(
            backgroundColor: PageStyle.c_FFFFFF,
            body: Container(
              height: 1.sh,
                child: Column(
                  children: [
                    buildHead(),
                    // buildSearch(),
                    // Expanded(child: Padding(child: buildContent2(context),padding: EdgeInsets.only(left: 10,right:10))),
                    Expanded(child: SingleChildScrollView(child: buildContent2(context),)),
                    buildFooter()
                  ],
              ),
            )),
        onWillPop: () async{
          //判断是不是正在录音
          if(isRecording){
            IMWidget.showToast("正在录音,请完成录音后再尝试");
            return false;
          }
          //todo 保存数据
          return true;
        });
  }

  String transferSec(int sec) {
    int hour = (sec / 3600).floor();
    int min = (sec % 3600 / 60).floor();
    int second = sec % 60;
    if (hour == 0) {
      return  (min<10?"0$min":"$min")+":"+ (second<10?"0$second":"$second");
    }else{
      return  (hour<10?"0$hour":"$hour")+":"+(min<10?"0$min":"$min")+":"+ (second<10?"0$second":"$second");
    }

  }

   var audioPlayer = AudioPlayer(
    // Handle audio_session events ourselves for the purpose of this demo.
    handleInterruptions: false,
    // androidApplyAudioAttributes: false,
    // handleAudioSessionActivation: false,
  );

  String currentPlayUri = ""; //当前播放的音频uri

  var _recordTimeStr = "0:00";
  int _recordTimeInt = 0;



  void doAfterAdd(){
    if (elements.length-1>=0) {
      var last = elements[elements.length-1];
      if(last.type != "text"){
        elements.add(YlbwElementNew(type: "text",autoFocus: true));
      }else{
        last.autoFocus = true;
      }
    }
    setState(() {

    });
  }

  // late VoiceRecord _record;
  bool isRecording = false;
  // int isRecordingIndex = 0;
  // String? _path;
  // int _sec = 0;


  var recordingPath = "";

  void stopRecord () async{
    RecordMp3.instance.stop();
    isRecording = false;
    var file = File.fromUri(path.toUri(recordingPath));
    // print("文件大小是多少？？？ ${await file.length()}  $recordingPath");
    // var filename = recordingPath.replaceAll("/data/data/io.openim.app.enterprisechat/files/", "");
    // await file.copy("/data/data/io.openim.app.enterprisechat/files/$filename");
    recordItem.voiceLength = _recordTimeInt;
    recordItem.fileUrl = recordingPath;
    recordItem.isRecording = false;
    // beans.add(MediaMemoBean(sec,path));
    _recordTimer?.cancel();
    _recordTimer=null;
    _recordTimeInt = 0;
    _recordTimeStr = "0:00";
    doAfterAdd();
    //上传录音
    Timer(Duration(seconds: 2),(){
      Apis.ylbwUploadRadio(recordingPath).then((value){
        if (value!=null) {
          recordItem.data = value.showUrl??"";
          recordItem.upload_id = value.uploadId??"";
          recordItem.property = value.fileInfo?.playtimeSeconds.toString()??"";

          //开始转写
          Apis.beginYyzx(value.uploadId??"").then((value){
            print("开始语音转写");
          });
        }
      });
    });
  }

  // void callback(int sec, String path3) async{
  //   isRecording = false;
  //   print("录音回调 _sec $_sec  录音位置 $_path");
  //   var file = File.fromUri(path.toUri(path3));
  //   print("文件大小是多少？？？ ${await file.length()}");
  //   var filename = path3.replaceAll("/data/user/0/io.openim.app.enterprisechat/app_flutter/voice/", "");
  //   await file.copy("/data/data/io.openim.app.enterprisechat/files/$filename");
  //   recordItem.voiceLength = sec;
  //   recordItem.fileUrl = path3;
  //   recordItem.isRecording = false;
  //   // beans.add(MediaMemoBean(sec,path));
  //   _recordTimer?.cancel();
  //   _recordTimer=null;
  //   _recordTimeInt = 0;
  //   _recordTimeStr = "0:00";
  //   doAfterAdd();
  //   //上传录音
  //   Apis.ylbwUploadRadio("/data/data/io.openim.app.enterprisechat/files/$filename").then((value){
  //     if (value!=null) {
  //       recordItem.data = value.showUrl??"";
  //       recordItem.property = value.fileInfo?.playtimeSeconds.toString()??"";
  //     }
  //   });
  // }

  late YlbwElementNew  recordItem;

  // late Timer recordingTimer;

  void startRecord() {
    // _record = VoiceRecord(callback);
    // _record.start();
    recordingPath = "/data/data/io.openim.app.enterprisechat/files/${DateTime.now().millisecondsSinceEpoch}.m4a";
    RecordMp3.instance.start(recordingPath, (p0){

    });
    recordItem = YlbwElementNew(type: "radio",isRecording: true);
    setState(() {
      elements.insert(currentFocusIndex+1,recordItem);
    });
    isRecording = true;
    if (_recordTimer!=null) {
      _recordTimer?.cancel();
      _recordTimer = null;
      _recordTimeInt = 0;
    }
    _recordTimer = Timer.periodic(Duration(seconds: 1), (timer){
          setState(() {
            _recordTimeInt = _recordTimeInt+1;
            _recordTimeStr = transferSec(_recordTimeInt);
          });
    });
  }

  Timer? _recordTimer;

  var pictureList = <String>[];

  /// 打开相册
  void onTapAlbum() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(requestType: RequestType.image),
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
        var insert = YlbwElementNew(type:"img",fileUrl: filePath);
        elements.insert(currentFocusIndex+1,insert);
        Apis.ylbwUploadImage(filePath).then((value) => {
          if (value != null) {
            insert
                ..data = value.showUrl??""
                ..property= "${fileSize/1000}KB"
          }
        });
      }
      doAfterAdd();
    }
  }

  createKeyboardActionsItem(){
    var list = <KeyboardActionsItem>[];
    for (var value in elements) {
      if (value.type == "text") {
        list.add(KeyboardActionsItem(
          focusNode: value.focusNode,
          toolbarButtons:null,
          displayActionBar: false,
          displayDoneButton:false,
          footerBuilder: (_) =>
              PreferredSize(
                  child:
                  Container(
                    height: 60.h,
                    color: PageStyle.c_E6E2E2,
                    child: Row(children: [
                      SizedBox(width: 20),
                      InkWell(child:
                      Image.asset(ImageRes.ic_ylbw_voice,width: 30.w,height: 30.w),
                      // Icon(Icons.keyboard_voice_rounded,size: 35.w,color: Colors.blue,),
                        onTap: (){
                          //开始录音
                          if(isRecording){
                            return;
                          }
                          startRecord();
                        },
                      ),

                      SizedBox(width: 20),
                      InkWell(child:
                      Image.asset(ImageRes.ic_ylbw_image,width: 30.w,height: 30.w),
                      // Icon(Icons.picture_in_picture,size: 35.w,color: Colors.blue),
                        onTap: (){
                          // FocusScope.of(context).requestFocus(FocusNode());
                          onTapAlbum();
                        },
                      ),
                      SizedBox(width: 20),
                    PopupMenuButton(
                        offset: Offset.infinite,
                        itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(child: Container(
                          color: Colors.red,
                          height: 200.w,
                          width: 200.w,
                        ))
                      ];
                    }),
                      InkWell(child:
                      Image.asset(ImageRes.ic_ylbw_label,width: 30.w,height: 30.w),
                      // Icon(Icons.label,size: 35.w,color: Colors.blue),
                        onTap: (){
                          EasyPopup.show(context, TypePopUp(_globalKey),darkEnable: false);
                          // Get.dialog(
                          //     Center(child: Container(margin: EdgeInsets.symmetric(horizontal: 80.w),width: 1.sw,height: 150.h,
                          //       decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.r)),child: ListView.builder(itemBuilder: (BuildContext context,int index){
                          //         var item2 =  logic.labelList[index];
                          //         return InkWell(
                          //           onTap: (){
                          //             logic.typeId = item2.id.toString();
                          //             logic.typeName = item2.name.toString();
                          //             Get.back();
                          //           },
                          //           child: Container(
                          //               margin: EdgeInsets.only(top: 10.h),
                          //               padding: EdgeInsets.only(left: 20.w,right: 10.w),
                          //               child:Row(
                          //                 children: [
                          //                   Image.asset(logic.typeId == item2.id.toString()?  ImageRes.ic_type_sel:ImageRes.ic_type_unsel,height: 20.w,width: 20.w,),
                          //                   SizedBox(width: 20.w),
                          //                   Text(item2.name??"",style: TextStyle(fontSize: 18.sp))
                          //                 ],
                          //                 mainAxisAlignment: MainAxisAlignment.start,
                          //               ),
                          //           ),
                          //         );
                          //
                          //         return Row(children: [
                          //           InkWell(child: Container(
                          //             padding: EdgeInsets.only(top: 10.h),
                          //             child:
                          //           Row(
                          //             children: [
                          //               Image.asset(ImageRes.ic_edit,height: 20.w,width: 20.w,),
                          //               SizedBox(width: 20.w),
                          //               Text(item2.name??"",style: TextStyle(fontSize: 18.sp))
                          //             ],
                          //             mainAxisAlignment: MainAxisAlignment.start,
                          //           )
                          //
                          //           ),onTap: (){
                          //             logic.typeId = item2.id.toString();
                          //             logic.typeName = item2.name.toString();
                          //             Get.back();
                          //           },)],mainAxisAlignment: MainAxisAlignment.center,);
                          //       },itemCount: logic.labelList.length,),),),
                          //     barrierColor: Colors.transparent
                          // );
                        },
                      ),
                      // Expanded(child: Text("完成",textAlign:TextAlign.end,style: TextStyle(decoration: TextDecoration.none,color: Colors.blue,fontSize: 14),)),
                      // SizedBox(width: 20),
                    ],),
                  ),
                  preferredSize: Size.fromHeight(40)),
        ));
      }
    }
    return list;
  }


  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.red,
        keyboardSeparatorColor: Colors.yellow,
        actions: createKeyboardActionsItem());
  }

  //分享
  void doShare() {
    YlbwListBeanData item = YlbwListBeanData();
    item.title = title;
    item.typeName = typeName;
    item.typeId = typeId;
    item.noteData = globalNewList;
    Get.toNamed(AppRoutes.SELECT_CONTACTS,arguments: {
      'action': SelAction.MyFORWARD,
      'ylbwItem':item,
      'sharePath':AppRoutes.MEDICAL_MEMO_DETAIL
    });

  }

  Widget buildFooter() {
    return Container(
      height: 60.h,
      color: PageStyle.c_E6E2E2,
      child: Row(children: [
        SizedBox(width: 20),
        InkWell(child:
        Image.asset(ImageRes.ic_ylbw_voice,width: 30.w,height: 30.w),
          // Icon(Icons.keyboard_voice_rounded,size: 35.w,color: Colors.blue,),
          onTap: (){
            //开始录音
            if(isRecording){
              return;
            }
            startRecord();
          },
        ),

        SizedBox(width: 20),
        InkWell(child:
        Image.asset(ImageRes.ic_ylbw_image,width: 30.w,height: 30.w),
          // Icon(Icons.picture_in_picture,size: 35.w,color: Colors.blue),
          onTap: (){
            // FocusScope.of(context).requestFocus(FocusNode());
            onTapAlbum();
          },
        ),
        SizedBox(width: 20),
        PopupMenuButton(
          offset: Offset(35.w,300.h),
          padding: EdgeInsets.all(0),
          child: Image.asset(ImageRes.ic_ylbw_label,width: 30.w,height: 30.w),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    padding: EdgeInsets.all(0),
                    child: Container(width: 150.w,height: 130.h,
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.r)),child: ListView.builder(itemBuilder: (BuildContext context,int index){
                    var item2 =  labelList[index];
                    return InkWell(
                      onTap: (){
                        typeId = item2.id.toString();
                        typeName = item2.name.toString();
                        Get.back();
                      },
                      child:

                      Container(
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.only(left: 10.w,right: 10.w),
                        child:Row(
                          children: [
                            Image.asset(typeId == item2.id.toString()?  ImageRes.ic_type_sel:ImageRes.ic_type_unsel,height: 20.w,width: 20.w,),
                            SizedBox(width: 20.w),
                            Text(item2.name??"",style: TextStyle(fontSize: 18.sp))
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      ),
                    );
                  },itemCount: labelList.length,),))
              ];
            }),
        // InkWell(child:
        // Image.asset(ImageRes.ic_ylbw_label,width: 30.w,height: 30.w),
        //   // Icon(Icons.label,size: 35.w,color: Colors.blue),
        //   onTap: (){
        //     // EasyPopup.show(context, TypePopUp(_globalKey),darkEnable: false);
        //     Get.dialog(
        //         Center(child: Container(margin: EdgeInsets.symmetric(horizontal: 80.w),width: 1.sw,height: 150.h,
        //           decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.r)),child: ListView.builder(itemBuilder: (BuildContext context,int index){
        //             var item2 =  logic.labelList[index];
        //             return InkWell(
        //               onTap: (){
        //                 logic.typeId = item2.id.toString();
        //                 logic.typeName = item2.name.toString();
        //                 Get.back();
        //               },
        //               child: Container(
        //                   margin: EdgeInsets.only(top: 10.h),
        //                   padding: EdgeInsets.only(left: 20.w,right: 10.w),
        //                   child:Row(
        //                     children: [
        //                       Image.asset(logic.typeId == item2.id.toString()?  ImageRes.ic_type_sel:ImageRes.ic_type_unsel,height: 20.w,width: 20.w,),
        //                       SizedBox(width: 20.w),
        //                       Text(item2.name??"",style: TextStyle(fontSize: 18.sp))
        //                     ],
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                   ),
        //               ),
        //             );
        //           },itemCount: logic.labelList.length,),),),
        //         barrierColor: Colors.transparent
        //     );
        //   },
        // ),
        // Expanded(child: Text("完成",textAlign:TextAlign.end,style: TextStyle(decoration: TextDecoration.none,color: Colors.blue,fontSize: 14),)),
        // SizedBox(width: 20),
      ],),
    );
  }
}

GlobalKey _globalKey = GlobalKey();


class TypePopUp extends StatefulWidget with EasyPopupChild{

  TypePopUp(this.globalKey,{Key? key}) : super(key: key);
  GlobalKey globalKey;
  @override
  State<TypePopUp> createState() => _TypePopUpState();


  @override
  dismiss() {

  }
}

class _TypePopUpState extends State<TypePopUp> {


  @override
  void initState() {
    // print("类型弹窗初始化了");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RenderBox? box =  widget.globalKey.currentContext?.findRenderObject() as RenderBox?;

    var height = 200.h;
    if(box!=null){
      var hei = box.paintBounds.height;
      Offset offset = box.localToGlobal(Offset.zero);
      height = offset.dy-hei;
    }

    return Column(
      children: [
        SizedBox(height: height),
    Container(
    height: 200.w,
    width: 200.w,
    color: Colors.red,
    )
      ],
    );

    return Container(
      height: 200.w,
      width: 200.w,
      color: Colors.red,
    );
  }
}