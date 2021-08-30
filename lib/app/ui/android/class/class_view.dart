import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';
import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/ui/android/class/widgets/class_preview.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/class_search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';

class ClassView extends StatelessWidget {
  const ClassView({Key key}) : super(key: key);

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
            } else {}
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
          // class preview 재사용
          Container(
            margin: EdgeInsets.all(10.0),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.book,
                        size: 60,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classInfoModel.CLASS_NAME,
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(classInfoModel.PROFESSOR),
                        ),
                        Row(
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
                              Icons.star_border,
                              color: Colors.yellow[800],
                            ),
                            Icon(
                              Icons.star_border,
                              color: Colors.yellow[800],
                            ),
                            Text(classInfoModel.CREDIT),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // 세부 내용
          // Subject
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Subject"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      classInfoModel.SECTOR,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Team Project: 서버에서 데이터가 안날라와서 No로 설정
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Team Project"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "No",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Credit Ratio: 이것도 데이터가 안날라옴
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Credit Ratio"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      classInfoModel.CREDIT,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Attendance: 이것도 마찬가지
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Attendance"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "99%",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Number Of Exams: 이것도
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Number of Exams"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "General",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
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
