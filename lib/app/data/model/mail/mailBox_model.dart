class MailBoxModel {
  String PROFILE_NICKNAME;
  int MAIL_BOX_ID;
  String CONTENT;
  String TIME_CREATED;

  MailBoxModel(
      {this.MAIL_BOX_ID,
      this.PROFILE_NICKNAME,
      this.TIME_CREATED,
      this.CONTENT});

  MailBoxModel.fromJson(Map<String, dynamic> json) {
    this.MAIL_BOX_ID = json["MAIL_BOX_ID"];
    this.PROFILE_NICKNAME = json["PROFILE_NICKNAME"];
    this.TIME_CREATED = json["TIME_CREATED"];
    this.CONTENT = json["CONTENT"];
  }
}
