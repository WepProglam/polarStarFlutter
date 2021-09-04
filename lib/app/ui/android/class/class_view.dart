import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';
import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/ui/android/class/functions/rating.dart';

import 'package:polarstar_flutter/app/ui/android/class/widgets/class_preview.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/class_search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';

class ClassView extends StatelessWidget {
  const ClassView({Key key}) : super(key: key);

  Widget writeEvaluation(BuildContext context) {
    final ClassViewController classViewController = Get.find();

    return Container(
      height: 673,
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 53,
              height: 6,
              child: Image.asset('assets/images/359.png', fit: BoxFit.fill),
            ),
          ),

          // 전체 별점
          Padding(
            padding: const EdgeInsets.only(top: 25.1),
            child: Row(
              children: [
                for (int i = 0; i < 5; i++)
                  InkWell(
                      onTap: () {
                        classViewController.commentRate(i + 1);
                      },
                      child: Obx(
                        () => Container(
                          width: 26.5,
                          height: 26.5,
                          child: Image.asset(
                            i + 1 <= classViewController.commentRate.value
                                ? 'assets/images/897.png'
                                : 'assets/images/898.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      )),
                Padding(
                  padding: const EdgeInsets.only(left: 37.3),
                  child: Obx(() => Text(
                        "${classViewController.commentRate}/5",
                        style: TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.bold,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 21.0),
                      )),
                )
              ],
            ),
          ),

          // 구분선
          Container(
            margin: EdgeInsets.only(top: 21.6, bottom: 23.9),
            height: 0.5,
            decoration: BoxDecoration(color: Colors.grey),
          ),

          // 세부 별점들 실제론 하트여야할 듯
          Container(
            margin: EdgeInsets.only(bottom: 17.5),
            child: Row(
              children: [
                Text(
                  "팀플량",
                  style: TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.bold,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                ),
                Spacer(),
                for (int i = 0; i < 5; i++)
                  InkWell(
                      onTap: () {
                        classViewController.teamProjectRate(i + 1);
                      },
                      child: Obx(
                        () => Container(
                          width: 21.5,
                          height: 21.5,
                          // 하트로 바꿔야 되는데 이미지가 없음
                          child: Image.asset(
                            i + 1 <= classViewController.teamProjectRate.value
                                ? 'assets/images/897.png'
                                : 'assets/images/898.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      )),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Text(
                  "과제량",
                  style: TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.bold,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                ),
                Spacer(),
                for (int i = 0; i < 5; i++)
                  InkWell(
                      onTap: () {
                        classViewController.homeworkRate(i + 1);
                      },
                      child: Obx(
                        () => Container(
                          width: 21.5,
                          height: 21.5,
                          // 하트로 바꿔야 되는데 이미지가 없음
                          child: Image.asset(
                            i + 1 <= classViewController.homeworkRate.value
                                ? 'assets/images/897.png'
                                : 'assets/images/898.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      )),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 17.5),
            child: Row(
              children: [
                Text(
                  "시험 공부량",
                  style: TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.bold,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                ),
                Spacer(),
                for (int i = 0; i < 5; i++)
                  InkWell(
                      onTap: () {
                        classViewController.examRate(i + 1);
                      },
                      child: Obx(
                        () => Container(
                          width: 21.5,
                          height: 21.5,
                          // 하트로 바꿔야 되는데 이미지가 없음
                          child: Image.asset(
                            i + 1 <= classViewController.examRate.value
                                ? 'assets/images/897.png'
                                : 'assets/images/898.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      )),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Text(
                  "학점 비율",
                  style: TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.bold,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                ),
                Spacer(),
                for (int i = 0; i < 5; i++)
                  InkWell(
                      onTap: () {
                        classViewController.gradeRate(i + 1);
                      },
                      child: Obx(
                        () => Container(
                          width: 21.5,
                          height: 21.5,
                          // 하트로 바꿔야 되는데 이미지가 없음
                          child: Image.asset(
                            i + 1 <= classViewController.gradeRate.value
                                ? 'assets/images/897.png'
                                : 'assets/images/898.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      )),
              ],
            ),
          ),
          // 구분선
          Container(
            margin: EdgeInsets.only(top: 33.1, bottom: 13.8),
            height: 0.5,
            decoration: BoxDecoration(color: Colors.grey),
          ),

          // General Comment
          Column(
            children: [
              Text(
                "General Comment",
                style: TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.bold,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
                textAlign: TextAlign.left,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget writeExamInfo(BuildContext context) {
    return Container(
      height: 673,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 14.5),
            width: 53,
            height: 6,
            child: Image.asset('assets/images/359.png', fit: BoxFit.fill),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ClassViewController classViewController = Get.find();

    return Scaffold(
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
                  context: context,
                  builder: writeEvaluation);
            } else {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(30),
                          topRight: const Radius.circular(30))),
                  context: context,
                  builder: writeExamInfo);
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
                            color: Colors.white, fontWeight: FontWeight.normal),
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
                  SliverPersistentHeader(pinned: true, delegate: IndexButton()),
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
                          return ClassViewReview(
                            classReviewModel:
                                classViewController.classReviewList[index],
                            index: index,
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
                            return ClassExamInfo(
                              classExamModel:
                                  classViewController.classExamList[index],
                              index: index,
                            );
                          },
                              childCount:
                                  classViewController.classExamList.length),
                        );
                      } else {
                        return SliverToBoxAdapter(
                            child: Center(
                          child: CircularProgressIndicator(),
                        ));
                      }
                    }
                  }),
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
                        classInfoModel.CLASS_NAME,
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
                          classInfoModel.PROFESSOR,
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
                              children:
                                  rate_star(classInfoModel.AVG_RATE, 14.6),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.6),
                            child: Text(
                              classInfoModel.AVG_RATE,
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
                          classInfoModel.SECTOR,
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
                            children: rate_heart(
                                classInfoModel.AVG_RATE_GROUP_STUDY, 24),
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
                            children: rate_heart(
                                classInfoModel.AVG_RATE_ASSIGNMENT, 24),
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
                            children: rate_heart(
                                classInfoModel.AVG_RATE_EXAM_STUDY, 24),
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
                            children: rate_heart(
                                classInfoModel.AVG_RATE_GRADE_RATIO, 24),
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
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 별점 & 좋아요
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                ),
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
          ),

          // 수강 학기: 데이터 안 날라옴
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
            child: Text(
              "First Semester Of 2021",
              textScaleFactor: 1.1,
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    classReviewModel.CONTENT,
                    maxLines: 2,
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class ClassExamInfo extends StatelessWidget {
  const ClassExamInfo({Key key, @required this.classExamModel, this.index})
      : super(key: key);
  final ClassExamModel classExamModel;
  final int index;

  // String semester로 변환 함수
  String semester(int intSemester) {
    String retString = "First";
    switch (intSemester) {
      case 1:
        retString = "First";
        break;
      case 2:
        retString = "Second";
        break;
      default:
        retString = "First";
    }
    return retString;
  }

  @override
  Widget build(BuildContext context) {
    final ClassViewController classViewController = Get.find();

    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이것도 데이터 없음
            Row(
              children: [
                Text(
                  "The Final Exam",
                  textScaleFactor: 1.4,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                TextButton.icon(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.red),
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(semester(classExamModel.CLASS_EXAM_SEMESTER) +
                  " Semester Of " +
                  classExamModel.CLASS_EXAM_YEAR.toString()),
            ),
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
                    child: Text(classExamModel.TEST_STRATEGY),
                  )
                ],
              ),
            ),
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
                    child: Text(classExamModel.TEST_TYPE),
                  )
                ],
              ),
            ),
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
                      child: ListView.builder(
                          itemCount: classExamModel.TEST_EXAMPLE.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(classExamModel.TEST_EXAMPLE[index]),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
              GestureDetector(
                onTap: () {
                  classViewController.typeIndex(0);
                },
                child: Obx(
                  () => Text(
                    "Comment",
                    textScaleFactor: 1.2,
                    style: TextStyle(
                        color: classViewController.typeIndex.value == 0
                            ? Colors.blue[900]
                            : Colors.black,
                        fontWeight: classViewController.typeIndex.value == 0
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  classViewController.typeIndex(1);
                  if (!classViewController.classExamAvailable.value) {
                    print("exam data fetch");
                    classViewController
                        .getExamInfo(int.parse(Get.parameters["classid"]));
                  }
                },
                child: Obx(
                  () => Text(
                    "Exam Information",
                    textScaleFactor: 1.2,
                    style: TextStyle(
                        color: classViewController.typeIndex.value == 1
                            ? Colors.blue[900]
                            : Colors.black,
                        fontWeight: classViewController.typeIndex.value == 1
                            ? FontWeight.bold
                            : FontWeight.normal),
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
