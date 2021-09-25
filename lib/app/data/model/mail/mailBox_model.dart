class MailBoxModel {
  String PROFILE_NICKNAME, PROFILE_PHOTO;
  int MAIL_BOX_ID;
  String CONTENT;
  DateTime TIME_CREATED;

  MailBoxModel(
      {this.MAIL_BOX_ID,
      this.PROFILE_NICKNAME,
      this.TIME_CREATED,
      this.CONTENT,
      this.PROFILE_PHOTO});

  MailBoxModel.fromJson(Map<String, dynamic> json) {
    this.MAIL_BOX_ID = json["MAIL_BOX_ID"];
    this.PROFILE_NICKNAME = json["PROFILE_NICKNAME"];
    this.TIME_CREATED = DateTime.parse(json["TIME_CREATED"]);
    this.CONTENT = json["CONTENT"];
    this.PROFILE_PHOTO = json["PROFILE_PHOTO"];
  }
}
