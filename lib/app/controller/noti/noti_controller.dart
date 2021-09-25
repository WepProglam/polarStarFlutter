import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:meta/meta.dart';
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

class NotiController extends GetxController {
  final NotiRepository repository;
  final box = GetStorage();
  RxList<Rx<NotiModel>> noties = <Rx<NotiModel>>[].obs;
  RxInt pageViewIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);
  RxBool notiNotiFetched = false.obs;
  RxBool notiMailFetched = false.obs;
  RxList<Rx<MailBoxModel>> mailBox = <Rx<MailBoxModel>>[].obs; //쪽지함
  RxList<SaveNotiModel> readNoties = <SaveNotiModel>[].obs;
  RxList<SaveMailBoxModel> readMails = <SaveMailBoxModel>[].obs;

  NotiController({@required this.repository}) : assert(repository != null);

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
      Get.snackbar("오류", "오류");
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
    notiMailFetched.value = true;
  }

  @override
  onInit() async {
    super.onInit();
    await getNoties();
    await getMailBox();
  }

  @override
  onClose() async {
    super.onClose();
  }
}
