import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';

import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/timetable_daytoindex.dart';
import 'package:polarstar_flutter/session.dart';

class TimeTableController extends GetxController {
  final TimeTableRepository repository;
  TimeTableController({@required this.repository});

  final dataAvailable = false.obs;
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);
  bool visitedBin = false;

  RxBool logoHidden = true.obs;
  RxBool isReady = false.obs;

  RxBool isExpandedHor = false.obs;
  RxInt limitStartTime = 9.obs;
  RxInt limitEndTime = 17.obs;

  RxInt verAmount = 9.obs;

  RxBool isHidden = false.obs;
  RxBool inTimeTableMainPage = true.obs;

  // RxDouble topHeight = 44.0.obs;
  // RxDouble timeHeight = 60.0.obs;

  RxDouble topHeight = 30.0.obs;
  RxDouble timeHeight = 55.0.obs;

  // 학기별 시간표 간략 정보 리스트
  RxMap<String, RxList<Rx<TimeTableModel>>> otherTable =
      <String, RxList<Rx<TimeTableModel>>>{}.obs;

  //(선택된) 세부 정보 시간표
  Rx<SelectedTimeTableModel> selectTable = SelectedTimeTableModel().obs;

  // 고유번호 별 세부 정보 시간표 리스트
  List<SelectedTimeTableModel> selectTableList = <SelectedTimeTableModel>[];

  // 고유번호 인덱스
  RxInt selectedTimeTableId = 0.obs;

  // 학기별 디폴트 시간표 리스트
  Map<String, Rx<SelectedTimeTableModel>> defaultTableList =
      <String, Rx<SelectedTimeTableModel>>{}.obs;

  //  디폴트 시간표들의 간략 정보 리스트
  RxList<Rx<SelectYearSemesterModel>> selectYearSemester =
      <Rx<SelectYearSemesterModel>>[].obs;

  // 디폴트 시간표 선택용 인덱스
  RxInt yearSemesterIndex = 0.obs;

  RxList<RxList<Map<String, dynamic>>> showTimeTable =
      <RxList<Map<String, dynamic>>>[
    <Map<String, dynamic>>[].obs,
    <Map<String, dynamic>>[].obs,
    <Map<String, dynamic>>[].obs,
    <Map<String, dynamic>>[].obs,
    <Map<String, dynamic>>[].obs,
    <Map<String, dynamic>>[].obs,
    <Map<String, dynamic>>[].obs,
  ].obs;

  RxString addTimeTableYearSem = "".obs;

  List<String> addTimeTableYearSemList = [
    //"2021년 겨울학기",
    "2022学年度 第1学期",
    // "2022学年度 第2学期",
    // "2022년 여름학기",
    // "2022년 2학기",
    // "2022년 겨울학기",
  ];

  RxString createYear = "".obs;
  RxString createSemester = "".obs;
  RxString createName = "".obs;

  // RxString createTimeTableYear = "".obs;
  // RxString createTimeTableSemester ="".obs;

  final List<Color> colorList = [
    const Color(0xff2cbf4f),
    const Color(0xff91e5dd),
    const Color(0xff9ee85e),
    const Color(0xfffeb764),
    const Color(0xfffcc7ff),
    const Color(0xff4570ff),
    const Color(0xff294dff),
    const Color(0xfff7c0fa),
    const Color(0xff00ed84),
  ];

  void makeShowTimeTable() {
    int colorIndex = 0;
    int limitTempStart = 9;
    int limitTempEnd = 18;
    for (var item in selectTable.value.CLASSES) {
      print(item.CLASS_NAME);
      for (var detail in item.CLASS_TIME) {
        int day_index = getIndexFromDay(detail.day);
        DateTime start = detail.start_time;
        if (start == null) {
          continue;
        }
        int startTime = start.hour * 60 + start.minute;

        DateTime end = detail.end_time;
        int endTime = end.hour * 60 + end.minute;

        if (limitTempStart > start.hour) {
          limitTempStart = start.hour;
        }

        if (limitTempEnd <= end.hour) {
          limitTempEnd = end.hour + 1;
        }

        showTimeTable[day_index].add({
          "start_time": startTime,
          "end_time": endTime,
          "classInfo": item,
          "color": colorList[colorIndex % colorList.length]
        });
      }
      colorIndex += 1;
    }

    limitStartTime.value = limitTempStart;
    limitEndTime.value = limitTempEnd;
    setVerAmount();
    isExpandedHor.value = checkHorExpand();
  }

  bool checkHorExpand() {
    print("checkHor Expaned");
    if (showTimeTable[5].length == 0 && showTimeTable[6].length == 0) {
      return false;
    }
    // print(showTimeTable[5]);
    return true;
  }

  bool checkVerExpand(int endTime) {
    print("checkVer Expaned");

    if (endTime > 18 * 60) {
      print(endTime);
      return true;
    }
    return false;
  }

  List<TimeTableClassModel> get getIcampusOrUndetermined {
    List<TimeTableClassModel> tempList = [];
    for (TimeTableClassModel item in selectTable.value.CLASSES) {
      if (item.IS_ICAMPUS || item.IS_NOT_DETERMINED) {
        tempList.add(item);
      }
    }
    return tempList;
  }

  Future<bool> canGoClassSearchPage(int year, int semester) async {
    var response = await Session()
        .getX("/timetable/isExist/year/${year}/semester/${semester}");
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  void initShowTimeTable() {
    showTimeTable.value = [
      <Map<String, dynamic>>[].obs,
      <Map<String, dynamic>>[].obs,
      <Map<String, dynamic>>[].obs,
      <Map<String, dynamic>>[].obs,
      <Map<String, dynamic>>[].obs,
      <Map<String, dynamic>>[].obs,
      <Map<String, dynamic>>[].obs,
    ];
  }

  Future<void> createTimeTable(int year, int semester, String name) async {
    print(year);
    print(semester);
    var response = await Session()
        .postX("/timetable/${year}/${semester}?name=${name}", {});
    switch (response.statusCode) {
      case 200:
        var rs = jsonDecode(response.body);
        if (!otherTable.containsKey("${year}년 ${semester}학기")) {
          otherTable["${year}년 ${semester}학기"] = [
            TimeTableModel.fromJson({
              "YEAR": year,
              "SEMESTER": semester,
              "NAME": name,
              "IS_DEFAULT": 1,
              "TIMETABLE_ID": rs["TIMETABLE_ID"]
            }).obs
          ].obs;
        } else {
          otherTable["${year}년 ${semester}학기"].add(TimeTableModel.fromJson({
            "YEAR": year,
            "SEMESTER": semester,
            "NAME": name,
            "IS_DEFAULT": 0,
            "TIMETABLE_ID": rs["TIMETABLE_ID"]
          }).obs);
        }

        print(otherTable["${year}년 ${semester}학기"].last.value.TIMETABLE_ID);
        // Get.snackbar("시간표 생성 성공", "시간표 생성 성공");
        selectedTimeTableId.value = rs["TIMETABLE_ID"];

        break;
      default:
        break;
      // Get.snackbar("시발 정신 차려", "시발 정신 차려");
    }
  }

  Future<void> refreshPage() async {
    await getSemesterTimeTable("2021", "3");
  }

  Future<int> getSemesterTimeTable(String YEAR, String SEMESTER) async {
    int status_code = 404;
    if (need_download_semester(YEAR, SEMESTER)) {
      // dataAvailable(false);

      Map<String, dynamic> jsonResponse =
          await repository.getSemesterTimeTable(YEAR, SEMESTER);

      switch (jsonResponse["statusCode"]) {
        case 200:
          otherTable["${YEAR}년 ${SEMESTER}학기"] = jsonResponse["otherTable"];
          //디폴트인 순서대로 정렬
          otherTable["${YEAR}년 ${SEMESTER}학기"]
              .sort((a, b) => b.value.IS_DEFAULT.compareTo(a.value.IS_DEFAULT));
          for (Rx<TimeTableModel> model in jsonResponse["otherTable"]) {
            getTimeTable(model.value.TIMETABLE_ID);
            // await getTimeTable(model.value.TIMETABLE_ID);
          }
          print(jsonResponse["otherTable"]);

          selectedTimeTableId.value =
              jsonResponse["defaultTable"].value.TIMETABLE_ID;

          defaultTableList["${YEAR}년 ${SEMESTER}학기"] =
              jsonResponse["defaultTable"];

          selectTableList.add(jsonResponse["defaultTable"].value);
          selectTable.value = jsonResponse["defaultTable"].value;

          dataAvailable(true);
          status_code = 200;
          break;
        case 404:
          // Get.snackbar("없는 시간표", "없는 시간표");
          status_code = 404;

          break;
        default:
          dataAvailable(false);
          printError(info: "Data Fetch ERROR!!");
          status_code = 404;
          break;
      }
    } else {
      for (SelectedTimeTableModel item in selectTableList) {
        if (item.YEAR == int.parse(YEAR) &&
            item.SEMESTER == int.parse(SEMESTER)) {
          selectedTimeTableId.value = item.TIMETABLE_ID;

          break;
        }
      }
      status_code = 200;
    }
    return status_code;

    // else {
    //   print("${YEAR}년 ${SEMESTER}학기");
    //   // selectTable.value = defaultTableList["${YEAR}년 ${SEMESTER}학기"].value;
    //   selectedTimeTableId.value =
    //       defaultTableList["${YEAR}년 ${SEMESTER}학기"].value.TIMETABLE_ID;
    //   print("asdfasdfasdf");
    //   dataAvailable(true);
    // }
  }

  Future getTimeTable(int TIMETABLE_ID) async {
    // dataAvailable.value = false;

    Map<String, dynamic> jsonResponse =
        await repository.getTimeTable(TIMETABLE_ID);

    switch (jsonResponse["statusCode"]) {
      case 200:
        print("getTimeTable");
        print(jsonResponse["selectTable"].value);
        selectTableList.add(jsonResponse["selectTable"].value);
        dataAvailable(true);
        break;
      default:
        dataAvailable(false);
        printError(info: "Data Fetch ERROR!!");
    }
  }

  Future<int> deleteClass(int TIMETABLE_ID, String class_name) async {
    Response<dynamic> response = await Session()
        .deleteX("/timetable/tid/${TIMETABLE_ID}?className=${class_name}");
    return response.statusCode;
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

  void refactoringTime() {
    initShowTimeTable();
    makeShowTimeTable();
  }

  Future setDefaultTable() async {
    int tid = selectTable.value.TIMETABLE_ID;
    int year = selectTable.value.YEAR;
    int semester = selectTable.value.SEMESTER;

    var status = await repository.setDefaultTable(tid, year, semester);

    switch (status["statusCode"]) {
      case 200:
        // Get.snackbar("디폴트 변경 성공", "디폴트 변경 성공");
        // if (!defaultTableList.containsKey("${year}년 ${semester}학기")) {
        //   defaultTableList["${year}년 ${semester}학기"] = selectTable;
        // } else {
        //   defaultTableList["${year}년 ${semester}학기"].value = selectTable.value;
        // }

        defaultTableList["${year}년 ${semester}학기"] = selectTable;

        //topbar에 나오는 애들 변경
        for (var item in selectYearSemester) {
          if (item.value.YEAR == year.toString() &&
              item.value.SEMESTER == semester.toString()) {
            item.update((val) {
              val.NAME = selectTable.value.NAME;
              val.TIMETABLE_ID = tid;
            });
          }
        }

        //테이블 리스트에 나오는 애들 변경
        for (var item in otherTable["${year}년 ${semester}학기"]) {
          if (item.value.IS_DEFAULT != 0) {
            item.update((val) {
              val.IS_DEFAULT = 0;
            });
          } else if (item.value.TIMETABLE_ID == tid) {
            item.update((val) {
              val.IS_DEFAULT = 1;
            });
          }
        }

        //테이블 리스트를 default 기반으로 재정렬
        otherTable["${year}년 ${semester}학기"]
            .sort((a, b) => b.value.IS_DEFAULT.compareTo(a.value.IS_DEFAULT));

        break;
      default:
        // Get.snackbar("디폴트 변경 실패", "디폴트 변경 실패");
        break;
    }
  }

  Future getTableInfo() async {
    var response = await Session().getX("/timetable");
    Iterable tableInfoJson = jsonDecode(response.body);
    // print(tableInfoJson);
    selectYearSemester.value = tableInfoJson
        .map((e) => SelectYearSemesterModel.fromJson(e).obs)
        .toList();

    print(selectYearSemester.length);
  }

  void setVerAmount() {
    verAmount.value = limitEndTime.value - limitStartTime.value + 1;
  }

  void handleAddButtonTrue() {
    inTimeTableMainPage.value = true;
  }

  void handleAddButtonFalse() {
    inTimeTableMainPage.value = false;
  }

  @override
  void onInit() async {
    super.onInit();
    await getTableInfo();

    if (selectYearSemester.length > 0) {
      await getSemesterTimeTable("${selectYearSemester[0].value.YEAR}",
          "${selectYearSemester[0].value.SEMESTER}");
      refactoringTime();
    }

    ever(isExpandedHor, (_) {
      print(isExpandedHor.value);
      print("변경");
    });

    ever(limitStartTime, (_) {
      print("변경");
      setVerAmount();
    });
    ever(limitEndTime, (_) {
      setVerAmount();
    });

    ever(selectedTimeTableId, (_) async {
      print("인덱스 변경 ${selectedTimeTableId.value}");
      bool needDownload = need_download_tableId();
      if (needDownload) {
        print("need Download ${selectedTimeTableId.value}!");
        await getTimeTable(selectedTimeTableId.value);
      }

      for (var item in selectTableList) {
        if (item.TIMETABLE_ID == selectedTimeTableId.value) {
          selectTable.value = item;
          break;
        }
      }

      refactoringTime();

      print(selectTable.value.SEMESTER);
    });
    isReady.value = true;
  }

  String get yearSem =>
      "${selectTable.value.YEAR}년 ${selectTable.value.SEMESTER}학기";

  int get selectedYear => selectTable.value.YEAR;
  int get selectedSemester => selectTable.value.SEMESTER;
  // bool get isReady => _isReady.value;
}
