import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';

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
      child: ListView.builder(
          itemCount: 14,
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
    return Container(
      width: width * 11 / 12,
      margin: EdgeInsets.only(top: 44, left: width / 12),
      child: ListView.builder(
          itemCount: 7,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
                width: (width * 11 / 12) / 7,
                child: Obx(() {
                  int last_end_time = 60 * 9;

                  return ListView.builder(
                      itemCount:
                          timeTableController.showTimeTable[index].length,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int i) {
                        int curEndTime = last_end_time;
                        Map classItem =
                            timeTableController.showTimeTable[index][i];
                        TimeTableClassModel classItemModel =
                            classItem["classInfo"];
                        print(
                            "margin : ${(classItem["start_time"] - curEndTime) * 1.0}");

                        last_end_time = classItem["end_time"];
                        return Container(
                          height: (classItem["end_time"] -
                                  classItem["start_time"]) *
                              1.0,
                          decoration:
                              contentTableBoxDecoration(classItem["color"]),
                          margin: EdgeInsets.only(
                              top:
                                  (classItem["start_time"] - curEndTime) * 1.0),
                          child: Center(
                            child: Text(
                              "${classItemModel.className}",
                              maxLines: 3,
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "PingFangSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                            ),
                          ),
                        );
                      });
                }));
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
