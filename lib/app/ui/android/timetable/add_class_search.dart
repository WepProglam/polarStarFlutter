import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_addclass_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_addclass_search_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/timetable_daytoindex.dart';
import 'package:polarstar_flutter/app/ui/android/functions/time_pretty.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/timetable.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/timetable.dart';

var inputDecoration = (hint) => InputDecoration(
    isDense: true,
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    hintStyle: const TextStyle(
        color: const Color(0xff999999),
        fontWeight: FontWeight.w400,
        fontFamily: "PingFangSC",
        fontStyle: FontStyle.normal,
        fontSize: 14.0),
    hintText: "Please enter the ${hint} name");

const textStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontFamily: "PingFangSC",
    fontStyle: FontStyle.normal,
    fontSize: 14.0);

class TimetableAddClassMain extends StatelessWidget {
  TimetableAddClassMain({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  final TimeTableAddClassSearchController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomSheet: // 사각형 612
              Container(
            height: 473.5,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff707070), width: 1),
                color: const Color(0xffffffff)),
            child: classSearchBottomSheet(
                controller: controller,
                timeTableController: timeTableController),
          ),
          body: Container(
            height: size.height - 473.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 32,
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 14.6, 7.3),
                        child: // 패스 907
                            InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 9.365753173828125,
                            height: 16.6669921875,
                            child: Image.asset(
                              "assets/images/891.png",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Text("Add  Course",
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w700,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 21.0),
                            textAlign: TextAlign.left),
                      ),
                      Spacer(),
                      Container(
                        margin: const EdgeInsets.only(top: 4, right: 0),
                        child: // 사각형 511
                            Container(
                                // width: 74.5,
                                // height: 28,
                                child: // complete
                                    Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(7.5, 4, 7, 5.5),
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed("/timetable/addClass/direct");
                                      // bool checkClasses =
                                      //     controller
                                      //         .checkClassValidate();
                                      // TimeTableClassModel postData =
                                      //     controller
                                      //         .TOTAL_CLASS.value;
                                      // if (postData.PROFESSOR == null ||
                                      //     postData.PROFESSOR.isEmpty) {
                                      //   Get.snackbar("교강사명을 입력하세요", "교강사명을 입력하세요",
                                      //       snackPosition: SnackPosition.BOTTOM);
                                      // } else if (postData.CLASS_NAME == null ||
                                      //     postData.CLASS_NAME.isEmpty) {
                                      //   Get.snackbar("강의명을 입력하세요", "강의명을 입력하세요",
                                      //       snackPosition: SnackPosition.BOTTOM);
                                      // } else if (!checkClasses) {
                                      //   Get.snackbar(
                                      //       "시간이 중복되었습니다.", "시간이 중복되었습니다.",
                                      //       snackPosition: SnackPosition.BOTTOM);
                                      // } else {
                                      //   timeTableAddClassController.addClass(
                                      //       timeTableController
                                      //           .selectedTimeTableId.value);
                                      //   Get.back();
                                      // }
                                    },
                                    child: Text("직접 추가",
                                        style: const TextStyle(
                                            color: const Color(0xff1a4678),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "PingFangSC",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(28)),
                                    color: const Color(0xffdceafa))),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Obx(() {
                      RxBool isExpandedHor = timeTableController.isExpandedHor;
                      int dayAmount = isExpandedHor.value ? 7 : 5;
                      int verAmount = timeTableController.verAmount.value;

                      return Container(
                        height: 44 + 60.0 * (verAmount - 1) + 30,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Stack(children: [
                          TimeTableBin(
                              timeTableController: timeTableController,
                              width: size.width - 30,
                              dayAmount: dayAmount,
                              verAmount: verAmount),
                          TimeTableContent(
                              timeTableController: timeTableController,
                              width: size.width - 30,
                              dayAmount: dayAmount,
                              verAmount: verAmount),
                          //선택한 애들 띄우기
                          for (Rx<AddClassModel> item in controller.NewClass)
                            Positioned(
                              child: TimeTableAddClass(
                                  new_class: item,
                                  width: size.width - 30,
                                  show: controller.selectedIndex == -1
                                      ? false
                                      : true,
                                  dayAmount: dayAmount,
                                  verAmount: verAmount),
                            )
                        ]),
                      );
                    }),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class classSearchBottomSheet extends StatelessWidget {
  const classSearchBottomSheet(
      {Key key, @required this.controller, @required this.timeTableController})
      : super(key: key);

  final TimeTableAddClassSearchController controller;
  final TimeTableController timeTableController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        searchClassSliverAppBar(controller: controller),
        Obx(() {
          return SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              TimeTableClassModel model = controller.CLASS_SEARCH[index];
              return Ink(
                  child: InkWell(
                onTap: () {
                  if (controller.selectedIndex.value == index) {
                    controller.selectedIndex.value = -1;
                  } else {
                    controller.selectedIndex.value = index;
                    controller.NewClass.value =
                        model.CLASS_TIME.map((e) => e.obs).toList();
                    for (var item in controller.NewClass) {
                      if (item.value.end_time.hour >
                          timeTableController.limitStartTime.value) {
                        timeTableController.limitStartTime.value =
                            item.value.end_time.hour;
                      }
                      if (item.value.day == "토" || item.value.day == "일") {
                        timeTableController.isExpandedHor.value = true;
                      }
                    }
                  }
                },
                child: Obx(() {
                  return Container(
                      height:
                          index == controller.selectedIndex.value ? 135 : 104.4,
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 6, top: 6),
                      color: index == controller.selectedIndex.value
                          ? Colors.lightBlue[50]
                          : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 19.5,
                                  child: Text("${model.CLASS_NAME}",
                                      style: const TextStyle(
                                          color: const Color(0xff333333),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "PingFangSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15.0),
                                      textAlign: TextAlign.center),
                                ),
                                Spacer(),
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 15, bottom: 9),
                                  child: Row(
                                    children: [
                                      for (var i = 0; i < 5; i++)
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 2.5),
                                          height: 10,
                                          width: 10,
                                          child: Image.asset(
                                              "assets/images/647.png"),
                                        )
                                    ],
                                  ),
                                )
                              ]),
                          Container(
                            margin: const EdgeInsets.only(top: 7.5),
                            child: Row(
                              children: [
                                Container(
                                    height: 15,
                                    width: 15,
                                    child:
                                        Image.asset("assets/images/647.png")),
                                Container(
                                  height: 12,
                                  margin: const EdgeInsets.only(
                                      left: 15, bottom: 1.5, top: 1.5),
                                  child: Text("${model.PROFESSOR}",
                                      style: const TextStyle(
                                          color: const Color(0xff333333),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "PingFangSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 9.0),
                                      textAlign: TextAlign.center),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 7.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    height: 15,
                                    width: 15,
                                    child:
                                        Image.asset("assets/images/647.png")),
                                Container(
                                  // width: size.width - 100 + 173,
                                  height: 12,
                                  margin: const EdgeInsets.only(
                                      left: 15,
                                      bottom: 1.5,
                                      top: 1.5,
                                      right: 15),
                                  child: Text(
                                      "${classTimePretty(model.CLASS_TIME)}",
                                      style: const TextStyle(
                                          color: const Color(0xff333333),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "PingFangSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 9.0),
                                      textAlign: TextAlign.left),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 7.5),
                            child: Row(
                              children: [
                                Container(
                                    height: 15,
                                    width: 15,
                                    child:
                                        Image.asset("assets/images/647.png")),
                                Container(
                                  height: 12,
                                  margin: const EdgeInsets.only(
                                      left: 15, bottom: 1.5, top: 1.5),
                                  child: Text(
                                      "${model.CLASS_TIME[0].class_room}",
                                      style: const TextStyle(
                                          color: const Color(0xff333333),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "PingFangSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 9.0),
                                      textAlign: TextAlign.center),
                                ),
                                Spacer(),
                                // 전공
                                Container(
                                  margin: const EdgeInsets.only(top: 7),
                                  child: Text(
                                      "${model.CLASS_SECTOR_TOTAL} ${model.CREDIT}학점 ${model.CLASS_NUMBER}",
                                      style: const TextStyle(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "PingFangSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 9.0),
                                      textAlign: TextAlign.center),
                                )
                              ],
                            ),
                          ),
                          index == controller.selectedIndex.value
                              ? Container(
                                  margin: const EdgeInsets.only(top: 7),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xff1a4678),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Ink(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 2, 8, 2),
                                          child: InkWell(
                                            onTap: () {
                                              controller.addClass(
                                                  timeTableController
                                                      .selectedTimeTableId
                                                      .value);
                                            },
                                            child: Center(
                                              child: Text(
                                                "등록",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ));
                }),
              ));
            }, childCount: controller.CLASS_SEARCH.length),
          );
        }),
      ],
    );
  }
}

