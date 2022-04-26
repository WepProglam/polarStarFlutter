import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/repository/board/board_repository.dart';

import 'package:flutter/material.dart';

class BoardController extends GetxController with SingleGetTickerProviderMixin {
  int initCommunityId;
  int initPage;
  final BoardRepository repository;

  BoardController(
      {@required this.repository,
      @required this.initCommunityId,
      @required this.initPage});

  RxInt COMMUNITY_ID = 4.obs;
  RxInt page = 1.obs;
  RxInt httpStatus = 200.obs;

  // RxBool canBuildRecruitBoard = false.obs;

  RxMap boardBody = {}.obs;

  TabController tabController;
  Rx<int> boardIndex = 0.obs;

  RxBool dataAvailablePostPreview = false.obs;

  RxList<Rx<Post>> postBody = <Rx<Post>>[].obs;
  RxList<Rx<Post>> HotBody = <Rx<Post>>[].obs;
  RxList<Rx<Post>> NewBody = <Rx<Post>>[].obs;
  // RxList<Rx<Post>> TotalBody = <Rx<Post>>[].obs;

  var scrollController = ScrollController().obs;
  var hotScrollController = ScrollController().obs;
  var newScrollController = ScrollController().obs;
  // var totalScrollController = ScrollController().obs;

  Future<void> refreshPage() async {
    page.value = 1;
    await getBoard();
  }

  Future<void> refreshHotPage() async {
    await getHotBoard();
  }

  Future<void> refreshNewPage() async {
    await getNewBoard();
  }

  Future<void> getBoard() async {
    print("CM : ${COMMUNITY_ID.value} PAGE : ${page.value}");

    Map<String, dynamic> response =
        await repository.getBoard(COMMUNITY_ID.value, page.value);
    final int status = response["status"];
    final List<Rx<Post>> listBoard = response["listBoard"];
    if (listBoard.length < MAX_BOARDS_LIMIT) {
      searchMaxPage.value = page.value;
    }
    httpStatus.value = status;

    switch (status) {
      case 200:
        // * refresh
        if (postBody.length != 0 && page.value == 1) {
          postBody.clear();
        }

        for (int i = 0; i < listBoard.length; i++) {
          postBody.add(listBoard[i]);
        }
        dataAvailablePostPreview.value = true;
        break;

      default:
        dataAvailablePostPreview.value = false;
        break;
    }
  }

  // Future<void> getTotalBoard() async {
  //   Map<String, dynamic> response =
  //       await repository.getTotalBoard(totalPage.value);
  //   final int status = response["status"];
  //   final List<Rx<Post>> listBoard = response["listBoard"];
  //   if (listBoard.length < MAX_BOARDS_LIMIT) {
  //     totalSearchMaxPage.value = totalPage.value;
  //   }

  //   httpStatus.value = status;
  //   switch (status) {
  //     case 200:
  //       if (TotalBody.length == 0) {
  //         TotalBody.clear();
  //       } else {
  //         if (checkDuplicate(TotalBody, listBoard)) {
  //           TotalBody.value = listBoard;
  //           break;
  //         }
  //       }

  //       for (int i = 0; i < listBoard.length; i++) {
  //         TotalBody.add(listBoard[i]);
  //       }
  //       dataAvailablePostPreview.value = true;
  //       break;

  //     default:
  //       dataAvailablePostPreview.value = false;
  //       break;
  //   }
  // }

  Future<void> getNewBoard() async {
    Map<String, dynamic> response = await repository.getNewBoard(newPage.value);
    final int status = response["status"];
    final List<Rx<Post>> listBoard = response["listBoard"];
    if (listBoard.length < MAX_BOARDS_LIMIT) {
      newSearchMaxPage.value = newPage.value;
    }

    httpStatus.value = status;
    switch (status) {
      case 200:
        if (NewBody.length == 0) {
          NewBody.clear();
        } else {
          if (checkDuplicate(NewBody, listBoard)) {
            NewBody.value = listBoard;
            break;
          }
        }

        for (int i = 0; i < listBoard.length; i++) {
          NewBody.add(listBoard[i]);
        }
        dataAvailablePostPreview.value = true;
        break;

      default:
        dataAvailablePostPreview.value = false;
        break;
    }
  }

  bool checkDuplicate(List<Rx<Post>> listBoard, List<Rx<Post>> src) {
    if (src.last.value.UNIQUE_ID == listBoard.last.value.UNIQUE_ID) {
      return true;
    }
    return false;
  }

