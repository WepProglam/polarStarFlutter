import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';

import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/add_class_search.dart';
import 'package:polarstar_flutter/session.dart';

class TimeTableAddClassSearchController extends GetxController {
  final TimeTableAddClassRepository repository;

  final TimeTableController timeTableController = Get.find();

  TimeTableAddClassSearchController({@required this.repository});

  RxList<TimeTableClassModel> CLASS_SEARCH = <TimeTableClassModel>[].obs;
  RxList<Rx<AddClassModel>> NewClass = <Rx<AddClassModel>>[].obs;
  List<TimeTableClassModel> initModel = [];

  TextEditingController classSearchController = new TextEditingController();

  int searchPage = 0;
  Rx<int> searchMaxPage = 99999.obs;

  RxBool isItBuild = false.obs;
  BuildContext context;
  RxBool dataAvailbale = false.obs;
  RxInt selectedIndex = (-1).obs;
  RxList<CollegeNameModel> college_name_list = <CollegeNameModel>[].obs;
  RxList<CollegeMajorModel> college_major_list = <CollegeMajorModel>[].obs;

  RxString college_major = "".obs;
  RxString search_name = "".obs;

  RxInt COLLEGE_ID = (-1).obs;
  RxInt MAJOR_ID = (-1).obs;

  // 초기값 (실제로 받을 때 변경)
  int MAX_CLASS_LIMIT = 30;

  final Rx<ScrollController> scrollController =
      ScrollController(initialScrollOffset: 0.0).obs;

  Future<void> addClass(int tid) async {
    // print(CLASS_SEARCH[selectedIndex.value].toJson());
    // TOTAL_CLASS.update((val) {
    //   val.CLASS_TIME = CLASS_LIST.map((element) => element.value).toList();
    // });

    // Map<String, dynamic> data = TOTAL_CLASS.toJson();

    var response = await Session().postX(
        "/timetable/class/tid/${tid}?CLASS_ID=${CLASS_SEARCH[selectedIndex.value].CLASS_ID}",
        {});

    if (response.statusCode == 200) {
      timeTableController.selectTable.update((val) {
        val.CLASSES.add(CLASS_SEARCH[selectedIndex.value]);
      });
      selectedIndex.value = -1;
      timeTableController.initShowTimeTable();
      timeTableController.makeShowTimeTable();

      // * 시간표 수업 추가 시 noti page 업데이트(채팅 방)
      await MainUpdateModule.updateNotiPage(
        1,
      );
    } else if (response.statusCode == 404) {
      Get.snackbar("404", "1. 다른 학기 수업을 등록하려고 했습니다\n2. 없는 class_id입니다");
    } else {
      Get.snackbar("系统错误", "系统错误");
    }
  }

  // void initClass() {
  //   Rx<AddClassModel> tmp = AddClassModel.fromJson({
  //     "day": "월요일",
  //     "start_time": "09:00",
  //     "end_time": "10:00",
  //   }).obs;
  //   classLocationController.add(new TextEditingController());

  //   CLASS_LIST.add(tmp);
  // }

