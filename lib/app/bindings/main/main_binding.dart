import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/data/provider/mail/mail_provider.dart';

import 'package:polarstar_flutter/app/data/provider/main/main_provider.dart';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/provider/noti/noti_provider.dart';
import 'package:polarstar_flutter/app/data/provider/profile/mypage_provider.dart';
import 'package:polarstar_flutter/app/data/repository/mail/mail_repository.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_repository.dart';
import 'package:polarstar_flutter/app/data/repository/noti/noti_repository.dart';
import 'package:polarstar_flutter/app/data/repository/profile/mypage_repository.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() =>
        MainController(repository: MainRepository(apiClient: MainApiClient())));

    Get.lazyPut<NotiController>(() =>
        NotiController(repository: NotiRepository(apiClient: NotiApiClient())));

    // Get.lazyPut<SearchController>(() => (SearchController(
    //     repository: SearchRepository(apiClient: SearchApiClient()),
    //     initCommunityId: 1,
    //     initPage: 1,
    //     from: "outside")));

    Get.lazyPut<MyPageController>(() => MyPageController(
        repository: MyPageRepository(apiClient: MyPageApiClient())));

    Get.lazyPut<MailController>(() =>
        MailController(repository: MailRepository(apiClient: MailApiClient())));
  }
}
