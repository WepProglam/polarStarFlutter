class TimeTableModel {
  int YEAR, SEMESTER, TIMETABLE_ID;
  int IS_DEFAULT;
  String NAME;

  TimeTableModel({YEAR, SEMESTER, TIMETABLE_ID, NAME, IS_DEFAULT});

  TimeTableModel.fromJson(Map<String, dynamic> json) {
    this.YEAR = json["YEAR"];
    this.SEMESTER = json["SEMESTER"];
    this.TIMETABLE_ID = json["TIMETABLE_ID"];
    this.NAME = json["NAME"];
    this.IS_DEFAULT = json["IS_DEFAULT"];
  }
}

class SelectedTimeTableModel {
  int YEAR, SEMESTER, TIMETABLE_ID;

  String NAME;

  List<dynamic> CLASSES;

  SelectedTimeTableModel({YEAR, SEMESTER, TIMETABLE_ID, NAME, CLASSES});

  SelectedTimeTableModel.fromJson(Map<String, dynamic> json) {
    this.YEAR = json["YEAR"];
    this.SEMESTER = json["SEMESTER"];
    this.TIMETABLE_ID = json["TIMETABLE_ID"];
    this.NAME = json["NAME"];
    this.CLASSES = json["CLASSES"];
  }
}

class SelectYearSemesterModel {
  String YEAR, SEMESTER;

  SelectYearSemesterModel({YEAR, SEMESTER});

  SelectYearSemesterModel.fromJson(Map<String, dynamic> json) {
    this.YEAR = json["YEAR"].toString();
    this.SEMESTER = json["SEMESTER"].toString();
  }
}
