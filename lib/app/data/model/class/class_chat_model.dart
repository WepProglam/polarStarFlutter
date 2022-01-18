import 'dart:collection';

import 'dart:developer';

import 'package:polarstar_flutter/app/data/model/main_model.dart';

class ClassChatModel {
  String CONTENT, PHOTO, PROFILE_NICKNAME, PROFILE_PHOTO;
  DateTime TIME_CREATED;
  int CHAT_ID, CLASS_ID;
  bool MY_SELF;

  ClassChatModel({
    CLASS_ID,
    CONTENT,
    PHOTO,
    PROFILE_NICKNAME,
    PROFILE_PHOTO,
    TIME_CREATED,
    CHAT_ID,
    MY_SELF,
  });

  Map<String, dynamic> toJson() {
    return {
      'CLASS_ID': CLASS_ID,
      'CONTENT': CONTENT,
      'PHOTO': PHOTO,
      'PROFILE_NICKNAME': PROFILE_NICKNAME,
      'PROFILE_PHOTO': PROFILE_PHOTO,
      'TIME_CREATED': TIME_CREATED,
      'CHAT_ID': CHAT_ID,
      'MY_SELF': MY_SELF,
    };
  }

  ClassChatModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_ID = nullCheck(json["CLASS_ID"]);
    this.CONTENT = nullCheck("${json["CONTENT"]}");

    this.PHOTO = nullCheck(json["PHOTO"]);
    this.PROFILE_NICKNAME = nullCheck(json["PROFILE_NICKNAME"]);
    this.PROFILE_PHOTO = nullCheck(json["PROFILE_PHOTO"]);
    this.TIME_CREATED = nullCheck(DateTime.parse(json["TIME_CREATED"]));
    this.CHAT_ID = nullCheck(json["CHAT_ID"]);

    this.MY_SELF = json["MY_SELF"] == null ? false : nullCheck(json["MY_SELF"]);
  }
}
