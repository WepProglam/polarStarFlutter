import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_addclass_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

class TimetableAddClass extends StatelessWidget {
  TimetableAddClass({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  final TimeTableAddClassController timeTableAddClassController = Get.find();
  @override
  Widget build(BuildContext context) {
    print("asdfasdf");
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
                            child: Text("Complete",
                                style: const TextStyle(
                                    color: const Color(0xff1a4678),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.center),
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
            color: Colors.black,
            height: 479.3,
            child: Center(
              child: Text(
                "시간표",
                style: TextStyle(color: Colors.white),
              ),
            ),
            width: size.width,
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, top: 11.3),
            child: Column(
              children: [
                //강의명
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: // Course name
                            Text("Course name",
                                style: const TextStyle(
                                    color: const Color(0xff333333),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                                textAlign: TextAlign.center) // renyuan – 2

                        ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, bottom: 14.3),
                      child: Text("Please enter the course name",
                          style: const TextStyle(
                              color: const Color(0xff999999),
                              fontWeight: FontWeight.w400,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.3),
                      child: Container(
                          width: size.width - 15.3 - 14.8,
                          height: 0.5,
                          decoration:
                              BoxDecoration(color: const Color(0xffdedede))),
                    )
                  ],
                ),
                //교강사명
                Container(
                  margin: const EdgeInsets.only(top: 12.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 0.5, bottom: 12),
                          child:
                              // The teacher name
                              Text("The teacher name",
                                  style: const TextStyle(
                                      color: const Color(0xff333333),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "PingFangSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0),
                                  textAlign: TextAlign.center)),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.1, bottom: 14.3),
                        child: Text("Please enter the course name",
                            style: const TextStyle(
                                color: const Color(0xff999999),
                                fontWeight: FontWeight.w400,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.3),
                        child: Container(
                            width: size.width - 15.3 - 14.8,
                            height: 0.5,
                            decoration:
                                BoxDecoration(color: const Color(0xffdedede))),
                      )
                    ],
                  ),
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
        int classIndex = timeTableAddClassController.selectIndex.value;
        Rx<AddClassModel> newClass =
            timeTableAddClassController.CLASS_LIST[classIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 2.5),
                child:
                    // Class time and place
                    Text("Class time and place",
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w700,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        textAlign: TextAlign.center)),
            Container(
              child: TpoSelector(
                  timeTableAddClassController: timeTableAddClassController,
                  classIndex: classIndex,
                  days: days,
                  size: size),
              padding: const EdgeInsets.only(bottom: 18.8),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.1, bottom: 14.3),
              child: Text("Please enter the course name",
                  style: const TextStyle(
                      color: const Color(0xff999999),
                      fontWeight: FontWeight.w400,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.3),
              child: Container(
                  width: size.width - 15.3 - 14.8,
                  height: 0.5,
                  decoration: BoxDecoration(color: const Color(0xffdedede))),
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
  const TpoSelector(
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

  @override
  Widget build(BuildContext context) {
    return Column(
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
                child: ClassTrashCan(),
                margin: const EdgeInsets.only(right: 21.4),
              )
            ],
          ),
        ),
        Container(
          width: size.width - 15.3 - 14.8,
          height: 0.5,
          // margin: const EdgeInsets.only(top: 14.3),
          decoration: BoxDecoration(color: const Color(0xffdedede)),
        ),
      ],
    );
  }
}

class ClassTrashCan extends StatelessWidget {
  const ClassTrashCan({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17.104248046875,
      height: 16.619873046875,
      child: Image.asset(
        "assets/images/15_4.png",
        fit: BoxFit.fitHeight,
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
        newClass.update((val) {
          val.start_time = "${time.hour}:${time.minute}";
        });
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
        newClass.update((val) {
          val.end_time = "${time.hour}:${time.minute}";
        });
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
