import 'dart:convert';
import 'dart:io';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import 'package:package_info/package_info.dart';

import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/modules/board/board_controller.dart';
import 'package:polarstar_flutter/app/modules/post/post_controller.dart';
import 'package:polarstar_flutter/app/modules/classChat/class_chat_controller.dart';
import 'package:polarstar_flutter/app/modules/class/class_controller.dart';
import 'package:polarstar_flutter/app/modules/class_search/class_search_controller.dart';
import 'package:polarstar_flutter/app/modules/init_page/init_controller.dart';

import 'package:polarstar_flutter/app/modules/noti/noti_controller.dart';

import 'package:polarstar_flutter/app/modules/mypage/mypage_controller.dart';

import 'package:polarstar_flutter/app/modules/board/search_controller.dart';
import 'package:polarstar_flutter/app/modules/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/database_helper.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/src/db_community.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_repository.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_page.dart';

import 'package:polarstar_flutter/app/global_widgets/dialoge.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:launch_review/launch_review.dart';

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
  RxInt MIN_CLASS_REVIEW_LENGTH = 30.obs;
  Rx<Color> statusBarColor = Colors.white.obs;
  bool isAlreadyRunned;
  RxMap profile = {}.obs;
  RxBool splashTransparent = true.obs;

  RxList<BoardInfo> boardListInfo = <BoardInfo>[].obs;

  RxList<LikeListModel> likeList = <LikeListModel>[].obs;
  RxList<ScrapListModel> scrapList = <ScrapListModel>[].obs;
  RxList<ClassModel> classList = <ClassModel>[].obs;
  RxList<BannerListModel> bannerList = <BannerListModel>[].obs;

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
        // * 게시판 생성 요청 성공
        Get.snackbar("创建论坛失败", "创建论坛失败",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
        break;
      default:
        Get.snackbar("该论坛已经存在了", "该论坛已经存在了",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
    }
    //print(status["status"]);
  }

  void checkBoard(String text) {
    //print("checkBoard?!");
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
    //print("############### ${isAlreadyRunned}");

    await getNewBoard();
    boardListInfo.clear();
    boardInfo.clear();

    // print(value);
    // print("=------------------------------------------------");

    hotBoard.value = value["hotBoard"];
    likeList.value = value["likeList"];
    scrapList.value = value["scrapList"];
    classList.value = value["classList"];
    profile.value = value["PROFILE"];
    bannerList.value = value["bannerList"];
    MIN_CLASS_REVIEW_LENGTH.value = value["MIN_CLASS_REVIEW_LENGTH"];
    // print(profile);
    print("MIN_CLASS_REVIEW_LENGTH : ${MIN_CLASS_REVIEW_LENGTH.value}");
    box.write("year_sem", value["year_sem"]);
    box.write("MAX_BOARDS_LIMIT", value["MAX_BOARDS_LIMIT"]);

    // print("MAX_BOARDS_LIMIT : ${value["MAX_BOARDS_LIMIT"]}");

    // print(value["year_sem"]["TIMETABLE_YEAR_FROM_DATE"]);
    // for (MainClassModel model in classList) {
    //   print("${model.CLASS_NAME}: ${model.CLASS_ID}");
    // }

    for (BoardInfo item in value["boardInfo"]) {
      boardListInfo.add(item);
      boardInfo.add(item.obs);
    }

    // 선택된 보드에 넣기
    selectedBoard.clear();
    for (Rx<BoardInfo> item in boardInfo) {
      // print(
      //     "${item.value.IS_DEFAULT} ${!isAlreadyRunned}  ${item.value.IS_DEFAULT && !isAlreadyRunned}!!!!!!!!!!!");
      if (item.value.isChecked) {
        selectedBoard.add(item);
      }

      // else if (item.value.IS_DEFAULT && (!isAlreadyRunned)) {
      //   print("add ${item}");
      //   item.update((val) {
      //     val.isFollowed = true;
      //     // val.isChecked = true;
      //   });
      //   selectedBoard.add(item);
      // }
    }

    sortBoard();

    box.write("boardInfo", boardListInfo);

    _dataAvailable.value = true;
  }

  Future<void> deleteFollowingCommunity(int COMMUNITY_ID) async {
    List<BoardInfo> boardInfoList = await fetchCommunityInfoFromBox();

    boardInfoList.removeWhere(
        (BoardInfo element) => element.COMMUNITY_ID == COMMUNITY_ID);
    box.write("followingCommunity", boardInfoList);
    await getFollowingCommunity();
  }

  Future<List<BoardInfo>> fetchCommunityInfoFromBox() async {
    List<dynamic> aa = await box.read("followingCommunity");
    if (aa == null || aa.length == 0) {
      return [];
    }
    //print(aa.runtimeType);
    if (aa[0].runtimeType == BoardInfo) {
      return aa;
    }

    List<BoardInfo> boardInfoList = aa.map((e) {
      if (e["COMMUNITY_ID"].runtimeType != int) {
        e["COMMUNITY_ID"] = int.parse(e["COMMUNITY_ID"]);
      }
      return BoardInfo.fromJson(e);
    }).toList();
    // boardInfoList.forEach((element) {
    //   print(element.toJson());
    // });
    return boardInfoList;
  }

  Future<void> getFollowingCommunity() async {
    if (!isAlreadyRunned) {
      List<BoardInfo> temp = [];
      followingCommunity.value = [];
      for (var item in boardInfo) {
        if (item.value.IS_DEFAULT) {
          followingCommunity.add("${item.value.COMMUNITY_ID}");
          item.update((val) {
            val.isFollowed = true;
            val.isChecked = true;
          });
          temp.add(item.value);

          // setFollowingCommunity(
          //     item.value.COMMUNITY_ID,
          //     item.value.COMMUNITY_NAME,
          //     item.value.RECENT_TITLE,
          //     "${item.value.RECENT_TIME}",
          //     item.value.isFollowed,
          //     item.value.isNew);
        }
      }
      box.write("followingCommunity", temp);
      isAlreadyRunned = true;
      box.write("alreadyRunned", isAlreadyRunned);
      // followingCommunity.value = boardInfo.map((element) {
      //   print(" @@@@@@@@@@  ${element.value.COMMUNITY_ID}");
      //   if (element.value.IS_DEFAULT) {
      //     BoardInfo item = element.value;
      //     setFollowingCommunity(
      //         item.COMMUNITY_ID,
      //         item.COMMUNITY_NAME,
      //         item.RECENT_TITLE,
      //         "${item.RECENT_TIME}",
      //         item.isFollowed,
      //         item.isNew);
      //     return "${element.value.COMMUNITY_ID}";
      //   }
      // }).toList();
      followAmount.value = followingCommunity.length;
    } else {
      List<BoardInfo> boardInfoList = await fetchCommunityInfoFromBox();

      if (boardInfoList == null) {
        followAmount.value = 0;
        return;
      }
      List<Rx<BoardInfo>> follwing = boardInfoList.map((e) {
        e.isFollowed = true;
        e.isChecked = true;
        return e.obs;
      }).toList();
      followAmount.value = follwing.length;
      followingCommunity.value =
          follwing.map((e) => "${e.value.COMMUNITY_ID}").toList();

      for (Rx<BoardInfo> item in boardInfo) {
        for (BoardInfo box in boardInfoList) {
          if (box.COMMUNITY_ID == item.value.COMMUNITY_ID) {
            item.update((val) {
              val.isFollowed = true;
              val.isChecked = true;
            });
            break;
          }
        }
      }
    }
  }

  Future<void> setFollowingCommunity(
      int COMMUNITY_ID,
      String COMMUNITY_NAME,
      String RECENT_TITLE,
      String RECENT_TIME,
      bool isFollowed,
      bool isNew) async {
    if (box.read("followingCommunity") == null) {
      BoardInfo a = BoardInfo.fromJson({
        "COMMUNITY_ID": COMMUNITY_ID,
        "COMMUNITY_NAME": COMMUNITY_NAME,
        "RECENT_TITLE": RECENT_TITLE,
        "RECENT_TIME": RECENT_TIME,
        "isFollowed": isFollowed,
        "isNew": isNew
      });
      box.write("followingCommunity", [a]);
    } else {
      List<BoardInfo> boardInfoList = await fetchCommunityInfoFromBox();

      for (BoardInfo item in boardInfoList) {
        if (item.COMMUNITY_ID == COMMUNITY_ID) {
          return;
        }
      }
      boardInfoList.add(BoardInfo.fromJson({
        "COMMUNITY_ID": COMMUNITY_ID,
        "COMMUNITY_NAME": COMMUNITY_NAME,
        "RECENT_TITLE": RECENT_TITLE,
        "RECENT_TIME": RECENT_TIME,
        "isFollowed": isFollowed,
        "isNew": isNew
      }));
      box.write("followingCommunity", boardInfoList);
    }

    await getFollowingCommunity();
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

  // Future<String> _getAndroidStoreVersion(PackageInfo packageInfo) async {
  //   final id = packageInfo.packageName;
  //   final uri =
  //       Uri.https("play.google.com", "/store/apps/details", {"id": "$id"});
  //   final response = await Session().getX(uri.toString());
  //   if (response.statusCode != 200) {
  //     debugPrint('Can\'t find an app in the Play Store with the id: $id');
  //     return "";
  //   }
  //   final document = jsonDecode(response.body);
  //   final elements = document.getElementsByClassName('hAyfc');
  //   final versionElement = elements.firstWhere(
  //     (elm) => elm.querySelector('.BgcNfc').text == 'Current Version',
  //   );
  //   return versionElement.querySelector('.htlgb').text;
  // }

  // Future<dynamic> _getiOSStoreVersion(PackageInfo packageInfo) async {
  //   final id = packageInfo.packageName;

  //   final parameters = {"bundleId": "$id"};

  //   var uri = Uri.https("itunes.apple.com", "/lookup", parameters);
  //   final response = await Session().get(uri.toString());

  //   if (response.statusCode != 200) {
  //     debugPrint('Can\'t find an app in the App Store with the id: $id');
  //     return "";
  //   }

  //   final jsonObj = json.decode(response.body);

  //   /* 일반 print에서 일정 길이 이상의 문자열이 들어왔을 때,
  //    해당 길이만큼 문자열이 출력된 후 나머지 문자열은 잘린다.
  //    debugPrint의 경우 일반 print와 달리 잘리지 않고 여러 행의 문자열 형태로 출력된다. */

  //   // debugPrint(response.body.toString());
  //   return jsonObj['results'][0]['version'];
  // }

  final int SPLASH_LIMIT = 1500;

  Future<void> fake_onInit() async {
    await ManagePermission.getPermission();

    // DateTime pass = new DateTime.now();
    splashTransparent.value = false;
    super.onInit();
    //버전 확인
    isAlreadyRunned = box.read("alreadyRunned") == null ? false : true;
    await getBoardInfo();
    await getFollowingCommunity();
    putController<TimeTableController>();
    putController<ClassController>();
    putController<NotiController>();
    putController<MyPageController>();

    // await getCurSemTimetableExist();

    hotNewTabController = await TabController(vsync: this, length: 2);
    // DateTime cur = new DateTime.now();
    // print("cur.difference(pass) : ${cur.difference(pass)}");
    // Duration diff = cur.difference(pass);
    // Duration expected = Duration(milliseconds: SPLASH_LIMIT);
    // if (cur.difference(pass) > expected) {
    //   initDataAvailable.value = true;
    // } else {
    //   await Future.delayed(expected - diff, () {
    //     initDataAvailable.value = true;
    //   });
    // }

    sortBoard();
  }

  @override
  void onInit() async {
    super.onInit();

    // // tabController = TabController(vsync: this, length: 2);
    // await ManagePermission.getPermission();

    // // DateTime pass = new DateTime.now();
    // splashTransparent.value = false;
    // //버전 확인
    // await versionCheck();
    // isAlreadyRunned = box.read("alreadyRunned") == null ? false : true;
    // await getBoardInfo();
    // await getFollowingCommunity();
    // putController<TimeTableController>();
    // putController<ClassController>();
    // putController<NotiController>();
    // putController<MyPageController>();

    // // await getCurSemTimetableExist();

    // hotNewTabController = await TabController(vsync: this, length: 2);
    // // DateTime cur = new DateTime.now();
    // // print("cur.difference(pass) : ${cur.difference(pass)}");
    // // Duration diff = cur.difference(pass);
    // // Duration expected = Duration(milliseconds: SPLASH_LIMIT);
    // // if (cur.difference(pass) > expected) {
    // //   initDataAvailable.value = true;
    // // } else {
    // //   await Future.delayed(expected - diff, () {
    // //     initDataAvailable.value = true;
    // //   });
    // // }

    // sortBoard();
  }

  @override
  void onReady() async {
    InitController initController = Get.find();
    // initController.opacityControl(true);
    // Future.delayed(Duration(milliseconds: 800))
    //     .then((value) => Get.toNamed('/main'));
    super.onReady();
  }

  @override
  onClose() async {
    Get.delete<ClassChatController>();
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

  @override
  void dispose() {
    Get.delete<ClassChatController>();
    super.dispose();
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
    print("!!!!!");
    ClassController cc = Get.find();
    await cc.refreshPage();
    print("?????");
    return;
  }

  static Future<void> updateClassSearchPage() async {
    if (Get.isRegistered<ClassSearchController>()) {
      ClassSearchController csc = Get.find();
      await csc.refreshPage();
    }

    return;
  }

  static Future<void> updateMyPage(int index) async {
    putController<MyPageController>();
    MyPageController mc = Get.find();
    if (index == 0) {
      await mc.getMineWrite();
    } else if (index == 1) {
      await mc.getMineLike();
    } else {
      await mc.getMineScrap();
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
      putController<ClassChatController>();
      final ClassChatController classChatController = Get.find();
      await classChatController.getChatBox();
    } else {
      await nc.getMailBox();
      print(">>");
      for (Rx<MailBoxModel> item in nc.mailBox) {
        if (!item.value.isReaded) {
          item.update((val) {
            val.isReaded = true;
          });
          nc.setReadMails(SaveMailBoxModel.fromJson({
            "MAIL_BOX_ID": item.value.MAIL_BOX_ID,
            "MAIL_ID": item.value.MAIL_ID,
            "LOOKUP_DATE": "${DateTime.now()}"
          }));
        }
      }
    }
    return;
  }

  static Future<void> updateHotMain(int index) async {
    final BoardController boardController = Get.find();
    if (index == 0) {
      boardController.hotPage.value = 0;
      await boardController.refreshHotPage();
    } else {
      boardController.newPage.value = 0;
      await boardController.refreshNewPage();
    }

    updateLikeList();
    updateScrapList();

    return;
  }

  static Future<void> updateBoard() async {
    final BoardController boardController = Get.find();
    print("update page!");
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