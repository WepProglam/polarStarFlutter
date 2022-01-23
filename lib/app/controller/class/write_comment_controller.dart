import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';
import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/ui/android/class/class_view.dart';

class WriteCommentController extends GetxController {
  final ClassRepository repository;
  WriteCommentController({@required this.repository});

  final box = GetStorage();

  final commentRate = 5.obs;
  final languageRate = 5.obs;
  final attitudeRate = 5.obs;
  final examRate = 5.obs;
  final assignmentRate = 5.obs;
  final gradeRate = 5.obs;

  var currentYearSem;

  int writeCommentIndex;
  int writeCommentYear;
  int writeCommentSemester;

  ScrollController writeCommentScrollController;

  List<DropdownMenuItem> yearSemItem = [];

  Future postComment(int CLASS_ID, Map<String, String> data) async {
    final jsonResponse = await repository.postComment(CLASS_ID, data);

    switch (jsonResponse["statusCode"]) {
      case 200:
        Get.back();

        if (Get.currentRoute != "/class") {
          ClassViewController classViewController = Get.find();
          classViewController.refreshPage();
        }

        // Get.snackbar("강평 작성 완료", "강의평가 작성이 완료되었습니다.",
        //     duration: Duration(seconds: 2),
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.white,
        //     colorText: Colors.black);

        break;
      default:
        print(jsonResponse["statusCode"]);
        Get.snackbar("강평 작성 실패", "Failed",
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
    }
  }

  @override
  void onInit() {
    currentYearSem = box.read("year_sem");
    print(currentYearSem);
    if (currentYearSem["TIMETABLE_SEMESTER_FROM_DATE"] == 1) {
      for (var i = 0; i < 5; i++) {
        yearSemItem.add(DropdownMenuItem(
          child: Text(
            "${currentYearSem["TIMETABLE_YEAR_FROM_DATE"] - i}년도 ${i % 2 + 1}학기",
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

    writeCommentScrollController = ScrollController(initialScrollOffset: 0.0);

    super.onInit();
  }
}
