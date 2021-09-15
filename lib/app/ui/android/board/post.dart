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
          appBar: AppBar(
            title: Text('${communityBoardName(c.COMMUNITY_ID)}'),
          ),
          body: Obx(() {
            if (!c.dataAvailable) {
              return CircularProgressIndicator();
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
