import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

void createNewCommunity(MainController mainController) {
  final TextEditingController communityNameController = TextEditingController();
  final TextEditingController communityDescriptionController =
      TextEditingController();
  Get.defaultDialog(
    title: "게시판 생성하기",
    barrierDismissible: true,
    content: Container(
      width: 300,
      child: Column(
        children: [
          TextFormField(
            controller: communityNameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: "게시판 이름"),
            maxLines: 1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: communityDescriptionController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: "게시판 설명"),
            minLines: 1,
            maxLines: 5,
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Get.theme.primaryColor)),
              onPressed: () async {
                Get.back();

                String COMMUNITY_NAME = communityNameController.text.trim();
                String COMMUNITY_DESCRIPTION =
                    communityDescriptionController.text.trim();

                if (COMMUNITY_NAME.isEmpty ||
                    COMMUNITY_DESCRIPTION.trim().isEmpty) {
                  Get.snackbar("텍스트를 작성해주세요", "텍스트를 작성해주세요");
                  return;
                }

                await mainController.createCommunity(
                    COMMUNITY_NAME, COMMUNITY_DESCRIPTION);
              },
              child: Text("발송"))
        ],
      ),
    ),
  );
}
