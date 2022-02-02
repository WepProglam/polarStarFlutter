import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';

void sendMail(int UNIQUE_ID, int COMMUNITY_ID,
    TextEditingController mailWriteController, MailController mailController) {
  Get.defaultDialog(title: "发送私信 ", middleText: "确定要给对方发送私信吗?", actions: [
    TextButton(
        onPressed: () async {
          await Get.defaultDialog(
            title: "发送私信",
            barrierDismissible: true,
            content: Column(
              children: [
                TextFormField(
                  controller: mailWriteController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        child: Transform.scale(
                          scale: 1,
                          child: Obx(() {
                            return Checkbox(
                              value: mailController.mailAnonymous.value,
                              onChanged: (value) {
                                mailController.mailAnonymous.value = value;
                              },
                            );
                          }),
                        ),
                      ),
                      Text('匿名'),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      String content = mailWriteController.text;
                      if (content.trim().isEmpty) {
                        // Get.snackbar("텍스트를 작성해주세요", "텍스트를 작성해주세요");
                        return;
                      }

                      await mailController.sendMailOut(
                          UNIQUE_ID, COMMUNITY_ID, content);
                      mailWriteController.clear();
                      Get.toNamed("/mail/${mailController.MAIL_BOX_ID.value}");
                    },
                    child: Text("发送"))
              ],
            ),
          ).then((value) {
            Get.back();
            Get.back();
          });
        },
        child: Text("是")),
    TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text("否"))
  ]);

  mailWriteController.clear();
}
