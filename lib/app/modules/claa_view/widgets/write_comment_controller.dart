import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';

import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';
import 'package:polarstar_flutter/app/modules/claa_view/class_view_controller.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class WriteCommentController extends GetxController {
  final ClassRepository repository;
  WriteCommentController({@required this.repository});

  final box = GetStorage();
  final commentRate = 0.obs;
  final languageRate = 0.obs;
  final attitudeRate = 0.obs;
  final examRate = 0.obs;
  final assignmentRate = 0.obs;
  final gradeRate = 0.obs;

  final languageExplain = ["非常差", "较差", "一般", "较好", "非常好"];
  final attitudeExplain = ["非常差", "较差", "一般", "较好", "非常好"];
  final examExplain = ["非常难", "较难", "一般", "较简单", "非常简单"];
  final assignmentExplain = ["非常多", "较多", "一般", "较少", "非常少"];
  final gradeExplain = ["非常差", "较差", "一般", "较好", "非常好"];

  var currentYearSem;

  int writeCommentIndex;
  int writeCommentYear;
  int writeCommentSemester;

  ScrollController writeCommentScrollController;

  List<DropdownMenuItem> yearSemItem = [];

  Future postComment(int CLASS_ID, Map<String, String> data,
      TextEditingController reviewTextController) async {
    MainController mc = Get.find();
    if (data["content"].length < mc.MIN_CLASS_REVIEW_LENGTH.value) {
      Get.snackbar("讲义评价撰写失败", "您撰写的内容过短",
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black);
      return;
    }
    print("??");
    final jsonResponse = await repository.postComment(CLASS_ID, data);

    switch (jsonResponse["statusCode"]) {
      case 200:
        Get.back();

        if (Get.currentRoute != "/class") {
          ClassViewController classViewController = Get.find();
          classViewController.refreshPage();
        }
        reviewTextController.clear();

        // Get.snackbar("강평 작성 완료", "강의평가 작성이 완료되었습니다.",
        //     duration: Duration(seconds: 2),
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.white,
        //     colorText: Colors.black);

        break;
      default:
        print(data["content"].length);
        // print(jsonResponse["statusCode"]);
        Get.snackbar("讲义评价撰写失败", "已经撰写过的讲义评价",
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
    }
  }

  @override
  void onInit() {
    currentYearSem = box.read("year_sem");
    //print(currentYearSem);
    if (currentYearSem["TIMETABLE_SEMESTER_FROM_DATE"] == 1) {
      for (var i = 0; i < 5; i++) {
        yearSemItem.add(DropdownMenuItem(
          child: Text(
            "${currentYearSem["TIMETABLE_YEAR_FROM_DATE"] - ((i + 1) ~/ 2)}学年度 第${i % 2 + 1}学期",
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
            "${currentYearSem["TIMETABLE_YEAR_FROM_DATE"] - (i ~/ 2)}学年度 第${(i + 1) % 2 + 1}学期",
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
