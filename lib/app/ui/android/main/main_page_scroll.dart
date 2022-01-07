import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/loby/init_controller.dart';
import 'package:polarstar_flutter/app/controller/loby/login_controller.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/class/class.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/boardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/classPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/hotBoardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/outsidePreview.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/add_class.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:flutter/services.dart';

import '../../../../main.dart';

class MainPageScroll extends StatelessWidget {
  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();
  final ScrollController mainScrollController =
      ScrollController(initialScrollOffset: 0.0);
  final FocusNode searchFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    print("시발");
    final Size size = MediaQuery.of(context).size;
    final PageController outsidePageController = PageController();
    return GestureDetector(
      onTap: () {
        searchFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 56.3,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Container(
            width: size.width,
            child: Container(
              height: 24,
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: // 폴라스타
                          Text("폴라스타",
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansKR",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center)),
                  Spacer(),
                  Container(
                    child: Ink(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                          onTap: () async {
                            await mainScrollController.animateTo(0.0,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.fastOutSlowIn);
                            searchFocusNode.requestFocus();
                          },
                          child: Image.asset(
                            "assets/images/icn_search.png",
                            width: 24,
                            height: 24,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (!mainController.dataAvailalbe) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              controller: mainScrollController,
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("新建立 韩国大学联合交流区",
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                                textAlign: TextAlign.center),
                            Text("成均馆大学，汉阳大学，高丽大学",
                                style: const TextStyle(
                                    color: const Color(0xff9b75ff),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 14, left: 20, right: 20),
                        child: NormalSearchBar(
                            searchText: searchText,
                            searchFocusNode: searchFocusNode,
                            mainController: mainController),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 129),
                        decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        child: Column(
                          children: [
                            // * 정보제공
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 48, bottom: 12),
                              height: 100,
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: PageScrollPhysics(),
                                controller: outsidePageController,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return OutsidePreview();
                                },
                              ),
                            ),
                            Center(
                              child: SmoothPageIndicator(
                                controller: outsidePageController,
                                count: 5,
                                effect: ExpandingDotsEffect(
                                    dotWidth: 6,
                                    dotHeight: 6,
                                    expansionFactor: 2,
                                    dotColor: const Color(0xffcecece),
                                    activeDotColor: const Color(0xff571df0)),
                              ),
                            ),

                            //* 핫게
                            Container(
                              // padding: const EdgeInsets.all(18),
                              margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // 热榜
                                  Text("热榜",
                                      style: const TextStyle(
                                          color: const Color(0xff2f2f2f),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "NotoSansSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18.0),
                                      textAlign: TextAlign.left),
                                  InkWell(
                                    onTap: () async {
                                      searchText.clear();
                                      searchFocusNode.unfocus();
                                      await Get.toNamed("/board/hot/page/1")
                                          .then((value) async {
                                        await MainUpdateModule.updateMainPage();
                                      });
                                    },
                                    child: SeeMore(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: size.width,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: HotBoardMain(
                                  size: size,
                                  mainController: mainController,
                                  searchFocusNode: searchFocusNode,
                                  searchText: searchText,
                                ),
                              ),
                            ),

                            // 게시판
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: BoardPreviewItem_top(),
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                    ),
                                    mainController.followingCommunity.length > 0
                                        ? Container(
                                            height: (80 + 10.0) *
                                                mainController
                                                    .followingCommunity.length,
                                            child: ListView.builder(
                                                itemCount: mainController
                                                    .followingCommunity.length,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  String target_community_id =
                                                      mainController
                                                              .followingCommunity[
                                                          index];
                                                  Rx<BoardInfo> boardInfo;

                                                  for (var item
                                                      in mainController
                                                          .boardInfo) {
                                                    if ("${item.value.COMMUNITY_ID}" ==
                                                        target_community_id) {
                                                      boardInfo = item;
                                                      break;
                                                    }
                                                  }

                                                  return InkWell(
                                                    onTap: () async {
                                                      searchText.clear();
                                                      searchFocusNode.unfocus();
                                                      await Get.toNamed(
                                                        "/board/${boardInfo.value.COMMUNITY_ID}/page/${1}",
                                                      ).then((value) async {
                                                        await MainUpdateModule
                                                            .updateMainPage();
                                                      });
                                                    },
                                                    child: Container(
                                                        height: 80,
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10.0),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8)),
                                                            border: Border.all(
                                                                color: const Color(
                                                                    0xffeaeaea),
                                                                width: 1),
                                                            color: const Color(
                                                                0xffffffff)),
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      14),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(children: [
                                                                Text(
                                                                    "${boardInfo.value.COMMUNITY_NAME}",
                                                                    style: const TextStyle(
                                                                        color: const Color(
                                                                            0xff2f2f2f),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            "NotoSansKR",
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        fontSize:
                                                                            14.0),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left),
                                                                NewIcon()
                                                              ]),
                                                              Text(
                                                                  "${boardInfo.value.RECENT_TITLE}",
                                                                  style: const TextStyle(
                                                                      color: const Color(
                                                                          0xff6f6e6e),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          "NotoSansSC",
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontSize:
                                                                          12.0),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left)
                                                            ],
                                                          ),
                                                        )
                                                        // BoardPreviewItem_board(
                                                        //   boardInfo: boardInfo,
                                                        //   size: size,
                                                        //   fromList: false,
                                                        // ),
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
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: Ink(
                                                        width: 40,
                                                        height: 40,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            searchText.clear();
                                                            searchFocusNode
                                                                .unfocus();
                                                            await Get.toNamed(
                                                                    "/board/boardList")
                                                                .then(
                                                                    (value) async {
                                                              await MainUpdateModule
                                                                  .updateMainPage();
                                                            });
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

                            // ClassItem(model: mainController.classList[0]),
                            //강의정보
                            Container(
                              //리스트 뷰에서 bottom 13 마진 줌
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: ClassItem_TOP(),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: mainController.classList.length > 0
                                          ? ListView.builder(
                                              itemCount: mainController
                                                  .classList.length,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Ink(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      searchFocusNode.unfocus();
                                                      await Get.toNamed(
                                                              '/class/view/${mainController.classList[index].CLASS_ID}')
                                                          .then((value) async {
                                                        await MainUpdateModule
                                                            .updateMainPage();
                                                      });
                                                    },
                                                    child: ClassItem(
                                                        model: mainController
                                                            .classList[index]),
                                                  ),
                                                );
                                              })
                                          : Container(
                                              height: 150,
                                              child: Center(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10),
                                                        child: Ink(
                                                          width: 40,
                                                          height: 40,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              searchText
                                                                  .clear();
                                                              searchFocusNode
                                                                  .unfocus();
                                                              await Get.toNamed(
                                                                      Routes
                                                                          .TIMETABLE_ADDCLASS_MAIN)
                                                                  .then(
                                                                      (value) async {
                                                                await MainUpdateModule
                                                                    .updateMainPage();
                                                              });
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: const Color(0xffffffff)))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    right: 20,
                    top: 142,
                    child: Image.asset(
                      "assets/images/img_main_illust.png",
                      // width: 272,
                      fit: BoxFit.fitHeight,
                      height: 137,
                      // width: Get.mediaQuery.size.width,
                      // height: 137,/
                    ))
              ]),
            );
          }
        }),
      ),
    );
  }
}

