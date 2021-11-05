import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/timetable.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

class Timetable extends StatelessWidget {
  Timetable({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        bottomNavigationBar:
            CustomBottomNavigationBar(mainController: mainController),
        body: SingleChildScrollView(
            controller: timeTableController.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 28,
                            child: TopIcon(
                                timeTableController: timeTableController,
                                selectedModel:
                                    timeTableController.selectTable)),
                        Container(
                          height: 18.5,
                          margin: const EdgeInsets.only(top: 3.5),
                          child: Obx(() {
                            print(
                                "${timeTableController.selectTable.value.SEMESTER}학기");
                            return FittedBox(
                              child: Text(
                                  "${timeTableController.selectTable.value.YEAR}년 ${timeTableController.selectTable.value.SEMESTER}학기",
                                  style: const TextStyle(
                                      color: const Color(0xff333333),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.left),
                            );
                          }),
                        )
                      ]),
                )),
                Container(
                    margin:
                        const EdgeInsets.only(top: 15.5, left: 15, right: 15),
                    child: TimeTablePackage(
                        timeTableController: timeTableController,
                        size: size,
                        scrollable: false)),
                Container(
                  margin:
                      const EdgeInsets.only(top: 8, left: 15.3, right: 15.3),
                  child: Row(
                    children: [
                      // 선 43
                      Container(
                          height: 0.5,
                          width: Get.size.width / 2 - 9.8 - 15.3 - 20,
                          margin: const EdgeInsets.only(
                              top: 6.5, bottom: 6.5, right: 9.8),
                          decoration:
                              BoxDecoration(color: const Color(0xffdedede))),

                      Ink(
                          width: 40,
                          child: InkWell(
                            onTap: () {
                              timeTableController.isHidden.value =
                                  !timeTableController.isHidden.value;
                            },
                            child: Image.asset(
                                "assets/images/timetable_hidden.png"),
                          )),

                      Container(
                          height: 0.5,
                          width: Get.size.width / 2 - 9.8 - 15.3 - 20,
                          margin: const EdgeInsets.only(
                              top: 6.5, bottom: 6.5, left: 9.8),
                          decoration:
                              BoxDecoration(color: const Color(0xffdedede)))
                    ],
                  ),
                ),
                Obx(() {
                  bool isHidden = timeTableController.isHidden.value;
                  if (isHidden) {
                    return Container();
                  }
                  return Container(
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
                  );
                }),
                Obx(() {
                  bool isHidden = timeTableController.isHidden.value;
                  if (isHidden) {
                    return Container();
                  }
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 15, top: 22, bottom: 20, right: 15),
                    height: 184.5,
                    //과목 리스트
                    child: SubjectList(model: timeTableController.selectTable),
                  );
                })
              ],
            )));
  }
}

class TimeTablePackage extends StatelessWidget {
  const TimeTablePackage(
      {Key key,
      @required this.timeTableController,
      @required this.size,
      @required this.scrollable})
      : super(key: key);

  final TimeTableController timeTableController;
  final Size size;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: scrollable
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      child: Obx(() {
        RxBool isExpandedHor = timeTableController.isExpandedHor;

        int dayAmount = isExpandedHor.value ? 7 : 5;
        int verAmount = timeTableController.verAmount.value;
        print("verAmount : $verAmount");
        return Container(
          child: Column(
            children: [
              Container(
                height: 44 + 60.0 * (verAmount - 1),
                child: Stack(children: [
                  Obx(() {
                    // temp 이거 뺴면 오류남(야매)
                    bool temp = timeTableController.dataAvailable.value;
                    return TimeTableBin(
                        timeTableController: timeTableController,
                        width: size.width - 30,
                        dayAmount: dayAmount,
                        verAmount: verAmount);
                  }),
                  Obx(() {
                    // temp 이거 뺴면 오류남(야매)
                    bool temp = timeTableController.dataAvailable.value;
                    return TimeTableContent(
                        timeTableController: timeTableController,
                        width: size.width - 30,
                        dayAmount: dayAmount,
                        verAmount: verAmount);
                  })
                ]),
              )
            ],
          ),
        );
      }),
    );
  }
}
