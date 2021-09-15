import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/boardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/new_board_dialog.dart';

import '../board/functions/check_follow.dart';

class BoardList extends StatelessWidget {
  final MainController mainController = Get.find();
  final TextEditingController boardNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfff6f6f6),
          elevation: 0,
          toolbarHeight: 37 + 13.0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: size.width - 15 * 2,
            child: Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () async {
                    await createNewCommunity(mainController);
                  },
                  child: Container(
                      width: 16,
                      height: 16,
                      child: Image.asset("assets/images/941.png")),
                )
              ],
            ),
          ),
        ),
        body: Obx(() {
          if (mainController.dataAvailalbe) {
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(color: const Color(0xfff6f6f6)),
                child: Container(
                  child: Column(
                    children: [
                      // // Hot
                      // Container(child: hotBoard()),
                      // // Recruit

                      // 게시판
                      Container(
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, top: 8),
                        child: Container(
                          child: Column(
                            children: [
                              Obx(() {
                                return Container(
                                  height: (81 + 10.0) *
                                      mainController.boardInfo.length,
                                  child: ListView.builder(
                                      itemCount:
                                          mainController.boardInfo.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Rx<BoardInfo> boardInfo =
                                            mainController.boardInfo[index];

                                        return Container(
                                          height: 81,
                                          margin: const EdgeInsets.only(
                                              bottom: 10.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: BoardPreviewItem_board(
                                            boardInfo: boardInfo,
                                            size: size,
                                            fromList: true,
                                          ),
                                        );
                                      }),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}

class Recruit extends StatelessWidget {
  const Recruit({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(color: Colors.lightBlue[100]),
        width: Get.mediaQuery.size.width - 18,
        height: 100,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: Colors.black,
          ),
          onPressed: () {
            Get.toNamed('/outside/1/page/1');
          },
          child: Text(
            'RECRUIT',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

Widget boards(MainController mainController) {
  List<Widget> boardList = [];
  List<BoardInfo> data = mainController.boardListInfo;

  data.forEach((element) {
    boardList.add(board(element, mainController));
  });

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: boardList,
  );
}

// 게시판 위젯
Widget board(BoardInfo element, MainController mainController) {
  int COMMUNITY_ID = element.COMMUNITY_ID;
  String COMMUNITY_NAME = element.COMMUNITY_NAME;
  String RECENT_TITLE = "${element.RECENT_TITLE}";
  bool isFollowed = element.isFollowed;
  return Obx(() {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(color: Colors.lightBlue[100]),
        width: Get.mediaQuery.size.width - 18,
        height: 100,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: Colors.black,
          ),
          onPressed: () {
            Get.toNamed('/board/$COMMUNITY_ID/page/1');
          },
          child: Row(children: [
            InkWell(
              onTap: () async {
                if (!checkFollow(COMMUNITY_ID, mainController.boardInfo)) {
                  await mainController.setFollowingCommunity(
                      COMMUNITY_ID, COMMUNITY_NAME, RECENT_TITLE, isFollowed);
                } else {
                  await mainController.deleteFollowingCommunity(COMMUNITY_ID);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: checkFollow(COMMUNITY_ID, mainController.boardInfo)
                    ? Icon(Icons.star)
                    : Icon(Icons.star_border),
              ),
            ),
            Text(
              "${COMMUNITY_NAME}",
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ),
    );
  });
}

Widget hotBoard() {
  return Padding(
    padding: const EdgeInsets.all(1),
    child: Container(
      decoration: BoxDecoration(color: Colors.lightBlue[100]),
      width: Get.mediaQuery.size.width - 18,
      height: 100,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: Colors.black,
        ),
        onPressed: () {
          Get.toNamed('/board/hot/page/1');
        },
        child: Text(
          'HOT',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
