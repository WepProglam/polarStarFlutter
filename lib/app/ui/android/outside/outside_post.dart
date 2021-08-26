// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/outside/post_controller.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';
import 'package:polarstar_flutter/app/ui/android/outside/widgets/outside_post_layout.dart';

class OutSidePost extends StatelessWidget {
  final mailWriteController = TextEditingController();
  final BOTTOM_SHEET_HEIGHT = 60;
  final OutSidePostController c = Get.find();
  final commentWriteController = TextEditingController();

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
              return OutSidePostLayout(
                c: c,
              );
            }
          })),
    );
  }
}
