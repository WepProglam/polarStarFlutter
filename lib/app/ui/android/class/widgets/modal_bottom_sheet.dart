import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';

import 'package:polarstar_flutter/app/controller/class/write_comment_controller.dart';
import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/ui/android/class/functions/semester.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/timetable.dart';

class WriteComment extends StatelessWidget {
  const WriteComment(
      {Key key,
      // @required this.classViewController,
      @required this.reviewTextController,
      @required this.CLASS_ID})
      : super(key: key);

  // final ClassViewController classViewController;
  final TextEditingController reviewTextController;
  final int CLASS_ID;

  @override
  Widget build(BuildContext context) {
    WriteCommentController writeCommentController = Get.find();

    print(CLASS_ID);

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
                              writeCommentController.commentRate(i + 1);
                            },
                            child: Obx(
                              () => Container(
                                width: 27.4,
                                height: 26.5,
                                child: Image.asset(
                                  i + 1 <=
                                          writeCommentController
                                              .commentRate.value
                                      ? 'assets/images/897.png'
                                      : 'assets/images/898.png',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            )),
                      Padding(
                        padding: const EdgeInsets.only(left: 23.2),
                        child: Obx(() => Text(
                              "${writeCommentController.commentRate}/5",
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
                            writeCommentController.teamProjectRate(i + 1);
                          },
                          child: Obx(
                            () => Container(
                              margin: EdgeInsets.only(left: 8),
                              width: 21.5,
                              height: 21.5,
                              // 하트로 바꿔야 되는데 이미지가 없음
                              child: Image.asset(
                                i + 1 <=
                                        writeCommentController
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
                            writeCommentController.assignmentRate(i + 1);
                          },
                          child: Obx(
                            () => Container(
                              width: 21.5,
                              height: 21.5,
                              margin: EdgeInsets.only(left: 8),
                              // 하트로 바꿔야 되는데 이미지가 없음
                              child: Image.asset(
                                i + 1 <=
                                        writeCommentController
                                            .assignmentRate.value
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
                            writeCommentController.examRate(i + 1);
                          },
                          child: Obx(
                            () => Container(
                              width: 21.5,
                              height: 21.5,
                              margin: EdgeInsets.only(left: 8),
                              // 하트로 바꿔야 되는데 이미지가 없음
                              child: Image.asset(
                                i + 1 <= writeCommentController.examRate.value
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
                            writeCommentController.gradeRate(i + 1);
                          },
                          child: Obx(
                            () => Container(
                              width: 21.5,
                              height: 21.5,
                              margin: EdgeInsets.only(left: 8),
                              // 하트로 바꿔야 되는데 이미지가 없음
                              child: Image.asset(
                                i + 1 <= writeCommentController.gradeRate.value
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            hint: Text("Please select year"),
                            value:
                                writeCommentController.writeCommentYear.value,
                            items: [
                              for (int i = DateTime.now().year; i > 1999; i--)
                                DropdownMenuItem(
                                  child: Center(
                                    child: Text(
                                      "$i년도",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  value: i,
                                )
                            ],
                            onChanged: (value) {
                              print(value);
                              writeCommentController.writeCommentYear(value);
                              writeCommentController.writeCommentYear.refresh();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            hint: Text("Please select semester"),
                            value: writeCommentController
                                .writeCommentSemester.value,
                            items: [
                              for (int j = 1; j < 3; j++)
                                DropdownMenuItem(
                                  child: Center(
                                    child: Text(
                                      "$j학기",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  value: j,
                                )
                            ],
                            onChanged: (value) {
                              print(value);
                              writeCommentController
                                  .writeCommentSemester(value);
                              writeCommentController.writeCommentSemester
                                  .refresh();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 리뷰 작성칸
                  Container(
                      height: 94.5,
                      child: TextField(
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        expands: false,
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
                          onTap: () async {
                            print(Get.currentRoute);
                            Map<String, String> data = {
                              "content": reviewTextController.text,
                              "rate": writeCommentController.commentRate.value
                                  .toDouble()
                                  .toString(),
                              "rate_assignment": writeCommentController
                                  .assignmentRate.value
                                  .toDouble()
                                  .toString(),
                              "rate_group_study": writeCommentController
                                  .teamProjectRate.value
                                  .toDouble()
                                  .toString(),
                              "rate_exam_study": writeCommentController
                                  .examRate.value
                                  .toDouble()
                                  .toString(),
                              "rate_grade_ratio": writeCommentController
                                  .gradeRate.value
                                  .toDouble()
                                  .toString(),
                              "class_year": writeCommentController
                                  .writeCommentYear.value
                                  .toString(),
                              "class_semester": writeCommentController
                                  .writeCommentSemester.value
                                  .toString()
                            };

                            await writeCommentController.postComment(
                                CLASS_ID, data);
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
  const WriteExamInfo(
      {Key key,
      @required this.classViewController,
      @required this.examInfoTextController,
      @required this.testStrategyController})
      : super(key: key);

  final ClassViewController classViewController;
  final TextEditingController examInfoTextController;
  final TextEditingController testStrategyController;

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text("Please select year"),
                          value: classViewController.writeExamInfoYear.value,
                          items: [
                            for (int i = DateTime.now().year; i > 1999; i--)
                              DropdownMenuItem(
                                child: Center(
                                  child: Text(
                                    "$i년도",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                value: i,
                              )
                          ],
                          onChanged: (value) {
                            print(value);
                            classViewController.writeExamInfoYear(value);
                            classViewController.writeExamInfoYear.refresh();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text("Please select semester"),
                          value:
                              classViewController.writeExamInfoSemester.value,
                          items: [
                            for (int j = 1; j < 3; j++)
                              DropdownMenuItem(
                                child: Center(
                                  child: Text(
                                    "$j학기",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                value: j,
                              )
                          ],
                          onChanged: (value) {
                            print(value);
                            classViewController.writeExamInfoSemester(value);
                            classViewController.writeExamInfoSemester.refresh();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              // Exam
              Container(
                child: Column(
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
                    Container(
                      height: 29,
                      margin: EdgeInsets.only(top: 16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: classViewController.examList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: index < classViewController.examList.length
                                ? EdgeInsets.only(right: 10.0)
                                : null,
                            child: Obx(() => InkWell(
                                  onTap: () {
                                    classViewController.examIndex(index);
                                  },
                                  child: Ink(
                                    height: 29,
                                    padding:
                                        EdgeInsets.fromLTRB(14, 4.5, 14, 6),
                                    decoration: BoxDecoration(
                                        color: index ==
                                                classViewController
                                                    .examIndex.value
                                            ? Color(0xff1a4678)
                                            : Color(0xffebebeb),
                                        borderRadius:
                                            BorderRadius.circular(14.5)),
                                    child: Center(
                                        child: Text(
                                      classViewController.examList[index],
                                      style: TextStyle(
                                          color: index ==
                                                  classViewController
                                                      .examIndex.value
                                              ? Color(0xffffffff)
                                              : Color(0xff6b6b6b),
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "PingFangSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                    )),
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Questioon Type
              Container(
                margin: EdgeInsets.only(top: 16.5, bottom: 15.5),
                child: Column(
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
                    Container(
                      height: 29,
                      margin: EdgeInsets.only(top: 16.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: classViewController.questionTypeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: index <
                                    classViewController.questionTypeList.length
                                ? EdgeInsets.only(right: 10.0)
                                : null,
                            child: Obx(() => InkWell(
                                  onTap: () {
                                    classViewController
                                        .questionTypeIndex(index);
                                  },
                                  child: Ink(
                                    height: 29,
                                    padding:
                                        EdgeInsets.fromLTRB(14, 4.5, 14, 6),
                                    decoration: BoxDecoration(
                                        color: index ==
                                                classViewController
                                                    .questionTypeIndex.value
                                            ? Color(0xff1a4678)
                                            : Color(0xffebebeb),
                                        borderRadius:
                                            BorderRadius.circular(14.5)),
                                    child: Center(
                                        child: Text(
                                      classViewController
                                          .questionTypeList[index],
                                      style: TextStyle(
                                          color: index ==
                                                  classViewController
                                                      .questionTypeIndex.value
                                              ? Color(0xffffffff)
                                              : Color(0xff6b6b6b),
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "PingFangSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                    )),
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Test Strategy
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Test Strategy",
                    style: TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.bold,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 12),
                    child: TextFormField(
                      maxLines: 1,
                      controller: testStrategyController,
                      style: TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.normal,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                      decoration: InputDecoration(
                          hintText: "Please enter your test strategy",
                          filled: true,
                          fillColor: Color(0xfff3f3f3),
                          border: InputBorder.none,
                          isDense: true),
                    ),
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
                      child: TextFormField(
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
                          hintText:
                              "Please enter some examples,\nIf you enter, new text field will be created",
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
                          Map<String, dynamic> data = {
                            "type": classViewController
                                .examList[classViewController.examIndex.value],
                            "strategy": testStrategyController.text,
                            "example": [examInfoTextController.text].toString(),
                            "year": classViewController.writeExamInfoYear.value
                                .toString(),
                            "semester": classViewController
                                .writeExamInfoSemester.value
                                .toString(),
                            "mid_final":
                                examType(classViewController.examIndex.value)
                          };

                          print(data["year"] + data["semester"]);

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
