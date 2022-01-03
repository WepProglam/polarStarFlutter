// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_mail_dialog.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/post_menu_item.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_item.dart';
import 'package:polarstar_flutter/app/ui/android/photo/photo_layout.dart';
import 'package:polarstar_flutter/main.dart';

final double PostIconSize = 16;
final double CommentIconSize = 12;

class PostLayout extends StatelessWidget {
  final PostController c = Get.find();
  final MailController mailController = Get.find();
  final mailWriteController = TextEditingController();
  final MainController mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.only(
              bottom: 60.0 + ((c.bottomTextLine.value - 1) * 21)),
          child: Container(
              // height: Get.mediaQuery.size.height,
              // margin: const EdgeInsets.symmetric(horizontal: 15),
              child: RefreshIndicator(
            onRefresh: () async {
              print(Get.arguments);
              await MainUpdateModule.updatePost(type: c.callType);
            },
            child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: c.sortedList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (c.sortedList[index].value.DEPTH == 0) {
                    return PostWidget(
                      c: c,
                      mailWriteController: mailWriteController,
                      mailController: mailController,
                      item: c.sortedList[index],
                      index: index,
                      mainController: mainController,
                    );
                  } else if (c.sortedList[index].value.DEPTH == 1) {
                    return CommentWidget(
                        c: c,
                        mailWriteController: mailWriteController,
                        mailController: mailController,
                        item: c.sortedList[index].value,
                        index: index);
                  } else {
                    return CCWidget(
                        c: c,
                        mailWriteController: mailWriteController,
                        mailController: mailController,
                        item: c.sortedList[index].value,
                        index: index);
                  }
                }),
          )
              // SingleChildScrollView(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: finalPost,
              //   ),
              // ),
              ),
        ));
  }
}

class CCWidget extends StatelessWidget {
  const CCWidget({
    Key key,
    @required this.c,
    @required this.mailWriteController,
    @required this.mailController,
    @required this.item,
    @required this.index,
  }) : super(key: key);

  final PostController c;
  final TextEditingController mailWriteController;
  final MailController mailController;
  final Post item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xfff8f6fe)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(58, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * 구분선
            Container(
                width: Get.mediaQuery.size.width - 40,
                height: 1,
                decoration: BoxDecoration(color: const Color(0xffeaeaea))),

            // * 닉네임, 프사, 시간, 좋아요, 댓글, 옵션
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              child: CommnetTop(
                  item: item,
                  c: c,
                  index: index,
                  cidUrl: null,
                  mailWriteController: mailWriteController,
                  mailController: mailController),
            ),

            // 대댓 내용
            Padding(
              padding: const EdgeInsets.only(left: 0.0, bottom: 11),
              child: Text(item.CONTENT,
                  style: const TextStyle(
                      color: const Color(0xff242424),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansTC",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                  textAlign: TextAlign.justify),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    Key key,
    @required this.c,
    @required this.mailWriteController,
    @required this.mailController,
    @required this.item,
    @required this.index,
  }) : super(key: key);

  final PostController c;
  final TextEditingController mailWriteController;
  final MailController mailController;
  final Post item;
  final int index;

  @override
  Widget build(BuildContext context) {
    String cidUrl = '/board/${item.COMMUNITY_ID}/cid/${item.UNIQUE_ID}';

    return Container(
      decoration: BoxDecoration(color: const Color(0xfff8f6fe)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * 구분선
            Container(
                width: Get.mediaQuery.size.width - 40,
                height: 1,
                decoration: BoxDecoration(color: const Color(0xffeaeaea))),

            // * 닉네임, 프사, 시간, 좋아요, 댓글, 옵션
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              child: CommnetTop(
                  item: item,
                  c: c,
                  index: index,
                  cidUrl: cidUrl,
                  mailWriteController: mailWriteController,
                  mailController: mailController),
            ),

            // * 댓글 내용
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(item.CONTENT,
                  style: const TextStyle(
                      color: const Color(0xff242424),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansTC",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                  textAlign: TextAlign.justify),
            ),
          ],
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget(
      {Key key,
      @required this.c,
      @required this.mailWriteController,
      @required this.mailController,
      @required this.item,
      @required this.index,
      @required this.mainController})
      : super(key: key);

  final PostController c;
  final TextEditingController mailWriteController;
  final MailController mailController;
  final Rx<Post> item;
  final int index;
  final MainController mainController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: const Color(0xffeaeaea), width: 1),
        color: const Color(0xffffffff),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * 프사, 닉네임, 시간, 메뉴
            Container(
              margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: PostTop(
                  item: item,
                  c: c,
                  index: index,
                  mailWriteController: mailWriteController,
                  mailController: mailController),
            ),
            // * 본문 - 제목, 내용, 사진
            Container(
              margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: PostBody(item: item),
            ),

            // * 좋아요, 댓글, 스크랩 수
            Container(
              margin: EdgeInsets.only(top: 14),
              decoration: BoxDecoration(color: const Color(0x0a571df0)),
              child: PostBottom(
                  item: item,
                  mainController: mainController,
                  c: c,
                  index: index),
            ),
          ],
        ),
      ),
    );
  }
}
