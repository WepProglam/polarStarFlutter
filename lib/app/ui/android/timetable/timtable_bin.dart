import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_bin_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/appBar.dart';

class TimeTableBin extends StatelessWidget {
  TimeTableBin({Key key}) : super(key: key);

  final TimeTableController timeTableController = Get.find();
  final TimeTableBinController timeTableBinController = Get.find();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xffffffff),
            appBar: AppBar(
              toolbarHeight: 56,
              backgroundColor: Get.theme.primaryColor,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              title: Container(
                  width: Get.mediaQuery.size.width,
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Stack(children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: (92 + 24.0)),
                        child: Obx(() {
                          if (!timeTableController.isReady.value) {
                            return Container();
                          }
                          return Text("时间表列表",
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                              textAlign: TextAlign.left);
                        }),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      child: Ink(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Image.asset(
                            "assets/images/back_icon.png",
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      child: Ink(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.TIMETABLE_ADDTIMETABLE);
                          },
                          child: Image.asset(
                            "assets/images/icn_plus.png",
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ])),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: timeTableController.otherTable.keys.length,
                        // physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int i) {
                          String key =
                              timeTableController.otherTable.keys.toList()[i];
                          RxList<Rx<TimeTableModel>> items =
                              timeTableController.otherTable[key];

                          return // 사각형 406
                              Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                    color: const Color(0xffeaeaea), width: 1),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0x0f000000),
                                      offset: Offset(0, 3),
                                      blurRadius: 10,
                                      spreadRadius: 0)
                                ],
                                color: const Color(0xffffffff)),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Text(
                                        "${items[0].value.YEAR}年 第${items[0].value.SEMESTER}学期",
                                        style: const TextStyle(
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "NotoSansCJKKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        textAlign: TextAlign.left),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 15),
                                    child: ListView.builder(
                                        itemCount: items.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Rx<TimeTableModel> item =
                                              items[index];
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: TimeTableBinItem(
                                                timeTableController:
                                                    timeTableController,
                                                item: item),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                            margin: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                          );
                        });
                  }),
                )
              ],
            )));
  }
}

class TimeTableBinItem extends StatelessWidget {
  const TimeTableBinItem(
      {Key key, @required this.item, @required this.timeTableController})
      : super(key: key);

  final Rx<TimeTableModel> item;
  final TimeTableController timeTableController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Ink(
              child: InkWell(
                onTap: () {
                  timeTableController.selectedTimeTableId.value =
                      item.value.TIMETABLE_ID;
                  Get.back();
                },
                child: Text("- ${item.value.NAME}",
                    style: const TextStyle(
                        color: const Color(0xff9b9b9b),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
              ),
            ),
          ),
          (item.value.IS_DEFAULT == 1)
              ? Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: // default
                      Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.5, horizontal: 9),
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text("Default",
                          style: const TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.left),
                    ),
                  ),
                )
              : Container(),
        ],
      );
    });
  }
}
