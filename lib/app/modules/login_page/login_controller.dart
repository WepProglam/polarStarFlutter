import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/data/model/login_model.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/session.dart';

class LoginController extends GetxController {
  final LoginRepository repository;
  final box = GetStorage();
  LoginController({@required this.repository}) : assert(repository != null);

  var isAutoLogin = true.obs;
  var isObscured = true.obs;

  var loginModel = LoginModel().obs;
  RxBool isTyping = false.obs;

  Future<void> logout() async {
    await box.erase();
    await box.remove('id');
    await box.remove('pw');
    await box.remove('isAutoLogin');
    // await box.write('isAutoLogin', false);

    // await box.save();
    //print("id = " + box.read('id').toString());

    Session.cookies = {};
    Session.headers['Cookie'] = '';

    await Session().getX('/logout');

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
        // Get.snackbar("登陆成功", "登陆成功");

        break;
      default:
        Get.snackbar("登录失败", "登录失败");
    }
    return response;
  }

  Future<bool> checkLogin() async {
    //print(box.read("id"));
    if (box.hasData('isAutoLogin') && box.hasData('id') && box.hasData('pw')) {
      var res = await autoLogin(box.read('id'), box.read('pw'));
      // print(box.read('id'));
      //  print("login!!");

      switch (res["statusCode"]) {
        case 200:
          return true;
          break;
        default:
          return false;
      }
    }
    // print("no login");
    // print(box.hasData('isAutoLogin'));
    // print(box.hasData('id'));
    // print(box.hasData('pw'));
    return false;
  }

  Future login(String id, String pw) async {
    String user_id = id;
    String user_pw = pw;

    Map<String, String> data = {
      'id': user_id,
      'pw': user_pw,
    };

    // print(data);
    // print("auto login : ${isAutoLogin.value}");

    final response = await repository.login(data);

    switch (response["statusCode"]) {
      case 200:
        // print("chatSokcet : ${classChatSocket.connected}");
        // * 이미 박스에 데이터 있을 때
        if (box.hasData('id') || box.hasData('pw')) {
          await box.remove('id');
          await box.remove('pw');
          // print("없어짐");
        }
        // Get.snackbar("登陆成功", "登陆成功");

        if (isAutoLogin.value) {
          await box.write('isAutoLogin', true);
          await box.write('id', id);
          await box.write('pw', pw);
          await box.save();
          // print("checkcheck");
          print(box.hasData('isAutoLogin') &&
              box.hasData('id') &&
              box.hasData('pw'));
        } else {
          await box.remove('id');
          await box.remove('pw');
          await box.write('isAutoLogin', false);
          await box.save();
        }
        // print(box.read("id"));
        // Get.offAndToNamed(Routes.INITIAL, arguments: "fromLogin");
        // Get.offAndToNamed('/main');
        Get.offAllNamed(Routes.INITIAL, arguments: "fromLogin");
        break;
      default:
        Get.snackbar("Failed to sign in", "Failed to sign in",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
    }
  }

  @override
  void onInit() async {
    // if (box.hasData('isAutoLogin')) {
    //   if (box.read('isAutoLogin')) {
    //     await login(box.read('id'), box.read('pw'), box.read('token'));
    //   }
    // }

    super.onInit();
  }
}
