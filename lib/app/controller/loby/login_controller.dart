import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/data/model/login_model.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/ui/android/functions/crypt.dart';
import 'package:polarstar_flutter/session.dart';

class LoginController extends GetxController {
  final LoginRepository repository;
  final box = GetStorage();

  LoginController({@required this.repository}) : assert(repository != null);

  var isAutoLogin = true.obs;
  var isObscured = true.obs;

  var loginModel = LoginModel().obs;

  Future login(String id, String pw, String token) async {
    String user_id = id;
    String user_pw = pw;

    Map<String, String> data = {
      'id': user_id,
      'pw': user_pw,
      'token': token,
    };

    final response = await repository.login(data);

    switch (response["statusCode"]) {
      case 200:
        Get.snackbar("로그인 성공", "로그인 성공");

        if (isAutoLogin.value) {
          await box.write('isAutoLogin', true);
          await box.write('id', id);
          await box.write('pw', pw);
          await box.write('token', data["token"]);
        } else {
          box.remove('id');
          box.remove('pw');
          box.remove('token');
          await box.write('isAutoLogin', false);
        }

        Get.offAndToNamed('/main');
        break;
      default:
        Get.snackbar("로그인 실패", "로그인 실패");
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
