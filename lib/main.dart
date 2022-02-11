import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/bindings/loby/login_binding.dart';
import 'package:polarstar_flutter/app/bindings/loby/init_binding.dart';
import 'package:polarstar_flutter/app/bindings/main/main_binding.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/session.dart';
// import 'package:polarstar_flutter/app/translations/app_translations.dart';
// import 'app/ui/theme/app_theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'app/controller/loby/init_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

// void checkFcmToken(InitController initController) async {
//   String tempFcmToken = await initController.checkFcmToken();
//   if (initController.needRefreshToken(tempFcmToken)) {
//     await initController.tokenRefresh(tempFcmToken);
//   }
//   return;
// }

// // TODO: 스낵바 모양
// void onforegroundMessage() {
//   // if (Platform.isIOS) iOS_Permission();
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     Get.snackbar(
//         "${message.notification.title}", "${message.notification.body}",
//         snackPosition: SnackPosition.TOP);
//   });
// }

// // TODO: 백그라운드에서 알림 스낵바 & 클릭했을때 이동 & 플랫폼 옵션 (app key, api key)
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
//   String noti_type = message.data["type"];
//   String url = message.data["url"];

//   // if (noti_type == "댓글") {
//   //   String temp = url.split("board/")[1];
//   //   int community_id = int.parse(temp.split("/read/")[0]);
//   //   int board_id = int.parse(temp.split("/read/")[1]);
//   //   Get.toNamed("/board/$community_id/read/$board_id");
//   // }

//   print("Handling a background message: ${message.messageId}");
//   print("Handling a background message: ${message.data}");
// }

IO.Socket classChatSocket;

void main() async {
  changeStatusBarColor(Color(0xff4570ff), Brightness.light);

  await GetStorage.init();

  // await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  runApp(GetMaterialApp(
    themeMode: ThemeMode.light, // Change it as you want
    theme: ThemeData(
        primaryColor: const Color(0xff4570ff),
        appBarTheme: AppBarTheme(color: const Color(0xff4570ff)),
        unselectedWidgetColor: Color(0xffeaeaea)),
    scrollBehavior: MyBehavior(),
    debugShowCheckedModeBanner: false,
    // ! Route로 가면 자동으로 binding 됨
    // ! 여기서 binding하면 binding 총 2번 실행됨
    // initialBinding: isLogined ? MainBinding() : LoginBinding(),
    initialRoute: Routes.INITIAL,
    // theme: appThemeData,
    // defaultTransition: Transition.cupertino,
    getPages: AppPages.pages,
    locale: Locale('pt', 'BR'),
    // translationsKeys: AppTranslation.translations,
  ));
}

void changeStatusBarColor(Color color, Brightness brighteness) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color, statusBarBrightness: brighteness));
}

class AssetImageBin {
  static Image scrap_clicked = null;
  static Image scrap_none = null;
  static Image like_clicked = null;
  static Image like_none = null;
  static Image comment = null;

  static Image get scrapClickedIcon {
    if (scrap_clicked == null) {
      String url = getImageLocation("scrap_clicked");
      scrap_clicked = Image.asset(url);
    }
    return scrap_clicked;
  }

  static Image get scrapNoneIcon {
    if (scrap_none == null) {
      String url = getImageLocation("scrap_none");
      scrap_none = Image.asset(url);
    }
    return scrap_none;
  }

  static Image get likeClickedIcon {
    if (like_clicked == null) {
      String url = getImageLocation("like_clicked");
      like_clicked = Image.asset(url);
    }
    return like_clicked;
  }

  static Image get likeNoneIcon {
    if (like_none == null) {
      String url = getImageLocation("like_none");
      like_none = Image.asset(url);
    }
    return like_none;
  }

  static Image get commentIcon {
    if (comment == null) {
      String url = getImageLocation("comment");
      comment = Image.asset(url);
    }
    return comment;
  }

  static String getImageLocation(String name) {
    String url = null;
    // * 스크랩 O
    if (name == "scrap_clicked") {
      url = 'assets/images/icn_star_selected.png';
    }
    // * 스크랩 X
    else if (name == "scrap_none") {
      url = 'assets/images/icn_star_normal.png';
    }
    // * 좋아요 O
    else if (name == "like_clicked") {
      url = 'assets/images/icn_like_selected.png';
    }
    // * 좋아요 X
    else if (name == "like_none") {
      url = 'assets/images/icn_like_normal.png';
    }
    // * 댓글
    else if (name == "comment") {
      url = 'assets/images/icn_comment_normal.png';
    }

    return url;
  }
}
