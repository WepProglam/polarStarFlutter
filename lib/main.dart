import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/bindings/login_binding.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
// import 'package:polarstar_flutter/app/translations/app_translations.dart';

import 'app/bindings/main_binding.dart';
// import 'app/ui/theme/app_theme.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();

  // Bindings initBinding = LoginBinding();
  // String initRoute = Routes.LOGIN;

  // if (box.hasData('id') && box.hasData('pw')) {
  //   Map<String, String> user_data = {
  //     'id': box.read('id'),
  //     'pw': box.read('pw'),
  //     'token': box.read('token')
  //   };

  //   print(user_data);

  //   Session().autoLogin(user_data).then((value) {
  //     print(value.statusCode);
  //     switch (value.statusCode) {
  //       case 200:
  //         initBinding = MainBinding();
  //         initRoute = Routes.MAIN_PAGE;
  //         break;
  //       default:
  //         initBinding = LoginBinding();
  //         initRoute = Routes.LOGIN;
  //     }
  //   });
  // }

  await Firebase.initializeApp();

  runApp(GetMaterialApp(
    theme: ThemeData(fontFamily: "PingFangSC"),
    debugShowCheckedModeBanner: false,

    initialBinding: LoginBinding(),
    initialRoute: Routes.LOGIN,
    // theme: appThemeData,
    defaultTransition: Transition.fade,
    getPages: AppPages.pages,
    locale: Locale('pt', 'BR'),
    // translationsKeys: AppTranslation.translations,
  ));
}
