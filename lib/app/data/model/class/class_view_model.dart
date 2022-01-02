import 'dart:convert';

import 'package:polarstar_flutter/app/ui/android/class/class.dart';

class ClassInfoModel {
  int CLASS_ID;
  int MY_CLASS_POINT;
  double CREDIT;
  String AVG_RATE,
      AVG_RATE_ASSIGNMENT,
      AVG_RATE_GROUP_STUDY,
      AVG_RATE_EXAM_STUDY,
      AVG_RATE_GRADE_RATIO,
      CLASS_NUMBER,
      CLASS_NAME,
      PROFESSOR,
      CLASS_SECTOR_1,
      CLASS_SECTOR_TOTAL,
      COLLEGE_NAME,
      COLLEGE_MAJOR;

  List CLASS_TIME;

  ClassInfoModel(
      {CLASS_ID,
      AVG_RATE,
      AVG_RATE_ASSIGNMENT,
      AVG_RATE_GROUP_STUDY,
      AVG_RATE_EXAM_STUDY,
      AVG_RATE_GRADE_RATIO,
      CLASS_NUMBER,
      CLASS_NAME,
      PROFESSOR,
      CREDIT,
      DEGREE_COURSE,
      SECTOR,
      CLASS_TIME,
      CLASS_SECTOR_1,
      CLASS_SECTOR_TOTAL,
      COLLEGE_NAME,
      COLLEGE_MAJOR,
      MY_CLASS_POINT});

  ClassInfoModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_ID = json["CLASS_ID"];
    this.AVG_RATE = json["AVG(RATE)"];
    this.AVG_RATE_ASSIGNMENT = json["AVG(RATE_ASSIGNMENT)"];
    this.AVG_RATE_GROUP_STUDY = json["AVG(RATE_GROUP_STUDY)"];
    this.AVG_RATE_EXAM_STUDY = json["AVG(RATE_EXAM_STUDY)"];
    this.AVG_RATE_GRADE_RATIO = json["AVG(RATE_GRADE_RATIO)"];
    this.CLASS_NUMBER = json["CLASS_NUMBER"];
    this.CLASS_NAME = json["CLASS_NAME"];
    this.PROFESSOR = json["PROFESSOR"];
    this.CREDIT = double.parse("${json["CREDIT"]}");
    this.CLASS_SECTOR_1 = json["CLASS_SECTOR_1"];
    this.CLASS_SECTOR_TOTAL = json["CLASS_SECTOR_TOTAL"];
    this.COLLEGE_NAME = json["COLLEGE_NAME"];
    this.COLLEGE_MAJOR = json["COLLEGE_MAJOR"];
    this.CLASS_TIME = json["CLASSES"];
    this.MY_CLASS_POINT = json["CLASS_POINT"];
  }
}

class ClassReviewModel {
  int CLASS_COMMENT_ID,
      CLASS_ID,
      PROFILE_ID,
      LIKES,
      UNNAMED,
      ACCUSE_AMOUNT,
      CLASS_YEAR,
      CLASS_SEMESTER;

  String TIME_CREATED,
      CONTENT,
      RATE,
      RATE_ASSIGNMENT,
      RATE_GROUP_STUDY,
      RATE_GRADE_RATIO;

  ClassReviewModel(
      {CLASS_COMMENT_ID,
      CLASS_ID,
      PROFILE_ID,
      LIKES,
      UNNAMED,
      ACCUSE_AMOUNT,
      CLASS_YEAR,
      CLASS_SEMESTER,
      TIME_CREATED,
      CONTENT,
      RATE,
      RATE_ASSIGNMENT,
      RATE_GROUP_STUDY,
      RATE_GRADE_RATIO});

  ClassReviewModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_COMMENT_ID = json["CLASS_COMMENT_ID"];
    this.CLASS_ID = json["CLASS_ID"];
    this.PROFILE_ID = json["PROFILE_ID"];
    this.LIKES = json["LIKES"];
    this.UNNAMED = json["UNNAMED"];
    this.ACCUSE_AMOUNT = json["ACCUSE_AMOUNT"];
    this.CLASS_YEAR = json["CLASS_YEAR"];
    this.CLASS_SEMESTER = json["CLASS_SEMESTER"];
    this.TIME_CREATED = json["TIME_CREATED"];
    this.CONTENT =
        (json["CONTENT"] as String).replaceAll('\\n', '\n').replaceAll('"', '');
    this.RATE = json["RATE"];
    this.RATE_ASSIGNMENT = json["RATE_ASSIGNMENT"];
    this.RATE_GROUP_STUDY = json["RATE_GROUP_STUDY"];
    this.RATE_GRADE_RATIO = json["RATE_GRADE_RATIO"];
  }
}

class ClassExamModel {
  int CLASS_EXAM_ID,
      CLASS_ID,
      PROFILE_ID,
      CLASS_EXAM_YEAR,
      CLASS_EXAM_SEMESTER,
      LIKES;
  String TEST_STRATEGY, TEST_TYPE, TIME_CREATED, MID_FINAL;
  List TEST_EXAMPLE;
  bool IS_BUYED;

  ClassExamModel(
      {CLASS_EXAM_ID,
      CLASS_ID,
      TEST_STRATEGY,
      TEST_TYPE,
      TEST_EXAMPLE,
      TIME_CREATED,
      PROFILE_ID,
      CLASS_EXAM_YEAR,
      CLASS_EXAM_SEMESTER,
      LIKES,
      MID_FINAL,
      IS_BUYED});

  ClassExamModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_EXAM_ID = json["CLASS_EXAM_ID"];
    this.CLASS_ID = json["CLASS_ID"];

    this.TEST_STRATEGY = json["TEST_STRATEGY"];
    this.TEST_TYPE = json["TEST_TYPE"];
    //ㅅㅂ 이거 해결해야 함
    if (json["TEST_EXAMPLE"] is String) {
      this.TEST_EXAMPLE = json["TEST_EXAMPLE"]
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",");
    } else {
      this.TEST_EXAMPLE = json["TEST_EXAMPLE"];
    }
    ;
    this.TIME_CREATED = json["TIME_CREATED"];

    this.PROFILE_ID = json["PROFILE_ID"];
    this.CLASS_EXAM_YEAR = json["CLASS_EXAM_YEAR"];
    this.CLASS_EXAM_SEMESTER = json["CLASS_EXAM_SEMESTER"];
    this.LIKES = json["LIKES"];
    this.MID_FINAL = json["MID_FINAL"];
    this.IS_BUYED = json["IS_BUYED"];
  }
}
