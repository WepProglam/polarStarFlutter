import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/search/search_board.dart';
import 'package:polarstar_flutter/app/ui/android/search/widgets/search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';

class Board extends StatelessWidget {
  Board({Key key}) : super(key: key);
  final BoardController controller = Get.find();
  final SearchController searchController = Get.find();
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xffffffff),
            appBar: AppBar(
              toolbarHeight: 56,

              backgroundColor: Get.theme.primaryColor,
              titleSpacing: 0,
              // elevation: 0,
              automaticallyImplyLeading: false,

              title: Stack(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.5),
                      child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "成均馆大学",
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansTC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                              )
                            ],
                            text: communityBoardName(
                                        controller.COMMUNITY_ID.value) ==
                                    null
                                ? ""
                                : '${communityBoardName(controller.COMMUNITY_ID.value)} / ',
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansTC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                          ),
                          textAlign: TextAlign.left),
                    ),
                  ),
                  Positioned(
                    // left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      child: Ink(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Image.asset(
                            'assets/images/back_icon.png',
                            // fit: BoxFit.fitWidth,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      child: Ink(
                        child: InkWell(
                          onTap: () async {
                            await Get.toNamed("/searchBoard")
                                .then((value) async {
                              await MainUpdateModule.updateBoard();
                            });
                          },
                          child: Image.asset(
                            'assets/images/icn_search.png',
                            // fit: BoxFit.fitWidth,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Get.toNamed('/board/${Get.parameters["COMMUNITY_ID"]}')
                    .then((value) async {
                  await MainUpdateModule.updateBoard();
                });
              },
              child: // Ellipse 6
                  Container(
                      width: 56,
                      height: 56,
                      child: Image.asset("assets/images/icn_pen.png"),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: const Color(0xff571df0))),
            ),
            body: RefreshIndicator(
              onRefresh: MainUpdateModule.updateBoard,
              child: Stack(
                children: [
                  Column(
                    children: [
                      // ToDo: 쓸데없는 빈칸 삭제
                      /* Container(
                        height: 0,
                        width: Get.mediaQuery.size.width,
                      ), */
                      // Container(
                      //   height: 30,
                      //   color: const Color(0x1a1a4678),
                      //   child: BoardAnnounce(),
                      // ),

                      Container(
                        margin: const EdgeInsets.only(top: 16),
                      ),
                      // 게시글 프리뷰 리스트
                      Expanded(
                        child: Obx(() {
                          if (controller.dataAvailablePostPreview.value) {
                            return ListView.builder(
                                controller: controller.scrollController.value,
                                itemCount: controller.postBody.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return PostWidget(
                                    c: null,
                                    mailWriteController: null,
                                    mailController: null,
                                    item: controller.postBody[index],
                                    index: index,
                                    mainController: mainController,
                                  );
                                });
                          } else if (controller.httpStatus != 200) {
                            return Text("아직 게시글이 없습니다.");
                          } else {
                            return Text("아직 게시글이 없습니다.");
                          }
                        }),
                      ),
                    ],
                  ),
                  // ToDo: Search Bar 제거
                  /* SearchBar(
                      // controller: searchController,
                      ), */

                  // ! 글쓰기 아이콘 변경
                  // Positioned(
                  //     bottom: 151.5,
                  //     right: 0,
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         Get.toNamed(
                  //             '/board/${Get.parameters["COMMUNITY_ID"]}');
                  //       },
                  //       child: Container(
                  //         width: 72,
                  //         height: 47,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(47),
                  //                 bottomLeft: Radius.circular(47)),
                  //             boxShadow: [
                  //               BoxShadow(
                  //                   color: const Color(0x24111111),
                  //                   offset: Offset(0, 8),
                  //                   blurRadius: 20,
                  //                   spreadRadius: 0)
                  //             ],
                  //             color: const Color(0xffffffff)),
                  //         child: Container(
                  //           width: 39,
                  //           height: 39,
                  //           margin: const EdgeInsets.fromLTRB(6, 4, 27, 4),
                  //           child: Center(
                  //             child: Container(
                  //                 width: 17,
                  //                 height: 17,
                  //                 child: Image.asset(
                  //                     "assets/images/write_pencil.png")),
                  //           ),
                  //           decoration: BoxDecoration(
                  //               color: const Color(0xff1a4678),
                  //               shape: BoxShape.circle),
                  //         ),
                  //       ),
                  //     ))
                ],
              ),
            )));
  }
}

class BoardAnnounce extends StatelessWidget {
  const BoardAnnounce({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 24.4),
            width: 13,
            height: 16,
            child: Image.asset("assets/images/board_bell.png")),
        Container(
          margin: const EdgeInsets.only(left: 10),
          width: Get.size.width - 47.5 * 2,
          child: Text("This is an announcement",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: const Color(0xff1a4678),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left),
        )
      ],
    );
  }
}
