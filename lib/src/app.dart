import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/routes/app_pages.dart';
import 'package:mics_big_version/src/utils/logger_util.dart';
import 'package:mics_big_version/src/widgets/app_view.dart';

import 'core/controller/cache_controller.dart';
import 'core/controller/im_controller.dart';
import 'core/controller/jpush_controller.dart';
import 'core/controller/permission_controller.dart';

class EnterpriseChatApp extends StatelessWidget {
  const EnterpriseChatApp({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return AppView(
      builder: (locale, builder) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        enableLog: true,
        navigatorKey: navigatorKey,
        builder: builder,
        logWriterCallback: Logger.print,
        translations: TranslationService(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // DefaultCupertinoLocalizations.delegate,
        ],
        fallbackLocale: TranslationService.fallbackLocale,
        locale: locale,
        localeResolutionCallback: (locale, list) {
          Get.locale ??= locale;
          return locale;
        },
        supportedLocales: [
          const Locale('zh', 'CN'),
          const Locale('en', 'US'),
        ],
        getPages: AppPages.routes,
        initialBinding: InitBinding(),
        initialRoute: AppRoutes.SPLASH,
      ),
    );
    // return ScreenUtilInit(
    //   designSize: Size(Config.UI_W, Config.UI_H),
    //   builder: () => GetMaterialApp(
    //     debugShowCheckedModeBanner: true,
    //     enableLog: true,
    //     logWriterCallback: Logger.print,
    //     translations: TranslationService(),
    //     fallbackLocale: TranslationService.fallbackLocale,
    //     locale: Locale('zh', 'CN'),
    //     getPages: AppPages.routes,
    //     initialBinding: InitBinding(),
    //     initialRoute: AppRoutes.SPLASH,
    //   ),
    // );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PermissionController>(PermissionController());
    Get.put<IMController>(IMController());
    Get.put<JPushController>(JPushController());
    Get.put<CacheController>(CacheController());
    // Get.put<SpeechServiceController>(SpeechServiceController());
    // Get.put<DoBySpeechLogic>(DoBySpeechLogic());
    // Get.lazyPut(() => JPushController());
    // Get.lazyPut(() => CallController());
    // Get.lazyPut(() => IMController());
    // Get.lazyPut(() => PermissionController());
  }
}