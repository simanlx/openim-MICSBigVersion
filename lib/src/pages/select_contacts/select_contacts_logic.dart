import 'dart:convert';
import 'dart:developer';

import 'package:common_utils/common_utils.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/core/controller/im_controller.dart';
import 'package:mics_big_version/src/models/contacts_info.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/routes/app_navigator.dart';
import 'package:mics_big_version/src/utils/im_util.dart';
import 'package:mics_big_version/src/widgets/custom_dialog.dart';
import 'package:mics_big_version/src/widgets/custom_sure_share_dialog.dart';
import 'package:mics_big_version/src/widgets/custom_sure_share_dialog2.dart';
import 'package:mics_big_version/src/widgets/im_widget.dart';

import '../../models/zskjs/PatientDetailRes.dart';
import '../../models/zskjs/YlbwListBean.dart';

enum SelAction {
  FORWARD,
  MyFORWARD, //分享档案信息 分享医疗备忘
  CARTE,
  CRATE_GROUP,
  ADD_MEMBER,
  RECOMMEND,
  CREATE_TAG,
}

class SelectContactsLogic extends GetxController {
  var index = 0.obs;
  var contactsList = <ContactsInfo>[].obs;
  var checkedList = <ContactsInfo>[].obs;
  var defaultCheckedUidList = <String>[];
  var imController = Get.find<IMController>();
  var action;
  List<String>? excludeUidList;


  var showTitle = "".obs;
  var groupList = <GroupInfo>[].obs;
  var checkedGroupList = <GroupInfo>[].obs;


  @override
  void onInit() {
    action = Get.arguments['action'] as SelAction;
    // 排除的uid
    excludeUidList = Get.arguments['excludeUidList'];
    // 默认选中，且不能修改
    var defaultCheckedUidList = Get.arguments['defaultCheckedUidList'];
    // 已经选中的
    var checkedList = Get.arguments['checkedList'];

    if (defaultCheckedUidList is List) {
      this.defaultCheckedUidList.addAll(defaultCheckedUidList.cast());
    }
    if (checkedList is List) {
      this.checkedList.addAll(checkedList.cast());
    }

    if (action == SelAction.MyFORWARD) {
      showTitle.value = "分享";
    }else if(action == SelAction.CRATE_GROUP){
      showTitle.value = "发起群聊";
    }
    super.onInit();
  }

  bool isMultiModel() {
    return action == SelAction.CRATE_GROUP ||
        action == SelAction.ADD_MEMBER ||
        action == SelAction.MyFORWARD ||
        action == SelAction.CREATE_TAG;
  }

  void switchTab(i) {
    index.value = i;
  }

  void getFriends() {
    OpenIM.iMManager.friendshipManager
        .getFriendListMap()
        .then((list) {
          if (null != excludeUidList && excludeUidList!.isNotEmpty) {
            var l = <ContactsInfo>[];
            list.forEach((e) {
              var info = ContactsInfo.fromJson(e);
              if (!excludeUidList!.contains(info.userID)) {
                l.add(info);
              }
            });
            return l;
          }
          return list.map((e) => ContactsInfo.fromJson(e)).toList();
        })
        .then((list) => IMUtil.convertToAZList(list))
        .then((list) => contactsList.assignAll(list.cast<ContactsInfo>()));
  }


  void selectedGroups(GroupInfo info){
    if (isMultiModel()) {
      if (checkedGroupList.contains(info)) {
        checkedGroupList.remove(info);
        print("1111111111  ${checkedGroupList.length}");
      } else {
        checkedGroupList.add(info);
        print("1111111111  ${checkedGroupList.length}");
      }
      // info.isChecked = !(info.isChecked ?? false);
      checkedGroupList.refresh();
      return;
    }
  }

  void selectedContacts(ContactsInfo info) {
    if (isMultiModel()) {
      if (checkedList.contains(info)) {
        checkedList.remove(info);
      } else {
        checkedList.add(info);
      }
      // info.isChecked = !(info.isChecked ?? false);
      contactsList.refresh();
      return;
    }
    var title;
    var content;
    var url;
    var type;
    switch (action) {
      case SelAction.FORWARD:
        title = StrRes.confirmSendTo;
        content = info.getShowName();
        url = info.faceURL;
        type = DialogType.FORWARD;
        break;
      case SelAction.CARTE:
        title = StrRes.confirmSendCarte;
        type = DialogType.BASE;
        break;
      case SelAction.RECOMMEND:
        title = StrRes.confirmRecommendFriend;
        type = DialogType.BASE;
        break;
      default:
        break;
    }
    Get.dialog(CustomDialog(
      title: title,
      content: content,
      url: url,
      type: type,
    )).then((confirm) {
      if (confirm == true) {
        Get.back(
          result: {
            "userID": info.userID,
            "nickname": info.getShowName(),
            "faceURL": info.faceURL,
          },
        );
      }
    });
  }

