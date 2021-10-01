import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';

import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/session.dart';

class TimeTableAddClassSearchController extends GetxController {
  final TimeTableAddClassRepository repository;

  final TimeTableController timeTableController = Get.find();

  TimeTableAddClassSearchController({@required this.repository});

  RxList<TimeTableClassModel> CLASS_SEARCH = <TimeTableClassModel>[].obs;
  RxList<Rx<AddClassModel>> NewClass = <Rx<AddClassModel>>[].obs;
  List<TimeTableClassModel> initModel = [];

  TextEditingController classSearchController = new TextEditingController();

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

  Future<void> addClass(int tid) async {
    print(CLASS_SEARCH[selectedIndex.value].toJson());
    // TOTAL_CLASS.update((val) {
    //   val.CLASS_TIME = CLASS_LIST.map((element) => element.value).toList();
    // });

    // Map<String, dynamic> data = TOTAL_CLASS.toJson();

    // await Session().postX("/timetable/tid/${tid}", data);

    // timeTableController.selectTable.update((val) {
    //   val.CLASSES.add(TOTAL_CLASS.value);
    // });
    timeTableController.initShowTimeTable();
    timeTableController.makeShowTimeTable();
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

  Future<void> getFilteredClass() async {
    if (INDEX_COLLEGE_NAME.value == -1 || INDEX_COLLEGE_MAJOR.value == -1) {
      CLASS_SEARCH.value = initModel;
      return;
    }
    var response = await Session().getX(
        "/class/timetable/filter/page/0?INDEX_COLLEGE_NAME=${INDEX_COLLEGE_NAME.value}&INDEX_COLLEGE_MAJOR=${INDEX_COLLEGE_MAJOR.value}");
    Iterable class_list = jsonDecode(response.body);
    print(class_list);
    CLASS_SEARCH.value =
        class_list.map((e) => TimeTableClassModel.fromJson(e)).toList();
  }

  Future<void> getSearchedClass() async {
    if (search_name.value.trim().isEmpty) {
      CLASS_SEARCH.value = initModel;
      return;
    }
    var response = await Session()
        .getX("/class/search/page/0?search=${search_name.value}");

    Iterable class_list = jsonDecode(response.body);
    CLASS_SEARCH.value =
        class_list.map((e) => TimeTableClassModel.fromJson(e)).toList();
  }

  Future<void> getFilterAndSearch(int page) async {
    var response = await Session().getX(
        "/class/search/page/${page}?search=${search_name.value}&INDEX_COLLEGE_NAME=${INDEX_COLLEGE_NAME.value}&INDEX_COLLEGE_MAJOR=${INDEX_COLLEGE_MAJOR.value}");
    Iterable class_list = jsonDecode(response.body);
    CLASS_SEARCH.value =
        class_list.map((e) => TimeTableClassModel.fromJson(e)).toList();
  }

  Future<void> getMajorInfo() async {
    var response = await Session().getX(
        "/class/timetable/major?INDEX_COLLEGE_NAME=${INDEX_COLLEGE_NAME.value}");
    Iterable majorList = jsonDecode(response.body);
    college_major_list.value =
        majorList.map((e) => CollegeMajorModel.fromJson(e)).toList();
    print(majorList);
  }

  @override
  void onReady() async {
    super.onReady();
    timeTableController.initShowTimeTable();
    timeTableController.makeShowTimeTable();
  }

  @override
  void onInit() async {
    super.onInit();
    await getClassInfo();

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
}
