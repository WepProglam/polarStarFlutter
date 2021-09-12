import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';

class BoardPreviewItem_board extends StatelessWidget {
  const BoardPreviewItem_board({
    Key key,
    @required this.boardInfo,
    @required this.size,
  }) : super(key: key);

  final Rx<BoardInfo> boardInfo;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 타원 108
              Container(
                  width: 45,
                  height: 45,
                  margin: const EdgeInsets.only(right: 19.5),
                  child: Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      child: Image.asset(
                        "assets/images/968.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: const Color(0xffe6effa))),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 1),
                height: 43,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoardPreviewItem_boardTop(boardInfo: boardInfo),
                      BoardPreviewItem_boardContent(size: size)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 18));
  }
}

class BoardPreviewItem_boardContent extends StatelessWidget {
  const BoardPreviewItem_boardContent({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 18.5,
        width: size.width - 55.5 - 99.5,
        child: Text("You know,I have a dream,Within my",
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
            margin: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
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
        child: Text("Board",
            style: const TextStyle(
                color: const Color(0xff333333),
                fontWeight: FontWeight.w900,
                fontFamily: "PingFangSC",
                fontStyle: FontStyle.normal,
                fontSize: 18.0),
            textAlign: TextAlign.center),
      ),
      Spacer(),
      Container(
          height: 16,
          child: // View more
              Ink(
            child: InkWell(
              onTap: () {
                Get.toNamed("board/boardList");
              },
              child: Text("View more",
                  style: const TextStyle(
                      color: const Color(0xff1a4678),
                      fontWeight: FontWeight.w700,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                  textAlign: TextAlign.center),
            ),
          ),
          margin: const EdgeInsets.only(top: 5, bottom: 3)),
    ]);
  }
}
