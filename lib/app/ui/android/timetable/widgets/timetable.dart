import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/timetable_daytoindex.dart';

class TimeTableBin extends StatelessWidget {
  const TimeTableBin(
      {Key key,
      @required this.timeTableController,
      @required this.width,
      @required this.dayAmount,
      @required this.verAmount})
      : super(key: key);

  final TimeTableController timeTableController;
  final double width;
  final int dayAmount;
  final int verAmount;

  @override
  Widget build(BuildContext context) {
    List<String> days = dayAmount == 7
        ? ["Mon.", "Tues.", "Wed.", "Thur.", "Fri.", "Sat.", "Sun."]
        : ["Mon.", "Tues.", "Wed.", "Thur.", "Fri."];
    return Container(
      child: ListView.builder(
          itemCount: verAmount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                height: 44,
                decoration: BoxDecoration(
                    color: const Color(0xfff6f6f6),
                    border: Border(
                        bottom: BorderSide(
                            color: const Color(0xffdedede), width: 0.5))),
                child: TimeTableDays(width: width, days: days),
              );
            } else {
              return Container(
                height: 60,
                child: ListView.builder(
                    itemCount: dayAmount + 1,
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
                          width: (width * (11 / 12)) / dayAmount,
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

class TimeTableAddClass extends StatelessWidget {
  const TimeTableAddClass(
      {Key key,
      @required this.new_class,
      @required this.width,
      @required this.dayAmount,
      @required this.verAmount,
      @required this.show})
      : super(key: key);

  final Rx<AddClassModel> new_class;
  final double width;
  final int dayAmount;
  final int verAmount;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return show
        ? Container(
            // width: 10,
            margin: EdgeInsets.only(top: 44, left: width / 12),
            child: Container(
              child: Obx(() {
                int last_end_time = 60 * 9;

                int start_time = new_class.value.start_time.hour * 60 +
                    new_class.value.start_time.minute;
                int end_time = new_class.value.end_time.hour * 60 +
                    new_class.value.end_time.minute;

                if (start_time >= end_time) {
                  start_time = end_time;
                }

                return Opacity(
                  opacity: 0.5,
                  child: Container(
                    width: (width * 11 / 12) / dayAmount,
                    height: (end_time - start_time) * 1.0,
                    decoration: contentTableBoxDecoration(Colors.black),
                    margin: EdgeInsets.only(
                        top: (start_time - last_end_time) * 1.0,
                        left: getIndexFromDay(new_class.value.day) *
                            (width * 11 / 12) /
                            dayAmount),
                  ),
                );
              }),
            ))
        : Container();
  }
}

class TimeTableContent extends StatelessWidget {
  const TimeTableContent(
      {Key key,
      @required this.timeTableController,
      @required this.width,
      @required this.dayAmount,
      @required this.verAmount})
      : super(key: key);

  final TimeTableController timeTableController;
  final double width;
  final int dayAmount;
  final int verAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 11 / 12,
      margin: EdgeInsets.only(top: 44, left: width / 12),
      child: ListView.builder(
          itemCount: dayAmount,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            int last_end_time = 60 * 9;
            return Container(
                width: (width * 11 / 12) / dayAmount,
                child: Obx(() {
                  return Stack(
                    children: [
                      for (var item in timeTableController.showTimeTable[index])
                        Positioned(
                          top: (item["start_time"] - last_end_time) * 1.0,
                          width: (width * 11 / 12) / dayAmount,
                          child: TimeTableItem(
                            classItem: item,
                            classItemModel: item["classInfo"],
                            curEndTime: last_end_time,
                            timeTableController: timeTableController,
                          ),
                        )
                    ],
                  );
                }));
          }),
    );
  }
}

class TimeTableItem extends StatelessWidget {
  const TimeTableItem(
      {Key key,
      @required this.classItem,
      @required this.curEndTime,
      @required this.classItemModel,
      @required this.timeTableController})
      : super(key: key);

  final Map classItem;
  final int curEndTime;
  final TimeTableClassModel classItemModel;
  final TimeTableController timeTableController;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: () {
          List<String> times = classItemModel.CLASS_TIME
              .map((e) =>
                  "${e.day} ${timeFormatter(e.start_time)}~${timeFormatter(e.end_time)}\n")
              .toList();

          String timeString = "";
          for (String item in times) {
            timeString += item;
          }
          Get.defaultDialog(
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              title: "",
              content: Container(
                // height: 300,
                width: 300,
                color: Colors.white,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: classItem["color"],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Container(
                                child: Text("${classItemModel.CLASS_NAME}"),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              child: Icon(Icons.person),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Container(
                                child: Text("${classItemModel.PROFESSOR}"),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              child: Icon(Icons.lock_clock),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Container(
                                // width: 300 - 30.0 - 40,
                                child: FittedBox(
                                  child: Text(
                                    "${timeString}",
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              child: Icon(Icons.location_city),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Container(
                                child: FittedBox(
                                  child: Text(
                                    "${classItemModel.CLASS_NUMBER}",
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            Ink(
                              child: InkWell(
                                onTap: () async {
                                  var statusCode =
                                      await timeTableController.deleteClass(
                                          timeTableController
                                              .selectTable.value.TIMETABLE_ID,
                                          classItemModel.CLASS_NAME);
                                  switch (statusCode) {
                                    case 200:
                                      timeTableController.selectTable
                                          .update((val) {
                                        val.CLASSES.removeWhere((element) =>
                                            element.CLASS_NAME ==
                                            classItemModel.CLASS_NAME);
                                      });

                                      timeTableController.initShowTimeTable();
                                      timeTableController.makeShowTimeTable();

                                      break;
                                    default:
                                  }

                                  Get.back();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Container(
                                    child: FittedBox(
                                      child: Text(
                                        "삭제",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
        },
        child: Container(
          height: (classItem["end_time"] - classItem["start_time"]) * 1.0,
          decoration: contentTableBoxDecoration(classItem["color"]),
          // margin: EdgeInsets.only(
          //     top: (classItem["start_time"] - curEndTime) * 1.0),
          child: Center(
            child: Text(
              "${classItemModel.CLASS_NAME}",
              maxLines: 3,
              style: const TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w900,
                  fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
            ),
          ),
        ),
      ),
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
              itemCount: days.length + 1,
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
                    width: (width * (11 / 12)) / days.length,
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
    color: const Color(0xfff6f6f6),
    border: Border(
        bottom: BorderSide(color: Color(0xffdedede), width: 0.5),
        right: BorderSide(color: Color(0xffdedede), width: 0.5)));

var contentTableBoxDecoration = (Color color) => BoxDecoration(
    color: color,
    border: Border(
        bottom: BorderSide(color: Color(0xffdedede), width: 0.5),
        right: BorderSide(color: Color(0xffdedede), width: 0.5)));

const innerTableBoxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border(
        bottom: BorderSide(color: Color(0xffdedede), width: 0.5),
        right: BorderSide(color: Color(0xffdedede), width: 0.5)));
