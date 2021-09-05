import 'dart:convert';

class TimeTableClassModel {
  String professor, sector, degreeCourse, classNumber, className, refer;
  int classID, credit;
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
    this.classID = json["classID"];
    this.credit = json["credit"];
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

    data["classes"] = this.classes.map((e) => e.toJson()).toList();
    return data;
  }
}

class AddClassModel {
  String start_time, end_time, day, classRoom;
  int online;

  AddClassModel({start_time, end_time, day, classRoom, online});

  AddClassModel.fromJson(Map<String, dynamic> json) {
    this.start_time = json["start_time"];
    this.end_time = json["end_time"];
    this.day = json["day"];
    this.classRoom = json["classRoom"];
    this.online = json["online"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.start_time;
    data['end_time'] = this.end_time;
    data["day"] = this.day;
    data["total_elapsed_time"] = "60";
    data["classRoom"] = this.classRoom;
    data["campus"] = "자연과학캠퍼스";
    data["online"] = this.online == null ? '1' : "${this.online}";
    return data;
  }
}
