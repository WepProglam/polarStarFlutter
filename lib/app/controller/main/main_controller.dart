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
  RxList<BoardInfo> totalBoardInfo = <BoardInfo>[].obs;
  RxList<BoardInfo> boardListInfo = <BoardInfo>[].obs;

  RxBool _dataAvailable = false.obs;
  RxInt mainPageIndex = 0.obs;

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
    final value = await repository.getBoardInfo();
    totalBoardInfo.clear();
    boardListInfo.clear();

    hotBoard.value = value["hotBoard"];

    for (BoardInfo item in value["boardInfo"]) {
      totalBoardInfo.add(item);
      boardListInfo.add(item);
    }

    totalBoardInfo.addAll([
      BoardInfo.fromJson({"COMMUNITY_ID": 1, "COMMUNITY_NAME": "취업"}),
      BoardInfo.fromJson({"COMMUNITY_ID": 2, "COMMUNITY_NAME": "알바"}),
      BoardInfo.fromJson({"COMMUNITY_ID": 3, "COMMUNITY_NAME": "공모전"}),
    ]);

    box.write("boardInfo", totalBoardInfo);
    _dataAvailable.value = true;
  }

  Future<void> deleteFollowingCommunity(int COMMUNITY_ID) async {
    await _dbHelper.delete(COMMUNITY_ID);
    await getFollowingCommunity();
  }

  Future<void> getFollowingCommunity() async {
    List<Rx<BoardInfo>> follwing = await _dbHelper.queryAllRows();
    boardInfo.clear();
    boardInfo.value = follwing;
  }

  Future<void> setFollowingCommunity(
      int COMMUNITY_ID, String COMMUNITY_NAME) async {
    await _dbHelper.insert(BoardInfo.fromJson({
      "COMMUNITY_ID": COMMUNITY_ID,
      "COMMUNITY_NAME": COMMUNITY_NAME,
    }));

    await getFollowingCommunity();
  }

  @override
  onInit() async {
    super.onInit();
    await getBoardInfo();
    await getFollowingCommunity();
  }

  @override
  onClose() async {
    super.onClose();
    _dataAvailable.value = false;
  }

  bool get dataAvailalbe => _dataAvailable.value;
}
