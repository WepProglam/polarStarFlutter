import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
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
                height: 44 + 60.0 * 11,
                child: TimeTable(
                  timeTableController: timeTableController,
                  width: size.width,
                ),
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

class TimeTable extends StatelessWidget {
  const TimeTable(
      {Key key, @required this.timeTableController, @required this.width})
      : super(key: key);

  final TimeTableController timeTableController;
  final double width;

  @override
  Widget build(BuildContext context) {
    final List<String> days = [
      "MON.",
      "Tues.",
      "Wed.",
      "Thur.",
      "Fri.",
      "Sat.",
      "Sun."
    ];
    return Column(
      children: [
        Container(
          height: 44 + 60.0 * 11,
          child: ListView.builder(
              itemCount: 12,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    height: 44,
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     border: Border(
                    //         bottom:
                    //             BorderSide(color: Colors.black, width: 0.5))),
                    child: TimeTableDays(width: width, days: days),
                  );
                } else {
                  return Container(
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          width: width,
                          child: ListView.builder(
                              itemCount: 8,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int i) {
                                if (i == 0) {
                                  return Container(
                                    width: width / 12,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        border: Border(
                                            right: BorderSide(
                                                color: Colors.black,
                                                width: 0.5),
                                            bottom: BorderSide(
                                                color: Colors.black,
                                                width: 0.5))),
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
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            right: BorderSide(
                                                color: Colors.black,
                                                width: 0.5),
                                            bottom: BorderSide(
                                                color: Colors.black,
                                                width: 0.5))),
                                  );
                                }
                              }),
                        )
                      ],
                    ),
                  );
                }
              }),
        )
      ],
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
                    color: Colors.grey,
                  );
                } else {
                  return Container(
                    width: (width * (11 / 12)) / 7,
                    color: Colors.grey,
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
