import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MyProfileModel {
  String LOGIN_ID, PROFILE_PHOTO, PROFILE_NICKNAME, PROFILE_MESSAGE;
  String CAMPUS_NAME, MAJOR_NAME, DOUBLE_MAJOR_NAME;
  int CAMPUS_ID;

  MyProfileModel(
      {this.LOGIN_ID,
      this.PROFILE_NICKNAME,
      this.PROFILE_MESSAGE,
      this.PROFILE_PHOTO,
      this.DOUBLE_MAJOR_NAME,
      this.MAJOR_NAME,
      this.CAMPUS_NAME,
      this.CAMPUS_ID});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
    this.LOGIN_ID = json["LOGIN_ID"];
    this.PROFILE_NICKNAME = json["PROFILE_NICKNAME"];
    this.PROFILE_MESSAGE = json["PROFILE_MESSAGE"];
    this.MAJOR_NAME = json["MAJOR_NAME"];
    this.DOUBLE_MAJOR_NAME = json["DOUBLE_MAJOR_NAME"];
    this.PROFILE_PHOTO = json["PROFILE_PHOTO"];
    this.CAMPUS_NAME = json["CAMPUS_NAME"];
    this.CAMPUS_ID = json["CAMPUS_ID"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PROFILE_NICKNAME'] = this.PROFILE_NICKNAME;
    data['PROFILE_MESSAGE'] = this.PROFILE_MESSAGE;
    return data;
  }
}

class MyPageBoardModel {
  int BOARD_ID, COMMUNITY_ID;
  String TITLE, CONTENT;
  int LIKES, SCRAPS, COMMENTS;
  List<dynamic> PHOTO;
  String TIME_CREATED, TIME_UPDATED;
  int IS_UPDATED;
  String PROFILE_NICKNAME, PROFILE_PHOTO;

  MyPageBoardModel(
    Set set, {
    BOARD_ID,
    COMMUNITY_ID,
    TITLE,
    CONTENT,
    LIKES,
    SCRAPS,
    COMMENTS,
    PHOTO,
    TIME_CREATED,
    TIME_UPDATED,
    IS_UPDATED,
    PROFILE_NICKNAME,
    PROFILE_PHOTO,
  });

  MyPageBoardModel.fromJson(Map<String, dynamic> json) {
    this.TITLE = json["TITLE"];
    this.CONTENT = json["CONTENT"];

    this.TIME_CREATED = json["TIME_CREATED"];
    this.TIME_UPDATED = json["TIME_UPDATED"];
    this.LIKES = json["LIKES"];
    this.SCRAPS = json["SCRAPS"];

    this.PHOTO = json["PHOTO"];
    this.IS_UPDATED = json["IS_UPDATED"];

    this.COMMUNITY_ID = json["COMMUNITY_ID"];
    this.COMMENTS = json["COMMENTS"];
    this.PROFILE_NICKNAME = json["PROFILE_NICKNAME"];
    this.PROFILE_PHOTO = json["PROFILE_PHOTO"];

    this.BOARD_ID = json["BOARD_ID"];
  }
}
