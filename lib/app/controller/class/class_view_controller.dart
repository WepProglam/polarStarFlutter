import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/controller/class/write_comment_controller.dart';
import 'package:polarstar_flutter/app/ui/android/functions/timetable_semester.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/dialoge.dart';

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
  final RxList classReviewList = <ClassReviewModel>[].obs;
  final RxList commentLikeList = <LikeModel>[].obs;
  final RxList examLikeList = <LikeModel>[].obs;
  final RxList commentAccuseList = <AccuseCommentModel>[].obs;
  final RxList examAccuseList = <AccuseExamModel>[].obs;
  final RxList<dynamic> classExamList = [].obs;

  final RxList<String> exampleList = <String>[].obs;

  ScrollController writeExamInfoScrollController;

  Future<void> refreshPage() async {
    // classViewAvailable(false);
    // classExamAvailable(false);
    await getClassView(int.parse(Get.parameters["CLASS_ID"]));
    await getExamInfo(int.parse(Get.parameters["CLASS_ID"]));
  }

  Future<void> arrestClassCommentFunc(int index) async {
    var ARREST_TYPE = await getArrestType();

    if (ARREST_TYPE == null) {
      return;
    }
    var response = await repository.arrestClassComment(
        classReviewList[index].CLASS_ID,
        classReviewList[index].CLASS_COMMENT_ID,
        ARREST_TYPE);

    switch (response["statusCode"]) {
      case 200:
        Get.defaultDialog(title: "举报成功");
        classReviewList[index].ACCUSE_AMOUNT++;
        classReviewList[index].ALREADY_ACCUSED = true;
        classReviewList.refresh();
        break;
      case 400:
        Get.defaultDialog(title: "举报失败 - 无法举报本人");
        break;
      case 401:
        Get.defaultDialog(title: "举报失败 - 请先登录");
        break;
      case 403:
        Get.defaultDialog(title: "举报失败 - 无法重复举报");
        break;
      case 404:
        Get.defaultDialog(title: "举报失败 - 该内容已被删除");
        break;
      default:
        Get.defaultDialog(title: "举报失败 - ${response["statusCode"]}");
        break;
    }
  }

  Future<void> arrestClassExamFunc(int index) async {
    var ARREST_TYPE = await getArrestType();

    if (ARREST_TYPE == null) {
      return;
    }
    var response = await repository.arrestClassExam(
        classExamList[index].CLASS_ID,
        classExamList[index].CLASS_EXAM_ID,
        ARREST_TYPE);

    print(classExamList[index].CLASS_ID);
    print(classExamList[index].CLASS_EXAM_ID);

    switch (response["statusCode"]) {
      case 200:
        Get.defaultDialog(title: "举报成功");
        classExamList[index].ACCUSE_AMOUNT++;
        classExamList[index].ALREADY_ACCUSED = true;
        classExamList.refresh();
        break;
      case 400:
        Get.defaultDialog(title: "举报失败 - 无法举报本人");
        break;
      case 401:
        Get.defaultDialog(title: "举报失败 - 请先登录");
        break;
      case 403:
        Get.defaultDialog(title: "举报失败 - 无法重复举报");
        break;
      case 404:
        Get.defaultDialog(title: "举报失败 - 该内容已被删除");
        break;
      default:
        Get.defaultDialog(title: "举报失败 - ${response["statusCode"]}");
        break;
    }
  }

  Future getClassView(int CLASS_ID) async {
    // print("asdfasdfasdfadfasdf");
    final jsonResponse = await repository.getClassView(CLASS_ID);
    // print(jsonResponse["statusCode"]);

    switch (jsonResponse["statusCode"]) {
      case 200:
        classInfo(jsonResponse["classInfo"]);
        classReviewList(jsonResponse["classReview"]);
        commentLikeList(jsonResponse["commentLikeList"]);
        examLikeList(jsonResponse["examLikeList"]);
        commentAccuseList(jsonResponse["commentAccuseList"]);
        examAccuseList(jsonResponse["examAccuseList"]);
        print(examLikeList);

//이미 좋아요나 신고 했는지 체크
        for (int i = 0; i < classReviewList.length; i++) {
          classReviewList[i].ALREADY_LIKED = false;
          classReviewList[i].ALREADY_ACCUSED = false;
          for (int j = 0; j < commentLikeList.length; j++) {
            if (classReviewList[i].CLASS_COMMENT_ID ==
                commentLikeList[j].UNIQUE_ID) {
              classReviewList[i].ALREADY_LIKED = true;
              break;
            }
          }
          for (int j = 0; j < commentAccuseList.length; j++) {
            if (classReviewList[i].CLASS_COMMENT_ID ==
                commentAccuseList[j].CLASS_COMMENT_ID) {
              classReviewList[i].ALREADY_ACCUSED = true;
              break;
            }
          }
        }
        classReviewList.refresh();
        classViewAvailable(true);

        break;
      case 400:
        Get.snackbar("400 Error", "该数据无效",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        classViewAvailable(false);
        printError(info: "Data Fetch ERROR!!");
        break;
      case 404:
        Get.snackbar("404 Error", "该数据无效",
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

        print(classExamList.length);
        print("===========================");
        for (int i = 0; i < classExamList.length; i++) {
          classExamList[i].ALREADY_LIKED = false;
          classExamList[i].ALREADY_ACCUSED = false;
          print(classExamList[i].CLASS_EXAM_ID);
          print("===========================");
          print(examLikeList);
          for (int j = 0; j < examLikeList.length; j++) {
            print(examLikeList[j].UNIQUE_ID);
            if (classExamList[i].CLASS_EXAM_ID == examLikeList[j].UNIQUE_ID) {
              print("askdjhnaskjndkjansdasd");
              classExamList[i].ALREADY_LIKED = true;
              break;
            }
          }
          for (int j = 0; j < examAccuseList.length; j++) {
            if (classExamList[i].CLASS_EXAM_ID ==
                examAccuseList[j].CLASS_EXAM_ID) {
              classExamList[i].ALREADY_ACCUSED = true;
              break;
            }
          }
        }
        classExamList.refresh();
        classExamAvailable(true);

        break;
      case 400:
        Get.snackbar("400 Error", "该数据无效",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        classExamAvailable(false);
        printError(info: "Data Fetch ERROR!!");
        break;
      case 401:
        Get.snackbar("401 Error", "未登录",
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
        classReviewList[index].ALREADY_LIKED = true;
        classReviewList.refresh();
        Get.snackbar('200', '您已点赞成功',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 400:
        Get.snackbar('400 Error', '该数据无效',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 401:
        Get.snackbar('401 Error', '未登录',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 403:
        Get.snackbar('403 Error', '您已经点过赞了',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 500:
        Get.snackbar('500 Error', '服务器错误',
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
        classExamList[index].ALREADY_LIKED = true;
        classExamList.refresh();
        Get.snackbar('200', '您已点赞成功',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 400:
        Get.snackbar('400 Error', '该数据无效',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 401:
        Get.snackbar('401 Error', '未登录',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 403:
        Get.snackbar('403 Error', '您已经点过赞了',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      case 500:
        Get.snackbar('500 Error', '服务器错误',
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
        Get.snackbar("考试信息撰写失败", "考试信息撰写失败",
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
      // Get.snackbar("구매 실패", "시험정보 구매 실패",
      //     duration: Duration(seconds: 2),
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.white,
      //     colorText: Colors.black);
    }
  }

  @override
  void onInit() async {
    //print(Get.parameters["CLASS_ID"]);
    await getClassView(int.parse(Get.parameters["CLASS_ID"]));
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
            "${currentYearSem["TIMETABLE_YEAR_FROM_DATE"] - (i + 1) ~/ 2}学年度 第${i % 2 + 1}学期",
            //! 함수 괜히 바꿨다가 버그날까봐 이렇게함
            // "${timetableSemChanger(currentYearSem["TIMETABLE_YEAR_FROM_DATE"] - (i + 1) ~/ 2, i % 2 + 1)}",
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
            "${currentYearSem["TIMETABLE_YEAR_FROM_DATE"] - i ~/ 2}년도 ${(i + 1) % 2 + 1}학기",
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
