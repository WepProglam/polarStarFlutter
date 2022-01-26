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
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 56,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Container(
              width: size.width,
              child: Container(
                child: Stack(
                  children: [
                    Ink(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Image.asset(
                              "assets/images/back_icon.png",
                              width: 24,
                              height: 24,
                            )),
                      ),
                    ),
                    Center(
                      child: // 专业 / 领域
                          Text("专业 / 教养领域",
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // bottomNavigationBar:
          //     CustomBottomNavigationBar(mainController: mainController),
          body: Obx(() {
            return ListView.builder(
                itemCount: controller.college_name_list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Ink(
                    child: InkWell(
                      onTap: () async {
                        int INDEX_COLLEGE_NAME = controller
                            .college_name_list[index].INDEX_COLLEGE_NAME;

                        controller.INDEX_COLLEGE_NAME.value =
                            INDEX_COLLEGE_NAME;

                        await controller.getMajorInfo();

                        Get.toNamed(Routes.TIMETABLE_ADDCLASS_FILTER_MAJOR);
                      },
                      child: Column(children: [
                        index == 0
                            ? Container(
                                height: 24,
                              )
                            : Container(),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 11.5),
                          child: Text(
                            "${controller.college_name_list[index].COLLEGE_NAME}",
                            style: const TextStyle(
                                color: const Color(0xff6f6e6e),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansKR",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                          ),
                        ),
                        // 선 21
                        Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration:
                                BoxDecoration(color: const Color(0xffeaeaea)))
                      ]),
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
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 56,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Container(
              width: size.width,
              child: Container(
                child: Stack(
                  children: [
                    Ink(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Image.asset(
                              "assets/images/back_icon.png",
                              width: 24,
                              height: 24,
                            )),
                      ),
                    ),
                    Center(
                      child: // 专业 / 领域
                          Text("专业 / 领域",
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // bottomNavigationBar:
          //     CustomBottomNavigationBar(mainController: mainController),
          body: Obx(() {
            return ListView.builder(
                itemCount: controller.college_major_list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Ink(
                    child: InkWell(
                      onTap: () async {
                        controller.INDEX_COLLEGE_MAJOR.value = controller
                            .college_major_list[index].INDEX_COLLEGE_MAJOR;
                        controller.college_major.value =
                            controller.college_major_list[index].NAME;

                        String text = controller.search_name.value.trim();
                        await controller.getClass(0);
                        FocusScope.of(context).unfocus();
                        Get.back();
                        Get.back();
                      },
                      child: Column(
                        children: [
                          index == 0
                              ? Container(
                                  height: 24,
                                )
                              : Container(),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 11.5),
                            child: Text(
                              "${controller.college_major_list[index].NAME}",
                              style: const TextStyle(
                                  color: const Color(0xff6f6e6e),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansKR",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                            ),
                          ),
                          // 선 21
                          Container(
                              height: 1,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration:
                                  BoxDecoration(color: const Color(0xffeaeaea)))
                        ],
                      ),
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
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 56,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Container(
                margin: const EdgeInsets.only(
                    left: 20, top: 12, bottom: 12, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: Get.mediaQuery.size.width - 20 - 62,
                        margin: const EdgeInsets.only(right: 14),
                        height: 32,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Image.asset(
                                "assets/images/icn_search.png",
                                width: 20,
                                height: 20,
                                color: const Color(0xffcecece),
                              ),
                            ),
                            Container(
                              width:
                                  Get.mediaQuery.size.width - 20 - 62 - 30 - 20,
                              child: TextFormField(
                                controller: searchText,

                                onEditingComplete: () async {
                                  String text = searchText.text.trim();
                                  controller.search_name.value = text;
                                  await controller.getClass(0);
                                  // //통합 검색 X
                                  // if (text.isEmpty ||
                                  //     controller.INDEX_COLLEGE_MAJOR == -1) {
                                  //   await controller.getSearchedClass(0);
                                  // } else {
                                  //   await controller.getFilterAndSearch(0);
                                  // }
                                  FocusScope.of(context).unfocus();
                                  Get.back();
                                },
                                // focusNode: searchFocusNode,
                                autofocus: false,
                                minLines: 1,
                                maxLines: 1,
                                // controller: searchText,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "新建立 韩国大学联合交流区",
                                  hintStyle: const TextStyle(
                                      color: const Color(0xffcecece),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: const Color(0xffffffff))),
                    Container(
                      child: Ink(
                        child: InkWell(
                          onTap: () async {
                            String text = searchText.text.trim();
                            controller.search_name.value = text;
                            await controller.getClass(0);
                            // //통합 검색 X
                            // if (text.isEmpty ||
                            //     controller.INDEX_COLLEGE_MAJOR == -1) {
                            //   await controller.getSearchedClass(0);
                            // } else {
                            //   await controller.getFilterAndSearch(0);
                            // }
                            FocusScope.of(context).unfocus();
                            Get.back();
                          },
                          child: Text("取消",
                              style: const TextStyle(
                                  color: const Color(0xfff5f6ff),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                              textAlign: TextAlign.left),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Container()));
  }
}
