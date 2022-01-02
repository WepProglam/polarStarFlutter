import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/class/write_comment_controller.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';
import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/modal_bottom_sheet.dart';
import 'package:polarstar_flutter/app/ui/android/class/functions/rating.dart';

// class 메인 페이지에서 사용(My Last Courses)
class CoursePreview extends StatelessWidget {
  const CoursePreview({Key key, @required this.classModel}) : super(key: key);
  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    final reviewTextController = TextEditingController();

    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 0, 13.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white
          // boxShadow: [
          //   BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 2),
          // ],
          ),
      child: Stack(
        children: [
          Ink(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Get.toNamed('/class/view/${classModel.CLASS_ID}');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 강의 이미지
                  // 사각형 493
                  Container(
                      width: 52,
                      height: 52,
                      child: Container(
                        margin:
                            const EdgeInsets.fromLTRB(13.6, 14.5, 13.6, 14.5),
                        child: Image.asset(
                          "assets/images/568.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: const Color(0xff1a4678))),
                  // 강의명, 교수명, 평가
                  Container(
                    margin: const EdgeInsets.only(left: 16.0, top: 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Introduction to alg...
                        Container(
                          width: Get.mediaQuery.size.width - 165,
                          // padding: EdgeInsets.only(right: 83),
                          child: Text("${classModel.CLASS_NAME}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: const Color(0xff333333),
                                  fontWeight: FontWeight.w700,
                                  // fontFamily: "PingFangSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                              textAlign: TextAlign.left),
                        ),

                        Container(
                            margin: const EdgeInsets.only(top: 7.0),
                            child: // Li Ming   A++
                                Text("${classModel.PROFESSOR}",
                                    style: const TextStyle(
                                        color: const Color(0xff999999),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "PingFangSC",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                    textAlign: TextAlign.left)),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),

          // 평가 버튼
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Get.toNamed('/class/view/${classModel.CLASS_ID}');

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
                                CLASS_ID: classModel.CLASS_ID);
                          })
                      .whenComplete(() => Get.delete<WriteCommentController>());
                },
                child: Container(
                  width: 61.5,
                  height: 25.5,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(26)),
                      color: const Color(0xff1a4678)),
                  child: Center(
                    child: Text("Evaluate",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w700,
                            // fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class 메인 페이지에서 사용(Recent Comments)
class CommentPreview extends StatelessWidget {
  const CommentPreview({Key key, @required this.classReviewModel})
      : super(key: key);
  final ClassRecentReviewModel classReviewModel;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print(classReviewModel);
    return Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 10.5),
                  child: // Ideological and moral
                      Text(classReviewModel.CLASS_NAME,
                          style: const TextStyle(
                              color: const Color(0xff333333),
                              fontWeight: FontWeight.w700,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.center),
                ),
                Spacer(),
                Padding(
                    padding: const EdgeInsets.only(top: 15, right: 16.3),
                    child: Row(
                      children: [
                        for (int i = 0; i < 5; i++)
                          Padding(
                            padding: const EdgeInsets.only(left: 4.6),
                            child: Container(
                              width: 14.442626953125,
                              height: 13.96044921875,
                              child: Image.asset(
                                i + 1 <= double.parse(classReviewModel.RATE)
                                    ? 'assets/images/897.png'
                                    : 'assets/images/898.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )
                      ],
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13, left: 14.5),
              child: // teacher:   Li Ming
                  Text("Professor:   ${classReviewModel.PROFESSOR}",
                      style: const TextStyle(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.w400,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 8.5, left: 14.5),
                child: Text(
                    "Semester:   ${classReviewModel.CLASS_YEAR}년 ${classReviewModel.CLASS_SEMESTER}학기",
                    style: const TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left)),
            //강평 적는 박스
            Container(
              margin: const EdgeInsets.fromLTRB(13, 12, 12.5, 15.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  color: const Color(0xfff3f3f3)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7.5, 9.5, 7.5, 8.5),
                child: SizedBox(
                  width: size.width - 28 - 27.5,
                  child: Text(classReviewModel.CONTENT,
                      style: const TextStyle(
                          color: const Color(0xff707070),
                          fontWeight: FontWeight.w400,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: const Color(0xffffffff)));
  }
}
