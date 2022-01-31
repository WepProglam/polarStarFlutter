import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';
import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/ui/android/functions/form_validator.dart';

import 'package:polarstar_flutter/app/controller/class/write_comment_controller.dart';
import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/ui/android/class/class_view.dart';
import 'package:polarstar_flutter/app/ui/android/class/functions/semester.dart';
import 'package:polarstar_flutter/app/ui/android/functions/timetable_semester.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/timetable.dart';

class WriteComment extends StatelessWidget {
  const WriteComment(
      {Key key,
      @required this.classInfoModel,
      // @required this.classViewController,
      @required this.reviewTextController,
      @required this.CLASS_ID})
      : super(key: key);

  // final ClassViewController classViewController;
  final TextEditingController reviewTextController;
  final int CLASS_ID;
  final ClassInfoModel classInfoModel;

  @override
  Widget build(BuildContext context) {
    final writeCommentController = Get.put(WriteCommentController(
        repository: ClassRepository(apiClient: ClassApiClient())));

    // print(CLASS_ID);

    return SingleChildScrollView(
      controller: writeCommentController.writeCommentScrollController,
      child: Padding(
        padding: EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
        child: Container(
          // height: 590,
          margin: EdgeInsets.fromLTRB(24, 24, 24, 24),
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

              // * 강의명
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                child: Text("${classInfoModel.CLASS_NAME}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
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
                          writeCommentController.commentRate.value == 0
                              ? ""
                              : "(${writeCommentController.commentRate.value}.0)",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
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
                margin: EdgeInsets.only(top: 13.5, bottom: 13.5),
                height: 1,
                decoration: BoxDecoration(color: const Color(0xffeaeaea)),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text("课程评分",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
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
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Obx(() => Text(
                          writeCommentController.languageRate.value == 0
                              ? ""
                              : writeCommentController.languageExplain[
                                  writeCommentController.languageRate.value -
                                      1],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.right)),
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
                      child: Obx(() => Text(
                          writeCommentController.attitudeRate.value == 0
                              ? ""
                              : writeCommentController.attitudeExplain[
                                  writeCommentController.attitudeRate.value -
                                      1],
                          style: const TextStyle(
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.right)),
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
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Obx(() => Text(
                          writeCommentController.examRate.value == 0
                              ? ""
                              : writeCommentController.examExplain[
                                  writeCommentController.examRate.value - 1],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.right)),
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
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Obx(() => Text(
                          writeCommentController.assignmentRate.value == 0
                              ? ""
                              : writeCommentController.assignmentExplain[
                                  writeCommentController.assignmentRate.value -
                                      1],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.right)),
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
                margin: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Text("给分",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Obx(() => Text(
                          writeCommentController.gradeRate.value == 0
                              ? ""
                              : writeCommentController.gradeExplain[
                                  writeCommentController.gradeRate.value - 1],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.right)),
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
                  Text("课程评价",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: const Color(0xff6f6e6e),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),

                  //* 학기 선택 버튼
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 13.5),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: const Color(0xffeaeaea), width: 1.0)),
                      ),
                      isExpanded: false,
                      hint: Text("请选择听课学期",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
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
                          writeCommentController
                              .writeCommentYear = writeCommentController
                                  .currentYearSem["TIMETABLE_YEAR_FROM_DATE"] -
                              writeCommentController.writeCommentIndex;
                          writeCommentController.writeCommentSemester =
                              flutterToServerSemChanger(
                                  writeCommentController.writeCommentIndex % 2 +
                                      1);
                        } else {
                          writeCommentController
                              .writeCommentYear = writeCommentController
                                  .currentYearSem["TIMETABLE_YEAR_FROM_DATE"] -
                              writeCommentController.writeCommentIndex;
                          writeCommentController.writeCommentSemester =
                              flutterToServerSemChanger(
                                  (writeCommentController.writeCommentIndex +
                                              1) %
                                          2 +
                                      1);
                        }

                        print(writeCommentController.writeCommentYear);
                        print(writeCommentController.writeCommentSemester);
                      },
                      icon: Image.asset('assets/images/drop_down_arrow.png',
                          fit: BoxFit.fill),
                    ),
                  ),

                  //* 리뷰 작성칸
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
                        onTap: () async {
                          await Future.delayed(Duration(milliseconds: 100));
                          writeCommentController.writeCommentScrollController
                              .animateTo(
                                  writeCommentController
                                      .writeCommentScrollController
                                      .position
                                      .maxScrollExtent,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.fastOutSlowIn);
                        },
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        expands: false,
                        controller: reviewTextController,
                        style: TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.normal,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        decoration: const InputDecoration(
                          hintText: "请输入你对这门课的评价",
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

                  //* 제출 버튼
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
                            if (writeCommentController.writeCommentYear ==
                                    null ||
                                reviewTextController.text.isEmpty) {
                              return;
                            }
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
                              "RATE_GRADE": writeCommentController
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

                            print(writeCommentController.gradeRate.value
                                .toDouble()
                                .toString());

                            await writeCommentController.postComment(
                                CLASS_ID, data, reviewTextController);
                          },
                          child: Center(
                              child: Text("写考试攻略",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
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
  WriteExamInfo(
      {Key key,
      @required this.classViewController,
      @required this.examInfoTextController,
      @required this.testStrategyController})
      : super(key: key);

  final ClassViewController classViewController;
  final TextEditingController examInfoTextController;
  final TextEditingController testStrategyController;
  final GlobalKey<FormState> _exampleFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _tipsFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: classViewController.writeExamInfoScrollController,
      child: Padding(
        padding: EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
        child: Container(
          margin: EdgeInsets.fromLTRB(24, 24, 24, 24),
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

              //* 시험정보 텍스트
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text("${classViewController.classInfo.value.CLASS_NAME}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: const Color(0xff6f6e6e),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansKR",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0),
                    textAlign: TextAlign.left),
              ),

              //* 구분선
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 13.5),
                  height: 1,
                  decoration: BoxDecoration(color: const Color(0xffeaeaea))),

              //* 시험 학기 선택
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("听课学期",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: const Color(0xff6f6e6e),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),

                //* 학기 선택 버튼
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 13.5),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: const Color(0xffeaeaea), width: 1.0)),
                    ),
                    isExpanded: false,
                    hint: Text("请选择听课学期",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    items: classViewController.yearSemItem,
                    value: classViewController.writeCommentIndex,
                    onChanged: (value) {
                      classViewController.writeCommentIndex = value;
                      if (classViewController
                              .currentYearSem["TIMETABLE_SEMESTER_FROM_DATE"] ==
                          1) {
                        classViewController
                            .writeExamInfoYear = classViewController
                                .currentYearSem["TIMETABLE_YEAR_FROM_DATE"] -
                            classViewController.writeCommentIndex;
                        classViewController.writeExamInfoSemester =
                            flutterToServerSemChanger(
                                classViewController.writeCommentIndex % 2 + 1);
                      } else {
                        classViewController
                            .writeExamInfoYear = classViewController
                                .currentYearSem["TIMETABLE_YEAR_FROM_DATE"] -
                            classViewController.writeCommentIndex;
                        classViewController.writeExamInfoSemester =
                            flutterToServerSemChanger(
                                (classViewController.writeCommentIndex + 1) %
                                        2 +
                                    1);
                      }

                      print(classViewController.writeExamInfoYear);
                      print(classViewController.writeExamInfoSemester);
                    },
                    icon: Image.asset('assets/images/drop_down_arrow.png',
                        fit: BoxFit.fill),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 14.5),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: DropdownButtonFormField(
                //           isExpanded: true,
                //           hint: Text("Please select year"),
                //           value: classViewController.writeExamInfoYear.value,
                //           items: [
                //             for (int i = DateTime.now().year; i > 1999; i--)
                //               DropdownMenuItem(
                //                 child: Center(
                //                   child: Text(
                //                     "$i년도",
                //                     textAlign: TextAlign.center,
                //                   ),
                //                 ),
                //                 value: i,
                //               )
                //           ],
                //           onChanged: (value) {
                //             print(value);
                //             classViewController.writeExamInfoYear(value);
                //             classViewController.writeExamInfoYear.refresh();
                //           },
                //         ),
                //       ),
                //       SizedBox(
                //         width: 20,
                //       ),
                //       Expanded(
                //         child: DropdownButtonFormField(
                //           isExpanded: true,
                //           hint: Text("Please select semester"),
                //           value:
                //               classViewController.writeExamInfoSemester.value,
                //           items: [
                //             for (int j = 1; j < 3; j++)
                //               DropdownMenuItem(
                //                 child: Center(
                //                   child: Text(
                //                     "$j학기",
                //                     textAlign: TextAlign.center,
                //                   ),
                //                 ),
                //                 value: j,
                //               )
                //           ],
                //           onChanged: (value) {
                //             print(value);
                //             classViewController.writeExamInfoSemester(value);
                //             classViewController.writeExamInfoSemester.refresh();
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ]),

              //* Exam
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("门类",
                    //     style: const TextStyle(
                    //         color: const Color(0xff9b9b9b),
                    //         fontWeight: FontWeight.w400,
                    //         fontFamily: "NotoSansSC",
                    //         fontStyle: FontStyle.normal,
                    //         fontSize: 14.0),
                    //     textAlign: TextAlign.left),
                    Container(
                      height: 28.0,
                      margin: const EdgeInsets.only(top: 10.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: classViewController.examList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: index < classViewController.examList.length
                                ? EdgeInsets.only(right: 8.0)
                                : null,
                            child: Obx(() => InkWell(
                                  onTap: () {
                                    classViewController.examIndex(index);
                                  },
                                  child: Ink(
                                    height: 28.0,
                                    padding: EdgeInsets.fromLTRB(
                                        12.0, 5.0, 12.0, 6.0),
                                    decoration: BoxDecoration(
                                        color: index ==
                                                classViewController
                                                    .examIndex.value
                                            ? const Color(0xff91bbff)
                                            : const Color(0xffeaeaea),
                                        borderRadius:
                                            BorderRadius.circular(14.0)),
                                    child: Center(
                                        child: Text(
                                            classViewController.examList[index],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: index ==
                                                        classViewController
                                                            .examIndex.value
                                                    ? const Color(0xffffffff)
                                                    : const Color(0xff9b9b9b),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "NotoSansSC",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.center)),
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //* 시험 유형
              Container(
                margin: EdgeInsets.only(top: 14.0, bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("考试类型",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      height: 28.0,
                      margin: EdgeInsets.only(top: 10.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: classViewController.questionTypeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: index <
                                    classViewController.questionTypeList.length
                                ? EdgeInsets.only(right: 8.0)
                                : null,
                            child: Obx(() => InkWell(
                                  onTap: () {
                                    classViewController
                                        .questionTypeIndex(index);
                                  },
                                  child: Ink(
                                    height: 28.0,
                                    padding: EdgeInsets.fromLTRB(
                                        12.0, 5.0, 12.0, 5.0),
                                    decoration: BoxDecoration(
                                        color: index ==
                                                classViewController
                                                    .questionTypeIndex.value
                                            ? const Color(0xff91bbff)
                                            : const Color(0xffeaeaea),
                                        borderRadius:
                                            BorderRadius.circular(14.0)),
                                    child: Center(
                                        child: Text(
                                            classViewController
                                                .questionTypeList[index],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: index ==
                                                        classViewController
                                                            .questionTypeIndex
                                                            .value
                                                    ? const Color(0xffffffff)
                                                    : const Color(0xff9b9b9b),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "NotoSansSC",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.center)),
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //* 시험 전략
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("考试攻略",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: const Color(0xff9b9b9b),
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 14.0),
                    // height: 46.0,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.all(Radius.circular(7)),
                      // border:
                      //     Border.all(color: const Color(0xffeaeaea), width: 1),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x0f000000),
                            offset: Offset(0, 3),
                            blurRadius: 10,
                            spreadRadius: 0)
                      ],
                      color: const Color(0xffffffff),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        return checkEmpty(value);
                      },
                      onTap: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        classViewController.writeExamInfoScrollController
                            .animateTo(
                                classViewController
                                    .writeExamInfoScrollController
                                    .position
                                    .maxScrollExtent,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.fastOutSlowIn);
                      },
                      maxLines: 1,
                      controller: testStrategyController,
                      cursorColor: const Color(0xff91bbff),
                      style: const TextStyle(
                          color: const Color(0xff9b9b9b),
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0),
                      decoration: InputDecoration(
                          hintText: "请输入考试攻略",
                          hintStyle: const TextStyle(
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide(
                                color: const Color(0xffeaeaea), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide(
                                color: const Color(0xffeaeaea), width: 1),
                          ),
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          border: InputBorder.none,
                          isDense: true),
                    ),
                  ),
                ],
              ),

              //* 시험 문제 예시
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("考试真题",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: const Color(0xff9b9b9b),
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),

                  Obx(() {
                    List<Widget> exampleWidget = [];
                    for (var exampleStr in classViewController.exampleList) {
                      exampleWidget.add(Container(
                        margin: EdgeInsets.only(top: 8.0),
                        height: 39.0,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 10.0, 12.0, 12.0),
                                child: Text(
                                  exampleStr,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: const Color(0xff9b9b9b),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ),
                            ),
                            Ink(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: InkWell(
                                onTap: () {
                                  classViewController.exampleList
                                      .remove(exampleStr);
                                },
                                child: Image.asset("assets/images/186.png"),
                              ),
                            )
                          ],
                        ),
                      ));
                    }
                    return Container(
                        width: Get.mediaQuery.size.width,
                        child: Column(children: exampleWidget));
                  }),

                  //* 텍스트 작성칸
                  Container(
                      margin: EdgeInsets.only(top: 8.0, bottom: 20.0),
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.all(Radius.circular(7)),
                          // border: Border.all(
                          //     color: const Color(0xffeaeaea), width: 1),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x0f000000),
                                offset: Offset(0, 3),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ], color: const Color(0xffffffff)),
                      child: TextFormField(
                        // key: _exampleFormKey,
                        validator: (value) {
                          return checkEmpty(value);
                        },
                        onTap: () async {
                          await Future.delayed(Duration(milliseconds: 500));
                          classViewController.writeExamInfoScrollController
                              .animateTo(
                                  classViewController
                                      .writeExamInfoScrollController
                                      .position
                                      .maxScrollExtent,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                        },
                        textInputAction: TextInputAction.go,
                        maxLines: 1,
                        controller: examInfoTextController,
                        style: const TextStyle(
                            color: const Color(0xff9b9b9b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        decoration: const InputDecoration(
                            hintText: "请输入真题内容",
                            hintStyle: const TextStyle(
                                color: const Color(0xffd6d4d4),
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            filled: true,
                            fillColor: const Color(0xffffffff),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide(
                                  color: const Color(0xffeaeaea), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide(
                                  color: const Color(0xffeaeaea), width: 1),
                            ),
                            border: InputBorder.none,
                            isDense: true),
                        onEditingComplete: () async {
                          if (examInfoTextController.text.isEmpty) {
                            return;
                          }
                          classViewController.exampleList
                              .add(examInfoTextController.text);

                          examInfoTextController.text = "";
                          examInfoTextController.clear();
                          // print(classViewController.exampleList);

                          await Future.delayed(Duration(milliseconds: 500));
                          classViewController.writeExamInfoScrollController
                              .animateTo(
                                  classViewController
                                      .writeExamInfoScrollController
                                      .position
                                      .maxScrollExtent,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                        },
                      )),

                  //* 제출 버튼
                  Center(
                    child: Ink(
                      height: 48.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x33000000),
                                offset: Offset(0, 3),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                          color: const Color(0xff4570ff)),
                      child: InkWell(
                        onTap: () {
                          if (classViewController.writeExamInfoYear == null ||
                              classViewController.exampleList.isEmpty ||
                              testStrategyController.text.isEmpty) {
                            return;
                          }
                          var str = "";
                          classViewController.exampleList.forEach((element) {
                            str += element;
                            str += "\n\n";
                          });
                          str = str.substring(0, str.length - 2);

                          Map<String, dynamic> data = {
                            "type": classViewController
                                .examList[classViewController.examIndex.value],
                            "strategy": testStrategyController.text,
                            "example": str,
                            "year": classViewController.writeExamInfoYear
                                .toString(),
                            "semester": classViewController
                                .writeExamInfoSemester
                                .toString(),
                            "mid_final":
                                examType(classViewController.examIndex.value)
                          };

                          print(data["year"] + data["semester"]);

                          classViewController.postExam(
                              classViewController.classInfo.value.CLASS_ID,
                              data);

                          classViewController.exampleList.clear();
                        },
                        child: Center(
                            child: Text("发布",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left)),
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
