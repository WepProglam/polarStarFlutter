import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polarstar_flutter/app/modules/init_page/pushy_controller.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/global_widgets/dialoge.dart';
import 'package:polarstar_flutter/session.dart';

import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/data/provider/main/main_provider.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_repository.dart';

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

  Future<bool> checkLogin() async {
    //print(box.read("id"));'
    print("login");
    if (box.hasData('isAutoLogin') && box.hasData('id') && box.hasData('pw')) {
      var res = await autoLogin(box.read('id'), box.read('pw'));

      switch (res["statusCode"]) {
        case 200:
          await PushyController.refreshDeviceToken();
          // PushyController pushyController = Get.find();
          // pushyController.push_register_total();

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

  String current_version = "1.0";

  Future<void> versionCheck() async {
    try {
      //현재 앱 버전
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      current_version = packageInfo.version;

      print("current_version: ${current_version}");
      int current_buildNumber = int.tryParse(packageInfo.buildNumber);

      final response = await Session().getX('/versionCheck');
      final jsonResponse = await jsonDecode(response.body);

      bool versionCheckSuccess = (response.statusCode == 200);

      if (!versionCheckSuccess) {
        print("versionCheck Fetch Failed");
        return;
      }

      final String latest_version = jsonResponse["latest_version"];
      int latest_buildNumber = int.tryParse(latest_version.split("+")[1]);

      // print("latest_version: ${latest_version}");

      final String min_version = jsonResponse["min_version"];
      int min_buildNumber = int.tryParse(min_version.split("+")[1]);

      // print("min_version: ${min_version}");

      //version check 실패
      if (!(current_buildNumber != null &&
          latest_buildNumber != null &&
          min_buildNumber != null)) {
        print("versionCheck failed");
        return;
      }
      Function onTapConfirm = () async {
        LaunchReview.launch(
            androidAppId: "com.polarstar.polarStar", iOSAppId: "1608688540");
        if (Platform.isIOS) {
          exit(0);
        } else {
          SystemNavigator.pop();
        }
      };

      print(current_buildNumber);
      print(min_buildNumber);
      print(latest_buildNumber);

      if (current_buildNumber < min_buildNumber) {
        //업데이트 해야함(필수)

        await Tdialogue(
            Get.context, "软件检测到新版本必须更新后使用", "软件检测到新版本必须更新后使用", onTapConfirm);
      } else if (current_buildNumber > latest_buildNumber) {
        //이건 오류(build number 잘못 입력됨)
        print("versionCheck failed");

        //SystemNavigator.pop();

        return;
      } else if (current_buildNumber < latest_buildNumber) {
        print(("업데이트 권장"));
        //업데이트 권장

        await TFdialogue("通知", "目前软件版本过低 建议更新至最新版本", onTapConfirm, () {});
      } else {
        //버전 잘 맞음 (current_buildNumber == latest_buildNumber)
        print("LATEST VERSION");
      }
      // } catch (err) {
      //   print(err);
      // }
    } catch (e) {}
  }

  @override
  void onInit() async {
    opacityControl(true);
    super.onInit();
    print("try");
    await versionCheck();
    opacityControl(false);

    print("init controller init");
    if (Get.arguments == "fromLogin") {
      isLogined(true);
      print("refresh device token");
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

    } else {
      Get.offAndToNamed('/login');
    }
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

    await TFdialogue(
        "权限未授予", "因$target权限管理将移动至软件设置管理", onTapConfirm, onTapCancel);
  }
}
