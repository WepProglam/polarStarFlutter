import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
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
              backgroundColor: Color(0xffffffff),
              foregroundColor: Color(0xff333333),
              elevation: 0,
              automaticallyImplyLeading: false,
              leadingWidth: 15 + 13.1 + 9.4,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      communityBoardName(controller.COMMUNITY_ID.value) + "게시판",
                      style: const TextStyle(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.bold,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.left),
                  Text("Sungkyunkwan University",
                      style: const TextStyle(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.normal,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 11.0),
                      textAlign: TextAlign.left),
                ],
              ),
            ),
            body: RefreshIndicator(
              onRefresh: controller.refreshPage,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 63,
                        width: Get.mediaQuery.size.width,
                      ),
                      // 게시글 프리뷰 리스트
                      Expanded(
                        child: Obx(() {
                          print(controller.httpStatus);
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
                  SearchBar(
                      // controller: searchController,
                      ),
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
