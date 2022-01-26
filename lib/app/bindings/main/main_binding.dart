import 'package:polarstar_flutter/app/controller/class/class_chat_controller.dart';
import 'package:polarstar_flutter/app/controller/loby/login_controller.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/provider/mail/mail_provider.dart';

import 'package:polarstar_flutter/app/data/provider/main/main_provider.dart';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/provider/noti/noti_provider.dart';
import 'package:polarstar_flutter/app/data/provider/profile/mypage_provider.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:polarstar_flutter/app/data/repository/mail/mail_repository.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_repository.dart';
import 'package:polarstar_flutter/app/data/repository/noti/noti_repository.dart';
import 'package:polarstar_flutter/app/data/repository/profile/mypage_repository.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MainBinding implements Bindings {
  @override
  void dependencies() async {
    print("MAINBINDING");
    Get.lazyPut<MainController>(() =>
        MainController(repository: MainRepository(apiClient: MainApiClient())));

    Get.lazyPut<NotiController>(() =>
        NotiController(repository: NotiRepository(apiClient: NotiApiClient())));

    Get.put(LoginController(
        repository: LoginRepository(apiClient: LoginApiClient())));

    Get.lazyPut<MyPageController>(() => MyPageController(
        repository: MyPageRepository(apiClient: MyPageApiClient())));

    Get.put(ClassChatController());
    ClassChatController classChatController = Get.find();
    if (classChatSocket == null || classChatSocket.disconnected) {
      print("disconnected!!!");
      classChatSocket = await IO.io(
          'http://13.209.5.161:3000',
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setExtraHeaders({'cookie': Session.headers["Cookie"]})
              .build());
      classChatSocket.connect();
    } else {
      print("disconnect!!");
      classChatSocket.disconnect();
    }

    await classChatController.registerSocket();
    await classChatController.getChatBox();
    print(" !!!!  ${classChatController.classChatBox}");
  }
}
