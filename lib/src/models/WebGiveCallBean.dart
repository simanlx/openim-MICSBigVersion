
class WebGiveCallBean {
  bool? type;
  List<CallList>? callList;

  WebGiveCallBean({this.type, this.callList});

  WebGiveCallBean.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['callList'] != null) {
      callList = <CallList>[];
      json['callList'].forEach((v) {
        callList!.add(new CallList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.callList != null) {
      data['callList'] = this.callList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CallList {
  int? id;
  String? account;
  String? name;

  CallList({this.id, this.account, this.name});

  CallList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    account = json['account'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['account'] = this.account;
    data['name'] = this.name;
    return data;
  }
}