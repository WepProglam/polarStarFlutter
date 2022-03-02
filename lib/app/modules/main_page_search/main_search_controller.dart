import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_search_repository.dart';
import 'package:polarstar_flutter/session.dart';

class MainSearchController extends GetxController {
  final MainSearchRepository repository;
  final box = GetStorage();

  var scrollController = ScrollController().obs;
  final pageController = PageController(initialPage: 0);

  bool searchStarted = false;

  RxBool _dataAvailable = false.obs;
  RxBool _noData = false.obs;
  RxList<bool> typeSelect = [true, false, false].obs;

  RxInt curPage = 0.obs;
  RxString searchText = "".obs;
  RxInt searchType = 0.obs;
  TextEditingController searchTextController = TextEditingController();

  RxList<RxList<Rx<Post>>> searchData =
      [<Rx<Post>>[].obs, <Rx<Post>>[].obs, <Rx<Post>>[].obs].obs;

  RxList<bool> didfetched = [false, false, false].obs;
  RxList<RxBool> hasData = [false.obs, false.obs, false.obs].obs;

  MainSearchController({@required this.repository})
      : assert(repository != null);

  void clearAll() {
    searchData.value = [<Rx<Post>>[].obs, <Rx<Post>>[].obs, <Rx<Post>>[].obs];
    didfetched.value = [false, false, false];
  }

  Future searchApi() async {
    searchStarted = true;
    String reqUrl = searchType.value == 0
        ? "/main/search/board?search=${searchText.value}&page=${curPage.value}"
        : "/main/search/outside?search=${searchText.value}&page=${curPage.value}&type=${searchType.value}";
    var response = await Session().getX(reqUrl);

    _dataAvailable.value = true;

    //나중에 장학금/ 공모전 모델 따로 만들어서 따로 저장 필요
    if (response.statusCode != 200) {
      hasData[searchType.value].value = false;
      didfetched[searchType.value] = true;

      return;
    }
    Iterable searchList = jsonDecode(response.body);

    searchData[searchType.value].value =
        searchList.map((e) => Post.fromJson(e).obs).toList();
    hasData[searchType.value].value = true;
    didfetched[searchType.value] = true;
  }

  void selectType(int index) {
    List<bool> tempBool = [false, false, false];
    tempBool[index] = true;
    typeSelect(tempBool);
  }

  @override
  onInit() async {
    super.onInit();
    ever(searchType, (_) async {
      List<bool> tempBool = [false, false, false];
      tempBool[searchType.value] = true;
      typeSelect(tempBool);
      if (searchStarted && !didfetched[searchType.value]) {
        await searchApi();
      } else {
        print("이미 다운로드");
      }
      // await pageController.animateToPage(searchType.value,
      //     duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    });

    // searchTextController = TextEditingController(text: searchText.value);
    searchTextController.text = searchText.value;

    scrollController.value.addListener(() async {
      if (scrollController.value.position.pixels ==
              scrollController.value.position.maxScrollExtent / 10 * 9 ||
          !scrollController.value.position.hasPixels) {
        int currentPage = curPage.value;
        curPage(currentPage + 1);
        await searchApi();
      }
    });

    // * 검색 바로 하기
    if (Get.arguments != null && Get.arguments.containsKey("search")) {
      String text = Get.arguments["search"];
      if (text.trim().length >= 2) {
        searchText.value = text;
        searchType.value = 0;
        await searchApi();
      }
    }
  }

  @override
  onClose() async {
    super.onClose();
  }

  bool get dataAvailalbe => _dataAvailable.value;
  bool get noData => _noData.value;
}
