import 'package:flutter/foundation.dart';
import 'package:string_validator/string_validator.dart';

class BoardInfo {
  String COMMUNITY_NAME, RECENT_TITLE;
  int COMMUNITY_ID;
  bool isFollowed;

  BoardInfo({COMMUNITY_NAME, COMMUNITY_ID, RECENT_TITLE, isFollowed});

  BoardInfo.fromJson(Map<String, dynamic> json) {
    this.COMMUNITY_NAME = json['COMMUNITY_NAME'];
    this.COMMUNITY_ID = json['COMMUNITY_ID'];
    this.RECENT_TITLE = json["RECENT_TITLE"];
    this.isFollowed = toBoolean("${json["isFollowed"]}");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['COMMUNITY_NAME'] = "${this.COMMUNITY_NAME}";
    data['COMMUNITY_ID'] = "${this.COMMUNITY_ID}";
    data["RECENT_TITLE"] = "${this.RECENT_TITLE}";
    data["isFollowed"] = "${this.isFollowed}";
    return data;
  }
}

class HotBoard {
  String TITLE;
  String CONTENT;
  int COMMUNITY_ID;
  String COMMUNITY_NAME;
  int UNNAMED;
  int LIKES;
  int SCRAPS;
  int COMMENTS;
  String TIME_CREATED;
  int BOARD_ID;
  String PROFILE_NICKNAME;
  String PROFILE_PHOTO;
  List<dynamic> PHOTO;

  HotBoard(
      {TITLE,
      CONTENT,
      COMMUNITY_ID,
      COMMUNITY_NAME,
      UNNAMED,
      LIKES,
      SCRAPS,
      COMMENTS,
      TIME_CREATED,
      BOARD_ID,
      PROFILE_NICKNAME,
      PROFILE_PHOTO,
      PHOTO});

  HotBoard.fromJson(Map<String, dynamic> json) {
    this.TITLE = json["TITLE"];
    this.CONTENT = json["CONTENT"];
    this.COMMUNITY_ID = json["COMMUNITY_ID"];
    this.COMMUNITY_NAME = json["COMMUNITY_NAME"];
    this.UNNAMED = json["UNNAMED"];
    this.LIKES = json["LIKES"];
    this.SCRAPS = json["SCRAPS"];
    this.COMMENTS = json["COMMENTS"];
    this.TIME_CREATED = json["TIME_CREATED"];
    this.BOARD_ID = json["BOARD_ID"];
    this.PROFILE_NICKNAME = json["PROFILE_NICKNAME"];
    this.PROFILE_PHOTO = json["PROFILE_PHOTO"];
    this.PHOTO = json["PHOTO"];
  }
}

class LikeListModel {
  int COMMUNITY_ID, UNIQUE_ID;

  LikeListModel({COMMUNITY_ID, UNIQUE_ID});

  LikeListModel.fromJson(Map<String, dynamic> json) {
    this.COMMUNITY_ID = json["COMMUNITY_ID"];
    this.UNIQUE_ID = json["UNIQUE_ID"];
  }
}

class ScrapListModel {
  int COMMUNITY_ID, UNIQUE_ID;

  ScrapListModel({COMMUNITY_ID, UNIQUE_ID});

  ScrapListModel.fromJson(Map<String, dynamic> json) {
    this.COMMUNITY_ID = json["COMMUNITY_ID"];
    this.UNIQUE_ID = json["UNIQUE_ID"];
  }
} 
// class FollowCommunity {
//   int COMMUNITY_ID;
//   String COMMUNITY_NAME;

//   FollowCommunity({this.COMMUNITY_ID, this.COMMUNITY_NAME});

//   FollowCommunity.fromJson(Map<String, dynamic> json) {
//     this.COMMUNITY_ID = json["COMMUNITY_ID"];
//     this.COMMUNITY_NAME = json["COMMUNITY_NAME"];
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "COMMUNITY_ID": this.COMMUNITY_ID,
//       "COMMUNITY_NAME": this.COMMUNITY_NAME
//     };
//   }
// }
