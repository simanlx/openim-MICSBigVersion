import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_member_manager/member_list/member_list_logic.dart';
import 'package:mics_big_version/src/pages/select_contacts/select_contacts_logic.dart';
import '../models/contacts_info.dart';
import '../models/zskjs/YlbwListBean.dart';
import '../models/zskjs/ZskjsListContentListItem.dart';
import '../pages/add_friend/search/search_logic.dart';
import '../widgets/qr_view.dart';
import 'app_pages.dart';

class AppNavigator {
  static void backLogin() {
    Get.until((route) => Get.currentRoute == AppRoutes.LOGIN);
  }

  static void startLogin() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  static void startRegister(String way) {
    Get.toNamed(AppRoutes.REGISTER, arguments: {'registerWay': way});
  }

  static void startRegisterVerifyPhoneOrEmail({
    String? email,
    String? phoneNumber,
    String? areaCode,
    required int usedFor,
  }) {
    Get.toNamed(AppRoutes.REGISTER_VERIFY_PHONE, arguments: {
      'phoneNumber': phoneNumber,
      'areaCode': areaCode,
      'email': email,
      'usedFor': usedFor,
    });
  }

  /// [usedFor] 1：注册，2：重置密码
  static void startSetupPwd({
    String? phoneNumber,
    String? areaCode,
    String? email,
    required String verifyCode,
    required int usedFor,
  }) {
    Get.toNamed(AppRoutes.SETUP_PWD, arguments: {
      'phoneNumber': phoneNumber,
      'areaCode': areaCode,
      'email': email,
      'verifyCode': verifyCode,
      'usedFor': usedFor,
    });
  }

  static void startRegisterSetupSelfInfo({
    String? phoneNumber,
    String? areaCode,
    String? email,
    required String verifyCode,
    required String password,
  }) {
    Get.toNamed(AppRoutes.REGISTER_SETUP_SELF_INFO, arguments: {
      'phoneNumber': phoneNumber,
      'areaCode': areaCode,
      'email': email,
      'verifyCode': verifyCode,
      'password': password,
    });
  }

  static void startMain() {
    Get.offAllNamed(AppRoutes.HOME);
  }

  static void startBackMain() {
    Get.until((route) => Get.currentRoute == AppRoutes.HOME);
  }

  static Future<T?>? startChat<T>({
    int type = 0,
    String? uid,
    String? gid,
    String? name,
    String? icon,
    String? draftText,
    bool isValidChat = true,
    ConversationInfo? conversationInfo,
    Message? searchMessage,
  }) async {
    var arguments = {
      'uid': uid,
      'gid': gid,
      'name': name,
      'icon': icon,
      'draftText': draftText,
      'isValidChat': isValidChat,
      'conversationInfo': conversationInfo,
      'searchMessage': searchMessage,
    };
    // var result = await navigator?.push(
    //   CustomMaterialPageRoute(
    //     settings: RouteSettings(name: AppRoutes.CHAT, arguments: arguments),
    //     builder: (_) {
    //       return GetBuilder(
    //         init: ChatLogic(),
    //         builder: (controller) => ChatPage(),
    //       );
    //     },
    //   ),
    // );
    // return result;
    switch (type) {
      case 0:
        return Get.toNamed(AppRoutes.CHAT, arguments: arguments);
      case 1:
        return Get.offNamedUntil(
          AppRoutes.CHAT,
          (route) => route.settings.name == AppRoutes.HOME,
          arguments: arguments,
        );
      default:
        return Get.offNamed(AppRoutes.CHAT, arguments: arguments);
    }
  }

  static void startChatSetup({
    required String uid,
    required String name,
    required String icon,
  }) {
    Get.toNamed(AppRoutes.CHAT_SETUP, arguments: {
      'uid': uid,
      'name': name,
      'icon': icon,
    });
  }

  static void startGroupSetup({
    required String gid,
    required String name,
    required String icon,
  }) {
    Get.toNamed(AppRoutes.GROUP_SETUP, arguments: {
      'gid': gid,
      'name': name,
      'icon': icon,
    });
  }

