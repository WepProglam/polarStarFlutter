import 'package:flutter/foundation.dart';

class BoardInfo {
  String COMMUNITY_NAME;
  int COMMUNITY_ID;

  BoardInfo({COMMUNITY_NAME, COMMUNITY_ID});

  BoardInfo.fromJson(Map<String, dynamic> json) {
    this.COMMUNITY_NAME = json['COMMUNITY_NAME'];
    this.COMMUNITY_ID = json['COMMUNITY_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['COMMUNITY_NAME'] = this.COMMUNITY_NAME;
    data['COMMUNITY_ID'] = this.COMMUNITY_ID;
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
      PROFILE_PHOTO});

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
