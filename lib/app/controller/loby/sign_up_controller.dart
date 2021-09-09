import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

import 'package:polarstar_flutter/app/data/model/sign_up_model.dart';
import 'package:polarstar_flutter/app/data/repository/sign_up_repository.dart';
import 'package:polarstar_flutter/session.dart';

class SignUpController extends GetxController {
  final SignUpRepository repository;
  final box = GetStorage();

  SignUpController({@required this.repository}) : assert(repository != null);

  Future signUp(String id, String pw, String nickname, String studentID) async {
    Map<String, String> data = {
      "id": id,
      "pw": pw,
      "nickname": nickname,
      "studentID": studentID
    };

    final response = await repository.signUp(data);

    switch (response["statusCode"]) {
      case 200:
        print("회원가입 완료");
        Get.snackbar("회원가입 성공", "회원가입 성공");

        break;
      default:
        print("회원가입 실패");
        Get.snackbar("회원가입 실패", "회원가입 실패");
    }
  }
}
