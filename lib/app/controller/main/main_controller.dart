import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/database_helper.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/src/db_community.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_repository.dart';
import 'package:polarstar_flutter/app/ui/android/class/class.dart';

class MainController extends GetxController {
  final MainRepository repository;
  final box = GetStorage();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  MainController({@required this.repository}) : assert(repository != null);

  RxList<Rx<BoardInfo>> boardInfo = <Rx<BoardInfo>>[].obs;
  RxList<Rx<Post>> hotBoard = <Rx<Post>>[].obs;
  RxInt hotBoardIndex = 0.obs;
  RxInt followAmount = 0.obs;
  Rx<Color> statusBarColor = Colors.white.obs;

  RxList<BoardInfo> boardListInfo = <BoardInfo>[].obs;

  RxList<LikeListModel> likeList = <LikeListModel>[].obs;
  RxList<ScrapListModel> scrapList = <ScrapListModel>[].obs;
  RxList<MainClassModel> classList = <MainClassModel>[].obs;

  RxBool isLikeScrapUpdate = false.obs;

  RxBool _dataAvailable = false.obs;
  RxInt mainPageIndex = 0.obs;
  RxList<String> followingCommunity = <String>[].obs;

  List<Color> classColorList = [
    Color(0xff1a785c),
    Color(0xff983280),
    Color(0xffcfa01f),
    Color(0xff78431a),
    Color(0xff781a59),
    Color(0xff1a4678),
    Color(0xff66259f),
    Color(0xff9e3d3d),
    Color(0xff2f3c94),
    Color(0xff409282)
  ];

  List<String> classIconList = [
    "assets/images/class_1.png",
    "assets/images/class_2.png",
    "assets/images/class_3.png",
    "assets/images/class_4.png",
    "assets/images/class_5.png",
    "assets/images/class_6.png",
    "assets/images/class_7.png",
    "assets/images/class_8.png",
    "assets/images/class_9.png",
    "assets/images/class_10.png",
  ];

  // var animationController = AnimationController().obs;
  var pageController = PageController().obs;

  Future<void> createCommunity(
      String COMMUNITY_NAME, String COMMUNITY_DESCRIPTION) async {
    var status =
        await repository.createCommunity(COMMUNITY_NAME, COMMUNITY_DESCRIPTION);

    switch (status["status"]) {
      case 200:
        Get.snackbar("생성 요청 성공", "생성 요청 성공");
        break;
      default:
        Get.snackbar("이미 생성되어있는 게시판입니다.", "이미 생성되어있는 게시판입니다.");
    }
    print(status["status"]);
  }

  Future<void> getBoardInfo() async {
    final value = await repository.getBoardInfo(followingCommunity);
    boardListInfo.clear();
    boardInfo.clear();

    print(value);
    print("=------------------------------------------------");

    hotBoard.value = value["hotBoard"];
    likeList.value = value["likeList"];
    scrapList.value = value["scrapList"];
    classList.value = value["classList"];

    for (MainClassModel model in classList) {
      print("${model.CLASS_NAME}: ${model.CLASS_ID}");
    }

    for (BoardInfo item in value["boardInfo"]) {
      boardListInfo.add(item);
      boardInfo.add(item.obs);
    }

    box.write("boardInfo", boardListInfo);
    box.write("likeList", likeList);
    box.write("scrapList", scrapList);
    _dataAvailable.value = true;
  }

  Future<void> deleteFollowingCommunity(int COMMUNITY_ID) async {
    await COMMUNITY_DB_HELPER.delete(COMMUNITY_ID);
    await getFollowingCommunity();
  }

  Future<void> getFollowingCommunity() async {
    List<Rx<BoardInfo>> follwing = await COMMUNITY_DB_HELPER.queryAllRows();
    print(follwing);
    followAmount.value = follwing.length;
    followingCommunity.value =
        follwing.map((e) => "${e.value.COMMUNITY_ID}").toList();
  }

