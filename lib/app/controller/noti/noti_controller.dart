import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/controller/class/class_chat_controller.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/database_helper.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/src/db_mail.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/src/db_noti.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_repository.dart';
import 'package:polarstar_flutter/app/data/repository/noti/noti_repository.dart';
import 'package:polarstar_flutter/app/ui/android/class/class.dart';
import 'package:polarstar_flutter/session.dart';

class NotiController extends GetxController with SingleGetTickerProviderMixin {
  final NotiRepository repository;
  final box = GetStorage();
  final ClassChatController classChatController =
      Get.put(ClassChatController());
  RxList<Rx<NotiModel>> noties = <Rx<NotiModel>>[].obs;
  // RxInt pageViewIndex = 0.obs;
  // final PageController pageController = PageController(initialPage: 0);
  RxBool notiNotiFetched = false.obs;
  RxBool notiMailFetched = false.obs;
  RxList<Rx<MailBoxModel>> mailBox = <Rx<MailBoxModel>>[].obs; //쪽지함
  RxList<SaveNotiModel> readNoties = <SaveNotiModel>[].obs;
  RxList<SaveMailBoxModel> readMails = <SaveMailBoxModel>[].obs;
  TabController tabController;

  NotiController({@required this.repository}) : assert(repository != null);

  RxList<ChatModel> chatHistory = <ChatModel>[].obs;

  Future<void> getReadMails() async {
    readMails.value = await MAIL_DB_HELPER.queryAllRows();
  }

  Future<void> getReadNoties() async {
    readNoties.value = await NOTI_DB_HELPER.queryAllRows();
  }

  Future<void> setReadMails(SaveMailBoxModel mailBox) async {
    await MAIL_DB_HELPER.insert(mailBox);
  }

  Future<void> setReadNotied(SaveNotiModel noti) async {
    await NOTI_DB_HELPER.insert(noti);
  }

  Future<void> getNoties() async {
    await getReadNoties();
    var response = await Session().getX("/notification");
    Iterable notiList = jsonDecode(response.body);
    noties.value = notiList.map((e) => NotiModel.fromJson(e).obs).toList();

    for (var item in noties) {
      for (SaveNotiModel saveNoti in readNoties) {
        if (item.value.NOTI_ID == saveNoti.NOTI_ID) {
          item.update((val) {
            val.isReaded = true;
          });
          break;
        }
      }
    }
    notiNotiFetched.value = true;
  }

  Future<void> getMailBox() async {
    await getReadMails();
    //쪽지함 보기
    Map<String, dynamic> value = await repository.getMailBox();

    if (value["status"] != 200) {
      Get.snackbar("系统错误", "系统错误",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black);
      return;
    }
    mailBox.value = value["listMailBox"];

    for (var item in mailBox) {
      for (SaveMailBoxModel saveMailBox in readMails) {
        if (item.value.MAIL_BOX_ID == saveMailBox.MAIL_BOX_ID &&
            item.value.MAIL_ID == saveMailBox.MAIL_ID) {
          item.update((val) {
            val.isReaded = true;
          });
          break;
        }
      }
    }
    await sortMailBox();
    notiMailFetched.value = true;
  }

  bool isUnreadNotiExist() {
    for (Rx<NotiModel> item in noties) {
      if (!item.value.isReaded) {
        return false;
      }
    }

    for (Rx<MailBoxModel> item in mailBox) {
      if (!item.value.isReaded) {
        return false;
      }
    }

    for (Rx<ChatBoxModel> item in classChatController.majorChatBox) {
      if (item.value.UNREAD_AMOUNT > 0) {
        return false;
      }
    }

    for (Rx<ChatBoxModel> item in classChatController.classChatBox) {
      if (item.value.UNREAD_AMOUNT > 0) {
        return false;
      }
    }

    return true;
  }

  // Future<void> getChatBox() async {
  //   List<ChatBoxModel> tempBox = box.read("classSocket");
  //   chatBox.value = tempBox.map((e) => e.obs).toList();

  //   RxList<Rx<ChatModel>> tt = chatBox[0].value.ClassChatList;
  //   print(chatBox[0].value.ClassChatList);

  //   // var response = await Session().getX("/chat/chatBox");
  //   // Iterable chatBoxList = jsonDecode(response.body);
  //   // chatBox.value =
  //   //     chatBoxList.map((e) => ChatBoxModel.fromJson(e).obs).toList();
  //   // box.remove("classSocket");
  //   // List<int> tempClassList = [];
  //   // for (Rx<ChatBoxModel> item in chatBox) {
  //   //   tempClassList.add(item.value.CLASS_ID);
  //   // }
  // }

  Future<void> sortMailBox() async {
    mailBox
        .sort((a, b) => b.value.TIME_CREATED.compareTo(a.value.TIME_CREATED));
  }

  @override
  onInit() async {
    tabController = TabController(vsync: this, length: 3);

    super.onInit();
    await getNoties();
    await getMailBox();
    // await getChatBox();
  }

  @override
  onClose() async {
    super.onClose();
  }
}
