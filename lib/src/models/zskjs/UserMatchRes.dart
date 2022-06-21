

class UserMatchRes {
  String? id;
  String? account;
  String? realName;

  UserMatchRes({this.id, this.realName});

  UserMatchRes.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    account = json['account'].toString();
    realName = json['real_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['account'] = this.account;
    data['real_name'] = this.realName;
    return data;
  }
}