import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/global_functions/board_name.dart';
import 'package:polarstar_flutter/app/modules/board/functions/time_parse.dart';

import 'package:polarstar_flutter/app/modules/photo_layout/photo_layout.dart';

// 게시글 프리뷰 위젯
class PostPreview extends StatelessWidget {
  PostPreview({Key key, @required this.item, this.type}) : super(key: key);
  final Rx<Post> item;
  int type;
  final MainController mainController = Get.find();

  String boardName(int COMMUNITY_ID) {
    return communityBoardName(COMMUNITY_ID);
  }

  @override
  Widget build(BuildContext context) {
    type = type == null ? 2 : type;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Ink(
        decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.fromLTRB(27, 19.5, 27, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 이미지 & 닉네임 & 작성 시간
            Container(
              height: 39,
              margin: EdgeInsets.only(bottom: 7.6),
              child: Row(
                children: [
                  // profile image
                  Container(
                      width: 39,
                      height: 39,
                      margin: EdgeInsets.only(right: 11.8),
                      child: CachedNetworkImage(
                        imageUrl: '${item.value.PROFILE_PHOTO}',
                        imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover))),
                      )),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // nickname
                      Text(item.value.PROFILE_NICKNAME,
                          style: const TextStyle(
                              color: const Color(0xff333333),
                              fontWeight: FontWeight.bold,
                              // fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0),
                          textAlign: TextAlign.left),

                      // time
                      Text(
                          timeParsing(
                              item.value.TIME_CREATED, item.value.TIME_UPDATED),
                          style: const TextStyle(
                              color: const Color(0xff999999),
                              fontWeight: FontWeight.normal,
                              // fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 11.0),
                          textAlign: TextAlign.left),
                    ],
                  ),

                  Spacer(),

                  // 좋아요, 즐겨찾기
                  // Ink(
                  //   width: 11,
                  //   height: 11,
                  //   child: InkWell(
                  //     onTap: () {},
                  //     child: Image.asset(
                  //       "assets/images/invalid_name.png",
                  //       fit: BoxFit.fitWidth,
                  //     ),
                  //   ),
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.only(left: 13.7),
                  //   child: Ink(
                  //     width: 11,
                  //     height: 11,
                  //     child: InkWell(
                  //       onTap: () {},
                  //       child: Image.asset(
                  //         "assets/images/scrap_none.png",
                  //         fit: BoxFit.fitWidth,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // 제목, 내용
            Text(item.value.TITLE,
                style: const TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.bold,
                    // fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0),
                textAlign: TextAlign.left),
            Text(item.value.CONTENT,
                maxLines: 2,
                style: const TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.normal,
                    // fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),

            // Photo
            Obx(() {
              print("??");
              return Container(
                  margin: EdgeInsets.only(top: 13.1 - 5.6, bottom: 17.8 - 5.6),
                  child: item.value.PHOTO_URL == null ||
                          item.value.PHOTO_URL.length == 0
                      ? Container(
                          height: 100,
                          color: Colors.red,
                        )
                      : Container(
                          height: 120,
                          child: PhotoLayout(
                            model: item.value,
                          ),
                        ));
            }),

            //좋아요, 댓글, 스크랩 수
            Obx(() {
              return Row(
                children: [
                  Container(
                    height: 16,
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 10.6,
                          height: 10.6,
                          margin: const EdgeInsets.only(right: 6.4),
                          child: (mainController.isLiked(item.value)
                              ? Image.asset(
                                  "assets/images/like_red.png",
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/invalid_name.png",
                                  fit: BoxFit.cover,
                                )),
                        ),
                        Text(item.value.LIKES.toString(),
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.bold,
                                // fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left)
                      ],
                    ),
                  ),
                  Container(
                    height: 16,
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Container(
                            width: 10.6,
                            height: 10.6,
                            margin: const EdgeInsets.only(right: 6.4),
                            child: Icon(
                              Icons.comment_outlined,
                              size: 10.6,
                            )),
                        Text(item.value.COMMENTS.toString(),
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.bold,
                                // fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left)
                      ],
                    ),
                  ),
                  Container(
                    height: 16,
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 10.6,
                          height: 10.6,
                          margin: const EdgeInsets.only(right: 6.4),
                          child: (mainController.isScrapped(item.value)
                              ? Image.asset(
                                  "assets/images/849.png",
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/scrap_none.png",
                                  fit: BoxFit.cover,
                                )),
                        ),
                        Text(item.value.SCRAPS.toString(),
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.bold,
                                // fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left)
                      ],
                    ),
                  )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
