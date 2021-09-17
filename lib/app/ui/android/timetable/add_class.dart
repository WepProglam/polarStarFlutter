import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_addclass_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/timetable.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

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

class TimetableAddClass extends StatelessWidget {
  TimetableAddClass({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  final TimeTableAddClassController timeTableAddClassController = Get.find();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
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
                            padding: const EdgeInsets.fromLTRB(7.5, 4, 7, 5.5),
                            child: InkWell(
                              onTap: () {
                                print(timeTableAddClassController
                                    .TOTAL_CLASS.value.className);
                                print(timeTableAddClassController
                                    .TOTAL_CLASS.value.professor);
                                for (var items in timeTableController
                                    .selectTable.value.CLASSES) {
                                  for (var dd in items.value.classes) {
                                    print("${dd.day},${dd.start_time}");
                                  }
                                }

                                print("==============================");

                                for (var item
                                    in timeTableAddClassController.CLASS_LIST) {
                                  //여기 검증하는 코드 추가 필요
                                  print(item.value.day);
                                  print(item.value.start_time);
                                  print(item.value.end_time);
                                  print(item.value.classRoom);
                                }
                                timeTableAddClassController.addClass(
                                    timeTableController
                                        .selectedTimeTableId.value);
                                Get.back();
                              },
                              child: Text("Complete",
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
          Container(
            margin: const EdgeInsets.only(top: 12.5),
            height: 200,
            child: TimeTablePackage(
              timeTableController: timeTableController,
              size: size,
              scrollable: true,
            ),
            width: size.width,
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, top: 11.3),
            child: Column(
              children: [
                //교강사명
                Container(
                  margin: const EdgeInsets.only(top: 12.3),
                  child: Row(children: [
                    Container(
                      width: 10,
                      margin: const EdgeInsets.only(bottom: 14.3),
                      child: Icon(Icons.book),
                    ),
                    Container(
                      width: size.width - 15.3 - 14.8 - 30,
                      margin: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14.3),
                            child: TextFormField(
                              controller: timeTableAddClassController
                                  .professorNameController,
                              onChanged: (value) {
                                timeTableAddClassController.TOTAL_CLASS
                                    .update((val) {
                                  val.professor = timeTableAddClassController
                                      .professorNameController.text;
                                });
                              },
                              maxLines: 1,
                              style: textStyle,
                              textAlign: TextAlign.left,
                              decoration: inputDecoration("professor"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                //강의명
                Container(
                  margin: const EdgeInsets.only(top: 12.3),
                  child: Row(children: [
                    Container(
                      width: 10,
                      margin: const EdgeInsets.only(bottom: 14.3),
                      child: Icon(Icons.school),
                    ),
                    Container(
                      width: size.width - 15.3 - 14.8 - 30,
                      margin: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14.3),
                            child: TextFormField(
                              controller: timeTableAddClassController
                                  .courseNameController,
                              onChanged: (value) {
                                timeTableAddClassController.TOTAL_CLASS
                                    .update((val) {
                                  val.className = timeTableAddClassController
                                      .courseNameController.text;
                                });
                              },
                              maxLines: 1,
                              style: textStyle,
                              textAlign: TextAlign.left,
                              decoration: inputDecoration("course"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                //강의 장소 및 시간
                Container(
                  margin: const EdgeInsets.only(top: 12.3),
                  child: ClassInfoTPO(
                    size: size,
                    timeTableAddClassController: timeTableAddClassController,
                  ),
                )
              ],
            ),
          )
        ],
      ))),
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
                  timeTableAddClassController.CLASS_LIST.length * 92.0;
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
                val.classRoom = timeTableAddClassController
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
  const SelectDay({
    Key key,
    @required this.newClass,
    @required this.days,
  }) : super(key: key);

  final Rx<AddClassModel> newClass;
  final List<String> days;

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
  const SelectStartTime({
    Key key,
    @required this.newClass,
  }) : super(key: key);

  final Rx<AddClassModel> newClass;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        List<String> timeInfo = newClass.value.start_time.split(":");
        TimeOfDay time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
                hour: int.parse(timeInfo[0]), minute: int.parse(timeInfo[1])));
        if (time.hour > 21 || time.hour < 9) {
          Get.snackbar("9시에서 21시 사이로 선택해주세요", "9시에서 21시 사이로 선택해주세요");
        } else {
          newClass.update((val) {
            String tempHour = time.hour.toString();
            String tempMin = time.minute.toString();

            if (tempHour.length == 1) {
              tempHour = "0" + tempHour;
            }

            if (tempMin.length == 1) {
              tempMin += "0";
            }
            val.start_time = "${tempHour}:${tempMin}";
          });
        }
      },
      child: Obx(() {
        return Row(children: [
          Container(
            child: Text("${newClass.value.start_time}",
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
        List<String> timeInfo = newClass.value.end_time.split(":");
        TimeOfDay time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
                hour: int.parse(timeInfo[0]), minute: int.parse(timeInfo[1])));

        if (time.hour > 21 || time.hour < 9) {
          Get.snackbar("9시에서 21시 사이로 선택해주세요", "9시에서 21시 사이로 선택해주세요");
        } else {
          newClass.update((val) {
            String tempHour = time.hour.toString();
            String tempMin = time.minute.toString();

            if (tempHour.length == 1) {
              tempHour = "0" + tempHour;
            }

            if (tempMin.length == 1) {
              tempMin += "0";
            }
            val.end_time = "${tempHour}:${tempMin}";
          });
        }
      },
      child: Obx(() {
        return Row(children: [
          Container(
            child: Text("${newClass.value.end_time}",
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