  // void _search(String text) {
  //   if (ObjectUtil.isEmpty(text)) {
  //     _handleList(originList);
  //   } else {
  //     List<Languages> list = originList.where((v) {
  //       return v.name.toLowerCase().contains(text.toLowerCase());
  //     }).toList();
  //     _handleList(list);
  //   }
  // }

  void removeContacts(ContactsInfo info) {
    checkedList.remove(info);
    contactsList.refresh();
  }

  void removeGroup(GroupInfo info) {
    checkedGroupList.remove(info);
    groupList.refresh();
  }

  void confirmSelected() {
    if (action == SelAction.MyFORWARD) {
      if (checkedList.isEmpty && checkedGroupList.isEmpty) return;

      //转发 分享 我们自己的    医疗备忘 患者详情
      var patientItem = Get.arguments['patientItem'] as PatientDetailRes?;
      var ylbwItem = Get.arguments['ylbwItem'] as YlbwListBeanData?;
      var message = Get.arguments['message'];
      if (patientItem!=null) {
        handleSharePatient();
      }else if(ylbwItem!=null) {
        handleShareYlbw();
      }else if(message !=null){
        handleOtherMsg(message);
      }
    }else{
      if (checkedList.isEmpty) return;
      // 创建群组
      if (action == SelAction.CRATE_GROUP) {
        checkedList.addAll(
          contactsList.where((e) => defaultCheckedUidList.contains(e.userID)),
        );
        AppNavigator.startCreateGroupInChatSetup(members: checkedList.value);
      } else if (action == SelAction.ADD_MEMBER) {
        // 添加成员
        Get.back(result: checkedList.value);
      } else if (action == SelAction.CREATE_TAG) {
        // 添加成员
        // Get.until((route) => route.route == AppRoutes.TAG_NEW);
        // navigator?.popUntil(ModalRoute.withName(AppRoutes.TAG_NEW));
        // Get.offNamedUntil(
        //   AppRoutes.TAG_NEW,
        //   ModalRoute.withName(AppRoutes.TAG_NEW),
        //   arguments: checkedList.value,
        // );
        Get.back(result: checkedList.value);
      }
    }

  }

  void handleShareYlbw(){
    var ylbwItem = Get.arguments['ylbwItem'] as YlbwListBeanData;
    var sharePath = Get.arguments['sharePath'];
    var stringBuffer = StringBuffer();
    for (var value1 in ylbwItem.noteData!) {
      if (value1.type == "text") {
        stringBuffer.write(value1.data);
      }
    }
    Get.dialog(CustomSureShareDialog(
      checkList: checkedList,
      checkGroupList: checkedGroupList.value,
      type: CustomSureShareDialogType.YLBW,
      title: ylbwItem.title??"",
      content: stringBuffer.toString(),
      timeStr: DateUtil.formatDateMs(DateTime.now().millisecondsSinceEpoch),
    )).then((confirm) async{
      if (confirm == true) {
        var data = {
          "type":"note",
          "title":"${ylbwItem.title})",
          "fromId":ylbwItem.id,
          "fromUID": imController.userInfo.value.userID,
          "time":DateTime.now().millisecondsSinceEpoch,
          "content":ylbwItem
        };
        var description = {
          "title":"医疗备忘"
        };

        for(var ii in  checkedList.value){
          var message = await OpenIM.iMManager.messageManager.createCustomMessage(
            data: json.encode(data),
            extension: "",
            description: json.encode(description),
          );
          log('医疗备忘分享 send : ${json.encode(message)}');
          OpenIM.iMManager.messageManager
              .sendMessage(
            message: message,
            userID: ii.userID,
            groupID: "",
            offlinePushInfo: OfflinePushInfo(
              title: "你收到了一条消息",
              desc: "",
              iOSBadgeCount: true,
              iOSPushSound: '+1',
            ),
          )
              .then((value){
            IMWidget.showToast("分享成功");
          })
              .catchError((e){

          })
              .whenComplete((){

          });
        }

        for(var ii in checkedGroupList.value){
          var message = await OpenIM.iMManager.messageManager.createCustomMessage(
            data: json.encode(data),
            extension: "",
            description: json.encode(description),
          );
          log('医疗备忘分享 send : ${json.encode(message)}');
          OpenIM.iMManager.messageManager
              .sendMessage(
            message: message,
            userID: "",
            groupID: ii.groupID,
            offlinePushInfo: OfflinePushInfo(
              title: "你收到了一条消息",
              desc: "",
              iOSBadgeCount: true,
              iOSPushSound: '+1',
            ),
          )
              .then((value){
            IMWidget.showToast("分享成功");
          })
              .catchError((e){

          })
              .whenComplete((){

          });
        }
        Get.until((route) => Get.currentRoute == sharePath);
      }
    });
  }


