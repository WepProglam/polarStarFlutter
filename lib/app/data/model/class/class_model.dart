import 'dart:collection';

class ClassModel {
  int CLASS_ID, HEAD_COUNT;
  String CLASS_NUMBER,
      CLASS_NAME,
      PROFESSOR,
      CLASS_SECTOR_1,
      CLASS_SECTOR_TOTAL,
      COLLEGE_NAME,
      COLLEGE_MAJOR;

  List CLASS_TIME;
  List OPEN_TIME;
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
      OPEN_TIME,
      CREDIT});

  ClassModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_ID = json["CLASS_ID"];
    this.HEAD_COUNT = json["HEAD_COUNT"];

    this.CLASS_NUMBER = json["CLASS_NUMBER"];
    this.CLASS_NAME = json["CLASS_NAME"];
    this.PROFESSOR = json["PROFESSOR"];
    this.CREDIT = double.parse("${json["CREDIT"]}");
    this.CLASS_SECTOR_1 = json["CLASS_SECTOR_1"];
    this.CLASS_SECTOR_TOTAL = json["CLASS_SECTOR_TOTAL"];
    this.COLLEGE_NAME = json["COLLEGE_NAME"];

    this.COLLEGE_MAJOR = json["COLLEGE_MAJOR"];
    this.CLASS_TIME = json["CLASS_TIME"];
    this.OPEN_TIME = json["OPEN_TIME"];
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
    this.CONTENT = json["CONTENT"];
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
