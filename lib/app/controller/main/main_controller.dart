import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/database_helper.dart';
import 'package:polarstar_flutter/app/data/repository/main_repository.dart';

class MainController extends GetxController {
  final MainRepository repository;
  final box = GetStorage();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  MainController({@required this.repository}) : assert(repository != null);

  RxList<Rx<BoardInfo>> boardInfo = <Rx<BoardInfo>>[].obs;
  RxList<HotBoard> hotBoard = <HotBoard>[].obs;
  RxInt followAmount = 0.obs;

  RxList<BoardInfo> boardListInfo = <BoardInfo>[].obs;

  RxList<LikeListModel> likeList = <LikeListModel>[].obs;
  RxList<ScrapListModel> scrapList = <ScrapListModel>[].obs;

  RxBool _dataAvailable = false.obs;
  RxInt mainPageIndex = 0.obs;
  RxList<dynamic> followingCommunity = [].obs;

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
    final value = await repository.getBoardInfo(followingCommunity.value);
    boardListInfo.clear();

    hotBoard.value = value["hotBoard"];
    likeList.value = value["likeList"];
    scrapList.value = value["scrapList"];

    for (BoardInfo item in value["boardInfo"]) {
      boardListInfo.add(item);
      boardInfo.add(item.obs);
      print(item.COMMUNITY_NAME);
    }
    print("================================");
    print(boardInfo[0].value.isFollowed);

    box.write("boardInfo", boardListInfo);
    _dataAvailable.value = true;
  }

  Future<void> deleteFollowingCommunity(int COMMUNITY_ID) async {
    await _dbHelper.delete(COMMUNITY_ID);
    await getFollowingCommunity();
  }

  Future<void> getFollowingCommunity() async {
    List<Rx<BoardInfo>> follwing = await _dbHelper.queryAllRows();
    boardInfo.value = follwing;
    followAmount.value = follwing.length;
    followingCommunity.value =
        follwing.map((e) => "${e.value.COMMUNITY_ID}").toList();
  }

  Future<void> setFollowingCommunity(int COMMUNITY_ID, String COMMUNITY_NAME,
      String RECENT_TITLE, bool isFollowed) async {
    await _dbHelper.insert(BoardInfo.fromJson({
      "COMMUNITY_ID": COMMUNITY_ID,
      "COMMUNITY_NAME": COMMUNITY_NAME,
      "RECENT_TITLE": RECENT_TITLE,
      "isFollowed": isFollowed
    }));
    await getFollowingCommunity();
    // await _dbHelper.dropTable();
  }

  @override
  onInit() async {
    super.onInit();
    await getFollowingCommunity();
    await getBoardInfo();
  }

  @override
  onClose() async {
    super.onClose();
    _dataAvailable.value = false;
  }

  bool get dataAvailalbe => _dataAvailable.value;
}
