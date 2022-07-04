
import 'package:flutter_openim_widget/flutter_openim_widget.dart';

import 'PatientDetailRes.dart';
import 'YlbwListBean.dart';

class CollectListRes {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<Data>? data;

  CollectListRes(
      {this.total, this.perPage, this.currentPage, this.lastPage, this.data});

  CollectListRes.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? from;
  int? type;
  String? createTime;
  int? operateUser;
  Content? content;
  ExtraInfo? extraInfo;
  String? showIcon;

  Data(
      {this.id,
        this.title,
        this.from,
        this.type,
        this.createTime,
        this.operateUser,
        this.content,
        this.extraInfo,
        this.showIcon});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    from = json['from'];
    type = json['type'];
    createTime = json['create_time'];
    operateUser = json['operate_user'];
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    extraInfo = json['extra_info'] != null
        ? new ExtraInfo.fromJson(json['extra_info'])
        : null;
    showIcon = json['show_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['from'] = this.from;
    data['type'] = this.type;
    data['create_time'] = this.createTime;
    data['operate_user'] = this.operateUser;
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    if (this.extraInfo != null) {
      data['extra_info'] = this.extraInfo!.toJson();
    }
    data['show_icon'] = this.showIcon;
    return data;
  }
}

class Content {
  String? txt;
  String? voice;
  String? voice_length;
  String? file_name;
  String? file_path;
  String? image_path;
  String? video_path;
  PatientDetailRes? patient;
  YlbwListBeanData? note;
  Message? message;


  Content({this.txt});

  Content.fromJson(Map<String, dynamic> json) {
    txt = json['txt'];
    voice = json['voice'];
    voice_length = json['voice_length'].toString();
    file_name = json['file_name'];
    file_path = json['file_path'];
    image_path = json['image_path'];
    video_path = json['video_path'];
    if (json["patient"]!=null) {
      patient = PatientDetailRes.fromJson(json["patient"]);
    }
    if (json["note"]!=null) {
      note = YlbwListBeanData.fromJson(json["note"]);
    }
    if (json["message"]!=null) {
      message = Message.fromJson(json["message"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['txt'] = this.txt;
    data['voice'] = this.voice;
    data['voice_length'] = this.voice_length;
    data['file_name'] = this.file_name;
    data['file_path'] = this.file_path;
    data['image_path'] = this.image_path;
    data['video_path'] = this.video_path;
    if(patient!=null){
      data['patient'] = this.patient!.toJson();
    }
    if (note!=null) {
      data['note'] = this.note!.toJson();
    }
    if (message!=null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class ExtraInfo {
  String? createUserId;
  String? createUserName;
  String? createUserAvatar;
  String? createTime;

  ExtraInfo(
      {this.createUserId,
        this.createUserName,
        this.createUserAvatar,
        this.createTime});

  ExtraInfo.fromJson(Map<String, dynamic> json) {
    createUserId = json['create_user_id'];
    createUserName = json['create_user_name'];
    createUserAvatar = json['create_user_avatar'];
    createTime = json['create_time'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create_user_id'] = this.createUserId;
    data['create_user_name'] = this.createUserName;
    data['create_user_avatar'] = this.createUserAvatar;
    data['create_time'] = this.createTime;
    return data;
  }
}