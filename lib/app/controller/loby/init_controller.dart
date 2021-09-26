import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/data/model/login_model.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:meta/meta.dart';

class InitController extends GetxController {
  final LoginRepository repository;
  final box = GetStorage();

  InitController({@required this.repository}) : assert(repository != null);

  Future autoLogin(String id, String pw, String token) async {
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
      if (box.read('isAutoLogin')) {
        await autoLogin(box.read('id'), box.read('pw'), box.read('token'));
        return true;
        //     .then((response) {
        //   switch (response["statusCode"]) {
        //     case 200:
        //       return true;
        //       break;
        //     default:
        //       return false;
        //   }
        // });
      }
    }
    return false;
  }

  @override
  void onInit() async {
    super.onInit();
  }
}
