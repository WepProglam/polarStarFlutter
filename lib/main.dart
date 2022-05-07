import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/init_page/pushy_controller.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flurry/flurry.dart';
// import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

// import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

IO.Socket ChatSocket;
// FirebaseAnalytics analytics;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
    PushyController pushyController = Get.put(PushyController());
    await pushyController.push_register_total();
    await FlutterDownloader.initialize();
    // await Firebase.initializeApp();
    // analytics = FirebaseAnalytics.instance;

    // KakaoSdk.init(nativeAppKey: '46e40379d2bed8feccedacd7a59ab06a');
  } catch (e) {
    print(e);
  }

  runApp(PolarStar());
}

class PolarStar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: child,
        );
      },
      // navigatorObservers: <NavigatorObserver>[
      //   // FirebaseAnalyticsObserver(analytics: analytics),
      // ],
      themeMode: ThemeMode.light, // Change it as you want
      theme: ThemeData(
          // 0xff571DF0
          primaryColor: const Color(0xff4570ff),
          appBarTheme: AppBarTheme(color: const Color(0xff4570ff)),
          unselectedWidgetColor: Color(0xffeaeaea)),
      scrollBehavior: MyBehavior(),
      debugShowCheckedModeBanner: false,
      // ! Route로 가면 자동으로 binding 됨
      // ! 여기서 binding하면 binding 총 2번 실행됨
      initialRoute: Routes.INITIAL,
      defaultTransition: Transition.cupertino,
      getPages: AppPages.pages,
      locale: Locale('pt', 'BR'),
    );
  }
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
