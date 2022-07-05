class AppVersionInfo {
  int? id;
  int? type;
  String? appName;
  String? appDesc;
  String? appCode;
  String? appUrl;
  int? versionCode;
  String? buildAt;
  bool? needForceUpdate; //后面要加上

  AppVersionInfo(
      {this.id,
        this.type,
        this.appName,
        this.appDesc,
        this.appCode,
        this.appUrl,
        this.versionCode,
        this.buildAt});

  AppVersionInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    appName = json['app_name'];
    appDesc = json['app_desc'];
    appCode = json['app_code'];
    appUrl = json['app_url'];
    versionCode = json['version_code'];
    buildAt = json['build_at'];
    needForceUpdate = json['need_force_update'] is bool?json['need_force_update']:false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['app_name'] = this.appName;
    data['app_desc'] = this.appDesc;
    data['app_code'] = this.appCode;
    data['app_url'] = this.appUrl;
    data['version_code'] = this.versionCode;
    data['build_at'] = this.buildAt;
    return data;
  }
}