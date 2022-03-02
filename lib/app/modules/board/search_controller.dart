import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
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
  RxList<Rx<Post>> postBody = <Rx<Post>>[].obs;
  RxString searchText = "".obs;

  var scrollController = ScrollController().obs;

  Future<void> getSearchBoard({String searchTextTemp}) async {
    if (searchTextTemp != null) {
      searchText.value = searchTextTemp;
    }

    String checkText = searchText.value;
    if (checkText.trim().length < 2) {
      Get.snackbar("搜索失败", "请输入至少两个字以上",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black);
      return;
    }

    Map<String, dynamic> response = await repository.getSearchBoard(
        searchText.value, COMMUNITY_ID.value, from);
    final int status = response["status"];
    httpStatus.value = status;

    switch (status) {
      case 200:
        final List<Rx<Post>> listBoard = response["listBoard"];

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
          getSearchBoard(searchTextTemp: searchText.value);
        }
      }
    });
  }
}
