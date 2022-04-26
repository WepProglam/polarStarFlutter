// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkwell/linkwell.dart';
import 'package:polarstar_flutter/app/modules/post/functions/post_menu_item.dart';
import 'package:polarstar_flutter/app/modules/post/post_controller.dart';
import 'package:polarstar_flutter/app/modules/mailHistory/mail_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/modules/board/widgets/post_item.dart';
import 'package:polarstar_flutter/main.dart';

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
      // decoration: BoxDecoration(color: const Color(0xfff4f9ff)),
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
            Container(
              margin: const EdgeInsets.only(left: 37),
              padding: const EdgeInsets.only(left: 0.0, bottom: 0),
              child: LinkWell("${item.CONTENT}",
                  style: const TextStyle(
                      color: const Color(0xff242424),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
                  linkStyle: TextStyle(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
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
      // decoration: BoxDecoration(color: const Color(0xfff4f9ff)),
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
              margin: const EdgeInsets.only(left: 37),
              child: LinkWell("${item.value.CONTENT}",
                  style: const TextStyle(
                      color: const Color(0xff242424),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
                  linkStyle: TextStyle(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
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
            // * 본문 - 제목, 내용, 사진
            Container(
              margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: PostBody(
                item: item,
                c: c,
                index: index,
                mailController: mailController,
                mailWriteController: mailWriteController,
              ),
            ),

            // // * 좋아요, 댓글, 스크랩 수
            // Container(
            //   margin: EdgeInsets.only(top: 14),
            //   decoration: BoxDecoration(color: const Color(bottomColor)),
            //   child: PostBottom(
            //       item: item,
            //       mainController: mainController,
            //       c: c,
            //       index: index),
            // ),
            // // * 프사, 닉네임, 시간, 메뉴
            // Container(
            //   margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            //   child: PostTop(
            //       item: item,
            //       c: c,
            //       index: index,
            //       mailWriteController: mailWriteController,
            //       mailController: mailController),
            // ),
            Container(
                margin: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 프로필 사진
                    Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(right: 10),
                      child: CachedNetworkImage(
                        imageUrl: '${item.value.PROFILE_PHOTO}',
                        imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover))),
                      ),
                    ),
                    // * 닉네임, 작성 시간
                    Container(
                      // margin: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Text("${item.value.PROFILE_NICKNAME}",
                          style: TextStyle(
                              color: const Color(0xff2f2f2f),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.left),
                    ),
                    // Container(
                    //   // margin: const EdgeInsets.only(top: 4, bottom: 4),
                    //   child: Text(
                    //       "       ${item.value.TIME_CREATED}"
                    //           .substring(2, 19)
                    //           .replaceAll('-', '.')
                    //           .replaceAll('T', ' '),
                    //       style: const TextStyle(
                    //           color: const Color(0xff6f6e6e),
                    //           fontWeight: FontWeight.w400,
                    //           fontFamily: "Roboto",
                    //           fontStyle: FontStyle.normal,
                    //           fontSize: 12.0),
                    //       textAlign: TextAlign.left),
                    // ),
                    Spacer(),
                    // 게시글 좋아요 수 버튼
                    TextButton.icon(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff6f6e6e)),
                      ),
                      onPressed:
                          (mainController.isLiked(item.value) || c == null) ||
                                  item.value.MYSELF
                              ? null
                              : () async {
                                  /*if (item.value.MYSELF) {
                    Get.snackbar("게시글 좋아요", "내가 쓴 게시글에는 할 수 없습니다.",
                        colorText: Colors.white,
                        backgroundColor: Color(0xff6f6e6e),
                        snackPosition: SnackPosition.BOTTOM);
                  } else {*/
                                  int status_code = await c.totalSend(
                                      '/like/${item.value.COMMUNITY_ID}/id/${item.value.UNIQUE_ID}',
                                      '좋아요',
                                      index);
                                  print(status_code);
                                  //}
                                },
                      icon: Container(
                        width: PostIconSize,
                        height: PostIconSize,
                        child: (mainController.isLiked(item.value)
                            ? AssetImageBin.likeClickedIcon
                            : AssetImageBin.likeNoneIcon),
                      ),
                      label: Text(item.value.LIKES.toString(),
                          style: const TextStyle(
                              color: const Color(0xff6f6e6e),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.left),
                    ),
                    // 게시글 댓글 수 버튼
                    TextButton.icon(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                      onPressed: null,
                      icon: Container(
                        width: PostIconSize,
                        height: PostIconSize,
                        child: AssetImageBin.commentIcon,
                      ),
                      label: Text("${item.value.COMMENTS}",
                          style: const TextStyle(
                              color: const Color(0xff6f6e6e),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.left),
                    ),
                    // 게시글 스크랩 수 버튼
                    TextButton.icon(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                      onPressed: c == null
                          ? null
                          : () async {
                              if (mainController.isScrapped(item.value)) {
                                int status_code = await c.scrap_cancel(
                                    '/scrap/${item.value.COMMUNITY_ID}/id/${item.value.BOARD_ID}');
                              } else {
                                int status_code = await c.totalSend(
                                    '/scrap/${item.value.COMMUNITY_ID}/id/${item.value.BOARD_ID}',
                                    '스크랩',
                                    index);
                              }
                            },
                      icon: Container(
                        width: PostIconSize,
                        height: PostIconSize,
                        child: mainController.isScrapped(item.value)
                            ? AssetImageBin.scrapClickedIcon
                            : AssetImageBin.scrapNoneIcon,
                      ),
                      label: Text(item.value.SCRAPS.toString(),
                          style: const TextStyle(
                              color: const Color(0xff6f6e6e),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.left),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
