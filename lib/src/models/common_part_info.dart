

//工作台-常用应用
class CommonPartInfo {
  int? id;
  String? name;
  String? icon;
  int? sorts;
  int? status;
  int? isBuiltin;
  String? appUrl;
  String? manageUrl;
  int? createTime;

  CommonPartInfo(
      {this.id,
        this.name,
        this.icon,
        this.sorts,
        this.status,
        this.isBuiltin,
        this.appUrl,
        this.manageUrl,
        this.createTime});

  CommonPartInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    sorts = json['sorts'];
    status = json['status'];
    isBuiltin = json['is_builtin'];
    appUrl = json['app_url'];
    manageUrl = json['manage_url'];
    createTime = json['create_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['sorts'] = this.sorts;
    data['status'] = this.status;
    data['is_builtin'] = this.isBuiltin;
    data['app_url'] = this.appUrl;
    data['manage_url'] = this.manageUrl;
    data['create_time'] = this.createTime;
    return data;
  }
}