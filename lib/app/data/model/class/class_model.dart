import 'dart:collection';

class ClassModel {
  int CLASS_ID;
  String CLASS_NUMBER,
      CLASS_NAME,
      PROFESSOR,
      CREDIT,
      DEGREE_COURSE,
      SECTOR,
      REFER;
  List CLASSES;

  ClassModel(
      {CLASS_ID,
      CLASS_NUMBER,
      CLASS_NAME,
      PROFESSOR,
      CREDIT,
      DEGREE_COURSE,
      SECTOR,
      REFER,
      CLASSES});

  ClassModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_ID = json["CLASS_ID"];

    this.CLASS_NUMBER = json["CLASS_NUMBER"];
    this.CLASS_NAME = json["CLASS_NAME"];
    this.PROFESSOR = json["PROFESSOR"];
    this.CREDIT = json["CREDIT"];
    this.DEGREE_COURSE = json["DEGREE_COURSE"];
    this.SECTOR = json["SECTOR"];
    this.REFER = json["REFER"];

    this.CLASSES = json["CLASSES"];
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
