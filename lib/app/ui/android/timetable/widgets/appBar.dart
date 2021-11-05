import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';

class TimeTableAppBar extends StatelessWidget {
  const TimeTableAppBar({
    Key key,
    @required this.timeTableController,
  }) : super(key: key);

  final TimeTableController timeTableController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   systemNavigationBarColor: Colors.blue, // Navigation bar
      //   statusBarColor: Colors.pink, // Status bar
      // ),
      toolbarHeight: 50 + 17.5,
      brightness: Brightness.light,
      backgroundColor: const Color(0xffffffff),
      elevation: 0,
      titleSpacing: 0,
      title: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 7.5),
          child: Container(
            margin: const EdgeInsets.only(left: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  height: 28,
                  child: TopIcon(
                      timeTableController: timeTableController,
                      selectedModel: timeTableController.selectTable)),
              Container(
                height: 18.5,
                margin: const EdgeInsets.only(top: 3.5),
                child: Obx(() {
                  print("${timeTableController.selectTable.value.SEMESTER}학기");
                  return Text(
                      "${timeTableController.selectTable.value.YEAR}년 ${timeTableController.selectTable.value.SEMESTER}학기",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left);
                }),
              )
            ]),
          )),
    );
  }
}
