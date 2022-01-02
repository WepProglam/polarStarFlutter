import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
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
        backgroundColor: Colors.grey[200],
        appBar: AppBars().classBasicAppBar(),
        bottomSheet: Ink(
          color: Colors.blue[900],
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
          onRefresh: classViewController.refreshPage,
          child: Obx(() {
            if (classViewController.classViewAvailable.value) {
              return SafeArea(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: ClassViewInfo(
                          classInfoModel: classViewController.classInfo.value),
                    ),
                    SliverPersistentHeader(
                        pinned: true, delegate: IndexButton()),
                    SliverToBoxAdapter(
                      child: Container(
                        width: Get.mediaQuery.size.width,
                        height: 10,
                      ),
                    ),
                    Obx(() {
                      if (classViewController.typeIndex == 0) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return GestureDetector(
                              //* SWAPPING remove
                              /* onHorizontalDragEnd: (dragEnd) {
                                if (dragEnd.primaryVelocity < 0) {
                                  classViewController.typeIndex(1);
                                }
                              }, */
                              child: ClassViewReview(
                                classReviewModel:
                                    classViewController.classReviewList[index],
                                index: index,
                              ),
                            );
                          },
                              childCount:
                                  classViewController.classReviewList.length),
                        );
                      } else {
                        if (classViewController.classExamAvailable.value) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return GestureDetector(
                                // *SWAPPING remove
                                /* onHorizontalDragEnd: (dragEnd) {
                                  if (dragEnd.primaryVelocity > 0) {
                                    classViewController.typeIndex(0);
                                  }
                                }, */
                                child: ClassExamInfo(
                                  classExamModel:
                                      classViewController.classExamList[index],
                                  classInfoModel:
                                      classViewController.classInfo.value,
                                  index: index,
                                ),
                              );
                            },
                                childCount:
                                    classViewController.classExamList.length),
                          );
                        } else {
                          return SliverToBoxAdapter(
                              child: GestureDetector(
                            onHorizontalDragEnd: (dragEnd) {
                              if (dragEnd.primaryVelocity > 0) {
                                classViewController.typeIndex(0);
                              }
                            },
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ));
                        }
                      }
                    }),
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 50,
                    )),
                  ],
                ),
              );
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
      child: Column(
        children: [
          Container(
            height: 107,
            width: 375,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 22.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 5),
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 책 이미지
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 16.5, 15, 16),
                  child: Container(
                      width: 74.5,
                      height: 74.5,
                      child: Container(
                        margin:
                            const EdgeInsets.fromLTRB(19.5, 20.7, 19.4, 20.6),
                        child: Image.asset(
                          "assets/images/568.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: const Color(0xff1a785c))),
                ),
                // 과목명 등
                Container(
                  margin: EdgeInsets.only(top: 12.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${classInfoModel.CLASS_NAME}",
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w700,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 6),
                        child: Text(
                          "${classInfoModel.PROFESSOR}",
                          style: const TextStyle(
                              color: const Color(0xff333333),
                              fontWeight: FontWeight.normal,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 94.4,
                            height: 14.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: classInfoModel.AVG_RATE != null
                                  ? rate_star(classInfoModel.AVG_RATE, 14.6)
                                  : rate_star("5.0", 14.6),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.6),
                            child: Text(
                              classInfoModel.AVG_RATE != null
                                  ? classInfoModel.AVG_RATE
                                  : "5.0",
                              style: const TextStyle(
                                  color: const Color(0xff333333),
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "PingFangSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          // 세부 내용
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                // SECTOR
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "구분",
                          style: TextStyle(
                              color: const Color(0xff666666),
                              fontWeight: FontWeight.normal,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${classInfoModel.CLASS_SECTOR_1}",
                          style: TextStyle(
                              color: const Color(0xff333333),
                              fontWeight: FontWeight.bold,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                ),
                // Team Project
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "팀플량",
                          style: TextStyle(
                              color: const Color(0xff666666),
                              fontWeight: FontWeight.normal,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 154,
                          height: 24,
                          margin: EdgeInsets.only(right: 11),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                                classInfoModel.AVG_RATE_GROUP_STUDY != null
                                    ? rate_heart(
                                        classInfoModel.AVG_RATE_GROUP_STUDY, 24)
                                    : rate_heart("5.0", 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 과제량
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "과제량",
                          style: TextStyle(
                              color: const Color(0xff666666),
                              fontWeight: FontWeight.normal,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 154,
                          height: 24,
                          margin: EdgeInsets.only(right: 11),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: classInfoModel.AVG_RATE_ASSIGNMENT != null
                                ? rate_heart(
                                    classInfoModel.AVG_RATE_ASSIGNMENT, 24)
                                : rate_heart("5.0", 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //시험공부량
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "시험 공부량",
                          style: TextStyle(
                              color: const Color(0xff666666),
                              fontWeight: FontWeight.normal,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 154,
                          height: 24,
                          margin: EdgeInsets.only(right: 11),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: classInfoModel.AVG_RATE_EXAM_STUDY != null
                                ? rate_heart(
                                    classInfoModel.AVG_RATE_EXAM_STUDY, 24)
                                : rate_heart("5.0", 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 학점 비율
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "학점 비율",
                          style: TextStyle(
                              color: const Color(0xff666666),
                              fontWeight: FontWeight.normal,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 154,
                          height: 24,
                          margin: EdgeInsets.only(right: 11),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                                classInfoModel.AVG_RATE_GRADE_RATIO != null
                                    ? rate_heart(
                                        classInfoModel.AVG_RATE_GRADE_RATIO, 24)
                                    : rate_heart("5.0", 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 별점 & 좋아요
            Row(
              children: [
                Container(
                    width: 94.4,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: rate_star(classReviewModel.RATE, 14.6))),
                Spacer(),
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
                    icon: Icon(Icons.thumb_up, size: 20),
                    label: Text(classReviewModel.LIKES.toString()))
              ],
            ),

            // 수강 학기: 데이터 안 날라옴
            Text(
              "${semester(classReviewModel.CLASS_SEMESTER)} Semester Of ${classReviewModel.CLASS_YEAR}",
              style: TextStyle(
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.normal,
                  fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
            ),

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
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                ))
          ],
        ),
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
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0)))))
    ]);
  }
}

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