  Future<void> getHotBoard() async {
    Map<String, dynamic> response = await repository.getHotBoard(hotPage.value);
    final int status = response["status"];
    final List<Rx<Post>> listBoard = response["listBoard"];
    if (listBoard.length < MAX_BOARDS_LIMIT) {
      hotSearchMaxPage.value = hotPage.value;
    }
    httpStatus.value = status;
    switch (status) {
      case 200:
        if (HotBody.length == 0) {
          HotBody.clear();
        } else {
          if (checkDuplicate(HotBody, listBoard)) {
            HotBody.value = listBoard;
            break;
          }
        }

        for (int i = 0; i < listBoard.length; i++) {
          HotBody.add(listBoard[i]);
        }
        dataAvailablePostPreview.value = true;
        break;

      default:
        dataAvailablePostPreview.value = false;
        break;
    }
    //print(HotBody);
  }

  Future<void> getSearchBoard(String searchText) async {
    Map<String, dynamic> response =
        await repository.getSearchBoard(searchText, COMMUNITY_ID.value);
    final int status = response["status"];
    final List<Rx<Post>> listBoard = response["listBoard"];
    if (listBoard.length < MAX_BOARDS_LIMIT) {
      searchMaxPage.value = page.value;
    }

    httpStatus.value = status;
    switch (status) {
      case 200:
        if (postBody.length == 0) {
          postBody.clear();
        } else {
          if (checkDuplicate(postBody, listBoard)) {
            break;
          }
        }

        for (int i = 0; i < listBoard.length; i++) {
          postBody.add(listBoard[i]);
        }
        dataAvailablePostPreview.value = true;
        break;

      default:
        dataAvailablePostPreview.value = false;
        break;
    }
  }

  Future<void> getSearchAll(String searchText) async {
    Map<String, dynamic> response = await repository.getSearchAll(searchText);
    final int status = response["status"];
    final List<Rx<Post>> listBoard = response["listBoard"];

    httpStatus.value = status;
    switch (status) {
      case 200:
        if (postBody.length == 0) {
          postBody.clear();
        } else {
          if (checkDuplicate(postBody, listBoard)) {
            break;
          }
        }

        for (int i = 0; i < listBoard.length; i++) {
          postBody.add(listBoard[i]);
        }
        dataAvailablePostPreview.value = true;
        break;

      default:
        dataAvailablePostPreview.value = false;
        break;
    }
  }

  int MAX_BOARDS_LIMIT = 30;
  final box = GetStorage();

  Rx<int> searchMaxPage = 99999.obs;
  Rx<int> hotSearchMaxPage = 99999.obs;
  Rx<int> newSearchMaxPage = 99999.obs;
  // Rx<int> totalSearchMaxPage = 99999.obs;
  Rx<int> hotPage = 0.obs;
  Rx<int> newPage = 0.obs;
  // Rx<int> totalPage = 0.obs;

  @override
  void onInit() async {
    tabController = TabController(vsync: this, length: 2);

    super.onInit();
    MAX_BOARDS_LIMIT = await box.read("MAX_BOARDS_LIMIT");

    // print("MAX_BOARDS_LIMIT : ${MAX_BOARDS_LIMIT}");
    boardIndex.value = 0;
    COMMUNITY_ID.value = initCommunityId;
    page.value = initPage;

    hotScrollController.value.addListener(() async {
      if ((hotScrollController.value.position.pixels ==
                  hotScrollController.value.position.maxScrollExtent ||
              !hotScrollController.value.position.hasPixels) &&
          (hotPage.value < hotSearchMaxPage.value)) {
        hotPage.value += 1;
        await getHotBoard();
      }
    });

    newScrollController.value.addListener(() async {
      if ((newScrollController.value.position.pixels ==
                  newScrollController.value.position.maxScrollExtent ||
              !newScrollController.value.position.hasPixels) &&
          (newPage.value < newSearchMaxPage.value)) {
        newPage.value += 1;
        await getNewBoard();
      }
    });

    // totalScrollController.value.addListener(() async {
    //   if ((totalScrollController.value.position.pixels ==
    //               totalScrollController.value.position.maxScrollExtent ||
    //           !totalScrollController.value.position.hasPixels) &&
    //       (totalPage.value < totalSearchMaxPage.value)) {
    //     totalPage.value += 1;
    //     await getTotalBoard();
    //   }
    // });

    // await getBoard();

    scrollController.value.addListener(() async {
      if ((scrollController.value.position.pixels ==
                  scrollController.value.position.maxScrollExtent ||
              !scrollController.value.position.hasPixels) &&
          (page.value < searchMaxPage.value)) {
        page.value += 1;
        await getBoard();
      }
    });
  }

  //   scrollController.value.addListener(() {
  //     if (scrollController.value.position.pixels ==
  //             scrollController.value.position.maxScrollExtent ||
  //         !scrollController.value.position.hasPixels) {
  //       int curPage = page.value;
  //       if (curPage < boardBody['pageAmount']) {
  //         page(curPage + 1);
  //         print('scroll end');
  //         getBoard();
  //       }
  //     }
  //   });
  // }
}
