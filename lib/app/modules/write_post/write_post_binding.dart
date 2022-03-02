import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/write_post/write_post_controller.dart';
import 'package:polarstar_flutter/app/data/provider/board/write_post_provider.dart';
import 'package:polarstar_flutter/app/data/repository/board/write_post_repository.dart';

class WritePostBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(WritePostController(
        repository: WritePostRepository(apiClient: WritePostApiClient()),
        COMMUNITY_ID: int.parse(Get.parameters["COMMUNITY_ID"]),
        putOrPost: Get.parameters["BOARD_ID"] != null ? "put" : "post",
        BOARD_ID: Get.parameters["BOARD_ID"] != null
            ? int.parse(Get.parameters["BOARD_ID"])
            : null));
  }
}
