import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/search/widgets/search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';

class HotBoard extends StatelessWidget {
  HotBoard({Key key}) : super(key: key);
  final BoardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
              pageName: "HOT",
            ),
            body: RefreshIndicator(
              onRefresh: controller.refreshPage,
              child: Stack(
                children: [
                  Column(
                    children: [
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
                          } else if (controller.httpStatus == 404) {
                            return Text("아직 게시글이 없습니다.");
                          } else {
                            return Text("아직 게시글이 없습니다.");
                          }
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
