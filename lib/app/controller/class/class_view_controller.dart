import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/controller/class/write_comment_controller.dart';
import 'package:polarstar_flutter/app/ui/android/functions/timetable_semester.dart';

class ClassViewController extends GetxController
    with SingleGetTickerProviderMixin {
  final ClassRepository repository;
  ClassViewController({@required this.repository});

  final box = GetStorage();

  // final commentRate = 5.obs;
  // final teamProjectRate = 5.obs;
  // final assignmentRate = 5.obs;
  // final examRate = 5.obs;
  // final gradeRate = 5.obs;

  // final writeCommentSemester = 0.obs;

  final examIndex = 0.obs;
  final questionTypeIndex = 0.obs;

  final List<String> examList = ["期中考试", "期末考试"];
  final List<String> questionTypeList = [
    "选择题",
    "判断题",
    "填空题",
    "简答题",
    "论述题",
    "其它"
  ];

  var currentYearSem;
  int writeCommentIndex;
  int writeExamInfoYear;
  int writeExamInfoSemester;
  List<DropdownMenuItem> yearSemItem = [];

  final classViewAvailable = false.obs;
  final classExamAvailable = false.obs;

  TabController tabController;
  // final typeIndex = 0.obs;

  final classInfo = ClassInfoModel().obs;
  final classReviewList = <ClassReviewModel>[].obs;
  final classExamList = [].obs;

  final RxList<String> exampleList = <String>[].obs;

  ScrollController writeExamInfoScrollController;

  Future<void> refreshPage() async {
    // classViewAvailable(false);
    // classExamAvailable(false);
    await getClassView(int.parse(Get.parameters["CLASS_ID"]));
    await getExamInfo(int.parse(Get.parameters["CLASS_ID"]));
  }

  Future getClassView(int CLASS_ID) async {
    // print("asdfasdfasdfadfasdf");
    final jsonResponse = await repository.getClassView(CLASS_ID);
    // print(jsonResponse["statusCode"]);

    switch (jsonResponse["statusCode"]) {
      case 200:
        classInfo(jsonResponse["classInfo"]);
        classReviewList(jsonResponse["classReview"]);
        classViewAvailable(true);

        break;
      case 400:
        Get.snackbar("400 Error", "class Id가 유효하지 않습니다.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        classViewAvailable(false);
        printError(info: "Data Fetch ERROR!!");
        break;
      case 404:
        Get.snackbar("400 Error", "없는 class Id 요청입니다.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
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
        Get.snackbar("400 Error", "class Id가 유효하지 않습니다.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        classExamAvailable(false);
        printError(info: "Data Fetch ERROR!!");
        break;
      case 401:
        Get.snackbar("401 Error", "로그인 X",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        classExamAvailable(false);
        printError(info: "Data Fetch ERROR!!");
        break;
      case 404:
        // Get.snackbar("400 Error", "없는 class Id 요청입니다.");
        classExamAvailable(true);
        // printError(info: "Data Fetch ERROR!!");
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
        Get.snackbar('좋아요 Ok', 'good',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 400:
        Get.snackbar('400 Error', 'cid 유효하지 않음',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 401:
        Get.snackbar('401 Error', '로그인 안됨',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 403:
        Get.snackbar('403 Error', '이미 좋아요 누른 강평입니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 500:
        Get.snackbar('500 Error', 'failed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
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
        Get.snackbar('좋아요 Ok', 'good',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 400:
        Get.snackbar('400 Error', 'cid 유효하지 않음',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 401:
        Get.snackbar('401 Error', '로그인 안됨',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 403:
        Get.snackbar('403 Error', '이미 좋아요 누른 시험 정보입니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 500:
        Get.snackbar('500 Error', 'failed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      default:
    }
  }

  // Future postComment(int CLASS_ID, Map data) async {
  //   final jsonResponse = await repository.postComment(CLASS_ID, data);

  //   switch (jsonResponse["statusCode"]) {
  //     case 200:
  //       Get.snackbar("강평 작성 완료", "강의평가 작성이 완료되었습니다.",
  //           duration: Duration(seconds: 2));
  //       Get.back();

  //       break;
  //     default:
  //       print(jsonResponse["statusCode"]);
  //       Get.snackbar("강평 작성 실패", "Failed", duration: Duration(seconds: 2));
  //   }
  // }

  Future postExam(int CLASS_ID, Map<String, dynamic> data) async {
    final jsonResponse = await repository.postExam(CLASS_ID, data);

    switch (jsonResponse["statusCode"]) {
      case 200:
        Get.back();
        await refreshPage();
        // Get.snackbar("시험정보 작성 완료", "시험정보 작성이 완료되었습니다.",
        //     duration: Duration(seconds: 2));
        break;
      default:
        //  print(jsonResponse["statusCode"]);
        Get.snackbar("시험정보 작성 실패", "Failed",
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
    }
  }

  Future buyExamInfo(int CLASS_ID, int CLASS_EXAM_ID) async {
    final jsonResponse = await repository.buyExamInfo(CLASS_ID, CLASS_EXAM_ID);

    switch (jsonResponse["statusCode"]) {
      case 200:
        // Get.snackbar("구매 성공", "시험정보 구매 성공",
        //     duration: Duration(seconds: 2),
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.white,
        //     colorText: Colors.black);
        refreshPage();
        break;
      default:
        Get.snackbar("구매 실패", "시험정보 구매 실패",
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
    }
  }

  @override
  void onInit() async {
    //print(Get.parameters["CLASS_ID"]);
    getClassView(int.parse(Get.parameters["CLASS_ID"]));
    getExamInfo(int.parse(Get.parameters["CLASS_ID"]));
    tabController = TabController(vsync: this, length: 2);
    // tabController.addListener(() {
    //   if (!tabController.indexIsChanging) {
    //     typeIndex(tabController.index);
    //     print(typeIndex.value);
    //   }
    // });

    currentYearSem = box.read("year_sem");
    print(currentYearSem);
    if (currentYearSem["TIMETABLE_SEMESTER_FROM_DATE"] == 1) {
      for (var i = 0; i < 5; i++) {
        yearSemItem.add(DropdownMenuItem(
          child: Text(
            "${timetableSemChanger(currentYearSem["TIMETABLE_YEAR_FROM_DATE"] - i, i % 2 + 1)}",
            style: const TextStyle(
                color: const Color(0xff6f6e6e),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSansSC",
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
            textAlign: TextAlign.left,
          ),
          value: i,
        ));
      }
    } else {
      for (var i = 0; i < 6; i++) {
        yearSemItem.add(DropdownMenuItem(
          child: Text(
            "${currentYearSem["TIMETABLE_YEAR_FROM_DATE"] - i}년도 ${(i + 1) % 2 + 1}학기",
            style: const TextStyle(
                color: const Color(0xff6f6e6e),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSansSC",
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
            textAlign: TextAlign.left,
          ),
          value: i,
        ));
      }
    }

    writeExamInfoScrollController = ScrollController(initialScrollOffset: 0.0);

    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<WriteCommentController>();

    super.onClose();
  }
}
