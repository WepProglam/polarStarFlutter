import 'dart:convert';

import 'package:polarstar_flutter/session.dart';

import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';

class TimetableApiClient {
  Future getCurrentTimeTable() async {
    var response = await Session().getX("/timetable");
    return response;
  }

  Future getTimeTable(int TIMETABLE_ID) async {
    var response = await Session().getX("/timetable/table/tid/${TIMETABLE_ID}");
    return response;
  }

  Future getSemesterTimeTable(int YEAR, int SEMESTER) async {
    var response = await Session().getX("/timetable/${YEAR}/${SEMESTER}");
    return response;
  }
}
