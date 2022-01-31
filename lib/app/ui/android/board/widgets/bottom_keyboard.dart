import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

class BottomKeyboard extends StatelessWidget {
  const BottomKeyboard({
    Key key,
    @required this.BOTTOM_SHEET_HEIGHT,
    @required this.commentWriteController,
  }) : super(key: key);

  final int BOTTOM_SHEET_HEIGHT;
  final TextEditingController commentWriteController;

  @override
  Widget build(BuildContext context) {
    final PostController c = Get.find();

    return Container(
      decoration: BoxDecoration(color: const Color(0xff4570ff)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        // height: BOTTOM_SHEET_HEIGHT.toDouble() - 10 * 2,
        decoration: BoxDecoration(
            color: const Color(0xffffffff),
            border: Border.all(color: const Color(0xffffffff)),
            borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            // Obx(
            //   () =>
            TextFormField(
              autofocus: false,
              controller: commentWriteController,
              // autofocus: c.autoFocusTextForm.value,
              // scrollPadding: const EdgeInsets.all(),

              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,

              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),

              textAlign: TextAlign.left,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.only(left: 70, right: 40, top: 10, bottom: 10),
                // hintText: c.autoFocusTextForm.value
                //     ? '수정하기'
                //     : c.isCcomment.value
                //         ? '대댓글 작성'
                //         : '댓글 작성',
                border: InputBorder.none,
              ),
            ),
            // ),
            // 익명 체크
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // height: BOTTOM_SHEET_HEIGHT.toDouble(),
                  // width: 70,
                  child: GestureDetector(
                    onTap: () {
                      c.changeAnonymous(!c.anonymousCheck.value);
                    },
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() => Container(
                                width: 16,
                                margin: const EdgeInsets.only(left: 14),
                                child: Transform.scale(
                                  scale: 1,
                                  child: Checkbox(
                                      value: c.anonymousCheck.value,
                                      onChanged: (value) {
                                        c.changeAnonymous(value);
                                      },
                                      checkColor: const Color(0xffffffff),
                                      fillColor: MaterialStateProperty.all(
                                          const Color(0xff4570ff))),
                                ),
                              )),
                          // 匿名
                          Container(
                            // width: 24 + 6.0,
                            margin: const EdgeInsets.only(left: 6, bottom: 1.5),
                            child: Text("匿名",
                                style: const TextStyle(
                                    color: const Color(0xff4570ff),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                                textAlign: TextAlign.center),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.only(right: 11.0),
                  child: InkWell(
                    onTap: () async {
                      print("댓글 작성");
                      Map commentData = {
                        'content': commentWriteController.text,
                        'unnamed': c.anonymousCheck.value ? '1' : '0'
                      };

                      //댓 대댓 수정
                      if (c.autoFocusTextForm.value) {
                        c.autoFocusTextForm.value = false;
                        Get.defaultDialog(
                            title: "댓글 수정",
                            middleText: "${commentData['content']}로 수정하시겠습니까?",
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await c.putComment(
                                        c.putUrl.value, commentData);
                                    Get.back();
                                  },
                                  child: Text("네")),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("아니요"))
                            ]);
                      }

                      //댓 대댓 작성
                      else {
                        String postUrl;
                        if (c.isCcomment.value) {
                          // 대댓인경우
                          postUrl = c.ccommentUrl.value;
                          Get.defaultDialog(
                              title: "대댓글 작성",
                              middleText:
                                  "${commentData['content']}로 작성하시겠습니까?",
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await c.postComment(postUrl, commentData);
                                      Get.back();
                                    },
                                    child: Text("네")),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("아니요"))
                              ]);
                        } else {
                          // 댓글인경우
                          postUrl = c.commentUrl.value;
                          Get.defaultDialog(
                              title: "댓글 작성",
                              middleText:
                                  "${commentData['content']}로 작성하시겠습니까?",
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await c.postComment(postUrl, commentData);
                                      Get.back();
                                    },
                                    child: Text("네")),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("아니요"))
                              ]);
                        }

                        c.isCcomment.value = false;
                      }

                      commentWriteController.clear();
                      await MainUpdateModule.updatePost();
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      child: Image.asset("assets/images/chat_input_send.png"),
                      // child: Image.asset(
                      //   'assets/images/icn_send_white.png',
                      //   // fit: BoxFit.fitWidth,
                      // ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
