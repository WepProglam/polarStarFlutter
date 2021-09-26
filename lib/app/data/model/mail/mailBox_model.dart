class MailBoxModel {
  String PROFILE_NICKNAME, PROFILE_PHOTO;
  int MAIL_BOX_ID, MAIL_ID;
  String CONTENT;
  bool isReaded, MY_SELF;
  DateTime TIME_CREATED;

  MailBoxModel(
      {this.MAIL_BOX_ID,
      this.MAIL_ID,
      this.PROFILE_NICKNAME,
      this.isReaded,
      this.TIME_CREATED,
      this.CONTENT,
      this.PROFILE_PHOTO,
      this.MY_SELF});

  MailBoxModel.fromJson(Map<String, dynamic> json) {
    this.MAIL_BOX_ID = json["MAIL_BOX_ID"];
    this.MAIL_ID = json["MAIL_ID"];
    this.PROFILE_NICKNAME = json["PROFILE_NICKNAME"];
    this.TIME_CREATED = DateTime.parse(json["TIME_CREATED"]);
    this.CONTENT = json["CONTENT"];
    this.PROFILE_PHOTO = json["PROFILE_PHOTO"];
    this.MY_SELF = json["MY_SELF"] == true;
    this.isReaded = false;
  }
}

class SaveMailBoxModel {
  int MAIL_BOX_ID, MAIL_ID;
  DateTime LOOKUP_DATE;

  SaveMailBoxModel({this.MAIL_BOX_ID, this.MAIL_ID, this.LOOKUP_DATE});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["MAIL_BOX_ID"] = this.MAIL_BOX_ID;
    json["MAIL_ID"] = this.MAIL_ID;
    json["LOOKUP_DATE"] = "${this.LOOKUP_DATE}";
    return json;
  }

  SaveMailBoxModel.fromJson(Map<String, dynamic> json) {
    this.MAIL_BOX_ID = json["MAIL_BOX_ID"];
    this.MAIL_ID = json["MAIL_ID"];
    this.LOOKUP_DATE = DateTime.parse(json["LOOKUP_DATE"]);
  }
}
