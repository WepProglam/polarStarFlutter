import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/controller/outside/post_controller.dart';
import 'package:polarstar_flutter/app/data/provider/mail/mail_provider.dart';

import 'package:polarstar_flutter/app/data/provider/outside/post_provider.dart';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/repository/mail/mail_repository.dart';
import 'package:polarstar_flutter/app/data/repository/outside/post_repository.dart';

class OutSidePostBinding implements Bindings {
  @override
  void dependencies() {
    print(Get.parameters["COMMUNITY_ID"]);
    Get.put(OutSidePostController(
        COMMUNITY_ID: int.parse(Get.parameters["COMMUNITY_ID"]),
        BOARD_ID: int.parse(Get.parameters["BOARD_ID"]),
        repository: OutSidePostRepository(apiClient: OutSidePostApiClient())));
    Get.put(
        MailController(repository: MailRepository(apiClient: MailApiClient())));
  }
}
