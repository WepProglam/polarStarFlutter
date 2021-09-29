import 'dart:convert';

import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';

class TimeTableClassModel {
  int CLASS_ID, HEAD_COUNT;
  String CLASS_NUMBER,
      CLASS_NAME,
      PROFESSOR,
      CLASS_SECTOR_1,
      CLASS_SECTOR_TOTAL,
      COLLEGE_NAME,
      COLLEGE_MAJOR;

  List<AddClassModel> CLASS_TIME;
  List OPEN_TIME;
  double CREDIT;

  TimeTableClassModel(
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

  TimeTableClassModel.fromJson(Map<String, dynamic> json) {
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
    this.OPEN_TIME = json["OPEN_TIME"];

    Iterable tempClassJson = json["CLASS_TIME"];

    List<AddClassModel> tempClasses =
        tempClassJson.map((e) => AddClassModel.fromJson(e)).toList();
    this.CLASS_TIME = tempClasses;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CLASS_ID'] = this.CLASS_ID;
    data['HEAD_COUNT'] = this.HEAD_COUNT;
    data['CLASS_NUMBER'] = this.CLASS_NUMBER;
    data['CLASS_NAME'] = this.CLASS_NAME;
    data['PROFESSOR'] = this.PROFESSOR;
    data['CREDIT'] = this.CREDIT;
    data['CLASS_SECTOR_1'] = this.CLASS_SECTOR_1;
    data['CLASS_SECTOR_TOTAL'] = this.CLASS_SECTOR_TOTAL;
    data["COLLEGE_NAME"] = this.COLLEGE_NAME;
    data["COLLEGE_MAJOR"] = this.COLLEGE_MAJOR;
    data["OPEN_TIME"] = this.OPEN_TIME;
    data["CLASS_TIME"] =
        jsonEncode(this.CLASS_TIME.map((e) => e.toJson()).toList());

    return data;
  }
}

class AddClassModel {
  DateTime start_time, end_time;
  String day, class_room;

  AddClassModel({start_time, end_time, day, class_room});

  AddClassModel.fromJson(Map<String, dynamic> json) {
    List<String> start = json["start_time"].split(":");
    List<String> end = json["end_time"].split(":");

    this.start_time = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, int.parse(start[0]), int.parse(start[1]));
    this.end_time = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, int.parse(end[0]), int.parse(end[1]));

    this.day = json["day"];
    this.class_room = json["class_room"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = timeFormatter(this.start_time);
    data['end_time'] = timeFormatter(this.end_time);
    data["day"] = this.day;
    data["class_room"] = this.class_room;
    return data;
  }
}
