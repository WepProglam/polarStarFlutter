import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:swipedetector/swipedetector.dart';

class HotBoardMain extends StatelessWidget {
  const HotBoardMain({
    Key key,
    @required this.size,
    @required this.mainController,
  }) : super(key: key);

  final Size size;
  final MainController mainController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 24,
          child: Row(children: [
            Container(
              child: Text("HotBoard",
                  style: const TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0),
                  textAlign: TextAlign.center),
            ),
            Spacer(),
            Ink(
              child: InkWell(
                onTap: () {
                  Get.toNamed("/board/hot/page/1");
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 3),
                  child: // View more
                      Text("View more",
                          style: const TextStyle(
                              color: const Color(0xff1a4678),
                              fontWeight: FontWeight.w700,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.center),
                ),
              ),
            ),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(top: 14),
          height: 317 + 15.5 - 4.1 + 4.6,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 62.5),
                child: Opacity(
                  opacity: 0.15000000149011612,
                  child: Container(
                      height: 50.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: const Color(0xff1a4678))),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 10.5, left: 30.3, right: 30.3),
                child: Opacity(
                  opacity: 0.15000000149011612,
                  child: Container(
                      height: 50.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: const Color(0xff1a4678))),
                ),
              ),

              // 핫게
              Container(
                  margin: const EdgeInsets.only(top: 22),
                  child: Obx(() {
                    return SwipeDetector(
                      onSwipeLeft: () async {
                        await mainController.swipeLeftHotBoard();
                      },
                      onSwipeRight: () async {
                        await mainController.swipeRightHotBoard();
                      },
                      child: Container(
                        width: size.width - 15 * 2,
                        height: 301.6,
                        margin: const EdgeInsets.only(top: 9),
                        child: Ink(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(
                                  "/board/${mainController.hotBoard[mainController.hotBoardIndex.value].COMMUNITY_ID}/read/${mainController.hotBoard[mainController.hotBoardIndex.value].BOARD_ID}");
                            },
                            child: HotBoardPreview(
                                model: mainController.hotBoard[
                                    mainController.hotBoardIndex.value],
                                size: size),
                          ),
                        ),
                      ),
                      swipeConfiguration: SwipeConfiguration(
                          verticalSwipeMinVelocity: 100.0,
                          verticalSwipeMinDisplacement: 50.0,
                          verticalSwipeMaxWidthThreshold: 100.0,
                          horizontalSwipeMaxHeightThreshold: 50.0,
                          horizontalSwipeMinDisplacement: 50.0,
                          horizontalSwipeMinVelocity: 200.0),
                    );
                  }),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: const Color(0xffffffff)))
            ],
          ),
        )
      ],
    );
  }
}

class HotBoardPreview extends StatelessWidget {
  const HotBoardPreview({
    Key key,
    @required this.model,
    @required this.size,
  }) : super(key: key);

  final HotBoard model;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 11, right: 11),
          padding: const EdgeInsets.only(bottom: 15.2 / 2),
          height: 78 / 2 + 15.2 / 2,
          child: HotBoardPreviewItem_Top(model: model, size: size),
        ),
        Container(
          height: 195,
          margin: const EdgeInsets.only(left: 11, right: 11),
          child: HotBoardItem_content(model: model, size: size),
        ),
        Container(
            height: 0.5,
            margin: const EdgeInsets.only(top: 15.5),
            decoration: BoxDecoration(color: const Color(0xfff0f0f0))),
        Container(
          height: 44,
          child: HotBoardItem_bottomLine(model: model),
        )
      ],
    );
  }
}

class HotBoardItem_bottomLine extends StatelessWidget {
  const HotBoardItem_bottomLine({Key key, @required this.model})
      : super(key: key);

  final HotBoard model;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 16,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HotBoardPreviewItem_bottom(
                image_url: "assets/images/good.png", amount: "${model.LIKES}"),
            HotBoardPreviewItem_bottom(
                image_url: "assets/images/comment.png",
                amount: "${model.COMMENTS}"),
            HotBoardPreviewItem_bottom(
                image_url: "assets/images/star.png", amount: "${model.SCRAPS}"),
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

  final HotBoard model;
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
                  fontFamily: "PingFangSC",
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
                  fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left),
        ),
        Container(
          height: 118.5,
          margin: const EdgeInsets.only(top: 16 / 2),
          child: model.PHOTO != null && model.PHOTO.length > 0
              ? CachedNetworkImage(
                  imageUrl:
                      'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com/uploads/${model.PROFILE_PHOTO}',
                  imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          // shape: BoxShape
                          //     .circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.fill))),
                  fadeInDuration: Duration(milliseconds: 0),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Image(image: AssetImage('assets/images/spinner.gif')),
                  errorWidget: (context, url, error) {
                    print(error);
                    return Icon(Icons.error);
                  })
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
    return Container(
      height: 16,
      width: 53,
      child: Row(
        children: [
          Container(
            height: 10.6,
            width: 10.6,
            margin: const EdgeInsets.only(bottom: 1.9, top: 3.5),
            child: Image.asset("${image_url}"),
          ),
          Container(
            height: 16,
            padding: const EdgeInsets.only(left: 12.9 / 2),
            child: // 8678
                Text("${amount}",
                    style: const TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.w700,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left),
          )
        ],
      ),
    );
  }
}

class HotBoardPreviewItem_Top extends StatelessWidget {
  const HotBoardPreviewItem_Top({
    Key key,
    @required this.model,
    @required this.size,
  }) : super(key: key);

  final HotBoard model;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: 39,
          height: 39,
          child: CachedNetworkImage(
              imageUrl:
                  'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com/uploads/${model.PROFILE_PHOTO}',
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
              width: size.width - 30 - 10.5 * 2 - 15 * 2 - 39,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 0.3, bottom: 1.3),
                    child: // Userid
                        Text("${model.PROFILE_NICKNAME}",
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w700,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 15.0),
                            textAlign: TextAlign.left),
                  ),
                  Spacer(),
                  Container(
                    height: 4.5,
                    width: 23,
                    margin: const EdgeInsets.only(
                      top: 13,
                      bottom: 4,
                    ),
                    child: Image.asset("assets/images/dots.png"),
                  )
                ],
              ),
            ),
            Container(
                height: 15,
                child: // 2019.10.23  22:34:24
                    Text("${model.TIME_CREATED}",
                        style: const TextStyle(
                            color: const Color(0xff999999),
                            fontWeight: FontWeight.w400,
                            fontFamily: "PingFangSC",
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