class searchClassSliverAppBar extends StatelessWidget {
  const searchClassSliverAppBar({Key key, @required this.controller})
      : super(key: key);
  final TimeTableAddClassSearchController controller;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 45 + 6.0,
      leadingWidth: 0,
      titleSpacing: 0.0,
      flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
          title: Row(
            children: [
              // 사각형 613
              Container(
                  // width: 100,
                  height: 35,
                  child: // 전공/영역: 전체
                      InkWell(
                    onTap: () {
                      Get.toNamed(Routes.TIMETABLE_ADDCLASS_FILTER_COLLEGE);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Obx(() {
                          return Row(children: [
                            Text(
                                "전공/영역: ${controller.college_major.value.isEmpty ? "없음" : controller.college_major.value}",
                                maxLines: 1,
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14),
                                textAlign: TextAlign.left),
                            Ink(
                              child: InkWell(
                                onTap: () async {
                                  controller.college_major.value = "";
                                  controller.INDEX_COLLEGE_MAJOR.value = -1;
                                  controller.INDEX_COLLEGE_NAME.value = -1;
                                  await controller.getSearchedClass();
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ]);
                        }),
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(29)),
                      color: const Color(0xff1a4678))),
              Container(
                  height: 35,
                  margin: const EdgeInsets.only(left: 15),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.TIMETABLE_ADDCLASS_SEARCH);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Obx(() {
                          return Row(children: [
                            Text(
                                "검색 : ${controller.search_name.isEmpty ? "없음" : controller.search_name}",
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14),
                                textAlign: TextAlign.left),
                            Ink(
                              child: InkWell(
                                onTap: () async {
                                  controller.search_name.value = "";
                                  await controller.getFilteredClass();
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ]);
                        }),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(29)),
                      color: const Color(0xff1a4678))),
            ],
          )),
    );
  }
}

