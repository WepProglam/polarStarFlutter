import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';

Future<void> ShowClassDetail(TimeTableClassModel classItemModel,
    TimeTableController timeTableController) async {
  List<String> times = [];
  String timeString = "";

  if (classItemModel.IS_ICAMPUS || classItemModel.IS_NOT_DETERMINED) {
    timeString = classItemModel.IS_ICAMPUS ? "[iCampus 수업]" : "미지정";
  } else {
    times = classItemModel.CLASS_TIME
        .map((e) =>
            "${e.day} ${timeFormatter(e.start_time)}~${timeFormatter(e.end_time)} / ")
        .toList();

    print(times);

    for (String item in times) {
      timeString += item;
    }
    timeString = timeString.substring(0, timeString.length - 2);
  }

  return await Get.defaultDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: "",
      content: Container(
        width: 320,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: const Color(0xffffffff)),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      child: Container(
                        child: Text(
                          "${classItemModel.CLASS_NAME}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: const Color(0xff2f2f2f),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansKR",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: Row(
                  children: [
                    Container(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                            "assets/images/timetable_direct_professr.png")),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Container(
                        child: Text(
                          "${classItemModel.PROFESSOR}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: const Color(0xff9b9b9b),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansKR",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                // height: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                            "assets/images/timetable_direct_clock.png")),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Container(
                        child: Text(
                          "${timeString}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              color: const Color(0xff9b9b9b),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansKR",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
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
                        child: Image.asset(
                            "assets/images/timetable_direct_location.png")),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Container(
                        child: FittedBox(
                          child: Text(
                            "${classItemModel.CLASS_NUMBER}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: const Color(0xff9b9b9b),
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansKR",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 14),
                child: Ink(
                  child: InkWell(
                    onTap: () async {
                      var statusCode = await timeTableController.deleteClass(
                          timeTableController.selectTable.value.TIMETABLE_ID,
                          classItemModel.CLASS_NAME);
                      switch (statusCode) {
                        case 200:
                          for (TimeTableClassModel model in timeTableController
                              .selectTable.value.CLASSES) {
                            print(
                                "${model.CLASS_NAME} => ${classItemModel.CLASS_NAME} : ${model.CLASS_NAME == classItemModel.CLASS_NAME}");
                          }

                          timeTableController.selectTable.update((val) {
                            val.CLASSES.removeWhere((element) =>
                                (element.CLASS_NAME ==
                                    classItemModel.CLASS_NAME) &&
                                (element.CLASS_ID == classItemModel.CLASS_ID));
                          });

                          timeTableController.initShowTimeTable();
                          timeTableController.makeShowTimeTable();

                          // * 시간표 수업 추가 시 noti page 업데이트(채팅 방)
                          await MainUpdateModule.updateNotiPage(
                            1,
                          );

                          break;
                        default:
                      }

                      Get.back();
                    },
                    child: Row(
                      children: [
                        Container(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                                "assets/images/timetable_direct_delete.png")),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: // 한국문화와언어
                              Text("삭제",
                                  style: const TextStyle(
                                      color: const Color(0xff6ea5ff),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ));
}
