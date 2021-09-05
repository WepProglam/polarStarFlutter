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
    data['professor'] = this.professor;
    data['sector'] = this.sector;
    data["degreeCourse"] = this.degreeCourse;
    data["classNumber"] = this.classNumber;
    data["className"] = this.className;
    data["refer"] = this.refer;
    data["classID"] = this.classID;
    data["credit"] = this.credit;
    data["classes"] = this.classes;
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
    data["classRoom"] = this.classRoom;
    data["online"] = this.online;
    return data;
  }
}
