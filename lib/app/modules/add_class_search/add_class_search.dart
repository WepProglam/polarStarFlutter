import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/timetable/timetable_class_model.dart';
import 'package:polarstar_flutter/app/global_functions/time_pretty.dart';
import 'package:polarstar_flutter/app/modules/add_class/timetable_addclass_controller.dart';
import 'package:polarstar_flutter/app/modules/add_class_search/timetable_addclass_search_controller.dart';
import 'package:polarstar_flutter/app/modules/board/functions/time_parse.dart';
import 'package:polarstar_flutter/app/modules/board/functions/timetable_daytoindex.dart';
import 'package:polarstar_flutter/app/modules/class/functions/rating.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/modules/timetable/widgets/timetable.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';

var inputDecoration = (hint) => InputDecoration(
    isDense: true,
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    hintStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
        color: const Color(0xff999999),
        fontWeight: FontWeight.w400,
        fontFamily: "PingFangSC",
        fontStyle: FontStyle.normal,
        fontSize: 14.0),
    hintText: "Please enter the ${hint} name");

const textStyle = const TextStyle(
    overflow: TextOverflow.ellipsis,
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
    fontStyle: FontStyle.normal,
    fontSize: 14.0);

class TimetableAddClassMain extends StatelessWidget {
  TimetableAddClassMain({Key key}) : super(key: key);
  final TimeTableController timeTableController = Get.find();
  final MainController mainController = Get.find();
  final TimeTableAddClassSearchController controller = Get.find();
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print(timeTableController.yearSem);
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomSheet: // 사각형 612
              Container(
            height: Get.mediaQuery.size.height - (55.0 * 5 + 30) - 56 - 37 + 10,
            // decoration: BoxDecoration(
            //     border: Border.all(color: const Color(0xff707070), width: 1),
            //     color: const Color(0xffffffff)),
            child: classSearchBottomSheet(scrollController: scrollController),
          ),
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 56,
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset("assets/images/back_icon.png"),
            ),
            centerTitle: true,
            titleSpacing: 0,
            actions: [
              Container(
                  width: 72,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.TIMETABLE_ADDCLASS_DIRECT);
                      },
                      child: Center(
                        child: Text("直接输入",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Get.theme.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.right),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                      border:
                          Border.all(color: const Color(0xff99bbf9), width: 1),
                      color: const Color(0xffffffff))),
            ],
          ),
          body: Container(
            child: Container(
              height: 55.0 * 5 + 30,
              child: SingleChildScrollView(
                controller: scrollController,
                // physics: NeverScrollableScrollPhysics(),
                physics: AlwaysScrollableScrollPhysics(),
                child: Obx(() {
                  RxBool isExpandedHor = timeTableController.isExpandedHor;
                  int dayAmount = isExpandedHor.value ? 7 : 5;
                  int verAmount = timeTableController.verAmount.value;

                  double time_height = timeTableController.timeHeight.value;
                  double top_height = timeTableController.topHeight.value;

                  return Container(
                    height: top_height + time_height * (verAmount - 1),
                    child: Stack(children: [
                      TimeTableBin(
                          time_height: time_height,
                          top_height: top_height,
                          timeTableController: timeTableController,
                          width: size.width,
                          dayAmount: dayAmount,
                          verAmount: verAmount),
                      TimeTableContent(
                          time_height: time_height,
                          top_height: top_height,
                          timeTableController: timeTableController,
                          width: size.width,
                          dayAmount: dayAmount,
                          verAmount: verAmount),
                      //선택한 애들 띄우기
                      for (Rx<AddClassModel> item in controller.NewClass)
                        Positioned(
                          child: TimeTableAddClass(
                              timeTableController: timeTableController,
                              new_class: item,
                              top_height: top_height,
                              time_height: time_height,
                              width: size.width,
                              show:
                                  controller.selectedIndex == -1 ? false : true,
                              dayAmount: dayAmount,
                              verAmount: verAmount),
                        )
                    ]),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class classSearchBottomSheet extends StatelessWidget {
  classSearchBottomSheet({Key key, this.scrollController}) : super(key: key);

  final TimeTableAddClassSearchController controller = Get.find();
  final TimeTableController timeTableController = Get.find();
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller.scrollController.value,
      slivers: [
        searchClassSliverAppBar(controller: controller),
        Obx(() {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == controller.CLASS_SEARCH.length) {
                  if (controller.searchPage == controller.searchMaxPage.value) {
                    return Container();
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    color: Get.theme.primaryColor,
                  ));
                }

                TimeTableClassModel model = controller.CLASS_SEARCH[index];
                return Ink(
                    child: InkWell(
                  onTap: () {
                    if (controller.selectedIndex.value == index) {
                      controller.selectedIndex.value = -1;
                    } else {
                      controller.selectedIndex.value = index;
                      controller.NewClass.value =
                          model.CLASS_TIME.map((e) => e.obs).toList();
                      double ypos_average = controller
                              .NewClass[0].value.start_time.hour +
                          controller.NewClass[0].value.start_time.minute / 60;

                      for (var item in controller.NewClass) {
                        //끝 시간 맞추기
                        if (item.value.end_time.hour >=
                            timeTableController.limitEndTime.value) {
                          timeTableController.limitEndTime.value =
                              item.value.end_time.hour + 1;
                        }

                        //시작 시간 맞추기
                        if (item.value.start_time.hour <
                            timeTableController.limitStartTime.value) {
                          timeTableController.limitStartTime.value =
                              item.value.start_time.hour;
                        }

                        if (ypos_average >
                            (item.value.start_time.hour +
                                item.value.start_time.minute / 60.0)) {
                          ypos_average = (item.value.start_time.hour +
                              item.value.start_time.minute / 60.0);
                        }

                        // ypos_average += ((item.value.end_time.hour +
                        //             item.value.end_time.minute / 60.0) +
                        //         (item.value.start_time.hour +
                        //             item.value.start_time.minute / 60.0)) /
                        //     2;

                        if (item.value.day == "토" || item.value.day == "일") {
                          timeTableController.isExpandedHor.value = true;
                        }
                      }
                      // ypos_average /= controller.NewClass.length;

                      double target_ypos = (ypos_average - 9) *
                              timeTableController.timeHeight.value +
                          20;

                      double current_ypos = scrollController.offset;

                      // int seconds =
                      //     (((current_ypos - target_ypos).abs() * 5000.0) / 1000)
                      //         .round();
                      scrollController.animateTo(target_ypos,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.fastOutSlowIn);
                    }
                  },
                  child: Obx(() {
                    return Container(
                        padding: const EdgeInsets.only(bottom: 12.5),
                        color: index == controller.selectedIndex.value
                            ? const Color(0xfff5f6ff)
                            : const Color(0xffffffff),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 선 21
                            Container(
                                height: 1,
                                decoration: BoxDecoration(
                                    color: const Color(0xffeaeaea))),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 13.5),
                                            width: Get.mediaQuery.size.width -
                                                100 -
                                                20,
                                            child: Text("${model.CLASS_NAME}",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                textAlign: TextAlign.left),
                                          ),
                                          Spacer(),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 17.5),
                                            child: Row(
                                                children:
                                                    // [
                                                    rate_star(model.RATE, 12)
                                                // for (var i = 0; i < 5; i++)
                                                //   Container(
                                                //     margin:
                                                //         const EdgeInsets.only(
                                                //             right: 2),
                                                //     height: 12,
                                                //     width: 12,
                                                //     child: Image.asset(
                                                //         "assets/images/star_100.png"),
                                                // )
                                                // ],
                                                ),
                                          )
                                        ]),
                                    Container(
                                        child: Row(children: [
                                      Text("${model.PROFESSOR}",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: const Color(0xff9b9b9b),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "NotoSansKR",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0),
                                          textAlign: TextAlign.center),
                                      Spacer(),
                                      // 담은 82
                                      Text("已选人数 ${model.NUMBER_OF_STUDENTS}",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: const Color(0xff9b9b9b),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "NotoSansKR",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 10.0),
                                          textAlign: TextAlign.right)
                                    ])),
                                    Container(
                                        child: Text(
                                            model.IS_NOT_DETERMINED
                                                ? "미지정"
                                                : model.IS_ICAMPUS
                                                    ? "[iCampus 수업]"
                                                    : "${classTimePretty(model.CLASS_TIME)}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: const Color(0xff9b9b9b),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "NotoSansKR",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.left)),
                                    Container(
                                      child: Row(
                                        children: [
                                          // Container(
                                          //   child: Text(
                                          //       model.CLASS_TIME.length == 0
                                          //           ? "null"
                                          //           : "${model.CLASS_TIME[0].class_room}",
                                          //       overflow: TextOverflow.ellipsis,
                                          //       style: const TextStyle(
                                          //           overflow:
                                          //               TextOverflow.ellipsis,
                                          //           color:
                                          //               const Color(0xff9b9b9b),
                                          //           fontWeight: FontWeight.w400,
                                          //           fontFamily: "NotoSansKR",
                                          //           fontStyle: FontStyle.normal,
                                          //           fontSize: 12.0),
                                          //       textAlign: TextAlign.center),
                                          // ),
                                          // Spacer(),
                                          // 전공
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 1),
                                            child: Text(
                                                // * 버림해서 (3.0 -> 3) 같은 값이면 버림
                                                "${model.CLASS_SECTOR_2} ${model.CREDIT.floor() == model.CREDIT ? model.CREDIT.floor() : model.CREDIT}학점 ${model.CLASS_NUMBER}",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color:
                                                        const Color(0xff9b9b9b),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 10.0),
                                                textAlign: TextAlign.center),
                                          ),
                                          Spacer(),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                                (model.CAMPUS == null ||
                                                        model.CAMPUS.isEmpty)
                                                    ? ""
                                                    : "${model.CAMPUS}",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color:
                                                        const Color(0xff9b9b9b),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                                textAlign: TextAlign.center),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 2, top: 2),
                                            child: Text(
                                                model.CLASS_TIME.length == 0
                                                    ? "[미지정]"
                                                    : "[${model.CLASS_TIME[0].class_room}]",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color:
                                                        const Color(0xff9b9b9b),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                                textAlign: TextAlign.center),
                                          ),
                                        ],
                                      ),
                                    ),
                                    index == controller.selectedIndex.value
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(top: 7),
                                            child: Row(
                                              children: [
                                                Ink(
                                                  child: InkWell(
                                                    onTap: () {
                                                      controller.addClass(
                                                          timeTableController
                                                              .selectedTimeTableId
                                                              .value);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          13)),
                                                          border: Border.all(
                                                              color: Get.theme
                                                                  .primaryColor,
                                                              width: 1),
                                                          color: const Color(
                                                              0xffffffff)),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 12,
                                                                vertical: 4.5),
                                                        child: Center(
                                                            child: Text("添加",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    overflow: TextOverflow
                                                                        .ellipsis,
                                                                    color: Get
                                                                        .theme
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        "NotoSansSC",
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        12.0),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Ink(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Get.toNamed(
                                                              '/class/view/${controller.CLASS_SEARCH[controller.selectedIndex.value].CLASS_ID}')
                                                          .then((value) async {
                                                        await MainUpdateModule
                                                            .updateClassPage();
                                                      });
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          13)),
                                                          border: Border.all(
                                                              color: Get.theme
                                                                  .primaryColor,
                                                              width: 1),
                                                          color: const Color(
                                                              0xffffffff)),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 12,
                                                                vertical: 4.5),
                                                        child: Center(
                                                            child: Text("讲义评",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    overflow: TextOverflow
                                                                        .ellipsis,
                                                                    color: Get
                                                                        .theme
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        "NotoSansSC",
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        12.0),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ]),
                            ),
                          ],
                        ));
                  }),
                ));
              },
              childCount:
                  controller.searchPage == controller.searchMaxPage.value
                      ? controller.CLASS_SEARCH.length
                      : controller.CLASS_SEARCH.length + 1,
            ),
          );
        }),
      ],
    );
  }
}

