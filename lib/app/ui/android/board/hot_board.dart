import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
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
                return RefreshIndicator(
                  onRefresh: () async {
                    await MainUpdateModule.updateHotMain();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: ListView.builder(
                        controller: controller.scrollController.value,
                        itemCount: controller.postBody.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        cacheExtent: 100,
                        itemBuilder: (BuildContext context, int index) {
                          return Ink(
                            child: InkWell(
                              onTap: () async {
                                await Get.toNamed(
                                    "/board/${controller.postBody[index].value.COMMUNITY_ID}/read/${controller.postBody[index].value.BOARD_ID}",
                                    arguments: {"type": 0}).then((value) async {
                                  await MainUpdateModule.updateHotMain();
                                });
                              },
                              child: PostWidget(
                                c: null,
                                mailWriteController: null,
                                mailController: null,
                                item: controller.postBody[index],
                                index: index,
                                mainController: mainController,
                              ),
                            ),
                          );

                          // PostPreview(
                          //   item: controller.postBody[index],
                          // );
                        }),
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
