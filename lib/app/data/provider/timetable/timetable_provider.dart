import 'dart:convert';

import 'package:polarstar_flutter/session.dart';

import 'package:polarstar_flutter/app/data/model/timetable/timetable_model.dart';

class TimetableApiClient {
  Future getCurrentTimeTable() async {
    var response = await Session().getX("/timetable");
    return response;
  }
}
