import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/timetable_daytoindex.dart';

class TimeTableBin extends StatelessWidget {
  const TimeTableBin(
      {Key key,
      @required this.timeTableController,
      @required this.width,
      @required this.top_height,
      @required this.time_height,
      @required this.dayAmount,
      @required this.verAmount})
      : super(key: key);

  final TimeTableController timeTableController;
  final double width;
  final int dayAmount;
  final int verAmount;
  final double top_height;
  final double time_height;

  @override
  Widget build(BuildContext context) {
    List<String> days = dayAmount == 7
        ? ["Mon.", "Tues.", "Wed.", "Thur.", "Fri.", "Sat.", "Sun."]
        : ["Mon.", "Tues.", "Wed.", "Thur.", "Fri."];
    int startTime = timeTableController.limitStartTime.value;
    return Container(
      child: ListView.builder(
          itemCount: verAmount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                height: top_height,
                decoration: BoxDecoration(
                    color: const Color(0xfff6f6f6),
                    border: Border(
                        bottom: BorderSide(
                            color: const Color(0xffdedede), width: 0.5))),
                child: TimeTableDays(width: width, days: days),
              );
            } else {
              return Container(
                height: time_height,
                child: ListView.builder(
                    itemCount: dayAmount + 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int i) {
                      if (i == 0) {
                        return Container(
                          width: width / 12,
                          decoration: tableBoxDecoration,
                          child: Center(
                            child: Text("${startTime - 1 + index}",
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
      @required this.timeTableController,
      @required this.width,
      @required this.dayAmount,
      @required this.verAmount,
      @required this.time_height,
      @required this.top_height,
      @required this.show})
      : super(key: key);

  final Rx<AddClassModel> new_class;
  final double width;
  final int dayAmount;
  final int verAmount;
  final bool show;
  final TimeTableController timeTableController;
  final double time_height;
  final double top_height;

  @override
  Widget build(BuildContext context) {
    return show && new_class.value.day != null
        ? Container(
            // width: 10,
            margin: EdgeInsets.only(top: top_height, left: width / 12),
            child: Container(
              child: Obx(() {
                int last_end_time =
                    60 * timeTableController.limitStartTime.value;

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
                    height: (end_time - start_time) * (time_height / 60),
                    decoration: contentTableBoxDecoration(Colors.black),
                    margin: EdgeInsets.only(
                        top: ((start_time - last_end_time) *
                                    (time_height / 60)) <
                                0
                            ? 0
                            : (start_time - last_end_time) * (time_height / 60),
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
      @required this.top_height,
      @required this.time_height,
      @required this.dayAmount,
      @required this.verAmount})
      : super(key: key);

  final TimeTableController timeTableController;
  final double width;
  final int dayAmount;
  final int verAmount;
  final double top_height;
  final double time_height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 11 / 12,
      margin: EdgeInsets.only(top: top_height, left: width / 12),
      child: Obx(() {
        //지우지마 오류나 시부레
        print(timeTableController.inTimeTableMainPage.value);
        return ListView.builder(
            itemCount: dayAmount,
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              double last_end_time =
                  60.0 * timeTableController.limitStartTime.value;
              double add_pos_startTime =
                  (timeTableController.limitEndTime.value + 1) * 60.0;
              print("adsfasdfasdfa");
              return Obx(() {
                return Container(
                    width: (width * 11 / 12) / dayAmount,
                    child: Stack(
                      children: [
                        for (var item
                            in timeTableController.showTimeTable[index])
                          Positioned(
                            top: (item["start_time"] - last_end_time) *
                                    (time_height / 60) +
                                1,
                            width: ((width - 4) * 11 / 12) / dayAmount,
                            child: Container(
                              child: TimeTableItem(
                                classItem: item,
                                time_height: time_height,
                                classItemModel: item["classInfo"],
                                curEndTime: last_end_time,
                                timeTableController: timeTableController,
                              ),
                            ),
                          ),
                        //목요일 밑에 add 버튼
                        if (index == 3 &&
                            timeTableController.inTimeTableMainPage.value)
                          Positioned(
                            top: (add_pos_startTime - last_end_time) *
                                    (time_height / 60) +
                                1,
                            width: ((width - 4) * 11 / 12) / dayAmount,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(Routes.TIMETABLE_ADDCLASS_MAIN);
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: time_height / 3,
                                      horizontal: 20),
                                  height: time_height, // 20 + 20 + 20
                                  width: 60, // 20 + 20 + 20
                                  child: Image.asset(
                                      "assets/images/timetable_add.png")),
                            ),
                          )
                      ],
                    ));
              });
            });
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
      @required this.time_height,
      @required this.timeTableController})
      : super(key: key);

  final Map classItem;
  final double curEndTime;
  final double time_height;
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
                                      for (TimeTableClassModel model
                                          in timeTableController
                                              .selectTable.value.CLASSES) {
                                        print(
                                            "${model.CLASS_NAME} => ${classItemModel.CLASS_NAME} : ${model.CLASS_NAME == classItemModel.CLASS_NAME}");
                                      }

                                      timeTableController.selectTable
                                          .update((val) {
                                        val.CLASSES.removeWhere((element) =>
                                            (element.CLASS_NAME ==
                                                classItemModel.CLASS_NAME) &&
                                            (element.CLASS_ID ==
                                                classItemModel.CLASS_ID));
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
          // margin: const EdgeInsets.only(top: 1),
          margin: const EdgeInsets.symmetric(horizontal: 2),

          height: (classItem["end_time"] - classItem["start_time"]) *
                  time_height /
                  60 -
              1,
          decoration: contentTableBoxDecoration(classItem["color"]),
          // margin: EdgeInsets.only(
          //     top: (classItem["start_time"] - curEndTime) * 1.0),
          child: Center(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                width: constraints.maxWidth,
                child: Text(
                  "${classItemModel.CLASS_NAME}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              );
            }),
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
    color: color, borderRadius: BorderRadius.all(Radius.circular(6)));

const innerTableBoxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border(
        bottom: BorderSide(color: Color(0xffdedede), width: 0.5),
        right: BorderSide(color: Color(0xffdedede), width: 0.5)));
