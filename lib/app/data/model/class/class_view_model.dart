import 'package:polarstar_flutter/app/ui/android/class/class.dart';

class ClassInfoModel {
  int CLASS_ID;
  String AVG,
      CLASS_NUMBER,
      CLASS_NAME,
      PROFESSOR,
      CREDIT,
      DEGREE_COURSE,
      SECTOR,
      REFER;
  List CLASSES;

  ClassInfoModel(Set set,
      {CLASS_ID,
      AVG,
      CLASS_NUMBER,
      CLASS_NAME,
      PROFESSOR,
      CREDIT,
      DEGREE_COURSE,
      SECTOR,
      REFER,
      CLASSES});

  ClassInfoModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_ID = json["CLASS_ID"];

    this.AVG = json["AVG"];
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

class ClassReviewModel {
  int CLASS_COMMENT_ID, CLASS_ID, PROFILE_ID, LIKES, UNNAMED, ACCUSE_AMOUNT;

  String TIME_CREATED, CONTENT, RATE;

  ClassReviewModel(Set set,
      {CLASS_COMMENT_ID,
      CLASS_ID,
      PROFILE_ID,
      LIKES,
      UNNAMED,
      ACCUSE_AMOUNT,
      TIME_CREATED,
      CONTENT,
      RATE});

  ClassReviewModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_COMMENT_ID = json["CLASS_COMMENT_ID"];
    this.CLASS_ID = json["CLASS_ID"];
    this.PROFILE_ID = json["PROFILE_ID"];
    this.LIKES = json["LIKES"];
    this.UNNAMED = json["UNNAMED"];
    this.ACCUSE_AMOUNT = json["ACCUSE_AMOUNT"];
    this.TIME_CREATED = json["TIME_CREATED"];
    this.CONTENT = json["CONTENT"];
    this.RATE = json["RATE"];
  }
}
