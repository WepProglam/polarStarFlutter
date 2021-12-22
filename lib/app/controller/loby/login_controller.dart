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

  Future login(String id, String pw) async {
    String user_id = id;
    String user_pw = pw;

    Map<String, String> data = {
      'id': user_id,
      'pw': user_pw,
    };

    print(data);

    final response = await repository.login(data);

    switch (response["statusCode"]) {
      case 200:
        // * 이미 박스에 데이터 있을 때
        if (box.hasData('id') || box.hasData('pw')) {
          await box.remove('id');
          await box.remove('pw');
          print("없어짐");
        }
        Get.snackbar("로그인 성공", "로그인 성공");

        if (isAutoLogin.value) {
          await box.write('isAutoLogin', true);
          await box.write('id', id);
          await box.write('pw', pw);
        } else {
          await box.remove('id');
          await box.remove('pw');
          await box.write('isAutoLogin', false);
        }

        print(box.read("id"));

        // Get.offAndToNamed('/main');
        Get.offAllNamed('/main');
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
