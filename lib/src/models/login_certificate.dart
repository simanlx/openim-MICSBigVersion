class LoginCertificate {
  String userID;
  String token;
  String headUrl;
  String realName;
  String job;
  String departmentName;

  LoginCertificate.fromJson(Map<String, dynamic> map)
      : userID = map["userID"],
        headUrl = map["head_image_url"],
        realName = map["real_name"],
        job = map["job"],
        departmentName = map["department_name"],
        token = map["token"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['token'] = token;
    data['head_image_url'] = headUrl;
    data['real_name'] = realName;
    data['job'] = job;
    data['department_name'] = departmentName;
    return data;
  }
}
