class LoginModel {
  String id;
  String pw;
  String token;

  LoginModel({id, pw, token});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pw'] = this.pw;
    data["token"] = this.token;
    return data;
  }
}
