import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/boardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/classPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/hotBoardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/add_class.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:flutter/services.dart';

class MainPageScroll extends StatelessWidget {
  final box = GetStorage();
  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(children: [
      // Container(
      //   height: size.height,
      //   decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //           begin: Alignment.topCenter,
      //           // Alignment(0.5, 0),
      //           end: Alignment.bottomCenter,
      //           // Alignment(0.5, 1),
      //           stops: [
      //         0.1,
      //         0.2,
      //         0.5
      //       ],
      //           colors: [
      //         // Colors.lightBlue[200],
      //         // Colors.lightBlue[50],
      //         // const Color(0xfff6f6f6),
      //         const Color(0xff1a4678),
      //         const Color(0xba1a4678),
      //         const Color(0xfff6f6f6),
      //       ])),
      // ),
      Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor:
              // Colors.transparent,
              const Color(0xff1a4678),
          // Colors.lightBlue[100],
          // const Color(0xfff6f6f6),
          elevation: 0,
          toolbarHeight: 37 + 13.0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: size.width - 15 * 2,
            child: Row(
              children: [
                Container(
                  child: Text(
                    "POLAR STAR",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Ink(
                  child: InkWell(
                    onTap: () {
                      Session().getX('/logout');
                      Session.cookies = {};
                      Session.headers['Cookie'] = '';
                      box.remove('pw');
                      box.remove('isloggined');
                      box.remove('token');
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (Route<dynamic> route) => false);
                      Get.offAllNamed('/login');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.MAIN_PAGE_SEARCH);
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar:
            CustomBottomNavigationBar(mainController: mainController),
        body: Obx(() {
          if (!mainController.dataAvailalbe) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(
              height: size.height,
              // decoration: BoxDecoration(color: Colors.transparent),
              // decoration: BoxDecoration(color: const Color(0xfff6f6f6)),
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //         begin: Alignment.topCenter,
              //         // Alignment(0.5, 0),
              //         end: Alignment.bottomCenter,
              //         // Alignment(0.5, 1),
              //         stops: [
              //       0.1,
              //       0.2,
              //       0.3
              //     ],
              //         colors: [
              //       Colors.lightBlue[100],
              //       Colors.lightBlue[50],
              //       const Color(0xfff6f6f6),
              //       // const Color(0xff1a4678),
              //       // const Color(0xba1a4678),
              //       // const Color(0xfff6f6f6),
              //     ])),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          // Alignment(0.5, 0),
                          end: Alignment.bottomCenter,
                          // Alignment(0.5, 1),
                          stops: [
                        0.01,
                        0.1,
                        0.3
                      ],
                          colors: [
                        // Colors.lightBlue[100],
                        // Colors.lightBlue[50],
                        // const Color(0xfff6f6f6),
                        const Color(0xff1a4678),
                        const Color(0xba1a4678),
                        const Color(0xfff6f6f6),
                      ])),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //핫게
                      Container(
                        width: size.width,
                        // height: 372 + 5.0,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: HotBoardMain(
                              size: size, mainController: mainController),
                        ),
                      ),
                      // 게시판
                      Container(
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, top: 13),
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: 24 + 13.0,
                                child: BoardPreviewItem_top(),
                                padding: const EdgeInsets.only(bottom: 13),
                              ),
                              mainController.followingCommunity.length > 0
                                  ? Container(
                                      height: (81 + 10.0) *
                                          mainController
                                              .followingCommunity.length,
                                      child: ListView.builder(
                                          itemCount: mainController
                                              .followingCommunity.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String target_community_id =
                                                mainController
                                                    .followingCommunity[index];
                                            Rx<BoardInfo> boardInfo;

                                            for (var item
                                                in mainController.boardInfo) {
                                              if ("${item.value.COMMUNITY_ID}" ==
                                                  target_community_id) {
                                                boardInfo = item;
                                                break;
                                              }
                                            }

                                            return Container(
                                              height: 81,
                                              margin: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: BoardPreviewItem_board(
                                                boardInfo: boardInfo,
                                                size: size,
                                                fromList: false,
                                              ),
                                            );
                                          }),
                                    )
                                  : Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: const Color(0xffffffff)),
                                      child: Center(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Ink(
                                                  width: 40,
                                                  height: 40,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Get.toNamed(
                                                          "/board/boardList");
                                                    },
                                                    child: Image.asset(
                                                        "assets/images/941.png"),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Follow communites",
                                                style: textStyle,
                                              ),
                                            ]),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      //강의정보
                      Container(
                        //리스트 뷰에서 bottom 13 마진 줌
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, top: 17),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: ClassItem_TOP(),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 12),
                                // height: 163.5,
                                child: mainController.classList.length > 0
                                    ? ClassItem_Content(
                                        mainController: mainController)
                                    : Container(
                                        height: 150,
                                        child: Center(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Ink(
                                                    width: 40,
                                                    height: 40,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Get.toNamed(Routes
                                                            .TIMETABLE_ADDCLASS_MAIN);
                                                      },
                                                      child: Image.asset(
                                                          "assets/images/941.png"),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Add classes",
                                                  style: textStyle,
                                                ),
                                              ]),
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
              ),
            );
          }
        }),
      ),
    ]);
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
