import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/bindings/loby/login_binding.dart';
import 'package:polarstar_flutter/app/bindings/loby/init_binding.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
// import 'package:polarstar_flutter/app/translations/app_translations.dart';
// import 'app/ui/theme/app_theme.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();

  await Firebase.initializeApp();

  runApp(GetMaterialApp(
    theme: ThemeData(fontFamily: "PingFangSC"),
    debugShowCheckedModeBanner: false,

    initialBinding: InitBinding(),
    initialRoute: Routes.INITIAL,
    // theme: appThemeData,
    defaultTransition: Transition.fade,
    getPages: AppPages.pages,
    locale: Locale('pt', 'BR'),
    // translationsKeys: AppTranslation.translations,
  ));
}
