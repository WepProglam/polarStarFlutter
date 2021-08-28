import 'dart:collection';

class ClassMain {
  int CLASS_ID;
  String CLASS_NUMBER,
      CLASS_NAME,
      PROCESSOR,
      CREDIT,
      DEGREE_COURSE,
      SECTOR,
      REFER;
  List<String> CLASSES;

  ClassMain(Set set,
      {CLASS_ID,
      CLASS_NUMBER,
      CLASS_NAME,
      PROCESSOR,
      CREDIT,
      DEGREE_COURSE,
      SECTOR,
      REFER,
      CLASSES});

  ClassMain.fromJson(Map<String, dynamic> json) {
    this.CLASS_ID = json["CLASS_ID"];

    this.CLASS_NUMBER = json["CLASS_NUMBER"];
    this.CLASS_NAME = json["CLASS_NAME"];
    this.PROCESSOR = json["PROCESSOR"];
    this.CREDIT = json["CREDIT"];
    this.DEGREE_COURSE = json["DEGREE_COURSE"];
    this.SECTOR = json["SECTOR"];
    this.REFER = json["REFER"];

    this.CLASSES = json["CLASSES"];
  }
}
