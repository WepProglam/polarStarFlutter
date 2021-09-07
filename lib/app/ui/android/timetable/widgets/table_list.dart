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
                InkWell(
              onTap: () {
                Get.toNamed("/timetable/addClass");
              },
              child: Container(
                width: 16,
                height: 16,
                child: Image.asset(
                  "assets/images/941.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 9.7, bottom: 2.3, right: 15),
            child: // 패스 940
                InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(30),
                            topRight: const Radius.circular(30))),
                    builder: (BuildContext context) {
                      return Container(
                        height: 384.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 26.5, left: 26.5, right: 26.5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Rectangle-path
                                  TimeTableSettingItem(
                                    imagePath: "710.png",
                                    title: "Edit Curriculam",
                                  ),
                                  TimeTableSettingItem(
                                    imagePath: "713.png",
                                    title: "Visible Range",
                                  ),
                                  TimeTableSettingItem(
                                    imagePath: "714.png",
                                    title: "Save Picture",
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 24, left: 26.5, right: 26.5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Rectangle-path
                                  TimeTableSettingItem(
                                    imagePath: "715.png",
                                    title: "Share Links",
                                  ),
                                  TimeTableSettingItem(
                                    imagePath: "320.png",
                                    title: "Delete",
                                  ),
                                  TimeTableSettingItem(
                                    imagePath: "897.png",
                                    title: "Set Default",
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 24),
                                width: 49,
                                height: 49,
                                child: InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Image.asset(
                                    "assets/images/close.png",
                                    fit: BoxFit.fitHeight,
                                  ),
                                )),
                            Center(
                              child: Container(
                                  margin: const EdgeInsets.only(top: 22),
                                  width: 135,
                                  height: 5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      color: const Color(0xff000000))),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x4d4710b8),
                                  offset: Offset(0, -3),
                                  blurRadius: 6,
                                  spreadRadius: 0)
                            ],
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(30),
                                topRight: const Radius.circular(30))),
                      );
                    });
              },
              child: Container(
                width: 16,
                height: 16,
                child: Image.asset(
                  "assets/images/17_2.png",
                  fit: BoxFit.fitHeight,
                ),
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

class TimeTableSettingItem extends StatelessWidget {
  const TimeTableSettingItem({Key key, this.imagePath, this.title})
      : super(key: key);

  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            print("${title}");
            Get.back();
          },
          child: Stack(children: [
            Opacity(
              opacity: 0.14999999105930328,
              child: Container(
                  width: 84.70172119140625,
                  height: 84.70166015625,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(85)),
                      border:
                          Border.all(color: const Color(0xff4a4a4a), width: 1),
                      color: const Color(0x4d4a4a4a))),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 34.33978271484375,
                  height: 34.44189453125,
                  child: Image.asset(
                    "assets/images/${imagePath}",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ]),
        ),
        // Run
        Container(
          margin: const EdgeInsets.only(top: 11.05),
          child: Text("${title}",
              style: const TextStyle(
                  color: const Color(0xff2f2f2f),
                  fontWeight: FontWeight.w700,
                  fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
        )
      ],
    );
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
