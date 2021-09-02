import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';

class TimeTableController extends GetxController {
  final TimeTableRepository repository;
  TimeTableController({@required this.repository});

  final dataAvailable = false.obs;
  RxList<Rx<TimeTableModel>> otherTable = <Rx<TimeTableModel>>[].obs;
  Rx<SelectedTimeTableModel> selectTable = SelectedTimeTableModel().obs;
  Rx<selectYearSemesterModel> selectYearSemester =
      selectYearSemesterModel().obs;

  Future<void> refreshPage() async {
    await getCurrentTimeTable();
  }

  Future getCurrentTimeTable() async {
    Map<String, dynamic> jsonResponse = await repository.getCurrentTimeTable();

    switch (jsonResponse["statusCode"]) {
      case 200:
        otherTable.value = jsonResponse["otherTable"];
        selectTable.value = jsonResponse["selecTable"];
        selectYearSemester.value = jsonResponse["selectYearSemester"];
        dataAvailable(true);
        break;
      default:
        dataAvailable(false);
        printError(info: "Data Fetch ERROR!!");
    }
  }

  @override
  void onInit() async {
    await getCurrentTimeTable();
    super.onInit();
  }
}
