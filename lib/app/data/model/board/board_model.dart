class Board {
  int BOARD_ID, COMMUNITY_ID;

  String TITLE, CONTENT;

  int LIKES, SCRAPS, COMMENTS;

  String PHOTO;

  String TIME_CREATED, TIME_UPDATED;
  int IS_UPDATED;

  String PROFILE_NICKNAME, PROFILE_PHOTO;

  Board(
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

  Board.fromJson(Map<String, dynamic> json) {
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
