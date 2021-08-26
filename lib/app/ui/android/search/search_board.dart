import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';
import 'package:polarstar_flutter/app/ui/android/search/widgets/search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';

class Search extends StatelessWidget {
  Search({Key key}) : super(key: key);
  final SearchController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        pageName: "${communityBoardName(controller.COMMUNITY_ID.value)}",
      ),
      body: Stack(
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
                    return Text("검색 결과가 없습니다.");
                  } else {
                    return Text("검색 결과가 없습니다.");
                  }
                }),
              ),
            ],
          ),
          SearchBar(
            controller: controller,
          ),
        ],
      ),
    ));
  }
}
