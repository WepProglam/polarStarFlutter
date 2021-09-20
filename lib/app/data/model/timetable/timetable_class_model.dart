import 'dart:convert';

import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';

class TimeTableClassModel {
  String professor, sector, degreeCourse, classNumber, className, refer;
  String classID, credit;
  List<AddClassModel> classes;

  TimeTableClassModel(
      {professor,
      sector,
      degreeCourse,
      classNumber,
      className,
      refer,
      classID,
      credit,
      classes});

  TimeTableClassModel.fromJson(Map<String, dynamic> json) {
    this.professor = json["professor"];
    this.sector = json["sector"];
    this.degreeCourse = json["degreeCourse"];
    this.classNumber = json["classNumber"];
    this.className = json["className"];
    this.refer = json["refer"];
    this.classID = "${json["classID"]}";
    this.credit = "${json["credit"]}";
    Iterable tempClassJson = json["classes"];

    List<AddClassModel> tempClasses =
        tempClassJson.map((e) => AddClassModel.fromJson(e)).toList();
    this.classes = tempClasses;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['professor'] = this.professor == null ? "김갑생" : this.professor;
    data['sector'] = this.sector == null ? "전공필수" : this.sector;
    data["degreeCourse"] = this.degreeCourse == null ? "학사" : this.degreeCourse;
    data["classNumber"] = this.classNumber == null ? "11111" : this.classNumber;
    data["className"] = this.className == null ? "할머니김" : this.className;
    data["refer"] = this.refer == null ? "" : this.refer;

    data["classID"] = this.classID == null ? '0' : "${this.classID}";
    data["credit"] = this.credit == null ? '3' : "${this.credit}";

    data["classes"] = jsonEncode(this.classes.map((e) => e.toJson()).toList());
    return data;
  }
}

class AddClassModel {
  DateTime start_time, end_time;
  String day, classRoom;
  String online;

  AddClassModel({start_time, end_time, day, classRoom, online});

  AddClassModel.fromJson(Map<String, dynamic> json) {
    List<String> start = json["start_time"].split(":");
    List<String> end = json["end_time"].split(":");

    this.start_time = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, int.parse(start[0]), int.parse(start[1]));
    this.end_time = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, int.parse(end[0]), int.parse(end[1]));

    this.day = json["day"];
    this.classRoom = json["classRoom"];
    this.online = "${json["online"]}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = timeFormatter(this.start_time);
    data['end_time'] = timeFormatter(this.end_time);
    data["day"] = this.day;
    data["total_elapsed_time"] = "60";
    data["classRoom"] = this.classRoom;
    data["campus"] = "자연과학캠퍼스";
    data["online"] = this.online == null ? '1' : "${this.online}";
    return data;
  }
}
