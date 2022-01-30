class SignUpModel {
  String id;
  String pw;
  String nickname;
  String studentID;

  SignUpModel({id, pw, nickname, studentId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["pw"] = this.pw;
    data["nickname"] = this.nickname;
    data["studentID"] = this.studentID;
    return data;
  }
}

class CollegeMajorModel {
  String COLLEGE_NAME, MAJOR_NAME;
  int COLLEGE_ID, MAJOR_ID;

  CollegeMajorModel({COLLEGE_NAME, MAJOR_NAME, COLLEGE_ID, MAJOR_ID});

  CollegeMajorModel.fromJson(Map<String, dynamic> json) {
    this.COLLEGE_NAME = json["COLLEGE_NAME"];
    this.MAJOR_NAME = json["MAJOR_NAME"];
    this.COLLEGE_ID = json["COLLEGE_ID"];
    this.MAJOR_ID = json["MAJOR_ID"];
  }
}
