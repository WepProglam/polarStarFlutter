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
            margin: const EdgeInsets.only(left: 12, top: 14.8, bottom: 7.3),
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
          Spacer(),
          Container(
            margin: const EdgeInsets.only(top: 9.7, bottom: 2.3, right: 15),
            child: // 패스 940
                InkWell(
              onTap: () {
                Get.toNamed('/class');
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
            return // 사각형 526
                Obx(() {
              return Container(
                  width: 90,
                  height: 44,
                  margin: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      timeTableController.selectedTimeTableId.value =
                          timeTableController
                              .otherTable["${timeTableController.yearSem}"]
                                  [index]
                              .value
                              .TIMETABLE_ID;
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(6.5, 12.5, 5.5, 13),
                      child: Text("Third Grade",
                          style: TextStyle(
                              color: timeTableController
                                          .selectedTimeTableId.value ==
                                      timeTableController
                                          .otherTable[
                                              "${timeTableController.yearSem}"]
                                              [index]
                                          .value
                                          .TIMETABLE_ID
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
                      color: timeTableController.selectedTimeTableId.value ==
                              timeTableController
                                  .otherTable["${timeTableController.yearSem}"]
                                      [index]
                                  .value
                                  .TIMETABLE_ID
                          ? Color(0xff1a4678)
                          : Color(0xffebf4ff)));
            });
          }),
    );
  }
}

class SubjectList extends StatelessWidget {
  final TimeTableController timeTableController;

  const SubjectList({Key key, this.timeTableController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        child: ListView.builder(
            itemCount: timeTableController.selectTable.value.CLASSES.length + 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) {
              return i == timeTableController.selectTable.value.CLASSES.length
                  ? Container(
                      width: 157.5,
                      height: 184.5,
                      margin: const EdgeInsets.only(right: 31),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(36)),
                          color: const Color(0xfffff7e6)),
                      child: Icon(
                        Icons.add,
                        size: 50,
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
                                margin:
                                    const EdgeInsets.fromLTRB(9.5, 9, 9.7, 9.2),
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
                              margin:
                                  const EdgeInsets.only(top: 9.5, bottom: 11.5),
                              child: // Your subject
                                  Text(
                                      "${timeTableController.selectTable.value.NAME}",
                                      style: const TextStyle(
                                          color: const Color(0xff333333),
                                          fontWeight: FontWeight.w900,
                                          fontFamily: "PingFangSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.left),
                            ),
                            SubjectPreviewList(text: "90 marks"),
                            SubjectPreviewList(text: "A+"),
                            SubjectPreviewList(text: "Major"),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(36)),
                          color: const Color(0xfffff7e6)));
            }),
      );
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
