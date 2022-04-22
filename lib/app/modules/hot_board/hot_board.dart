import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/board/board_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/board/search_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/modules/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/global_functions/board_name.dart';

class HotBoard extends StatelessWidget {
  HotBoard({Key key}) : super(key: key);
  final BoardController controller = Get.find();
  final MainController mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffffff),
      child: SafeArea(
        top: true,
        child: Scaffold(
            backgroundColor: const Color(0xffffffff),
            // appBar: AppBar(
            //   toolbarHeight: 56,

            //   backgroundColor: Get.theme.primaryColor,
            //   titleSpacing: 0,
            //   // elevation: 0,
            //   automaticallyImplyLeading: false,
            //   // leading: InkWell(
            //   //   onTap: () {
            //   //     Get.back();
            //   //   },
            //   //   child: Ink(
            //   //     child: Image.asset(
            //   //       'assets/images/back_icon.png',
            //   //       // fit: BoxFit.fitWidth,
            //   //     ),
            //   //   ),
            //   // ),
            //   centerTitle: true,

            //   title: Container(
            //     margin: const EdgeInsets.symmetric(vertical: 16.5),
            //     child: Obx(() {
            //       return RichText(
            //           text: TextSpan(
            //             children: <TextSpan>[
            //               TextSpan(
            //                 text: "成均馆大学",
            //                 style: const TextStyle(
            //                     color: const Color(0xffffffff),
            //                     fontWeight: FontWeight.w500,
            //                     fontFamily: "NotoSansSC",
            //                     fontStyle: FontStyle.normal,
            //                     fontSize: 14.0),
            //               )
            //             ],
            //             text: communityBoardName(
            //                         controller.COMMUNITY_ID.value) ==
            //                     null
            //                 ? ""
            //                 : '${communityBoardName(controller.COMMUNITY_ID.value)} / ',
            //             style: const TextStyle(
            //                 color: const Color(0xffffffff),
            //                 fontWeight: FontWeight.w500,
            //                 fontFamily: "NotoSansSC",
            //                 fontStyle: FontStyle.normal,
            //                 fontSize: 16.0),
            //           ),
            //           textAlign: TextAlign.left);
            //     }),
            //   ),
            // ),
            body: Obx(() {
              if (controller.dataAvailablePostPreview.value) {
                return Column(children: [
                  Container(
                    height: 20,
                    margin: const EdgeInsets.only(top: 14, bottom: 5),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          padding: const EdgeInsets.all(0.0),
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                                color: const Color(0xff4c74f6), width: 2.0),
                            insets:
                                EdgeInsets.fromLTRB(100.0, 0.0, 100.0, -2.0),
                          ),
                          controller: controller.tabController,
                          indicatorColor: Get.theme.primaryColor,
                          isScrollable: false,
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
                              text: "New",
                            ),
                            Tab(
                              text: "Hot",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: TabBarView(
                          controller: controller.tabController,
                          physics: AlwaysScrollableScrollPhysics(),
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 0),
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  await MainUpdateModule.updateHotMain(
                                      controller.tabController.index);
                                },
                                child: ListView.builder(
                                    controller:
                                        controller.newScrollController.value,
                                    itemCount:
                                        controller.newSearchMaxPage.value ==
                                                controller.newPage.value
                                            ? controller.NewBody.length + 1
                                            : controller.NewBody.length + 2,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    cacheExtent: 100,
                                    itemBuilder:
                                        (BuildContext context, int ii) {
                                      int index = ii - 1;
                                      if (ii == 0) {
                                        return Container(
                                          height: 24 - 5.0,
                                        );
                                      }
                                      if (index == controller.NewBody.length) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Get.theme.primaryColor,
                                          ),
                                        );
                                      }
                                      Rx<Post> model =
                                          controller.NewBody[index];
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
                                            ? controller.HotBody.length + 1
                                            : controller.HotBody.length + 2,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    cacheExtent: 100,
                                    itemBuilder:
                                        (BuildContext context, int ii) {
                                      int index = ii - 1;
                                      if (ii == 0) {
                                        return Container(
                                          height: 24 - 5.0,
                                        );
                                      }
                                      if (index == controller.HotBody.length) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Get.theme.primaryColor,
                                          ),
                                        );
                                      }
                                      Rx<Post> model =
                                          controller.HotBody[index];

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
                          ]),
                    ),
                  ),
                ]);
              } else if (controller.httpStatus == 404) {
                return Container(
                  color: Colors.white,
                );
              } else {
                return Container(
                  color: Colors.white,
                );
              }
            })),
      ),
    );
  }
}
