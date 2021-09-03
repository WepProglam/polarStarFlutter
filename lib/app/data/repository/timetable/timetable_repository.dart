import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';

import 'package:polarstar_flutter/app/data/provider/timetable/timetable_provider.dart';

class TimeTableRepository {
  final TimetableApiClient apiClient;

  TimeTableRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getTimeTable(int TIMETABLE_ID) async {
    final response = await apiClient.getTimeTable(TIMETABLE_ID);

    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      var jsonResponse = jsonDecode(response.body);

      Rx<SelectedTimeTableModel> selectTable =
          SelectedTimeTableModel.fromJson(jsonResponse).obs;

      return {
        "statusCode": response.statusCode,
        "selectTable": selectTable,
      };
    }
  }

  Future<Map<String, dynamic>> getSemesterTimeTable(
      int YEAR, int SEMESTER) async {
    final response = await apiClient.getSemesterTimeTable(YEAR, SEMESTER);

    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      var jsonResponse = jsonDecode(response.body);

      // Map List를 Class model List로 만듦
      Iterable otherTableJson = jsonResponse["other"];
      var defaultTableJson = jsonResponse["default"];
      var selectYearSemesterJson = jsonResponse["info"];

      RxList<Rx<TimeTableModel>> otherTable = otherTableJson
          .map((e) => TimeTableModel.fromJson(e).obs)
          .toList()
          .obs;

      Rx<SelectedTimeTableModel> defaultTable =
          SelectedTimeTableModel.fromJson(defaultTableJson).obs;

      selectYearSemesterModel selectYearSemester =
          selectYearSemesterModel.fromJson(selectYearSemesterJson);

      return {
        "statusCode": response.statusCode,
        "otherTable": otherTable,
        "defaultTable": defaultTable,
        "selectYearSemester": selectYearSemester
      };
    }
  }

  Future<Map<String, dynamic>> getCurrentTimeTable() async {
    final response = await apiClient.getCurrentTimeTable();

    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      var jsonResponse = jsonDecode(response.body);

      // Map List를 Class model List로 만듦
      Iterable otherTableJson = jsonResponse["other"];
      var defaultTableJson = jsonResponse["default"];
      var selectYearSemesterJson = jsonResponse["info"];

      List<Rx<TimeTableModel>> otherTable =
          otherTableJson.map((e) => TimeTableModel.fromJson(e).obs).toList();

      SelectedTimeTableModel selectTable =
          SelectedTimeTableModel.fromJson(defaultTableJson);

      selectYearSemesterModel selectYearSemester =
          selectYearSemesterModel.fromJson(selectYearSemesterJson);

      return {
        "statusCode": response.statusCode,
        "otherTable": otherTable,
        "selectTable": selectTable,
        "selectYearSemester": selectYearSemester
      };
    }
  }
}
