import 'package:polarstar_flutter/app/modules/classChat/class_chat_controller.dart';
import 'package:polarstar_flutter/app/modules/login_page/login_controller.dart';

import 'package:polarstar_flutter/app/modules/mailHistory/mail_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/noti/noti_controller.dart';

import 'package:polarstar_flutter/app/modules/mypage/mypage_controller.dart';

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
import 'package:polarstar_flutter/app/modules/main_page/main_page.dart';

import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MainBinding implements Bindings {
  @override
  void dependencies() async {
    print("MAINBINDING!!!!!!!!!!!@##@%@#%#%#%#%");
    print("MAINBINDING!!!!!!!!!!@##@%@#%#%#%#%");
    print("MAINBINDING!!!!!!!!!@##@%@#%#%#%#%");
    print("=============================");
    print(DateTime.now().toString());
    Get.lazyPut<MainController>(() =>
        MainController(repository: MainRepository(apiClient: MainApiClient())));

    Get.lazyPut<NotiController>(() =>
        NotiController(repository: NotiRepository(apiClient: NotiApiClient())));

    Get.put(LoginController(
        repository: LoginRepository(apiClient: LoginApiClient())));

    Get.lazyPut<MyPageController>(() => MyPageController(
        repository: MyPageRepository(apiClient: MyPageApiClient())));

    print(Get.isRegistered<ClassChatController>());
    Get.put(ClassChatController());

    ClassChatController classChatController = Get.find();
    print("=============================");
    print(DateTime.now().toString());

    classChatSocket = await IO.io(
        'http://3.39.76.247:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders(Session.headers)
            .build());
    classChatSocket.connect();
    // } else {
    //   print("disconnect!!");
    //   classChatSocket.disconnect();

    // }
    await classChatController.registerSocket();
    await classChatController.getChatBox();
    // print(" !!!!  ${classChatController.classChatBox}");
  }
}