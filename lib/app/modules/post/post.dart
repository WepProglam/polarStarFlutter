// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/post/post_controller.dart';
import 'package:polarstar_flutter/app/modules/post/widgets/bottom_keyboard.dart';
import 'package:polarstar_flutter/app/modules/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/global_functions/board_name.dart';

class Post extends StatelessWidget {
  final mailWriteController = TextEditingController();
  final BOTTOM_SHEET_HEIGHT = 60;
  final commentWriteController = TextEditingController();
  final PostController c = Get.find();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.primaryColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: Color(0xffffffff),
            appBar: AppBar(
              toolbarHeight: 56,
              elevation: 0,

              backgroundColor: Colors.white,
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
                    color: Colors.black,
                    // fit: BoxFit.fitWidth,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () async {
                    String topic = "board_${c.COMMUNITY_ID}_bid_${c.BOARD_ID}";
                    if (c.isSubscribed.value) {
                      await c.pushyUnsubscribe(topic);
                    } else {
                      await c.pushySubscribe(topic);
                    }
                  },
                  child: Ink(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Obx(() {
                        return c.isSubscribed.value
                            ? Icon(
                                Icons.alarm_on,
                                color: Colors.black,
                              )
                            : Icon(
                                Icons.alarm_off,
                                color: Colors.black,
                              );
                      })),
                )
              ],
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
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Obx(() {
                if (!c.dataAvailable) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Stack(children: [
                    Opacity(
                        opacity: c.isPushySubUnsubcribing.value ? 0.3 : 1.0,
                        child: PostLayout()),
                    c.isPushySubUnsubcribing.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Get.theme.primaryColor,
                            ),
                          )
                        : Container()
                  ]);
                }
              }),
            ),
            bottomSheet: BottomKeyboard(
                BOTTOM_SHEET_HEIGHT: BOTTOM_SHEET_HEIGHT,
                commentWriteController: commentWriteController)),
      ),
    );
  }
}
