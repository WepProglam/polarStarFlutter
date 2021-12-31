import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/repository/board/board_repository.dart';

import 'package:flutter/material.dart';

class BoardController extends GetxController {
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

  Rx<int> boardIndex = 0.obs;

  RxBool dataAvailablePostPreview = false.obs;

  RxList<Rx<Post>> postBody = <Rx<Post>>[].obs;

  var scrollController = ScrollController().obs;

  Future<void> refreshPage() async {
    await getBoard().then((value) => postBody.refresh());
  }

  Future<void> refreshHotPage() async {
    await getHotBoard().then((value) => postBody.refresh());
  }

  Future<void> getBoard() async {
    Map<String, dynamic> response =
        await repository.getBoard(COMMUNITY_ID.value, page.value);
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

  Future<void> getHotBoard() async {
    Map<String, dynamic> response = await repository.getHotBoard(page.value);
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

  Future<void> getSearchBoard(String searchText) async {
    Map<String, dynamic> response =
        await repository.getSearchBoard(searchText, COMMUNITY_ID.value);
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

  @override
  void onInit() async {
    super.onInit();
    boardIndex.value = 0;
    COMMUNITY_ID.value = initCommunityId;
    page.value = initPage;

    // await getBoard();

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
              scrollController.value.position.maxScrollExtent / 10 * 9 ||
          !scrollController.value.position.hasPixels) {
        int curPage = page.value;
        if (curPage < boardBody['pageAmount']) {
          page(curPage + 1);
          print('scroll end');
          getBoard();
        }
      }
    });
  }
}
