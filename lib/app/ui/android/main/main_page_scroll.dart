import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/loby/init_controller.dart';
import 'package:polarstar_flutter/app/controller/loby/login_controller.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/class/class.dart';
import 'package:polarstar_flutter/app/ui/android/main/board_list.dart';
import 'package:polarstar_flutter/app/ui/android/main/main_page.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/banner_widget.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/dialoge.dart';
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
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../main.dart';

const mainColor = 0xff4570ff;
const subColor = 0xff91bbff;
const whiteColor = 0xffffffff;
const textColor = 0xff2f2f2f;

class MainPageScroll extends StatelessWidget {
  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();
  final ScrollController mainScrollController =
      ScrollController(initialScrollOffset: 0.0);
  final InitController initController = Get.find();
  final FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        searchFocusNode.unfocus();
      },
      child: Scaffold(
        // backgroundColor: Get.theme.primaryColor,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 56,
          automaticallyImplyLeading: false,
          titleSpacing: 20,
          title: Text("北北上学堂",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: const Color(whiteColor),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
              textAlign: TextAlign.center),
          actions: [
            InkWell(
              onTap: () async {
                await mainScrollController.animateTo(0.0,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.fastOutSlowIn);
                searchFocusNode.requestFocus();
              },
              child: Ink(
                width: 65.6,
                child: Image.asset(
                  "assets/images/icn_search.png",
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (!mainController.dataAvailalbe) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Obx(() {
              int boardHeight = 77;
              int boardListLength = mainController.followingCommunity.length;
              double tabbar_height = 20 + 14.0 + 5.0;

              double boardListHeight =
                  mainController.followingCommunity.length > 0
                      ? boardHeight.toDouble() *
                          (mainController.followingCommunity.length)
                      : 77.0;
              return NestedScrollView(
                controller: mainScrollController,

                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  print(
                      "mainController.followingCommunity.length ${mainController.followingCommunity.length}");

                  return [
                    SliverAppBar(
                        elevation: 0.0,
                        pinned: true,
                        floating: true,
                        snap: false,
                        stretch: true,
                        expandedHeight: boardListHeight +
                            24 +
                            24 +
                            40 +
                            14.0 +
                            100 +
                            12 +
                            6.0 +
                            42 +
                            14 +
                            301 +
                            tabbar_height,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 301,
                                  color: Get.theme.primaryColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("성균관대학교",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color:
                                                        const Color(whiteColor),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0),
                                                textAlign: TextAlign.center),
                                            (mainController.profile.value != {})
                                                ? Text(
                                                    "${mainController.profile["COLLEGE_NAME"]} ${mainController.profile["MAJOR_NAME"]}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: const Color(
                                                            subColor),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "NotoSansKR",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 12.0),
                                                    textAlign: TextAlign.center)
                                                : Text("UNKNOWN COLLEGE",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: const Color(
                                                            subColor),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "NotoSansSC",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 12.0),
                                                    textAlign:
                                                        TextAlign.center),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, left: 20, right: 20),
                                        child: NormalSearchBar(
                                            searchText: searchText,
                                            searchFocusNode: searchFocusNode,
                                            mainController: mainController),
                                      ),
                                      Stack(children: [
                                        Container(
                                          height: 198,
                                        ),
                                        Positioned(
                                          top: 36.6,
                                          right: 17.1,
                                          child: Image.asset(
                                              "assets/images/panda.png",
                                              height: 164.6),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: boardListHeight +
                                      24 +
                                      14.0 +
                                      100 +
                                      12 +
                                      6.0 +
                                      14 +
                                      42,
                                  color: Get.theme.primaryColor,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(whiteColor),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        // * 정보제공
                                        Container(
                                          height: 100 + 12 + 6.0 + 42,
                                          padding:
                                              const EdgeInsets.only(top: 42),
                                          child: BannerWidget(),
                                        ),
                                        //* 게시판
                                        Container(
                                          height: boardListHeight + 24 + 14.0,
                                          color: Colors.white,
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20, top: 14),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 14),
                                                  height: 24,
                                                  child: BoardPreviewItem_top(
                                                    mainController:
                                                        mainController,
                                                  ),
                                                ),
                                                mainController
                                                            .followingCommunity
                                                            .length >
                                                        0
                                                    ? Container(
                                                        height: boardListHeight,
                                                        child: Obx(() {
                                                          return ListView
                                                              .builder(
                                                                  itemCount:
                                                                      mainController
                                                                          .followingCommunity
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    String
                                                                        target_community_id =
                                                                        mainController
                                                                            .followingCommunity[index];
                                                                    Rx<BoardInfo>
                                                                        boardInfo;

                                                                    for (var item
                                                                        in mainController
                                                                            .boardInfo) {
                                                                      if ("${item.value.COMMUNITY_ID}" ==
                                                                          target_community_id) {
                                                                        boardInfo =
                                                                            item;
                                                                        break;
                                                                      }
                                                                    }

                                                                    // * follow 하는게 서버에서 사라졌을때 해당 팔로우 정보 삭제
                                                                    if (boardInfo ==
                                                                        null) {
                                                                      mainController
                                                                          .deleteFollowingCommunity(
                                                                              int.parse(target_community_id));
                                                                      return Container();
                                                                    }

                                                                    return Container(
                                                                      height:
                                                                          77,
                                                                      child: BoardListItem(
                                                                          enableFollowTab:
                                                                              false,
                                                                          boardInfo:
                                                                              boardInfo,
                                                                          mainController:
                                                                              mainController),
                                                                    );
                                                                  });
                                                        }),
                                                      )
                                                    : InkWell(
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
                                                        child: Container(
                                                          height: 77,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              7)),
                                                                  border: Border.all(
                                                                      color: const Color(
                                                                          0xffeaeaea),
                                                                      width: 1),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: const Color(
                                                                            0x0f000000),
                                                                        offset: Offset(
                                                                            0,
                                                                            3),
                                                                        blurRadius:
                                                                            10,
                                                                        spreadRadius:
                                                                            0)
                                                                  ],
                                                                  color: const Color(
                                                                      0xffffffff)),
                                                          child: Center(
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            1),
                                                                    child: Ink(
                                                                      width: 24,
                                                                      height:
                                                                          24,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add_circle_outline_outlined,
                                                                        size:
                                                                            24,
                                                                        color: const Color(
                                                                            0xffd6d4d4),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text("跟踪社区",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: const TextStyle(
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color: const Color(
                                                                              0xffd6d4d4),
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontFamily:
                                                                              "NotoSansSC",
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          fontSize:
                                                                              10.0),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center)
                                                                ]),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 20, top: 40),
                                  child: Text("帖子推荐",
                                      style: const TextStyle(
                                          color: const Color(0xff2f2f2f),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "NotoSansSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.left),
                                ),
                              ],
                            ),
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(tabbar_height),
                          child: Container(
                            margin: const EdgeInsets.only(top: 14, bottom: 5),
                            height: 20,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TabBar(
                                    padding: const EdgeInsets.all(0.0),
                                    indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                          color: const Color(0xff4c74f6),
                                          width: 2.0),
                                      insets: EdgeInsets.fromLTRB(
                                          3.0, 0.0, 3.0, 0.0),
                                    ),
                                    controller:
                                        mainController.hotNewTabController,
                                    onTap: (index) {
                                      mainController.hotOrNewIndex(index);
                                      print(mainController.hotOrNewIndex);
                                    },
                                    indicatorColor: Get.theme.primaryColor,
                                    isScrollable: true,
                                    indicatorPadding: EdgeInsets.zero,
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    labelColor: const Color(0xff000000),
                                    unselectedLabelColor:
                                        const Color(0xffd6d4d4),
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Roboto",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                    tabs: <Tab>[
                                      Tab(
                                        text: "Hot",
                                      ),
                                      Tab(
                                        text: "New",
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: Ink(
                                    child: InkWell(
                                      onTap: () async {
                                        searchText.clear();
                                        searchFocusNode.unfocus();
                                        await Get.toNamed("/board/hot/page/1")
                                            .then((value) async {
                                          await MainUpdateModule
                                              .updateMainPage();
                                        });
                                      },
                                      child: SeeMore(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        backgroundColor: const Color(whiteColor))
                  ];
                },
                body: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 23 - 5.0),
                  child: mainController.hotBoard.length != 0
                      ?
                      //* 핫게
                      Column(children: [
                          Obx(() {
                            if (mainController.hotOrNewIndex.value == 0) {
                              return Expanded(
                                child: HotBoardMain(
                                  size: size,
                                  mainController: mainController,
                                  searchFocusNode: searchFocusNode,
                                  searchText: searchText,
                                ),
                              );
                            } else {
                              return Expanded(
                                  child: NewBoardMain(
                                size: size,
                                mainController: mainController,
                                searchFocusNode: searchFocusNode,
                                searchText: searchText,
                              ));
                            }
                          }),
                          // Container(
                          //   width: size.width,
                          //   child: Container(
                          //     margin: const EdgeInsets.fromLTRB(
                          //         0, 0, 0, 0),
                          //     child: HotBoardMain(
                          //       size: size,
                          //       mainController: mainController,
                          //       searchFocusNode: searchFocusNode,
                          //       searchText: searchText,
                          //     ),
                          //   ),
                          // ),
                        ])
                      : Container(),
                ),
                // Positioned(
                //     right: 17.1,
                //     top: 158.6 - 20,
                //     child: Image.asset("assets/images/panda.png",
                //         // width: 272,
                //         height: 164.6
                //         // width: Get.mediaQuery.size.width,
                //         // height: 137,/
                //         ))
              );
            });
          }
        }),
      ),
    );
  }
}

