import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';

class TimeTableBin extends StatelessWidget {
  TimeTableBin({Key key}) : super(key: key);

  final TimeTableController timeTableController = Get.find();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xfff6f6f6),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 1.5, left: 15, right: 15, bottom: 12.5),
                    height: 28 + 12.5 + 1.5,
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.only(top: 6.5, bottom: 4.8),
                            padding: const EdgeInsets.only(right: 14.6),
                            child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Image.asset("assets/images/891.png")),
                          ),
                          Container(
                            width: 98.5,
                            height: 28,
                            child: // timetable
                                FittedBox(
                              child: Text("Timetable",
                                  style: const TextStyle(
                                      color: const Color(0xff333333),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "PingFangSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 21.0),
                                  textAlign: TextAlign.left),
                            ),
                          ),
                          Spacer(),
                          // 패스 843
                          Container(
                            width: 16.00732421875,
                            height: 16.00732421875,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed("/timetable/addTimeTable");
                              },
                              child: Image.asset("assets/images/843.png"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: (114.5 + 15) * 10 + 15,
                    child: ListView.builder(
                        itemCount: 10,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int i) {
                          return // 사각형 406
                              Container(
                                  width: 345,
                                  height: 114.5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.5, top: 12.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // In the summer of 2021
                                        Container(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.5),
                                          child: Text("In the summer of 2021",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff333333),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "PingFangSC",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 18.0),
                                              textAlign: TextAlign.left),
                                        ),
                                        Container(
                                          height: 18.5,
                                          child: // Schedule 1
                                              Row(children: [
                                            // 타원 162
                                            Container(
                                                width: 3.5,
                                                height: 3.5,
                                                margin: const EdgeInsets.only(
                                                    top: 8.5,
                                                    bottom: 6.5,
                                                    right: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: const Color(
                                                        0xff1a4678))),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 18.5),
                                              child: Text("Schedule 1",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff1a4678),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "PingFangSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 14.0),
                                                  textAlign: TextAlign.left),
                                            ),
                                            Container(
                                              height: 15,
                                              width: 38,
                                              margin: const EdgeInsets.only(
                                                  top: 2.5, bottom: 1),
                                              child: // default
                                                  Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: FittedBox(
                                                  child: Text("Default",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xffffffff),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              "PingFangSC",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 10.0),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff781a49),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                            )
                                          ]),
                                        ),
                                        Container(
                                          height: 18.5,
                                          margin:
                                              const EdgeInsets.only(top: 6.5),
                                          child: // Schedule 1
                                              Row(children: [
                                            // 타원 162
                                            Container(
                                                width: 3.5,
                                                height: 3.5,
                                                margin: const EdgeInsets.only(
                                                    top: 8.5,
                                                    bottom: 6.5,
                                                    right: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: const Color(
                                                        0xff1a4678))),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 18.5),
                                              child: Text("Schedule 1",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff1a4678),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "PingFangSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 14.0),
                                                  textAlign: TextAlign.left),
                                            ),
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(top: 15),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: const Color(0x17000000),
                                            offset: Offset(0, 6),
                                            blurRadius: 20,
                                            spreadRadius: 0)
                                      ],
                                      color: const Color(0xffffffff)));
                        }),
                  )
                ],
              ),
            )));
  }
}
