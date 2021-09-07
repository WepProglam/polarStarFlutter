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

  // 학기별 시간표 간략 정보 리스트
  Map<String, RxList<Rx<TimeTableModel>>> otherTable =
      <String, RxList<Rx<TimeTableModel>>>{}.obs;

  //(선택된) 세부 정보 시간표
  Rx<SelectedTimeTableModel> selectTable = SelectedTimeTableModel().obs;

  // 고유번호 별 세부 정보 시간표 리스트
  RxList<SelectedTimeTableModel> selectTableList =
      <SelectedTimeTableModel>[].obs;

  // 고유번호 인덱스
  RxInt selectedTimeTableId = 0.obs;

  // 학기별 디폴트 시간표 리스트
  Map<String, Rx<SelectedTimeTableModel>> defaultTableList =
      <String, Rx<SelectedTimeTableModel>>{}.obs;

  //  디폴트 시간표들의 간략 정보 리스트
  RxList<SelectYearSemesterModel> selectYearSemester =
      <SelectYearSemesterModel>[].obs;

  // 디폴트 시간표 선택용 인덱스
  RxInt yearSemesterIndex = 0.obs;

  RxList<List<Map<String, dynamic>>> showTimeTable =
      <List<Map<String, dynamic>>>[[], [], [], [], [], [], []].obs;
  final List<Color> colorList = [
    Color(0xfff78773),
    Color(0xfff0c26c),
    Color(0xffadc972),
    Color(0xff7ba5ef),
    Color(0xff9c87e6),
    Color(0xff9c87e6)
  ];
  void makeShowTimeTable() {
    int colorIndex = 0;
    for (var item in selectTable.value.CLASSES) {
      for (var detail in item.classes) {
        int day_index = getIndexFromDay(detail.day);
        List start = detail.start_time.split(":");
        int startTime = int.parse(start[0]) * 60 + int.parse(start[1]);

        List end = detail.end_time.split(":");
        int endTime = int.parse(end[0]) * 60 + int.parse(end[1]);
        showTimeTable[day_index].add({
          "start_time": startTime,
          "end_time": endTime,
          "classInfo": item,
          "color": colorList[colorIndex % 6]
        });
      }
      colorIndex += 1;
    }
  }

  void initShowTimeTable() {
    showTimeTable.value = [[], [], [], [], [], [], []];
  }

  Future<void> refreshPage() async {
    await getSemesterTimeTable("2021", "3");
  }

  Future getSemesterTimeTable(String YEAR, String SEMESTER) async {
    if (need_download_semester(YEAR, SEMESTER)) {
      dataAvailable(false);

      Map<String, dynamic> jsonResponse =
          await repository.getSemesterTimeTable(YEAR, SEMESTER);

      switch (jsonResponse["statusCode"]) {
        case 200:
          otherTable["${YEAR}년 ${SEMESTER}학기"] = jsonResponse["otherTable"];

          //디폴트인 순서대로 정렬
          otherTable["${YEAR}년 ${SEMESTER}학기"]
              .sort((a, b) => b.value.IS_DEFAULT.compareTo(a.value.IS_DEFAULT));

          selectTable = jsonResponse["defaultTable"];

          selectedTimeTableId.value = selectTable.value.TIMETABLE_ID;

          defaultTableList["${YEAR}년 ${SEMESTER}학기"] = selectTable;

          selectTableList.add(jsonResponse["defaultTable"].value);

          dataAvailable(true);
          break;
        default:
          dataAvailable(false);
          printError(info: "Data Fetch ERROR!!");
      }
    } else {
      dataAvailable(false);

      selectTable = defaultTableList["${YEAR}년 ${SEMESTER}학기"];
      selectedTimeTableId.value = selectTable.value.TIMETABLE_ID;

      dataAvailable(true);
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

  bool need_download_semester(String YEAR, String SEMESTER) {
    if (otherTable["${YEAR}년 ${SEMESTER}학기"] != null) {
      print("false");
      return false;
    }
    print("true");
    return true;
  }

  bool need_download_tableId() {
    bool needDownload = true;
    for (var item in selectTableList) {
      if (item.TIMETABLE_ID == selectedTimeTableId.value) {
        selectTable.value = item;
        needDownload = false;
        break;
      }
    }
    return needDownload;
  }

  Future getTableInfo() async {
    var response = await Session().getX("/timetable");
    Iterable tableInfoJson = jsonDecode(response.body);
    print(tableInfoJson);
    selectYearSemester.value =
        tableInfoJson.map((e) => SelectYearSemesterModel.fromJson(e)).toList();

    print(selectYearSemester.length);
  }

  @override
  void onInit() async {
    super.onInit();
    await getTableInfo();

    if (selectYearSemester.length > 0) {
      await getSemesterTimeTable(
          "${selectYearSemester[0].YEAR}", "${selectYearSemester[0].SEMESTER}");
      initShowTimeTable();
      makeShowTimeTable();
    }

    ever(selectedTimeTableId, (_) async {
      print("인덱스 변경 ${selectedTimeTableId.value}");
      bool needDownload = need_download_tableId();
      if (needDownload) {
        print("need Download ${selectedTimeTableId.value}!");
        await getTimeTable(selectedTimeTableId.value);
      }
      initShowTimeTable();
      makeShowTimeTable();
    });
  }

  String get yearSem =>
      "${selectYearSemester[yearSemesterIndex.value].YEAR}년 ${selectYearSemester[yearSemesterIndex.value].SEMESTER}학기";
}

int getIndexFromDay(String day) {
  int index = 0;
  switch (day) {
    case "월요일":
      index = 0;
      break;
    case "화요일":
      index = 1;
      break;
    case "수요일":
      index = 2;
      break;
    case "목요일":
      index = 3;
      break;
    case "금요일":
      index = 4;
      break;
    case "토요일":
      index = 5;
      break;
    case "일요일":
      index = 6;
      break;
    default:
      index = 0;
      break;
  }
  return index;
}
