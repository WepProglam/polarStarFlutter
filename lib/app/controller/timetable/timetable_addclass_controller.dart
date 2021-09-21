import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';

import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/session.dart';

class TimeTableAddClassController extends GetxController {
  final TimeTableAddClassRepository repository;

  final TimeTableController timeTableController = Get.find();

  TimeTableAddClassController({@required this.repository});

  Rx<TimeTableClassModel> TOTAL_CLASS = TimeTableClassModel().obs;

  RxList<Rx<AddClassModel>> CLASS_LIST = <Rx<AddClassModel>>[].obs;

  RxInt selectIndex = 0.obs;

  RxBool dataAvailable = false.obs;

  RxList<TextEditingController> classLocationController =
      <TextEditingController>[].obs;

  TextEditingController courseNameController = new TextEditingController();

  TextEditingController professorNameController = new TextEditingController();

  Future<void> addClass(int tid) async {
    TOTAL_CLASS.update((val) {
      val.classes = CLASS_LIST.map((element) => element.value).toList();
    });

    Map<String, dynamic> data = TOTAL_CLASS.toJson();

    await Session().postX("/timetable/tid/${tid}", data);

    timeTableController.selectTable.update((val) {
      val.CLASSES.add(TOTAL_CLASS.value);
    });
    timeTableController.initShowTimeTable();
    timeTableController.makeShowTimeTable();
  }

  void initClass() {
    Rx<AddClassModel> tmp = AddClassModel.fromJson({
      "day": "월요일",
      "start_time": "09:00",
      "end_time": "10:00",
    }).obs;
    classLocationController.add(new TextEditingController());

    CLASS_LIST.add(tmp);
  }

  bool checkClassValidate() {
    List<List<AddClassModel>> curClasses = timeTableController
        .selectTable.value.CLASSES
        .map((e) => e.classes)
        .toList();
    for (var CurClass in curClasses) {
      for (var item in CurClass) {
        for (var new_item in CLASS_LIST) {
          if (new_item.value.day != item.day) {
            continue;
          }
          bool afterClass = ((new_item.value.start_time
                      .isAfter(item.start_time) ||
                  new_item.value.start_time
                      .isAtSameMomentAs(item.start_time)) &&
              (new_item.value.start_time.isAfter(item.end_time) ||
                  new_item.value.start_time.isAtSameMomentAs(item.end_time)));

          bool beforeClass = ((new_item.value.end_time
                      .isBefore(item.start_time) ||
                  new_item.value.end_time.isAtSameMomentAs(item.start_time)) &&
              (new_item.value.end_time.isBefore(item.end_time) ||
                  new_item.value.end_time.isAtSameMomentAs(item.end_time)));

          bool innerCheck =
              new_item.value.start_time.isBefore(new_item.value.end_time);

          //한 수업에 대해 시작과 끝 시간이 모두 이르거나 느린 경우 통과
          bool checkItOut = (afterClass || beforeClass) && innerCheck;

          if (!checkItOut) {
            return false;
          }
        }
      }
    }
    return true;
  }

  @override
  void onInit() async {
    super.onInit();
    initClass();
    dataAvailable.value = true;
    ever(CLASS_LIST, (_) {
      for (var item in CLASS_LIST) {
        print(item.value.day);
        print(item.value.start_time);
        print(item.value.end_time);
      }
    });

    ever(selectIndex, (_) {
      if (CLASS_LIST.length > selectIndex.value) {
      } else {
        initClass();
      }
    });
  }
}
