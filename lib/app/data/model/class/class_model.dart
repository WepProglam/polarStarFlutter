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