  void handleOtherMsg(message) {
    var sharePath = Get.arguments['sharePath'];
    Get.dialog(CustomSureShareDialog2(
      checkList: checkedList,
      checkGroupList: checkedGroupList.value,
      type: CustomSureShareDialogType.OTHER,
      title: "",
      content: "",
      timeStr: DateUtil.formatDateMs(DateTime.now().millisecondsSinceEpoch),
    )).then((value) async{
      for(var ii in  checkedList.value){
        var messageAfter = await OpenIM.iMManager.messageManager.createForwardMessage(
          message: message
        );
        OpenIM.iMManager.messageManager
            .sendMessage(
          message: messageAfter,
          userID: ii.userID,
          groupID: "",
          offlinePushInfo: OfflinePushInfo(
            title: "你收到了一条消息",
            desc: "",
            iOSBadgeCount: true,
            iOSPushSound: '+1',
          ),
        )
            .then((value){
            IMWidget.showToast("分享成功");
        })
            .catchError((e){

        })
            .whenComplete((){

        });
      }
      for(var ii in checkedGroupList.value){
        var messageAfter = await OpenIM.iMManager.messageManager.createForwardMessage(
            message: message
        );
        OpenIM.iMManager.messageManager
            .sendMessage(
          message: messageAfter,
          userID: "",
          groupID: ii.groupID,
          offlinePushInfo: OfflinePushInfo(
            title: "你收到了一条消息",
            desc: "",
            iOSBadgeCount: true,
            iOSPushSound: '+1',
          ),
        )
            .then((value){
          IMWidget.showToast("分享成功");
        })
            .catchError((e){

        })
            .whenComplete((){

        });
      }
      Get.until((route) => Get.currentRoute == sharePath);
    });
  }

  void handleSharePatient(){
    String title = "";
    String content = "";
    var patientItem = Get.arguments['patientItem'] as PatientDetailRes?;
    var sharePath = Get.arguments['sharePath'];
    if (patientItem!=null) {
      title = "${patientItem.name} (${patientItem.sex} ${patientItem.patientRoomName})";
    }
    // patie
    Get.dialog(CustomSureShareDialog(
      checkList: checkedList,
      checkGroupList: checkedGroupList.value,
      type: CustomSureShareDialogType.HZXQ,
      title: title,
      content: content,
      timeStr: DateUtil.formatDateMs(DateTime.now().millisecondsSinceEpoch),
    )).then((confirm) async{
      if (confirm == true) {
        //   {
        //    "data":"{\"type\":\"patient\",\"title\":\"\患\者\档\案: \逻\辑\",\"fromId\":29,\"fromUID\":\"15375547102\",\"time\":\"1653890209290\",\"content\":\"{\\\"name\\\":\\\"\\\逻\\\辑\\\",\\\"gender\\\":\\\"\\\女\\\",\\\"patientRoom\\\":\\\"22N45\\\",\\\"patientID\\\":1,\\\"age\\\":50,\\\"inpatientNumber\\\":\\\"123979324\\\",\\\"illnessDesc\\\":\\\"\\\病\\\情\\\简\\\介\\\"}\"}",
        //    "description":"{\"title\":\"\患\者\档\案: \逻\辑\"}"
        // }
        var data = {
          "type":"patient",
          "title":"${patientItem?.name} (${patientItem?.sex} ${patientItem?.patientRoomName})",
          "fromId":patientItem?.id,
          "fromUID": imController.userInfo.value.userID,
          "time":DateTime.now().millisecondsSinceEpoch,
          "content":patientItem
        };
        var description = {
          "title":"患者档案"
        };

        for(var ii in  checkedList.value){
          var message = await OpenIM.iMManager.messageManager.createCustomMessage(
            data: json.encode(data),
            extension: "",
            description: json.encode(description),
          );
          log('患者档案分享 send : ${json.encode(message)}');
          OpenIM.iMManager.messageManager
              .sendMessage(
            message: message,
            userID: ii.userID,
            groupID: "",
            offlinePushInfo: OfflinePushInfo(
              title: "你收到了一条消息",
              desc: "",
              iOSBadgeCount: true,
              iOSPushSound: '+1',
            ),
          )
              .then((value){
            IMWidget.showToast("分享成功");
          })
              .catchError((e){

          })
              .whenComplete((){

          });
        }

        for(var ii in checkedGroupList.value){
          var message = await OpenIM.iMManager.messageManager.createCustomMessage(
            data: json.encode(data),
            extension: "",
            description: json.encode(description),
          );
          log('患者档案分享 send : ${json.encode(message)}');
          OpenIM.iMManager.messageManager
              .sendMessage(
            message: message,
            userID: "",
            groupID: ii.groupID,
            offlinePushInfo: OfflinePushInfo(
              title: "你收到了一条消息",
              desc: "",
              iOSBadgeCount: true,
              iOSPushSound: '+1',
            ),
          )
              .then((value){
            IMWidget.showToast("分享成功");
          })
              .catchError((e){

          })
              .whenComplete((){

          });
        }
        Get.until((route) => Get.currentRoute == sharePath);
      }
    });
  }

  @override
  void onReady() {
    getFriends();
    getGroups();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getGroups() {
    //群聊相关
    OpenIM.iMManager.groupManager.getJoinedGroupList().then((value){
      groupList.assignAll(value);
    });
  }
}
