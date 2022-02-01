import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  int BOX_ID, CHAT_ID, LAST_READ_CHAT_ID, UNREAD_AMOUNT;
  DateTime TIME_LAST_CHAT_SENDED;
  RxList<Rx<ChatModel>> ChatList;
  RxList<Rx<ChatModel>> LoadingChatList;

  ChatBoxModel(
      {BOX_NAME,
      CLASS_PROFESSOR,
      LAST_CHAT,
      UNREAD_AMOUNT,
      BOX_ID,
      CHAT_ID,
      TIME_LAST_CHAT_SENDED});

  Map<String, dynamic> toJson() {
    // print("tojson called");
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
    this.UNREAD_AMOUNT = nullCheck(json["UNREAD_AMOUNT"]);
    //print("class_id: ${json["CLASS_ID"]}");
    this.CHAT_ID = nullCheck(json["CHAT_ID"]);
    this.BOX_ID = json["BOX_ID"];
    this.LAST_READ_CHAT_ID = nullCheck(json["LAST_READ_CHAT_ID"]);
    this.LAST_CHAT = json["LAST_CHAT"];
    //print(json["LAST_CHAT"]);
    this.TIME_LAST_CHAT_SENDED = json["TIME_LAST_CHAT_SENDED"] == null
        ? null
        : DateTime.parse(json["TIME_LAST_CHAT_SENDED"]);
    this.ChatList = json["ChatList"] != null
        ? json["ChatList"].map((e) => ChatModel.fromJson(e).obs).toList().obs
        : <Rx<ChatModel>>[].obs;

    this.LoadingChatList = <Rx<ChatModel>>[].obs;
  }
}

class ChatModel {
  String CONTENT, PROFILE_NICKNAME, PROFILE_PHOTO;
  String ENTRY_CHAT;
  List<dynamic> PHOTO, FILE;
  List<FileMetalModel> FILE_META;
  List<PhotoMetaModel> PHOTO_META;
  List<Image> PRE_IMAGE;
  // List<Image> PRE_CACHE_IMAGE;
  bool FILE_DOWNLOADED, FILE_DOWNLOADING;
  int FILE_PROGRESS;
  String FILE_TID;
  DateTime TIME_CREATED;
  int CHAT_ID, BOX_ID;
  bool MY_SELF, IS_PRE_SEND;

  ChatModel(
      {BOX_ID,
      CONTENT,
      PHOTO,
      PROFILE_NICKNAME,
      PROFILE_PHOTO,
      TIME_CREATED,
      CHAT_ID,
      MY_SELF,
      FILE_META,
      PHOTO_META,
      ENTRY_CHAT,
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
      'FILE_META': FILE_META,
      'PHOTO_META': PHOTO_META,
      'MY_SELF': MY_SELF,
      "FILE": FILE,
      "ENTRY_CHAT": ENTRY_CHAT
    };
  }

  ChatModel.fromJson(Map<String, dynamic> json) {
    this.IS_PRE_SEND = json["IS_PRE_SEND"] == null ? false : true;
    this.ENTRY_CHAT = nullCheck(json["ENTRY_CHAT"]);

    this.BOX_ID = nullCheck(json["BOX_ID"]);
    this.CONTENT = nullCheck("${json["CONTENT"]}");
    if (json["PHOTO"] == null) {
      this.PHOTO = null;
    } else {
      if (json["PHOTO"].runtimeType.toString() == "String") {
        this.PHOTO = jsonDecode(json["PHOTO"]);
      } else {
        this.PHOTO = json["PHOTO"];
      }

      if (json["PHOTO_META"] == null || json["PHOTO_META"].isEmpty) {
        this.PHOTO_META = null;
      } else {
        List<dynamic> temp = [];
        if (json["PHOTO_META"].runtimeType == String) {
          temp = jsonDecode(json["PHOTO_META"]);
        } else {
          temp = json["PHOTO_META"];
        }
        //print(temp);
        this.PHOTO_META = [PhotoMetaModel.fromJson(temp[0])];
      }

      if (this.PHOTO.length > 0) {
        if (this.IS_PRE_SEND) {
          this.PRE_IMAGE = json["PRE_IMAGE"];
        } else {
          String httpUrl = this.PHOTO[0].split("s://")[0] +
              "://" +
              this.PHOTO[0].split("s://")[1];
          this.PRE_IMAGE = [
            Image(
              width: this.PHOTO_META[0].IMAGE_WIDTH,
              height: this.PHOTO_META[0].IMAGE_HIEGHT,
              image: CachedNetworkImageProvider(httpUrl, scale: 1.0),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return Container(
                      width: this.PHOTO_META[0].IMAGE_WIDTH,
                      height: this.PHOTO_META[0].IMAGE_HIEGHT,
                      child: child);
                }
                return Container(
                  color: Colors.white12,
                  width: this.PHOTO_META[0].IMAGE_WIDTH,
                  height: this.PHOTO_META[0].IMAGE_HIEGHT,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  ),
                );
              },
              gaplessPlayback: true,
            )
          ];
        }

