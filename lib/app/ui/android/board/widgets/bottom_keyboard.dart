import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';

class BottomKeyboard extends StatelessWidget {
  const BottomKeyboard({
    Key key,
    @required this.BOTTOM_SHEET_HEIGHT,
    @required this.c,
    @required this.commentWriteController,
  }) : super(key: key);

  final int BOTTOM_SHEET_HEIGHT;
  final PostController c;
  final TextEditingController commentWriteController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Stack(children: [
        Container(
          child: Row(
            children: [
              // 익명 체크
              Container(
                height: BOTTOM_SHEET_HEIGHT.toDouble(),
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Obx(() => Container(
                            height: 20,
                            width: 20,
                            child: Transform.scale(
                              scale: 1,
                              child: Checkbox(
                                value: c.anonymousCheck.value,
                                onChanged: (value) {
                                  c.changeAnonymous(value);
                                },
                              ),
                            ),
                          )),
                      Text(' 익명'),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Obx(
                () => TextFormField(
                  controller: commentWriteController,
                  autofocus: c.autoFocusTextForm.value,
                  decoration: InputDecoration(
                      hintText: c.autoFocusTextForm.value
                          ? '수정하기'
                          : c.isCcomment.value
                              ? '대댓글 작성'
                              : '댓글 작성',
                      border: OutlineInputBorder()),
                ),
              )),
            ],
          ),
        ),
        Positioned(
          top: 15,
          right: 20,
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
                c.putComment(c.putUrl.value, commentData);
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
                c.postComment(postUrl, commentData);
              }

              commentWriteController.clear();
            },
            child: Icon(
              Icons.send,
              size: 30,
            ),
          ),
        ),
      ]),
    );
  }
}
