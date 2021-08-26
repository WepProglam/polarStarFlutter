class Post {
  int DEPTH;
  String TITLE;
  String CONTENT;
  int UNNAMED;
  int LIKES;
  int SCRAPS;
  String PHOTO;
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
    this.DEPTH = json["DEPTH"];
    this.TITLE = json["TITLE"];
    this.CONTENT = json["CONTENT"];
    this.UNNAMED = json["UNNAMED"];
    this.TIME_CREATED = json["TIME_CREATED"];
    this.TIME_UPDATED = json["TIME_UPDATED"];
    this.LIKES = json["LIKES"];
    this.SCRAPS = json["SCRAPS"];
    this.PARENT_ID = json["PARENT_ID"];
    this.PHOTO = json["PHOTO"];
    this.IS_UPDATED = json["IS_UPDATED"];
    this.UNIQUE_ID = json["UNIQUE_ID"];
    this.COMMUNITY_ID = json["COMMUNITY_ID"];
    this.COMMENTS = json["COMMENTS"];
    this.PROFILE_NICKNAME = json["PROFILE_NICKNAME"];
    this.PROFILE_PHOTO = json["PROFILE_PHOTO"];
    this.MYSELF = json["MYSELF"];
    this.BOARD_ID = json["BOARD_ID"];
  }
}
