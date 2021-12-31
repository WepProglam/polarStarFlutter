class Post {
  int DEPTH;
  String TITLE;
  String CONTENT;
  int UNNAMED;
  int LIKES;
  int SCRAPS;
  List<dynamic> PHOTO;
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
    this.PHOTO = nullCheck(json["PHOTO"]);
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
