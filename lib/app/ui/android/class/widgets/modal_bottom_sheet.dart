import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';

class WriteComment extends StatelessWidget {
  const WriteComment({
    Key key,
    @required this.classViewController,
    @required this.reviewTextController,
  }) : super(key: key);

  final ClassViewController classViewController;
  final TextEditingController reviewTextController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
        child: Container(
          // height: 590,
          margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 알수없는 구분선
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
                child: Container(
                  width: 260,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 5; i++)
                        InkWell(
                            onTap: () {
                              classViewController.commentRate(i + 1);
                            },
                            child: Obx(
                              () => Container(
                                width: 27.4,
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
                        padding: const EdgeInsets.only(left: 23.2),
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
                              margin: EdgeInsets.only(left: 8),
                              width: 21.5,
                              height: 21.5,
                              // 하트로 바꿔야 되는데 이미지가 없음
                              child: Image.asset(
                                i + 1 <=
                                        classViewController
                                            .teamProjectRate.value
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
                            classViewController.assignmentRate(i + 1);
                          },
                          child: Obx(
                            () => Container(
                              width: 21.5,
                              height: 21.5,
                              margin: EdgeInsets.only(left: 8),
                              // 하트로 바꿔야 되는데 이미지가 없음
                              child: Image.asset(
                                i + 1 <=
                                        classViewController.assignmentRate.value
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
                              margin: EdgeInsets.only(left: 8),
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
                              margin: EdgeInsets.only(left: 8),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  // 학기 선택 버튼
                  Padding(
                    padding: const EdgeInsets.only(top: 16.3, bottom: 16.3),
                    child: DropdownButtonFormField(
                      hint: Text("Please select semester"),
                      value: classViewController.writeCommentSemester.value,
                      items: [
                        DropdownMenuItem(
                          child: Text("2021년도 1학기"),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text("2021년도 2학기"),
                          value: 1,
                        ),
                      ],
                      onChanged: (value) {
                        classViewController.writeCommentSemester(value);
                        classViewController.writeCommentSemester.refresh();
                      },
                    ),
                  ),

                  // 리뷰 작성칸
                  Container(
                      height: 94.5,
                      child: TextField(
                        maxLines: 6,
                        controller: reviewTextController,
                        style: TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.normal,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        decoration: const InputDecoration(
                          hintText: "Please enter the review content",
                          filled: true,
                          fillColor: Color(0xfff3f3f3),
                          border: InputBorder.none,
                        ),
                      )),

                  // 제출 버튼
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 17.5),
                      child: Ink(
                        height: 49,
                        width: 288,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff1a4678),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff965f88b7),
                                  offset: Offset(0, 6.5),
                                  blurRadius: 15)
                            ]),
                        child: InkWell(
                          onTap: () {
                            Map data = {
                              "content": reviewTextController.text,
                              "rate": classViewController.commentRate.value
                                  .toString(),
                              "rate_assignment": classViewController
                                  .assignmentRate.value
                                  .toString(),
                              "rate_group_study": classViewController
                                  .teamProjectRate.value
                                  .toString(),
                              "rate_exam_study":
                                  classViewController.examRate.value.toString(),
                              "rate_grade_ratio": classViewController
                                  .gradeRate.value
                                  .toString(),
                            };
                            classViewController.postComment(
                                classViewController.classInfo.value.CLASS_ID,
                                data);
                          },
                          child: Center(
                              child: Text(
                            "Confirm Submission",
                            style: TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.bold,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0),
                          )),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WriteExamInfo extends StatelessWidget {
  const WriteExamInfo({
    Key key,
    @required this.classViewController,
    @required this.examInfoTextController,
  }) : super(key: key);

  final ClassViewController classViewController;
  final TextEditingController examInfoTextController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
        child: Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 알수없는 구분선
              Center(
                child: Container(
                  width: 53,
                  height: 6,
                  child: Image.asset('assets/images/359.png', fit: BoxFit.fill),
                ),
              ),

              // TeachingPeriod
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.8, bottom: 14.5),
                  child: Text(
                    "Teaching Period",
                    style: TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.bold,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                ),

                // 학기 선택 버튼
                // 일단 임시로 해놓음
                Padding(
                  padding: const EdgeInsets.only(bottom: 14.5),
                  child: DropdownButtonFormField(
                    hint: Text("Please select semester"),
                    value: classViewController.writeExamInfoSemester.value,
                    items: [
                      DropdownMenuItem(
                        child: Text("2021년도 1학기"),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Text("2021년도 2학기"),
                        value: 1,
                      ),
                    ],
                    onChanged: (value) {
                      classViewController.writeCommentSemester(value);
                      classViewController.writeCommentSemester.refresh();
                    },
                  ),
                ),
              ]),

              // Exam
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Exam",
                    style: TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.bold,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),

              // Questioon Type
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Question Type",
                    style: TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.bold,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),

              // For Example
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For Example",
                    style: TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.bold,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),

                  // 텍스트 작성칸
                  Container(
                      height: 94.5,
                      margin: EdgeInsets.only(top: 13.4, bottom: 12),
                      child: TextField(
                        textInputAction: TextInputAction.go,
                        maxLines: 6,
                        controller: examInfoTextController,
                        style: TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.normal,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        decoration: const InputDecoration(
                          hintText: "Please enter example question",
                          filled: true,
                          fillColor: Color(0xfff3f3f3),
                          border: InputBorder.none,
                        ),
                      )),

                  // 제출 버튼
                  Center(
                    child: Ink(
                      height: 49,
                      width: 288,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff1a4678),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xff965f88b7),
                                offset: Offset(0, 6.5),
                                blurRadius: 15)
                          ]),
                      child: InkWell(
                        onTap: () {
                          Map data = {
                            "exaple": [examInfoTextController.text],
                          };
                          classViewController.postExam(
                              classViewController.classInfo.value.CLASS_ID,
                              data);
                        },
                        child: Center(
                            child: Text(
                          "Confirm Submission",
                          style: TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.bold,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
