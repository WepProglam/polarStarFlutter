import 'package:polarstar_flutter/app/modules/mailHistory/mail_controller.dart';
import 'package:polarstar_flutter/app/data/provider/mail/mail_provider.dart';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/repository/mail/mail_repository.dart';

class MailBoxBinding implements Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<MailController>(() =>
        MailController(repository: MailRepository(apiClient: MailApiClient())));
  }
}
