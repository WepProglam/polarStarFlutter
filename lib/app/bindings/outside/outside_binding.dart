import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/outside/outside_controller.dart';

import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/data/provider/board/board_provider.dart';
import 'package:polarstar_flutter/app/data/provider/outside/outside_provider.dart';
import 'package:polarstar_flutter/app/data/provider/search/search_provider.dart';
import 'package:polarstar_flutter/app/data/repository/outside/outside_repository.dart';
import 'package:polarstar_flutter/app/data/repository/search/search_repository.dart';

class OutSideBinding implements Bindings {
  @override
  void dependencies() async {
    int initCommunityId = Get.parameters["COMMUNITY_ID"] == null
        ? 1
        : int.parse(Get.parameters["COMMUNITY_ID"]);
    int initPage =
        Get.parameters["page"] == null ? 1 : int.parse(Get.parameters["page"]);

    Get.lazyPut<OutSideController>(() => (OutSideController(
        repository: OutSideRepository(apiClient: OutSideApiClient()),
        initCommunityId: initCommunityId,
        initPage: initPage)));

    // Get.lazyPut<SearchController>(() => (SearchController(
    //     repository: SearchRepository(apiClient: SearchApiClient()),
    //     initCommunityId: initCommunityId,
    //     initPage: initPage,
    //     from: "outside")));
  }
}
