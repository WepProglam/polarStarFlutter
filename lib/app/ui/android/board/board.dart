import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/search/widgets/search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';

class Board extends StatelessWidget {
  Board({Key key}) : super(key: key);
  final BoardController controller = Get.find();
  final SearchController searchController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: WritePostAppBar(
              COMMUNITY_ID: int.parse(Get.parameters["COMMUNITY_ID"]),
            ),
            body: RefreshIndicator(
              onRefresh: controller.refreshPage,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 60,
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
                    controller: searchController,
                  ),
                ],
              ),
            )));
  }
}
