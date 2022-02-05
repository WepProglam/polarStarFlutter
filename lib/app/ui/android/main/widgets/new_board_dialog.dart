import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

void createNewCommunity(MainController mainController) {
  final TextEditingController communityNameController = TextEditingController();
  final TextEditingController communityDescriptionController =
      TextEditingController();
  Get.defaultDialog(
    // * 게시판 생성하기
    title: "创建论坛",
    titlePadding: const EdgeInsets.only(top: 20),
    titleStyle: const TextStyle(
        color: const Color(0xff6f6e6e),
        fontWeight: FontWeight.w400,
        fontFamily: "NotoSansSC",
        fontStyle: FontStyle.normal,
        fontSize: 12.0),
    barrierDismissible: true,
    content: Container(
      width: Get.mediaQuery.size.width - 40,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 24, left: 20, right: 20),
            padding: const EdgeInsets.only(top: 12, left: 20, bottom: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                color: const Color(0xfff5f5f5)),
            child: TextFormField(
              controller: communityNameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                // contentPadding: const EdgeInsets.only(bottom: 14),
                hintStyle: const TextStyle(
                    color: const Color(0xff9b9b9b),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                hintText: '论坛名称',
              ),
              maxLines: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
            padding: const EdgeInsets.only(top: 12, left: 20, bottom: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                color: const Color(0xfff5f5f5)),
            child: TextFormField(
              controller: communityDescriptionController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                // contentPadding: const EdgeInsets.only(bottom: 14),
                hintStyle: const TextStyle(
                    color: const Color(0xff9b9b9b),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                hintText: '论坛说明',
              ),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          // 선 122
          Container(
              margin: const EdgeInsets.only(top: 24, left: 20, right: 20),
              height: 1,
              decoration: BoxDecoration(color: const Color(0xffd6d4d4))),

          Ink(
            child: InkWell(
              onTap: () async {
                Get.back();

                String COMMUNITY_NAME = communityNameController.text.trim();
                String COMMUNITY_DESCRIPTION =
                    communityDescriptionController.text.trim();

                if (COMMUNITY_NAME.isEmpty ||
                    COMMUNITY_DESCRIPTION.trim().isEmpty) {
                  // Get.snackbar("텍스트를 작성해주세요", "텍스트를 작성해주세요");
                  return;
                }

                await mainController.createCommunity(
                    COMMUNITY_NAME, COMMUNITY_DESCRIPTION);
              },
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: Text("确认创建",
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
        ],
      ),
    ),
  );
}
