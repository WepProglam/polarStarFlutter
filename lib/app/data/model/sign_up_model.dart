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
