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
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/timetable.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// Colors
const mainColor = 0xff371ac7;
const backgroundColor = 0xfff5f6ff;
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
        bottomSheet: Ink(
          color: const Color(mainColor),
          child: InkWell(
            onTap: () {
              if (classViewController.typeIndex.value == 0) {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(30),
                            topRight: const Radius.circular(30))),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return WriteComment(
                        // classViewController: classViewController,
                        reviewTextController: reviewTextController,
                        CLASS_ID: classViewController.classInfo.value.CLASS_ID,
                      );
                    });
              } else {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(30),
                            topRight: const Radius.circular(30))),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return WriteExamInfo(
                          classViewController: classViewController,
                          examInfoTextController: examInfoTextController,
                          testStrategyController: testStrategyController);
                    });
              }
            },
            child: Container(
              height: 50,
              width: Get.mediaQuery.size.width,
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          classViewController.typeIndex.value == 0
                              ? Icons.post_add
                              : Icons.add_circle_outline,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          classViewController.typeIndex.value == 0
                              ? "Writing Evaluation"
                              : "Add Exam Information",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
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
                        expandedHeight: 272,
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
                                text: "在校生交流区",
                              ),
                              Tab(
                                text: "考试攻略",
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
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
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
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
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
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
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
                          itemCount: classViewController.classReviewList.length,
                          separatorBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.symmetric(horizontal: 34.5),
                                height: 1,
                                decoration: BoxDecoration(
                                    color: const Color(0xffeaeaea)));
                          },
                        ),
                        Obx(() {
                          if (classViewController.classExamAvailable.value) {
                            return ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return ClassExamInfo(
                                    classExamModel: classViewController
                                        .classExamList[index],
                                    classInfoModel:
                                        classViewController.classInfo.value,
                                    index: index,
                                  );
                                },
                                itemCount:
                                    classViewController.classExamList.length,
                                separatorBuilder: (context, index) {
                                  return Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 34.5),
                                      height: 1,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffeaeaea)));
                                });
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
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  Text("${classInfoModel.PROFESSOR}",
                      style: const TextStyle(
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
                                : "평가 X",
                            style: const TextStyle(
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
                        style: const TextStyle(
                            color: const Color(categoryColor),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansTC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Text(
                      "${classInfoModel.CLASS_SECTOR_1}",
                      style: TextStyle(
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
              // Team Project
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("小组作业量",
                        style: const TextStyle(
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
                        children: classInfoModel.AVG_RATE_GROUP_STUDY != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_GROUP_STUDY, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              // 과제량
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("考试难度",
                        style: const TextStyle(
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
                        children: classInfoModel.AVG_RATE_ASSIGNMENT != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_ASSIGNMENT, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              //시험공부량
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("授课方式",
                        style: const TextStyle(
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
                        children: classInfoModel.AVG_RATE_EXAM_STUDY != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_EXAM_STUDY, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              // 학점 비율
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("出勤",
                        style: const TextStyle(
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
                        children: classInfoModel.AVG_RATE_GRADE_RATIO != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_GRADE_RATIO, starSize)
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 별점 & 좋아요
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 68,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: rate_star(classReviewModel.RATE, 12))),
              TextButton.icon(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.red),
                      overlayColor: MaterialStateProperty.all(
                          Colors.red.withOpacity(0.6))),
                  onPressed: () async {
                    await classViewController.getCommentLike(
                        classReviewModel.CLASS_ID,
                        classReviewModel.CLASS_COMMENT_ID,
                        index);
                  },
                  icon: Icon(Icons.thumb_up, size: 12),
                  label: Text(classReviewModel.LIKES.toString()))
            ],
          ),

          // 수강 학기: 데이터 안 날라옴
          Text(
              "${semester(classReviewModel.CLASS_SEMESTER)} Semester Of ${classReviewModel.CLASS_YEAR}",
              style: const TextStyle(
                  color: const Color(0xff9b9b9b),
                  fontWeight: FontWeight.w300,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 10.0),
              textAlign: TextAlign.left),

          Container(
              margin: EdgeInsets.only(top: 11, bottom: 13),
              width: Get.mediaQuery.size.width,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                child: Text(
                  classReviewModel.CONTENT,
                  // maxLines: 2,
                  style: TextStyle(
                      color: const Color(0xff707070),
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                ),
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
            : ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: GestureDetector(
          onTap: () {
            print(classExamModel.CLASS_ID);
            print(classExamModel.CLASS_EXAM_ID);

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
                        child: Text("네")),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("아니요")),
                  ]);
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 시험 종류 이것도 데이터 없음
                  Row(
                    children: [
                      Text(
                        classExamModel.MID_FINAL != null
                            ? "The ${classExamModel.MID_FINAL} Exam"
                            : "The Unknown Exam",
                        textScaleFactor: 1.4,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      TextButton.icon(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.red.withOpacity(0.6))),
                          onPressed: () async {
                            await classViewController.getExamLike(
                                classExamModel.CLASS_ID,
                                classExamModel.CLASS_EXAM_ID,
                                index);
                          },
                          icon: Icon(Icons.thumb_up, size: 20),
                          label: Text(classExamModel.LIKES.toString()))
                    ],
                  ),
                  // 학기 정보
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(semester(classExamModel.CLASS_EXAM_SEMESTER) +
                        " Semester Of " +
                        classExamModel.CLASS_EXAM_YEAR.toString()),
                  ),

                  // 시험 전략
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text("Test Strategy",
                              style: TextStyle(fontWeight: FontWeight.w300)),
                        ),
                        Expanded(
                          flex: 3,
                          child: classExamModel.TEST_STRATEGY != null
                              ? Text(
                                  classExamModel.TEST_STRATEGY,
                                )
                              : Text(''),
                        )
                      ],
                    ),
                  ),
                  // 문제 유형
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text("Questions Type",
                              style: TextStyle(fontWeight: FontWeight.w300)),
                        ),
                        Expanded(
                          flex: 3,
                          child: classExamModel.TEST_TYPE != null
                              ? Text(classExamModel.TEST_TYPE)
                              : Text(''),
                        )
                      ],
                    ),
                  ),
                  // 문제 예시
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text("For Example",
                              style: TextStyle(fontWeight: FontWeight.w300)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 90,
                            child: classExamModel.TEST_EXAMPLE != null
                                ? ListView.builder(
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
                                            ? Text(classExamModel
                                                .TEST_EXAMPLE[index])
                                            : Text(''),
                                      );
                                      ;
                                    })
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text("There are no examples"),
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0)))))
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

class IndexButton extends SliverPersistentHeaderDelegate {
  final height = 50.0;
  final ClassViewController classViewController = Get.find();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          // height: 40,
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // commenr, exam info button
              GestureDetector(
                onTap: () {
                  classViewController.typeIndex(0);
                },
                child: Container(
                  width: Get.mediaQuery.size.width / 2,
                  child: Center(
                    child: Obx(
                      () => Text(
                        "Comment",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: classViewController.typeIndex.value == 0
                                ? Color(0xff1a4678)
                                : Colors.black,
                            fontWeight: classViewController.typeIndex.value == 0
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  classViewController.typeIndex(1);
                  if (!classViewController.classExamAvailable.value) {
                    print("exam data fetch");
                    classViewController
                        .getExamInfo(int.parse(Get.parameters["CLASS_ID"]));
                  }
                },
                child: Container(
                  width: Get.mediaQuery.size.width / 2,
                  child: Center(
                    child: Obx(
                      () => Text(
                        "Exam Information",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: classViewController.typeIndex.value == 1
                                ? Color(0xff1a4678)
                                : Colors.black,
                            fontWeight: classViewController.typeIndex.value == 1
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;
}
