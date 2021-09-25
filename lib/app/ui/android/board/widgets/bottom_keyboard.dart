import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';

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

    return Obx(() => Container(
          height: BOTTOM_SHEET_HEIGHT.toDouble() +
              (c.bottomTextLine.value - 1) * 21,
          padding: const EdgeInsets.fromLTRB(15, 5.5, 15, 5.5),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xffececec),
                border: Border.all(color: const Color(0xffd9d9d9)),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                // 익명 체크
                Container(
                  height: BOTTOM_SHEET_HEIGHT.toDouble(),
                  child: GestureDetector(
                    onTap: () {
                      c.changeAnonymous(!c.anonymousCheck.value);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Obx(() => Container(
                                width: 20,
                                child: Transform.scale(
                                  scale: 1,
                                  child: Checkbox(
                                      value: c.anonymousCheck.value,
                                      onChanged: (value) {
                                        c.changeAnonymous(value);
                                      },
                                      checkColor: Color(0xffececec),
                                      fillColor: MaterialStateProperty.all(
                                          Color(0xff333333))),
                                ),
                              )),
                          Text(' 익명'),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Obx(
                  () => TextFormField(
                    controller: commentWriteController,
                    autofocus: c.autoFocusTextForm.value,
                    minLines: 1,
                    maxLines: 10,
                    onChanged: (String str) {
                      int line_num = '\n'.allMatches(str).length + 1;
                      if (line_num < 4) {
                        c.bottomTextLine(line_num);
                      } else {
                        c.bottomTextLine(4);
                      }
                    },
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 5),
                      hintText: c.autoFocusTextForm.value
                          ? '수정하기'
                          : c.isCcomment.value
                              ? '대댓글 작성'
                              : '댓글 작성',
                      border: InputBorder.none,
                    ),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
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
                          await c.putComment(c.putUrl.value, commentData);
                        }

                        //댓 대댓 작성
                        else {
                          String postUrl;
                          if (c.isCcomment.value) {
                            // 대댓인경우
                            postUrl = c.ccommentUrl.value;
                          } else {
                            // 댓글인경우
                            postUrl = c.commentUrl.value;
                          }
                          c.isCcomment.value = false;
                          await c.postComment(postUrl, commentData);
                        }

                        commentWriteController.clear();
                        await c.refreshPost();
                      },
                      child: Ink(
                          width: 18,
                          height: 18,
                          child: Image.asset(
                            'assets/images/512.png',
                            fit: BoxFit.fitHeight,
                          ))),
                ),
              ],
            ),
          ),
        ));
  }
}