class ClassInfoTPO extends StatelessWidget {
  const ClassInfoTPO(
      {Key key,
      @required this.size,
      @required this.timeTableAddClassController})
      : super(key: key);
  final TimeTableAddClassController timeTableAddClassController;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final days = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];

    return Obx(() {
      if (timeTableAddClassController.dataAvailable.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  margin: const EdgeInsets.only(bottom: 14.3),
                  child: Icon(Icons.timer),
                ),
                Container(
                  width: size.width - 15.3 - 14.8 - 30,
                  margin: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 14.3),
                          child: Text(
                            "요일과 시간을 설정해주세요",
                            style: const TextStyle(
                                color: const Color(0xff999999),
                                fontWeight: FontWeight.w400,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() {
              double height =
                  timeTableAddClassController.CLASS_LIST.length * 76.0;
              return Container(
                height: height,
                margin: const EdgeInsets.only(left: 30),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: timeTableAddClassController.CLASS_LIST.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        Container(
                          child: TpoSelector(
                              timeTableAddClassController:
                                  timeTableAddClassController,
                              classIndex: index,
                              days: days,
                              size: size),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                              width: size.width - 15.3 - 14.8,
                              height: 1,
                              decoration: BoxDecoration(
                                  color: const Color(0xffdedede))),
                        ),
                      ]);
                    }),
              );
            }),

            // 사각형 511
            InkWell(
              onTap: () {
                timeTableAddClassController.selectIndex.value += 1;
              },
              child: Container(
                  width: 80,
                  height: 28,
                  margin: const EdgeInsets.only(left: 30, top: 10),
                  child: // complete
                      Center(
                    child: Text("장소 및 시간 추가",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 10.0),
                        textAlign: TextAlign.center),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      color: Colors.red)),
            )
          ],
        );
      } else {
        return CircularProgressIndicator();
      }
    });
  }
}

