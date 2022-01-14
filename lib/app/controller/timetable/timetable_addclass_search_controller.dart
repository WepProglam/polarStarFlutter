import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

  RxInt INDEX_COLLEGE_NAME = (-1).obs;
  RxInt INDEX_COLLEGE_MAJOR = (-1).obs;

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
    } else {
      Get.snackbar("오류", "오류");
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

  Future<void> getClassInfo() async {
    // * initmodel이 있으면 initmodel 반환
    // ? initmodel도 page별로 append할거면 코드 수정 필요
    if (initModel.length != 0) {
      CLASS_SEARCH.value = initModel;
      return;
    }
    var response = await Session().getX("/class/timetable");
    var json = jsonDecode(response.body);
    Iterable classList = json["CLASS"];
    Iterable collegeList = json["index"];
    CLASS_SEARCH.value =
        classList.map((e) => TimeTableClassModel.fromJson(e)).toList();
    initModel = classList.map((e) => TimeTableClassModel.fromJson(e)).toList();

    college_name_list.value =
        collegeList.map((e) => CollegeNameModel.fromJson(e)).toList();
    dataAvailbale.value = true;
  }

  Future<void> getFilteredClass(int page) async {
    if (INDEX_COLLEGE_NAME.value == -1 || INDEX_COLLEGE_MAJOR.value == -1) {
      CLASS_SEARCH.value = initModel;
      return;
    }

    if (page > searchMaxPage.value) {
      return;
    }

    var response = await Session().getX(
        "/class/timetable/filter/page/$page?INDEX_COLLEGE_NAME=${INDEX_COLLEGE_NAME.value}&INDEX_COLLEGE_MAJOR=${INDEX_COLLEGE_MAJOR.value}");
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
    var response = await Session()
        .getX("/class/search/page/$page?search=${search_name.value}");

    Iterable class_list = jsonDecode(response.body);

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
  }

  Future<void> getFilterAndSearch(int page) async {
    var response = await Session().getX(
        "/class/search/page/$page?search=${search_name.value}&INDEX_COLLEGE_NAME=${INDEX_COLLEGE_NAME.value}&INDEX_COLLEGE_MAJOR=${INDEX_COLLEGE_MAJOR.value}");
    Iterable class_list = jsonDecode(response.body);

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
  }

  Future<void> getMajorInfo() async {
    var response = await Session().getX(
        "/class/timetable/major?INDEX_COLLEGE_NAME=${INDEX_COLLEGE_NAME.value}");
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
    INDEX_COLLEGE_NAME.value = -1;
    INDEX_COLLEGE_MAJOR.value = -1;
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
    bool searchMajorEmpty =
        (INDEX_COLLEGE_NAME.value == -1 || INDEX_COLLEGE_MAJOR.value == -1);
    print(searchNameEmpty);
    print(searchMajorEmpty);
    // * getClass - 이것도 계속 로드?
    if (searchNameEmpty && searchMajorEmpty) {
      print("1");
      getClassInfo();
    }
    // * getFilteredClass
    else if (!searchNameEmpty && searchMajorEmpty) {
      print("2");
      getSearchedClass(page);
    }
    // * getSearchedClass
    else if (searchNameEmpty && !searchMajorEmpty) {
      print("3");
      getFilteredClass(page);
    }
    // * getFilterAndSearch
    else if (!searchNameEmpty && !searchMajorEmpty) {
      print("4");
      getFilterAndSearch(page);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getClassInfo();
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

    // ever(scrollController.offset, callback)
    // once(isItBuild, (_) {
    //   print("sadfsadfadsf");
    //   if (isItBuild.value) {
    //     showBottomSheet();
    //   }
    // });
    // initClass();
    // dataAvailable.value = true;
    // ever(CLASS_LIST, (_) {
    //   for (var item in CLASS_LIST) {
    //     print(item.value.day);
    //     print(item.value.start_time);
    //     print(item.value.end_time);
    //   }
    // });

    // ever(selectIndex, (_) {
    //   if (CLASS_LIST.length > selectIndex.value) {
    //   } else {
    //     initClass();
    //   }
    // });
  }

  @override
  void onClose() async {
    //print("CURR ROUTE!! : ${Get.currentRoute}");
    // Get.currentRoute == Routes.MAIN_PAGE
    print("close!1");
    await timeTableController.refactoringTime();
    await timeTableController.handleAddButtonTrue();
  }
}
