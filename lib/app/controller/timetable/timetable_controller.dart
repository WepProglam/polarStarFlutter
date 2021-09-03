import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/session.dart';

class TimeTableController extends GetxController {
  final TimeTableRepository repository;
  TimeTableController({@required this.repository});

  final dataAvailable = false.obs;
  RxInt selectedTimeTableId = 0.obs;

  Map<String, RxList<Rx<TimeTableModel>>> otherTable =
      <String, RxList<Rx<TimeTableModel>>>{}.obs;
  Rx<SelectedTimeTableModel> selectTable = SelectedTimeTableModel().obs;

  RxList<SelectedTimeTableModel> selectTableList =
      <SelectedTimeTableModel>[].obs;

  Map<String, Rx<SelectedTimeTableModel>> defaultTableList =
      <String, Rx<SelectedTimeTableModel>>{}.obs;

  RxList<SelectYearSemesterModel> selectYearSemester =
      <SelectYearSemesterModel>[].obs;
  RxInt yearSemesterIndex = 0.obs;

  Future<void> refreshPage() async {
    await getSemesterTimeTable("2021", "3");
  }

  Future getSemesterTimeTable(String YEAR, String SEMESTER) async {
    Map<String, dynamic> jsonResponse =
        await repository.getSemesterTimeTable(YEAR, SEMESTER);

    switch (jsonResponse["statusCode"]) {
      case 200:
        otherTable["${YEAR}-${SEMESTER}"] = jsonResponse["otherTable"];
        defaultTableList["${YEAR}-${SEMESTER}"] = selectTable;

        selectTable = jsonResponse["defaultTable"];
        selectTableList.add(jsonResponse["defaultTable"].value);

        dataAvailable(true);
        break;
      default:
        dataAvailable(false);
        printError(info: "Data Fetch ERROR!!");
    }
  }

  Future getTimeTable(int TIMETABLE_ID) async {
    dataAvailable.value = false;

    Map<String, dynamic> jsonResponse =
        await repository.getTimeTable(TIMETABLE_ID);

    switch (jsonResponse["statusCode"]) {
      case 200:
        selectTable = jsonResponse["selectTable"];
        selectTableList.add(jsonResponse["selectTable"].value);
        dataAvailable(true);
        break;
      default:
        dataAvailable(false);
        printError(info: "Data Fetch ERROR!!");
    }
  }

  Future getTableInfo() async {
    var response = await Session().getX("/timetable");
    Iterable tableInfoJson = jsonDecode(response.body);
    print(tableInfoJson);
    selectYearSemester.value =
        tableInfoJson.map((e) => SelectYearSemesterModel.fromJson(e)).toList();
  }

  @override
  void onInit() async {
    super.onInit();
    await getTableInfo();
    await getSemesterTimeTable(
        "${selectYearSemester[0].YEAR}", "${selectYearSemester[0].SEMESTER}");

    ever(selectedTimeTableId, (_) {
      bool needDownload = true;
      for (var item in selectTableList) {
        if (item.TIMETABLE_ID == selectedTimeTableId.value) {
          selectTable.value = item;
          needDownload = false;
          break;
        }
      }

      if (needDownload) {
        print("need Download ${selectedTimeTableId.value}!");
        getTimeTable(selectedTimeTableId.value);
      }
    });
  }

  String get yearSem =>
      "${selectYearSemester[yearSemesterIndex.value].YEAR}-${selectYearSemester[yearSemesterIndex.value].SEMESTER}";
}
