import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';

import 'package:polarstar_flutter/app/data/provider/timetable/timetable_provider.dart';

class TimeTableRepository {
  final TimetableApiClient apiClient;

  RxInt selectedYear = 2021.obs;
  RxInt selectedSemester = 3.obs;

  TimeTableRepository({@required this.apiClient}) : assert(apiClient != null);

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
        "statusCode": 200,
        "otherTable": otherTable,
        "selectTable": selectTable,
        "selectYearSemester": selectYearSemester
      };
    }
  }
}
