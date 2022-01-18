import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/data/model/login_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:meta/meta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';

class InitController extends GetxController {
  final LoginRepository repository;
  final box = GetStorage();

  InitController({@required this.repository}) : assert(repository != null);

  RxInt mainPageIndex = 0.obs;

  Future<String> checkFcmToken() async {
    String FcmToken;
    await FirebaseMessaging.instance.getToken().then((token) {
      FcmToken = token;
    });
    return FcmToken;
  }

  bool needRefreshToken(String curFcmToken) {
    String oldFcmToken = box.read("FcmToken");
    print(curFcmToken);
    print(oldFcmToken);
    return (oldFcmToken != curFcmToken);
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
    box.write("FcmToken", FcmToken);

    print("fcm return : ${response}");
    return;
  }

  Future<void> getChatBox() async {
    var response = await Session().getX("/chat/chatBox");
    Iterable chatBoxList = jsonDecode(response.body);
    List<Rx<ChatBoxModel>> chatBox =
        chatBoxList.map((e) => ChatBoxModel.fromJson(e).obs).toList();
    box.remove("classSocket");
    List<int> tempClassList = [];
    for (Rx<ChatBoxModel> item in chatBox) {
      tempClassList.add(item.value.CLASS_ID);
    }
    await box.write("classSocket", tempClassList);
    return;
  }

  Future autoLogin(String id, String pw) async {
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
    print(box.read("id"));
    if (box.hasData('isAutoLogin') && box.hasData('id') && box.hasData('pw')) {
      var res = await autoLogin(box.read('id'), box.read('pw'));
      print(box.read('id'));
      print("login!!");

      switch (res["statusCode"]) {
        case 200:
          return true;
          break;
        default:
          return false;
      }
    }
    print("no login");
    print(box.hasData('isAutoLogin'));
    print(box.hasData('id'));
    print(box.hasData('pw'));
    return false;
  }

  @override
  void onInit() async {
    super.onInit();
    // firebaseCloudMessaging_Listeners();
  }
}