  bool checkClassValidate() {
    List<List<AddClassModel>> curClasses = timeTableController
        .selectTable.value.CLASSES
        .map((e) => e.CLASS_TIME)
        .toList();
    for (var CurClass in curClasses) {
      for (var item in CurClass) {
        for (var temp in CLASS_SEARCH) {
          for (var new_item in temp.CLASS_TIME) {
            if (new_item.day != item.day) {
              continue;
            }
            bool afterClass = ((new_item.start_time.isAfter(item.start_time) ||
                    new_item.start_time.isAtSameMomentAs(item.start_time)) &&
                (new_item.start_time.isAfter(item.end_time) ||
                    new_item.start_time.isAtSameMomentAs(item.end_time)));

            bool beforeClass = ((new_item.end_time.isBefore(item.start_time) ||
                    new_item.end_time.isAtSameMomentAs(item.start_time)) &&
                (new_item.end_time.isBefore(item.end_time) ||
                    new_item.end_time.isAtSameMomentAs(item.end_time)));

            bool innerCheck = new_item.start_time.isBefore(new_item.end_time);

            //한 수업에 대해 시작과 끝 시간이 모두 이르거나 느린 경우 통과
            bool checkItOut = (afterClass || beforeClass) && innerCheck;

            if (!checkItOut) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  Future<void> getClassInfo(int page) async {
    // * initmodel이 있으면 initmodel 반환
    // ? initmodel도 page별로 append할거면 코드 수정 필요
    if (initModel.length != 0) {
      var response = await Session().getX(
          "/class/timetable/page/$page/year/${timeTableController.selectedYear}/semester/${timeTableController.selectedSemester}");
      var json = jsonDecode(response.body);
      Iterable classList = json;
      CLASS_SEARCH.addAll(
          classList.map((e) => TimeTableClassModel.fromJson(e)).toList());
      initModel = CLASS_SEARCH.value;
      dataAvailbale.value = true;
      return;
    }

    var response = await Session().getX(
        "/class/timetable/year/${timeTableController.selectedYear}/semester/${timeTableController.selectedSemester}");
    var json = jsonDecode(response.body);
    Iterable classList = json["CLASS"];
    Iterable collegeList = json["index"];
    CLASS_SEARCH.value =
        classList.map((e) => TimeTableClassModel.fromJson(e)).toList();
    initModel = classList.map((e) => TimeTableClassModel.fromJson(e)).toList();

    college_name_list.value =
        collegeList.map((e) => CollegeNameModel.fromJson(e)).toList();

    MAX_CLASS_LIMIT = json["MAX_CLASS_LIMIT"];

    dataAvailbale.value = true;
  }

  Future<void> getFilteredClass(int page) async {
    if (COLLEGE_ID.value == -1 || MAJOR_ID.value == -1) {
      CLASS_SEARCH.value = initModel;
      return;
    }

    if (page > searchMaxPage.value) {
      return;
    }
    var response = await Session().getX(
        "/class/timetable/filter/page/$page/year/${timeTableController.selectedYear}/semester/${timeTableController.selectedSemester}?COLLEGE_ID=${COLLEGE_ID.value}&MAJOR_ID=${MAJOR_ID.value}");
    Iterable class_list = jsonDecode(response.body);
    print("${CLASS_SEARCH.length} page: $page");
    List<TimeTableClassModel> tempClasses =
        class_list.map((e) => TimeTableClassModel.fromJson(e)).toList();
    if (page == 0) {
      CLASS_SEARCH.value = tempClasses;
    } else {
      if (tempClasses.length == 0) {
        searchMaxPage.value = page;
        print("find max");
      } else {
        CLASS_SEARCH.addAll(tempClasses);
      }
    }
    print(CLASS_SEARCH.length);
  }

  Future<void> getSearchedClass(int page) async {
    if (search_name.value.trim().isEmpty) {
      CLASS_SEARCH.value = initModel;
      return;
    }
    var response = await Session().getX(
        "/class/search/page/$page/year/${timeTableController.selectedYear}/semester/${timeTableController.selectedSemester}?search=${search_name.value}");

    Iterable class_list = jsonDecode(response.body);

    List<TimeTableClassModel> tempClasses =
        class_list.map((e) => TimeTableClassModel.fromJson(e)).toList();
    if (page == 0) {
      CLASS_SEARCH.value = tempClasses;
    } else {
      if (tempClasses.length == 0) {
        searchMaxPage.value = page;
      } else {
        CLASS_SEARCH.addAll(tempClasses);
      }
    }
  }

  Future<void> getFilterAndSearch(int page) async {
    var response = await Session().getX(
        "/class/search/page/$page/year/${timeTableController.selectedYear}/semester/${timeTableController.selectedSemester}?search=${search_name.value}&COLLEGE_ID=${COLLEGE_ID.value}&MAJOR_ID=${MAJOR_ID.value}");
    Iterable class_list = jsonDecode(response.body);

    List<TimeTableClassModel> tempClasses =
        class_list.map((e) => TimeTableClassModel.fromJson(e)).toList();

    if (page == 0) {
      CLASS_SEARCH.value = tempClasses;
    } else {
      if (tempClasses.length == 0) {
        searchMaxPage.value = page;
      } else {
        CLASS_SEARCH.addAll(tempClasses);
      }
    }
  }

  Future<void> getMajorInfo() async {
    var response = await Session()
        .getX("/class/timetable/major?COLLEGE_ID=${COLLEGE_ID.value}");
    Iterable majorList = jsonDecode(response.body);
    college_major_list.value =
        majorList.map((e) => CollegeMajorModel.fromJson(e)).toList();
  }

  void initSeachPage() {
    searchPage = 0;
    searchMaxPage.value = 99999;
  }

  void initMajor() {
    college_major.value = "";
    COLLEGE_ID.value = -1;
    MAJOR_ID.value = -1;
    scrollController.value.jumpTo(0.0);
  }

  void initSearchName() {
    search_name.value = "";
    scrollController.value.jumpTo(0.0);
  }

  @override
  void onReady() async {
    super.onReady();
    timeTableController.refactoringTime();
  }

  Future<void> getClass(int page) async {
    bool searchNameEmpty = search_name.value.isEmpty;
    bool searchMajorEmpty = (COLLEGE_ID.value == -1 || MAJOR_ID.value == -1);
    // * getClass - 이것도 계속 로드?
    if (searchNameEmpty && searchMajorEmpty) {
      print("1");
      await getClassInfo(page);
    }
    // * getFilteredClass
    else if (!searchNameEmpty && searchMajorEmpty) {
      print("2");
      await getSearchedClass(page);
    }
    // * getSearchedClass
    else if (searchNameEmpty && !searchMajorEmpty) {
      print("3");
      await getFilteredClass(page);
    }
    // * getFilterAndSearch
    else if (!searchNameEmpty && !searchMajorEmpty) {
      print("4");
      await getFilterAndSearch(page);
    }

    print("CLASS SEARCH :  ${CLASS_SEARCH.length}");
    print("MAX : ${MAX_CLASS_LIMIT}");

    if (CLASS_SEARCH.length < MAX_CLASS_LIMIT) {
      searchMaxPage.value = page;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getClass(0);
    await timeTableController.handleAddButtonFalse();

    scrollController.value.addListener(() async {
      if ((scrollController.value.position.pixels ==
                  scrollController.value.position.maxScrollExtent ||
              !scrollController.value.position.hasPixels) &&
          (searchPage < searchMaxPage.value)) {
        searchPage += 1;
        getClass(searchPage);
        print("end ($searchPage)");
      }
    });
  }

  @override
  void onClose() async {
    await timeTableController.refactoringTime();
    await timeTableController.handleAddButtonTrue();
  }
}
