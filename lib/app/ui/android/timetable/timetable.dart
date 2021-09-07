import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

class Timetable extends StatelessWidget {
  Timetable({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar:
              CustomBottomNavigationBar(mainController: mainController),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                child: Obx(() {
                  return timeTableController.dataAvailable.value
                      ? TopIcon(
                          timeTableController: timeTableController,
                        )
                      : InkWell(
                          onTap: () {
                            Get.toNamed("/class");
                          },
                          child: Icon(Icons.person),
                        );
                }),
              ),
              Row(children: [
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15, 3.5, 0, 0),
                    child: Text(
                        timeTableController.dataAvailable.value
                            ? "${timeTableController.yearSem}"
                            : "no info",
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w400,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  );
                }),
                Spacer(),
              ]),
              Container(
                width: size.width,
                margin: const EdgeInsets.only(top: 15.5),
                height: 44 + 60.0 * 14,
                child: Stack(children: [
                  TimeTableBin(
                    timeTableController: timeTableController,
                    width: size.width,
                  ),
                  TimeTableContent(
                    timeTableController: timeTableController,
                    width: size.width,
                  )
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, top: 20.3),
                height: 44,
                //시간표 리스트
                child: Obx(() {
                  return timeTableController.dataAvailable.value
                      ? TableList(
                          timeTableController: timeTableController,
                        )
                      : Container();
                }),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, top: 22, bottom: 20),
                height: 184.5,
                //과목 리스트
                child: Obx(() {
                  return timeTableController.dataAvailable.value
                      ? SubjectList(
                          timeTableController: timeTableController,
                        )
                      : Container();
                }),
              )
            ],
          ))),
    );
  }
}

class TimeTableBin extends StatelessWidget {
  const TimeTableBin(
      {Key key, @required this.timeTableController, @required this.width})
      : super(key: key);

  final TimeTableController timeTableController;
  final double width;

  @override
  Widget build(BuildContext context) {
    final List<String> days = [
      "Mon.",
      "Tues.",
      "Wed.",
      "Thur.",
      "Fri.",
      "Sat.",
      "Sun."
    ];
    return Container(
      height: 44 + 60.0 * 14,
      child: ListView.builder(
          itemCount: 14,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                height: 44,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 0.5))),
                child: TimeTableDays(width: width, days: days),
              );
            } else {
              return Container(
                height: 60,
                child: ListView.builder(
                    itemCount: 8,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int i) {
                      if (i == 0) {
                        return Container(
                          width: width / 12,
                          decoration: tableBoxDecoration,
                          child: Center(
                            child: Text("${index + 8}",
                                style: const TextStyle(
                                    color: const Color(0xff333333),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                          ),
                        );
                      } else {
                        return Container(
                          width: (width * (11 / 12)) / 7,
                          decoration: innerTableBoxDecoration,
                        );
                      }
                    }),
              );
            }
          }),
    );
  }
}

class TimeTableContent extends StatelessWidget {
  const TimeTableContent(
      {Key key, @required this.timeTableController, @required this.width})
      : super(key: key);

  final TimeTableController timeTableController;
  final double width;

  @override
  Widget build(BuildContext context) {
    final List<String> days = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];

    return Container(
      height: 60.0 * 14,
      width: width * 11 / 12,
      margin: EdgeInsets.only(top: 44, left: width / 12),
      child: ListView.builder(
          itemCount: 7,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            int class_index = 0;

            return Container(
              height: 60 / 12,
              width: (width * 11 / 12) / 7,
              child: ListView.builder(
                  itemCount: 14 * 12,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int i) {
                    int time = 9 * 60 + i * 5;

                    if (timeTableController.showTimeTable[index].length <=
                        class_index) {
                      return SizedBox.shrink();
                    } else if (timeTableController.showTimeTable[index]
                                [class_index]["start_time"] <=
                            time &&
                        timeTableController.showTimeTable[index][class_index]
                                ["end_time"] >=
                            time) {
                      print(
                          "start : ${timeTableController.showTimeTable[index][class_index]["start_time"]} end : ${timeTableController.showTimeTable[index][class_index]["end_time"]} time : ${time}");

                      if (timeTableController.showTimeTable[index][class_index]
                              ["end_time"] ==
                          time) {
                        class_index += 1;
                      }
                      return Container(
                        height: 60 / 12,
                        color: Colors.orange,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
            );
          }),
    );
  }
}

class TimeTableDays extends StatelessWidget {
  const TimeTableDays({
    Key key,
    @required this.width,
    @required this.days,
  }) : super(key: key);

  final double width;
  final List<String> days;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: width,
          child: ListView.builder(
              itemCount: 8,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return Container(
                    width: width / 12,
                    decoration: tableBoxDecoration,
                  );
                } else {
                  return Container(
                    width: (width * (11 / 12)) / 7,
                    decoration: tableBoxDecoration,
                    child: Center(
                      child: Text(
                        "${days[i - 1]}",
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w700,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                    ),
                  );
                }
              }),
        )
      ],
    );
  }
}

const tableBoxDecoration = BoxDecoration(
    color: Colors.grey,
    border: Border(
        bottom: BorderSide(color: Colors.black, width: 0.5),
        right: BorderSide(color: Colors.black, width: 0.5)));

const innerTableBoxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border(
        bottom: BorderSide(color: Colors.black, width: 0.5),
        right: BorderSide(color: Colors.black, width: 0.5)));