class searchClassSliverAppBar extends StatelessWidget {
  const searchClassSliverAppBar({Key key, @required this.controller})
      : super(key: key);
  final TimeTableAddClassSearchController controller;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 32 + 10.0 * 2,
      leadingWidth: 0,
      elevation: 0.0,
      titleSpacing: 0.0,
      flexibleSpace: Obx(() {
        return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            background: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                      height: 32,
                      child: // 전공/영역: 전체
                          InkWell(
                              onTap: () {
                                // * 선택된 강의 취소 후 이동
                                controller.selectedIndex.value = -1;
                                // * page 값 초기화
                                controller.initSeachPage();

                                Get.toNamed(
                                    Routes.TIMETABLE_ADDCLASS_FILTER_COLLEGE);
                              },
                              child: Container(
                                  height: 32,
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Row(children: [
                                    Center(
                                      child: // 专业/领域: 整个
                                          Text(
                                              "专业/教养领域: ${controller.college_major.value.isEmpty ? "所有" : controller.college_major.value}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color:
                                                      const Color(0xffffffff),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "NotoSansSC",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      child: Ink(
                                        child: InkWell(
                                            onTap: () async {
                                              controller.initMajor();
                                              // * page 값 초기화
                                              controller.initSeachPage();
                                              controller.getClass(
                                                  controller.searchPage);
                                            },
                                            child: Image.asset(
                                              "assets/images/timetable_filter_delete.png",
                                              width: 16,
                                              height: 16,
                                            )),
                                      ),
                                    )
                                  ]),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      color: Get.theme.primaryColor))),
                      margin: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: const Color(0xff1a4678))),

