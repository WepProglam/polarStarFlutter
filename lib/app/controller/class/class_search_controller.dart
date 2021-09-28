import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';

class ClassSearchController extends GetxController {
  final ClassRepository repository;
  ClassSearchController({@required this.repository});

  final classSearchListAvailable = false.obs;
  final classSearchList = <ClassModel>[].obs;
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0);
  RxInt page = 0.obs;
  RxString searchText = "".obs;
  bool isFetching = false;
  int searchLength = 0;
  bool fetchTilEnd = false;

  Future<void> refreshPage() async {
    await getClassSearchList();
  }

  Future getClassSearchList() async {
    Map<String, dynamic> jsonResponse =
        await repository.getClassSearchList(searchText.value, page.value);

    switch (jsonResponse["statusCode"]) {
      case 200:
        classSearchList(jsonResponse["classList"]);
        if (searchLength >= classSearchList.length) {
          fetchTilEnd = true;
        }
        searchLength = classSearchList.length;
        classSearchListAvailable(true);
        break;
      default:
        classSearchListAvailable(false);
        printError(info: "Data Fetch ERROR!!");
    }
  }

  @override
  void onInit() async {
    super.onInit();
    searchText.value = Get.parameters["search"];

    await getClassSearchList();
    scrollController.addListener(() async {
      print(scrollController.position.maxScrollExtent);
      if ((scrollController.position.pixels ==
                  scrollController.position.maxScrollExtent ||
              !scrollController.position.hasPixels) &&
          !fetchTilEnd) {
        page.value += 1;
        await getClassSearchList();
      }
    });
  }
}
