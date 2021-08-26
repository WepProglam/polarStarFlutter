import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/repository/search/search_repository.dart';

import 'package:flutter/material.dart';

class SearchController extends GetxController {
  final int initCommunityId;
  int initPage;
  String from;
  final SearchRepository repository;

  SearchController(
      {@required this.repository,
      @required this.initCommunityId,
      @required this.initPage,
      @required this.from});

  RxInt COMMUNITY_ID = 1.obs;
  RxInt page = 1.obs;
  RxInt httpStatus = 200.obs;

  RxMap boardBody = {}.obs;

  Rx<int> boardIndex = 0.obs;

  RxBool dataAvailablePostPreview = false.obs;
  RxList<Board> postBody = <Board>[].obs;
  RxString searchText = "".obs;

  var scrollController = ScrollController().obs;

  Future<void> getSearchBoard(String searchTextTemp) async {
    searchText.value = searchTextTemp;

    dataAvailablePostPreview.value = false;
    Map<String, dynamic> response = await repository.getSearchBoard(
        searchText.value, COMMUNITY_ID.value, from);
    final int status = response["status"];
    httpStatus.value = status;

    switch (status) {
      case 200:
        final List<Board> listBoard = response["listBoard"];

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

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
              scrollController.value.position.maxScrollExtent / 10 * 9 ||
          !scrollController.value.position.hasPixels) {
        int curPage = page.value;
        if (curPage < boardBody['pageAmount']) {
          page(curPage + 1);
          print('scroll end');
          getSearchBoard(searchText.value);
        }
      }
    });
  }
}
