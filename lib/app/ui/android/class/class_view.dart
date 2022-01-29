import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';
import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/ui/android/class/functions/rating.dart';
import 'package:polarstar_flutter/app/ui/android/class/functions/semester.dart';

import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/modal_bottom_sheet.dart';
import 'package:polarstar_flutter/app/ui/android/functions/timetable_semester.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/timetable.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// Colors
const mainColor = 0xff4570ff;
const backgroundColor = 0xffe6f1ff;
const classInfoColor = 0xff2f2f2f;
const categoryColor = 0xff2f2f2f;

// Sizes
const starSize = 12.0;

class ClassView extends StatelessWidget {
  const ClassView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClassViewController classViewController = Get.find();
    final reviewTextController = TextEditingController();
    final examInfoTextController = TextEditingController();
    final testStrategyController = TextEditingController();
    final pageController = PageController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(backgroundColor),
        appBar: AppBars().classBasicAppBar(),
        // bottomSheet: Container(
        //   height: 56,
        //   child: TabBarView(
        //       controller: classViewController.tabController,
        //       children: [
        //         Ink(
        //           color: const Color(mainColor),
        //           child: InkWell(
        //             onTap: () {
        //               showModalBottomSheet(
        //                   shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.only(
        //                           topLeft: const Radius.circular(20),
        //                           topRight: const Radius.circular(20))),
        //                   isScrollControlled: true,
        //                   context: context,
        //                   builder: (BuildContext context) {
        //                     return WriteComment(
        //                       classInfoModel:
        //                           classViewController.classInfo.value,
        //                       // classViewController: classViewController,
        //                       reviewTextController: reviewTextController,
        //                       CLASS_ID:
        //                           classViewController.classInfo.value.CLASS_ID,
        //                     );
        //                   });
        //             },
        //             child: Container(
        //               height: 50,
        //               width: Get.mediaQuery.size.width,
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Icon(
        //                       Icons.post_add,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Text(
        //                       "Writing Evaluation",
        //                       textScaleFactor: 1.2,
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.normal),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //         Ink(
        //           color: const Color(mainColor),
        //           child: InkWell(
        //             onTap: () {
        //               showModalBottomSheet(
        //                   shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.only(
        //                           topLeft: const Radius.circular(30),
        //                           topRight: const Radius.circular(30))),
        //                   isScrollControlled: true,
        //                   context: context,
        //                   builder: (BuildContext context) {
        //                     return WriteExamInfo(
        //                         classViewController: classViewController,
        //                         examInfoTextController: examInfoTextController,
        //                         testStrategyController: testStrategyController);
        //                   });
        //             },
        //             child: Container(
        //               height: 50,
        //               width: Get.mediaQuery.size.width,
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Icon(
        //                       Icons.add_circle_outline,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Text(
        //                       "Add Exam Information",
        //                       textScaleFactor: 1.2,
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.normal),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ]),
        // ),

        body: RefreshIndicator(
          notificationPredicate: (notification) {
            return notification.depth == 2;
          },
          onRefresh: classViewController.refreshPage,
          child: Obx(() {
            if (classViewController.classViewAvailable.value) {
              return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        pinned: false,
                        floating: false,
                        snap: false,
                        forceElevated: false,
                        elevation: 0,
                        expandedHeight: 300.0,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: ClassViewInfo(
                              classInfoModel:
                                  classViewController.classInfo.value),
                        ),
                        backgroundColor: const Color(backgroundColor),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: MenuTabBar(
                          classViewController: classViewController,
                          tabBar: TabBar(
                            controller: classViewController.tabController,
                            labelColor: const Color(0xffffffff),
                            unselectedLabelColor: const Color(0xff2f2f2f),
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: const Color(mainColor)),
                            tabs: <Tab>[
                              Tab(
                                text: "讲义评价",
                              ),
                              Tab(
                                text: "考试信息",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                      controller: classViewController.tabController,
                      children: [
                        Stack(children: [
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(8))),
                                  child: ClassViewReview(
                                    classReviewModel: classViewController
                                        .classReviewList[index],
                                    index: index,
                                  ),
                                );
                              } else if (index ==
                                  classViewController.classReviewList.length -
                                      1) {
                                return Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(8))),
                                  child: ClassViewReview(
                                    classReviewModel: classViewController
                                        .classReviewList[index],
                                    index: index,
                                  ),
                                );
                              } else {
                                return Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: ClassViewReview(
                                    classReviewModel: classViewController
                                        .classReviewList[index],
                                    index: index,
                                  ),
                                );
                              }
                            },
                            itemCount:
                                classViewController.classReviewList.length,
                            separatorBuilder: (context, index) {
                              return Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 34.5),
                                  height: 1,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffeaeaea)));
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              color: const Color(mainColor),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(20),
                                              topRight:
                                                  const Radius.circular(20))),
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return WriteComment(
                                          classInfoModel: classViewController
                                              .classInfo.value,
                                          // classViewController: classViewController,
                                          reviewTextController:
                                              reviewTextController,
                                          CLASS_ID: classViewController
                                              .classInfo.value.CLASS_ID,
                                        );
                                      });
                                },
                                child: Container(
                                    height: 50,
                                    width: Get.mediaQuery.size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Padding(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   child: Icon(
                                        //     Icons.post_add,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "写讲义评价",
                                            // textScaleFactor: 1.2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "NotoSansSC",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14.0),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ]),
                        Obx(() {
                          if (classViewController.classExamAvailable.value) {
                            return Stack(children: [
                              Positioned.fill(
                                child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ClassExamInfo(
                                        classExamModel: classViewController
                                            .classExamList[index],
                                        classInfoModel:
                                            classViewController.classInfo.value,
                                        index: index,
                                      );
                                    },
                                    itemCount: classViewController
                                        .classExamList.length,
                                    separatorBuilder: (context, index) {
                                      return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 34.5),
                                          height: 1,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffeaeaea)));
                                    }),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  color: const Color(mainColor),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(30),
                                                  topRight:
                                                      const Radius.circular(
                                                          30))),
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return WriteExamInfo(
                                                classViewController:
                                                    classViewController,
                                                examInfoTextController:
                                                    examInfoTextController,
                                                testStrategyController:
                                                    testStrategyController);
                                          });
                                    },
                                    child: Container(
                                        height: 50,
                                        width: Get.mediaQuery.size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.all(8.0),
                                            //   child: Icon(
                                            //     Icons.add_circle_outline,
                                            //     color: Colors.white,
                                            //   ),
                                            // ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "写考试信息",
                                                overflow: TextOverflow.ellipsis,
                                                // textScaleFactor: 1.2,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color:
                                                        const Color(0xffffffff),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "NotoSansSC",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ]);
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })
                      ]));

              //     CustomScrollView(
              //   slivers: <Widget>[
              //     // 강의 정부
              //     SliverToBoxAdapter(
              //       child: ClassViewInfo(
              //           classInfoModel: classViewController.classInfo.value),
              //     ),
              //     // Comment, Exam Info Tabbar
              //     SliverPersistentHeader(
              //         pinned: true,
              //         delegate: MenuTabBar(
              //           classViewController: classViewController,
              //           tabBar: TabBar(
              //             controller: classViewController.tabController,
              //             labelColor: const Color(0xffffffff),
              //             unselectedLabelColor: const Color(0xff2f2f2f),
              //             labelStyle: const TextStyle(
              //                 fontWeight: FontWeight.w500,
              //                 fontFamily: "NotoSansSC",
              //                 fontStyle: FontStyle.normal,
              //                 fontSize: 14.0),
              //             indicator: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(8.0),
              //                 color: const Color(mainColor)),
              //             tabs: <Tab>[
              //               Tab(
              //                 text: "在校生交流区",
              //               ),
              //               Tab(
              //                 text: "考试攻略",
              //               ),
              //             ],
              //           ),
              //         )),

              //     SliverFillRemaining(

              //       child: TabBarView(
              //           controller: classViewController.tabController,
              //           children: <Widget>[
              //             ListView.separated(
              //                 // physics: NeverScrollableScrollPhysics(),
              //                 itemBuilder: (context, index) {
              //                   return ClassViewReview(
              //                     classReviewModel: classViewController
              //                         .classReviewList[index],
              //                     index: index,
              //                   );
              //                 },
              //                 separatorBuilder: (context, index) {
              //                   return Container(
              //                       width: 292,
              //                       height: 1,
              //                       decoration: BoxDecoration(
              //                           color: const Color(0xffeaeaea)));
              //                 },
              //                 itemCount:
              //                     classViewController.classReviewList.length),
              //             ListView.separated(
              //                 // physics: NeverScrollableScrollPhysics(),
              //                 itemBuilder: (context, index) {
              //                   return ClassViewReview(
              //                     classReviewModel: classViewController
              //                         .classReviewList[index],
              //                     index: index,
              //                   );
              //                 },
              //                 separatorBuilder: (context, index) {
              //                   return Container(
              //                       width: 292,
              //                       height: 1,
              //                       decoration: BoxDecoration(
              //                           color: const Color(0xffeaeaea)));
              //                 },
              //                 itemCount:
              //                     classViewController.classReviewList.length),
              //           ]),
              //     ),
              //     // SliverPersistentHeader(pinned: true, delegate: IndexButton()),
              //     // SliverToBoxAdapter(
              //     //   child: Container(
              //     //     width: Get.mediaQuery.size.width,
              //     //     height: 10,
              //     //   ),
              //     // ),
              //     // Obx(() {
              //     //   if (classViewController.typeIndex == 0) {
              //     //     return SliverList(
              //     //       delegate: SliverChildBuilderDelegate(
              //     //           (BuildContext context, int index) {
              //     //         return GestureDetector(
              //     //           //* SWAPPING remove
              //     //           /* onHorizontalDragEnd: (dragEnd) {
              //     //             if (dragEnd.primaryVelocity < 0) {
              //     //               classViewController.typeIndex(1);
              //     //             }
              //     //           }, */
              //     //           child: ClassViewReview(
              //     //             classReviewModel:
              //     //                 classViewController.classReviewList[index],
              //     //             index: index,
              //     //           ),
              //     //         );
              //     //       },
              //     //           childCount:
              //     //               classViewController.classReviewList.length),
              //     //     );
              //     //   } else {
              //     //     if (classViewController.classExamAvailable.value) {
              //     //       return SliverList(
              //     //         delegate: SliverChildBuilderDelegate(
              //     //             (BuildContext context, int index) {
              //     //           return GestureDetector(
              //     //             //* SWAPPING remove
              //     //             /* onHorizontalDragEnd: (dragEnd) {
              //     //               if (dragEnd.primaryVelocity > 0) {
              //     //                 classViewController.typeIndex(0);
              //     //               }
              //     //             }, */
              //     //             child: ClassExamInfo(
              //     //               classExamModel:
              //     //                   classViewController.classExamList[index],
              //     //               classInfoModel:
              //     //                   classViewController.classInfo.value,
              //     //               index: index,
              //     //             ),
              //     //           );
              //     //         },
              //     //             childCount:
              //     //                 classViewController.classExamList.length),
              //     //       );
              //     //     } else {
              //     //       return SliverToBoxAdapter(
              //     //           child: GestureDetector(
              //     //         onHorizontalDragEnd: (dragEnd) {
              //     //           if (dragEnd.primaryVelocity > 0) {
              //     //             classViewController.typeIndex(0);
              //     //           }
              //     //         },
              //     //         child: Center(
              //     //           child: CircularProgressIndicator(),
              //     //         ),
              //     //       ));
              //     //     }
              //     //   }
              //     // }),
              //     // SliverToBoxAdapter(
              //     //     child: SizedBox(
              //     //   height: 50,
              //     // )),
              //   ],
              // );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      ),
    );
  }
}