                  // 사각형 16
                  Container(
                      height: 32,
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Ink(
                        child: InkWell(
                          onTap: () {
                            // * 선택된 강의 취소 후 이동
                            controller.selectedIndex.value = -1;
                            // * page 값 초기화
                            controller.initSeachPage();
                            Get.toNamed(Routes.TIMETABLE_ADDCLASS_SEARCH);
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                      "课程名: ${controller.search_name.isEmpty ? "无" : controller.search_name}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "NotoSansSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Ink(
                                    child: InkWell(
                                      onTap: () async {
                                        controller.initSearchName();
                                        // * page 값 초기화
                                        controller.initSeachPage();
                                        await controller.getFilteredClass(0);
                                      },
                                      child: Image.asset(
                                        "assets/images/timetable_filter_delete.png",
                                        width: 16,
                                        height: 16,
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                      margin: const EdgeInsets.only(left: 12, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: Get.theme.primaryColor)),
                ],
              ),
            ));
      }),
    );
  }
}

class ClassInfoTPO extends StatelessWidget {
  const ClassInfoTPO(
      {Key key,
      @required this.size,
      @required this.timeTableAddClassController})
      : super(key: key);
  final TimeTableAddClassController timeTableAddClassController;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final days = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];

    return Obx(() {
      if (timeTableAddClassController.dataAvailable.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  margin: const EdgeInsets.only(bottom: 14.3),
                  child: Icon(Icons.timer),
                ),
                Container(
                  width: size.width - 15.3 - 14.8 - 30,
                  margin: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 14.3),
                          child: Text(
                            "요일과 시간을 설정해주세요",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: const Color(0xff999999),
                                fontWeight: FontWeight.w400,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() {
              double height =
                  timeTableAddClassController.CLASS_LIST.length * 76.0;
              return Container(
                height: height,
                margin: const EdgeInsets.only(left: 30),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: timeTableAddClassController.CLASS_LIST.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        Container(
                          child: TpoSelector(
                              timeTableAddClassController:
                                  timeTableAddClassController,
                              classIndex: index,
                              days: days,
                              size: size),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                              width: size.width - 15.3 - 14.8,
                              height: 1,
                              decoration: BoxDecoration(
                                  color: const Color(0xffdedede))),
                        ),
                      ]);
                    }),
              );
            }),

            // 사각형 511
            InkWell(
              onTap: () {
                timeTableAddClassController.selectIndex.value += 1;
              },
              child: Container(
                  width: 80,
                  height: 28,
                  margin: const EdgeInsets.only(left: 30, top: 10),
                  child: // complete
                      Center(
                    child: Text("장소 및 시간 추가",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 10.0),
                        textAlign: TextAlign.center),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      color: Colors.red)),
            )
          ],
        );
      } else {
        return Center(
            child: CircularProgressIndicator(
          color: Get.theme.primaryColor,
        ));
      }
    });
  }
}

