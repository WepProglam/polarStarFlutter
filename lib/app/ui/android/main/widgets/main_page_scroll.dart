import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/boardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/classPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/hotBoardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

class MainPageScroll extends StatelessWidget {
  final box = GetStorage();
  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff6f6f6),
        elevation: 0,
        toolbarHeight: 37 + 13.0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 5),
              width: size.width - 15 * 2,
              height: 30,
              child: MainSearchBar(size: size, searchText: searchText),
            )
          ],
        ),
      ),
      bottomNavigationBar:
          CustomBottomNavigationBar(mainController: mainController),
      body: Obx(() {
        if (!mainController.dataAvailalbe) {
          return CircularProgressIndicator();
        } else {
          return Container(
            decoration: BoxDecoration(color: const Color(0xfff6f6f6)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //핫게
                  Container(
                    width: size.width,
                    height: 372 + 5.0,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                      child: HotBoardMain(
                          size: size, mainController: mainController),
                    ),
                  ),
                  // 게시판
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 8),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: 24 + 13.0,
                            child: BoardPreviewItem_top(),
                            padding: const EdgeInsets.only(bottom: 13),
                          ),
                          Container(
                            height: (81 + 10.0) *
                                mainController.followingCommunity.length,
                            child: ListView.builder(
                                itemCount:
                                    mainController.followingCommunity.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  String target_community_id =
                                      mainController.followingCommunity[index];
                                  Rx<BoardInfo> boardInfo;

                                  for (var item in mainController.boardInfo) {
                                    if ("${item.value.COMMUNITY_ID}" ==
                                        target_community_id) {
                                      boardInfo = item;
                                      break;
                                    }
                                  }

                                  return Container(
                                    height: 81,
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: BoardPreviewItem_board(
                                        boardInfo: boardInfo, size: size),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //강의정보
                  Container(
                    //리스트 뷰에서 bottom 13 마진 줌
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: ClassItem_TOP(),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 12),
                            // height: 163.5,
                            child: ClassItem_Content(
                                mainController: mainController),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: const Color(0xffffffff)))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}

class MainSearchBar extends StatelessWidget {
  const MainSearchBar({
    Key key,
    @required this.size,
    @required this.searchText,
  }) : super(key: key);

  final Size size;
  final TextEditingController searchText;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: size.width - 38.5 - 15 - 23.5 - 19.4 - 15,
              margin: const EdgeInsets.only(left: 23.5, top: 11),
              child: TextFormField(
                controller: searchText,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Search Something!!!"),
              ),
            ),
            Spacer(),
            // 패스 894
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 19.4, 7.7),
              child: Container(
                  width: 14.2841796875,
                  height: 14.29736328125,
                  child: InkWell(
                    onTap: () {
                      Map arg = {
                        'search': searchText.text,
                      };

                      Get.toNamed('/board/searchAll/page/1', arguments: arg);
                    },
                    child: Image.asset(
                      "assets/images/894.png",
                      fit: BoxFit.fitHeight,
                    ),
                  )),
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: const Color(0xffeeeeee)));
  }
}
