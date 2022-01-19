import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';

import 'package:polarstar_flutter/app/controller/class/write_comment_controller.dart';
import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/ui/android/class/class_view.dart';
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
    final writeCommentController = Get.put(WriteCommentController(
        repository: ClassRepository(apiClient: ClassApiClient())));

    // print(CLASS_ID);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
        child: Container(
          // height: 590,
          margin: EdgeInsets.fromLTRB(24, 24, 24, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 알수없는 구분선
              // Center(
              //   child: Container(
              //     width: 53,
              //     height: 6,
              //     child: Image.asset('assets/images/359.png', fit: BoxFit.fill),
              //   ),
              // ),

              //* X 아이콘
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                        width: 15,
                        height: 15,
                        child: Image.asset('assets/images/174.png',
                            fit: BoxFit.fill)),
                  )
                ],
              ),

              //* 뭔진 모르겠지만 写入教学评价
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                child: Text("写入教学评价",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: const Color(0xff6f6e6e),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0),
                    textAlign: TextAlign.left),
              ),

              // 전체 별점
              Container(
                width: 156.0,
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
                              width: 20.0,
                              height: 20.0,
                              child: Image.asset(
                                i + 1 <=
                                        writeCommentController.commentRate.value
                                    ? 'assets/images/star_100.png'
                                    : 'assets/images/star_0.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Obx(() => Text(
                          "(${writeCommentController.commentRate}.0)",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: const Color(0xff9b9b9b),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left)),
                    )
                  ],
                ),
              ),

              // 구분선
              Container(
                margin: EdgeInsets.only(top: 23.5, bottom: 13.5),
                height: 1,
                decoration: BoxDecoration(color: const Color(0xffeaeaea)),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text("成绩反映",
                    style: const TextStyle(
                        color: const Color(0xff6f6e6e),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
              ),

              //* 말하기 속도, 억양, 사투리
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Text("教授语速、方言等",
                        style: const TextStyle(
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text("中间儿",
                          style: const TextStyle(
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.right),
                    ),
                    for (int i = 0; i < 5; i++)
                      Container(
                          margin: EdgeInsets.only(left: 4.0),
                          width: 20.0,
                          height: 20.0,
                          child: InkWell(
                            onTap: () {
                              writeCommentController.languageRate(i + 1);
                            },
                            child: Obx(
                              () => Image.asset(
                                i + 1 <=
                                        writeCommentController
                                            .languageRate.value
                                    ? 'assets/images/star_100.png'
                                    : 'assets/images/star_0.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )),
                  ],
                ),
              ),
              //* 외국인을 대하는 태도
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Text("教授对留学生的态度",
                        style: const TextStyle(
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text("中间儿",
                          style: const TextStyle(
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.right),
                    ),
                    for (int i = 0; i < 5; i++)
                      Container(
                          margin: EdgeInsets.only(left: 4.0),
                          width: 20.0,
                          height: 20.0,
                          child: InkWell(
                            onTap: () {
                              writeCommentController.attitudeRate(i + 1);
                            },
                            child: Obx(
                              () => Image.asset(
                                i + 1 <=
                                        writeCommentController
                                            .attitudeRate.value
                                    ? 'assets/images/star_100.png'
                                    : 'assets/images/star_0.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )),
                  ],
                ),
              ),
              //* 시험 난이도
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Text("考试难度",
                        style: const TextStyle(
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text("中间儿",
                          style: const TextStyle(
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.right),
                    ),
                    for (int i = 0; i < 5; i++)
                      Container(
                          margin: EdgeInsets.only(left: 4.0),
                          width: 20.0,
                          height: 20.0,
                          child: InkWell(
                            onTap: () {
                              writeCommentController.examRate(i + 1);
                            },
                            child: Obx(
                              () => Image.asset(
                                i + 1 <= writeCommentController.examRate.value
                                    ? 'assets/images/star_100.png'
                                    : 'assets/images/star_0.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )),
                  ],
                ),
              ),

              //* 과제량
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Text("作业量",
                        style: const TextStyle(
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text("中间儿",
                          style: const TextStyle(
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.right),
                    ),
                    for (int i = 0; i < 5; i++)
                      Container(
                          margin: EdgeInsets.only(left: 4.0),
                          width: 20.0,
                          height: 20.0,
                          child: InkWell(
                            onTap: () {
                              writeCommentController.assignmentRate(i + 1);
                            },
                            child: Obx(
                              () => Image.asset(
                                i + 1 <=
                                        writeCommentController
                                            .assignmentRate.value
                                    ? 'assets/images/star_100.png'
                                    : 'assets/images/star_0.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )),
                  ],
                ),
              ),
              //* 학점비율
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Text("给分",
                        style: const TextStyle(
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text("中间儿",
                          style: const TextStyle(
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.right),
                    ),
                    for (int i = 0; i < 5; i++)
                      Container(
                          margin: EdgeInsets.only(left: 4.0),
                          width: 20.0,
                          height: 20.0,
                          child: InkWell(
                            onTap: () {
                              writeCommentController.gradeRate(i + 1);
                            },
                            child: Obx(
                              () => Image.asset(
                                i + 1 <= writeCommentController.gradeRate.value
                                    ? 'assets/images/star_100.png'
                                    : 'assets/images/star_0.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )),
                  ],
                ),
              ),
              //* 구분선
              Container(
                margin: EdgeInsets.only(top: 3.5, bottom: 13.5),
                height: 1.0,
                decoration: BoxDecoration(color: const Color(0xffeaeaea)),
              ),

              //* General Comment
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("一般评论",
                      style: const TextStyle(
                          color: const Color(0xff6f6e6e),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),

                  //* 학기 선택 버튼
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 23.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: const Color(0xffeaeaea),
                                      width: 1.0)),
                            ),
                            isExpanded: false,
                            hint: Text("请输入说明.",
                                style: const TextStyle(
                                    color: const Color(0xff9b9b9b),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                            items: writeCommentController.yearSemItem,
                            value: writeCommentController.writeCommentIndex,
                            onChanged: (value) {
                              writeCommentController.writeCommentIndex = value;
                              if (writeCommentController.currentYearSem[
                                      "TIMETABLE_SEMESTER_FROM_DATE"] ==
                                  1) {
                                writeCommentController.writeCommentYear =
                                    writeCommentController.currentYearSem[
                                            "TIMETABLE_YEAR_FROM_DATE"] -
                                        writeCommentController
                                            .writeCommentIndex;
                                writeCommentController.writeCommentSemester =
                                    writeCommentController.writeCommentIndex %
                                            2 +
                                        1;
                              } else {
                                writeCommentController.writeCommentYear =
                                    writeCommentController.currentYearSem[
                                            "TIMETABLE_YEAR_FROM_DATE"] -
                                        writeCommentController
                                            .writeCommentIndex;
                                writeCommentController.writeCommentSemester =
                                    (writeCommentController.writeCommentIndex +
                                                1) %
                                            2 +
                                        1;
                              }

                              print(writeCommentController.writeCommentYear);
                              print(
                                  writeCommentController.writeCommentSemester);
                            },
                            icon: Image.asset(
                                'assets/images/drop_down_arrow.png',
                                fit: BoxFit.fill),
                          ),
                        ),

                        //* 학기 선택 드롭다운
                        // Expanded(
                        //   child: DropdownButtonFormField(
                        //     isExpanded: true,
                        //     hint: Text("请输入说明.",
                        //         style: const TextStyle(
                        //             color: const Color(0xff9b9b9b),
                        //             fontWeight: FontWeight.w400,
                        //             fontFamily: "NotoSansSC",
                        //             fontStyle: FontStyle.normal,
                        //             fontSize: 14.0),
                        //         textAlign: TextAlign.left),
                        //     value: writeCommentController.writeCommentSemester,
                        //     items: [
                        //       for (int j = 1; j < 3; j++)
                        //         DropdownMenuItem(
                        //           child: Center(
                        //             child: Text(
                        //               "$j학기",
                        //               style: const TextStyle(
                        //                   color: const Color(0xff6f6e6e),
                        //                   fontWeight: FontWeight.w400,
                        //                   fontFamily: "NotoSansSC",
                        //                   fontStyle: FontStyle.normal,
                        //                   fontSize: 14.0),
                        //               textAlign: TextAlign.left,
                        //             ),
                        //           ),
                        //           value: j,
                        //         )
                        //     ],
                        //     onChanged: (value) {
                        //       print(value);
                        //       writeCommentController.writeCommentSemester =
                        //           value;
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  // 리뷰 작성칸
                  Container(
                      height: 120.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
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
                            fontSize: 12.0),
                        decoration: const InputDecoration(
                          hintText: "请输入说明.",
                          hintStyle: const TextStyle(
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          filled: true,
                          fillColor: Color(0xffffffff),
                          border: InputBorder.none,
                          // enabledBorder: OutlineInputBorder(
                          //     borderSide: const BorderSide(
                          //         color: const Color(0xffeaeaea)),
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(7))),
                        ),
                      )),

                  // 제출 버튼
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Ink(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(mainColor),
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Color(0xff965f88b7),
                          //       offset: Offset(0, 6.5),
                          //       blurRadius: 15)
                          // ]
                        ),
                        child: InkWell(
                          onTap: () async {
                            print(Get.currentRoute);
                            Map<String, String> data = {
                              "content": reviewTextController.text,
                              "RATE": writeCommentController.commentRate.value
                                  .toDouble()
                                  .toString(),
                              "RATE_LANGUAGE": writeCommentController
                                  .languageRate.value
                                  .toDouble()
                                  .toString(),
                              "RATE_ATTITUDE": writeCommentController
                                  .attitudeRate.value
                                  .toDouble()
                                  .toString(),
                              "RATE_EXAM_DIFFICULTY": writeCommentController
                                  .examRate.value
                                  .toDouble()
                                  .toString(),
                              "RATE_ASSIGNMENT": writeCommentController
                                  .assignmentRate.value
                                  .toDouble()
                                  .toString(),
                              "RAGE_GRADE": writeCommentController
                                  .gradeRate.value
                                  .toDouble()
                                  .toString(),
                              "class_year": writeCommentController
                                  .writeCommentYear
                                  .toString(),
                              "class_semester": writeCommentController
                                  .writeCommentSemester
                                  .toString()
                            };

                            await writeCommentController.postComment(
                                CLASS_ID, data);
                          },
                          child: Center(
                              child: Text("写考试攻略",
                                  style: const TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.left)),
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

                  Obx(() {
                    if (classViewController.exampleList.isEmpty) {
                      return Container();
                    } else {
                      List<Widget> exampleWidget = [];
                      for (var exampleStr in classViewController.exampleList) {
                        exampleWidget.add(Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                          )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  exampleStr,
                                  softWrap: true,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  classViewController.exampleList
                                      .remove(exampleStr);
                                },
                                child: Icon(Icons.delete),
                              )
                            ],
                          ),
                        ));
                      }
                      return Container(
                          width: Get.mediaQuery.size.width,
                          child: Column(children: exampleWidget));
                    }
                  }),

                  //* 텍스트 작성칸
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
                              "Please enter some examples.\n\nIf you enter in the keyboard,\nnew text field will be created",
                          filled: true,
                          fillColor: Color(0xfff3f3f3),
                          border: InputBorder.none,
                        ),
                        onEditingComplete: () {
                          classViewController.exampleList
                              .add(examInfoTextController.text);
                          examInfoTextController.clear();
                          // print(classViewController.exampleList);
                        },
                      )),

                  //* 제출 버튼
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
                            "example":
                                classViewController.exampleList.toString(),
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
