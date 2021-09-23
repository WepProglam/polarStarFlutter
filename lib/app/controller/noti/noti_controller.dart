import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/database_helper.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_repository.dart';
import 'package:polarstar_flutter/app/ui/android/class/class.dart';
import 'package:polarstar_flutter/session.dart';

class NotiController extends GetxController {
  final MainRepository repository;
  final box = GetStorage();
  RxList<NotiModel> noties = <NotiModel>[].obs;
  RxInt pageViewIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);
  RxBool notiFetched = false.obs;

  NotiController({@required this.repository}) : assert(repository != null);

  Future<void> getNoties() async {
    var response = await Session().getX("/notification");
    Iterable notiList = jsonDecode(response.body);
    print(notiList);
    noties.value = notiList.map((e) => NotiModel.fromJson(e)).toList();
    notiFetched.value = true;
  }

  @override
  onInit() async {
    super.onInit();
    await getNoties();
  }

  @override
  onClose() async {
    super.onClose();
  }
}