  static Future<T?>? startSelectContacts<T>({
    required SelAction action,
    List<String>? defaultCheckedUidList,
    List<String>? excludeUidList,
    List<ContactsInfo>? checkedList,
  }) {
    return Get.toNamed<T>(
      AppRoutes.SELECT_CONTACTS,
      arguments: {
        'action': action,
        'defaultCheckedUidList': defaultCheckedUidList,
        'excludeUidList': excludeUidList,
        'checkedList': checkedList,
      },
    );
  }

  static void startAddContacts() {
    Get.toNamed(AppRoutes.ADD_CONTACTS);
  }

  static void startFriendApplicationList() {
    Get.toNamed(AppRoutes.NEW_FRIEND_APPLICATION);
  }

  static void startFriendList() {
    Get.toNamed(AppRoutes.FRIEND_LIST);
  }

  static void startGroupList() {
    Get.toNamed(AppRoutes.GROUP_LIST);
  }

  static Future<T?>? startFriendInfo<T>({
    required UserInfo userInfo,
    String? groupID,
    bool showMuteFunction = false,
  }) {
    return Get.toNamed(AppRoutes.FRIEND_INFO, arguments: {
      'userInfo': userInfo,
      'groupID': groupID,
      'showMuteFunction': showMuteFunction,
    });
  }

  /// 扫一扫进去
  static Future<T?>? startFriendInfoFromScan<T>({
    required UserInfo info,
  }) {
    return Get.offAndToNamed(AppRoutes.FRIEND_INFO, arguments: {
      'userInfo': info,
      'showMuteFunction': false,
    });
  }

  static Future<T?>? startSearchAddGroup<T>({required GroupInfo info}) {
    return Get.toNamed(AppRoutes.SEARCH_ADD_GROUP, arguments: info);
  }

  static Future<T?>? startSearchAddGroupFromScan<T>({required GroupInfo info}) {
    return Get.offAndToNamed(AppRoutes.SEARCH_ADD_GROUP, arguments: info);
  }

  static void startFriendIDCode({required UserInfo info}) {
    Get.toNamed(AppRoutes.FRIEND_ID_CODE, arguments: info);
  }

  static void startSendFriendRequest({required UserInfo info}) {
    Get.toNamed(AppRoutes.SEND_FRIEND_REQUEST, arguments: info);
  }

  static Future<T?>? startSetFriendRemarksName<T>({required UserInfo info}) {
    return Get.toNamed(AppRoutes.FRIEND_REMARK, arguments: info);
  }

  static void startAddFriend() {
    Get.toNamed(AppRoutes.ADD_FRIEND);
  }

  static void startAddFriendBySearch() {
    Get.toNamed(
      AppRoutes.ADD_FRIEND_BY_SEARCH,
      arguments: {'searchType': SearchType.user},
    );
  }

  static void startAddGroupBySearch() {
    Get.toNamed(
      AppRoutes.ADD_FRIEND_BY_SEARCH,
      arguments: {'searchType': SearchType.group},
    );
  }

  static Future<T?>? startAcceptFriendRequest<T>(
      {required FriendApplicationInfo apply}) {
    return Get.toNamed(
      AppRoutes.ACCEPT_FRIEND_REQUEST,
      arguments: apply,
    );
  }

  static void startMyQrcode() {
    Get.toNamed(AppRoutes.MY_QRCODE);
  }

  static void startMyInfo() {
    Get.toNamed(AppRoutes.MY_INFO /*, arguments: userInfo*/);
  }

  static void startMyID() {
    Get.toNamed(AppRoutes.MY_ID);
  }

  static void startSetUserName() {
    Get.toNamed(AppRoutes.SETUP_USER_NAME);
  }

  // static void startCall({dynamic data}) {
  //   Get.toNamed(AppRoutes.CALL, arguments: data);
  // }

  static void startCreateGroupInChatSetup(
      {required List<ContactsInfo> members}) {
    Get.offNamed(
      AppRoutes.CREATE_GROUP_IN_CHAT_SETUP,
      arguments: {'members': members},
    );
  }

  static void startGroupNameSet({required GroupInfo info}) {
    Get.toNamed(AppRoutes.GROUP_NAME_SETUP, arguments: info);
  }

