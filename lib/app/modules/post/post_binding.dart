import 'package:polarstar_flutter/app/modules/board/board_controller.dart';
import 'package:polarstar_flutter/app/modules/post/post_controller.dart';
import 'package:polarstar_flutter/app/modules/mailHistory/mail_controller.dart';
import 'package:polarstar_flutter/app/modules/noti/noti_controller.dart';

import 'package:polarstar_flutter/app/data/provider/board/board_provider.dart';

import 'package:polarstar_flutter/app/data/provider/board/post_provider.dart';
import 'package:polarstar_flutter/app/data/provider/mail/mail_provider.dart';
import 'package:polarstar_flutter/app/data/repository/board/board_repository.dart';

import 'package:polarstar_flutter/app/data/repository/board/post_repository.dart';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/repository/mail/mail_repository.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_page.dart';

class PostBinding implements Bindings {
  @override
  void dependencies() {
    print(Get.parameters["COMMUNITY_ID"]);

    PostController ps = PostController(
        COMMUNITY_ID: int.parse(Get.parameters["COMMUNITY_ID"]),
        BOARD_ID: int.parse(Get.parameters["BOARD_ID"]),
        repository: PostRepository(apiClient: PostApiClient()));

    ps.callType = 2;
    if (Get.arguments != null && Get.arguments.containsKey("type")) {
      ps.callType = Get.arguments["type"];
    }

    Get.put(ps);

    putController<NotiController>();
    putController<MailController>();
  }
}
