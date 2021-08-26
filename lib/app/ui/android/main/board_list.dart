import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/new_board_dialog.dart';

import '../board/functions/check_follow.dart';

class BoardList extends StatelessWidget {
  final MainController mainController = Get.find();
  final TextEditingController boardNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (mainController.dataAvailalbe) {
            return SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        // // Hot
                        // Container(child: hotBoard()),
                        // // Recruit
                        // Recruit(),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '전체 게시판 목록',
                                ),
                              ),
                              Spacer(),
                              // Container(
                              //   height: 20,
                              //   width: 150,
                              //   child: TextFormField(
                              //     controller: boardNameController,
                              //     inputFormatters: [
                              //       LengthLimitingTextInputFormatter(9)
                              //     ],
                              //   ),
                              // ),
                              // 게시판 추가
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "게시판 새로 만들기",
                                  textScaleFactor: 1,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await createNewCommunity(mainController);
                                },
                                child: Icon(Icons.add),
                              )
                            ],
                          ),
                        ),
                        Container(child: boards(mainController))
                      ],
                    ),
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
    boardList.add(
        board(element.COMMUNITY_ID, element.COMMUNITY_NAME, mainController));
  });

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: boardList,
  );
}

// 게시판 위젯
Widget board(
    int COMMUNITY_ID, dynamic COMMUNITY_NAME, MainController mainController) {
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
                      COMMUNITY_ID, COMMUNITY_NAME);
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