  static void startModifyMyNicknameInGroup({
    required GroupInfo groupInfo,
    required GroupMembersInfo membersInfo,
  }) {
    Get.toNamed(AppRoutes.MY_GROUP_NICKNAME, arguments: {
      'groupInfo': groupInfo,
      'membersInfo': membersInfo,
    });
  }

  static void startEditAnnouncement({required GroupInfo info}) {
    Get.toNamed(AppRoutes.GROUP_ANNOUNCEMENT_SETUP, arguments: info);
  }

  static void startViewGroupQrcode({required GroupInfo info}) {
    Get.toNamed(AppRoutes.GROUP_QRCODE, arguments: info);
  }

  static Future<T?>? startGroupMemberManager<T>({required GroupInfo info}) {
    return Get.toNamed(
      AppRoutes.GROUP_MEMBER_MANAGER,
      arguments: info,
    );
  }

  static Future<T?>? startGroupMemberList<T>({
    required String gid,
    required OpAction action,
    List<GroupMembersInfo>? list,
    List<String>? defaultCheckedUidList,
  }) {
    return Get.toNamed(
      AppRoutes.GROUP_MEMBER_LIST,
      arguments: {
        'gid': gid,
        'list': list,
        'action': action,
        'defaultCheckedUidList': defaultCheckedUidList,
      },
    );
  }

  static void startViewGroupId({required GroupInfo info}) {
    Get.toNamed(AppRoutes.GROUP_ID, arguments: info);
  }

  static void startJoinGroup() {
    Get.toNamed(AppRoutes.JOIN_GROUP);
  }

  static void startAccountSetup() {
    Get.toNamed(AppRoutes.ACCOUNT_SETUP);
  }

  static void startAboutUs() {
    Get.toNamed(AppRoutes.ABOUT_US);
  }

  static void startAddMyMethod() {
    Get.toNamed(AppRoutes.ADD_MY_METHOD);
  }

  static void startBlacklist() {
    Get.toNamed(AppRoutes.BLACKLIST);
  }

  static Future<T?>? startSearchFriend<T>({required List<ContactsInfo> list}) {
    return Get.toNamed(AppRoutes.SEARCH_FRIEND, arguments: list);
  }

  static Future<T?>? startSearchGroup<T>({required List<GroupInfo> list}) {
    return Get.toNamed(AppRoutes.SEARCH_GROUP, arguments: list);
  }

  static Future<T?>? startSearchMember<T>(
      {required List<GroupMembersInfo> list}) {
    return Get.toNamed(AppRoutes.SEARCH_MEMBER, arguments: list);
  }

  static void startCallRecords() {
    Get.toNamed(AppRoutes.CALL_RECORDS);
  }

  static void startScanQrcode() {
    Get.to(() => QrcodeView());
  }

  static Future<T?>? startLanguageSetup<T>() {
    return Get.toNamed(AppRoutes.LANGUAGE_SETUP);
  }

  static void createGroup() => startSelectContacts(
        action: SelAction.CRATE_GROUP,
        defaultCheckedUidList: [OpenIM.iMManager.uid],
      );

  static void applyEnterGroup(GroupInfo info) {
    Get.toNamed(AppRoutes.APPLY_ENTER_GROUP, arguments: info);
  }

  static void startGroupApplication() {
    Get.toNamed(AppRoutes.GROUP_APPLICATION);
  }

  static Future<T?>? startHandleGroupApplication<T>(
    GroupInfo gInfo,
    GroupApplicationInfo aInfo,
  ) {
    return Get.toNamed(AppRoutes.HANDLE_GROUP_APPLICATION, arguments: {
      'aInfo': aInfo,
      'gInfo': gInfo,
    });
  }

  static Future<T?>? startOrganization<T>({
    bool isMultiModel = false,
  }) {
    return Get.toNamed(
      AppRoutes.ORGANIZATION,
      arguments: {
        'isMultiModel': isMultiModel,
      },
    );
  }

  static void startForgetPassword({String accountType = "phone"}) {
    Get.toNamed(AppRoutes.FORGET_PASSWORD,
        arguments: {"accountType": accountType});
  }

  static void startEmojiManage() {
    Get.toNamed(AppRoutes.EMOJI_MANAGE);
  }