class TpoSelector extends StatelessWidget {
  TpoSelector(
      {Key key,
      @required this.timeTableAddClassController,
      @required this.days,
      @required this.size,
      @required this.classIndex})
      : super(key: key);

  final TimeTableAddClassController timeTableAddClassController;
  final List<String> days;
  final Size size;
  final int classIndex;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            children: [
              Obx(() {
                return Container(
                  child: SelectDay(
                      newClass:
                          timeTableAddClassController.CLASS_LIST[classIndex],
                      days: days),
                );
              }),
              Obx(() {
                return Container(
                  child: SelectStartTime(
                      newClass:
                          timeTableAddClassController.CLASS_LIST[classIndex]),
                  padding: const EdgeInsets.only(left: 31.9, right: 27.2),
                );
              }),
              Obx(() {
                return Container(
                  child: SelectEndTime(
                      newClass:
                          timeTableAddClassController.CLASS_LIST[classIndex]),
                  padding: const EdgeInsets.only(right: 27.2),
                );
              }),
              Spacer(),
              Container(
                child: ClassTrashCan(
                    classIndex: classIndex,
                    timeTableAddClassController: timeTableAddClassController),
                margin: const EdgeInsets.only(right: 21.4),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 1),
          child: TextFormField(
            controller:
                timeTableAddClassController.classLocationController[classIndex],
            onChanged: (value) {
              timeTableAddClassController.CLASS_LIST[classIndex].update((val) {
                val.class_room = timeTableAddClassController
                    .classLocationController[classIndex].text;
              });
            },
            maxLines: 1,
            style: textStyle,
            textAlign: TextAlign.left,
            decoration: inputDecoration("class"),
          ),
        ),
      ],
    );
  }
}

