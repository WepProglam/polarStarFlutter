import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:polarstar_flutter/app/global_functions/photoOrVideo.dart';

import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Post {
  int DEPTH;
  String TITLE;
  String CONTENT;
  int UNNAMED;
  int LIKES;
  int SCRAPS;
  List<dynamic> PHOTO_URL;
  List<POST_MEDIA> MEDIA;
  // List<VideoPlayer> VIDEO;
  // List<Image> PHOTO;

  int UNIQUE_ID;
  int COMMUNITY_ID;
  int COMMENTS;
  int PARENT_ID;
  int BOARD_ID;

  String TIME_CREATED;
  String TIME_UPDATED;
  int IS_UPDATED;

  String PROFILE_NICKNAME;
  String PROFILE_PHOTO;

  bool MYSELF;
  bool isScraped;
  bool isLiked;

  Post(
      {DEPTH,
      TITLE,
      CONTENT,
      UNNAMED,
      TIME_CREATED,
      TIME_UPDATED,
      LIKES,
      SCRAPS,
      PHOTO,
      IS_UPDATED,
      UNIQUE_ID,
      COMMUNITY_ID,
      COMMENTS,
      PARENT_ID,
      PROFILE_NICKNAME,
      PROFILE_PHOTO,
      BOARD_ID,
      MYSELF});

  Post.fromJson(Map<String, dynamic> json) {
    this.DEPTH = nullCheck(json["DEPTH"]);
    this.TITLE = nullCheck(json["TITLE"]);
    this.CONTENT = nullCheck(json["CONTENT"]);
    this.UNNAMED = nullCheck(json["UNNAMED"]);
    this.TIME_CREATED = nullCheck(json["TIME_CREATED"]);
    this.TIME_UPDATED = nullCheck(json["TIME_UPDATED"]);
    this.LIKES = nullCheck(json["LIKES"]);
    this.SCRAPS = nullCheck(json["SCRAPS"]);
    this.PARENT_ID = nullCheck(json["PARENT_ID"]);
    this.PHOTO_URL = nullCheck(json["PHOTO"]) == null ? [] : json["PHOTO"];
    this.MEDIA = [];

    this.IS_UPDATED = nullCheck(json["IS_UPDATED"]);
    this.UNIQUE_ID = nullCheck(json["UNIQUE_ID"]);
    this.COMMUNITY_ID = nullCheck(json["COMMUNITY_ID"]);
    this.COMMENTS = nullCheck(json["COMMENTS"]);
    this.PROFILE_NICKNAME = nullCheck(json["PROFILE_NICKNAME"]);
    this.PROFILE_PHOTO = nullCheck(json["PROFILE_PHOTO"]);
    this.MYSELF = nullCheck(json["MYSELF"]);
    this.BOARD_ID = nullCheck(json["BOARD_ID"]);
    this.isScraped = false;
    this.isLiked = false;
  }

  dynamic nullCheck(dynamic a) {
    return a == null ? null : a;
  }
}

class POST_MEDIA {
  VideoPlayerController VIDEO;
  Image PHOTO;
  bool isVideo;
  String URL;
  Duration VIDEO_POS, VIDEO_TOTAL;

  POST_MEDIA(
      {this.VIDEO,
      this.PHOTO,
      this.isVideo,
      this.VIDEO_POS,
      this.VIDEO_TOTAL,
      this.URL});

  // POST_MEDIA.fromJson(Map<String, dynamic> json) {

  //   this.PHOTO = ;
  //   this.VIDEO = ;

  // }

}
