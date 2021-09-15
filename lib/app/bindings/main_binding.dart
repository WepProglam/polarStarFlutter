import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';

import 'package:polarstar_flutter/app/data/provider/main_provider.dart';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/provider/profile/mypage_provider.dart';
import 'package:polarstar_flutter/app/data/provider/search/search_provider.dart';
import 'package:polarstar_flutter/app/data/repository/main_repository.dart';
import 'package:polarstar_flutter/app/data/repository/profile/mypage_repository.dart';
import 'package:polarstar_flutter/app/data/repository/search/search_repository.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() =>
        MainController(repository: MainRepository(apiClient: MainApiClient())));

    Get.lazyPut<SearchController>(() => (SearchController(
        repository: SearchRepository(apiClient: SearchApiClient()),
        initCommunityId: 1,
        initPage: 1,
        from: "outside")));

    Get.lazyPut<MyPageController>(() => MyPageController(
        repository: MyPageRepository(apiClient: MyPageApiClient())));
  }
}
