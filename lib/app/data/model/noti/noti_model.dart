import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/class/class_chat_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';

class NotiModel {
  String URL, CONTENT, TITLE;
  int NOTI_ID, NOTI_TYPE;
  DateTime TIME_CREATED;
  bool isReaded;
  int COMMUNITY_ID, BOARD_ID;

  NotiModel({URL, CONTENT, TIME_CREATED, isReaded, TITLE, NOTI_TYPE});

  NotiModel.fromJson(Map<String, dynamic> json) {
    this.URL = json["URL"];
    this.CONTENT = json["CONTENT"];
    this.TITLE = json["TITLE"];
    this.TIME_CREATED = DateTime.parse(json["TIME_CREATED"]);
    this.NOTI_ID = json["NOTI_ID"];
    this.NOTI_TYPE = json["NOTI_TYPE"];
    this.isReaded = false;
    this.COMMUNITY_ID = null;
    this.BOARD_ID = null;
    if (this.NOTI_TYPE == 0) {
      this.COMMUNITY_ID = int.parse(json["URL"].split("/")[1]);
      this.BOARD_ID = int.parse(json["URL"].split("/")[3]);
    }
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

class ChatBoxModel {
  String CLASS_NAME, CLASS_PROFESSOR, LAST_CHAT;
  int CLASS_ID, CHAT_ID, AMOUNT;
  DateTime TIME_LAST_CHAT_SENDED;
  RxList<Rx<ClassChatModel>> ClassChatList;

  ChatBoxModel(
      {CLASS_NAME,
      CLASS_PROFESSOR,
      LAST_CHAT,
      CLASS_ID,
      CHAT_ID,
      TIME_LAST_CHAT_SENDED});

  Map<String, dynamic> toJson() {
    print("tojson called");
    return {
      'CLASS_NAME': "${this.CLASS_NAME}",
      'CLASS_PROFESSOR': "${this.CLASS_PROFESSOR}",
      'LAST_CHAT': "${this.LAST_CHAT}",
      'CLASS_ID': "${this.CLASS_ID}",
      'CHAT_ID': "${this.CHAT_ID}",
      'TIME_LAST_CHAT_SENDED': "${this.TIME_LAST_CHAT_SENDED}",
      'ClassChatList': this.ClassChatList.toJson(),
    };
  }

  ChatBoxModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_NAME = json["CLASS_NAME"];
    this.CLASS_PROFESSOR = json["CLASS_PROFESSOR"];
    print("class_id: ${json["CLASS_ID"]}");
    this.CHAT_ID = nullCheck(json["CHAT_ID"]);
    this.CLASS_ID = json["CLASS_ID"];
    this.LAST_CHAT = json["LAST_CHAT"];
    print(json["LAST_CHAT"]);
    this.TIME_LAST_CHAT_SENDED = json["TIME_LAST_CHAT_SENDED"] == null
        ? null
        : DateTime.parse(json["TIME_LAST_CHAT_SENDED"]);
    this.ClassChatList = json["ClassChatList"] != null
        ? json["ClassChatList"]
            .map((e) => ClassChatModel.fromJson(e).obs)
            .toList()
            .obs
        : <Rx<ClassChatModel>>[].obs;
    this.AMOUNT = 0;
  }
}
