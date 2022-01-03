// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/bottom_keyboard.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';

class Post extends StatelessWidget {
  final mailWriteController = TextEditingController();
  final BOTTOM_SHEET_HEIGHT = 50;
  final commentWriteController = TextEditingController();
  final PostController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: AppBar(
            toolbarHeight: 56,

            backgroundColor: Get.theme.primaryColor,
            // elevation: 0,
            automaticallyImplyLeading: false,

            title: Stack(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.5),
                    child: Text(
                        communityBoardName(c.COMMUNITY_ID) == null
                            ? ""
                            : '${communityBoardName(c.COMMUNITY_ID)}',
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansTC",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        textAlign: TextAlign.left),
                  ),
                ),
                Positioned(
                  // left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    child: Ink(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          'assets/images/back_icon.png',
                          // fit: BoxFit.fitWidth,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
