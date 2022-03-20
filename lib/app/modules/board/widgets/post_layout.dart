// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkwell/linkwell.dart';
import 'package:polarstar_flutter/app/modules/post/post_controller.dart';
import 'package:polarstar_flutter/app/modules/mailHistory/mail_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/modules/board/widgets/post_item.dart';

const mainColor = 0xff4570ff;
const subColor = 0xff91bbff;
const whiteColor = 0xffffffff;
const textColor = 0xff2f2f2f;
const bottomColor = 0xfff4faff;

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
              margin: const EdgeInsets.only(top: 14),
              child: RefreshIndicator(
                onRefresh: () async {
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
                        if (index == 1) {
                          return Column(
                            children: [
                              // * 구분선
                              Container(
                                  width: Get.mediaQuery.size.width,
                                  height: 1,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffeaeaea))),
                              CommentWidget(
                                  c: c,
                                  mailWriteController: mailWriteController,
                                  mailController: mailController,
                                  item: c.sortedList[index],
                                  index: index),
                            ],
                          );
                        }
                        return CommentWidget(
                            c: c,
                            mailWriteController: mailWriteController,
                            mailController: mailController,
                            item: c.sortedList[index],
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
      decoration: BoxDecoration(color: const Color(0xfff4f9ff)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(58, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            // * 대댓 내용
            Padding(
              padding: const EdgeInsets.only(left: 0.0, bottom: 0),
              child: LinkWell("${item.CONTENT}",
                  style: const TextStyle(
                      color: const Color(0xff242424),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  linkStyle: TextStyle(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.justify),
            ),

            // * 구분선
            Container(
                margin: const EdgeInsets.only(top: 14),
                width: Get.mediaQuery.size.width - 40,
                height: 1,
                decoration: BoxDecoration(color: const Color(0xffeaeaea))),
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
  final Rx<Post> item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find();
    print("${item.value.CONTENT} ${mainController.isLiked(item.value)}");

    String cidUrl =
        '/board/${item.value.COMMUNITY_ID}/cid/${item.value.UNIQUE_ID}';

    return Container(
      decoration: BoxDecoration(color: const Color(0xfff4f9ff)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * 닉네임, 프사, 시간, 좋아요, 댓글, 옵션
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              child: CommnetTop(
                  item: item.value,
                  c: c,
                  index: index,
                  cidUrl: cidUrl,
                  mailWriteController: mailWriteController,
                  mailController: mailController),
            ),

            // * 댓글 내용
            Container(
              child: LinkWell("${item.value.CONTENT}",
                  style: const TextStyle(
                      color: const Color(0xff242424),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  linkStyle: TextStyle(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.justify),
            ),

            // * 구분선
            Container(
                margin: const EdgeInsets.only(top: 14),
                width: Get.mediaQuery.size.width - 40,
                height: 1,
                decoration: BoxDecoration(color: const Color(0xffeaeaea))),
          ],
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget(
      {Key key,
      this.c,
      this.mailWriteController,
      this.mailController,
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
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: const Color(0xffeaeaea), width: 1),
          boxShadow: [
            BoxShadow(
                color: const Color(0x0f000000),
                offset: Offset(0, 3),
                blurRadius: 10,
                spreadRadius: 0)
          ],
          color: const Color(whiteColor)),
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
              child: PostBody(item: item, c: c),
            ),

            // * 좋아요, 댓글, 스크랩 수
            Container(
              margin: EdgeInsets.only(top: 14),
              decoration: BoxDecoration(color: const Color(bottomColor)),
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
