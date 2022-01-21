import 'dart:convert';

import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';

class TimeTableClassModel {
  int CLASS_ID, HEAD_COUNT, NUMBER_OF_STUDENTS;
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
    this.NUMBER_OF_STUDENTS = json["NUMBER_OF_STUDENTS"];

    this.CLASS_NUMBER = json["CLASS_NUMBER"];
    this.CLASS_NAME = json["CLASS_NAME"];
    this.PROFESSOR = json["PROFESSOR"];
    if (json['CREDIT'] == null) {
      this.CREDIT = null;
    } else {
      this.CREDIT = double.parse("${json['CREDIT']}");
    }
    this.CLASS_SECTOR_1 = json["CLASS_SECTOR_1"];
    this.CLASS_SECTOR_TOTAL = json["CLASS_SECTOR_TOTAL"];
    this.COLLEGE_NAME = json["COLLEGE_NAME"];

    this.COLLEGE_MAJOR = json["COLLEGE_MAJOR"];
    this.OPEN_TIME = json["OPEN_TIME"];

    Iterable tempClassJson = json["CLASS_TIME"];

    List<AddClassModel> tempClasses =
        tempClassJson.map((e) => AddClassModel.fromJson(e)).toList();

    Map<String, List<AddClassModel>> unionClassMap = unionClasses(tempClasses);

    List<AddClassModel> CLASS_TIME_UNION = [];
    unionClassMap.forEach((key, value) {
      for (AddClassModel item in value) {
        CLASS_TIME_UNION.add(item);
      }
    });

    this.CLASS_TIME = CLASS_TIME_UNION;
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
      data['HEAD_COUNT'] = this.HEAD_COUNT;
      data['NUMBER_OF_STUDENTS'] = this.NUMBER_OF_STUDENTS;
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
  int INDEX_COLLEGE_NAME;

  CollegeNameModel({COLLEGE_NAME, INDEX_COLLEGE_NAME});

  CollegeNameModel.fromJson(Map<String, dynamic> json) {
    this.COLLEGE_NAME = json["NAME"];
    this.INDEX_COLLEGE_NAME = json["INDEX"];
  }
}

class CollegeMajorModel {
  int INDEX_COLLEGE_MAJOR, INDEX_COLLEGE_NAME;
  String NAME;

  CollegeMajorModel(
      {this.INDEX_COLLEGE_MAJOR, this.INDEX_COLLEGE_NAME, this.NAME});

  CollegeMajorModel.fromJson(Map<String, dynamic> json) {
    this.INDEX_COLLEGE_MAJOR = json["INDEX"];
    this.INDEX_COLLEGE_NAME = json["INDEX_COLLEGE_NAME"];
    this.NAME = json["NAME"];
  }
}
