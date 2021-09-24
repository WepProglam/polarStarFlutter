class NotiModel {
  String URL, CONTENT, TITLE;
  int NOTI_ID, NOTI_TYPE;
  DateTime TIME_CREATED;
  bool isReaded;

  NotiModel({URL, CONTENT, TIME_CREATED, isReaded, TITLE, NOTI_TYPE});

  NotiModel.fromJson(Map<String, dynamic> json) {
    this.URL = json["URL"];
    this.CONTENT = json["CONTENT"];
    this.TITLE = json["TITLE"];
    this.TIME_CREATED = DateTime.parse(json["TIME_CREATED"]);
    this.NOTI_ID = json["NOTI_ID"];
    this.NOTI_TYPE = json["NOTI_TYPE"];
    this.isReaded = false;
  }
}

class SaveNotiModel {
  int NOTI_ID;
  DateTime LOOKUP_DATE;

  SaveNotiModel({NOTI_ID, LOOKUP_DATE});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["NOTI_ID"] = NOTI_ID;
    data["LOOKUP_DATE"] = "${LOOKUP_DATE}";
    return data;
  }

  SaveNotiModel.fromJson(Map<String, dynamic> json) {
    this.NOTI_ID = json["NOTI_ID"];
    this.LOOKUP_DATE = DateTime.parse(json["LOOKUP_DATE"]);
  }
}
