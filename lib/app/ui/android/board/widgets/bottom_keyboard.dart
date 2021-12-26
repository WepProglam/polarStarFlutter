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

    return Container(
      // height: BOTTOM_SHEET_HEIGHT.toDouble(),
      margin: EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(
          color: Color(0xffececec),
          border: Border.all(color: const Color(0xffd9d9d9)),
          borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          TextFormField(
            autofocus: false,
            controller: commentWriteController,
            // autofocus: c.autoFocusTextForm.value,
            // scrollPadding: const EdgeInsets.all(),

            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,

            // expands: true,
            /* onChanged: (String str) {
            int line_num = '\n'.allMatches(str).length + 1;
          
            List<String> splitStr = str.split("\n");
          
            // 줄바뀜 횟수 체크
            for (var item in splitStr) {
              final span = TextSpan(text: item);
          
              bool str_end = false;
              for (int line_end_num = 1; !str_end; line_end_num++) {
                var tp = TextPainter(
                  text: span,
                  textAlign: TextAlign.start,
                  maxLines: line_end_num,
                  textDirection: TextDirection.ltr,
                );
          
                tp.layout(
                    maxWidth:
                        MediaQuery.of(context).size.width - 140 - 45);
          
                print(tp.minIntrinsicWidth);
          
                if (tp.didExceedMaxLines) {
                  line_num++;
          
                  print(line_end_num);
                } else {
                  str_end = true;
                }
              }
            }
          
            if (line_num < 4) {
              c.bottomTextLine(line_num);
            } else {
              c.bottomTextLine(4);
            }
          },
           */

            style: const TextStyle(
                color: const Color(0xff333333),
                fontWeight: FontWeight.w400,
                // fontFamily: "PingFangSC",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),

            textAlign: TextAlign.left,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.only(left: 70, right: 40, top: 10, bottom: 15),
              hintText: c.autoFocusTextForm.value
                  ? '수정하기'
                  : c.isCcomment.value
                      ? '대댓글 작성'
                      : '댓글 작성',
              border: InputBorder.none,
            ),
          ),
          // 익명 체크
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                // height: BOTTOM_SHEET_HEIGHT.toDouble(),
                width: 70,
                child: GestureDetector(
                  onTap: () {
                    c.changeAnonymous(!c.anonymousCheck.value);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            ' 익명',
                            style: const TextStyle(
                              color: const Color(0xff333333),
                              fontWeight: FontWeight.normal,
                              // fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
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
              child: Padding(
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
                      await c.refreshPost();
                    },
                    child: Ink(
                        width: 18,
                        height: 18,
                        child: Image.asset(
                          'assets/images/512.png',
                          fit: BoxFit.fitWidth,
                        ))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
