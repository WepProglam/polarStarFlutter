import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';
import 'package:polarstar_flutter/app/ui/android/search/widgets/search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';

class Search extends StatelessWidget {
  Search({Key key}) : super(key: key);
  final SearchController controller = Get.find();
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 56,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: SearchBar()),
      body: RefreshIndicator(
        onRefresh: () => MainUpdateModule.updateBoardSearchPage(),
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.dataAvailablePostPreview.value) {
                    return ListView.builder(
                        controller: controller.scrollController.value,
                        itemCount: controller.postBody.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Ink(
                              child: InkWell(
                                onTap: () async {
                                  await Get.toNamed(
                                      "/board/${controller.postBody[index].value.COMMUNITY_ID}/read/${controller.postBody[index].value.BOARD_ID}",
                                      arguments: {
                                        "type": 0
                                      }).then((value) async {
                                    await MainUpdateModule
                                        .updateBoardSearchPage();
                                  });
                                },
                                child: PostWidget(
                                    item: controller.postBody[index],
                                    index: index,
                                    mainController: mainController),
                              ),
                            ),
                          );
                        });
                  } else if (controller.httpStatus != 200) {
                    return Stack(children: [
                      ListView(),
                      Center(child: Text("검색 결과가 없습니다."))
                    ]);
                  } else {
                    return Stack(children: [
                      ListView(),
                      Center(child: Text("검색 결과가 없습니다."))
                    ]);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