void CreateNewTimetable(
    TextEditingController searchText, FocusNode searchFocusNode) async {
  putController<TimeTableController>();
  final box = GetStorage();
  TimeTableController tc = Get.find();
  int year = box.read("year_sem")["TIMETABLE_YEAR_FROM_DATE"];
  int semester = box.read("year_sem")["TIMETABLE_SEMESTER_FROM_DATE"];
  int stc = await tc.getSemesterTimeTable(
    "${year}",
    "${semester}",
  );
  if (stc != 200) {
    Function ontapConfirm = () async {
      Get.back();
      searchText.clear();
      searchFocusNode.unfocus();

      await Get.toNamed(Routes.TIMETABLE_ADDTIMETABLE).then((value) async {
        await MainUpdateModule.updateMainPage();
      });
    };
    Function ontapCancel = () {
      Get.back();
    };
    TFdialogue(Get.context, "目前您还未生成该学期的时间表",
        "确定生成${year}学年度 第${semester}学期的时间表吗？ ", ontapConfirm, ontapCancel);
  } else {
    bool canGo = await tc.canGoClassSearchPage(year, semester);
    if (canGo) {
      await Get.toNamed(Routes.TIMETABLE_ADDCLASS_MAIN).then((value) async {
        await MainUpdateModule.updateMainPage();
      });
    } else {
      await Get.toNamed(Routes.TIMETABLE_ADDCLASS_DIRECT).then((value) async {
        await MainUpdateModule.updateMainPage();
      });
    }
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
                hintText: "请输入搜索内容",
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
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(whiteColor),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: const Color(textColor))),
          ),
        ]),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: const Color(whiteColor)));
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
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: const Color(whiteColor),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 10.0),
              textAlign: TextAlign.left),
        ),
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Get.theme.primaryColor));
  }
}

class SeeMore extends StatelessWidget {
  const SeeMore({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 3.0, 2.0, 3.0),
      child: Row(
        children: [
          // 更多
          Text("更多",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: const Color(mainColor),
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
              color: const Color(mainColor),
            ),
          )
        ],
      ),
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
