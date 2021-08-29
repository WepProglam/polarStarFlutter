import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';

class ClassViewController extends GetxController {
  final ClassRepository repository;
  ClassViewController({@required this.repository});

  final classViewAvailable = false.obs;

  final typeIndex = 0.obs;

  final classInfo = ClassInfoModel().obs;
  final classReviewList = <ClassReviewModel>[].obs;
  final classExamList = [].obs;

  Future<void> refreshPage() async {
    await getClassView(int.parse(Get.parameters["classid"]));
  }

  Future getClassView(int classid) async {
    final jsonResponse = await repository.getClassView(classid);

    switch (jsonResponse["statusCode"]) {
      case 200:
        classInfo(jsonResponse["classInfo"]);
        classReviewList(jsonResponse["classReview"]);
        classViewAvailable(true);
        break;
      case 400:
        Get.snackbar("400 Error", "class Id가 유효하지 않습니다.");
        classViewAvailable(false);
        printError(info: "Data Fetch ERROR!!");
        break;
      case 404:
        Get.snackbar("400 Error", "없는 class Id 요청입니다.");
        classViewAvailable(false);
        printError(info: "Data Fetch ERROR!!");
        break;
      default:
        classViewAvailable(false);
        printError(info: "Data Fetch ERROR!!");
    }
  }

  @override
  void onInit() async {
    await getClassView(int.parse(Get.parameters["classid"]));

    super.onInit();
  }
}
