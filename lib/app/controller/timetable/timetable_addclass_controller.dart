import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';

import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';

class TimeTableAddClassController extends GetxController {
  final TimeTableAddClassRepository repository;
  TimeTableAddClassController({@required this.repository});

  Rx<TimeTableClassModel> TOTAL_CLASS = TimeTableClassModel().obs;

  RxList<Rx<AddClassModel>> CLASS_LIST = <Rx<AddClassModel>>[].obs;

  RxInt selectIndex = 0.obs;

  RxBool dataAvailable = false.obs;

  void initClass() {
    Rx<AddClassModel> tmp = AddClassModel.fromJson({
      "day": "월요일",
      "start_time": "9:0",
      "end_time": "10:0",
    }).obs;

    CLASS_LIST.add(tmp);
  }

  @override
  void onInit() async {
    super.onInit();
    initClass();
    dataAvailable.value = true;

    ever(selectIndex, (_) {
      if (CLASS_LIST[selectIndex.value] != null) {
      } else {
        initClass();
      }
    });
  }
}
