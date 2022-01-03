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
      color: Color(0xfff6f6f6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25.3, 9.7, 12.2, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 9.2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프사
                  Container(
                    height: 39,
                    width: 39,
                    margin: const EdgeInsets.only(right: 11.8),
                    child: CachedNetworkImage(
                      imageUrl: '${item.PROFILE_PHOTO}',
                      imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover))),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.PROFILE_NICKNAME,
                          style: const TextStyle(
                              color: const Color(0xff333333),
                              fontWeight: FontWeight.w700,
                              // fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0),
                          textAlign: TextAlign.left),
                      // 댓글 작성 시간
                      Text(
                          item.TIME_CREATED
                              .substring(2, 19)
                              .replaceAll('-', '/')
                              .replaceAll('T', ' '),
                          style: const TextStyle(
                              color: const Color(0xff999999),
                              fontWeight: FontWeight.w400,
                              // fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 11.0),
                          textAlign: TextAlign.left),
                    ],
                  ),
                  Spacer(),

                  // 버튼들
                  item.MYSELF
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 수정 버튼
                            InkWell(
                                onTap: () async {
                                  String putUrl =
                                      '/board/${item.COMMUNITY_ID}/ccid/${item.UNIQUE_ID}';
                                  if (c.autoFocusTextForm.value &&
                                      c.putUrl.value == putUrl) {
                                    c.autoFocusTextForm.value = false;
                                    c.putUrl.value = putUrl;
                                  } else {
                                    c.autoFocusTextForm.value = true;
                                    c.putUrl.value = putUrl;
                                  }
                                },
                                child: Container(
                                  width: 11,
                                  height: 11,
                                  child: Obx(() => FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: c.autoFocusTextForm.value &&
                                                c.putUrl.value ==
                                                    '/board/${item.COMMUNITY_ID}/ccid/${item.UNIQUE_ID}'
                                            ? Image.asset(
                                                'assets/images/comment.png',
                                              )
                                            : Icon(
                                                Icons.edit_outlined,
                                              ),
                                      )),
                                )),

                            // 삭제 버튼
                            InkWell(
                                onTap: () async {
                                  await c.deleteResource(item.COMMUNITY_ID,
                                      item.UNIQUE_ID, "ccid");
                                },
                                child: Container(
                                  width: 11,
                                  height: 11,
                                  margin: EdgeInsets.only(left: 9.2),
                                  child: Image.asset('assets/images/320.png'),
                                )),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 좋아요 버튼
                            InkWell(
                              onTap: () async {
                                await c.totalSend(
                                    '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                                    '좋아요',
                                    index);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 10.6,
                                    height: 10.6,
                                    child: Image.asset(
                                      'assets/images/good.png',
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 9.9),
                                    child: Text(item.LIKES.toString(),
                                        style: const TextStyle(
                                            color: const Color(0xff333333),
                                            fontWeight: FontWeight.w400,
                                            // fontFamily: "PingFangSC",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 10.0),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),

                            // 신고 버튼
                            InkWell(
                              onTap: () async {
                                var ARREST_TYPE = await c.getArrestType();
                                await c.totalSend(
                                    '/arrest/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}?ARREST_TYPE=$ARREST_TYPE',
                                    '신고',
                                    index);
                              },
                              child: Container(
                                width: 11,
                                height: 11,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Icon(
                                    Icons.report_problem_outlined,
                                    // 댓글 신고
                                  ),
                                ),
                              ),
                            ),

                            // 쪽지 버튼
                            InkWell(
                                onTap: () async {
                                  await sendMail(
                                      item.UNIQUE_ID,
                                      item.COMMUNITY_ID,
                                      mailWriteController,
                                      mailController);
                                },
                                child: Container(
                                    width: 11,
                                    height: 11,
                                    margin: EdgeInsets.only(left: 9.2),
                                    child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Icon(Icons.mail_outlined)))),
                          ],
                        ),
                ],
              ),
            ),

            // 대댓 내용
            Padding(
              padding: const EdgeInsets.only(left: 74.8 - 25.3, bottom: 9.7),
              child: Text(item.CONTENT,
                  style: const TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.w400,
                      // fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left),
            ),

            Container(
              width: Get.mediaQuery.size.width - (74.8 - 25.3) - 30,
              height: 0.5,
              margin: const EdgeInsets.only(left: 74.8 - 25.3),
              decoration: BoxDecoration(color: const Color(0xffdedede)),
            )
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
    // String where = "outside";
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
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // * 프사
                  Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(right: 8),
                    child: CachedNetworkImage(
                      imageUrl: '${item.PROFILE_PHOTO}',
                      imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover))),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // * 닉네임
                      Container(
                        child: Text("${item.PROFILE_NICKNAME}",
                            style: const TextStyle(
                                color: const Color(0xff2f2f2f),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansTC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left),
                      ),

                      // * 댓글 작성 시간, 좋아요 수
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: Row(children: [
                          Container(
                            margin: const EdgeInsets.only(top: 1),
                            child: Text(
                                "${item.TIME_CREATED}"
                                    .substring(2, 19)
                                    .replaceAll('-', '.')
                                    .replaceAll('T', ' '),
                                style: const TextStyle(
                                    color: const Color(0xff6f6e6e),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Roboto",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                                textAlign: TextAlign.left),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Image.asset(
                                "assets/images/icn_reply_like_color.png"),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: // 99
                                Text("99",
                                    style: const TextStyle(
                                        color: const Color(0xff571df0),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Roboto",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.0),
                                    textAlign: TextAlign.left),
                          )
                        ]),
                      ),
                    ],
                  ),
                  Spacer(),

                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    // * 좋아요 버튼
                    InkWell(
                      onTap: () async {
                        await c.totalSend(
                            '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                            '좋아요',
                            index);
                      },
                      child: Container(
                          width: CommentIconSize,
                          height: CommentIconSize,
                          child: AssetImageBin.like_none),
                    ),
                    // * 댓글
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: InkWell(
                        onTap: () async {
                          await c.totalSend(
                              '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                              '좋아요',
                              index);
                        },
                        child: // 대댓 작성 버튼
                            InkWell(
                                onTap: () {
                                  c.changeCcomment(cidUrl);
                                  c.makeCcommentUrl(
                                      item.COMMUNITY_ID, item.UNIQUE_ID);
                                  c.autoFocusTextForm(false);
                                },
                                child: Container(
                                  width: CommentIconSize,
                                  height: CommentIconSize,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Obx(() => c.isCcomment.value &&
                                            c.ccommentUrl.value == cidUrl
                                        ? Image.asset(
                                            'assets/images/icn_reply_comment_normal.png')
                                        : Image.asset(
                                            'assets/images/icn_reply_comment_normal.png')),
                                  ),
                                )),
                      ),
                    ),

                    // * 메뉴
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: InkWell(
                        onTap: () async {
                          await c.totalSend(
                              '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                              '좋아요',
                              index);
                        },
                        // TODO: 기능 삽입
                        child: PopupMenuButton(
                            child: Container(
                              width: CommentIconSize,
                              height: CommentIconSize,
                              child: Image.asset("assets/images/icn_more.png"),
                            ),
                            onSelected: (value) async {
                              // if (value == "게시글 수정") {
                              //   await updatePostFunc(item);
                              // } else if (value == "게시글 삭제") {
                              //   await deletePostFunc(item, c);
                              // } else if (value == "게시글 신고") {
                              //   await arrestPostFunc(c, item, index);
                              // } else if (value == "쪽지 보내기") {
                              //   await sendMailPostFunc(
                              //       c, item, mailWriteController, mailController);
                              // }
                            },
                            itemBuilder: (context) {
                              if (item.MYSELF) {
                                return [
                                  PopupMenuItem(
                                    child: Text("게시글 수정"),
                                    value: "게시글 수정",
                                  ),
                                  PopupMenuItem(
                                    child: Text("게시글 삭제"),
                                    value: "게시글 삭제",
                                  ),
                                ];
                              } else {
                                return [
                                  PopupMenuItem(
                                    child: Text("게시글 신고"),
                                    value: "게시글 신고",
                                  ),
                                  PopupMenuItem(
                                    child: Text("쪽지 보내기"),
                                    value: "쪽지 보내기",
                                  ),
                                ];
                              }
                            }),
                      ),
                    ),
                  ]),

                  // // 버튼들
                  // item.MYSELF
                  //     ? Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           // 수정 버튼
                  //           InkWell(
                  //               onTap: () async {
                  //                 if (c.autoFocusTextForm.value) {
                  //                   c.autoFocusTextForm(false);
                  //                 } else {
                  //                   c.putUrl.value = cidUrl;
                  //                   c.autoFocusTextForm(true);
                  //                 }
                  //               },
                  //               child: Container(
                  //                 width: CommentIconSize,
                  //                 height: CommentIconSize,
                  //                 child: Obx(() => FittedBox(
                  //                       fit: BoxFit.fitHeight,
                  //                       child: c.autoFocusTextForm.value &&
                  //                               c.putUrl.value == cidUrl
                  //                           ? AssetImageBin.commentIcon
                  //                           : Icon(
                  //                               Icons.edit_outlined,
                  //                             ),
                  //                     )),
                  //               )),

                  //           // 삭제 버튼
                  //           InkWell(
                  //               onTap: () async {
                  //                 await c.deleteResource(
                  //                     item.COMMUNITY_ID, item.UNIQUE_ID, "cid");
                  //               },
                  //               child: Container(
                  //                 width: CommentIconSize,
                  //                 height: CommentIconSize,
                  //                 margin: EdgeInsets.symmetric(horizontal: 9.2),
                  //                 child: Image.asset('assets/images/320.png'),
                  //               )),
                  //           // 대댓 작성 버튼
                  //           InkWell(
                  //               onTap: () {
                  //                 c.changeCcomment(cidUrl);
                  //                 c.makeCcommentUrl(
                  //                     item.COMMUNITY_ID, item.UNIQUE_ID);
                  //                 c.autoFocusTextForm(false);
                  //               },
                  //               child: Container(
                  //                 width: CommentIconSize,
                  //                 height: CommentIconSize,
                  //                 child: FittedBox(
                  //                   fit: BoxFit.fitHeight,
                  //                   child: Obx(
                  //                     () => c.isCcomment.value &&
                  //                             c.ccommentUrl.value == cidUrl
                  //                         ? Image.asset(
                  //                             'assets/images/comment.png')
                  //                         : Icon(
                  //                             Icons.add_comment_outlined,
                  //                           ),
                  //                   ),
                  //                 ),
                  //               )),
                  //         ],
                  //       )
                  //     : Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           // 좋아요 버튼
                  //           InkWell(
                  //             onTap: () async {
                  //               await c.totalSend(
                  //                   '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                  //                   '좋아요',
                  //                   index);
                  //             },
                  //             child: Row(
                  //               children: [
                  //                 Container(
                  //                     width: CommentIconSize,
                  //                     height: CommentIconSize,
                  //                     child: AssetImageBin.like_none),
                  //               ],
                  //             ),
                  //           ),

                  //           // 신고 버튼
                  //           InkWell(
                  //             onTap: () async {
                  //               var ARREST_TYPE = await c.getArrestType();
                  //               print(ARREST_TYPE);
                  //               if (ARREST_TYPE != null) {
                  //                 await c.totalSend(
                  //                     '/arrest/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}?ARREST_TYPE=$ARREST_TYPE',
                  //                     '신고',
                  //                     index);
                  //               }
                  //             },
                  //             child: Container(
                  //               width: CommentIconSize,
                  //               height: CommentIconSize,
                  //               child: FittedBox(
                  //                 fit: BoxFit.fitHeight,
                  //                 child: Icon(
                  //                   Icons.report_problem_outlined,
                  //                   // 댓글 신고
                  //                 ),
                  //               ),
                  //             ),
                  //           ),

                  //           // 쪽지 버튼
                  //           InkWell(
                  //               onTap: () async {
                  //                 await sendMail(
                  //                     item.UNIQUE_ID,
                  //                     item.COMMUNITY_ID,
                  //                     mailWriteController,
                  //                     mailController);
                  //               },
                  //               child: Container(
                  //                   width: CommentIconSize,
                  //                   height: CommentIconSize,
                  //                   margin:
                  //                       EdgeInsets.symmetric(horizontal: 9.2),
                  //                   child: FittedBox(
                  //                       fit: BoxFit.fitHeight,
                  //                       child: Icon(Icons.mail_outlined)))),
                  //           // 대댓 작성 버튼
                  //           InkWell(
                  //               onTap: () {
                  //                 c.changeCcomment(cidUrl);
                  //                 c.makeCcommentUrl(
                  //                     item.COMMUNITY_ID, item.UNIQUE_ID);
                  //                 c.autoFocusTextForm(false);
                  //               },
                  //               child: Container(
                  //                 width: CommentIconSize,
                  //                 height: CommentIconSize,
                  //                 child: FittedBox(
                  //                   fit: BoxFit.fitHeight,
                  //                   child: Obx(
                  //                     () => c.isCcomment.value &&
                  //                             c.ccommentUrl.value == cidUrl
                  //                         ? Image.asset(
                  //                             'assets/images/comment.png')
                  //                         : Icon(
                  //                             Icons.add_comment_outlined,
                  //                           ),
                  //                   ),
                  //                 ),
                  //               )),
                  // ],
                  // ),
                ],
              ),
            ),
            // 댓글 내용
            Padding(
              padding: const EdgeInsets.only(bottom: 9.7),
              child: Text(item.CONTENT,
                  style: const TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.w400,
                      // fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left),
            ),
            Container(
              width: Get.mediaQuery.size.width - 30,
              height: 0.5,
              decoration: BoxDecoration(color: const Color(0xffdedede)),
            )
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
