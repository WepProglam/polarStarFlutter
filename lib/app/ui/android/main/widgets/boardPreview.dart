import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/check_follow.dart';
import 'package:polarstar_flutter/app/ui/android/main/main_page_scroll.dart';

class BoardPreviewItem_board extends StatelessWidget {
  BoardPreviewItem_board(
      {Key key,
      @required this.boardInfo,
      @required this.size,
      @required this.fromList})
      : super(key: key);

  final Rx<BoardInfo> boardInfo;
  final Size size;
  final bool fromList;
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Ink(
      child: Obx(() {
        return InkWell(
          onTap: () {
            Get.toNamed("/board/${boardInfo.value.COMMUNITY_ID}/page/1");
          },
          child: Container(
              child: Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 타원 108
                    Container(
                        margin: const EdgeInsets.only(right: 19.5),
                        child: Ink(
                          width: 45,
                          height: 45,
                          child: InkWell(
                            onTap: fromList
                                ? () async {
                                    if (!checkFollow(
                                        boardInfo.value.COMMUNITY_ID,
                                        mainController.boardInfo)) {
                                      await mainController
                                          .setFollowingCommunity(
                                              boardInfo.value.COMMUNITY_ID,
                                              boardInfo.value.COMMUNITY_NAME,
                                              boardInfo.value.RECENT_TITLE,
                                              boardInfo.value.RECENT_TIME
                                                  .toString(),
                                              boardInfo.value.isFollowed,
                                              boardInfo.value.isNew);
                                    } else {
                                      await mainController
                                          .deleteFollowingCommunity(
                                              boardInfo.value.COMMUNITY_ID);
                                    }
                                    boardInfo.update((val) {
                                      val.isFollowed = !val.isFollowed;
                                    });
                                  }
                                : () {},
                            child: Center(
                              child: Container(
                                width: 24,
                                height: 24,
                                child: Image.asset(
                                  boardInfo.value.isFollowed
                                      ? "assets/images/968.png"
                                      : "assets/images/970.png",
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: boardInfo.value.isFollowed
                                ? const Color(0xffe6effa)
                                : const Color(0xfffae6f0))),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      height: 43,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BoardPreviewItem_boardTop(boardInfo: boardInfo),
                            BoardPreviewItem_boardContent(
                                size: size, boardInfo: boardInfo)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 18)),
        );
      }),
    );
  }
}

class BoardPreviewItem_boardContent extends StatelessWidget {
  const BoardPreviewItem_boardContent(
      {Key key, @required this.size, @required this.boardInfo})
      : super(key: key);

  final Size size;
  final Rx<BoardInfo> boardInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 18.5,
        width: size.width - 55.5 - 99.5,
        child: Text("${boardInfo.value.RECENT_TITLE}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: const Color(0xff999999),
                fontWeight: FontWeight.w400,
                fontFamily: "PingFangSC",
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
            textAlign: TextAlign.left));
  }
}

class BoardPreviewItem_boardTop extends StatelessWidget {
  const BoardPreviewItem_boardTop({
    Key key,
    @required this.boardInfo,
  }) : super(key: key);

  final Rx<BoardInfo> boardInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18.5 + 6,
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text("${boardInfo.value.COMMUNITY_NAME}",
                style: const TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w900,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.center),
          ),
          Container(
            height: 15,
            width: 30.5,
            margin: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
            child: Image.asset("assets/images/627.png"),
          )
        ],
      ),
    );
  }
}

class BoardPreviewItem_top extends StatelessWidget {
  const BoardPreviewItem_top({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        height: 24,
        child: // 公告事項
            Text("论坛分区",
                style: const TextStyle(
                    color: const Color(0xff2f2f2f),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0),
                textAlign: TextAlign.left),
      ),
      Spacer(),
      InkWell(
        onTap: () {
          Get.toNamed("board/boardList");
        },
        child: SeeMore(),
      ),
    ]);
  }
}