  static void startFontSizeSetup() {
    Get.toNamed(AppRoutes.FONT_SIZE);
  }

  static void startTag() {
    Get.toNamed(AppRoutes.TAG);
  }

  static Future<T?>? startTagNew<T>() {
    return Get.toNamed(AppRoutes.TAG_NEW);
  }

  static void startGroupHaveRead({
    required List<String> haveReadUserIDList,
    required List<String> needReadUserIDList,
    required String groupID,
  }) {
    Get.toNamed(AppRoutes.GROUP_HAVE_READ, arguments: {
      'haveReadUserIDList': haveReadUserIDList,
      'needReadUserIDList': needReadUserIDList,
      'groupID': groupID,
    });
  }

  static void startMessageSearch({required ConversationInfo info}) {
    Get.toNamed(AppRoutes.SEARCH_HISTORY_MESSAGE, arguments: info);
  }

  static void startSearchFile({required ConversationInfo info}) {
    Get.toNamed(AppRoutes.SEARCH_FILE, arguments: info);
  }

  /// [type] 0:picture 1:video
  static void startSearchPicture({
    required ConversationInfo info,
    required int type,
  }) {
    Get.toNamed(AppRoutes.SEARCH_PICTURE, arguments: {
      'info': info,
      'type': type,
    });
  }

  static void startSetGroupMemberMute({
    required String groupID,
    required String userID,
  }) {
    Get.toNamed(AppRoutes.SET_MEMBER_MUTE, arguments: {
      'groupID': groupID,
      'userID': userID,
    });
  }

  static startOANotificationList({
    required ConversationInfo info,
  }) {
    return Get.toNamed(AppRoutes.OA_NOTIFICATION_LIST, arguments: info);
  }

  static startSetChatBackground() {
    return Get.toNamed(AppRoutes.SET_BACKGROUND_IMAGE);
  }

  static startLoginPc({required String args}) {
    return Get.offAndToNamed(AppRoutes.LOGIN_PC, arguments: args);
  }

  static startGlobalSearch() {
    return Get.toNamed(AppRoutes.GLOBAL_SEARCH);
  }

  static startHzgl() {
    return Get.toNamed(AppRoutes.PATIENT_MANAGE);
  }

  //去我的收藏
  static startWdsc() {
    return Get.toNamed(AppRoutes.MY_COLLECTION);
  }

  //去医疗备忘
  static startYlbw() {
    return Get.toNamed(AppRoutes.MEDICAL_MEMO);
  }

  //去系统通知
  static startXttz() {
    return Get.toNamed(AppRoutes.SYSTEM_NOTICE_LIST);
  }

  static startExpandChatHistory({
    required SearchResultItems searchResultItems,
    required String searchKey,
  }) {
    return Get.toNamed(
      AppRoutes.GLOBAL_SEARCH_CHAT_HISTORY,
      arguments: {
        'items': searchResultItems,
        'searchKey': searchKey,
      },
    );
  }

  static startPreviewChatHistory({
    required String conversationID,
    required String showName,
    String? faceURL,
    required Message searchMessage,
  }) {
    return Get.toNamed(
      AppRoutes.PREVIEW_CHAT_HISTORY,
      arguments: {
        'conversationID': conversationID,
        'showName': showName,
        'faceURL': faceURL,
        'searchMessage': searchMessage,
      },
    );
  }

  //跳知识库检索
  static void startZskjs() {
    Get.toNamed(AppRoutes.KNOWLEDGE_BASE_SEARCH);
  }

  //跳知识库检索
  static void startZskjsDetail({required ZskjsListContentListItemData data}) {
    Get.toNamed(AppRoutes.KNOWLEDGE_BASE_SEARCH_DETAIL,arguments: {
      'data':data
    });
  }

  //跳医疗备忘详情
  static void startYlbwDetail({YlbwListBeanData? item}) {
    Get.toNamed(AppRoutes.MEDICAL_MEMO_DETAIL,arguments: {"item":item});
  }

  static void startDepartFriendList(String id,String name) {
    Get.toNamed(AppRoutes.DEPART_FRIEND_LIST,arguments: {"departmentId":id,"departmentName":name});
  }
}
