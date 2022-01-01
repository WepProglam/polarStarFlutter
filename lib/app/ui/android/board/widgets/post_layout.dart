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
import 'package:polarstar_flutter/app/ui/android/photo/photo_layout.dart';
import 'package:polarstar_flutter/main.dart';

final double PostIconSize = 20;
final double CommentIconSize = 15;

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
              height: Get.mediaQuery.size.height,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: RefreshIndicator(
                onRefresh: () async {
                  print(Get.arguments);
                  await MainUpdateModule.updatePost(type: c.callType);
                },
                child: ListView.builder(
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
                        return returningComment(
                            c.sortedList[index].value, index);
                      } else {
                        return returningCC(c.sortedList[index].value, index);
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

  Widget returningComment(Post item, int index) {
    // String where = "outside";
    String cidUrl = '/board/${item.COMMUNITY_ID}/cid/${item.UNIQUE_ID}';

    return Container(
      decoration: BoxDecoration(
          borderRadius: index == 1
              ? BorderRadius.only(
                  topLeft: Radius.circular(17), topRight: Radius.circular(17))
              : BorderRadius.zero,
          color: Color(0xfff6f6f6)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.5, 11.3, 12.2, 0),
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
                              fontFamily: "PingFangSC",
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
                              fontFamily: "PingFangSC",
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
                                  if (c.autoFocusTextForm.value) {
                                    c.autoFocusTextForm(false);
                                  } else {
                                    c.putUrl.value = cidUrl;
                                    c.autoFocusTextForm(true);
                                  }
                                },
                                child: Container(
                                  width: CommentIconSize,
                                  height: CommentIconSize,
                                  child: Obx(() => FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: c.autoFocusTextForm.value &&
                                                c.putUrl.value == cidUrl
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
                                  await c.deleteResource(
                                      item.COMMUNITY_ID, item.UNIQUE_ID, "cid");
                                },
                                child: Container(
                                  width: CommentIconSize,
                                  height: CommentIconSize,
                                  margin: EdgeInsets.symmetric(horizontal: 9.2),
                                  child: Image.asset('assets/images/320.png'),
                                )),
                            // 대댓 작성 버튼
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
                                    child: Obx(
                                      () => c.isCcomment.value &&
                                              c.ccommentUrl.value == cidUrl
                                          ? Image.asset(
                                              'assets/images/comment.png')
                                          : Icon(
                                              Icons.add_comment_outlined,
                                            ),
                                    ),
                                  ),
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
                                    width: CommentIconSize,
                                    height: CommentIconSize,
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
                                            fontFamily: "PingFangSC",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),

                            // 신고 버튼
                            InkWell(
                              onTap: () async {
                                var ARREST_TYPE = await c.getArrestType();
                                print(ARREST_TYPE);
                                if (ARREST_TYPE != null) {
                                  await c.totalSend(
                                      '/arrest/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}?ARREST_TYPE=$ARREST_TYPE',
                                      '신고',
                                      index);
                                }
                              },
                              child: Container(
                                width: CommentIconSize,
                                height: CommentIconSize,
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
                                    width: CommentIconSize,
                                    height: CommentIconSize,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 9.2),
                                    child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Icon(Icons.mail_outlined)))),
                            // 대댓 작성 버튼
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
                                    child: Obx(
                                      () => c.isCcomment.value &&
                                              c.ccommentUrl.value == cidUrl
                                          ? Image.asset(
                                              'assets/images/comment.png')
                                          : Icon(
                                              Icons.add_comment_outlined,
                                            ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
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
                      fontFamily: "PingFangSC",
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

  Widget returningCC(Post item, int index) {
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
                              fontFamily: "PingFangSC",
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
                              fontFamily: "PingFangSC",
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
                                            fontFamily: "PingFangSC",
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
                      fontFamily: "PingFangSC",
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
    print("rebuild");
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 18.5),
      decoration: BoxDecoration(
          color: Color(0xffffffff),
          boxShadow: [
            BoxShadow(
                color: const Color(0x1c000000),
                offset: Offset(0, 6),
                blurRadius: 14,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(top: 9),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: const EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 프로필 사진
                Container(
                  height: 39,
                  width: 39,
                  margin: const EdgeInsets.only(right: 11.8),
                  child: CachedNetworkImage(
                    imageUrl: '${item.value.PROFILE_PHOTO}',
                    imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover))),
                  ),
                ),
                //닉네임, 작성 시간
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.value.PROFILE_NICKNAME,
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.bold,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0),
                        textAlign: TextAlign.left),
                    Text(
                        item.value.TIME_CREATED
                            .substring(2, 19)
                            .replaceAll('-', '/')
                            .replaceAll('T', ' '),
                        style: const TextStyle(
                            color: const Color(0xff999999),
                            fontWeight: FontWeight.normal,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 11.0),
                        textAlign: TextAlign.left),
                  ],
                ),
                Spacer(),

                item.value.MYSELF
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 9.2),
                            child: InkWell(
                              onTap: () {
                                // 게시글 수정
                                Get.defaultDialog(
                                    title: "게시글 수정",
                                    middleText: "수정하시겠습니까?",
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            Get.offAndToNamed(
                                                '/board/${item.value.COMMUNITY_ID}/bid/${item.value.BOARD_ID}',
                                                arguments: item);
                                          },
                                          child: Text("네")),
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text("아니요"))
                                    ]);
                              },
                              child: Ink(
                                width: PostIconSize,
                                height: PostIconSize,
                                child: Image.asset('assets/images/934.png'),
                              ),
                            ),
                          ),
                          // 게시글 삭제
                          InkWell(
                            onTap: () async {
                              await c.deleteResource(item.value.COMMUNITY_ID,
                                  item.value.UNIQUE_ID, "bid");
                            },
                            child: Ink(
                              width: PostIconSize,
                              height: PostIconSize,
                              child: Image.asset('assets/images/15_4.png'),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 게시글 신고
                          Padding(
                            padding: const EdgeInsets.only(right: 9.2),
                            child: InkWell(
                              onTap: () async {
                                await c.totalSend(
                                    '/arrest/${item.value.COMMUNITY_ID}/id/${item.value.BOARD_ID}?ARREST_TYPE=',
                                    '신고',
                                    index);
                              },
                              child: Ink(
                                  width: PostIconSize,
                                  height: PostIconSize,
                                  child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child:
                                          Icon(Icons.report_problem_outlined))),
                            ),
                          ),
                          // 쪽지
                          InkWell(
                            onTap: () async {
                              await sendMail(
                                  item.value.UNIQUE_ID,
                                  item.value.COMMUNITY_ID,
                                  mailWriteController,
                                  mailController);
                            },
                            child: Ink(
                                width: PostIconSize,
                                height: PostIconSize,
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Icon(Icons.mail_outlined))),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          // 제목
          Container(
            margin:
                const EdgeInsets.fromLTRB(11.5, 46.6 - 39, 11.5, 72.7 - 57.6),
            child: Text("${item.value.TITLE}",
                style: const TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.bold,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0),
                textAlign: TextAlign.left),
          ),
          // 내용
          Container(
            margin: const EdgeInsets.fromLTRB(11.5, 0, 11.5, 119 - 104.1),
            child: Text("${item.value.CONTENT}",
                style: const TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.normal,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),
          ),
          //사진
          (item.value.PHOTO != [] &&
                  item.value.PHOTO != null &&
                  item.value.PHOTO.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
                  child: PhotoLayout(model: item.value),
                )
              : Container(),
          // 좋아요, 댓글, 스크랩 수
          Container(
            margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                border: BorderDirectional(
                    top: BorderSide(
                        width: 0.5, color: const Color(0xfff0f0f0)))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 게시글 좋아요 수 버튼
                  TextButton.icon(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () async {
                      if (item.value.MYSELF) {
                        Get.snackbar("게시글 좋아요", "내가 쓴 게시글에는 할 수 없습니다.",
                            snackPosition: SnackPosition.BOTTOM);
                      } else if (mainController.isLiked(item.value)) {
                      } else {
                        int status_code = await c.totalSend(
                            '/like/${item.value.COMMUNITY_ID}/id/${item.value.UNIQUE_ID}',
                            '좋아요',
                            index);
                        // // * 뒤로가기 했을 때 게시글 리스트에서도 숫자 반영
                        // c.increaseLike(item.value, status_code);
                      }
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
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w700,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
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
                      child: Image.asset('assets/images/comment.png'),
                    ),
                    label: Text("${c.sortedList.length - 1}",
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w700,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        textAlign: TextAlign.left),
                  ),
                  // 게시글 스크랩 수 버튼
                  TextButton.icon(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black)),
                    onPressed: () async {
                      if (mainController.isScrapped(item.value)) {
                        int status_code = await c.scrap_cancel(
                            '/scrap/${item.value.COMMUNITY_ID}/id/${item.value.BOARD_ID}');
                        // // * 뒤로가기 했을 때 게시글 리스트에서도 숫자 반영
                        // c.decreaseScrap(item.value, status_code);
                      } else {
                        int status_code = await c.totalSend(
                            '/scrap/${item.value.COMMUNITY_ID}/id/${item.value.BOARD_ID}',
                            '스크랩',
                            index);
                        // // * 뒤로가기 했을 때 게시글 리스트에서도 숫자 반영
                        // c.increaseScrap(item.value, status_code);
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
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w700,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// bool isLiked() {
//   final MainController mainController = Get.find();
//   final PostController c = Get.find();

//   for (int i = 0; i < mainController.likeList.length; i++) {
//     if (mainController.likeList[i].UNIQUE_ID == c.BOARD_ID) {
//       if (mainController.likeList[i].COMMUNITY_ID == c.COMMUNITY_ID) {
//         return true;
//       }
//     }
//   }

//   return false;
// }

// bool isScrapped(Post item) {
//   // // final MainController mainController = Get.find();
//   // mainController.refreshScrapList();
//   // // final PostController c = Get.find();

//   // print("다시 검사");
//   // print("${c.BOARD_ID}  :  ${c.COMMUNITY_ID}");
//   // print("asdfdafa legnth: ${mainController.scrapList.length}");
//   // final box = GetStorage();
//   // var sd = box.read("scrap");
//   // print("asdfdafa legnth: ${sd.length}");

//   // for (int i = 0; i < mainController.scrapList.length; i++) {
//   //   final bool bidSame = (mainController.scrapList[i].UNIQUE_ID == c.BOARD_ID);
//   //   final bool cidSame =
//   //       (mainController.scrapList[i].COMMUNITY_ID == c.COMMUNITY_ID);
//   //   print(
//   //       "${mainController.scrapList[i].UNIQUE_ID}  :  ${mainController.scrapList[i].COMMUNITY_ID}");
//   //   if (cidSame && bidSame) {
//   //     return true;
//   //   }
//   // }
//   // print("false");

//   // return false;
//   print(item.isScraped);
//   return item.isScraped;
// }
