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

        Get.back();
        await Get.snackbar("회원가입 성공", "회원가입 성공");

        break;
      default:
        print("회원가입 실패");
        Get.snackbar("회원가입 실패", "회원가입 실패");
    }
  }

  Future IDTest(String id) async {
    Map<String, String> data = {"id": id};

    final response = await repository.IDTest(data);

    switch (response["statusCode"]) {
      case 200:
        print("ID not duplicate");
        Get.snackbar("ID not duplicate", "ID not duplicate");

        break;
      default:
        print("ID duplicate");
        Get.snackbar("ID duplicate", "ID duplicate");
    }
  }

  Future emailAuthRequest(String email) async {
    Map<String, String> data = {"email": email};

    final response = await repository.emailAuthRequest(data);

    switch (response["statusCode"]) {
      case 200:
        print("emailAuthRequest 성공");
        Get.snackbar("emailAuthRequest 성공", "emailAuthRequest 성공");

        break;
      default:
        print("emailAuthRequest 실패");
        Get.snackbar("emailAuthRequest 실패", "emailAuthRequest 실패");
    }
  }

  Future emailAuthVerify(String email, String code) async {
    Map<String, String> data = {"email": email, "code": code};

    final response = await repository.emailAuthVerify(data);

    switch (response["statusCode"]) {
      case 200:
        print("emailAuthVerify 성공");
        Get.snackbar("emailAuthVerify 성공", "emailAuthVerify 성공");

        break;
      default:
        print("emailAuthRequest 실패");
        Get.snackbar("emailAuthVerify 실패", "emailAuthVerify 실패");
    }
  }
}
