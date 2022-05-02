import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/post/post_controller.dart';
import 'package:polarstar_flutter/app/modules/mailHistory/mail_controller.dart';

import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/modules/hot_board/widgets/board_mail_dialog.dart';
import 'package:polarstar_flutter/app/global_widgets/dialoge.dart';

Future<void> updatePostFunc(Rx<Post> item) async {
  Function ontapConfirm = () async {
    Get.offAndToNamed(
        '/board/${item.value.COMMUNITY_ID}/bid/${item.value.BOARD_ID}',
        arguments: item);
  };
  Function ontapCancel = () {
    Get.back();
  };
  await TFdialogue("修改帖子", "确定要修改帖子吗？", ontapConfirm, ontapCancel);
}

Future<void> deletePostFunc(Rx<Post> item, PostController c) async {
  await c.deleteResource(item.value.COMMUNITY_ID, item.value.UNIQUE_ID, "bid");
}

Future<void> arrestPostFunc(PostController c, Rx<Post> item, int index) async {
  var ARREST_TYPE = await getArrestType();
  if (ARREST_TYPE == null) {
    return;
  }
  int statusCode = await c.totalSend(
      '/arrest/${item.value.COMMUNITY_ID}/id/${item.value.BOARD_ID}?ARREST_TYPE=$ARREST_TYPE',
      '신고',
      index);
  print("신고 완료");
  arrestReaction(statusCode);
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
  c.focusNode.requestFocus();
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
  var ARREST_TYPE = await getArrestType();
  if (ARREST_TYPE == null) {
    return;
  }

  if (ARREST_TYPE != null) {
    int statusCode = await c.totalSend(
        '/arrest/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}?ARREST_TYPE=$ARREST_TYPE',
        '신고',
        index);
    arrestReaction(statusCode);
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
  c.focusNode.requestFocus();
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
  var ARREST_TYPE = await getArrestType();
  if (ARREST_TYPE == null) {
    return;
  }
  int statusCode = await c.totalSend(
      '/arrest/${item.COMMUNITY_ID}/id/${item.UNIQUE_ID}?ARREST_TYPE=$ARREST_TYPE',
      '신고',
      index);
  arrestReaction(statusCode);
}

void arrestReaction(int statusCode) {
  switch (statusCode) {
    case 200:
      Textdialogue(Get.context, "차단/신고 처리 완료",
          "일정 횟수 이상 누적될 경우,\n해당 유저는 앱 이용에 제한이 가해집니다.");
      break;
    default:
      Textdialogue(Get.context, "신고 처리 실패", "해당 유저를 신고할 수 없습니다.");

      break;
  }
}

// * 대댓글 쪽지 보내기
Future<void> sendMailCCFunc(
    Post item,
    TextEditingController mailWriteController,
    MailController mailController) async {
  await sendMail(
      item.UNIQUE_ID, item.COMMUNITY_ID, mailWriteController, mailController);
}
