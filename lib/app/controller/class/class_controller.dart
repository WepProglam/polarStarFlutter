import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';

class ClassController extends GetxController {
  final ClassRepository repository;
  ClassController({@required this.repository});

  final classListAvailable = false.obs;
  final classList = <ClassModel>[].obs;
  final reviewList = <ClassRecentReviewModel>[].obs;

  Future<void> refreshPage() async {
    await getClassList();
  }

  Future getClassList() async {
    Map<String, dynamic> jsonResponse = await repository.getRecentClass();

    switch (jsonResponse["statusCode"]) {
      case 200:
        classList(jsonResponse["classList"]);
        reviewList(jsonResponse["reviewList"]);
        classListAvailable(true);
        break;
      default:
        classListAvailable(false);
        printError(info: "Data Fetch ERROR!!");
    }
  }

  @override
  void onInit() async {
    await getClassList();
    super.onInit();
  }
}
