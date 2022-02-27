import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polarstar_flutter/app/controller/class/class_chat_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';

import 'package:polarstar_flutter/app/data/model/login_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/dialoge.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:polarstar_flutter/app/controller/loby/login_controller.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/provider/main/main_provider.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_repository.dart';

import 'package:flutter/services.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

class InitController extends GetxController {
  final LoginRepository repository;
  final box = GetStorage();

  InitController({@required this.repository}) : assert(repository != null);

  RxBool isLogined = false.obs;
  RxBool opacityControl = true.obs;

  // Future<String> checkFcmToken() async {
  //   String FcmToken;
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     FcmToken = token;
  //   });
  //   return FcmToken;
  // }

  bool needRefreshToken(String curFcmToken) {
    String oldFcmToken = box.read("FcmToken");
    //print(curFcmToken);
    //print(oldFcmToken);
    return (oldFcmToken != curFcmToken);
  }

  Future<void> tokenRefresh(String FcmToken) async {
    Map<String, String> data = {"FcmToken": FcmToken};
    //print(data);
    final int response = await repository.tokenRefresh(data);
    switch (response) {
      case 200:
        break;
      default:
    }
    box.write("FcmToken", FcmToken);

    //print("fcm return : ${response}");
    return;
  }

  Future refreshDeviceToken() async {
    print("device token");
    print(deviceToken);
    await Session().postX("/login/deviceToken", {"deviceToken": deviceToken});
    print("sibal");
  }

  Future autoLogin(String id, String pw) async {
    String user_id = id;
    String user_pw = pw;

    Map<String, String> data = {
      'id': user_id,
      'pw': user_pw,
    };

    print("auto login");

    final response = await repository.login(data);

    switch (response["statusCode"]) {
      case 200:
        // Get.snackbar("登陆成功", "登陆成功",
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.white,
        //     colorText: Colors.black);

        break;
      default:
        Get.snackbar("登录失败", "登录失败",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
    }
    return response;
  }

  void pushyClickListener() {
    // Listen for push notification clicked
    Pushy.setNotificationClickListener((Map<String, dynamic> data) {
      // Print notification payload data
      print('Notification clicked: $data');

      switch (data["NOTI_TYPE"].toString()) {
        // * 커뮤니티
        case "0":
          Get.toNamed(
              "/board/${data["URL"].toString().split("/")[1]}/read/${data["URL"].toString().split("/")[3]}");
          break;
        // * 개인 공지
        case "3":
          Get.toNamed(Routes.NOTI);
          print("??");
          break;
        // * 전체 공지
        case "4":
          Get.toNamed(Routes.NOTI);
          print("??");
          break;
        // * 핫보드 알림
        case "8":
          Get.toNamed(
              "/board/${data["URL"].toString().split("/")[1]}/read/${data["URL"].toString().split("/")[3]}");
          break;
        default:
          break;
      }
    });
  }

  // Please place this code in main.dart,
  // After the import statements, and outside any Widget class (top-level)
  void backgroundNotificationListener(Map<String, dynamic> data) {
    // Print notification payload data
    print('Received notification: $data');

    // Notification title
    String notificationTitle = data['TITLE'];

    // Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
    String notificationText = data['CONTENT'];

    String url = data["URL"];

    if (Get.isRegistered<NotiController>()) {
      print("registered");
      NotiController notiController = Get.find<NotiController>();
      switch (data["NOTI_TYPE"].toString()) {
        // * 커뮤니티
        case "0":
          notiController.noties.insert(0, NotiModel.fromJson(data).obs);
          break;
        // * 개인 공지
        case "3":
          notiController.noties.insert(0, NotiModel.fromJson(data).obs);
          break;
        // * 전체 공지
        case "4":
          notiController.noties.insert(0, NotiModel.fromJson(data).obs);
          break;
        // * 핫보드 알림
        case "8":
          notiController.noties.insert(0, NotiModel.fromJson(data).obs);
          break;
        default:
          break;
      }
    } else {
      print("not registed");
    }

    // Android: Displays a system notification
    // iOS: Displays an alert dialog
    if (Platform.isIOS) {
    } else {
      Pushy.notify(notificationTitle, notificationText, data);
    }
  }

  String deviceToken;

  Future pushyRegister() async {
    try {
      // Register the user for push notifications
      deviceToken = await Pushy.register();

      // Print token to console/logcat
      print('Device token: $deviceToken');

      // Display an alert with the device token
      // showDialog(
      //     context: Get.context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //           title: Text('Pushy'),
      //           content: Text('Pushy device token: $deviceToken'),
      //           actions: [
      //             FlatButton(
      //                 child: Text('OK'),
      //                 onPressed: () {
      //                   Navigator.of(context, rootNavigator: true)
      //                       .pop('dialog');
      //                 })
      //           ]);
      //     });

      // Optionally send the token to your backend server via an HTTP GET request
      // ...
    } on PlatformException catch (error) {
      print(error);
      // Display an alert with the error message
      // showDialog(
      //     context: Get.context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //           title: Text('Error'),
      //           content: Text(error.message),
      //           actions: [
      //             FlatButton(
      //                 child: Text('OK'),
      //                 onPressed: () {
      //                   Navigator.of(context, rootNavigator: true)
      //                       .pop('dialog');
      //                 })
      //           ]);
      //     });
    }
  }

  Future<bool> checkLogin() async {
    //print(box.read("id"));'
    print("login");
    if (box.hasData('isAutoLogin') && box.hasData('id') && box.hasData('pw')) {
      var res = await autoLogin(box.read('id'), box.read('pw'));
      // print(box.read('id'));
      //  print("login!!");

      switch (res["statusCode"]) {
        case 200:
          await refreshDeviceToken();

          return true;
          break;
        case 302:
          return true;
          break;
        default:
          return false;
      }
    }
    return false;
  }

  @override
  void onInit() async {
    opacityControl(true);
    super.onInit();
    print("init");
    Pushy.listen();
    print("listen");
    await pushyRegister();
    print("register");

    Pushy.setNotificationIcon('ic_launcher');

    opacityControl(false);

    print("init controller init");
    if (Get.arguments == "fromLogin") {
      isLogined(true);
      print("refresh device token");
      await refreshDeviceToken();
      print("refresh device token");
    } else {
      isLogined(await checkLogin());
    }
    print("??");

    DateTime pass = DateTime.now();

    if (isLogined.isTrue) {
      MainController mainController = Get.put(MainController(
          repository: MainRepository(apiClient: MainApiClient())));
      await mainController.fake_onInit();
      // await mainController.onInit();
      // await mainController.onReady();
    }

    DateTime cur = DateTime.now();

    if (cur.difference(pass) < Duration(milliseconds: 1500)) {
      int wait = 1500 - cur.difference(pass).inMilliseconds;
      await Future.delayed(Duration(milliseconds: wait));
    }

    if (isLogined.isTrue) {
      // Get.offNamed(Routes.MAIN_PAGE);
      Get.toNamed(Routes.MAIN_PAGE);
      print("main page");
      // Enable in-app notification banners (iOS 10+)
      Pushy.toggleInAppBanner(true);
      print("toggle app bar");
      // Listen for push notifications received
      Pushy.setNotificationListener(backgroundNotificationListener);
      pushyClickListener();
      Pushy.clearBadge();
    } else {
      Get.offAndToNamed('/login');
    }

    // box.remove("alreadyRunned");
  }

  // @override
  // void onReady() async {
  //   print("onready");
  // }

}

class ManagePermission {
  static Future<bool> getPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage, Permission.camera].request();

