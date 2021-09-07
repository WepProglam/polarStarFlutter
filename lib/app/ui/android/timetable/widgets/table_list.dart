import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';

class TopIcon extends StatelessWidget {
  final TimeTableController timeTableController;
  const TopIcon({Key key, this.timeTableController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          InkWell(
            onTap: () {
              Get.defaultDialog(
                  title: "학기 선택",
                  content: Container(
                    width: 300,
                    height: 100,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            timeTableController.selectYearSemester.length,
                        itemBuilder: (BuildContext context, int index) {
                          String yearSemester =
                              "${timeTableController.selectYearSemester[index].YEAR}년 ${timeTableController.selectYearSemester[index].SEMESTER}학기";

                          return InkWell(
                            onTap: () async {
                              timeTableController.yearSemesterIndex.value =
                                  index;
                              Get.back();
                              await timeTableController.getSemesterTimeTable(
                                  timeTableController
                                      .selectYearSemester[index].YEAR,
                                  timeTableController
                                      .selectYearSemester[index].SEMESTER);
                            },
                            child: Container(
                                child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${yearSemester}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${timeTableController.selectYearSemester[index].NAME}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "DEFAULT",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ])),
                          );
                        }),
                  ));
            },
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Text("${timeTableController.selectTable.value.NAME}",
                      // "${timeTableController.selectYearSemester[timeTableController.yearSemesterIndex.value].NAME}",
                      style: const TextStyle(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.w700,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 21.0),
                      textAlign: TextAlign.left),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 12, top: 14.8, bottom: 7.3),
                  child: // 패스 940
                      Container(
                    width: 10.68267822265625,
                    height: 5.931396484375,
                    child: Image.asset(
                      "assets/images/940.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.only(top: 9.7, bottom: 2.3, right: 15),
            child: // 패스 940
                Container(
              width: 16,
              height: 16,
              child: Image.asset(
                "assets/images/941.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 9.7, bottom: 2.3, right: 15),
            child: // 패스 940
                Container(
              width: 16,
              height: 16,
              child: Image.asset(
                "assets/images/17_2.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 9.7, bottom: 2.3, right: 15),
            child: // 패스 940
                Container(
              width: 16,
              height: 16,
              child: Image.asset(
                "assets/images/16_12.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class TableList extends StatelessWidget {
  const TableList({Key key, @required this.timeTableController})
      : super(key: key);
  final TimeTableController timeTableController;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            itemCount: timeTableController
                .otherTable["${timeTableController.yearSem}"].length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              TimeTableModel model = timeTableController
                  .otherTable["${timeTableController.yearSem}"][index].value;
              return // 사각형 526
                  Obx(() {
                return Container(
                    width: 90,
                    height: 44,
                    margin: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        timeTableController.selectedTimeTableId.value =
                            model.TIMETABLE_ID;
                      },
                      child: Center(
                        // margin: const EdgeInsets.fromLTRB(6.5, 12.5, 5.5, 13),
                        child: Text(
                            "${timeTableController.otherTable["${timeTableController.yearSem}"][index].value.NAME}",
                            maxLines: 1,
                            style: TextStyle(
                                color: model.TIMETABLE_ID ==
                                        timeTableController
                                            .selectedTimeTableId.value
                                    ? Color(0xffffffff)
                                    : Color(0xff1a4678),
                                fontWeight: FontWeight.w700,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: model.TIMETABLE_ID ==
                                timeTableController.selectedTimeTableId.value
                            ? Color(0xff1a4678)
                            : Color(0xffebf4ff)));
              });
            }));
  }
}

class SubjectList extends StatelessWidget {
  final TimeTableController timeTableController;

  const SubjectList({Key key, this.timeTableController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int total_length = timeTableController.selectTable.value.CLASSES == null
          ? 1
          : timeTableController.selectTable.value.CLASSES.length + 1;
      // print(timeTableController.selectTable.value.NAME);
      return Container(
          child: ListView.builder(
              itemCount: total_length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int i) {
                return i == total_length - 1
                    ? InkWell(
                        onTap: () {
                          Get.toNamed("/timetable/addClass");
                        },
                        child: Container(
                          width: 157.5,
                          height: 184.5,
                          margin: const EdgeInsets.only(right: 31),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(36)),
                              color: const Color(0xfffff7e6)),
                          child: Icon(
                            Icons.add,
                            size: 50,
                          ),
                        ),
                      )
                    : Container(
                        width: 157.5,
                        height: 184.5,
                        margin: const EdgeInsets.only(right: 31),
                        child: Container(
                          margin: const EdgeInsets.only(left: 19, top: 19.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 37.5,
                                height: 37.5,
                                child: // 패스 943
                                    Container(
                                  width: 18.29071044921875,
                                  height: 19.29248046875,
                                  margin: const EdgeInsets.fromLTRB(
                                      9.5, 9, 9.7, 9.2),
                                  child: Image.asset(
                                    "assets/images/942.png",
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: const Color(0xfffcaa02)),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 9.5, bottom: 11.5),
                                child: // Your subject
                                    Text(
                                        "${timeTableController.selectTable.value.CLASSES[i].className}",
                                        style: const TextStyle(
                                            color: const Color(0xff333333),
                                            fontWeight: FontWeight.w900,
                                            fontFamily: "PingFangSC",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.left),
                              ),
                              FittedBox(
                                child: SubjectPreviewList(
                                    text:
                                        "학수번호 : ${timeTableController.selectTable.value.CLASSES[i].classNumber}"),
                              ),
                              FittedBox(
                                child: SubjectPreviewList(
                                    text:
                                        "학점 : ${timeTableController.selectTable.value.CLASSES[i].credit}"),
                              ),
                              FittedBox(
                                child: SubjectPreviewList(
                                    text:
                                        "교수명 : ${timeTableController.selectTable.value.CLASSES[i].professor}"),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(36)),
                            color: const Color(0xfffff7e6)));
              }));
    });
  }
}

class SubjectPreviewList extends StatelessWidget {
  final String text;
  const SubjectPreviewList({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 7, right: 6),
            width: 3.5,
            height: 3.5,
            child: Image.asset("assets/images/220.png"),
          ),
          // 90 marks
          Text("${text}",
              style: const TextStyle(
                  color: const Color(0xff666666),
                  fontWeight: FontWeight.w500,
                  fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left)
        ],
      ),
    );
  }
}
