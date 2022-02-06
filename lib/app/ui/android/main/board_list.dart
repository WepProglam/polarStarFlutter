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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Get.theme.primaryColor,
          splashColor: Get.theme.primaryColor,
          onPressed: () async {
            await createNewCommunity(mainController);
          },
          child: // Ellipse 6
              Container(
                  width: 24,
                  height: 24,
                  child: Image.asset("assets/images/board_create.png"),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  )),
        ),
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 56,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Container(
            margin:
                const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: Get.mediaQuery.size.width - 20 - 62,
                    margin: const EdgeInsets.only(right: 14),
                    height: 32,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Image.asset(
                            "assets/images/icn_search.png",
                            width: 20,
                            height: 20,
                            color: const Color(0xffcecece),
                          ),
                        ),
                        Container(
                          width: Get.mediaQuery.size.width - 20 - 62 - 30 - 20,
                          child: TextFormField(
                            onChanged: (String text) {
                              mainController.checkBoard(text);
                              print(text);
                            },
                            // focusNode: searchFocusNode,
                            autofocus: false,
                            minLines: 1,
                            maxLines: 1,
                            // controller: searchText,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "搜索论坛分区",
                              hintStyle: const TextStyle(
                                  color: const Color(0xffcecece),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 0, right: 0, top: 0, bottom: 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: const Color(0xffffffff))),
                Container(
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text("取消",
                          style: const TextStyle(
                              color: const Color(0xfff5f6ff),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Obx(() {
          if (mainController.dataAvailalbe) {
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Container(
                  child: Column(
                    children: [
                      // 게시판
                      Container(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                child: Obx(() {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          mainController.selectedBoard.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Rx<BoardInfo> boardInfo =
                                            mainController.selectedBoard[index];

                                        if (!boardInfo.value.isChecked) {
                                          return Container();
                                        }

                                        return // 패스 63
                                            BoardListItem(
                                                enableFollowTab: true,
                                                boardInfo: boardInfo,
                                                mainController: mainController);

                                        // Container(
                                        //   height: 81,
                                        //   margin: const EdgeInsets.only(
                                        //       bottom: 10.0),
                                        //   decoration: BoxDecoration(
                                        //       color: Colors.white,
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(20))),
                                        // child: BoardPreviewItem_board(
                                        //     boardInfo: boardInfo,
                                        //     size: size,
                                        //     fromList: true,
                                        //   ),
                                        // );
                                      });
                                }),
                              )
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
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}

class BoardListItem extends StatelessWidget {
  const BoardListItem({
    Key key,
    @required this.boardInfo,
    @required this.mainController,
    @required this.enableFollowTab,
  }) : super(key: key);

  final Rx<BoardInfo> boardInfo;
  final MainController mainController;
  final bool enableFollowTab;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 77,
        child: Container(
          margin: const EdgeInsets.only(left: 14, right: 12),
          child: Ink(
            child: InkWell(
              onTap: () async {
                await Get.toNamed(
                  "/board/${boardInfo.value.COMMUNITY_ID}/page/${1}",
                ).then((value) async {
                  await MainUpdateModule.updateBoardListPage();
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${boardInfo.value.COMMUNITY_NAME}",
                                  style: const TextStyle(
                                      color: const Color(0xff2f2f2f),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.left),
                              InkWell(
                                onTap: enableFollowTab
                                    ? () async {
                                        if (!checkFollow(
                                            boardInfo.value.COMMUNITY_ID,
                                            mainController.boardInfo)) {
                                          await mainController
                                              .setFollowingCommunity(
                                                  boardInfo.value.COMMUNITY_ID,
                                                  boardInfo
                                                      .value.COMMUNITY_NAME,
                                                  boardInfo.value.RECENT_TITLE,
                                                  boardInfo.value.RECENT_TIME
                                                      .toString(),
                                                  boardInfo.value.isFollowed,
                                                  boardInfo.value.isNew);
                                        } else {
                                          await mainController
                                              .deleteFollowingCommunity(
                                                  boardInfo.value.COMMUNITY_ID);
                                        }
                                        boardInfo.update((val) {
                                          val.isFollowed = !val.isFollowed;
                                        });

                                        mainController.sortBoard();
                                      }
                                    : null,
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Image.asset(boardInfo.value.isFollowed
                                      ? "assets/images/bookmark_followed.png"
                                      : "assets/images/bookmark_none.png"),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Spacer(),
                        // Rectangle 7
                        boardInfo.value.isNew
                            ? Container(
                                width: 38,
                                height: 18,
                                child: Center(
                                  child: // New
                                      Text("New",
                                          style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Roboto",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 10.0),
                                          textAlign: TextAlign.left),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Get.theme.primaryColor))
                            : Container()
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2, right: 20),
                    child: Text("${boardInfo.value.RECENT_TITLE}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff6f6e6e),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),
                  )
                ],
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffeaeaea), width: 1),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x0f000000),
                  offset: Offset(0, 3),
                  blurRadius: 10,
                  spreadRadius: 0)
            ],
            color: const Color(0xffffffff)));
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
  DateTime RECENT_TIME = element.RECENT_TIME;
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
                      COMMUNITY_ID,
                      COMMUNITY_NAME,
                      RECENT_TITLE,
                      RECENT_TIME.toString(),
                      isFollowed,
                      element.isNew);
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
