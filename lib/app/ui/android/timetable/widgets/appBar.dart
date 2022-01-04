import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';

class TimeTableAppBar extends StatelessWidget {
  TimeTableAppBar({Key key, @required this.timeTableController})
      : super(key: key);

  final TimeTableController timeTableController;
  final courseNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 56,

      backgroundColor: Get.theme.primaryColor,
      titleSpacing: 0,
      // elevation: 0,
      automaticallyImplyLeading: false,
      title: Container(
          width: Get.mediaQuery.size.width,
          margin: const EdgeInsets.only(top: 16, bottom: 16),
          child: Stack(children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: (92 + 24.0)),
                child: Obx(() {
                  return Text(
                      "${timeTableController.selectTable.value.YEAR}년 ${timeTableController.selectTable.value.SEMESTER}학기",
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansTC",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.left);
                }),
              ),
            ),
            // Positioned(
            //   left: 20,
            //   child: Ink(
            //     child: InkWell(
            //       onTap: () {
            //         Get.back();
            //       },
            //       child: Image.asset(
            //         "assets/images/back_icon.png",
            //         width: 24,
            //         height: 24,
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              left: 20,
              child: Ink(
                child: InkWell(
                  onTap: () {
                    Get.toNamed("/timetable/bin");
                  },
                  child: Image.asset(
                    "assets/images/menu.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              child: Ink(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.TIMETABLE_ADDCLASS_MAIN);
                  },
                  child: Image.asset(
                    "assets/images/icn_plus.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),

            Positioned(
              right: 52,
              child: Ink(
                child: InkWell(
                  onTap: () {
                    showSetting(context, courseNameController,
                        timeTableController.selectTable);
                  },
                  child: Image.asset(
                    "assets/images/icn_setting.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(left: 15),
            //   child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Container(
            //             height: 28,
            //             child: TopIcon(
            //                 timeTableController: timeTableController,
            //                 selectedModel: timeTableController.selectTable)),
            //         Container(
            //           height: 18.5,
            //           margin: const EdgeInsets.only(top: 3.5),
            //           child: Obx(() {
            //             print(
            //                 "${timeTableController.selectTable.value.SEMESTER}학기");
            //             return Text(
            //                 "${timeTableController.selectTable.value.YEAR}년 ${timeTableController.selectTable.value.SEMESTER}학기",
            //                 overflow: TextOverflow.ellipsis,
            //                 style: const TextStyle(
            //                     color: const Color(0xff333333),
            //                     fontWeight: FontWeight.w400,
            //                     fontStyle: FontStyle.normal,
            //                     fontSize: 14.0),
            //                 textAlign: TextAlign.left);
            //           }),
            //         )
            //       ]),
            // ),
          ])),
    );
  }
}
