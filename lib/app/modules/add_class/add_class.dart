import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/global_functions/timetable_semester.dart';
import 'package:polarstar_flutter/app/modules/add_class/timetable_addclass_controller.dart';
import 'package:polarstar_flutter/app/modules/board/functions/time_parse.dart';
import 'package:polarstar_flutter/app/modules/board/functions/timetable_daytoindex.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/modules/timetable/widgets/timetable.dart';

var inputDecoration = (hint) => InputDecoration(
    isDense: true,
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    hintStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
        color: const Color(0xff9b9b9b),
        fontWeight: FontWeight.w500,
        fontFamily: "NotoSansSC",
        fontStyle: FontStyle.normal,
        fontSize: 14.0),
    hintText: "${hint}");

var addTimetablenputDecoration = (hint) => InputDecoration(
    isDense: true,
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    hintStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
        color: const Color(0xff9b9b9b),
        fontWeight: FontWeight.w400,
        fontFamily: "NotoSansSC",
        fontStyle: FontStyle.normal,
        fontSize: 14.0),
    hintText: "${hint}");

const textStyle = const TextStyle(
    overflow: TextOverflow.ellipsis,
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontFamily: "PingFangSC",
    fontStyle: FontStyle.normal,
    fontSize: 14.0);

class TimetableAddClass extends StatelessWidget {
  TimetableAddClass({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  final TimeTableAddClassController timeTableAddClassController = Get.find();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: const Color(0xffffffff),
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 56,
              automaticallyImplyLeading: false,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Ink(
                  child: Image.asset(
                    "assets/images/back_icon.png",
                  ),
                ),
              ),
              centerTitle: true,
              titleSpacing: 0,
              title: Text(
                "输入日程",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0),
              ),
              actions: [
                Container(
                    width: 52,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Ink(
                      child: InkWell(
                        onTap: () {
                          bool checkClasses =
                              timeTableAddClassController.checkClassValidate();
                          TimeTableClassModel postData =
                              timeTableAddClassController.TOTAL_CLASS.value;
                          if (postData.PROFESSOR == null ||
                              postData.PROFESSOR.isEmpty) {
                            Get.snackbar("请输入教师姓名", "请输入教师姓名",
                                snackPosition: SnackPosition.BOTTOM);
                          } else if (postData.CLASS_NAME == null ||
                              postData.CLASS_NAME.isEmpty) {
                            Get.snackbar("请输入课程名", "请输入课程名",
                                snackPosition: SnackPosition.BOTTOM);
                          } else if (!checkClasses) {
                            Get.snackbar("重复的时间表", "重复的时间表",
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            timeTableAddClassController.addClass(
                                timeTableController.selectedTimeTableId.value);
                            Get.back();
                          }
                        },
                        child: Center(
                          child: Text("添加",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Get.theme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.right),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        border: Border.all(
                            color: const Color(0xff99bbf9), width: 1),
                        color: const Color(0xffffffff))),
              ],
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(children: [
                Container(
                  color: const Color(0xffffffff),
                  child: Container(
                    height: 55.0 * 5 + 30,
                    child: SingleChildScrollView(
                      // controller: scrollController,
                      // physics: NeverScrollableScrollPhysics(),
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Obx(() {
                        RxBool isExpandedHor =
                            timeTableController.isExpandedHor;
                        int dayAmount = isExpandedHor.value ? 7 : 5;
                        int verAmount = timeTableController.verAmount.value;

                        double time_height =
                            timeTableController.timeHeight.value;
                        double top_height = timeTableController.topHeight.value;

                        return Container(
                          height: top_height + time_height * (verAmount - 1),
                          child: Stack(children: [
                            TimeTableBin(
                                time_height: time_height,
                                top_height: top_height,
                                timeTableController: timeTableController,
                                width: size.width,
                                dayAmount: dayAmount,
                                verAmount: verAmount),
                            TimeTableContent(
                                time_height: time_height,
                                top_height: top_height,
                                timeTableController: timeTableController,
                                width: size.width,
                                dayAmount: dayAmount,
                                verAmount: verAmount),

                            //선택한 애들 띄우기
                            for (Rx<AddClassModel> item
                                in timeTableAddClassController.CLASS_LIST)
                              Positioned(
                                child: TimeTableAddClass(
                                    new_class: item,
                                    time_height: time_height,
                                    top_height: top_height,
                                    width: size.width,
                                    timeTableController: timeTableController,
                                    dayAmount: dayAmount,
                                    show: true,
                                    verAmount: verAmount),
                              )
                          ]),
                        );
                      }),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 24),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // 강의명
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset(
                                          "assets/images/timetable_direct_book.png"),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      child: // 课名
                                          Text("新日程",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color:
                                                      const Color(0xff9b9b9b),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "NotoSansSC",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.left),
                                    )
                                  ]),
                                ),
                                Container(
                                  width: size.width - 20 - 20,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: TextFormField(
                                          controller:
                                              timeTableAddClassController
                                                  .courseNameController,
                                          onChanged: (value) {
                                            timeTableAddClassController
                                                .TOTAL_CLASS
                                                .update((val) {
                                              val.CLASS_NAME =
                                                  timeTableAddClassController
                                                      .courseNameController
                                                      .text;
                                            });
                                          },
                                          maxLines: 1,
                                          style: textStyle,
                                          textAlign: TextAlign.left,
                                          decoration:
                                              addTimetablenputDecoration(
                                                  "请输入日程"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 선 83
                                Container(
                                    margin: const EdgeInsets.only(
                                        top: 7.5, right: 20),
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffeaeaea)))
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 13.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            "assets/images/timetable_direct_professr.png"),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        child: Text("教授名",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: const Color(0xff9b9b9b),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "NotoSansSC",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14.0),
                                            textAlign: TextAlign.left),
                                      )
                                    ]),
                                  ),
                                  Container(
                                    width: size.width - 20 - 20,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: TextFormField(
                                            controller:
                                                timeTableAddClassController
                                                    .professorNameController,
                                            onChanged: (value) {
                                              timeTableAddClassController
                                                  .TOTAL_CLASS
                                                  .update((val) {
                                                val.PROFESSOR =
                                                    timeTableAddClassController
                                                        .professorNameController
                                                        .text;
                                              });
                                            },
                                            maxLines: 1,
                                            style: textStyle,
                                            textAlign: TextAlign.left,
                                            decoration:
                                                addTimetablenputDecoration(
                                                    "请输入教授名"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 선 83
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 7.5, right: 20),
                                      height: 1,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffeaeaea)))
                                ],
                              ),
                            ),

                            //강의 장소 및 시간
                            Container(
                              margin: const EdgeInsets.only(top: 13.5),
                              child: ClassInfoTPO(
                                size: size,
                                timeTableAddClassController:
                                    timeTableAddClassController,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ]),
            )),
      ),
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
    final days = ["월", "화", "수", "목", "금", "토", "일"];

    return Obx(() {
      if (timeTableAddClassController.dataAvailable.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 사각형 102
                Container(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Image.asset(
                        "assets/images/timetable_direct_clock.png",
                        width: 12,
                        height: 12,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: const Color(0xfff4f9ff))),
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  child: // 钟点
                      Text("时间",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xff9b9b9b),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                )
              ],
            ),
            Obx(() {
              return Container(
                child: ListView.builder(
                    shrinkWrap: true,
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
                          margin: const EdgeInsets.only(top: 10, right: 20),
                          child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  color: const Color(0xffeaeaea))),
                        ),
                      ]);
                    }),
              );
            }),

            // 사각형 511
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 65,
              height: 24,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: const Color(0xff4c74f6), width: 1),
                  color: const Color(0xffffffff)),
              child: InkWell(
                onTap: () {
                  timeTableAddClassController.selectIndex.value += 1;
                },
                child: // complete
                    Center(
                  child: // 添加时间
                      Text("添加时间",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xff4570ff),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.left),
                ),
              ),
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
                  padding: const EdgeInsets.only(left: 12),
                );
              }),
              Obx(() {
                return Container(
                  child: SelectEndTime(
                      newClass:
                          timeTableAddClassController.CLASS_LIST[classIndex]),
                  padding: const EdgeInsets.only(left: 12),
                );
              }),
              Container(
                child: ClassTrashCan(
                    classIndex: classIndex,
                    timeTableAddClassController: timeTableAddClassController),
                margin: const EdgeInsets.only(left: 12),
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
            decoration: addTimetablenputDecoration("请输入场所"),
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
        width: 16,
        height: 16,
        child: Image.asset(
          "assets/images/timetable_direct_delete.png",
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
  List<String> days;
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
            child: Image.asset("assets/images/940.png",
                color: Get.theme.primaryColor),
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
                    padding: const EdgeInsets.only(right: 4),
                    child: // 星期一
                        Text("${dayConverter(e)}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: const Color(0xff9b9b9b),
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left),
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

        await Get.defaultDialog(
            title: "时间选择",
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

        int cal_time = timeInput.hour;
        if (cal_time >= 0 && cal_time < 24) {
          timeInput = timeInput;
        } else {
          // Get.snackbar("0시부터 24시 사이로 골라주세요", "0시부터 24시 사이로 골라주세요",
          //     snackPosition: SnackPosition.BOTTOM);
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
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xff9b9b9b),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),
          ),
          Container(
            width: 10.68267822265625,
            height: 5.931396484375,
            margin: const EdgeInsets.only(left: 10.7, top: 8, bottom: 4.5),
            child: Image.asset("assets/images/940.png",
                color: Get.theme.primaryColor),
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

        await Get.defaultDialog(
            title: "时间选择",
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

        int cal_time = timeInput.hour;

        if (cal_time > 0 && cal_time <= 24) {
          timeInput = timeInput;
        } else {
          // Get.snackbar("0시부터 24시 사이로 골라주세요", "0시부터 24시 사이로 골라주세요",
          //     snackPosition: SnackPosition.BOTTOM);
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
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xff9b9b9b),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),
          ),
          Container(
            width: 10.68267822265625,
            height: 5.931396484375,
            margin: const EdgeInsets.only(left: 10.7, top: 8, bottom: 4.5),
            child: Image.asset("assets/images/940.png",
                color: Get.theme.primaryColor),
          )
        ]);
      }),
    );
  }
}