import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:mics_big_version/src/common/urls.dart';
import '../models/common_part_info.dart';
import '../models/login_certificate.dart';
import '../models/online_status.dart';
import '../models/tag_group.dart';
import '../models/tag_notification.dart';
import '../models/upgrade_info.dart';
import '../models/zskjs/CollectListRes.dart';
import '../models/zskjs/DepartFriendListRes.dart';
import '../models/zskjs/DepartListRes.dart';
import '../models/zskjs/GdjlRes.dart';
import '../models/zskjs/PatientDetailRes.dart';
import '../models/zskjs/PatientListRes.dart';
import '../models/zskjs/PatientRoomRes.dart';
import '../models/zskjs/SaveYlbwRes.dart';
import '../models/zskjs/UserMatchRes.dart';
import '../models/zskjs/VoiceTransferRes.dart';
import '../models/zskjs/YlbwElementNew.dart';
import '../models/zskjs/YlbwListBean.dart';
import '../models/zskjs/YlbwType.dart';
import '../models/zskjs/YlbwUploadRes.dart';
import '../models/zskjs/ZskjsListContentListItem.dart';
import '../models/zskjs/ZskjsListItem.dart';
import '../res/strings.dart';
import '../sdk_extension/message_manager.dart';
import '../utils/data_persistence.dart';
import '../utils/http_util.dart';
import '../utils/im_util.dart';
import '../widgets/im_widget.dart';
import 'config.dart';

class Apis {
  static int get _platform =>
      Platform.isAndroid ? IMPlatform.android : IMPlatform.ios;
  static final openIMMemberIDS = [
    "18349115126",
    "13918588195",
    "17396220460",
    "18666662412"
  ];
  static final openIMGroupID = '2a90f8c6f37edafd19c0ad8a9f4d347a';

  /// im登录，App端不再使用，该方法应该在业务服务端调用
  static Future<LoginCertificate> loginIM(String uid) async {
    try {
      var data = await HttpUtil.post(Urls.login2, data: {
        'secret': Config.secret,
        'platform': _platform,
        'userID': uid,
        'operationID': _getOperationID(),
      });
      return LoginCertificate.fromJson(data!);
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  /// im注册，App端不再使用，该方法应该在业务服务端调用
  static Future<bool> registerIM({
    required String uid,
    required String name,
    String? faceURL,
  }) async {
    try {
      await HttpUtil.post(Urls.register2, data: {
        'secret': Config.secret,
        'platform': _platform,
        'userID': uid,
        'nickname': name,
        'faceURL': faceURL,
        'operationID': _getOperationID(),
      });
      return true;
    } catch (e) {
      print('e:$e');
      return false;
    }
  }

  /// login
  static Future<LoginCertificate> login({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String password,
  }) async {
    try {
      var a = {
        'phoneNumber': phoneNumber,
        'password': IMUtil.generateMD5(password),
        'platform': _platform,
        'operationID': _getOperationID(),
      };
      var data = await HttpUtil.postBkrs(Urls.login, data: a);
      return LoginCertificate.fromJson(data!);
    } catch (e) {
      print('e:$e');
      // var error = e as DioError;
      // IMWidget.showToast('登录失败，请联系管理员:${error.response}');
      return Future.error(e);
    }
  }

  /// register
  static Future<LoginCertificate> setPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String password,
    required String verificationCode,
  }) async {
    try {
      var data = await HttpUtil.post(Urls.setPwd, data: {
        "areaCode": areaCode,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': IMUtil.generateMD5(password),
        'verificationCode': verificationCode,
        'platform': Platform.isAndroid ? IMPlatform.android : IMPlatform.ios,
        'operationID': _getOperationID(),
      });
      return LoginCertificate.fromJson(data!);
    } catch (e) {
      print('e:$e');
      // var error = e as DioError;
      // IMWidget.showToast('注册失败，请联系管理员:${error.response}');
      return Future.error(e);
    }
  }

