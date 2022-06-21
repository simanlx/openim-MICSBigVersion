

import 'package:flutter/cupertino.dart';

class YlbwElement{

  YlbwElement({this.type,this.content,this.fileName,this.fileUrl,this.voiceLength,this.isRecording}){
    textEditingController.text = content??"";
  }

  FocusNode focusNode = FocusNode();
  int? type;
  String? content;
  String? fileName;
  String? fileUrl;
  int? voiceLength;
  int currentSec = 0;
  bool? isRecording; //在录音
  bool? isPlaying;//在播放

  var textEditingController  = TextEditingController();

}