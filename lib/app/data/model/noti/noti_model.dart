class NotiModel {
  String URL, CONTENT, TIME_CREATED;

  NotiModel({URL, CONTENT, TIME_CREATED});

  NotiModel.fromJson(Map<String, dynamic> json) {
    this.URL = json["URL"];
    this.CONTENT = json["CONTENT"];
    this.TIME_CREATED = json["TIME_CREATED"];
  }
}