  Future<void> setFollowingCommunity(int COMMUNITY_ID, String COMMUNITY_NAME,
      String RECENT_TITLE, bool isFollowed) async {
    await COMMUNITY_DB_HELPER.insert(BoardInfo.fromJson({
      "COMMUNITY_ID": COMMUNITY_ID,
      "COMMUNITY_NAME": COMMUNITY_NAME,
      "RECENT_TITLE": RECENT_TITLE,
      "isFollowed": isFollowed
    }));
    await getFollowingCommunity();
    // await _dbHelper.dropTable();
  }

  Future<void> refreshLikeList() async {
    List<LikeListModel> value = await repository.refreshLikeList();
    likeList.value = value;
    print("refresh like");
    return;
  }

  Future<void> refreshScrapList() async {
    List<ScrapListModel> value = await repository.refreshScrapList();
    scrapList.value = value;
    print("refresh scrap");
    return;
  }

  void swipeLeftHotBoard() {
    hotBoardIndex.value = (hotBoardIndex.value + 1) % (hotBoard.length);
  }

  void swipeRightHotBoard() {
    hotBoardIndex.value =
        (hotBoard.length - (hotBoardIndex.value - 1)) % (hotBoard.length);
  }

  bool isScrapped(Post c) {
    for (int i = 0; i < scrapList.length; i++) {
      final bool bidSame = (scrapList[i].UNIQUE_ID == c.BOARD_ID);
      final bool cidSame = (scrapList[i].COMMUNITY_ID == c.COMMUNITY_ID);
      if (cidSame && bidSame) {
        return true;
      }
    }
    print("false");

    return false;
  }

  bool isLiked(Post c) {
    for (int i = 0; i < likeList.length; i++) {
      final bool bidSame = (likeList[i].UNIQUE_ID == c.BOARD_ID);
      final bool cidSame = (likeList[i].COMMUNITY_ID == c.COMMUNITY_ID);
      if (cidSame && bidSame) {
        return true;
      }
    }
    print("false");

    return false;
  }

  @override
  onInit() async {
    super.onInit();
    print("getFollowingCommunity");
    await getFollowingCommunity();

    // pageController.value.addListener(() {});

    await getBoardInfo();
  }

  @override
  onClose() async {
    super.onClose();
    _dataAvailable.value = false;
  }

  bool get dataAvailalbe => _dataAvailable.value;
}

class MainUpdateModule {
  static Future<void> updatePost() async {
    final BoardController boardController = Get.find();
    final PostController postController = Get.find();
    final MainController mainController = Get.find();

    await postController.refreshPost();
    Post item = postController.sortedList[0].value;

    // * 게시판 페이지 업데이트
    Rx<Post> board = findSame(item, boardController.postBody);
    changeTargetPost(board, item);

    // * 메인 핫보드 업데이트
    Rx<Post> hotBoard = findSame(item, mainController.hotBoard);
    changeTargetPost(hotBoard, item);

    // Todo: 마이페이지 업데이트
  }

  static Future<void> updateHotMain() async {
    final BoardController boardController = Get.find();
    await boardController.refreshHotPage();
    return;
  }

  static Future<void> updateBoard() async {
    final BoardController boardController = Get.find();
    await boardController.refreshPage();
    return;
  }

  static void changeTargetPost(Rx<Post> target, Post item) {
    if (target != null) {
      target.update((val) {
        val.COMMENTS = item.COMMENTS;
        val.LIKES = item.LIKES;
        val.SCRAPS = item.SCRAPS;
      });
    }
    return;
  }

  // * private
  static Rx<Post> findSame(Post item, RxList<Rx<Post>> postList) {
    for (Rx<Post> a in postList) {
      if (a.value.BOARD_ID == item.BOARD_ID &&
          a.value.COMMUNITY_ID == item.COMMUNITY_ID) {
        return a;
      }
    }
    return null;
  }
}
