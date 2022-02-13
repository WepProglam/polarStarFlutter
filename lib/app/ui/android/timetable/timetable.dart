import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/functions/showClassDetail.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/appBar.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/table_list.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/timetable.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';
import 'package:flutter/services.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/main.dart';

class Timetable extends StatelessWidget {
  Timetable({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: TimeTableAppBar(
                timeTableController: timeTableController,
              )),
          body: TimeTableBody(
              timeTableController: timeTableController, size: size)),
    );
  }
}

class TimeTableBody extends StatelessWidget {
  const TimeTableBody({
    Key key,
    @required this.timeTableController,
    @required this.size,
  }) : super(key: key);

  final TimeTableController timeTableController;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!timeTableController.isReady.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      // int icampusOrUndeterminedCount = 0;
      // for (TimeTableClassModel item
      //     in timeTableController.selectTable.value.CLASSES) {
      //   if (item.IS_ICAMPUS || item.IS_NOT_DETERMINED) {
      //     icampusOrUndeterminedCount += 1;
      //   }
      // }
      return SingleChildScrollView(
          controller: timeTableController.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: TimeTablePackage(
                      timeTableController: timeTableController,
                      size: size,
                      scrollable: false)),

              ListView.builder(
                  // padding: const EdgeInsets.only(left: 20),
                  itemCount:
                      timeTableController.getIcampusOrUndetermined.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    TimeTableClassModel model =
                        timeTableController.getIcampusOrUndetermined[index];
                    return Ink(
                      child: InkWell(
                        onTap: () async {
                          await ShowClassDetail(model, timeTableController);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: const Color(0xffdedede),
                                        width: 0.5))),
                            child: Row(
                              children: [
                                Container(
                                  height: timeTableController.timeHeight.value,
                                  color: const Color(0xfff7fbff),
                                  width: Get.mediaQuery.size.width / 12,
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                      color: const Color(0xff9B9B9B),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Center(
                                      child: Container(
                                          child: Text("${model.CLASS_NAME}",
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color:
                                                      const Color(0xff9b9b9b),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "NotoSansKR",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0),
                                              textAlign: TextAlign.left))),
                                ),
                              ],
                            )),
                      ),
                    );
                  }),

              Obx(() {
                bool isHidden = timeTableController.isHidden.value;
                if (isHidden) {
                  return Container();
                }
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 42,
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
                  return Container(
                    height: 40,
                  );
                }
                return (timeTableController.selectTable.value.CLASSES == null ||
                        timeTableController.selectTable.value.CLASSES.length ==
                            0)
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(top: 14, bottom: 20),
                        height: 144,
                        //과목 리스트
                        child:
                            SubjectList(model: timeTableController.selectTable),
                      );
              }),
              // Container(
              //   height: 86,
              // )
            ],
          ));
    });
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

        return Container(
          child: Column(
            children: [
              Obx(() {
                double top_height =
                    timeTableController.topHeight.value; //원래는 30
                double time_height =
                    timeTableController.timeHeight.value; //원래는 55
                return Container(
                  height: top_height + time_height * (verAmount - 1),
                  child: Stack(children: [
                    Obx(() {
                      // temp 이거 뺴면 오류남(야매)
                      bool temp = timeTableController.dataAvailable.value;
                      return TimeTableBin(
                          timeTableController: timeTableController,
                          width: size.width,
                          top_height: top_height,
                          time_height: time_height,
                          dayAmount: dayAmount,
                          verAmount: verAmount);
                    }),
                    Obx(() {
                      // temp 이거 뺴면 오류남(야매)
                      bool temp = timeTableController.dataAvailable.value;
                      return TimeTableContent(
                          timeTableController: timeTableController,
                          width: size.width,
                          top_height: top_height,
                          time_height: time_height,
                          dayAmount: dayAmount,
                          verAmount: verAmount);
                    })
                  ]),
                );
              })
            ],
          ),
        );
      }),
    );
  }
}
