class YlbwUploadRes {
  String? path;
  String? uploadId;
  FileInfo? fileInfo;
  String? showUrl;

  YlbwUploadRes({this.path, this.uploadId, this.fileInfo, this.showUrl});

  YlbwUploadRes.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    uploadId = json['upload_id'];
    fileInfo = json['file_info'] != null
        ? new FileInfo.fromJson(json['file_info'])
        : null;
    showUrl = json['show_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['upload_id'] = this.uploadId;
    if (this.fileInfo != null) {
      data['file_info'] = this.fileInfo!.toJson();
    }
    data['show_url'] = this.showUrl;
    return data;
  }
}

class FileInfo {
  int? filesize;
  String? mimeType;
  double? playtimeSeconds;
  String? playtimeString;
  String? fileformat;

  FileInfo(
      {this.filesize,
        this.mimeType,
        this.playtimeSeconds,
        this.playtimeString,
        this.fileformat});

  FileInfo.fromJson(Map<String, dynamic> json) {
    filesize = json['filesize'];
    mimeType = json['mime_type'];
    playtimeSeconds = json['playtime_seconds'];
    playtimeString = json['playtime_string'];
    fileformat = json['fileformat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filesize'] = this.filesize;
    data['mime_type'] = this.mimeType;
    data['playtime_seconds'] = this.playtimeSeconds;
    data['playtime_string'] = this.playtimeString;
    data['fileformat'] = this.fileformat;
    return data;
  }
}