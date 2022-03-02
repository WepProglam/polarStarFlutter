import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/modules/board/board_controller.dart';
import 'package:polarstar_flutter/app/modules/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/board/search_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';

import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/global_functions/board_name.dart';
import 'package:polarstar_flutter/app/global_widgets/banner_widget.dart';

class Board extends StatelessWidget {
  Board({Key key}) : super(key: key);
  final BoardController controller = Get.find();
  final SearchController searchController = Get.find();
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffffff),
      child: SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: Color(0xffffffff),
            appBar: AppBar(
              toolbarHeight: 56,

              backgroundColor: Get.theme.primaryColor,
              titleSpacing: 0,
              // elevation: 0,
              automaticallyImplyLeading: false,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Ink(
                  child: Image.asset(
                    'assets/images/back_icon.png',
                    // fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              centerTitle: true,

              title: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "成均馆大学",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      )
                    ],
                    text: communityBoardName(controller.COMMUNITY_ID.value) ==
                            null
                        ? ""
                        : '${communityBoardName(controller.COMMUNITY_ID.value)} / ',
                    style: const TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                  ),
                  textAlign: TextAlign.left),
              actions: [
                InkWell(
                  onTap: () async {
                    await Get.toNamed(Routes.SEARCH).then((value) async {
                      await MainUpdateModule.updateBoard();
                    });
                  },
                  child: Ink(
                    child: Image.asset(
                      'assets/images/icn_search.png',
                      // fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: controller.COMMUNITY_ID == 14
                ? Container()
                : FloatingActionButton(
                    onPressed: () async {
                      await Get.toNamed(
                              '/board/${Get.parameters["COMMUNITY_ID"]}')
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                color: Get.theme.primaryColor)),
                  ),
            body: RefreshIndicator(
              onRefresh: MainUpdateModule.updateBoard,
              child: Column(
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
                  // Rectangle 54
                  Obx(() {
                    bool isExist = true;
                    BoardInfo boardInfo = mainController.boardInfo.firstWhere(
                        (element) =>
                            element.value.COMMUNITY_ID ==
                            controller.COMMUNITY_ID.value, orElse: () {
                      isExist = false;
                      return mainController.boardInfo.first;
                    }).value;
                    return isExist
                        ? Container(
                            height: !boardInfo.IS_CUSTOM ? 0 : 73,
                            child: Row(children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, top: 0),
                                    width: Get.mediaQuery.size.width - 20.0 * 2,
                                    child: Text(
                                        "${boardInfo.COMMUNITY_NAME}에 오신 것을 환영합니다！",
                                        style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, top: 2),
                                    width: Get.mediaQuery.size.width - 20.0 * 2,
                                    child: Text(
                                        "${boardInfo.COMMUNITY_DESCRIPTION}",
                                        style: const TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansSC",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 10.0),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left),
                                  )
                                ],
                              ),
                            ]),
                            decoration:
                                BoxDecoration(color: const Color(0xff2f2f2f)))
                        : Container();
                  }),

                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: BannerWidget(isScrollAble: true),
                  ),
                  Container(
                    height: 10,
                  ),

                  // 게시글 프리뷰 리스트
                  Expanded(
                    child: Obx(() {
                      if (controller.dataAvailablePostPreview.value) {
                        return ListView.builder(
                            padding: const EdgeInsets.only(top: 14),
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: controller.scrollController.value,
                            itemCount: controller.page.value ==
                                    controller.searchMaxPage.value
                                ? controller.postBody.length
                                : controller.postBody.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == controller.postBody.length) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Get.theme.primaryColor,
                                  ),
                                );
                              }
                              return Ink(
                                child: InkWell(
                                  onTap: () async {
                                    await Get.toNamed(
                                        "/board/${controller.postBody[index].value.COMMUNITY_ID}/read/${controller.postBody[index].value.BOARD_ID}",
                                        arguments: {
                                          "type": 2
                                        }).then((value) async {
                                      await MainUpdateModule.updateBoard();
                                    });
                                  },
                                  child: PostWidget(
                                    item: controller.postBody[index],
                                    index: index,
                                    mainController: mainController,
                                  ),
                                ),
                              );
                            });
                      } else if (controller.httpStatus != 200) {
                        return Center(child: Text("目前没有帖子"));
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Get.theme.primaryColor,
                          ),
                        );
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
            )),
      ),
    );
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