class ClassViewInfo extends StatelessWidget {
  const ClassViewInfo({Key key, @required this.classInfoModel})
      : super(key: key);
  final ClassInfoModel classInfoModel;

  @override
  Widget build(BuildContext context) {
    // final ClassViewController classViewController = Get.find();
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            height: 100,
            margin: EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 14.0),
            padding: EdgeInsets.fromLTRB(20.0, 23.0, 20.0, 20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color(0xffeaeaea), width: 1),
                color: const Color(classInfoColor)),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${classInfoModel.CLASS_NAME}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  Text("${classInfoModel.PROFESSOR}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: const Color(0xff6f6e6e),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0),
                      textAlign: TextAlign.left),
                  Row(
                    children: [
                      Container(
                        width: 68.0,
                        height: 12.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: classInfoModel.AVG_RATE != null
                              ? rate_star(classInfoModel.AVG_RATE, 12.0)
                              : rate_star("0.0", 12.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                            classInfoModel.AVG_RATE != null
                                ? "(${classInfoModel.AVG_RATE})"
                                : "",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          // 세부 내용
          Column(
            children: [
              // SECTOR
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("作业量",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(categoryColor),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansTC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Text(
                      "${classInfoModel.CLASS_SECTOR_1}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.bold,
                          fontFamily: "NotoSansTC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
              //* 말하기 속도, 억양, 사투리
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("教授语速、方言等",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(categoryColor),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NㅋotoSansTC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      width: 68,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: classInfoModel.AVG_RATE_LANGUAGE != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_LANGUAGE, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              //* 외국인을 대하는 태도
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("教授对留学生的态度",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(categoryColor),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansTC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      width: 68,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: classInfoModel.AVG_RATE_ATTITUDE != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_ATTITUDE, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              //* 시험 난이도
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("考试难度",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(categoryColor),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansTC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      width: 68,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            classInfoModel.AVG_RATE_EXAM_DIFFICULTY != null
                                ? rate_heart(
                                    classInfoModel.AVG_RATE_EXAM_DIFFICULTY,
                                    starSize)
                                : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              //* 과제량
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("作业量",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff2f2f2f),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansTC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      width: 68,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: classInfoModel.AVG_RATE_ASSIGNMENT != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_ASSIGNMENT, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              //* 학점 비율
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("给分",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff2f2f2f),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansTC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      width: 68,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: classInfoModel.AVG_RATE_GRADE != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_GRADE, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
          // Sector
        ],
      ),
    );
  }
}

class ClassViewReview extends StatelessWidget {
  const ClassViewReview({Key key, this.classReviewModel, this.index})
      : super(key: key);
  final ClassReviewModel classReviewModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ClassViewController classViewController = Get.find();
    print(classReviewModel.CLASS_YEAR);
    print(classReviewModel.CLASS_SEMESTER);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //* 별점 & 좋아요
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 4.0),
                          width: 68,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: rate_star(classReviewModel.RATE, 12))),
                      Text("(${classReviewModel.RATE})",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.center),
                    ],
                  ),
                  InkWell(
                    splashColor: Colors.cyan[100].withOpacity(0.6),
                    onTap: () async {
                      await classViewController.getCommentLike(
                          classReviewModel.CLASS_ID,
                          classReviewModel.CLASS_COMMENT_ID,
                          index);
                    },
                    child: Container(
                      width: 25.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.thumb_up, size: 12.0, color: Colors.cyan),
                          Text(
                            classReviewModel.LIKES.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.cyan,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                          )
                        ],
                      ),
                    ),
                  ),

                  //   TextButton.icon(
                  //       style: ButtonStyle(
                  //           foregroundColor:
                  //               MaterialStateProperty.all(Colors.cyan[200]),
                  //           overlayColor: MaterialStateProperty.all(
                  //               Colors.cyan[100].withOpacity(0.6))),
                  //       onPressed: () async {
                  //         await classViewController.getCommentLike(
                  //             classReviewModel.CLASS_ID,
                  //             classReviewModel.CLASS_COMMENT_ID,
                  //             index);
                  //       },
                  //       icon: Icon(Icons.thumb_up, size: 12),
                  //       label: Text(classReviewModel.LIKES.toString()))
                ]),
          ),

          // * 수강 학기: 데이터 안 날라옴
          Text(
              "${timetableSemChanger(classReviewModel.CLASS_YEAR, classReviewModel.CLASS_SEMESTER)}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: const Color(0xff9b9b9b),
                  fontWeight: FontWeight.w300,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 10.0),
              textAlign: TextAlign.left),

          Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 14.0),
              width: Get.mediaQuery.size.width,
              // decoration: BoxDecoration(
              //     color: Colors.grey[200],
              //     borderRadius: BorderRadius.circular(10)),
              child: Text(
                classReviewModel.CONTENT,
                overflow: TextOverflow.ellipsis,
                // maxLines: 2,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xff707070),
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
              ))
        ],
      ),
    );
  }
}