class ClassTrashCan extends StatelessWidget {
  final TimeTableAddClassController timeTableAddClassController;
  final int classIndex;
  const ClassTrashCan(
      {Key key,
      @required this.timeTableAddClassController,
      @required this.classIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        timeTableAddClassController.CLASS_LIST.removeAt(classIndex);
      },
      child: Container(
        width: 17.104248046875,
        height: 16.619873046875,
        child: Image.asset(
          "assets/images/15_4.png",
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class SelectDay extends StatelessWidget {
  SelectDay({
    Key key,
    @required this.newClass,
    @required this.days,
  }) : super(key: key);

  final Rx<AddClassModel> newClass;
  final List<String> days;
  final TimeTableController timeTableController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButton(
          underline: Container(),
          icon: // 패스 908
              Container(
            width: 10.682647705078125,
            height: 5.931396484375,
            margin: const EdgeInsets.only(top: 8, bottom: 4.5),
            child: Image.asset("assets/images/940.png"),
          ),
          value: newClass.value.day,
          onChanged: (value) {
            newClass.update((val) {
              val.day = value;
              if (getIndexFromDay(value) >= 5) {
                timeTableController.isExpandedHor.value = true;
              }
            });
          },
          items: days
              .map((e) => DropdownMenuItem(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.7),
                    child: Text(
                      e,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  value: e))
              .toList());
    });
  }
}

class SelectStartTime extends StatelessWidget {
  SelectStartTime({
    Key key,
    @required this.newClass,
  }) : super(key: key);

  final Rx<AddClassModel> newClass;
  final TimeTableController timeTableController = Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime start_time = newClass.value.start_time;

        DateTime timeInput = DateTime(start_time.year, start_time.month,
            start_time.day, start_time.hour, start_time.minute);
        DateTime end_time = newClass.value.end_time;
        bool flag = false;

        int fastest = 9 * 60;
        int lastest = 21 * 60;

        // * 시간표에서 시간 고를 때
        await Get.defaultDialog(
            title: "Select Time",
            content: Container(
              height: 200,
              width: Get.mediaQuery.size.width,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: start_time,
                  minuteInterval: 5,
                  onDateTimeChanged: (DateTime dateTime) {
                    timeInput = dateTime;
                  }),
            ));

