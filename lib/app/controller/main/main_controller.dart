import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/controller/class/class_controller.dart';
import 'package:polarstar_flutter/app/controller/loby/init_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/database_helper.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/src/db_community.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_repository.dart';
import 'package:polarstar_flutter/app/ui/android/class/class.dart';
import 'package:polarstar_flutter/app/ui/android/main/main_page.dart';
import 'package:polarstar_flutter/session.dart';

class MainController extends GetxController with SingleGetTickerProviderMixin {
  final MainRepository repository;
  final box = GetStorage();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  MainController({@required this.repository}) : assert(repository != null);

  RxList<Rx<BoardInfo>> boardInfo = <Rx<BoardInfo>>[].obs;
  RxList<Rx<BoardInfo>> selectedBoard = <Rx<BoardInfo>>[].obs;

  RxList<Rx<Post>> hotBoard = <Rx<Post>>[].obs;
  RxList<Rx<Post>> newBoard = <Rx<Post>>[].obs;
  RxInt hotBoardIndex = 0.obs;
  RxInt newBoardIndex = 0.obs;
  RxInt followAmount = 0.obs;
  Rx<Color> statusBarColor = Colors.white.obs;

  RxList<BoardInfo> boardListInfo = <BoardInfo>[].obs;

  RxList<LikeListModel> likeList = <LikeListModel>[].obs;
  RxList<ScrapListModel> scrapList = <ScrapListModel>[].obs;
  RxList<ClassModel> classList = <ClassModel>[].obs;

  RxBool isLikeScrapUpdate = false.obs;
  // RxBool isCurSemTimetableExist = false.obs;

  RxBool _dataAvailable = false.obs;
  RxInt mainPageIndex = 0.obs;
  RxList<String> followingCommunity = <String>[].obs;

  RxInt hotOrNewIndex = 0.obs;

  TabController hotNewTabController;
  // TabController tabController;
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

  void checkBoard(String text) {
    for (Rx<BoardInfo> item in boardInfo) {
      if (text == "") {
        item.update((val) {
          val.isChecked = true;
        });
      } else if (item.value.COMMUNITY_NAME.contains(text)) {
        item.update((val) {
          val.isChecked = true;
        });
      } else {
        item.update((val) {
          val.isChecked = false;
        });
      }
    }

    selectedBoard.clear();
    for (Rx<BoardInfo> item in boardInfo) {
      if (item.value.isChecked) {
        selectedBoard.add(item);
      }
    }

    sortBoard();
  }

  void sortBoard() {
    followingCommunity.sort((String a, String b) => a.compareTo(b));
    selectedBoard.sort((Rx<BoardInfo> a, Rx<BoardInfo> b) {
      if (a.value.isFollowed && b.value.isFollowed) {
        return a.value.COMMUNITY_ID.compareTo(b.value.COMMUNITY_ID);
      } else if (a.value.isFollowed && !b.value.isFollowed) {
        return -1;
      } else if (!a.value.isFollowed && b.value.isFollowed) {
        return 1;
      } else {
        return a.value.COMMUNITY_ID.compareTo(b.value.COMMUNITY_ID);
      }
    });

    boardInfo.sort((Rx<BoardInfo> a, Rx<BoardInfo> b) {
      if (a.value.isFollowed && b.value.isFollowed) {
        return a.value.COMMUNITY_ID.compareTo(b.value.COMMUNITY_ID);
      } else if (a.value.isFollowed && !b.value.isFollowed) {
        return -1;
      } else if (!a.value.isFollowed && b.value.isFollowed) {
        return 1;
      } else {
        return a.value.COMMUNITY_ID.compareTo(b.value.COMMUNITY_ID);
      }
    });

    // selectedBoard.sort((Rx<BoardInfo> a, Rx<BoardInfo> b) {
    //   return a.value.isFollowed
    //       ? 0
    //       : a.value.COMMUNITY_ID > b.value.COMMUNITY_ID
    //           ? 1
    //           : 2;
    // });

    // boardInfo.sort((Rx<BoardInfo> a, Rx<BoardInfo> b) {
    //   return a.value.isFollowed
    //       ? 0
    //       : a.value.COMMUNITY_ID > b.value.COMMUNITY_ID
    //           ? 1
    //           : 2;
    // });
  }

  Future<void> getNewBoard() async {
    Map<String, dynamic> response = await repository.getNewBoard(0);
    final int status = response["status"];
    final List<Rx<Post>> listBoard = response["listBoard"];

    switch (status) {
      case 200:
        if (newBoard.length == 0) {
          newBoard.clear();
        }
        newBoard(listBoard);
        break;
      default:
        break;
    }
  }

  // Future<void> getCurSemTimetableExist() async {
  //   int curYear = box.read("year_sem")["TIMETABLE_YEAR_FROM_DATE"];
  //   int curSem = box.read("year_sem")["TIMETABLE_SEMESTER_FROM_DATE"];
  //   final value = await Session().getX("/timetable/${curYear}/${curSem}");
  //   if (value.statusCode != 200) {
  //     isCurSemTimetableExist.value = false;
  //   } else {
  //     isCurSemTimetableExist.value = true;
  //   }
  // }

