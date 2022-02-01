// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/bottom_keyboard.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';

class Post extends StatelessWidget {
  final mailWriteController = TextEditingController();
  final BOTTOM_SHEET_HEIGHT = 60;
  final commentWriteController = TextEditingController();
  final PostController c = Get.find();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: AppBar(
            toolbarHeight: 56,

            backgroundColor: Get.theme.primaryColor,
            titleSpacing: 0,
            // elevation: 0,
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Ink(
                child: Image.asset(
                  'assets/images/back_icon.png',
                  // fit: BoxFit.fitWidth,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            centerTitle: true,
            title: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "成均馆大学",
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                    )
                  ],
                  text: communityBoardName(c.COMMUNITY_ID) == null
                      ? ""
                      : '${communityBoardName(c.COMMUNITY_ID)} / ',
                  style: const TextStyle(
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                ),
                textAlign: TextAlign.left),
          ),
          body: Obx(() {
            if (!c.dataAvailable) {
              return Center(child: CircularProgressIndicator());
            } else {
              return PostLayout();
            }
          }),
          bottomSheet: BottomKeyboard(
              BOTTOM_SHEET_HEIGHT: BOTTOM_SHEET_HEIGHT,
              commentWriteController: commentWriteController)),
    );
  }
}
