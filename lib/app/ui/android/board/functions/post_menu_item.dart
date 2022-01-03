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
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/photo/photo_layout.dart';
import 'package:polarstar_flutter/main.dart';

Future<void> updatePostFunc(Rx<Post> item) async {
  await Get.defaultDialog(title: "게시글 수정", middleText: "수정하시겠습니까?", actions: [
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
}

Future<void> deletePostFunc(Rx<Post> item, PostController c) async {
  await c.deleteResource(item.value.COMMUNITY_ID, item.value.UNIQUE_ID, "bid");
}

Future<void> arrestPostFunc(PostController c, Rx<Post> item, int index) async {
  await c.totalSend(
      '/arrest/${item.value.COMMUNITY_ID}/id/${item.value.BOARD_ID}?ARREST_TYPE=',
      '신고',
      index);
}

Future<void> sendMailPostFunc(
    PostController c,
    Rx<Post> item,
    TextEditingController mailWriteController,
    MailController mailController) async {
  await sendMail(item.value.UNIQUE_ID, item.value.COMMUNITY_ID,
      mailWriteController, mailController);
}

// * 댓글 수정
void updateCommentFunc(PostController c, String cidUrl) {
  if (c.autoFocusTextForm.value) {
    c.autoFocusTextForm(false);
  } else {
    c.putUrl.value = cidUrl;
    c.autoFocusTextForm(true);
  }
}

// * 댓글 삭제
Future<void> deleteCommentFunc(Post item, PostController c) async {
  await c.deleteResource(item.COMMUNITY_ID, item.UNIQUE_ID, "cid");
}

// * 댓글 신고
Future<void> arrestCommentFunc(PostController c, Post item, int index) async {
  var ARREST_TYPE = await c.getArrestType();
  print(ARREST_TYPE);
  if (ARREST_TYPE != null) {
    await c.totalSend(
        '/arrest/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}?ARREST_TYPE=$ARREST_TYPE',
        '신고',
        index);
  }
}

// * 댓글 쪽지 보내기
Future<void> sendMailCommentFunc(
    Post item,
    TextEditingController mailWriteController,
    MailController mailController) async {
  await sendMail(
      item.UNIQUE_ID, item.COMMUNITY_ID, mailWriteController, mailController);
}

// * 대댓 작성
void writeCCFunc(Post item, PostController c, String cidUrl) async {
  c.changeCcomment(cidUrl);
  c.makeCcommentUrl(item.COMMUNITY_ID, item.UNIQUE_ID);
  c.autoFocusTextForm(false);
}

// * 대댓글 수정
void updateCCFunc(PostController c, Post item) {
  String putUrl = '/board/${item.COMMUNITY_ID}/ccid/${item.UNIQUE_ID}';
  if (c.autoFocusTextForm.value && c.putUrl.value == putUrl) {
    c.autoFocusTextForm.value = false;
    c.putUrl.value = putUrl;
  } else {
    c.autoFocusTextForm.value = true;
    c.putUrl.value = putUrl;
  }
}

// * 대댓글 삭제
Future<void> deleteCCFunc(Post item, PostController c) async {
  await c.deleteResource(item.COMMUNITY_ID, item.UNIQUE_ID, "ccid");
}

// * 대댓글 신고
Future<void> arrestCCFunc(PostController c, Post item, int index) async {
  var ARREST_TYPE = await c.getArrestType();
  await c.totalSend(
      '/arrest/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}?ARREST_TYPE=$ARREST_TYPE',
      '신고',
      index);
}

// * 대댓글 쪽지 보내기
Future<void> sendMailCCFunc(
    Post item,
    TextEditingController mailWriteController,
    MailController mailController) async {
  await sendMail(
      item.UNIQUE_ID, item.COMMUNITY_ID, mailWriteController, mailController);
}
