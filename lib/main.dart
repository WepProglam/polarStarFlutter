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

import 'app/controller/loby/init_controller.dart';

void main() async {
  await GetStorage.init();

  await Firebase.initializeApp();
  InitController initController = await Get.put(
      InitController(repository: LoginRepository(apiClient: LoginApiClient())));

  // while (!initController.dataAvailable.value) {
  //   print(initController.dataAvailable.value);
  //   print("waiting..");
  // }

  bool isLogined = await initController.checkLogin();

  print(isLogined);
  print("start");

  await runApp(GetMaterialApp(
    theme: ThemeData(fontFamily: "PingFangSC"),
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
