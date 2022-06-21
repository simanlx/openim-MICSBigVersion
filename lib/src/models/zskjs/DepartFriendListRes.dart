
import 'package:azlistview/azlistview.dart';

class DepartFriendListRes with ISuspensionBean{
  String? account;
  String? initials;
  int? id;
  String? realName;
  String? uuid;
  int? floorId;
  String? headImageUrl;
  String? job;
  String? departmentName;
  String? floorName;
  String? pointName;
  String? area;
  int? deviceType;
  int? onlineStatus;
  String? sex;
  String? deviceName;
  String? positionName;

  DepartFriendListRes(
      {this.account,
        this.initials,
        this.id,
        this.realName,
        this.uuid,
        this.floorId,
        this.headImageUrl,
        this.job,
        this.departmentName,
        this.floorName,
        this.pointName,
        this.area,
        this.deviceType,
        this.onlineStatus,
        this.sex,
        this.deviceName,
        this.positionName});

  DepartFriendListRes.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    initials = json['initials'];
    id = json['id'];
    realName = json['real_name'];
    uuid = json['uuid'];
    floorId = json['floor_id'];
    headImageUrl = json['head_image_url'];
    job = json['job'];
    departmentName = json['department_name'];
    floorName = json['floor_name'];
    pointName = json['point_name'];
    area = json['area'];
    deviceType = json['device_type'];
    onlineStatus = json['online_status'];
    sex = json['sex'];
    deviceName = json['device_name'];
    positionName = json['position_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['initials'] = this.initials;
    data['id'] = this.id;
    data['real_name'] = this.realName;
    data['uuid'] = this.uuid;
    data['floor_id'] = this.floorId;
    data['head_image_url'] = this.headImageUrl;
    data['job'] = this.job;
    data['department_name'] = this.departmentName;
    data['floor_name'] = this.floorName;
    data['point_name'] = this.pointName;
    data['area'] = this.area;
    data['device_type'] = this.deviceType;
    data['online_status'] = this.onlineStatus;
    data['sex'] = this.sex;
    data['device_name'] = this.deviceName;
    data['position_name'] = this.positionName;
    return data;
  }

  @override
  String getSuspensionTag() {
    return initials!;
  }
}