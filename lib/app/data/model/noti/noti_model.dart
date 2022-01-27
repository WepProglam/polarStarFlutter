import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'dart:convert';

final box = GetStorage();

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
  String BOX_NAME, CLASS_PROFESSOR, LAST_CHAT;
  int BOX_ID, CHAT_ID, AMOUNT;
  DateTime TIME_LAST_CHAT_SENDED;
  RxList<Rx<ChatModel>> ChatList;

  ChatBoxModel(
      {BOX_NAME,
      CLASS_PROFESSOR,
      LAST_CHAT,
      BOX_ID,
      CHAT_ID,
      TIME_LAST_CHAT_SENDED});

  Map<String, dynamic> toJson() {
    print("tojson called");
    return {
      'BOX_NAME': "${this.BOX_NAME}",
      'CLASS_PROFESSOR': "${this.CLASS_PROFESSOR}",
      'LAST_CHAT': "${this.LAST_CHAT}",
      'CLASS_ID': "${this.BOX_ID}",
      'CHAT_ID': "${this.CHAT_ID}",
      'TIME_LAST_CHAT_SENDED': "${this.TIME_LAST_CHAT_SENDED}",
      'ChatList': this.ChatList.toJson(),
    };
  }

  ChatBoxModel.fromJson(Map<String, dynamic> json) {
    this.BOX_NAME = json["BOX_NAME"];
    this.CLASS_PROFESSOR = json["CLASS_PROFESSOR"];
    print("class_id: ${json["CLASS_ID"]}");
    this.CHAT_ID = nullCheck(json["CHAT_ID"]);
    this.BOX_ID = json["BOX_ID"];
    this.LAST_CHAT = json["LAST_CHAT"];
    print(json["LAST_CHAT"]);
    this.TIME_LAST_CHAT_SENDED = json["TIME_LAST_CHAT_SENDED"] == null
        ? null
        : DateTime.parse(json["TIME_LAST_CHAT_SENDED"]);
    this.ChatList = json["ChatList"] != null
        ? json["ChatList"].map((e) => ChatModel.fromJson(e).obs).toList().obs
        : <Rx<ChatModel>>[].obs;
    this.AMOUNT = 0;
  }
}

class ChatModel {
  String CONTENT, PROFILE_NICKNAME, PROFILE_PHOTO;
  List<dynamic> PHOTO, FILE;
  bool FILE_DOWNLOADED, FILE_DOWNLOADING;
  DateTime TIME_CREATED;
  int CHAT_ID, BOX_ID;
  bool MY_SELF;

  ChatModel(
      {BOX_ID,
      CONTENT,
      PHOTO,
      PROFILE_NICKNAME,
      PROFILE_PHOTO,
      TIME_CREATED,
      CHAT_ID,
      MY_SELF,
      FILE});

  Map<String, dynamic> toJson() {
    return {
      'BOX_ID': BOX_ID,
      'CONTENT': CONTENT,
      'PHOTO': PHOTO,
      'PROFILE_NICKNAME': PROFILE_NICKNAME,
      'PROFILE_PHOTO': PROFILE_PHOTO,
      'TIME_CREATED': TIME_CREATED,
      'CHAT_ID': CHAT_ID,
      'MY_SELF': MY_SELF,
      "FILE": FILE,
    };
  }

  ChatModel.fromJson(Map<String, dynamic> json) {
    this.BOX_ID = nullCheck(json["BOX_ID"]);
    this.CONTENT = nullCheck("${json["CONTENT"]}");
    if (json["PHOTO"] == null) {
      this.PHOTO = null;
    } else if (json["PHOTO"].runtimeType.toString() == "String") {
      this.PHOTO = jsonDecode(json["PHOTO"]);
    } else {
      this.PHOTO = json["PHOTO"];
    }

    if (json["FILE"] == null) {
      this.FILE = null;
      this.FILE_DOWNLOADED = false;
    } else {
      if (json["FILE"].runtimeType.toString() == "String") {
        this.FILE = jsonDecode(json["FILE"]);
      } else {
        this.FILE = json["FILE"];
      }

      if (this.FILE.length > 0) {
        this.FILE_DOWNLOADED = box.read(this.FILE[0]) == null ? false : true;
      } else {
        this.FILE_DOWNLOADED = false;
      }
    }
    this.FILE_DOWNLOADING = false;

    this.PROFILE_NICKNAME = nullCheck(json["PROFILE_NICKNAME"]);
    this.PROFILE_PHOTO = nullCheck(json["PROFILE_PHOTO"]);
    this.TIME_CREATED = nullCheck(DateTime.parse(json["TIME_CREATED"]));
    this.CHAT_ID = nullCheck(json["CHAT_ID"]);

    this.MY_SELF = json["MY_SELF"] == null ? false : nullCheck(json["MY_SELF"]);
  }
}
