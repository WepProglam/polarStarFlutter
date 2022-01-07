import 'dart:collection';

import 'dart:developer';

import 'package:polarstar_flutter/app/data/model/main_model.dart';

class ClassChatModel {
  String CLASS_ID, CONTENT, PHOTO, USERNAME;
  DateTime TIME_CREATED;
  bool MY_SELF;

  ClassChatModel({
    CLASS_ID,
    CONTENT,
    PHOTO,
    USERNAME,
    TIME_CREATED,
    MY_SELF,
  });

  ClassChatModel.fromJson(Map<String, dynamic> json) {
    this.CLASS_ID = nullCheck("${json["CLASS_ID"]}");
    this.CONTENT = nullCheck("${json["CONTENT"]}");

    this.PHOTO = nullCheck(json["PHOTO"]);
    this.USERNAME = nullCheck(json["USERNAME"]);
    this.TIME_CREATED = nullCheck(DateTime.parse(json["TIME_CREATED"]));

    this.MY_SELF = json["MY_SELF"] == null ? false : nullCheck(json["MY_SELF"]);
  }
}
