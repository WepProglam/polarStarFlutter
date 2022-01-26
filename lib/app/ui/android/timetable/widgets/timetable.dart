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
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                height: top_height,
                decoration: BoxDecoration(
                    color: const Color(0xfff8f6fe),
                    border: Border(
                        bottom: BorderSide(
                            color: const Color(0xffdedede), width: 0.5))),
                child: TimeTableDays(width: width, days: days),
              );
            } else {
              return Container(
                height: time_height,
                child: ListView.builder(
                    shrinkWrap: true,
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
                                    color: const Color(0xff2f2f2f),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Roboto",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                                textAlign: TextAlign.center),
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
                    decoration:
                        contentTableBoxDecoration(const Color(0xff9ee85e)),
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
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              double last_end_time =
                  60.0 * timeTableController.limitStartTime.value;
              double add_pos_startTime =
                  (timeTableController.limitEndTime.value + 1) * 60.0;
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
                            width: ((width) * 11 / 12) / dayAmount,
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

  String findCorrectClassRoom() {
    for (AddClassModel item in classItemModel.CLASS_TIME) {
      int dateToInt = item.start_time.hour * 60 + item.start_time.minute;
      print(
          "${dateToInt}  - ${classItem["start_time"]} => ${dateToInt == classItem["start_time"]} ");
      if (dateToInt == classItem["start_time"]) {
        return item.class_room;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String current_class_room = findCorrectClassRoom();
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
          margin: const EdgeInsets.symmetric(horizontal: 0.5),

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
                width: constraints.maxWidth - 10,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        child: Text(
                          "${classItemModel.CLASS_NAME}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // 이연희
                      Container(
                        width: 60,
                        child: Text("${classItemModel.PROFESSOR}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: const Color(0xfffff8dd),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 10.0),
                            textAlign: TextAlign.center),
                      ),
                      Container(
                        width: 60,
                        child: Text("${current_class_room}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: const Color(0xfffff8dd),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 10.0),
                            textAlign: TextAlign.center),
                      ),
                    ]),
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
                            color: const Color(0xff2f2f2f),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.center,
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
    color: const Color(0xfff7fbff),
    border: Border(
      bottom: BorderSide(color: Color(0xffdedede), width: 0.5),
    ));

var contentTableBoxDecoration = (Color color) => BoxDecoration(
    color: color, borderRadius: BorderRadius.all(Radius.circular(8)));

const innerTableBoxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border(
      bottom: BorderSide(color: Color(0xffdedede), width: 0.5),
    ));
