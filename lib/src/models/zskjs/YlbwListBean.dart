import 'dart:convert' as jjjj;

import 'package:mics_big_version/src/models/zskjs/YlbwElementNew.dart';

class YlbwListBean{
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<YlbwListBeanData>? data;

  YlbwListBean(
      {this.total, this.perPage, this.currentPage, this.lastPage, this.data});

  YlbwListBean.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    if (json['data'] != null) {
      data = <YlbwListBeanData>[];
      json['data'].forEach((v) {
        data!.add(new YlbwListBeanData.fromJson(v));
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


class YlbwListBeanData {
  // var id = "";
  // var type_id = "";
  // var title = "";
  // var create_time = "";
  // var update_time = "";
  // var type_name = "";
  // var note_data = <YlbwElementNew>[];

  int? id;
  String? typeId;
  String? title;
  String? createTime;
  String? updateTime;
  List<YlbwElementNew>? noteData;
  String? typeName;
  int? isTop;
  int? topTime;

  YlbwListBeanData({this.id,
    this.typeId,
    this.title,
    this.createTime,
    this.updateTime,
    this.noteData,
    this.typeName});

  YlbwListBeanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['type_id'].toString();
    title = json['title'];
    createTime = json['create_time'].toString();
    updateTime = json['update_time'].toString();
    if (json['note_data'] != null) {
      noteData = <YlbwElementNew>[];
      var aa = json['note_data'];
      if(aa is String){
        jjjj.json.decode(aa).forEach((v) {
          noteData!.add(new YlbwElementNew.fromJson(v));
        });
      }else{
        json['note_data'].forEach((v) {
          noteData!.add(new YlbwElementNew.fromJson(v));
        });
      };
    }
    typeName = json['type_name'];
    isTop = json['is_top'];
    topTime = json['top_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_id'] = this.typeId;
    data['title'] = this.title;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    if (this.noteData != null) {
      data['note_data'] = this.noteData!.map((v) => v.toJson()).toList();
    }
    data['type_name'] = this.typeName;
    data['is_Top'] = this.isTop;
    data['top_time'] = this.topTime;
    return data;
  }
}
