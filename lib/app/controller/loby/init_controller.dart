import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/data/model/login_model.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:meta/meta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class InitController extends GetxController {
  final LoginRepository repository;
  final box = GetStorage();

  InitController({@required this.repository}) : assert(repository != null);

  Future<String> checkFcmToken() async {
    String FcmToken;
    await FirebaseMessaging.instance.getToken().then((token) {
      FcmToken = token;
    });
    return FcmToken;
  }

  bool needRefreshToken(String curFcmToken) {
    String oldFcmToken = box.read("FcmToken");
    return !(oldFcmToken == curFcmToken);
  }

  Future<void> tokenRefresh(String FcmToken) async {
    Map<String, String> data = {"FcmToken": FcmToken};
    print(data);
    final int response = await repository.tokenRefresh(data);
    switch (response) {
      case 200:
        break;
      default:
    }

    print("fcm return : ${response}");
    return;
  }

  Future autoLogin(String id, String pw, String token) async {
    String user_id = id;
    String user_pw = pw;

    Map<String, String> data = {
      'id': user_id,
      'pw': user_pw,
    };

    final response = await repository.login(data);

    switch (response["statusCode"]) {
      case 200:
        Get.snackbar("로그인 성공", "로그인 성공");

        break;
      default:
        Get.snackbar("로그인 실패", "로그인 실패");
    }
    return response;
  }

  Future<bool> checkLogin() async {
    if (box.hasData('isAutoLogin') &&
        box.hasData('id') &&
        box.hasData('pw') &&
        box.hasData('token')) {
      if (box.read('isAutoLogin') == true) {
        var res =
            await autoLogin(box.read('id'), box.read('pw'), box.read('token'));

        switch (res["statusCode"]) {
          case 200:
            return true;
            break;
          default:
            return false;
        }
      }
    }
    return false;
  }

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  // }

  @override
  void onInit() async {
    super.onInit();
    // firebaseCloudMessaging_Listeners();
  }
}
