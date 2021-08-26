import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/provider/board/board_provider.dart';
import 'package:polarstar_flutter/app/data/repository/board/board_repository.dart';

class HotBoardBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(BoardController(
        repository: BoardRepository(apiClient: BoardApiClient()),
        initCommunityId: -1,
        initPage: int.parse(Get.parameters["page"])));

    final BoardController boardController = Get.find();
    await boardController.getHotBoard();
  }
}