        // this.PRE_CACHE_IMAGE = [
        //   Image.network(
        //     this.PHOTO[0],
        //     gaplessPlayback: true,
        //   )
        // ];
      }
    }

    // else if (json["PHOTO_META"].runtimeType == String) {
    //   this.PHOTO_META = jsonDecode(json["PHOTO_META"]);
    // } else {
    //   this.PHOTO_META = json["PHOTO_META"];
    // }

    if (json["FILE_META"] == null ||
        json["FILE_META"].isEmpty ||
        json["FILE_META"] == "[]") {
      this.FILE_META = null;
    } else {
      List<dynamic> temp = [];
      if (json["FILE_META"].runtimeType == String) {
        temp = jsonDecode(json["FILE_META"]);
      } else {
        temp = json["FILE_META"];
      }
      // print(json["FILE_META"]);
      // print(temp);
      this.FILE_META = [FileMetalModel.fromJson(temp[0])];
    }

    if (json["FILE"] == null) {
      this.FILE = null;
      this.FILE_DOWNLOADED = false;
    } else {
      try {
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
      } catch (e) {
        this.FILE = null;
      }
    }
    this.FILE_DOWNLOADING = false;
    this.FILE_PROGRESS = 0;
    this.FILE_TID = null;

    this.PROFILE_NICKNAME = nullCheck(json["PROFILE_NICKNAME"]);
    this.PROFILE_PHOTO = nullCheck(json["PROFILE_PHOTO"]);
    this.TIME_CREATED = nullCheck(DateTime.parse(json["TIME_CREATED"]));
    this.CHAT_ID = nullCheck(json["CHAT_ID"]);

    this.MY_SELF = json["MY_SELF"] == null ? false : nullCheck(json["MY_SELF"]);
  }
}

class FileMetalModel {
  String FILE_NAME, EXPIRE;
  int FILE_SIZE;

  FileMetalModel({this.FILE_NAME, this.EXPIRE, this.FILE_SIZE});

  FileMetalModel.fromJson(Map<String, dynamic> json) {
    this.FILE_NAME = json["file_name"];
    this.FILE_SIZE = json["file_size"];
    this.EXPIRE = json["expire"];
  }
}

class ChatPrifileModel {
  String PROFILE_NICKNAME, PROFILE_PHOTO;
  bool MY_SELF;

  ChatPrifileModel({this.PROFILE_NICKNAME, this.PROFILE_PHOTO, this.MY_SELF});

  ChatPrifileModel.fromJson(Map<String, dynamic> json) {
    this.PROFILE_NICKNAME = json["PROFILE_NICKNAME"];
    this.PROFILE_PHOTO = json["PROFILE_PHOTO"];
    this.MY_SELF = json["MY_SELF"];
  }
}

class PhotoMetaModel {
  int PIXEL_HEIGHT, PIXEL_WIDTH;
  String PHOTO_NAME;
  double IMAGE_HIEGHT, IMAGE_WIDTH;

  PhotoMetaModel({this.PIXEL_HEIGHT, this.PIXEL_WIDTH, this.PHOTO_NAME});

  PhotoMetaModel.fromJson(Map<String, dynamic> json) {
    this.PIXEL_HEIGHT = json["pixel_height"];
    this.PIXEL_WIDTH = json["pixel_width"];
    this.PHOTO_NAME = json["photo_name"];
    double image_height, image_width;
    if (this.PIXEL_WIDTH > 200) {
      image_height = (200 * this.PIXEL_HEIGHT) / this.PIXEL_WIDTH.toDouble();
      image_width = 200;
      bool isHeightNormal = !image_height.isNaN;
      image_height = isHeightNormal ? image_height : 200;
    } else {
      image_height = this.PIXEL_HEIGHT * 1.0;
      image_width = this.PIXEL_WIDTH * 1.0;
    }

    this.IMAGE_HIEGHT = image_height;
    this.IMAGE_WIDTH = image_width;
  }
}
