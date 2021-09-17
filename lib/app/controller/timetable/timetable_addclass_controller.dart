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
