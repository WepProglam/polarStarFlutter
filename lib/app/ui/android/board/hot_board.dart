import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/board.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';
import 'package:polarstar_flutter/app/ui/android/search/widgets/search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';

class HotBoard extends StatelessWidget {
  HotBoard({Key key}) : super(key: key);
  final BoardController controller = Get.find();
  final MainController mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xffffffff),
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
                      child: Obx(() {
                        return RichText(
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
                              text: communityBoardName(
                                          controller.COMMUNITY_ID.value) ==
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
                            textAlign: TextAlign.left);
                      }),
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
                  // Positioned(
                  //   right: 0,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 16, horizontal: 20),
                  //     child: Ink(
                  //       child: InkWell(
                  //         onTap: () async {
                  //           await Get.toNamed("/searchBoard")
                  //               .then((value) async {
                  //             await MainUpdateModule.updateBoard();
                  //           });
                  //         },
                  //         child: Image.asset(
                  //           'assets/images/icn_search.png',
                  //           // fit: BoxFit.fitWidth,
                  //           width: 24,
                  //           height: 24,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            body: Obx(() {
              if (controller.dataAvailablePostPreview.value) {
                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        pinned: true,
                        floating: true,
                        snap: false,
                        expandedHeight: 48.1,
                        elevation: 0,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(48.1),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(left: 20 - 6.0),
                              child: TabBar(
                                indicator: UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                      color: Get.theme.primaryColor,
                                      width: 2.0),
                                  insets:
                                      EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 12.0),
                                ),
                                controller: controller.tabController,
                                indicatorColor: Get.theme.primaryColor,
                                isScrollable: true,
                                indicatorPadding: EdgeInsets.zero,
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                labelColor: const Color(0xff000000),
                                unselectedLabelColor: const Color(0xffd6d4d4),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Roboto",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                tabs: <Tab>[
                                  Tab(
                                    text: "HOT",
                                  ),
                                  Tab(
                                    text: "NEW",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ];
                  },
                  body: Container(
                    margin: const EdgeInsets.only(top: 0),
                    child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          Container(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await MainUpdateModule.updateHotMain(
                                    controller.tabController.index);
                              },
                              child: ListView.builder(
                                  controller:
                                      controller.hotScrollController.value,
                                  itemCount:
                                      controller.hotSearchMaxPage.value ==
                                              controller.hotPage.value
                                          ? controller.HotBody.length
                                          : controller.HotBody.length + 1,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  cacheExtent: 100,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == controller.HotBody.length) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Get.theme.primaryColor,
                                        ),
                                      );
                                    }
                                    Rx<Post> model = controller.HotBody[index];

                                    return Ink(
                                      child: InkWell(
                                        onTap: () async {
                                          await Get.toNamed(
                                              "/board/${model.value.COMMUNITY_ID}/read/${model.value.BOARD_ID}",
                                              arguments: {
                                                "type": 0
                                              }).then((value) async {
                                            await MainUpdateModule
                                                .updateHotMain(controller
                                                    .tabController.index);
                                          });
                                        },
                                        child: PostWidget(
                                          item: model,
                                          index: index,
                                          mainController: mainController,
                                        ),
                                      ),
                                    );

                                    // PostPreview(
                                    //   item: model,
                                    // );
                                  }),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 0),
                            child: ListView.builder(
                                controller:
                                    controller.newScrollController.value,
                                itemCount: controller.newSearchMaxPage.value ==
                                        controller.newPage.value
                                    ? controller.NewBody.length
                                    : controller.NewBody.length + 1,
                                physics: AlwaysScrollableScrollPhysics(),
                                cacheExtent: 100,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == controller.NewBody.length) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Get.theme.primaryColor,
                                      ),
                                    );
                                  }
                                  Rx<Post> model = controller.NewBody[index];
                                  return Ink(
                                    child: InkWell(
                                      onTap: () async {
                                        await Get.toNamed(
                                            "/board/${model.value.COMMUNITY_ID}/read/${model.value.BOARD_ID}",
                                            arguments: {
                                              "type": 0
                                            }).then((value) async {
                                          await MainUpdateModule.updateHotMain(
                                              controller.tabController.index);
                                        });
                                      },
                                      child: PostWidget(
                                        item: model,
                                        index: index,
                                        mainController: mainController,
                                      ),
                                    ),
                                  );

                                  // PostPreview(
                                  //   item: model,
                                  // );
                                }),
                          ),
                        ]),
                  ),
                );
              } else if (controller.httpStatus == 404) {
                return Container(
                  color: Colors.white,
                );
              } else {
                return Container(
                  color: Colors.white,
                );
              }
            })));
  }
}
