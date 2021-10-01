import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_addclass_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_addclass_search_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/timetable.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/session.dart';

class TimetableClassFilter extends StatelessWidget {
  TimetableClassFilter({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  final TimeTableAddClassSearchController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar:
              CustomBottomNavigationBar(mainController: mainController),
          body: Obx(() {
            return ListView.builder(
                itemCount: controller.college_name_list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Ink(
                    height: 50,
                    child: InkWell(
                      onTap: () async {
                        int INDEX_COLLEGE_NAME = controller
                            .college_name_list[index].INDEX_COLLEGE_NAME;

                        controller.INDEX_COLLEGE_NAME.value =
                            INDEX_COLLEGE_NAME;

                        await controller.getMajorInfo();

                        Get.toNamed(Routes.TIMETABLE_ADDCLASS_FILTER_MAJOR);
                      },
                      child: Center(
                        child: Text(
                            "${controller.college_name_list[index].COLLEGE_NAME}"),
                      ),
                    ),
                  );
                });
          })),
    );
  }
}

class TimetableClassMajor extends StatelessWidget {
  TimetableClassMajor({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  final TimeTableAddClassSearchController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar:
              CustomBottomNavigationBar(mainController: mainController),
          body: Obx(() {
            return ListView.builder(
                itemCount: controller.college_major_list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Ink(
                    height: 50,
                    child: InkWell(
                      onTap: () async {
                        controller.INDEX_COLLEGE_MAJOR.value = controller
                            .college_major_list[index].INDEX_COLLEGE_MAJOR;
                        controller.college_major.value =
                            controller.college_major_list[index].NAME;

                        String text = controller.search_name.value.trim();
                        //통합 검색 X
                        if (text.isEmpty) {
                          await controller.getFilteredClass();
                        } else {
                          await controller.getFilterAndSearch(0);
                        }
                        FocusScope.of(context).unfocus();
                        Get.back();
                        Get.back();
                      },
                      child: Center(
                          child: Text(
                              "${controller.college_major_list[index].NAME}")),
                    ),
                  );
                });
          })),
    );
  }
}

class TimetableClassSearch extends StatelessWidget {
  TimetableClassSearch({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();
  final TimeTableAddClassSearchController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar:
                CustomBottomNavigationBar(mainController: mainController),
            appBar: AppBar(
              backgroundColor: const Color(0xfff6f6f6),
              elevation: 0,
              toolbarHeight: 37 + 13.0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Container(
                margin: const EdgeInsets.only(
                    left: 15, right: 15, top: 7, bottom: 5),
                width: size.width - 15 * 2,
                height: 32,
                child: TimetableClassSearchBar(
                    size: size, searchText: searchText, controller: controller),
              ),
            ),
            body: Container()));
  }
}

class TimetableClassSearchBar extends StatelessWidget {
  const TimetableClassSearchBar(
      {Key key,
      @required this.size,
      @required this.searchText,
      @required this.controller})
      : super(key: key);

  final Size size;
  final TextEditingController searchText;
  final TimeTableAddClassSearchController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: size.width - 38.5 - 15 - 20 - 19.4 - 15,
        // margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 20,
            ),
            Expanded(
              child: TextFormField(
                controller: searchText,
                onEditingComplete: () async {
                  String text = searchText.text.trim();
                  controller.search_name.value = text;
                  //통합 검색 X
                  if (text.isEmpty || controller.INDEX_COLLEGE_MAJOR == -1) {
                    await controller.getSearchedClass();
                  } else {
                    await controller.getFilterAndSearch(0);
                  }
                  FocusScope.of(context).unfocus();
                  Get.back();
                },
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: ""),
              ),
            ),
            // Spacer(),
            // 패스 894
            Container(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 19.4, 7.7),
              child: Container(
                  width: 14.2841796875,
                  height: 14.29736328125,
                  child: InkWell(
                    onTap: () async {
                      String text = searchText.text.trim();
                      controller.search_name.value = text;
                      //통합 검색 X
                      if (text.isEmpty ||
                          controller.INDEX_COLLEGE_MAJOR == -1) {
                        await controller.getSearchedClass();
                      } else {
                        await controller.getFilterAndSearch(0);
                      }
                      FocusScope.of(context).unfocus();
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/images/894.png",
                      fit: BoxFit.fitHeight,
                    ),
                  )),
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: const Color(0xffeeeeee)));
  }
}
