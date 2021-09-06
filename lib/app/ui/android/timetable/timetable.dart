import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';

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
                color: Colors.black,
                margin: const EdgeInsets.only(top: 15.5),
                height: 60.0 * 12,
                child: TimeTable(timeTableController: timeTableController),
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
  const TimeTable({
    Key key,
    @required this.timeTableController,
  }) : super(key: key);

  final TimeTableController timeTableController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60.0 * 12,
          child: ListView.builder(
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 60,
                  color: Colors.white10,
                );
              }),
        )
      ],
    );
  }
}
