import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/core/controller/im_controller.dart';
import 'package:mics_big_version/src/models/zskjs/DepartListRes.dart';
import 'package:mics_big_version/src/pages/home/contacts/department_friend_list/depart_list_friend_logic.dart';
import 'package:mics_big_version/src/pages/home/contacts/frequent_contacts/frequent_contacts_logic.dart';
import 'package:mics_big_version/src/pages/home/contacts/frequent_contacts/frequent_contacts_view.dart';
import 'package:mics_big_version/src/pages/home/contacts/friend_list/friend_list_view.dart';
import 'package:mics_big_version/src/routes/app_navigator.dart';
import 'package:mics_big_version/src/utils/data_persistence.dart';
import 'department_friend_list/depart_list_friend_view.dart';
import 'friend_list/friend_list_logic.dart';

class ContactsLogic extends GetxController {

  var imLogic = Get.find<IMController>();
  var departList = <DepartListRes>[].obs;
  var frequentContacts = <UserInfo>[].obs;
  var onlineStatusDesc = <String, String>{}.obs;
  var stackList = <Widget>[].obs;


  @override
  void onInit() {
    imLogic.conversationChangedSubject.listen((list) {
      var uList = <UserInfo>[];
      list.forEach((e) {
        if (e.isSingleChat) {
          var u = UserInfo(
            userID: e.userID!,
            nickname: e.showName,
            faceURL: e.faceURL,
          );
          uList.add(u);
        }
      });
      if (uList.isNotEmpty) {
        // if (uList.length > 15) {
        //   frequentContacts.assignAll(uList.take(15));
        // } else {
        //   frequentContacts.assignAll(uList);
        // }
        // frequentContacts.assignAll(uList);
        // frequentContacts.insertAll(0, uList);
        // frequentContacts.refresh();

        uList.forEach((element) {
          frequentContacts.remove(element);
        });
        frequentContacts.insertAll(0, uList);
        putFrequentContacts();
      }
    });

    imLogic.friendInfoChangedSubject.listen((value) {
      try {
        var u = frequentContacts.firstWhere((e) => e.userID == value.userID);
        u.nickname = value.nickname;
        u.faceURL = value.faceURL;
        u.remark = value.remark;
        u.phoneNumber = value.phoneNumber;
        frequentContacts.refresh();
      } catch (e) {}
    });

    imLogic.friendDelSubject.listen((user) {
      frequentContacts.removeWhere((e) => e.userID == user.userID);
      putFrequentContacts();
    });


    super.onInit();
  }

  void viewContactsInfo(info) {
    AppNavigator.startFriendInfo(userInfo: info);
  }

  bool removeFrequentContacts(UserInfo info) {
    bool suc = frequentContacts.remove(info);
    putFrequentContacts();
    return suc;
  }


  @override
  void onReady() {
    getFrequentContacts();
    getBkrsFriends();
    stackList.clear();
    Get.put(FrequentContactsLogic());
    var frequentFriend = new FrequentContactsPage();
    stackList.add(frequentFriend);
    super.onReady();
  }

  void putFrequentContacts() {
    var uidList = frequentContacts.map((e) => e.userID!);
    if (uidList.length > 15) {
      DataPersistence.putFrequentContacts(uidList.take(15).toList());
    } else {
      DataPersistence.putFrequentContacts(uidList.toList());
    }
    // DataPersistence.putFrequentContacts(uidList.toList());
  }

  void getFrequentContacts() async {
    var uidList = DataPersistence.getFrequentContacts();
    if (uidList != null && uidList.isNotEmpty) {
      var list = await OpenIM.iMManager.friendshipManager.getFriendsInfo(
        uidList: uidList,
      );
      frequentContacts.assignAll(list);
      // _checkOnlineStatus();
      // _startOnlineStatusTimer();
    }
  }


  void getBkrsFriends(){
    Apis.getDepartList().then((value){
      //获取
      print("获取到部门 $value");
      if (value!=null) {
        departList.clear();
        departList.addAll(value);
      }
    });
  }


  void showMyFriend() {
    clearLogic();
    stackList.clear();
    Get.put(MyFriendListLogic());
    var myFriend = new MyFriendListPage();
    stackList.add(myFriend);
  }

  void clearLogic(){
    for (var value in stackList) {
      if(value is MyFriendListPage){
        Get.delete<MyFriendListLogic>();
      }else if(value is DepartListFriendPage){
        Get.delete<DepartListFriendLogic>();
      }else if(value is FrequentContactsPage){
        Get.delete<FrequentContactsLogic>();
      }
    }
  }

  void showDepartPage(String departmentId, String departName) {
    clearLogic();
    stackList.clear();
    Get.put(DepartListFriendLogic(departmentId: departmentId,departName: departName));
    var depart = new DepartListFriendPage();
    stackList.add(depart);
  }

  //常用联系人
  void showFrequentFriend() {
    clearLogic();
    stackList.clear();
    Get.put(FrequentContactsLogic());
    var frequentFriend = new FrequentContactsPage();
    stackList.add(frequentFriend);
  }


  //朋友信息页面回去
  void friendInfoBack() {
    if (stackList.length == 1) {
      return;
    }
    print("stackList 长度  ${stackList.length}");
    if (stackList.length>0) {
      stackList.removeAt(stackList.length-1);
    }
  }

 // Widget currentPage() {
 //    if (stackList.length == 0) {
 //      return Container();
 //    }
 //    return stackList[stackList.length-1];
 // }

}
