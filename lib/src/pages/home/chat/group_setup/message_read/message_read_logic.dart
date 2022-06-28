import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';

class GroupMessageReadLogic extends GetxController {
  late List<String> haveReadUserIDList;
  late String groupID;
  var haveReadMemberList = <GroupMembersInfo>[].obs;
  var unreadMemberList = <GroupMembersInfo>[].obs;
  var needReadUserIDList = <String>[];
  var index = 0.obs;

  @override
  void onInit() {
    haveReadUserIDList = Get.arguments['haveReadUserIDList'];
    needReadUserIDList = Get.arguments['needReadUserIDList'];
    haveReadUserIDList.remove(OpenIM.iMManager.uid);
    groupID = Get.arguments['groupID'];
    _queryMembers();
    super.onInit();
  }

  void _queryMembers() async {
    var list = await OpenIM.iMManager.groupManager.getGroupMemberList(
      groupId: groupID,
    );
    list.forEach((element) {
      if (element.userID != OpenIM.iMManager.uid) {
        if (haveReadUserIDList.contains(element.userID)) {
          haveReadMemberList.add(element);
        } else {
          if (needReadUserIDList.isEmpty) {
            unreadMemberList.add(element);
          } else {
            if (needReadUserIDList.contains(element.userID!)) {
              unreadMemberList.add(element);
            }
          }
        }
      }
    });
  }

  void switchTab(i) => index.value = i;

  List<GroupMembersInfo> _getList() =>
      index.value == 0 ? haveReadMemberList : unreadMemberList;

  int get length => _getList().length;

  GroupMembersInfo getInfo(index) => _getList().elementAt(index);
}
