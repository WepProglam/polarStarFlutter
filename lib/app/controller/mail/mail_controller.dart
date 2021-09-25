import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailSend_model.dart';
import 'package:polarstar_flutter/app/data/repository/mail/mail_repository.dart';
import 'package:polarstar_flutter/session.dart';

class MailController extends GetxController {
  final MailRepository repository;
  final box = GetStorage();

  MailController({@required this.repository}) : assert(repository != null);
  RxBool dataAvailableMailSendPage = false.obs;
  final ScrollController scrollController =
      new ScrollController(initialScrollOffset: 0);

  RxBool mailAnonymous = false.obs; //쪽지함 익명
  RxInt MAIL_BOX_ID = 0.obs; //쪽지함 ID

  RxList<MailHistoryModel> mailHistory = <MailHistoryModel>[].obs; //쪽지내역
  Rx<MailProfile> opponentProfile = MailProfile().obs; //쪽지 상대방 프로필
  Rx<MailProfile> myProfile = MailProfile().obs; //쪽지 상대방 프로필

  final NotiController notiController = Get.find();

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
      Get.snackbar("텍스트를 입력해주세요", "텍스트를 입력해주세요",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    var response = await repository.sendMailIn(MAIL_BOX_ID.value, content);

    switch (response["status"]) {
      case 200:
        //mailHistory(Obs)에 추가 =>  돔 자동 수정
        mailHistory.add(MailHistoryModel.fromJson({
          "FROM_ME": 1,
          "CONTENT": content,
          "TIME_CREATED": DateTime.now()
        }));

        //mailBox에서 해당 mail 찾아서 미리보기 내용 바꿈
        for (Rx<MailBoxModel> item in notiController.mailBox) {
          if (item.value.MAIL_BOX_ID == MAIL_BOX_ID.value) {
            item.update((val) {
              val.CONTENT = content;
            });
          }
        }
        break;

      default:
        Get.snackbar("쪽지 보내기 실패", "쪽지 보내기 실패");
    }
  }

  void sendMailOut(int UNIQUE_ID, int COMMUNITY_ID, String content) async {
    if (content.trim().isEmpty) {
      Get.snackbar("텍스트를 작성해주세요", "텍스트를 작성해주세요");
      return;
    }

    Map<String, dynamic> value =
        await repository.sendMailOut(UNIQUE_ID, COMMUNITY_ID, content);

    switch (value["status"]) {
      case 200:
        Get.back();
        Get.snackbar("쪽지 전송 완료", "쪽지 전송 완료", snackPosition: SnackPosition.TOP);

        int targetMessageBoxID = value["MAIL_BOX_ID"];
        MAIL_BOX_ID.value = targetMessageBoxID;

        await getMail();

        break;
      case 403:
        Get.snackbar("다른 사람의 쪽지함입니다.", "다른 사람의 쪽지함입니다.",
            snackPosition: SnackPosition.TOP);
        break;

      default:
        Get.snackbar("업데이트 되지 않았습니다.", "업데이트 되지 않았습니다.",
            snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> getMail() async {
    //쪽지 내역 보기

    print("/message/${MAIL_BOX_ID.value}");
    Map<String, dynamic> value = await repository.getMail(MAIL_BOX_ID.value);
    if (value["status"] != 200) {
      Get.snackbar("오류", "오류");
      return;
    }

    mailHistory.value = value["listMailHistory"];
    opponentProfile.value = value["target_profile"];
    myProfile.value = value["profile"];
    dataAvailableMailSendPage.value = true;
  }
}