class TpoSelector extends StatelessWidget {
  TpoSelector(
      {Key key,
      @required this.timeTableAddClassController,
      @required this.days,
      @required this.size,
      @required this.classIndex})
      : super(key: key);

  final TimeTableAddClassController timeTableAddClassController;
  final List<String> days;
  final Size size;
  final int classIndex;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            children: [
              Obx(() {
                return Container(
                  child: SelectDay(
                      newClass:
                          timeTableAddClassController.CLASS_LIST[classIndex],
                      days: days),
                );
              }),
              Obx(() {
                return Container(
                  child: SelectStartTime(
                      newClass:
                          timeTableAddClassController.CLASS_LIST[classIndex]),
                  padding: const EdgeInsets.only(left: 31.9, right: 27.2),
                );
              }),
              Obx(() {
                return Container(
                  child: SelectEndTime(
                      newClass:
                          timeTableAddClassController.CLASS_LIST[classIndex]),
                  padding: const EdgeInsets.only(right: 27.2),
                );
              }),
              Spacer(),
              Container(
                child: ClassTrashCan(
                    classIndex: classIndex,
                    timeTableAddClassController: timeTableAddClassController),
                margin: const EdgeInsets.only(right: 21.4),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 1),
          child: TextFormField(
            controller:
                timeTableAddClassController.classLocationController[classIndex],
            onChanged: (value) {
              timeTableAddClassController.CLASS_LIST[classIndex].update((val) {
                val.class_room = timeTableAddClassController
                    .classLocationController[classIndex].text;
              });
            },
            maxLines: 1,
            style: textStyle,
            textAlign: TextAlign.left,
            decoration: inputDecoration("class"),
          ),
        ),
      ],
    );
  }
}

class ClassTrashCan extends StatelessWidget {
  final TimeTableAddClassController timeTableAddClassController;
  final int classIndex;
  const ClassTrashCan(
      {Key key,
      @required this.timeTableAddClassController,
      @required this.classIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        timeTableAddClassController.CLASS_LIST.removeAt(classIndex);
      },
      child: Container(
        width: 17.104248046875,
        height: 16.619873046875,
        child: Image.asset(
          "assets/images/15_4.png",
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class SelectDay extends StatelessWidget {
  SelectDay({
    Key key,
    @required this.newClass,
    @required this.days,
  }) : super(key: key);

  final Rx<AddClassModel> newClass;
  final List<String> days;
  final TimeTableController timeTableController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButton(
          underline: Container(),
          icon: // 패스 908
              Container(
            width: 10.682647705078125,
            height: 5.931396484375,
            margin: const EdgeInsets.only(top: 8, bottom: 4.5),
            child: Image.asset("assets/images/940.png"),
          ),
          value: newClass.value.day,
          onChanged: (value) {
            newClass.update((val) {
              val.day = value;
              if (getIndexFromDay(value) >= 5) {
                timeTableController.isExpandedHor.value = true;
              }
            });
          },
          items: days
              .map((e) => DropdownMenuItem(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.7),
                    child: Text(e),
                  ),
                  value: e))
              .toList());
    });
  }
}

class SelectStartTime extends StatelessWidget {
  SelectStartTime({
    Key key,
    @required this.newClass,
  }) : super(key: key);

  final Rx<AddClassModel> newClass;
  final TimeTableController timeTableController = Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime start_time = newClass.value.start_time;

        DateTime timeInput = DateTime(start_time.year, start_time.month,
            start_time.day, start_time.hour, start_time.minute);
        DateTime end_time = newClass.value.end_time;
        bool flag = false;

        int fastest = 9 * 60;
        int lastest = 21 * 60;

