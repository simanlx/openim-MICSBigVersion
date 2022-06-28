

import 'package:flutter/cupertino.dart';

class YlbwElementNew{



  String index = "";
  String type = "";
  String property = "";
  String data = ""; //远程地址
  String upload_id = ""; //远程语音转写id
  String zxText = ""; //远程语音转写id
  bool isZxExpand = false;

  int? voiceLength;
  int currentSec = 0;
  bool? isRecording; //在录音
  bool? isPlaying;//在播放
  String? fileUrl;//本地地址
  bool? autoFocus;

  FocusNode focusNode = FocusNode();
  var textEditingController = TextEditingController();

  YlbwElementNew({this.index = "", this.type = "", this.property="", this.data = "",this.fileUrl,this.voiceLength,this.isRecording,this.autoFocus}){
    textEditingController.text = data;
  }

  YlbwElementNew.fromJson(Map<String, dynamic> json) {
    index = json['index'].toString();
    type = json['type'];
    property = json['property'];
    data = json['data'];
    upload_id = json['upload_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['type'] = this.type;
    data['property'] = this.property;
    data['data'] = this.data;
    data['upload_id'] = this.upload_id;
    return data;
  }

}