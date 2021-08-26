class MailHistoryModel {
  int FROM_ME;
  String CONTENT;
  String TIME_CREATED;

  MailHistoryModel({this.FROM_ME, this.TIME_CREATED, this.CONTENT});

  MailHistoryModel.fromJson(Map<String, dynamic> json) {
    this.FROM_ME = json["FROM_ME"];
    this.TIME_CREATED = json["TIME_CREATED"];
    this.CONTENT = json["CONTENT"];
  }
}

class MailProfile {
  String PROFILE_NICKNAME;
  String PROFILE_PHOTO;

  MailProfile({this.PROFILE_NICKNAME, this.PROFILE_PHOTO});

  MailProfile.fromJson(Map<String, dynamic> json) {
    this.PROFILE_NICKNAME = json["PROFILE_NICKNAME"];
    this.PROFILE_PHOTO = json["PROFILE_PHOTO"];
  }
}
