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

  Future<void> refreshPage() async {
    await getClassSearchList();
  }

  Future getClassSearchList() async {
    print(Get.parameters["search"]);
    Map<String, dynamic> jsonResponse =
        await repository.getClassSearchList(Get.parameters["search"]);

    switch (jsonResponse["statusCode"]) {
      case 200:
        classSearchList(jsonResponse["classList"]);
        classSearchListAvailable(true);
        break;
      default:
        classSearchListAvailable(false);
        printError(info: "Data Fetch ERROR!!");
    }
  }

  @override
  void onInit() async {
    await getClassSearchList();
    super.onInit();
  }
}
