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

  var scrollController = ScrollController().obs;
  var hotScrollController = ScrollController().obs;
  var newScrollController = ScrollController().obs;

  Future<void> refreshPage() async {
    await getBoard().then((value) => postBody.refresh());
  }

  Future<void> refreshHotPage() async {
    await getHotBoard().then((value) => HotBody.refresh());
  }

  Future<void> refreshNewPage() async {
    await getNewBoard().then((value) => NewBody.refresh());
  }

  Future<void> getBoard() async {
    Map<String, dynamic> response =
        await repository.getBoard(COMMUNITY_ID.value, page.value);
    final int status = response["status"];
    final List<Rx<Post>> listBoard = response["listBoard"];

    httpStatus.value = status;

    switch (status) {
      case 200:
        if (postBody.length == 0) {
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
    print(HotBody);
  }

  Future<void> getSearchBoard(String searchText) async {
    Map<String, dynamic> response =
        await repository.getSearchBoard(searchText, COMMUNITY_ID.value);
    final int status = response["status"];
    final List<Rx<Post>> listBoard = response["listBoard"];

    httpStatus.value = status;
    switch (status) {
      case 200:
        if (postBody.length == 0) {
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

  Future<void> getSearchAll(String searchText) async {
    Map<String, dynamic> response = await repository.getSearchAll(searchText);
    final int status = response["status"];
    final List<Rx<Post>> listBoard = response["listBoard"];

    httpStatus.value = status;
    switch (status) {
      case 200:
        postBody.clear();

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
  Rx<int> hotPage = 0.obs;
  Rx<int> newPage = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    MAX_BOARDS_LIMIT = await box.read("MAX_BOARDS_LIMIT");

    print("MAX_BOARDS_LIMIT : ${MAX_BOARDS_LIMIT}");
    boardIndex.value = 0;
    COMMUNITY_ID.value = initCommunityId;
    page.value = initPage;

    tabController = TabController(vsync: this, length: 2);

    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        print("changing!!");
      }
      print(tabController.index);
    });

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

    // await getBoard();

    scrollController.value.addListener(() async {
      if ((scrollController.value.position.pixels ==
                  scrollController.value.position.maxScrollExtent ||
              !scrollController.value.position.hasPixels) &&
          (page.value < searchMaxPage.value)) {
        page.value += 1;
        await getBoard();
        if (postBody.length < MAX_BOARDS_LIMIT) {
          searchMaxPage.value = page.value;
        }
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
