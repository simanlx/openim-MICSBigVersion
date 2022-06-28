import 'config.dart';

class Urls {
  static var register2 = "${Config.imApiUrl()}/demo/user_register";
  static var login2 = "${Config.imApiUrl()}/demo/user_token";
  static var importFriends = "${Config.imApiUrl()}/friend/import_friend";
  static var inviteToGroup = "${Config.imApiUrl()}/group/invite_user_to_group";
  static var onlineStatus =
      "${Config.imApiUrl()}/manager/get_users_online_status";
  static var userOnlineStatus =
      "${Config.imApiUrl()}/user/get_users_online_status";
  static var queryAllUsers = "${Config.imApiUrl()}/manager/get_all_users_uid";

  ///
  // static const getVerificationCode = "/cpc/auth/code";
  // static const checkVerificationCode = "/cpc/auth/verify";
  // static const register = "/cpc/auth/password";
  // static const login = "/cpc/auth/login";

  /// 登录注册 独立于im的业务
  static var getVerificationCode = "${Config.appAuthUrl()}/demo/code";
  static var checkVerificationCode = "${Config.appAuthUrl()}/demo/verify";
  static var setPwd = "${Config.appAuthUrl()}/demo/password";
  static var resetPwd = "${Config.appAuthUrl()}/demo/reset_password";
  // static var login = "${Config.appAuthUrl()}/demo/login";
    static var login = "https://people-voip.raisound.com/vserver/pda/device/login";
  static var upgrade = "${Config.appAuthUrl()}/app/check";

  /// office
  static var getUserTags = "${Config.imApiUrl()}/office/get_user_tags";
  static var createTag = "${Config.imApiUrl()}/office/create_tag";
  static var deleteTag = "${Config.imApiUrl()}/office/delete_tag";
  static var updateTag = "${Config.imApiUrl()}/office/set_tag";
  static var sendMsgToTag = "${Config.imApiUrl()}/office/send_msg_to_tag";
  static var getSendTagLog = "${Config.imApiUrl()}/office/get_send_tag_log";



  //北科瑞声自己的接口
  static var getWorkModules = "${Config.bkrsApiUrl()}/im/module"; //获取工作台模块列表
  static var getZskjsList = "${Config.bkrsApiUrl()}/im/knowledge/type"; //获取知识库检索接口
  static var getZskjsListByFilte = "${Config.bkrsApiUrl()}/im/knowledge"; //获取知识库检索接口


  static var getYlbwLabelList = "${Config.bkrsApiUrl()}/im/note/type"; //医疗备忘type
  static var ylbwUploadImage = "${Config.bkrsApiUrl()}/im/tools/image/upload"; //医疗备忘上传图片
  static var ylbwUploadVoice = "${Config.bkrsApiUrl()}/im/tools/voice/upload"; //医疗备忘上传音频
  static var saveylbw = "${Config.bkrsApiUrl()}/im/note/add"; //医疗备忘创建
  static var updateylbw = "${Config.bkrsApiUrl()}/im/note/edit"; //医疗备忘更新
  static var getYlbwList = "${Config.bkrsApiUrl()}/im/note"; //医疗备忘列表
  static var removeYlbw = "${Config.bkrsApiUrl()}/im/note/delete"; //删除医疗备忘
  static var startYyzx = "${Config.bkrsApiUrl()}/im/tools/voice/transfer"; //开始离线转写
  static var getYyzxText = "${Config.bkrsApiUrl()}/im/tools/voice/transfer_detail"; //获取离线转写结果



  //患者管理
  static var getPatientList = "${Config.bkrsApiUrl()}/im/patient";
  static var getPatientRoomList = "${Config.bkrsApiUrl()}/im/patient/room";
  static var addPatient = "${Config.bkrsApiUrl()}/im/patient/add";
  static var patientDetail = "${Config.bkrsApiUrl()}/im/patient/detail";
  static var editPatientDetail = "${Config.bkrsApiUrl()}/im/patient/edit";
  static String patientBlly = "${Config.bkrsApiUrl()}/im/patient/leave";
  static String patientGetGdRecord = "${Config.bkrsApiUrl()}/im/message/archiveMessage";

  //通讯录
  static var departmentList = "${Config.bkrsApiUrl()}/im/department";
  static var departmentFriendList = "${Config.bkrsApiUrl()}/im/user";

  //收藏
  static var addLike = "${Config.bkrsApiUrl()}/im/collect/add";
  static var getLikeList = "${Config.bkrsApiUrl()}/im/collect/get";



  //语音呼叫 姓名匹配
  static var userMatch = "${Config.bkrsApiUrl()}/im/user/match";


  static var noteTop = "${Config.bkrsApiUrl()}/im/note/top";

  static var cancelNoteTop = "${Config.bkrsApiUrl()}/im/note/top/cancel";

  static var deleteLike = "${Config.bkrsApiUrl()}/im/collect/delete";

  //智能定位
  static var updataPos = "${Config.bkrsApiUrl()}/im/point/add";

}