class ClassExamInfo extends StatelessWidget {
  const ClassExamInfo(
      {Key key,
      @required this.classExamModel,
      @required this.classInfoModel,
      this.index})
      : super(key: key);
  final ClassExamModel classExamModel;
  final ClassInfoModel classInfoModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ClassViewController classViewController = Get.find();

    return Stack(children: [
      Container(
          child: ImageFiltered(
        imageFilter: classExamModel.IS_BUYED
            ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
            : ImageFilter.blur(
                sigmaX: 5.0, sigmaY: 5.0, tileMode: TileMode.decal),
        child: GestureDetector(
          onTap: () {
            if (classExamModel.IS_BUYED) {
              print("이미 구매한 정보");
            } else {
              Get.defaultDialog(
                  title: "시험 정보 구매",
                  middleText: "시험 정보를 구매하시겠습니까?",
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Get.back();
                          await classViewController.buyExamInfo(
                              classExamModel.CLASS_ID,
                              classExamModel.CLASS_EXAM_ID);
                        },
                        child: Text("네", overflow: TextOverflow.ellipsis)),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "아니요",
                          overflow: TextOverflow.ellipsis,
                        )),
                  ]);
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* 시험 종류
                  Row(
                    children: [
                      Text(
                        classExamModel.MID_FINAL != null
                            ? "${classExamModel.MID_FINAL}"
                            : "Unknown",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff2f2f2f),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () async {
                          await classViewController.getExamLike(
                              classExamModel.CLASS_ID,
                              classExamModel.CLASS_EXAM_ID,
                              index);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Image.asset(
                                "assets/images/like_class.png",
                                height: 12.0,
                                width: 12.0,
                              ),
                            ),
                            Text(
                              classExamModel.LIKES.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: const Color(0xff4570ff),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  //* 학기 정보
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                        "${timetableSemChanger(classExamModel.CLASS_EXAM_YEAR, classExamModel.CLASS_EXAM_SEMESTER)}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff6f6e6e),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),
                  ),

                  //* 시험 전략
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text("考试攻略 :",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: const Color(0xff2f2f2f),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.left),
                        ),
                        classExamModel.TEST_STRATEGY != null
                            ? Text(
                                classExamModel.TEST_STRATEGY,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: const Color(0xff6f6e6e),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                              )
                            : Text('')
                      ],
                    ),
                  ),
                  //* 문제 유형
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "考试类型 :",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: const Color(0xff2f2f2f),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                          ),
                        ),
                        classExamModel.TEST_TYPE != null
                            ? Text(
                                classExamModel.TEST_TYPE,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: const Color(0xff6f6e6e),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                              )
                            : Text('')
                      ],
                    ),
                  ),
                  //* 시험 예시
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "考试真题 :",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: const Color(0xff2f2f2f),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // height: 54.0,
                            child: classExamModel.TEST_EXAMPLE != null
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        classExamModel.TEST_EXAMPLE.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: classExamModel
                                                    .TEST_EXAMPLE[index] !=
                                                null
                                            ? Text(
                                                classExamModel
                                                    .TEST_EXAMPLE[index],
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansSC",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                              )
                                            : Text(''),
                                      );
                                      ;
                                    })
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      "There are no examples",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
      Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Container(
                  child: Text(
                classExamModel.IS_BUYED
                    ? ""
                    : '시험 정보를 구매해야 열람할 수 있습니다!\n' +
                        '현재 내 포인트 : ${classInfoModel.MY_CLASS_POINT}',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xff2f2f2f),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
              ))))
    ]);
  }
}

