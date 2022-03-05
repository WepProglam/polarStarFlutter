import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/mailHistory/mail_controller.dart';
import 'package:polarstar_flutter/app/global_widgets/dialoge.dart';

void sendClassChatMail(int TARGET_PROFILE_ID,
    TextEditingController mailWriteController, MailController mailController) {
  Function ontapConfirm = () async {
    await Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20.0),
      title: "发送私信",
      titleStyle: const TextStyle(
          color: const Color(0xff6f6e6e),
          fontWeight: FontWeight.w400,
          fontFamily: "NotoSansSC",
          fontStyle: FontStyle.normal,
          fontSize: 12.0),
      barrierDismissible: true,
      content: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              width: Get.mediaQuery.size.width - 40,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  color: const Color(0xfff5f5f5)),
              child: TextFormField(
                controller: mailWriteController,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                    color: const Color(0xff6f6e6e),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                      color: const Color(0xff9b9b9b),
                      fontWeight: FontWeight.w500,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                ),
                minLines: 1,
                maxLines: 5,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                width: 280,
                height: 1,
                decoration: BoxDecoration(color: const Color(0xffd6d4d4))),
            Container(
              height: 50,
              child: Stack(children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Ink(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: // 한국문화와언어
                                Text("否",
                                    style: const TextStyle(
                                        color: const Color(0xff4570ff),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "NotoSansSC",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0),
                                    textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                      Ink(
                        child: InkWell(
                          onTap: () async {
                            String content = mailWriteController.text;
                            if (content.trim().isEmpty) {
                              return;
                            }

                            await mailController.sendClassChatMailOut(
                                TARGET_PROFILE_ID, content);
                            mailWriteController.clear();
                            Get.toNamed(
                                "/mail/${mailController.MAIL_BOX_ID.value}");
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Text("是",
                                  style: const TextStyle(
                                      color: const Color(0xff4570ff),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0),
                                  textAlign: TextAlign.center)),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: 1,
                      height: 20,
                      decoration:
                          BoxDecoration(color: const Color(0xffd6d4d4))),
                )
              ]),
            ),
          ],
        ),
      ),
    );
    Get.back();
    mailWriteController.clear();
  };
  Function ontapCancel = () {
    Get.back();
    mailWriteController.clear();
  };
  TFdialogue(Get.context, "发送私信", "确定要给对方发送私信吗?", ontapConfirm, ontapCancel);
}
