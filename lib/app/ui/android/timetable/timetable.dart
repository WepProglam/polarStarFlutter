import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

class Timetable extends StatelessWidget {
  const Timetable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TimeTableController timeTableController = Get.find();
    final MainController mainController = Get.find();
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar:
            CustomBottomNavigationBar(mainController: mainController),
        body: Obx(() {
          if (timeTableController.dataAvailable.value) {
            return SingleChildScrollView(
                child: Column(
              children: [
                TopIcon(
                  timeTableController: timeTableController,
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 3.5, 0, 0),
                    child: Text(
                        "${timeTableController.selectYearSemester.value.YEAR}년 ${timeTableController.selectYearSemester.value.SEMESTER}학기",
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w400,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  Spacer(),
                ]),
                Container(
                  width: size.width,
                  color: Colors.black,
                  margin: const EdgeInsets.only(top: 15.5),
                  height: 479.3,
                  child: Center(
                    child: Text("시간표", style: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, top: 20.3),
                  height: 44,
                  //시간표 리스트
                  child: TableList(
                    timeTableController: timeTableController,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, top: 22, bottom: 20),
                  height: 184.5,
                  //과목 리스트
                  child: SubjectList(
                    timeTableController: timeTableController,
                  ),
                )
              ],
            ));
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