class NormalSearchBar extends StatelessWidget {
  const NormalSearchBar({
    Key key,
    @required this.searchText,
    @required this.searchFocusNode,
    @required this.mainController,
  }) : super(key: key);

  final TextEditingController searchText;
  final FocusNode searchFocusNode;
  final MainController mainController;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        child: Row(children: [
          Container(
            width: Get.mediaQuery.size.width - 20 * 2 - 6 - 68,
            child: TextFormField(
              onEditingComplete: () async {
                String text = searchText.text;
                searchText.clear();
                searchFocusNode.unfocus();

                await Get.toNamed(Routes.MAIN_PAGE_SEARCH,
                    arguments: {"search": text}).then((value) async {
                  await MainUpdateModule.updateMainPage();
                });
              },
              focusNode: searchFocusNode,
              autofocus: false,
              minLines: 1,
              maxLines: 1,
              controller: searchText,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                isDense: true,
                hintText: "新建立 韩国大学联合交流区",
                hintStyle: const TextStyle(
                    color: const Color(0xffcecece),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 20, right: 0, top: 14, bottom: 14),
              ),
            ),
          ),
          // Rectangle 12
          InkWell(
            onTap: () async {
              String text = searchText.text;
              searchText.clear();
              searchFocusNode.unfocus();

              await Get.toNamed(Routes.MAIN_PAGE_SEARCH,
                  arguments: {"search": text}).then((value) async {
                await MainUpdateModule.updateMainPage();
              });

              print(text);
            },
            child: Container(
                width: 68,
                height: 36,
                margin: const EdgeInsets.only(right: 6, top: 6, bottom: 6),
                child: Center(
                  child: // 搜索
                      Text("搜索",
                          style: const TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: const Color(0xff2f2f2f))),
          ),
        ]),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: const Color(0xffffffff)));
  }
}

class NewIcon extends StatelessWidget {
  const NewIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 38,
        height: 18,
        child: // New
            Center(
          child: Text("New",
              style: const TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 10.0),
              textAlign: TextAlign.left),
        ),
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: const Color(0xff571df0)));
  }
}

class SeeMore extends StatelessWidget {
  const SeeMore({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 更多
        Text("更多",
            style: const TextStyle(
                color: const Color(0xff571df0),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSansSC",
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
            textAlign: TextAlign.left),
        // icn/detail
        Container(
          width: 16,
          height: 16,
          child: Image.asset(
            "assets/images/icn_detail.png",
            fit: BoxFit.contain,
          ),
        )
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