    PermissionStatus permissionStorage = statuses[Permission.storage];
    PermissionStatus permissionCamera = statuses[Permission.camera];
    // PermissionStatus permissionCamera = statuses[Permission.camera];
    // print(permissionStorage.toString());
    // print(permissionStorage.isGranted);
    if (permissionStorage.isGranted && permissionCamera.isGranted) {
      // print("????");
      print("all true!!");
      return true;
    } else {
      // await openAppSettings();
      print("all false!!");
      if (!permissionStorage.isGranted && !permissionCamera.isGranted) {
        await permissionDialog("storage");
        await permissionDialog("camera");
      } else if (!permissionStorage.isGranted) {
        await permissionDialog("storage");
      } else if (!permissionCamera.isGranted) {
        await permissionDialog("camera");
        print("?!!!!");
        print("?!!!!");
      }

      return false;
    }
  }

  static Future<bool> checkPermission(String tag) async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage, Permission.camera].request();
    PermissionStatus permissionStorage = statuses[Permission.storage];
    PermissionStatus permissionCamera = statuses[Permission.camera];

    bool permissionGranted = false;
    if (tag == "storage") {
      permissionGranted = permissionStorage.isGranted;
    } else if (tag == "camera") {
      permissionGranted = permissionCamera.isGranted;
    }

    return permissionGranted;
  }

  static void permissionDialog(String target) async {
    Function onTapConfirm = () async {
      await openAppSettings();
      Get.back();
    };
    Function onTapCancel = () {
      Get.back();
    };

    await TFdialogue(Get.context, "权限未授予", "因$target权限管理将移动至软件设置管理",
        onTapConfirm, onTapCancel);
  }
}
