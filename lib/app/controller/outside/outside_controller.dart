import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';

import 'package:polarstar_flutter/app/data/repository/outside/outside_repository.dart';

import 'package:flutter/material.dart';

class OutSideController extends GetxController {
  int initCommunityId;
  int initPage;
  final OutSideRepository repository;

  OutSideController(
      {@required this.repository,
      @required this.initCommunityId,
      @required this.initPage});

  RxInt COMMUNITY_ID = 1.obs;
  RxInt page = 1.obs;
  RxInt httpStatus = 200.obs;

  RxMap boardBody = {}.obs;

  Rx<int> boardIndex = 0.obs;

  RxBool dataAvailablePostPreview = false.obs;

  List<bool> didFetchInfo = [false, false, false];

  RxList<Board> postBody = <Board>[].obs;

  List<Board> postBodyRecruit = <Board>[].obs;
  List<Board> postBodyPartTime = <Board>[].obs;
  List<Board> postBodyCompetition = <Board>[].obs;

  List<List<Board>> postBodtOutside = [];

  var scrollController = ScrollController().obs;

  Future<void> refreshPage() async {
    postBody.clear();
    dataAvailablePostPreview.value = false;
    await getBoard();
    didFetchInfo = [true, false, false];
    //긁어온거 postBody에 넣음
    postBodtOutside[0].forEach((element) {
      postBody.add(element);
    });
  }

  Future<void> getBoard() async {
    dataAvailablePostPreview.value = false;
    Map<String, dynamic> response =
        await repository.getBoard(COMMUNITY_ID.value, page.value);
    final int status = response["status"];
    final List<Board> listBoard = response["listBoard"];
    httpStatus.value = status;
    switch (status) {
      case 200:
        postBodtOutside[COMMUNITY_ID.value - 1].clear();
        for (int i = 0; i < listBoard.length; i++) {
          postBodtOutside[COMMUNITY_ID.value - 1].add(listBoard[i]);
        }
        dataAvailablePostPreview.value = true;
        break;

      default:
        dataAvailablePostPreview.value = false;
        break;
    }
  }

  Future<void> getSearchBoard(String searchText) async {
    dataAvailablePostPreview.value = false;
    Map<String, dynamic> response =
        await repository.getSearchBoard(searchText, COMMUNITY_ID.value);
    final int status = response["status"];
    final List<Board> listBoard = response["listBoard"];

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
    dataAvailablePostPreview.value = false;
    Map<String, dynamic> response = await repository.getSearchAll(searchText);
    final int status = response["status"];
    final List<Board> listBoard = response["listBoard"];

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

  void getFirstInfo() async {
    await getBoard();
    //취업 정보 긁어왔음 true
    didFetchInfo[0] = true;
    //긁어온걸 postBody에 넣어줌
    postBodtOutside[COMMUNITY_ID.value - 1].forEach((element) {
      postBody.add(element);
    });
  }

  @override
  void onInit() async {
    super.onInit();
    boardIndex.value = 0;
    COMMUNITY_ID.value = initCommunityId;
    page.value = initPage;

    postBodtOutside = [postBodyRecruit, postBodyPartTime, postBodyCompetition];

    await getFirstInfo();

    ever(COMMUNITY_ID, (_) async {
      print(didFetchInfo);
      if (!didFetchInfo[COMMUNITY_ID.value - 1]) {
        didFetchInfo[COMMUNITY_ID.value - 1] = true;
        await getBoard();
      }
      postBody.clear();
      postBodtOutside[COMMUNITY_ID.value - 1].forEach((element) {
        postBody.add(element);
      });
    });

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
