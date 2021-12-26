import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/search/search_board.dart';
import 'package:polarstar_flutter/app/ui/android/search/widgets/search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';

class Board extends StatelessWidget {
  Board({Key key}) : super(key: key);
  final BoardController controller = Get.find();
  final SearchController searchController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xfff6f6f6),
            appBar: AppBar(
              toolbarHeight: 55 + 10.0,
              backgroundColor: const Color(0xfff6f6f6),
              // backgroundColor: const Color(0xffffffff),
              foregroundColor: Color(0xff333333),
              elevation: 0,
              automaticallyImplyLeading: false,
              leadingWidth: 15 + 13.1 + 9.4,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(left: 15, right: 13.1),
                  child: Ink(
                    child: Image.asset(
                      'assets/images/848.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              titleSpacing: 0,
              title: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              communityBoardName(controller.COMMUNITY_ID.value),
                              style: const TextStyle(
                                  color: const Color(0xff333333),
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                              textAlign: TextAlign.left),
                          Text("Sungkyunkwan University",
                              style: const TextStyle(
                                  color: const Color(0xff999999),
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 11.0),
                              textAlign: TextAlign.left),
                        ],
                      ),
                    ),

                    // Search Button
                    /*
                     * 게시판 명이 사라지면서 검색창이 나오는걸 원하는거임?
                     * 지금처럼 페이지가 따로 있으면 그냥 이렇게 페이지 여는게 더 낫지않나?
                     */
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed("/searchBoard");
                        },
                        child: Image.asset(
                          'assets/images/671.png',
                          width: 14.3,
                          height: 14.3,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: controller.refreshPage,
              child: Stack(
                children: [
                  Column(
                    children: [
                      // ToDo: 쓸데없는 빈칸 삭제
                      /* Container(
                        height: 0,
                        width: Get.mediaQuery.size.width,
                      ), */
                      Container(
                        height: 30,
                        color: const Color(0x1a1a4678),
                        child: BoardAnnounce(),
                      ),

                      // 게시글 프리뷰 리스트
                      Expanded(
                        child: Obx(() {
                          if (controller.dataAvailablePostPreview.value) {
                            return ListView.builder(
                                controller: controller.scrollController.value,
                                itemCount: controller.postBody.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return PostPreview(
                                    item: controller.postBody[index],
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
                  Positioned(
                      bottom: 151.5,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                              '/board/${Get.parameters["COMMUNITY_ID"]}');
                        },
                        child: Container(
                          width: 72,
                          height: 47,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(47),
                                  bottomLeft: Radius.circular(47)),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0x24111111),
                                    offset: Offset(0, 8),
                                    blurRadius: 20,
                                    spreadRadius: 0)
                              ],
                              color: const Color(0xffffffff)),
                          child: Container(
                            width: 39,
                            height: 39,
                            margin: const EdgeInsets.fromLTRB(6, 4, 27, 4),
                            child: Center(
                              child: Container(
                                  width: 17,
                                  height: 17,
                                  child: Image.asset(
                                      "assets/images/write_pencil.png")),
                            ),
                            decoration: BoxDecoration(
                                color: const Color(0xff1a4678),
                                shape: BoxShape.circle),
                          ),
                        ),
                      ))
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
