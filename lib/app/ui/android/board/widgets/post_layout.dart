// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_mail_dialog.dart';

class PostLayout extends StatelessWidget {
  PostLayout({this.c});

  final PostController c;

  final MailController mailController = Get.find();
  final mailWriteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> finalPost = [];
    c.sortedList.forEach((Post item) {
      finalPost.addAll(item.DEPTH == 0
          ? returningPost(item)
          : item.DEPTH == 1
              ? returningComment(item)
              : returningCC(item));
    });

    return Container(
      height: MediaQuery.of(context).size.height - 60 - 100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: finalPost,
        ),
      ),
    );
  }

  List<Widget> returningPost(Post item) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration:
              BoxDecoration(border: BorderDirectional(top: BorderSide())),
          child: Row(
            children: [
              // 프로필 사진
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  width: 30,
                  child: CachedNetworkImage(
                      imageUrl:
                          'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/${item.PROFILE_PHOTO}'),
                ),
              ),
              //닉네임, 작성 시간
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.PROFILE_NICKNAME),
                  Text(
                    item.TIME_CREATED
                        .substring(2, 16)
                        .replaceAll(RegExp(r'-'), '/'),
                    textScaleFactor: 0.6,
                  ),
                ],
              ),
              Spacer(),
              // 게시글 좋아요 버튼
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: InkWell(
                  onTap: () {
                    if (item.MYSELF) {
                    } else {
                      c.totalSend(
                          '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                          '좋아요');
                    }
                  },
                  child: item.MYSELF ? Container() : Icon(Icons.thumb_up),
                ),
              ),
              // 게시글 수정, 스크랩 버튼
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if (item.MYSELF) {
                      Get.toNamed(
                          '/board/${item.COMMUNITY_ID}/bid/${item.BOARD_ID}',
                          arguments: item);
                    } else {
                      c.totalSend(
                          '/scrap/${item.COMMUNITY_ID}/id/${item.BOARD_ID}',
                          '스크랩');
                    }
                  },
                  child: item.MYSELF ? Icon(Icons.edit) : Icon(Icons.bookmark),
                ),
              ),
              // 게시글 삭제, 신고 버튼
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () async {
                    // 게시글 삭제
                    if (item.MYSELF) {
                      await c.deleteResource(
                          item.COMMUNITY_ID, item.UNIQUE_ID, "bid");
                    }
                    // 게시글 신고
                    else {
                      var ARREST_TYPE = await c.getArrestType();
                      c.totalSend(
                          '/arrest/${item.COMMUNITY_ID}/id/${item.BOARD_ID}?ARREST_TYPE=$ARREST_TYPE',
                          '신고');
                    }
                  },
                  child: item.MYSELF ? Icon(Icons.delete) : Icon(Icons.report),
                ),
              ),
              //쪽지
              item.MYSELF
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                          onTap: () async {
                            await sendMail(item.UNIQUE_ID, item.COMMUNITY_ID,
                                mailWriteController, mailController);
                          },
                          child: Icon(Icons.mail)),
                    ),
            ],
          ),
        ),
      ),
      // 제목
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: Text(
            "${item.TITLE}",
            textScaleFactor: 2,
          ),
        ),
      ),
      // 내용
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: Text(
            "${item.CONTENT}",
            textScaleFactor: 1.5,
          ),
        ),
      ),
      //사진
      Container(
        child: item.PHOTO != '' && item.PHOTO != null
            ? CachedNetworkImage(
                imageUrl:
                    'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/board/${item.PHOTO}')
            : null,
      ),
      // 좋아요, 댓글, 스크랩 수
      Container(
        decoration:
            BoxDecoration(border: BorderDirectional(bottom: BorderSide())),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            children: [
              // 게시글 좋아요 수 버튼
              TextButton.icon(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () {
                  if (item.MYSELF) {
                  } else {
                    c.totalSend(
                        '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                        '좋아요');
                  }
                },
                icon: Icon(
                  Icons.thumb_up,
                  size: 20,
                ),
                label: Text(item.LIKES.toString()),
              ),
              // 게시글 댓글 수 버튼
              TextButton.icon(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black)),
                onPressed: () {},
                icon: Icon(
                  Icons.comment,
                  size: 20,
                ),
                label: Text(item.COMMENTS.toString()),
              ),
              // 게시글 스크랩 수 버튼
              TextButton.icon(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.yellow[700])),
                onPressed: () {
                  c.totalSend(
                      '/scrap/${item.COMMUNITY_ID}/id/${item.BOARD_ID}', '스크랩');
                },
                icon: Icon(
                  Icons.bookmark,
                  size: 20,
                ),
                label: Text(item.SCRAPS.toString()),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> returningComment(Post item) {
    // String where = "outside";
    String cidUrl = '/board/${item.COMMUNITY_ID}/cid/${item.UNIQUE_ID}';

    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Container(
          // height: 200,
          decoration:
              BoxDecoration(border: BorderDirectional(top: BorderSide())),
          child: Row(
            children: [
              // 프사
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 20,
                  width: 20,
                  child: CachedNetworkImage(
                      imageUrl:
                          'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/${item.PROFILE_PHOTO}'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.PROFILE_NICKNAME),
                  // 댓글 작성 시간
                  Text(
                    item.TIME_CREATED,
                    textScaleFactor: 0.6,
                  ),
                ],
              ),
              // 댓글 좋아요 개수 표시
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.thumb_up,
                        size: 15,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      item.LIKES.toString(),
                      textScaleFactor: 0.8,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // 대댓 작성 버튼
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                    onTap: () {
                      c.changeCcomment(cidUrl);
                      c.makeCcommentUrl(item.COMMUNITY_ID, item.UNIQUE_ID);
                      c.autoFocusTextForm.value = false;
                    },
                    child: Obx(
                      () => Icon(
                        c.isCcomment.value && c.ccommentUrl.value == cidUrl
                            ? Icons.comment
                            : Icons.add,
                        size: 15,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: () async {
                    print("댓글 수정");
                    if (item.MYSELF) {
                      c.putUrl.value = cidUrl;
                      c.autoFocusTextForm.value = true;
                    } else {
                      c.isCcomment.value = !c.isCcomment.value;
                      await c.totalSend(
                          '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                          '좋아요');
                    }
                  },
                  child: item.MYSELF
                      ? Obx(() => Icon(
                            c.autoFocusTextForm.value &&
                                    c.putUrl.value == cidUrl
                                ? Icons.comment
                                : Icons.edit,
                            size: 15,
                          ))
                      : Icon(
                          Icons.thumb_up,
                          size: 15,
                        ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: () async {
                    if (item.MYSELF) {
                      await c.deleteResource(
                          item.COMMUNITY_ID, item.UNIQUE_ID, "cid");
                    } else {
                      var ARREST_TYPE = await c.getArrestType();
                      await c.totalSend(
                          '/arrest/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}?ARREST_TYPE=$ARREST_TYPE',
                          '신고');
                    }
                  },
                  child: item.MYSELF
                      ? Icon(
                          Icons.delete, // 댓글 삭제
                          size: 15,
                        )
                      : Icon(
                          Icons.report, // 댓글 신고
                          size: 15,
                        ),
                ),
              ),
              //댓글 쪽지
              item.MYSELF
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                          onTap: () async {
                            await sendMail(item.UNIQUE_ID, item.COMMUNITY_ID,
                                mailWriteController, mailController);
                          },
                          child: Icon(Icons.mail)),
                    ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
        child: Text(item.CONTENT),
      ),
      Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      ),
    ];
  }

  List<Widget> returningCC(Post item) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 2.0, left: 40),
        child: Container(
          // decoration:
          //     BoxDecoration(border: BorderDirectional(top: BorderSide())),
          child: Row(
            children: [
              // 프사
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 20,
                  width: 20,
                  child: Image.network(
                      'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/${item.PROFILE_PHOTO}'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.PROFILE_NICKNAME),
                  Text(
                    item.TIME_CREATED,
                    textScaleFactor: 0.6,
                  ),
                ],
              ),
              // 좋아요 개수 표시
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.thumb_up,
                        size: 15,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      item.LIKES.toString(),
                      textScaleFactor: 0.8,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              Spacer(),
              // 대댓 수정 or 좋아요
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: () async {
                    print("!!!!");

                    String putUrl =
                        '/board/${item.COMMUNITY_ID}/ccid/${item.UNIQUE_ID}';
                    if (item.MYSELF) {
                      if (c.autoFocusTextForm.value &&
                          c.putUrl.value == putUrl) {
                        c.autoFocusTextForm.value = false;
                        c.putUrl.value = putUrl;
                      } else {
                        c.autoFocusTextForm.value = true;
                        c.putUrl.value = putUrl;
                      }
                    } else {
                      await c.totalSend(
                          '/like/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}',
                          '좋아요');
                    }
                  },
                  child: item.MYSELF
                      ? Obx(() => Icon(
                            c.autoFocusTextForm.value &&
                                    c.putUrl.value ==
                                        '/board/${item.COMMUNITY_ID}/ccid/${item.UNIQUE_ID}'
                                ? Icons.comment
                                : Icons.edit,
                            size: 15,
                          ))
                      : Icon(
                          Icons.thumb_up,
                          size: 15,
                        ),
                ),
              ),
              // 대댓 삭제 or 신고
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                    onTap: () async {
                      if (item.MYSELF) {
                        await c.deleteResource(
                            item.COMMUNITY_ID, item.UNIQUE_ID, "ccid");
                      } else {
                        var ARREST_TYPE = await c.getArrestType();
                        await c.totalSend(
                            '/arrest/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}?ARREST_TYPE=$ARREST_TYPE',
                            '신고');
                      }
                    },
                    child: item.MYSELF
                        ? Icon(
                            Icons.delete,
                            size: 15,
                          )
                        : Icon(
                            Icons.report,
                            size: 15,
                          )),
              ),
              //대댓 쪽지
              item.MYSELF
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () async {
                          await sendMail(item.UNIQUE_ID, item.COMMUNITY_ID,
                              mailWriteController, mailController);
                        },
                        child: Icon(Icons.mail),
                      ),
                    )
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 50.0, bottom: 5.0),
        child: Text(item.CONTENT),
      ),
      Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      ),
    ];
  }
}