        int cal_time = timeInput.hour * 60 + timeInput.minute;
        if (cal_time >= fastest && cal_time < lastest) {
          timeInput = timeInput;
        } else {
          // Get.snackbar("9시부터 21시 사이로 골라주세요", "9시부터 21시 사이로 골라주세요",
          //     snackPosition: SnackPosition.BOTTOM);
          return;
        }

        if (timeInput.hour >= 0 &&
            timeInput.hour < timeTableController.limitStartTime.value) {
          timeTableController.limitStartTime.value = timeInput.hour;
        }
        if (timeInput.isAfter(end_time) ||
            timeInput.isAtSameMomentAs(end_time)) {
          newClass.update((val) {
            val.end_time = DateTime(timeInput.year, timeInput.month,
                timeInput.day, timeInput.hour + 1, timeInput.minute);
          });
        }
        newClass.update((val) {
          val.start_time = DateTime(timeInput.year, timeInput.month,
              timeInput.day, timeInput.hour, timeInput.minute);
        });
      },
      child: Obx(() {
        return Row(children: [
          Container(
            child: Text("${timeFormatter(newClass.value.start_time)}",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w400,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),
          ),
          Container(
            width: 10.68267822265625,
            height: 5.931396484375,
            margin: const EdgeInsets.only(left: 10.7, top: 8, bottom: 4.5),
            child: Image.asset("assets/images/940.png"),
          )
        ]);
      }),
    );
  }
}

class SelectEndTime extends StatelessWidget {
  const SelectEndTime({
    Key key,
    @required this.newClass,
  }) : super(key: key);

  final Rx<AddClassModel> newClass;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime end_time = newClass.value.end_time;

        DateTime timeInput = DateTime(end_time.year, end_time.month,
            end_time.day, end_time.hour, end_time.minute);

        DateTime start_time = newClass.value.start_time;

        int fastest = 9 * 60;
        int lastest = 21 * 60;
        await Get.defaultDialog(
            title: "Select Time",
            content: Container(
              height: 200,
              width: Get.mediaQuery.size.width,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: newClass.value.end_time,
                  minuteInterval: 5,
                  onDateTimeChanged: (DateTime dateTime) {
                    timeInput = dateTime;
                  }),
            ));

        int cal_time = timeInput.hour * 60 + timeInput.minute;
        if (cal_time > fastest && cal_time <= lastest) {
          timeInput = timeInput;
        } else {
          // Get.snackbar("9시부터 21시 사이로 골라주세요", "9시부터 21시 사이로 골라주세요",
          //     snackPosition: SnackPosition.BOTTOM);
          return;
        }

        if (timeInput.isBefore(start_time) ||
            timeInput.isAtSameMomentAs(start_time)) {
          newClass.update((val) {
            val.start_time = DateTime(timeInput.year, timeInput.month,
                timeInput.day, timeInput.hour - 1, timeInput.minute);
          });
        }
        newClass.update((val) {
          val.end_time = DateTime(timeInput.year, timeInput.month,
              timeInput.day, timeInput.hour, timeInput.minute);
        });

        // if (other_flag) {
        //   newClass.update((val) {
        //     val.start_time = DateTime(start_time.year, start_time.month,
        //         start_time.day, timeInput.hour - 1, timeInput.minute);
        //   });
        // } else {
        //   newClass.update((val) {
        //     timeInput = DateTime(
        //         timeInput.year,
        //         timeInput.month,
        //         timeInput.day,
        //         (timeInput.hour > 21)
        //             ? 21
        //             : self_flag
        //                 ? start_time.hour + 1
        //                 : timeInput.hour,
        //         timeInput.minute);
        //     val.end_time = timeInput;
        //   });
        // }
      },
      child: Obx(() {
        return Row(children: [
          Container(
            child: Text("${timeFormatter(newClass.value.end_time)}",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w400,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),
          ),
          Container(
            width: 10.68267822265625,
            height: 5.931396484375,
            margin: const EdgeInsets.only(left: 10.7, top: 8, bottom: 4.5),
            child: Image.asset("assets/images/940.png"),
          )
        ]);
      }),
    );
  }
}