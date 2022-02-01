import 'dart:convert';

import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';

class TimeTableClassModel {
  int CLASS_ID,
      CLASS_PART,
      NUMBER_OF_STUDENTS,
      YEAR,
      SEMESTER,
      COLLEGE_ID,
      MAJOR_ID;
  String CLASS_NUMBER,
      CLASS_NAME,
      PROFESSOR,
      RATE,
      CAMPUS,
      CLASS_SECTOR_1,
      CLASS_SECTOR_2;
  bool IS_ICAMPUS, IS_NOT_DETERMINED;

  List<AddClassModel> CLASS_TIME;
  double CREDIT;

  TimeTableClassModel(
      {CLASS_ID,
      CLASS_PART,
      NUMBER_OF_STUDENTS,
      YEAR,
      SEMESTER,
      COLLEGE_ID,
      MAJOR_ID,
      CLASS_NUMBER,
      CLASS_NAME,
      RATE,
      PROFESSOR,
      CAMPUS,
      CLASS_SECTOR_1,
      CLASS_SECTOR_2,
      CLASS_TIME,
      IS_ICAMPUS,
      IS_NOT_DETERMINED,
      CREDIT});

  TimeTableClassModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_ID = json["CLASS_ID"];
    this.CLASS_PART = json["CLASS_PART"];
    this.NUMBER_OF_STUDENTS = json["NUMBER_OF_STUDENTS"];

    this.YEAR = json["YEAR"];
    this.SEMESTER = json["SEMESTER"];
    this.COLLEGE_ID = json["COLLEGE_ID"];
    this.MAJOR_ID = json["MAJOR_ID"];
    this.CLASS_NUMBER = json["CLASS_NUMBER"];
    this.CLASS_NAME = json["CLASS_NAME"];
    this.CAMPUS = json["CAMPUS"];
    this.CLASS_SECTOR_1 = json["CLASS_SECTOR_1"];
    this.CLASS_SECTOR_2 = json["CLASS_SECTOR_2"];
    this.CLASS_NUMBER = json["CLASS_NUMBER"];
    this.PROFESSOR =
        json["PROFESSOR"] == null || json["PROFESSOR"].toString().isEmpty
            ? "미지정"
            : json["PROFESSOR"];
    this.RATE = json["AVG(RATE)"] == null ? "0" : json["AVG(RATE)"];
    if (json['CREDIT'] == null) {
      this.CREDIT = null;
    } else {
      this.CREDIT = double.parse("${json['CREDIT']}");
    }