  /// reset password
  static Future<dynamic> resetPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String password,
    required String verificationCode,
  }) {
    return HttpUtil.post(Urls.resetPwd, data: {
      "areaCode": areaCode,
      'phoneNumber': phoneNumber,
      'email': email,
      'newPassword': IMUtil.generateMD5(password),
      'verificationCode': verificationCode,
      'platform': Platform.isAndroid ? IMPlatform.android : IMPlatform.ios,
      'operationID': _getOperationID(),
    });
  }

  /// 获取验证码
  /// [usedFor] 1：注册，2：重置密码
  static Future<bool> requestVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required int usedFor,
  }) async {
    return HttpUtil.post(
      Urls.getVerificationCode,
      data: {
        "areaCode": areaCode,
        "phoneNumber": phoneNumber,
        "email": email,
        'operationID': _getOperationID(),
        'usedFor': usedFor,
      },
    ).then((value) {
      IMWidget.showToast(StrRes.sentSuccessfully);
      return true;
    }).catchError((e) {
      print('e:$e');
      // var error = e as DioError;
      // IMWidget.showToast('发送失败:${error.response}');
      return false;
    });
  }

  /// 校验验证码
  static Future<dynamic> checkVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verificationCode,
    required int usedFor,
  }) {
    return HttpUtil.post(
      Urls.checkVerificationCode,
      data: {
        "phoneNumber": phoneNumber,
        "areaCode": areaCode,
        "email": email,
        "verificationCode": verificationCode,
        "usedFor": usedFor,
        'operationID': _getOperationID(),
      },
    );
  }

  /// 查询tag组
  static Future<TagGroup> getUserTags() {
    return HttpUtil.post(
      Urls.getUserTags,
      data: {'operationID': _getOperationID()},
      options: _tokenOptions(),
    ).then((value) => TagGroup.fromJson(value));
  }

  /// 创建tag
  static createTag({
    required String tagName,
    required List<String> userIDList,
  }) {
    return HttpUtil.post(
      Urls.createTag,
      data: {
        'tagName': tagName,
        'userIDList': userIDList,
        'operationID': _getOperationID(),
      },
      options: _tokenOptions(),
    );
  }

  /// 创建tag
  static deleteTag({
    required String tagID,
  }) {
    return HttpUtil.post(
      Urls.deleteTag,
      data: {
        'tagID': tagID,
        'operationID': _getOperationID(),
      },
      options: _tokenOptions(),
    );
  }

  /// 创建tag
  static updateTag({
    required String tagID,
    required String newName,
    required List<String> increaseUserIDList,
    required List<String> reduceUserIDList,
  }) {
    return HttpUtil.post(
      Urls.updateTag,
      data: {
        'tagID': tagID,
        'newName': newName,
        'increaseUserIDList': increaseUserIDList,
        'reduceUserIDList': reduceUserIDList,
        'operationID': _getOperationID(),
      },
      options: _tokenOptions(),
    );
  }

  /// 下发tag通知
  static sendMsgToTag({
    String? url,
    int? duration,
    String? text,
    List<String> tagIDList = const [],
    List<String> userIDList = const [],
    List<String> groupIDList = const [],
  }) async {
    return HttpUtil.post(
      Urls.sendMsgToTag,
      data: {
        'tagList': tagIDList,
        'userList': userIDList,
        'groupList': groupIDList,
        'senderPlatformID': _platform,
        'content': json.encode({
          'data': json.encode({
            "customType": CustomMessageType.tag_message,
            "data": {
              'url': url,
              'duration': duration,
              'text': text,
            },
          }),
          'extension': '',
          'description': '',
        }),
        'operationID': _getOperationID(),
      },
      options: _tokenOptions(),
    );
  }

  /// 获取tag通知列表
  static Future<TagNotification> getSendTagLog({
    required int pageNumber,
    required int showNumber,
  }) async {
    return HttpUtil.post(
      Urls.getSendTagLog,
      data: {
        'pageNumber': pageNumber,
        'showNumber': showNumber,
        'operationID': _getOperationID(),
      },
      options: _tokenOptions(),
    ).then((value) => TagNotification.fromJson(value));
  }

  //////////////////////以下功能不应该出现在app里///////////////////////////////////
  /// 为用户导入好友OpenIM成员
  static Future<bool> importFriends({
    required String uid,
    required String token,
  }) async {
    try {
      await HttpUtil.post(
        Urls.importFriends,
        data: {
          "uidList": openIMMemberIDS,
          "ownerUid": uid,
          'operationID': _getOperationID(),
        },
        options: Options(headers: {'token': token}),
      );
      return true;
    } catch (e) {
      print('e:$e');
    }
    return false;
  }

  /// 拉用户进OpenIM官方体验群
  static Future<bool> inviteToGroup({
    required String uid,
    required String token,
  }) async {
    try {
      await dio.post(
        Urls.inviteToGroup,
        data: {
          "groupID": openIMGroupID,
          "uidList": [uid],
          "reason": "Welcome join openim group",
          'operationID': _getOperationID(),
        },
        options: Options(headers: {'token': token}),
      );
      return true;
    } catch (e) {
      print('e:$e');
    }
    return false;
  }

  /// 管理员调用获取IM已经注册的所有用户的userID接口
  static Future<List<String>?> queryAllUsers() async {
    try {
      var data = await loginIM('openIM123456');
      var list = await HttpUtil.post(
        Urls.queryAllUsers,
        data: {'operationID': _getOperationID()},
        options: Options(headers: {'token': data.token}),
      );
      return list.cast<String>();
    } catch (e) {
      print('e:$e');
    }
    return null;
  }

  /// 蒲公英更新检测
  static Future<UpgradeInfoV2> checkUpgradeV2() {
    return dio.post<Map<String, dynamic>>(
      'https://www.pgyer.com/apiv2/app/check',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
      ),
      data: {
        '_api_key': 'a8d237955358a873cb9472d6df198490',
        'appKey': 'ae0f3138d2c3ca660039945ffd70adb6',
      },
    ).then((resp) {
      Map<String, dynamic> map = resp.data!;
      if (map['code'] == 0) {
        return UpgradeInfoV2.fromJson(map['data']);
      }
      return Future.error(map);
    });
  }

  static void queryUserOnlineStatus({
    required List<String> uidList,
    Function(Map<String, String>)? onlineStatusDescCallback,
    Function(Map<String, bool>)? onlineStatusCallback,
  }) async {
    var resp = await dio.post<Map<String, dynamic>>(
      Urls.userOnlineStatus,
      data: {
        'operationID': _getOperationID(),
        "userIDList": uidList,
      },
      options: _tokenOptions(),
    );
    Map<String, dynamic> map = resp.data!;
    if (map['errCode'] == 0 && map['data'] is List) {
      _handleStatus(
        (map['data'] as List).map((e) => OnlineStatus.fromJson(e)).toList(),
        onlineStatusCallback: onlineStatusCallback,
        onlineStatusDescCallback: onlineStatusDescCallback,
      );
    }
  }

  static Future<List<OnlineStatus>> _onlineStatus({
    required List<String> uidList,
    required String token,
  }) async {
    var resp = await dio.post<Map<String, dynamic>>(
      Urls.onlineStatus,
      data: {
        'operationID': _getOperationID(),
        "secret": Config.secret,
        "userIDList": uidList,
      },
      options: Options(headers: {'token': token}),
    );
    Map<String, dynamic> map = resp.data!;
    if (map['errCode'] == 0) {
      return (map['data'] as List)
          .map((e) => OnlineStatus.fromJson(e))
          .toList();
    }
    return Future.error(map);
  }

  /// 每次最多查询200条
  static void queryOnlineStatus({
    required List<String> uidList,
    Function(Map<String, String>)? onlineStatusDescCallback,
    Function(Map<String, bool>)? onlineStatusCallback,
  }) async {
    // if (uidList.isEmpty) return;
    // var data = await Apis.loginIM('openIM123456');
    // var batch = uidList.length ~/ 200;
    // var remainder = uidList.length % 200;
    // var i = 0;
    // var subList;
    // if (batch > 0) {
    //   for (; i < batch; i++) {
    //     subList = uidList.sublist(i * 200, 200 * (i + 1));
    //     Apis._onlineStatus(uidList: subList, token: data.token)
    //         .then((list) => _handleStatus(
    //               list,
    //               onlineStatusCallback: onlineStatusCallback,
    //               onlineStatusDescCallback: onlineStatusDescCallback,
    //             ));
    //   }
    // }
    // if (remainder > 0) {
    //   if (i > 0) {
    //     subList = uidList.sublist(i * 200, 200 * i + remainder);
    //     Apis._onlineStatus(uidList: subList, token: data.token)
    //         .then((list) => _handleStatus(
    //               list,
    //               onlineStatusCallback: onlineStatusCallback,
    //               onlineStatusDescCallback: onlineStatusDescCallback,
    //             ));
    //   } else {
    //     subList = uidList.sublist(0, remainder);
    //     Apis._onlineStatus(uidList: subList, token: data.token)
    //         .then((list) => _handleStatus(
    //               list,
    //               onlineStatusCallback: onlineStatusCallback,
    //               onlineStatusDescCallback: onlineStatusDescCallback,
    //             ));
    //   }
    // }
  }

  static _handleStatus(List<OnlineStatus> list, {
    Function(Map<String, String>)? onlineStatusDescCallback,
    Function(Map<String, bool>)? onlineStatusCallback,
  }) {
    final statusDesc = <String, String>{};
    final status = <String, bool>{};
    list.forEach((e) {
      if (e.status == 'online') {
        // IOSPlatformStr     = "IOS"
        // AndroidPlatformStr = "Android"
        // WindowsPlatformStr = "Windows"
        // OSXPlatformStr     = "OSX"
        // WebPlatformStr     = "Web"
        // MiniWebPlatformStr = "MiniWeb"
        // LinuxPlatformStr   = "Linux"
        final pList = <String>[];
        for (var platform in e.detailPlatformStatus!) {
          if (platform.platform == "Android" || platform.platform == "IOS") {
            pList.add(StrRes.phoneOnline);
          } else if (platform.platform == "Windows") {
            pList.add(StrRes.pcOnline);
          } else if (platform.platform == "Web") {
            pList.add(StrRes.webOnline);
          } else if (platform.platform == "MiniWeb") {
            pList.add(StrRes.webMiniOnline);
          } else {
            statusDesc[e.userID!] = StrRes.online;
          }
        }
        statusDesc[e.userID!] = '${pList.join('/')}${StrRes.online}';
        status[e.userID!] = true;
      } else {
        statusDesc[e.userID!] = StrRes.offline;
        status[e.userID!] = false;
      }
    });
    onlineStatusDescCallback?.call(statusDesc);
    onlineStatusCallback?.call(status);
  }

  static Options _tokenOptions() {
    return Options(
        headers: {'token': DataPersistence.getLoginCertificate()!.token});
  }

  static Options _tokenOptionsBkrs() {
    return Options(
        headers: {'DTOKEN': DataPersistence.getLoginCertificate()!.token});
  }

  static String _getOperationID() {
    return DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
  }


  //北科瑞声 接口

  //知识库检索
  static Future<List<ZskjsListItem>?> getZskjsList() async {
    try {
      var res = await HttpUtil.get(Urls.getZskjsList);
      print("得到的结果 ${res}");
      return (res as List)
          .map((e) => ZskjsListItem.fromJson(e))
          .toList();
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  static Future<ZskjsListContentListItem?> getZskjsListByFilter(int page,
      int size, String name, String? type_id) async {
    try {
      var data = {
        "page": page,
        "size": size,
        "name": name,
        "type_id": type_id ?? "",
      };
      var res = await HttpUtil.postBkrs(Urls.getZskjsListByFilte, data: data);

      return ZskjsListContentListItem.fromJson(res);
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }


  //医疗备忘
  static Future<List<YlbwType>?> getYlbwLabelList() async {
    try {
      var res = await HttpUtil.get(Urls.getYlbwLabelList);
      return (res as List)
          .map((e) => YlbwType.fromJson(e))
          .toList();
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  static Future<YlbwUploadRes?> ylbwUploadImage(String filePath) async {
    try {

      FormData formData = FormData.fromMap({
        "file":await MultipartFile.fromFile(filePath)
      });
      var res = await HttpUtil.postBkrs(Urls.ylbwUploadImage,
          data: formData,
          options: _tokenOptionsBkrs());
      return Future.value(YlbwUploadRes.fromJson(res));
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }
  static Future<YlbwUploadRes?> ylbwUploadRadio(String filePath) async {
    try {
      var res = await HttpUtil.postBkrs(Urls.ylbwUploadVoice,
          data: FormData.fromMap({
            "file": MultipartFile.fromFileSync(filePath)
          }),
          options: _tokenOptionsBkrs());
      return Future.value(YlbwUploadRes.fromJson(res));
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  static Future<SaveYlbwRes?> updateYlbw(List<YlbwElementNew> elements, String typeId, String title, int id) async{
    try {
      var jsonStr = json.encode(elements);
      var res = await HttpUtil.postBkrs(Urls.updateylbw,
          data: {
            "type_id": typeId,
            "title": title,
            "note_data": jsonStr,
            "note_id":id
          },
          options: _tokenOptionsBkrs());
      return Future.value(SaveYlbwRes.fromJson(res));
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  static Future<SaveYlbwRes?> saveYlbw(List<YlbwElementNew> elements, String typeId,
      String title) async {
    try {
      var jsonStr = json.encode(elements);
      var res = await HttpUtil.postBkrs(Urls.saveylbw,
          data: {
            "type_id": typeId,
            "title": title,
            "note_data": jsonStr
          },
          options: _tokenOptionsBkrs());
      print("333333333333");
      print("333333333333$res");
      print("333333333333${SaveYlbwRes.fromJson(res)}");
      return Future.value(SaveYlbwRes.fromJson(res));
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }


  static Future<YlbwListBean?> getYlbwList(int pageIndex, int pageSize,
      String keyword, String type_id) async {
    try {
      var data = {
        "size": pageSize,
        "page": pageIndex,
        "title": keyword,
        "type_id": type_id
      };
      var res = await HttpUtil.postBkrs(
          Urls.getYlbwList, data: data, options: _tokenOptionsBkrs());
      print("这个返回的结果"+res.toString());
      return Future.value(YlbwListBean.fromJson(res));
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  static Future removeYlbw(String note_id) async {
    try {
      var data = {
        "note_id": note_id
      };
      var res = await HttpUtil.postBkrs(
          Urls.removeYlbw, data: data, options: _tokenOptionsBkrs());
      print("这个返回的结果"+res.toString());
      return Future.value(res);
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }


  static Future beginYyzx(String upload_id) async{
    try {
      var data = {
        "upload_id": upload_id
      };
      var res = await HttpUtil.postBkrs(
          Urls.startYyzx, data: data, options: _tokenOptionsBkrs());
      return Future.value(res);
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  //获取语音转写结果
  static Future<VoiceTransferRes?> getYyzxText(String upload_id) async {
    try {
      var data = {
        "upload_id": upload_id
      };
      var res = await HttpUtil.postBkrs(
          Urls.getYyzxText, data: data, options: _tokenOptionsBkrs());
      print("这个返回的结果"+res.toString());
      return Future.value(VoiceTransferRes.fromJson(res));
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }


/**
 * 患者管理
 */


  static Future<List<PatientRoomRes>?> getPatientRoomList() async{
    try {
      var res = await HttpUtil.get(
          Urls.getPatientRoomList, options: _tokenOptionsBkrs());
      print("这个返回的结果"+res.toString());
      return Future.value(
          (res as List).map((e) => PatientRoomRes.fromJson(e)).toList()
      );
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }


  static Future<PatientListRes?> getPatientList(int page,int pageSize,String name,String hospitalized,String patient_room) async{
    try {
      var data = {
        "page": page,
        "pageSize": pageSize,
        "name": name,
        "hospitalized": hospitalized,
        "patient_room": patient_room,
      };
      var res = await HttpUtil.postBkrs(
          Urls.getPatientList, data: data, options: _tokenOptionsBkrs());
      print("这个返回的结果"+res.toString());
      return Future.value(PatientListRes.fromJson(res));
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  static Future addPatient(String name,String sex,String age,String inpatient_number,String bed_number,String Illness_desc,String group_number,String patient_room) async{
    try {
      var data = {
        "name": name,
        "sex": sex,
        "age": age,
        "inpatient_number": inpatient_number,
        "bed_number": bed_number,
        "Illness_desc": Illness_desc,
        "group_number": group_number,
        "patient_room": patient_room,
      };
      var res = await HttpUtil.postBkrs(
          Urls.addPatient, data: data, options: _tokenOptionsBkrs());
      print("这个返回的结果"+res.toString());
      return Future.value("");
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  static Future<PatientDetailRes?> patientDetail(String patient_id) async{
    try {
      var data = {
        "patient_id": patient_id,
      };
      var res = await HttpUtil.postBkrs(
          Urls.patientDetail, data: data, options: _tokenOptionsBkrs());
      print("这个返回的结果"+res.toString());
      return Future.value(PatientDetailRes.fromJson(res));
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  static Future<List<DepartListRes>?> getDepartList() async{
    try {
      var res = await HttpUtil.get(
          Urls.departmentList);
      print("这个返回的结果"+res.toString());
      return Future.value(
          (res as List).map((e) => DepartListRes.fromJson(e)).toList()
      );
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  static Future<List<DepartFriendListRes>?> getDepartFriend(String department_id) async{
    try {

      var data;
      if(department_id == ""){
        data = {};
      }else{
        data = {
          "department_id": department_id,
        };
      }
      var res = await HttpUtil.postBkrs(
          Urls.departmentFriendList, data: data, options: _tokenOptionsBkrs());
      // print("这个返回的结果"+res.toString());
      return Future.value(
          (res as List).map((e) => DepartFriendListRes.fromJson(e)).toList()
      );
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  //更新患者详情
  static Future updatePatient(String patient_id,{String? name,
    String? avatar,
    String? sex,
    String? age,
    String? inpatient_number,
    String? bed_number,
    String? Illness_desc,
    String? patient_room
  })  async{
    try {
      //更新名字
      var data;
      if (name!=null) {
        data = {
          "patient_id":patient_id,
          "name":name,
        };
      }else if (avatar!=null) {
        data = {
          "patient_id":patient_id,
          "avatar":avatar,
        };
      }else if (sex!=null) {
        data = {
          "patient_id":patient_id,
          "sex":sex,
        };
      }else if (age!=null) {
        data = {
          "patient_id":patient_id,
          "age":age,
        };
      }else if (inpatient_number!=null) {
        data = {
          "patient_id":patient_id,
          "inpatient_number":inpatient_number,
        };
      }else if (bed_number!=null) {
        data = {
          "patient_id":patient_id,
          "bed_number":bed_number,
        };
      }else if (Illness_desc!=null) {
        data = {
          "patient_id":patient_id,
          "Illness_desc":Illness_desc,
        };
      }else if (patient_room!=null) {
        data = {
          "patient_id":patient_id,
          "patient_room":patient_room,
        };
      }
       await HttpUtil.postBkrs(
          Urls.editPatientDetail, data: data, options: _tokenOptionsBkrs());
      return Future.value("");
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }


  //通讯录相关
  // static Future getDepartList() async{
  //   try {
  //     var data = {
  //       "name": name,
  //       "sex": sex,
  //       "age": age,
  //       "inpatient_number": inpatient_number,
  //       "bed_number": bed_number,
  //       "Illness_desc": Illness_desc,
  //       "group_number": group_number,
  //     };
  //     var res = await HttpUtil.postBkrs(
  //         Urls.getYlbwList, data: data, options: _tokenOptionsBkrs());
  //     print("这个返回的结果"+res.toString());
  //     return Future.value(YlbwListBean.fromJson(res));
  //   } catch (e) {
  //     print('e:$e');
  //     return Future.error(e);
  //   }
  // }


  //添加收藏
  static Future addLike(
      String create_user_id,
      String create_user_name,
      String create_user_avatar,
      String create_time,
      content
      ) async{
    try {

      var res = await HttpUtil.postBkrs(
          Urls.addLike, data:
      {
        'data':json.encode({
          "create_user_id":create_user_id,
          "create_user_name":create_user_name,
          "create_user_avatar":create_user_avatar,
          "create_time":create_time,
          "content":content,
        })
      }
          , options: _tokenOptionsBkrs());
      print("这个添加收藏返回的结果"+res.toString());
      return Future.value(
          "收藏成功"
      );
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  //收藏列表
  static Future<CollectListRes?> getLikeList(
      String page,
      String size,
      String title,
      int type,
      ) async{
    try {
      int? realType;
      if (type == 1) {
        realType = 3;
      }else if(type == 2){
        realType = 4;
      }else if(type == 3){
        realType = 5;
      }else if(type == 4){
        realType = 2;
      }else if(type == 5){
        realType = 1;
      }else if(type ==6){
        // realType = 1;
      }else if(type == 7){
        realType = 6;
      }else if(type == 8){
        realType = 8;
      }

      var data;

      if (realType == null) {
        data =       {
          "page":page,
          "size":size,
          "title":title,
        };
      }else{
        data = {
          "page":page,
          "size":size,
          "title":title,
          "type":realType,
        };
      }

      var res = await HttpUtil.postBkrs(
          Urls.getLikeList, data: data
          , options: _tokenOptionsBkrs());
      return Future.value(
          CollectListRes.fromJson(res)
      );
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  static Future<List<CommonPartInfo>?> getWorkModules() async{
    try {
      var res = await HttpUtil.get(Urls.getWorkModules,options: _tokenOptionsBkrs());
      print("得到的结果 ${res}");
      return
        (res as List)
            .map((e) => CommonPartInfo.fromJson(e))
            .toList();
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }


  }

  static Future patientBlly(String id) async{
    try {
      var data = {
        "patient_id":id
      };
      var res = await HttpUtil.postBkrs(Urls.patientBlly,data: data,options: _tokenOptionsBkrs());
      print("得到的结果 ${res}");
      return "出院成功";
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  //归档记录
  static Future<GdjlRes?> patientGetGdRecord(String id,int pageIndex,int pageSize) async{
    try {
      var data = {
        "group_id":id,
        "page":pageIndex,
        "size":pageSize,
      };
      var res = await HttpUtil.postBkrs(Urls.patientGetGdRecord,data: data,options: _tokenOptionsBkrs());
      print("得到的结果 ${res}");
      return Future.value(
        GdjlRes.fromJson(res)
      );
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  //用户匹配
  static Future<UserMatchRes?> userMatch(String name) async{
    try {
      var data = {
        "name":name,
      };
      var res = await HttpUtil.postBkrs(Urls.userMatch,data: data,options: _tokenOptionsBkrs());
      print("得到的结果 ${res}");
      return Future.value(res==null?null:
          UserMatchRes.fromJson(res)
      );
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }


}
