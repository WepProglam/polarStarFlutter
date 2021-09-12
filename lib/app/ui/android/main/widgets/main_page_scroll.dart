import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/boardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/hotBoardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/main_page_board.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';
import 'package:polarstar_flutter/session.dart';

class MainPageScroll extends StatelessWidget {
  final box = GetStorage();
  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final deviceWidth = size.width;

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
      //테스트 용으로 놔둠
      floatingActionButton: FloatingActionButton(
        child: Center(child: Text("로그아웃")),
        onPressed: () async {
          Session().getX('/logout');
          Session.cookies = {};
          Session.headers['Cookie'] = '';

          box.write('isAutoLogin', false);
          box.remove('id');
          box.remove('pw');
          box.remove('token');

          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (Route<dynamic> route) => false);
          Get.offAllNamed('/');
        },
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
                    margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: 24 + 13.0,
                            child: BoardPreviewItem_top(),
                            padding: const EdgeInsets.only(bottom: 13),
                          ),
                          Container(
                            height:
                                (81 + 10.0) * mainController.boardInfo.length,
                            child: ListView.builder(
                                itemCount: mainController.boardInfo.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  Rx<BoardInfo> boardInfo =
                                      mainController.boardInfo[index];
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
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(children: [
                            Container(
                              height: 24,
                              child: Text("My last courses",
                                  style: const TextStyle(
                                      color: const Color(0xff333333),
                                      fontWeight: FontWeight.w900,
                                      fontFamily: "PingFangSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0),
                                  textAlign: TextAlign.left),
                            ),
                            Spacer(),
                            Container(
                              height: 16,
                              margin:
                                  const EdgeInsets.only(top: 4.5, bottom: 3.5),
                              child: Text("View more",
                                  style: const TextStyle(
                                      color: const Color(0xff1a4678),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "PingFangSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                  textAlign: TextAlign.center),
                            )
                          ]),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 12),
                            height: 163.5,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 23 - 13.5 / 2, horizontal: 15),
                              child: Column(
                                children: [
                                  Container(
                                      height: 52,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 13.5 / 2),
                                      child: ClassPreview_Main()),
                                  Container(
                                      height: 52,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 13.5 / 2),
                                      child: ClassPreview_Main()),
                                ],
                              ),
                            ),
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

class ClassPreview_Main extends StatelessWidget {
  const ClassPreview_Main({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 사각형 565
        Container(
            width: 52,
            height: 52,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                child: Image.asset("assets/images/568.png"),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: const Color(0xff1a785c))),
        Container(
          height: 47,
          margin: const EdgeInsets.only(left: 18, top: 2.5, bottom: 2.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 21.5,
                child: Text("Your Subject",
                    style: const TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.w700,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left),
              ),
              Container(
                margin: const EdgeInsets.only(top: 7),
                height: 18.5,
                child: Text("your teacher",
                    style: const TextStyle(
                        color: const Color(0xff999999),
                        fontWeight: FontWeight.w400,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
              )
            ],
          ),
        ),
        Spacer(),
        Container(
            padding: const EdgeInsets.fromLTRB(7.5, 4, 7, 5.5),
            child: Text("Evaluate",
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                textAlign: TextAlign.center),
            margin: const EdgeInsets.only(top: 14.5, bottom: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(26)),
                color: const Color(0xff1a4678)))
      ],
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
