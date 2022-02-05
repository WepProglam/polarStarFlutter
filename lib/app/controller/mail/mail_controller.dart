import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailSend_model.dart';
import 'package:polarstar_flutter/app/data/repository/mail/mail_repository.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/dialoge.dart';
import 'package:polarstar_flutter/session.dart';

class MailController extends GetxController {
  final MailRepository repository;
  final box = GetStorage();

  MailController({@required this.repository}) : assert(repository != null);
  RxBool dataAvailableMailSendPage = false.obs;
  final scrollController = new ScrollController(initialScrollOffset: 0);

  RxBool mailAnonymous = false.obs; //쪽지함 익명
  RxInt MAIL_BOX_ID = 0.obs; //쪽지함 ID

  RxList<MailHistoryModel> mailHistory = <MailHistoryModel>[].obs; //쪽지내역
  Rx<MailProfile> opponentProfile = MailProfile().obs; //쪽지 상대방 프로필
  Rx<MailProfile> myProfile = MailProfile().obs; //쪽지 상대방 프로필

  final NotiController notiController = Get.find();
  RxBool tapTextField = false.obs;
  ScrollController chatScrollController =
      ScrollController(initialScrollOffset: 0.0);
  FocusNode chatFocusNode = FocusNode();

  @override
  onInit() async {
    super.onInit();
  }

  @override
  onClose() async {
    super.onClose();
  }

  //쪽지 보내느 함수
  Future<void> sendMailIn(String content, ScrollController controller) async {
    if (content.trim().isEmpty) {
      //빈 값 보내면 snackBar 반환
      Get.snackbar("请输入文本", "请输入文本", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    var response = await repository.sendMailIn(MAIL_BOX_ID.value, content);

    switch (response["status"]) {
      case 200:
        //mailHistory(Obs)에 추가 =>  돔 자동 수정
        DateTime now = DateTime.now();
        mailHistory.add(MailHistoryModel.fromJson(
            {"FROM_ME": 1, "CONTENT": content, "TIME_CREATED": "${now}"}));
        List<Rx<MailBoxModel>> tempMailBox = [];
        MailBoxModel temp;
        for (Rx<MailBoxModel> item in notiController.mailBox) {
          if (item.value.MAIL_BOX_ID == MAIL_BOX_ID.value) {
            item.update((val) {
              val.CONTENT = content;
              val.TIME_CREATED = now;
            });
            temp = item.value;
          }

          tempMailBox.add(item);
        }

        notiController.mailBox.removeWhere(
            (element) => element.value.MAIL_BOX_ID == MAIL_BOX_ID.value);
        notiController.mailBox.insert(0, temp.obs);

        break;

      default:
        Get.snackbar("发送私信失败", "发送私信失败");
    }
  }

  void sendMailOut(int UNIQUE_ID, int COMMUNITY_ID, String content) async {
    if (content.trim().isEmpty) {
      Get.snackbar("请输入文本", "请输入文本");
      return;
    }

    Map<String, dynamic> value =
        await repository.sendMailOut(UNIQUE_ID, COMMUNITY_ID, content);

    switch (value["status"]) {
      case 200:
        Get.back();
        // Get.snackbar("쪽지 전송 완료", "쪽지 전송 완료", snackPosition: SnackPosition.TOP);

        int targetMessageBoxID = value["MAIL_BOX_ID"];
        MAIL_BOX_ID.value = targetMessageBoxID;

        await getMail();
        await notiController.sortMailBox();

        break;
      case 403:
        Get.snackbar("系统错误", "系统错误", snackPosition: SnackPosition.TOP);
        break;

      default:
        Get.snackbar("系统错误", "系统错误", snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> getMail() async {
    //쪽지 내역 보기

    Map<String, dynamic> value = await repository.getMail(MAIL_BOX_ID.value);
    if (value["status"] != 200) {
      await Textdialogue(Get.context, "삭제된 페이지입니다.", "삭제된 페이지입니다.");
      await Get.back();
      return;
    }

    mailHistory.value = value["listMailHistory"];
    opponentProfile.value = value["target_profile"];
    myProfile.value = value["profile"];
    dataAvailableMailSendPage.value = true;
  }
}
