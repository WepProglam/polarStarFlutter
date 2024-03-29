import 'package:polarstar_flutter/app/modules/board/board_controller.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/board/search_controller.dart';
import 'package:polarstar_flutter/app/data/provider/board/board_provider.dart';
import 'package:polarstar_flutter/app/data/provider/search/search_provider.dart';
import 'package:polarstar_flutter/app/data/repository/board/board_repository.dart';
import 'package:polarstar_flutter/app/data/repository/search/search_repository.dart';

class BoardBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(BoardController(
        repository: BoardRepository(apiClient: BoardApiClient()),
        initCommunityId: int.parse(Get.parameters["COMMUNITY_ID"]),
        initPage: int.parse(Get.parameters["page"])));

    Get.put(
      SearchController(
          repository: SearchRepository(apiClient: SearchApiClient()),
          initCommunityId: int.parse(Get.parameters["COMMUNITY_ID"]),
          initPage: int.parse(Get.parameters["page"]),
          from: "board"),
    );
    print("binding");
    print(Get.parameters["COMMUNITY_ID"]);

    final BoardController boardController = Get.find();
    boardController.COMMUNITY_ID.value =
        int.parse(Get.parameters["COMMUNITY_ID"]);

    boardController.page.value = int.parse(Get.parameters["page"]);

    await boardController.getBoard();
  }
}