class MenuTabBar extends SliverPersistentHeaderDelegate {
  MenuTabBar({this.classViewController, this.tabBar});

  final ClassViewController classViewController;
  final TabBar tabBar;

  // @override
  // Size get preferredSize => Size(tabBar.preferredSize.width, 80.0);

  @override
  Widget build(
      BuildContext context, double shirinkOffset, bool overlapsContent) {
    return new Container(
      color: const Color(backgroundColor),
      height: 80.0,
      child: Container(
        margin: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: const Color(0xffffffff)),
        child: tabBar,
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 80.0;

  @override
  // TODO: implement minExtent
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}

// class MenuTabBar extends SliverPersistentHeaderDelegate {
//   final height = 76.0;
//   final ClassViewController classViewController = Get.find();

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
//       width: 320.0,
//       height: 44.0,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//           color: const Color(0xffffffff)),
//       child: TabBar(
//         controller: classViewController.tabController,
//         labelColor: const Color(0xffffffff),
//         unselectedLabelColor: const Color(0xff2f2f2f),
//         labelStyle: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontFamily: "NotoSansSC",
//             fontStyle: FontStyle.normal,
//             fontSize: 14.0),
//         indicator: BoxDecoration(color: const Color(mainColor)),
//         tabs: <Tab>[
//           Tab(
//             text: "在校生交流区",
//           ),
//           Tab(
//             text: "考试攻略",
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   // TODO: implement maxExtent
//   double get maxExtent => height;

//   @override
//   // TODO: implement minExtent
//   double get minExtent => height;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     // TODO: implement shouldRebuild
//     return false;
//   }
// }

//! 안씀 제거예정
// class IndexButton extends SliverPersistentHeaderDelegate {
//   final height = 50.0;
//   final ClassViewController classViewController = Get.find();

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(
//       child: Container(
//         decoration: BoxDecoration(color: Colors.grey[200]),
//         child: Container(
//           margin: EdgeInsets.only(top: 10),
//           // height: 40,
//           decoration: BoxDecoration(color: Colors.white),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               // commenr, exam info button
//               GestureDetector(
//                 onTap: () {
//                   classViewController.typeIndex(0);
//                 },
//                 child: Container(
//                   width: Get.mediaQuery.size.width / 2,
//                   child: Center(
//                     child: Obx(
//                       () => Text(
//                         "Comment",
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             color: classViewController.typeIndex.value == 0
//                                 ? Color(0xff1a4678)
//                                 : Colors.black,
//                             fontWeight: classViewController.typeIndex.value == 0
//                                 ? FontWeight.bold
//                                 : FontWeight.normal),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   classViewController.typeIndex(1);
//                   if (!classViewController.classExamAvailable.value) {
//                     print("exam data fetch");
//                     classViewController
//                         .getExamInfo(int.parse(Get.parameters["CLASS_ID"]));
//                   }
//                 },
//                 child: Container(
//                   width: Get.mediaQuery.size.width / 2,
//                   child: Center(
//                     child: Obx(
//                       () => Text(
//                         "Exam Information",
//                         style: TextStyle(
//                             fontSize: 18.0,
//                             color: classViewController.typeIndex.value == 1
//                                 ? Color(0xff1a4678)
//                                 : Colors.black,
//                             fontWeight: classViewController.typeIndex.value == 1
//                                 ? FontWeight.bold
//                                 : FontWeight.normal),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }

//   @override
//   double get minExtent => height;

//   @override
//   double get maxExtent => height;
// }