  Future<void> getBoardInfo() async {
    final value = await repository.getBoardInfo(followingCommunity);
    await getNewBoard();
    boardListInfo.clear();
    boardInfo.clear();

    // print(value);
    // print("=------------------------------------------------");

    hotBoard.value = value["hotBoard"];
    likeList.value = value["likeList"];
    scrapList.value = value["scrapList"];
    classList.value = value["classList"];

    box.write("year_sem", value["year_sem"]);
    box.write("MAX_BOARDS_LIMIT", value["MAX_BOARDS_LIMIT"]);

    print("MAX_BOARDS_LIMIT : ${value["MAX_BOARDS_LIMIT"]}");

    // print(value["year_sem"]["TIMETABLE_YEAR_FROM_DATE"]);
    // for (MainClassModel model in classList) {
    //   print("${model.CLASS_NAME}: ${model.CLASS_ID}");
    // }

    for (BoardInfo item in value["boardInfo"]) {
      boardListInfo.add(item);
      boardInfo.add(item.obs);
    }

    sortBoard();

    // 선택된 보드에 넣기
    selectedBoard.clear();
    for (Rx<BoardInfo> item in boardInfo) {
      if (item.value.isChecked) {
        selectedBoard.add(item);
      }
    }

    box.write("boardInfo", boardListInfo);
    // box.write("likeList", likeList);
    // box.write("scrapList", scrapList);
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

  Future<void> setFollowingCommunity(
      int COMMUNITY_ID,
      String COMMUNITY_NAME,
      String RECENT_TITLE,
      String RECENT_TIME,
      bool isFollowed,
      bool isNew) async {
    await COMMUNITY_DB_HELPER.insert(BoardInfo.fromJson({
      "COMMUNITY_ID": COMMUNITY_ID,
      "COMMUNITY_NAME": COMMUNITY_NAME,
      "RECENT_TITLE": RECENT_TITLE,
      "RECENT_TIME": RECENT_TIME,
      "isFollowed": isFollowed,
      "isNew": isNew
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
      final bool bidSame = (likeList[i].UNIQUE_ID == c.UNIQUE_ID);
      final bool cidSame = (likeList[i].COMMUNITY_ID == c.COMMUNITY_ID);
      if (cidSame && bidSame) {
        return true;
      }
    }

    return false;
  }

  @override
  void onInit() async {
    // tabController = TabController(vsync: this, length: 2);
    super.onInit();
    await getFollowingCommunity();
    await getBoardInfo();
    // await getCurSemTimetableExist();

    hotNewTabController = await TabController(vsync: this, length: 2);

    // ever(hotOrNewIndex, (_) {
    //   if (hotOrNewIndex.value == 0) {
    //   } else if (hotOrNewIndex.value == 1) {}
    // });

    initDataAvailable.value = true;
  }

  @override
  onClose() async {
    super.onClose();
    _dataAvailable.value = false;
  }

  RxBool initDataAvailable = false.obs;

  bool get dataAvailalbe => _dataAvailable.value;

  // RxList<Rx<BoardInfo>> get getSelectedBoard {
  //   selectedBoard.clear();
  //   for (Rx<BoardInfo> item in boardInfo) {
  //     if (item.value.isChecked) {
  //       selectedBoard.add(item);
  //     }
  //   }
  //   return selectedBoard;
  // }

  int get selectedBoardLength {
    int i = 0;
    for (Rx<BoardInfo> item in boardInfo) {
      if (item.value.isChecked) {
        i++;
      }
    }
    return i;
  }
}

class MainUpdateModule {
  static Future<void> updatePost({int type = 2}) async {
    final PostController postController = Get.find();
    await postController.refreshPost();
    return;
  }

  static Future<void> updateLikeList() async {
    MainController mc = Get.find();
    await mc.refreshLikeList();
    return;
  }

  static Future<void> updateScrapList() async {
    MainController mc = Get.find();
    await mc.refreshScrapList();
    return;
  }

  static Future<void> updateBoardListPage() async {
    MainController mc = Get.find();
    await mc.getBoardInfo();
    return;
  }

  static Future<void> updateBoardSearchPage() async {
    SearchController sc = Get.find();
    await sc.getSearchBoard();
    return;
  }

  static Future<void> updateClassPage() async {
    putController<ClassController>();
    ClassController cc = Get.find();
    await cc.refreshPage();
    return;
  }

  static Future<void> updateMyPage(int index) async {
    putController<MyPageController>();
    MyPageController mc = Get.find();
    if (index == 0) {
      await mc.getMineWrite();
    } else if (index == 1) {
      await mc.getMineScrap();
    } else {
      await mc.getMineLike();
    }
    return;
  }

  static Future<void> updateMainPage() async {
    putController<MainController>();
    MainController mc = Get.find();
    await mc.getBoardInfo();
    return;
  }

  static Future<void> updateNotiPage(int index, {int curClassID}) async {
    putController<NotiController>();
    final InitController initController = Get.find();

    NotiController nc = Get.find();
    if (index == 0) {
      await nc.getNoties();
    } else if (index == 1) {
      initController.countingAmount(curClassID);
      // await nc.getChatBox();
    } else {
      await nc.getMailBox();
    }
    return;
  }

  static Future<void> updateHotMain(int index) async {
    final BoardController boardController = Get.find();
    if (index == 0) {
      await boardController.refreshHotPage();
    } else {
      await boardController.refreshNewPage();
    }

    updateLikeList();
    updateScrapList();

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
