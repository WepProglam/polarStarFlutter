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
