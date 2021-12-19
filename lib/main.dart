import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/bindings/loby/login_binding.dart';
import 'package:polarstar_flutter/app/bindings/loby/init_binding.dart';
import 'package:polarstar_flutter/app/bindings/main/main_binding.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
// import 'package:polarstar_flutter/app/translations/app_translations.dart';
// import 'app/ui/theme/app_theme.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'app/controller/loby/init_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

void checkFcmToken(InitController initController) async {
  String tempFcmToken = await initController.checkFcmToken();
  if (initController.needRefreshToken(tempFcmToken)) {
    await initController.tokenRefresh(tempFcmToken);
  }
  return;
}

void main() async {
  await GetStorage.init();

  await Firebase.initializeApp();

  InitController initController = await Get.put(
      InitController(repository: LoginRepository(apiClient: LoginApiClient())));

  bool isLogined = await initController.checkLogin();

  print(isLogined);
  print("start");

  // fcm token check
  await checkFcmToken(initController);

  await runApp(GetMaterialApp(
    theme: ThemeData(),
    scrollBehavior: MyBehavior(),
    debugShowCheckedModeBanner: false,
    initialBinding: isLogined ? MainBinding() : LoginBinding(),
    initialRoute: isLogined ? Routes.MAIN_PAGE : Routes.LOGIN,
    // theme: appThemeData,
    defaultTransition: Transition.fade,
    getPages: AppPages.pages,
    locale: Locale('pt', 'BR'),
    // translationsKeys: AppTranslation.translations,
  ));
}
