import 'package:get/get.dart';
import 'package:mics_big_version/src/core/controller/app_controller.dart';
import 'package:mics_big_version/src/routes/app_pages.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutUsLogic extends GetxController {
  var version = "".obs;
  var appLogic = Get.find<AppController>();

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String buildNumber = packageInfo.buildNumber;
    version.value = packageInfo.version;
  }

  void checkUpdate() {
    appLogic.checkUpdateBkrs();
    // Get.toNamed(AppRoutes.DO_BY_SPEECH);
  }

  @override
  void onReady() {
    getPackageInfo();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  //去隐私协议
  void toYsxy() {
    Get.toNamed(AppRoutes.YSXYPAGE);
  }
}
