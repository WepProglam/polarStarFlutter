import 'dart:collection';

import 'dart:developer';

import 'package:polarstar_flutter/app/data/model/main_model.dart';

class ClassModel {
  int CLASS_ID, CLASS_PART, YEAR, SEMESTER;
  String CLASS_NUMBER,
      CLASS_NAME,
      CAMPUS,
      PROFESSOR,
      CLASS_SECTOR_1,
      CLASS_SECTOR_2,
      COLLEGE_NAME,
      RATE,
      COLLEGE_MAJOR;

  List CLASS_TIME;
  double CREDIT;

  ClassModel(
      {CLASS_ID,
      HEAD_COUNT,
      CLASS_NUMBER,
      CLASS_NAME,
      PROFESSOR,
      CLASS_SECTOR_1,
      CLASS_SECTOR_TOTAL,
      COLLEGE_NAME,
      COLLEGE_MAJOR,
      CLASS_TIME,
      RATE,
      CREDIT});

  ClassModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_ID = nullCheck(json["CLASS_ID"]);

    this.CLASS_NUMBER = nullCheck(json["CLASS_NUMBER"]);
    this.CLASS_NAME = nullCheck(json["CLASS_NAME"]);
    this.PROFESSOR = json["PROFESSOR"] == null ? "" : (json["PROFESSOR"]);
    this.CREDIT = nullCheck(
        json["CREDIT"] == null ? null : double.parse("${json["CREDIT"]}"));
    this.CLASS_SECTOR_1 = nullCheck(json["CLASS_SECTOR_1"]);
    this.COLLEGE_NAME = nullCheck(json["COLLEGE_NAME"]);
    this.RATE = json["AVG(RATE)"] == null ? "0" : json["AVG(RATE)"];
    this.COLLEGE_MAJOR = nullCheck(json["COLLEGE_MAJOR"]);
    this.CLASS_TIME = nullCheck(json["CLASS_TIME"]);
  }
}

class ClassRecentReviewModel {
  int CLASS_YEAR, CLASS_SEMESTER;

  String CONTENT, PROFESSOR, CLASS_NAME, RATE;

  ClassRecentReviewModel({
    CLASS_YEAR,
    CLASS_SEMESTER,
    RATE,
    CONTENT,
    PROFESSOR,
    CLASS_NAME,
  });

  ClassRecentReviewModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_YEAR = json["CLASS_YEAR"];
    this.CLASS_SEMESTER = json["CLASS_SEMESTER"];
    this.RATE = json["RATE"];
    this.CONTENT =
        (json["CONTENT"] as String).replaceAll('\\n', '\n').replaceAll('"', '');
    this.PROFESSOR = json["PROFESSOR"];
    this.CLASS_NAME = json["CLASS_NAME"];
  }
}

class RecentClassComment {
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
      RATE_EXAM_STUDY,
      RATE_GRADE_RATIO;

  RecentClassComment(
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
      RATE_EXAM_STUDY,
      RATE_GRADE_RATIO});

  RecentClassComment.fromJson(Map<String, dynamic> json) {
    this.CLASS_COMMENT_ID = json["CLASS_COMMENT_ID"];
    this.CLASS_ID = json["CLASS_ID"];
    this.PROFILE_ID = json["PROFILE_ID"];
    this.LIKES = json["LIKES"];
    this.UNNAMED = json["UNNAMED"];
    this.ACCUSE_AMOUNT = json["ACCUSE_AMOUNT"];
    this.CLASS_YEAR = json["CLASS_YEAR"];
    this.CLASS_SEMESTER = json["CLASS_SEMESTER"];
    this.TIME_CREATED = json["TIME_CREATED"];
    this.CONTENT = json["CONTENT"];
    this.RATE = json["RATE"];
    this.RATE_ASSIGNMENT = json["RATE_ASSIGNMENT"];
    this.RATE_GROUP_STUDY = json["RATE_GROUP_STUDY"];
    this.RATE_EXAM_STUDY = json["RATE_EXAM_STUDY"];
    this.RATE_GRADE_RATIO = json["RATE_GRADE_RATIO"];
  }
}
