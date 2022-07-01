import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/add_friend/search/search_binding.dart';
import 'package:mics_big_version/src/pages/add_friend/search/search_view.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/background_image/background_image_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/background_image/background_image_view.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/chat_setup_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/chat_setup_view.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/emoji_manage/emoji_manage_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/emoji_manage/emoji_manage_view.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/font_size/font_size_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/font_size/font_size_view.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/search_history_message/file/file_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/search_history_message/file/file_view.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/search_history_message/picture/picture_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/search_history_message/picture/picture_view.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/search_history_message/preview_message/preview_message_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/search_history_message/preview_message/preview_message_view.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/search_history_message/search_history_message_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/chat_setup/search_history_message/search_history_message_view.dart';
import 'package:mics_big_version/src/pages/home/chat/create_group/create_group_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/create_group/create_group_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/announcement_setup/announcement_setup_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/announcement_setup/announcement_setup_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_member_manager/group_member_manager_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_member_manager/group_member_manager_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_member_manager/member_list/member_list_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_member_manager/member_list/member_list_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_member_manager/search_member/search_member_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_member_manager/search_member/search_member_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_setup_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/group_setup_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/id/id_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/id/id_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/message_read/message_read_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/message_read/message_read_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/my_group_nickname/my_group_nickname_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/my_group_nickname/my_group_nickname_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/name_setup/name_setup_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/name_setup/name_setup_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/qrcode/qrcode_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/qrcode/qrcode_view.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/set_member_mute/set_member_mute_binding.dart';
import 'package:mics_big_version/src/pages/home/chat/group_setup/set_member_mute/set_member_mute_view.dart';
import 'package:mics_big_version/src/pages/home/contacts/group_application/handle_application/handle_application_binding.dart';
import 'package:mics_big_version/src/pages/home/contacts/group_application/handle_application/handle_application_view.dart';
import 'package:mics_big_version/src/pages/home/contacts/group_list/search_group/search_group_binding.dart';
import 'package:mics_big_version/src/pages/home/contacts/group_list/search_group/search_group_view.dart';
import 'package:mics_big_version/src/pages/home/contacts/tag_group/new/new_tag_group_binding.dart';
import 'package:mics_big_version/src/pages/home/contacts/tag_group/new/new_tag_group_view.dart';
import 'package:mics_big_version/src/pages/home/contacts/tag_group/tag_group_binding.dart';
import 'package:mics_big_version/src/pages/home/contacts/tag_group/tag_group_view.dart';
import 'package:mics_big_version/src/pages/select_contacts/select_contacts_binding.dart';
import 'package:mics_big_version/src/pages/select_contacts/select_contacts_view.dart';
import 'package:mics_big_version/src/pages/webview/zhp_webview/zhp_webview_binding.dart';
import 'package:mics_big_version/src/pages/webview/zhp_webview/zhp_webview_view.dart';
import '../pages/add_friend/send_friend_request/send_friend_request_binding.dart';
import '../pages/add_friend/send_friend_request/send_friend_request_view.dart';
import '../pages/home/contacts/friend_info/friend_info_binding.dart';
import '../pages/home/contacts/friend_info/friend_info_view.dart';
import '../pages/home/contacts/friend_info/id_code/id_code_binding.dart';
import '../pages/home/contacts/friend_info/id_code/id_code_view.dart';
import '../pages/home/contacts/friend_info/remark/remark_binding.dart';
import '../pages/home/contacts/friend_info/remark/remark_view.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/login/login_binding.dart';
import '../pages/login/login_view.dart';
import '../pages/splash/splash_binding.dart';
import '../pages/splash/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.REGISTER,
    //   page: () => RegisterPage(),
    //   binding: RegisterBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.REGISTER_VERIFY_PHONE,
    //   page: () => VerifyPhonePage(),
    //   binding: VerifyPhoneBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.SETUP_PWD,
    //   page: () => SetupPwdPage(),
    //   binding: SetupPwdBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.REGISTER_SETUP_SELF_INFO,
    //   page: () => SetupSelfInfoPage(),
    //   binding: SetupSelfInfoBinding(),
    // ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    // // GetPage(
    // //   name: AppRoutes.CONVERSATION,
    // //   page: () => ConversationPage(),
    // //   binding: ConversationBinding(),
    // // ),
    // GetPage(
    //   name: AppRoutes.CHAT,
    //   page: () => ChatPage(),
    //   binding: ChatBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.CHAT2,
    //   page: () => ChatPage2(),
    //   binding: ChatBinding2(),
    // ),
    GetPage(
      name: AppRoutes.CHAT_SETUP,
      page: () => ChatSetupPage(),
      binding: ChatSetupBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.SELECT_CONTACTS_BY_GROUP,
    //   page: () => SelectByGroupMemberPage(),
    //   binding: SelectByGroupMemberBinding(),
    // ),
    GetPage(
      name: AppRoutes.SELECT_CONTACTS,
      page: () => SelectContactsPage(),
      binding: SelectContactsBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.ADD_CONTACTS,
    //   page: () => AddContactsPage(),
    //   binding: AddContactsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.NEW_FRIEND_APPLICATION,
    //   page: () => NewFriendPage(),
    //   binding: NewFriendBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.FRIEND_LIST,
    //   page: () => MyFriendListPage(),
    //   binding: MyFriendListBinding(),
    // ),
    GetPage(
      name: AppRoutes.FRIEND_INFO,
      page: () => FriendInfoPage(),
      binding: FriendInfoBinding(),
    ),
    GetPage(
      name: AppRoutes.FRIEND_ID_CODE,
      page: () => FriendIdCodePage(),
      binding: FriendIdCodeBinding(),
    ),
    GetPage(
      name: AppRoutes.FRIEND_REMARK,
      page: () => FriendRemarkPage(),
      binding: FriendRemarkBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.ADD_FRIEND,
    //   page: () => AddFriendPage(),
    //   binding: AddFriendBinding(),
    // ),
    GetPage(
      name: AppRoutes.ADD_FRIEND_BY_SEARCH,
      page: () => AddFriendBySearchPage(),
      binding: AddFriendBySearchBinding(),
    ),
    GetPage(
      name: AppRoutes.SEND_FRIEND_REQUEST,
      page: () => SendFriendRequestPage(),
      binding: SendFriendRequestBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.ACCEPT_FRIEND_REQUEST,
    //   page: () => AcceptFriendRequestPage(),
    //   binding: AcceptFriendRequestBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.MY_QRCODE,
    //   page: () => MyQrcodePage(),
    //   binding: MyQrcodeBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.MY_INFO,
    //   page: () => MyInfoPage(),
    //   binding: MyInfoBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.SETUP_USER_NAME,
    //   page: () => SetupUserNamePage(),
    //   binding: SetupUserNameBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.MY_ID,
    //   page: () => MyIDPage(),
    //   binding: MyIDBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.CALL,
    //   page: () => CallPage(),
    //   binding: CallBinding(),
    // ),
    GetPage(
      name: AppRoutes.CREATE_GROUP_IN_CHAT_SETUP,
      page: () => CreateGroupInChatSetupPage(),
      binding: CreateGroupInChatSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.GROUP_SETUP,
      page: () => GroupSetupPage(),
      binding: GroupSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.GROUP_NAME_SETUP,
      page: () => GroupNameSetupPage(),
      binding: GroupNameSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.GROUP_ANNOUNCEMENT_SETUP,
      page: () => GroupAnnouncementSetupPage(),
      binding: GroupAnnouncementSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.GROUP_QRCODE,
      page: () => GroupQrcodePage(),
      binding: GroupQrcodeBinding(),
    ),
    GetPage(
      name: AppRoutes.GROUP_ID,
      page: () => GroupIDPage(),
      binding: GroupIDBinding(),
    ),
    GetPage(
      name: AppRoutes.MY_GROUP_NICKNAME,
      page: () => MyGroupNicknamePage(),
      binding: MyGroupNicknameBinding(),
    ),
    GetPage(
      name: AppRoutes.GROUP_MEMBER_MANAGER,
      page: () => GroupMemberManagerPage(),
      binding: GroupMemberManagerBinding(),
    ),
    GetPage(
      name: AppRoutes.GROUP_MEMBER_LIST,
      page: () => GroupMemberListPage(),
      binding: GroupMemberListBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.GROUP_LIST,
    //   page: () => GroupListPage(),
    //   binding: GroupListBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.JOIN_GROUP,
    //   page: () => JoinGroupPage(),
    //   binding: JoinGroupBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.ACCOUNT_SETUP,
    //   page: () => AccountSetupPage(),
    //   binding: AccountSetupBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.ADD_MY_METHOD,
    //   page: () => AddMyMethodPage(),
    //   binding: AddMyMethodBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.BLACKLIST,
    //   page: () => BlacklistPage(),
    //   binding: BlacklistBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.ABOUT_US,
    //   page: () => AboutUsPage(),
    //   binding: AboutUsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.SEARCH_FRIEND,
    //   page: () => SearchFriendPage(),
    //   binding: SearchFriendBinding(),
    // ),
    GetPage(
      name: AppRoutes.SEARCH_GROUP,
      page: () => SearchGroupPage(),
      binding: SearchGroupBinding(),
    ),
    GetPage(
      name: AppRoutes.SEARCH_MEMBER,
      page: () => SearchMemberPage(),
      binding: SearchMemberBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.CALL_RECORDS,
    //   page: () => CallRecordsPage(),
    //   binding: CallRecordsBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.LANGUAGE_SETUP,
    //   page: () => SetupLanguagePage(),
    //   binding: SetupLanguageBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.SEARCH_ADD_GROUP,
    //   page: () => SearchAddGroupPage(),
    //   binding: SearchAddGroupBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.APPLY_ENTER_GROUP,
    //   page: () => ApplyEnterGroupPage(),
    //   binding: ApplyEnterGroupBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.GROUP_APPLICATION,
    //   page: () => GroupApplicationPage(),
    //   binding: GroupApplicationBinding(),
    // ),
    GetPage(
      name: AppRoutes.HANDLE_GROUP_APPLICATION,
      page: () => HandleGroupApplicationPage(),
      binding: HandleGroupApplicationBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.ORGANIZATION,
    //   page: () => OrganizationPage(),
    //   binding: OrganizationBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.FORGET_PASSWORD,
    //   page: () => ForgetPasswordPage(),
    //   binding: ForgetPasswordBinding(),
    // ),
    GetPage(
      name: AppRoutes.EMOJI_MANAGE,
      page: () => EmojiManagePage(),
      binding: EmojiManageBinding(),
    ),
    GetPage(
      name: AppRoutes.FONT_SIZE,
      page: () => FontSizePage(),
      binding: FontSizeBinding(),
    ),
    GetPage(
      name: AppRoutes.TAG,
      page: () => TagGroupPage(),
      binding: TagGroupBinding(),
    ),
    GetPage(
      name: AppRoutes.TAG_NEW,
      page: () => NewTagGroupPage(),
      binding: NewTagGroupBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.ALL_USERS,
    //   page: () => AllUsersPage(),
    //   binding: AllUsersBinding(),
    // ),
    GetPage(
      name: AppRoutes.GROUP_HAVE_READ,
      page: () => GroupMessageReadPage(),
      binding: GroupMessageReadBinding(),
    ),
    GetPage(
      name: AppRoutes.SEARCH_HISTORY_MESSAGE,
      page: () => SearchHistoryMessagePage(),
      binding: SearchHistoryMessageBinding(),
    ),
    GetPage(
      name: AppRoutes.SEARCH_FILE,
      page: () => SearchFilePage(),
      binding: SearchFileBinding(),
    ),
    GetPage(
      name: AppRoutes.SEARCH_PICTURE,
      page: () => SearchPicturePage(),
      binding: SearchPictureBinding(),
    ),
    GetPage(
      name: AppRoutes.SET_MEMBER_MUTE,
      page: () => SetMemberMutePage(),
      binding: SetMemberMuteBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.OA_NOTIFICATION_LIST,
    //   page: () => OANotificationPage(),
    //   binding: OANotificationBinding(),
    // ),
    GetPage(
      name: AppRoutes.SET_BACKGROUND_IMAGE,
      page: () => BackgroundImagePage(),
      binding: BackgroundImageBinding(),
    ),
    GetPage(
      name: AppRoutes.ZHP_WEBVIEW,
      page: () => ZhpWebviewPage(),
      binding: ZhpWebviewBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.LOGIN_PC,
    //   page: () => LoginPcPage(),
    //   binding: LoginPcBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.GLOBAL_SEARCH,
    //   page: () => GlobalSearchPage(),
    //   binding: GlobalSearchBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.GLOBAL_SEARCH_CHAT_HISTORY,
    //   page: () => ChatHistoryPage(),
    //   binding: ChatHistoryBinding(),
    // ),
    GetPage(
      name: AppRoutes.PREVIEW_CHAT_HISTORY,
      page: () => PreviewMessagePage(),
      binding: PreviewMessageBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.PATIENT_MANAGE,
    //   page: () => PatientManagePage(),
    //   binding: PatientManageBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.ADD_PATIENT,
    //   page: () => AddPatientPage(),
    //   binding: AddPatientBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.PATIENT_DETAIL,
    //   page: () => PatientDetailPage(),
    //   binding: PatientDetailBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.MY_COLLECTION,
    //   page: () => MyCollectionPage(),
    //   binding: MyCollectionBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.SYSTEM_NOTICE_LIST,
    //   page: () => SystemNoticeListPage(),
    //   binding: SystemNoticeListBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.SYSTEM_NOTICE_DETAIL,
    //   page: () => SystemNoticeDetailPage(),
    //   binding: SystemNoticeDetailBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.KNOWLEDGE_BASE_SEARCH,
    //   page: () => KnowledgeBaseSearchPage(),
    //   binding: KnowledgeBaseSearchBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.KNOWLEDGE_BASE_SEARCH_DETAIL,
    //   page: () => ZskjsDetailPage(),
    //   binding: ZskjsDetailBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.MEDICAL_MEMO,
    //   page: () => MedicalMemoPage(),
    //   binding: MedicalMemoBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.MEDICAL_MEMO_DETAIL,
    //   page: () => MedicalMemoDetailPage(),
    //   binding: MedicalMemoDetailBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.DEPART_FRIEND_LIST,
    //   page: () => DepartListFriendPage(),
    //   binding: DepartListFriendBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.COLLECTION_DETAIL,
    //   page: () => CollectDetailPage(),
    //   binding: CollectDetailBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.PATIENT_GDJL_PAGE,
    //   page: () => PatientGdjlPage(),
    //   binding: PatientGdjlBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.DO_BY_SPEECH,
    //   page: () => DoBySpeechPage(),
    //   binding: DoBySpeechBinding(),
    // ),
  ];
}
