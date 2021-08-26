import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/bindings/login_binding.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
// import 'package:polarstar_flutter/app/translations/app_translations.dart';

import 'app/bindings/main_binding.dart';
// import 'app/ui/theme/app_theme.dart';
import 'package:get_storage/get_storage.dart';
import 'session.dart';

void main() async {
  await GetStorage.init();
  if (GetStorage().hasData('token')) {
    Session.headers['Cookie'] = await GetStorage().read('token');
  }
  final box = GetStorage();

  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialBinding: box.hasData('token') ? MainBinding() : LoginBinding(),
    initialRoute: box.hasData('token') ? Routes.MAIN_PAGE : Routes.INITIAL,
    // theme: appThemeData,
    defaultTransition: Transition.fade,
    getPages: AppPages.pages,
    locale: Locale('pt', 'BR'),
    // translationsKeys: AppTranslation.translations,
  ));
}
