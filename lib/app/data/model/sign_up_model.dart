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
  String NAME;
  int CLASS_INDEX_ID, INDEX_COLLEGE_NAME, INDEX_TYPE, INDEX;

  CollegeMajorModel(
      {NAME, CLASS_INDEX_ID, INDEX_COLLEGE_NAME, INDEX_TYPE, INDEX});

  CollegeMajorModel.fromJson(Map<String, dynamic> json) {
    this.NAME = json["NAME"];
    this.CLASS_INDEX_ID = json["CLASS_INDEX_ID"];
    this.INDEX_COLLEGE_NAME = json["INDEX_COLLEGE_NAME"];
    this.INDEX_TYPE = json["INDEX_TYPE"];
    this.INDEX = json["INDEX"];
  }
}
