import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';

class ClassViewController extends GetxController {
  final ClassRepository repository;
  ClassViewController({@required this.repository});

  final commentRate = 5.obs;
  final teamProjectRate = 5.obs;
  final homeworkRate = 5.obs;
  final examRate = 5.obs;
  final gradeRate = 5.obs;

  final classViewAvailable = false.obs;
  final classExamAvailable = false.obs;

  final typeIndex = 0.obs;

  final classInfo = ClassInfoModel().obs;
  final classReviewList = <ClassReviewModel>[].obs;
  final classExamList = [].obs;

  Future<void> refreshPage() async {
    classViewAvailable(false);
    classExamAvailable(false);
    await getClassView(int.parse(Get.parameters["classid"]));
    await getExamInfo(int.parse(Get.parameters["classid"]));
  }

  Future getClassView(int CLASS_ID) async {
    final jsonResponse = await repository.getClassView(CLASS_ID);

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

  Future getExamInfo(int CLASS_ID) async {
    final jsonResponse = await repository.getClassExam(CLASS_ID);

    switch (jsonResponse["statusCode"]) {
      case 200:
        classExamList(jsonResponse["classExamList"]);
        classExamAvailable(true);
        break;
      case 400:
        Get.snackbar("400 Error", "class Id가 유효하지 않습니다.");
        classExamAvailable(false);
        printError(info: "Data Fetch ERROR!!");
        break;
      case 401:
        Get.snackbar("401 Error", "로그인 X");
        classExamAvailable(false);
        printError(info: "Data Fetch ERROR!!");
        break;
      case 404:
        Get.snackbar("400 Error", "없는 class Id 요청입니다.");
        classExamAvailable(false);
        printError(info: "Data Fetch ERROR!!");
        break;
      default:
        classExamAvailable(false);
        printError(info: "Data Fetch ERROR!!");
    }
  }

  // 좋아요 보내는 함수
  Future<void> getCommentLike(
      int CLASS_ID, int CLASS_COMMENT_ID, int index) async {
    final jsonResponse =
        await repository.getCommentLike(CLASS_ID, CLASS_COMMENT_ID);
    switch (jsonResponse["statusCode"]) {
      case 200:
        classReviewList[index].LIKES++;
        classReviewList.refresh();
        Get.snackbar('좋아요 Ok', 'good');
        break;
      case 400:
        Get.snackbar('400 Error', 'cid 유효하지 않음');
        break;
      case 401:
        Get.snackbar('401 Error', '로그인 안됨');
        break;
      case 403:
        Get.snackbar('403 Error', '이미 좋아요 누른 강평입니다.');
        break;
      case 500:
        Get.snackbar('500 Error', 'failed');
        break;
      default:
    }
  }

  Future<void> getExamLike(
      int CLASS_ID, int CLASS_COMMENT_ID, int index) async {
    final jsonResponse =
        await repository.getExamLike(CLASS_ID, CLASS_COMMENT_ID);

    switch (jsonResponse["statusCode"]) {
      case 200:
        classExamList[index].LIKES++;
        classExamList.refresh();
        Get.snackbar('좋아요 Ok', 'good');
        break;
      case 400:
        Get.snackbar('400 Error', 'cid 유효하지 않음');
        break;
      case 401:
        Get.snackbar('401 Error', '로그인 안됨');
        break;
      case 403:
        Get.snackbar('403 Error', '이미 좋아요 누른 시험 정보입니다.');
        break;
      case 500:
        Get.snackbar('500 Error', 'failed');
        break;
      default:
    }
  }

  @override
  void onInit() async {
    await getClassView(int.parse(Get.parameters["classid"]));

    super.onInit();
  }
}
