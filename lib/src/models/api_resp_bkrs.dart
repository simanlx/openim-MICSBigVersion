class BkrsApiResp {
  String code;
  String description;
  dynamic data;

  BkrsApiResp.fromJson(Map<String, dynamic> map)
      : code = map["code"].toString(),
        description = map["description"],
        data = map["data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    data['data'] = data;
    return data;
  }
}
