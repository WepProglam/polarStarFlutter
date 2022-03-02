import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/classChat/class_chat_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_page.dart';

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
    classChatController.past_totalHeightListView.value = 0;
    classChatController.isPageEnd.value = true;
    classChatController.toBottomButton.value = false;

    if (classChatController.findCurBox.value.ChatList.length == 0) {
      classChatController.chatDownloaed(false);
      classChatController.imagePreCached(false);
      await classChatController.getChatLog(int.parse(Get.arguments["roomID"]));
    }
  }
}
