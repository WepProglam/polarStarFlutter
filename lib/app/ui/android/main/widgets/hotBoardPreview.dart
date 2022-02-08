import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/functions/time_parse.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/photo/photo_layout.dart';
import 'package:swipedetector/swipedetector.dart';

class HotBoardMain extends StatelessWidget {
  HotBoardMain(
      {Key key,
      @required this.size,
      @required this.mainController,
      this.searchText,
      this.searchFocusNode})
      : super(key: key);

  final Size size;
  final MainController mainController;
  final searchText;
  final searchFocusNode;
  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    List<Ink> hotList = [];
    int max = mainController.hotBoard.length > 10
        ? 10
        : mainController.hotBoard.length;
    // for (var index = 0; index < max; index++) {
    //   hotList.add();
    // }
    return ListView.builder(
        itemCount: mainController.hotBoard.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Ink(
            child: InkWell(
              //                  * * type 0 : 메인 -> 핫
              //                  * * type 1 : 마이 -> 게시글
              //                  * * type 2 : 게시판 -> 게시글
              //                  */
              onTap: () async {
                searchText.clear();
                searchFocusNode.unfocus();
                await Get.toNamed(
                    "/board/${mainController.hotBoard[index].value.COMMUNITY_ID}/read/${mainController.hotBoard[index].value.BOARD_ID}",
                    arguments: {"type": 0}).then((value) async {
                  await MainUpdateModule.updateMainPage();
                });
              },
              child: PostWidget(
                c: null,
                mailWriteController: null,
                mailController: null,
                item: mainController.hotBoard[index],
                index: index,
                mainController: mainController,
              ),
            ),
          );
        });

    // return Column(
    //   children: hotList,
    // );

    // Container(
    //   child: ListView.builder(
    //     shrinkWrap: true,
    //     // allowImplicitScrolling: true,
    //     controller: mainController.pageController.value,
    //     scrollDirection: Axis.vertical,
    //     physics: BouncingScrollPhysics(),
    //     // onPageChanged: (int index) =>
    //     //     mainController.hotBoardIndex.value = index,
    //     // pageSnapping: true,
    //     itemCount: mainController.hotBoard.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Container(
    //           margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
    //           child: Obx(() {
    //             return Container(
    //               // width: size.width - 15 * 2,
    //               // height: 301.6,
    //               margin: const EdgeInsets.only(top: 9),
    //               child: Ink(
    //                 child: InkWell(
    //                   /**
    //                  * * type 0 : 메인 -> 핫
    //                  * * type 1 : 마이 -> 게시글
    //                  * * type 2 : 게시판 -> 게시글
    //                  */
    //                   onTap: () {
    //                     Get.toNamed(
    //                         "/board/${mainController.hotBoard[mainController.hotBoardIndex.value].value.COMMUNITY_ID}/read/${mainController.hotBoard[mainController.hotBoardIndex.value].value.BOARD_ID}",
    //                         arguments: {"type": 0});
    //                   },
    //                   child: PostWidget(
    //                     c: null,
    //                     mailWriteController: null,
    //                     mailController: null,
    //                     item: mainController.hotBoard[index],
    //                     index: index,
    //                     mainController: mainController,
    //                   ),
    //                   // HotBoardPreview(
    //                   //   model: mainController.hotBoard[index],
    //                   //   size: size,
    //                   // ),
    //                 ),
    //               ),
    //             );
    //           }),
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.all(Radius.circular(20)),
    //               color: const Color(0xffffffff)));
    //     },
    //   ),
    // );
  }
}

class HotBoardPreview extends StatelessWidget {
  const HotBoardPreview({
    Key key,
    @required this.model,
    @required this.size,
  }) : super(key: key);

  final Rx<Post> model;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 11, right: 11),
            padding: const EdgeInsets.only(bottom: 15.2 / 2),
            height: 78 / 2 + 15.2 / 2,
            child: HotBoardPreviewItem_Top(model: model.value, size: size),
          ),
          Container(
            // height: 195,
            margin: const EdgeInsets.only(left: 11, right: 11),
            child: HotBoardItem_content(model: model.value, size: size),
          ),
          Container(
              height: 0.5,
              margin: const EdgeInsets.only(top: 15.5),
              decoration: BoxDecoration(color: const Color(0xfff0f0f0))),
          Container(
            height: 44,
            child: HotBoardItem_bottomLine(model: model.value),
          )
        ],
      );
    });
  }
}

class HotBoardItem_bottomLine extends StatelessWidget {
  HotBoardItem_bottomLine({Key key, @required this.model}) : super(key: key);

  final Post model;
  final MainController mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 16,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HotBoardPreviewItem_bottom(
                image_url: (mainController.isLiked(model)
                    ? "assets/images/like_red.png"
                    : "assets/images/good.png"),
                amount: "${model.LIKES}"),
            HotBoardPreviewItem_bottom(
                image_url: "assets/images/comment.png",
                amount: "${model.COMMENTS}"),
            HotBoardPreviewItem_bottom(
                image_url: (mainController.isScrapped(model)
                    ? "assets/images/849.png"
                    : "assets/images/star.png"),
                amount: "${model.SCRAPS}"),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: Colors.white,
        ));
  }
}

class HotBoardItem_content extends StatelessWidget {
  const HotBoardItem_content({
    Key key,
    @required this.model,
    @required this.size,
  }) : super(key: key);

