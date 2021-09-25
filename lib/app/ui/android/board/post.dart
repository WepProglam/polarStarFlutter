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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: AppBar(
            toolbarHeight: 50,
            backgroundColor: Color(0xffffffff),
            foregroundColor: Color(0xff333333),
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 15 + 14.6 + 9.4,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 14.6),
                child: Ink(
                  child: Image.asset(
                    'assets/images/848.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            titleSpacing: 0,
            title: Text(
                communityBoardName(c.COMMUNITY_ID) == null
                    ? ""
                    : '${communityBoardName(c.COMMUNITY_ID)}',
                style: const TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.bold,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 21.0),
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
