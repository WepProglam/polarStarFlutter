import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';

class WriteCommentController extends GetxController {
  final ClassRepository repository;
  WriteCommentController({@required this.repository});

  final commentRate = 5.obs;
  final teamProjectRate = 5.obs;
  final assignmentRate = 5.obs;
  final examRate = 5.obs;
  final gradeRate = 5.obs;

  final writeCommentSemester = 0.obs;

  Future postComment(int CLASS_ID, Map data) async {
    final jsonResponse = await repository.postComment(CLASS_ID, data);

    switch (jsonResponse["statusCode"]) {
      case 200:
        Get.snackbar("강평 작성 완료", "강의평가 작성이 완료되었습니다.",
            duration: Duration(seconds: 2));
        Get.back();

        break;
      default:
        print(jsonResponse["statusCode"]);
        Get.snackbar("강평 작성 실패", "Failed", duration: Duration(seconds: 2));
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
