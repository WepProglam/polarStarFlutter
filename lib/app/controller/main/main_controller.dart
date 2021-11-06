import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
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
  RxList<HotBoard> hotBoard = <HotBoard>[].obs;
  RxInt hotBoardIndex = 0.obs;
  RxInt followAmount = 0.obs;
  Rx<Color> statusBarColor = Colors.white.obs;

  RxList<BoardInfo> boardListInfo = <BoardInfo>[].obs;

  RxList<LikeListModel> likeList = <LikeListModel>[].obs;
  RxList<ScrapListModel> scrapList = <ScrapListModel>[].obs;
  RxList<MainClassModel> classList = <MainClassModel>[].obs;

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
    box.write("likeList", likeList.value);
    box.write("scrapList", scrapList.value);
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

  void swipeLeftHotBoard() {
    hotBoardIndex.value = (hotBoardIndex.value + 1) % (hotBoard.length);
  }

  void swipeRightHotBoard() {
    hotBoardIndex.value =
        (hotBoard.length - (hotBoardIndex.value - 1)) % (hotBoard.length);
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