  final Post model;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 43 / 2,
          child: Text("${model.TITLE}",
              // "Trains flying across the strait",
              style: const TextStyle(
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.w700,
                  // fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
              textAlign: TextAlign.left),
        ),
        Container(
          margin: const EdgeInsets.only(top: 9.3 / 2),
          width: size.width - 15 * 2 - 11 * 2 - 20,
          child: Text(
              // "Taking the train may be the most common way to return home. You may not know that thereTaking the train may be the most common way to return home. You may not know that thereTaking the train may be the most common way to return home. You may not know that there\n",
              "${model.CONTENT}\n",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.w400,
                  // fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left),
        ),
        Container(
          height: 120,
          margin: const EdgeInsets.only(top: 16 / 2),
          child: model.MEDIA != null && model.MEDIA.length > 0
              ? PhotoLayout(model: model)
              : Container(),
        ),
      ],
    );
  }
}

class HotBoardPreviewItem_bottom extends StatelessWidget {
  const HotBoardPreviewItem_bottom({Key key, this.image_url, this.amount})
      : super(key: key);

  final String image_url;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
      icon: Container(
        width: 16,
        height: 16,
        child: Image.asset("${image_url}"),
      ),
      label: Text("${amount}",
          style: const TextStyle(
              color: const Color(0xff333333),
              fontWeight: FontWeight.w700,
              // fontFamily: "PingFangSC",
              fontStyle: FontStyle.normal,
              fontSize: 12.0),
          textAlign: TextAlign.left),
    );
  }
}

class HotBoardPreviewItem_Top extends StatelessWidget {
  const HotBoardPreviewItem_Top({
    Key key,
    @required this.model,
    @required this.size,
  }) : super(key: key);

  final Post model;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: 39,
          height: 39,
          child: CachedNetworkImage(
              imageUrl: model.PROFILE_PHOTO.trim() == "anonymous.jpg"
                  ? "https://polarstar-image.s3.ap-northeast-2.amazonaws.com/image_profile/${model.PROFILE_PHOTO}"
                  : '${model.PROFILE_PHOTO}',
              imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill))),
              fadeInDuration: Duration(milliseconds: 0),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Image(image: AssetImage('assets/images/spinner.gif')),
              errorWidget: (context, url, error) {
                print(error);
                return Icon(Icons.error);
              })),
      Container(
        margin: const EdgeInsets.only(left: 10.5, right: 10.5, top: 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 21.5,
              width: size.width - 30 - 10.5 * 2 - 15 * 2 - 39 + 8,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 0.3, bottom: 1.3),
                    child: // Userid
                        Text("${model.PROFILE_NICKNAME}",
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w700,
                                // fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 15.0),
                            textAlign: TextAlign.left),
                  ),
                  Spacer(),
                  // ToDo: 쓸데없는 View more 버튼임 제거해야할듯
                  /* Ink(
                    // height: 4.5,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed("/board/hot/page/1");
                      },
                      
                      child: Container(
                        margin: const EdgeInsets.only(
                            // top: 13,
                            // bottom: 4,
                            ),
                        child: // View more
                            Text("View more",
                                style: const TextStyle(
                                    color: const Color(0xff1a4678),
                                    fontWeight: FontWeight.w700,
                                    // fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                                textAlign: TextAlign.center),
                      ),
                    ),
                  ), */
                  // Container(
                  //   height: 4.5,
                  //   width: 23,
                  //   margin: const EdgeInsets.only(
                  //     top: 13,
                  //     bottom: 4,
                  //   ),
                  //   child: Image.asset("assets/images/dots.png"),
                  // )
                ],
              ),
            ),
            Container(
                height: 15,
                child: // 2019.10.23  22:34:24
                    Text("${timeParsing(model.TIME_CREATED, null)}",
                        style: const TextStyle(
                            color: const Color(0xff999999),
                            fontWeight: FontWeight.w400,
                            // fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 11.0),
                        textAlign: TextAlign.left),
                margin: const EdgeInsets.only(top: 0.5)),
          ],
        ),
      )
    ]);
  }
}

class NewBoardMain extends StatelessWidget {
  NewBoardMain(
      {Key key,
      @required this.size,
      @required this.mainController,
      this.searchText,
      this.searchFocusNode})
      : super(key: key);

  final Size size;
  final MainController mainController;
  final searchText;
  final searchFocusNode;
  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    List<Ink> newList = [];
    int max = mainController.hotBoard.length > 10
        ? 10
        : mainController.hotBoard.length;

    return ListView.builder(
        itemCount: mainController.hotBoard.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Ink(
            child: InkWell(
              //                  * * type 0 : 메인 -> 핫
              //                  * * type 1 : 마이 -> 게시글
              //                  * * type 2 : 게시판 -> 게시글
              //                  */
              onTap: () async {
                searchText.clear();
                searchFocusNode.unfocus();
                await Get.toNamed(
                    "/board/${mainController.newBoard[index].value.COMMUNITY_ID}/read/${mainController.newBoard[index].value.BOARD_ID}",
                    arguments: {"type": 0}).then((value) async {
                  await MainUpdateModule.updateMainPage();
                });
              },
              child: PostWidget(
                c: null,
                mailWriteController: null,
                mailController: null,
                item: mainController.newBoard[index],
                index: index,
                mainController: mainController,
              ),
            ),
          );
        });
    // Column(
    //   children: newList,
    // );
  }
}
