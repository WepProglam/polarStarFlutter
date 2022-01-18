import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/add_class.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TopIcon extends StatelessWidget {
  final TimeTableController timeTableController;
  TopIcon({Key key, this.timeTableController, this.selectedModel})
      : super(key: key);
  final courseNameController = TextEditingController();
  Rx<SelectedTimeTableModel> selectedModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            for (var item in timeTableController.selectYearSemester) {
              print(item.value.NAME);
            }

            Get.defaultDialog(
                title: "학기 선택",
                content: Container(
                  width: 300,
                  height: 40.0 * timeTableController.selectYearSemester.length,
                  child: Obx(() {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            timeTableController.selectYearSemester.length,
                        itemBuilder: (BuildContext context, int index) {
                          String yearSemester =
                              "${timeTableController.selectYearSemester[index].value.YEAR}년 ${timeTableController.selectYearSemester[index].value.SEMESTER}학기";

                          return InkWell(
                            onTap: () async {
                              await timeTableController.getSemesterTimeTable(
                                  timeTableController
                                      .selectYearSemester[index].value.YEAR,
                                  timeTableController.selectYearSemester[index]
                                      .value.SEMESTER);
                              timeTableController.selectedTimeTableId.value =
                                  timeTableController.selectYearSemester[index]
                                      .value.TIMETABLE_ID;
                              Get.back();
                            },
                            child: Container(
                                height: 40,
                                child: Row(children: [
                                  Container(
                                    // padding: const EdgeInsets.all(8.0),
                                    child: Text("${yearSemester}"),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.all(8.0),
                                    margin: const EdgeInsets.only(left: 15),
                                    // width: 100,
                                    child: Text(
                                        "${timeTableController.selectYearSemester[index].value.NAME}"),
                                  ),
                                  // Spacer(),
                                  Container(
                                    // padding: const EdgeInsets.all(8.0),
                                    margin: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "DEFAULT",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ])),
                          );
                        });
                  }),
                ));
          },
          child: Obx(() {
            return Container(
              height: 28,
              child: Row(
                children: [
                  Container(
                    height: 28,
                    child: Text("${selectedModel.value.NAME}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w700,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 21.0),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    height: 28,
                    margin:
                        const EdgeInsets.only(left: 12, top: 14.8, bottom: 7.3),
                    child: // 패스 940
                        FittedBox(
                      child: Container(
                        width: 10.68267822265625,
                        height: 5.931396484375,
                        child: Image.asset(
                          "assets/images/940.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        Spacer(),
        Container(
          width: 100,
          height: 100,
          child: InkWell(
            onDoubleTap: () {
              timeTableController.logoHidden.value =
                  !timeTableController.logoHidden.value;
              print("asdfasdfasdfsadf");
            },
          ),
        ),
        Obx(() {
          return timeTableController.logoHidden.value
              ? Container()
              : Container(
                  padding:
                      const EdgeInsets.only(top: 9, bottom: 1.5, right: 13.3),
                  child: // 패스 940
                      InkWell(
                    onTap: () {
                      if (timeTableController.topHeight.value == 30.0) {
                        timeTableController.topHeight.value = 44.0;
                        timeTableController.timeHeight.value = 60.0;
                      } else {
                        timeTableController.topHeight.value = 30.0;
                        timeTableController.timeHeight.value = 50.0;
                      }
                    },
                    child: Container(
                      width: 15.3,
                      height: 17.5,
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                );
        }),
        Container(
          margin: const EdgeInsets.only(top: 9, bottom: 1.5, right: 13.3),
          child: // 패스 940
              InkWell(
            onTap: () {
              Get.toNamed(Routes.CLASS);
              // Get.toNamed(Routes.TIMETABLE_ADDCLASS_MAIN);
            },
            child: Container(
              width: 15.3,
              height: 17.5,
              child: Image.asset(
                "assets/images/person.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 9, bottom: 1.5, right: 13.3),
          child: // 패스 940
              InkWell(
            onTap: () {
              showSetting(context, courseNameController, selectedModel);
            },
            child: Container(
              width: 15.3,
              height: 17.5,
              child: Image.asset(
                "assets/images/17_2.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
              top: 9 + 1.7, bottom: 1.5 + 1.7, right: 13.3),
          child: // 패스 940
              InkWell(
            onTap: () {
              Get.toNamed("/timetable/bin");
            },
            child: Container(
              width: 16.2,
              height: 14,
              child: Image.asset(
                "assets/images/16_12.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showSetting(
    BuildContext context,
    TextEditingController courseNameController,
    Rx<SelectedTimeTableModel> selectedModel) {
  final TimeTableController timeTableController = Get.find();
  final formSize = MediaQuery.of(context).size;
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(30),
              topRight: const Radius.circular(30))),
      builder: (BuildContext context) {
        return Container(
          height: 325,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 41, left: 42, right: 42),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rectangle-path
                    TimeTableSettingItem(
                      imagePath: "timetable_edit_name.png",
                      title: "Edit Name",
                      onTap: () async {
                        Get.back();
                        // Get.back();
                        await Get.defaultDialog(
                            title: "Edit course name",
                            titlePadding: const EdgeInsets.only(top: 15.5),
                            contentPadding: const EdgeInsets.all(0),
                            titleStyle: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w700,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0),
                            content: Container(
                              width: formSize.width - 30,
                              height: 175,
                              child: Container(
                                margin: const EdgeInsets.only(top: 31),
                                child: Container(
                                  child: Column(
                                    children: [
                                      // 사각형 544
                                      Container(
                                          width: formSize.width - 30 - 18.5 * 2,
                                          height: 41.5,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 25.5,
                                                top: 10,
                                                bottom: 10),
                                            padding: const EdgeInsets.only(
                                                right: 25.5),
                                            child: TextFormField(
                                                maxLines: 1,
                                                controller:
                                                    courseNameController,
                                                style: textStyle,
                                                textAlign: TextAlign.left,
                                                decoration: inputDecoration(
                                                    "timetable name")),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 18.5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: const Color(0xfff0f0f0))),

                                      Container(
                                        height: 55.5,
                                        margin: const EdgeInsets.only(top: 44),
                                        // width: formSize.width - 30,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: // Cancel
                                                  InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffdedede),
                                                          width: 0.3)),
                                                  child: Center(
                                                    child: FittedBox(
                                                      child: Text("Cancel",
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff1a4678),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily:
                                                                  "PingFangSC",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 18.0),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: // Confirm
                                                  InkWell(
                                                onTap: () async {
                                                  String newName =
                                                      courseNameController.text
                                                          .trim();

                                                  if (newName ==
                                                      timeTableController
                                                          .selectTable
                                                          .value
                                                          .NAME
                                                          .trim()) {
                                                    Get.snackbar("변경 사항이 없습니다.",
                                                        "변경 사항이 없습니다.");
                                                    return;
                                                  }
                                                  var response = await Session()
                                                      .patchX(
                                                          "/timetable/table/tid/${timeTableController.selectedTimeTableId.value}?name=${newName}",
                                                          {});

                                                  switch (response.statusCode) {
                                                    case 200:
                                                      timeTableController
                                                          .selectTable
                                                          .update((val) {
                                                        val.NAME =
                                                            courseNameController
                                                                .text;
                                                      });

                                                      for (var item
                                                          in timeTableController
                                                                  .otherTable[
                                                              "${timeTableController.yearSem}"]) {
                                                        if (item.value
                                                                .TIMETABLE_ID ==
                                                            timeTableController
                                                                .selectTable
                                                                .value
                                                                .TIMETABLE_ID) {
                                                          item.update((val) {
                                                            val.NAME = newName;
                                                          });
                                                        }
                                                      }
                                                      courseNameController
                                                          .clear();
                                                      Get.back();

                                                      break;
                                                    default:
                                                      Get.snackbar("이름 변경 실패",
                                                          "이름 변경 실패");
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffdedede),
                                                          width: 0.3)),
                                                  child: Center(
                                                    child: FittedBox(
                                                      child: Text("Confirm",
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff1a4678),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily:
                                                                  "PingFangSC",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 18.0),
                                                          textAlign:
                                                              TextAlign.center),
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
                              ),
                            ));
                      },
                    ),
                    TimeTableSettingItem(
                      imagePath: "timetable_visible_range.png",
                      title: "Visible Range",
                      onTap: () {
                        Get.back();
                      },
                    ),
                    TimeTableSettingItem(
                      imagePath: "timetable_save_picture.png",
                      title: "Save Picture",
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 42, right: 42),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rectangle-path
                    TimeTableSettingItem(
                      imagePath: "timetable_share_links.png",
                      title: "Share Links",
                      onTap: () {
                        Get.back();

                        print("Share Links");
                      },
                    ),
                    TimeTableSettingItem(
                      imagePath: "timetable_delete.png",
                      title: "Delete",
                      onTap: () async {
                        Get.back();
                        String yearSem = timeTableController.yearSem;

                        print(yearSem);

                        //시간표 하나일때 삭제 방지
                        if (timeTableController
                                    .otherTable["${yearSem}"].length -
                                1 <=
                            0) {
                          Get.snackbar(
                              "시간표가 하나일때는 지울 수 없습니다.", "시간표가 하나일때는 지울 수 없습니다.");
                          return;
                        }

                        //디폴트 시간표 삭제 방지
                        for (var item
                            in timeTableController.otherTable["${yearSem}"]) {
                          if (item.value.TIMETABLE_ID ==
                              timeTableController
                                  .selectTable.value.TIMETABLE_ID) {
                            if (item.value.IS_DEFAULT == 1) {
                              Get.snackbar("디폴트 시간표는 삭제할 수 없습니다.",
                                  "디폴트 시간표는 삭제할 수 없습니다.",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white);
                              return;
                            }
                          }
                        }

                        await Session().deleteX(
                            "/timetable/table/tid/${selectedModel.value.TIMETABLE_ID}");

                        //other에서 삭제
                        timeTableController.otherTable["${yearSem}"]
                            .removeWhere((element) =>
                                element.value.TIMETABLE_ID ==
                                selectedModel.value.TIMETABLE_ID);

                        //디폴트를 SELECTED로 설정
                        timeTableController.selectedTimeTableId.value =
                            timeTableController.defaultTableList["${yearSem}"]
                                .value.TIMETABLE_ID;

                        print("Delete");
                      },
                    ),
                    TimeTableSettingItem(
                      imagePath: "timetable_set_default.png",
                      title: "Set Default",
                      onTap: () async {
                        Get.back();

                        await timeTableController.setDefaultTable();
                      },
                    ),
                  ],
                ),
              ),
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
}

class TimeTableSettingItem extends StatelessWidget {
  const TimeTableSettingItem({Key key, this.imagePath, this.title, this.onTap})
      : super(key: key);

  final String imagePath;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
            onTap: () {
              onTap();
            },
            child:
                // 사각형 22
                Container(
                    width: 76,
                    height: 76,
                    child: Center(
                      child: Image.asset(
                        "assets/images/${imagePath}",
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: const Color(0xffeaeaea), width: 1),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0x0f000000),
                              offset: Offset(0, 3),
                              blurRadius: 10,
                              spreadRadius: 0)
                        ],
                        color: const Color(0xfffafbff)))),
        // Run
        Container(
          margin: const EdgeInsets.only(top: 11.05),
          child: Text("${title}",
              style: const TextStyle(
                  color: const Color(0xff9b9b9b),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 10.0),
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
    // print(timeTableController.selectedTimeTableId.value);
    return Container(
      child: Obx(
        () {
          if (timeTableController
                  .otherTable["${timeTableController.yearSem}"] ==
              null) {
            return Container();
          }
          return ListView.builder(
              itemCount: timeTableController
                  .otherTable["${timeTableController.yearSem}"].length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                TimeTableModel model = timeTableController
                    .otherTable["${timeTableController.yearSem}"][index].value;
                return // 사각형 526
                    Obx(() {
                  return Container(
                      width: 114,
                      height: 42,
                      margin: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          timeTableController.scrollController.jumpTo(0.0);
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
                                      : Color(0xff2f2f2f),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: model.TIMETABLE_ID ==
                                  timeTableController.selectedTimeTableId.value
                              ? Color(0xff571df0)
                              : Color(0xfff8f6fe)));
                });
              });
        },
      ),
    );
  }
}

class SubjectList extends StatelessWidget {
  const SubjectList({Key key, this.model}) : super(key: key);
  final Rx<SelectedTimeTableModel> model;
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    return Obx(() {
      int total_length =
          model.value.CLASSES == null ? 0 : model.value.CLASSES.length + 0;
      // 밑에서 강의 추가하는 기능
      // model.value.CLASSES == null ? 1 : model.value.CLASSES.length + 1;
      return Container(
          child: ListView.builder(
              itemCount: total_length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int i) {
                return i == total_length
                    // return i == total_length - 1
                    ? InkWell(
                        onTap: () {
                          Get.toNamed(Routes.TIMETABLE_ADDCLASS_MAIN);
                        },
                        child: Container(
                          width: 180,
                          height: 144,
                          margin: const EdgeInsets.only(right: 31),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(36)),
                              color: const Color(0xffe6edf5)),
                          child: Icon(
                            Icons.add,
                            size: 50,
                          ),
                        ),
                      )
                    : Container(
                        width: 180,
                        height: 144,
                        margin: const EdgeInsets.only(right: 8),
                        child: Ink(
                          child: InkWell(
                            // onTap: () async {
                            //   // box.remove("classSocket");
                            //   if (box.hasData("classSocket")) {
                            //     List<dynamic> classSocketList =
                            //         box.read("classSocket");
                            //     bool isExist = false;
                            //     for (var item in classSocketList) {
                            //       if ("${item}" ==
                            //           "${model.value.CLASSES[i].CLASS_ID}") {
                            //         isExist = true;
                            //       }
                            //     }
                            //     if (!isExist) {
                            //       classSocketList.add(
                            //           "${model.value.CLASSES[i].CLASS_ID}");
                            //       box.write("classSocket", classSocketList);
                            //     }
                            //   } else {
                            //     box.write("classSocket",
                            //         ["${model.value.CLASSES[i].CLASS_ID}"]);
                            //   }

                            //   Get.toNamed(Routes.CLASSCHAT, arguments: {
                            //     "roomID": "${model.value.CLASSES[i].CLASS_ID}"
                            //   });

                            //   // IO.Socket socket = await socketting(
                            //   //     "${model.value.CLASSES[i].CLASS_ID}");
                            // },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                        "${model.value.CLASSES[i].CLASS_NAME}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansSC",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        textAlign: TextAlign.center),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: // 이연희
                                        Text(
                                            "${model.value.CLASSES[i].PROFESSOR}",
                                            style: const TextStyle(
                                                color: const Color(0xff6f6e6e),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "NotoSansSC",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.center),
                                  ),
                                  FittedBox(
                                    child: SubjectPreviewList(
                                        text:
                                            "- ${model.value.CLASSES[i].CLASS_NUMBER}"),
                                  ),
                                  FittedBox(
                                    child: SubjectPreviewList(
                                        text:
                                            "- ${model.value.CLASSES[i].CREDIT}"),
                                  ),
                                  FittedBox(
                                    child: SubjectPreviewList(
                                        text:
                                            "- ${model.value.CLASSES[i].PROFESSOR}"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: const Color(0xffeaeaea), width: 1),
                            color: const Color(0xffffffff)));
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
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          // Container(
          //   margin: const EdgeInsets.only(top: 8, bottom: 7, right: 6),
          //   width: 3.5,
          //   height: 3.5,
          //   child: Image.asset("assets/images/220.png"),
          // ),
          // 90 marks
          Text("${text}",
              style: const TextStyle(
                  color: const Color(0xff2f2f2f),
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left)
        ],
      ),
    );
  }
}
