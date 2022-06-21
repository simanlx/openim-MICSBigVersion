
class GdjlRes {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<GdjlResData>? data;

  GdjlRes(
      {this.total, this.perPage, this.currentPage, this.lastPage, this.data});

  GdjlRes.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    if (json['data'] != null) {
      data = <GdjlResData>[];
      json['data'].forEach((v) {
        data!.add(new GdjlResData.fromJson(v));
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

class GdjlResData {
  String? serverMsgId;
  String? groupId;
  String? groupName;
  String? sessionType;
  String? contentType;
  String? senderNickName;
  String? senderId;
  dynamic wholeContent;
  String? date;
  String? clientMsgId;
  String? senderFaceUrl;

  GdjlResData(
      {this.serverMsgId,
        this.groupId,
        this.groupName,
        this.sessionType,
        this.contentType,
        this.senderNickName,
        this.senderId,
        this.wholeContent,
        this.date,
        this.clientMsgId,
        this.senderFaceUrl});

  GdjlResData.fromJson(Map<String, dynamic> json) {
    serverMsgId = json['server_msg_id'];
    groupId = json['group_id'];
    groupName = json['group_name'];
    sessionType = json['session_type'];
    contentType = json['content_type'];
    senderNickName = json['sender_nick_name'];
    senderId = json['sender_id'];
    wholeContent = json['whole_content'];
    date = json['date'];
    clientMsgId = json['client_msg_id'];
    senderFaceUrl = json['sender_face_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['server_msg_id'] = this.serverMsgId;
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    data['session_type'] = this.sessionType;
    data['content_type'] = this.contentType;
    data['sender_nick_name'] = this.senderNickName;
    data['sender_id'] = this.senderId;
    data['whole_content'] = this.wholeContent;
    data['date'] = this.date;
    data['client_msg_id'] = this.clientMsgId;
    data['sender_face_url'] = this.senderFaceUrl;
    return data;
  }
}