import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/class/class_chat_controller.dart';
import 'package:polarstar_flutter/app/controller/loby/init_controller.dart';

import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/controller/class/class_controller.dart';
import 'package:polarstar_flutter/app/controller/class/write_comment_controller.dart';
import 'package:polarstar_flutter/app/ui/android/main/main_page.dart';

class ClassChatBinding implements Bindings {
  @override
  void dependencies() async {
    putController<ClassChatController>();
    ClassChatController classChatController = Get.find();

    classChatController.currentBoxID.value = int.parse(Get.arguments["roomID"]);
    print(
        "classChatController.findCurBox.value.ChatList.length : ${classChatController.findCurBox.value.ChatList.length}");

    classChatController.getChatProfileList(int.parse(Get.arguments["roomID"]));
    classChatController.isFirstEnter.value = true;
    classChatController.chatEnterAmouunt.value = 0;
    classChatController.searchIndex = 0;

    if (classChatController.findCurBox.value.ChatList.length == 0) {
      classChatController.chatDownloaed(false);
      classChatController.imagePreCached(false);
      await classChatController.getChatLog(int.parse(Get.arguments["roomID"]));
    }
  }
}