    Iterable tempClassJson = json["CLASS_TIME"];
    print(tempClassJson.first["day"]);
    if (tempClassJson.first["day"].toString().contains("【iCampus 수업】")) {
      this.CLASS_TIME = [];
      this.IS_ICAMPUS = true;
      this.IS_NOT_DETERMINED = false;
    } else if (tempClassJson.first["day"].toString().contains("미지정")) {
      this.IS_NOT_DETERMINED = true;
      this.CLASS_TIME = [];
      this.IS_ICAMPUS = false;
    } else {
      List<AddClassModel> tempClasses =
          tempClassJson.map((e) => AddClassModel.fromJson(e)).toList();

      Map<String, List<AddClassModel>> unionClassMap =
          unionClasses(tempClasses);

      List<AddClassModel> CLASS_TIME_UNION = [];
      unionClassMap.forEach((key, value) {
        for (AddClassModel item in value) {
          CLASS_TIME_UNION.add(item);
        }
      });

      this.CLASS_TIME = CLASS_TIME_UNION;
      this.IS_ICAMPUS = false;
      this.IS_NOT_DETERMINED = false;
    }
  }

  Map<String, List<AddClassModel>> unionClasses(
      List<AddClassModel> tempClasses) {
    Map<String, List<AddClassModel>> tt = {};
    for (var item in tempClasses) {
      for (var item2 in tempClasses) {
        if (item2.start_time == null || item2.end_time == null) {
          continue;
        }

        if (!tt.containsKey(item2.day)) {
          tt[item2.day] = [item2];
        } else {
          for (var i = 0; i < tt[item2.day].length; i++) {
            AddClassModel classModel = tt[item2.day][i];

            bool beforeClass =
                classModel.start_time.difference(item2.end_time).inMinutes <=
                    15;
            bool afterClass =
                classModel.end_time.difference(item2.start_time).inMinutes <=
                    15;

            if (beforeClass) {
              tt[item2.day][i].end_time = item2.end_time;
            } else if (afterClass) {
              tt[item2.day][i].start_time = item2.start_time;
            }
          }
        }
      }
    }
    return tt;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.CLASS_ID != null) {
      data['CLASS_ID'] = this.CLASS_ID;
      data['CLASS_PART'] = this.CLASS_PART;
      data['NUMBER_OF_STUDENTS'] = this.NUMBER_OF_STUDENTS;
      data['YEAR'] = this.YEAR;
      data['SEMESTER'] = this.SEMESTER;
      data['COLLEGE_ID'] = this.COLLEGE_ID;
      data['MAJOR_ID'] = this.MAJOR_ID;
      data['CLASS_NUMBER'] = this.CLASS_NUMBER;
      data['CLASS_NAME'] = this.CLASS_NAME;
      data['PROFESSOR'] = this.PROFESSOR;
      data['CAMPUS'] = this.CAMPUS;
      data['CLASS_SECTOR_1'] = this.CLASS_SECTOR_1;
      data['CLASS_SECTOR_2'] = this.CLASS_SECTOR_2;
      data['CREDIT'] = this.CREDIT;
      data["CLASS_TIME"] =
          jsonEncode(this.CLASS_TIME.map((e) => e.toJson()).toList());
    } else {
      data['CLASS_NAME'] = this.CLASS_NAME;
      data['PROFESSOR'] = this.PROFESSOR;
      data["CLASS_TIME"] =
          jsonEncode(this.CLASS_TIME.map((e) => e.toJson()).toList());
    }

    return data;
  }
}

class AddClassModel {
  DateTime start_time, end_time;
  String day, class_room;

  AddClassModel({start_time, end_time, day, class_room});

  AddClassModel.fromJson(Map<String, dynamic> json) {
    if (json["day"].trim() == "미지정" ||
        json["end_time"].trim() == "미지정" ||
        json["start_time"].trim() == "미지정") {
      this.start_time = null;
      this.end_time = null;
      this.day = null;
      this.class_room = null;
    } else {
      List<String> start = json["start_time"].split(":");
      List<String> end = json["end_time"].split(":");

      if (start.length < 2) {
        this.start_time = null;
        this.end_time = null;
        this.day = null;
        this.class_room = "[iCampus 수업]";
      } else {
        this.start_time = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, int.parse(start[0]), int.parse(start[1]));
        this.end_time = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, int.parse(end[0]), int.parse(end[1]));

        this.day = json["day"];
        this.class_room = json["class_room"];
      }
    }
    // {day: 미지정, end_time: 미지정, class_room: 미지정, start_time: 미지정}
    // 으로 날라올때 에러처리
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

class CollegeNameModel {
  String COLLEGE_NAME;
  int COLLEGE_ID;

  CollegeNameModel({COLLEGE_NAME, COLLEGE_ID});

  CollegeNameModel.fromJson(Map<String, dynamic> json) {
    this.COLLEGE_NAME = json["COLLEGE_NAME"];
    this.COLLEGE_ID = json["COLLEGE_ID"];
  }
}

class CollegeMajorModel {
  int COLLEGE_ID, MAJOR_ID;
  String COLLEGE_NAME, MAJOR_NAME;

  CollegeMajorModel(
      {this.COLLEGE_ID, this.MAJOR_ID, this.COLLEGE_NAME, this.MAJOR_NAME});

  CollegeMajorModel.fromJson(Map<String, dynamic> json) {
    this.COLLEGE_ID = json["COLLEGE_ID"];
    this.MAJOR_ID = json["MAJOR_ID"];
    this.COLLEGE_NAME = json["COLLEGE_NAME"];
    this.MAJOR_NAME = json["MAJOR_NAME"];
  }
}