        await Get.defaultDialog(
            content: Container(
          height: 200,
          width: Get.mediaQuery.size.width,
          child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
              initialDateTime: start_time,
              minuteInterval: 5,
              onDateTimeChanged: (DateTime dateTime) {
                timeInput = dateTime;
              }),
        ));

        int cal_time = timeInput.hour * 60 + timeInput.minute;
        if (cal_time >= fastest && cal_time < lastest) {
          timeInput = timeInput;
        } else {
          Get.snackbar("9시부터 21시 사이로 골라주세요", "9시부터 21시 사이로 골라주세요",
              snackPosition: SnackPosition.BOTTOM);
          return;
        }

        if (timeInput.hour >= 0 &&
            timeInput.hour < timeTableController.limitStartTime.value) {
          timeTableController.limitStartTime.value = timeInput.hour;
        }
        if (timeInput.isAfter(end_time) ||
            timeInput.isAtSameMomentAs(end_time)) {
          newClass.update((val) {
            val.end_time = DateTime(timeInput.year, timeInput.month,
                timeInput.day, timeInput.hour + 1, timeInput.minute);
          });
        }
        newClass.update((val) {
          val.start_time = DateTime(timeInput.year, timeInput.month,
              timeInput.day, timeInput.hour, timeInput.minute);
        });
      },
      child: Obx(() {
        return Row(children: [
          Container(
            child: Text("${timeFormatter(newClass.value.start_time)}",
                style: const TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w400,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),
          ),
          Container(
            width: 10.68267822265625,
            height: 5.931396484375,
            margin: const EdgeInsets.only(left: 10.7, top: 8, bottom: 4.5),
            child: Image.asset("assets/images/940.png"),
          )
        ]);
      }),
    );
  }
}

class SelectEndTime extends StatelessWidget {
  const SelectEndTime({
    Key key,
    @required this.newClass,
  }) : super(key: key);

  final Rx<AddClassModel> newClass;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime end_time = newClass.value.end_time;

        DateTime timeInput = DateTime(end_time.year, end_time.month,
            end_time.day, end_time.hour, end_time.minute);

        DateTime start_time = newClass.value.start_time;

        int fastest = 9 * 60;
        int lastest = 21 * 60;
        await Get.defaultDialog(
            content: Container(
          height: 200,
          width: Get.mediaQuery.size.width,
          child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
              initialDateTime: newClass.value.end_time,
              minuteInterval: 5,
              onDateTimeChanged: (DateTime dateTime) {
                timeInput = dateTime;
              }),
        ));

        int cal_time = timeInput.hour * 60 + timeInput.minute;
        if (cal_time > fastest && cal_time <= lastest) {
          timeInput = timeInput;
        } else {
          Get.snackbar("9시부터 21시 사이로 골라주세요", "9시부터 21시 사이로 골라주세요",
              snackPosition: SnackPosition.BOTTOM);
          return;
        }

        if (timeInput.isBefore(start_time) ||
            timeInput.isAtSameMomentAs(start_time)) {
          newClass.update((val) {
            val.start_time = DateTime(timeInput.year, timeInput.month,
                timeInput.day, timeInput.hour - 1, timeInput.minute);
          });
        }
        newClass.update((val) {
          val.end_time = DateTime(timeInput.year, timeInput.month,
              timeInput.day, timeInput.hour, timeInput.minute);
        });

        // if (other_flag) {
        //   newClass.update((val) {
        //     val.start_time = DateTime(start_time.year, start_time.month,
        //         start_time.day, timeInput.hour - 1, timeInput.minute);
        //   });
        // } else {
        //   newClass.update((val) {
        //     timeInput = DateTime(
        //         timeInput.year,
        //         timeInput.month,
        //         timeInput.day,
        //         (timeInput.hour > 21)
        //             ? 21
        //             : self_flag
        //                 ? start_time.hour + 1
        //                 : timeInput.hour,
        //         timeInput.minute);
        //     val.end_time = timeInput;
        //   });
        // }
      },
      child: Obx(() {
        return Row(children: [
          Container(
            child: Text("${timeFormatter(newClass.value.end_time)}",
                style: const TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w400,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),
          ),
          Container(
            width: 10.68267822265625,
            height: 5.931396484375,
            margin: const EdgeInsets.only(left: 10.7, top: 8, bottom: 4.5),
            child: Image.asset("assets/images/940.png"),
          )
        ]);
      }),
    );
  }
}
