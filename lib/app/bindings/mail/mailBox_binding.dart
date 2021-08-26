import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/data/provider/mail/mail_provider.dart';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/repository/mail/mail_repository.dart';

class MailBoxBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(
        MailController(repository: MailRepository(apiClient: MailApiClient())));
    final MailController mailController = Get.find();
    await mailController.getMailBox();
  }
}
