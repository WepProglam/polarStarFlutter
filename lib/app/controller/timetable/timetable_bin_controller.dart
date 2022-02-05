import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_bin_repository.dart';

import 'package:polarstar_flutter/session.dart';

class TimeTableBinController extends GetxController {
  final TimeTableBinRepository repository;
  final TimeTableController timeTableController = Get.find();
  TimeTableBinController({@required this.repository});

  RxMap<String, RxList<Rx<TimeTableModel>>> tempTimeTables =
      <String, RxList<Rx<TimeTableModel>>>{}.obs;
  List<TimeTableModel> tempModels;

  Future getAllTable() async {
    var response = await Session().getX("/timetable/list");
    Iterable timetables = jsonDecode(response.body);
    tempModels = timetables.map((e) => TimeTableModel.fromJson(e)).toList();
    for (TimeTableModel item in tempModels) {
      if (tempTimeTables.containsKey("${item.YEAR}년 ${item.SEMESTER}학기")) {
        tempTimeTables["${item.YEAR}년 ${item.SEMESTER}학기"].add(item.obs);
      } else {
        tempTimeTables["${item.YEAR}년 ${item.SEMESTER}학기"] = [item.obs].obs;
      }
    }

    // tempTimeTables.keys.forEach((element) {
    //   timeTableController.otherTable.value = tempTimeTables.value;
    // });
    print(timeTableController.otherTable.toString());
  }

  Future<void> checkIsVisited() async {
    print(timeTableController.visitedBin);
    if (!timeTableController.visitedBin) {
      await getAllTable();
      timeTableController.visitedBin = true;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await checkIsVisited();
  }
}
