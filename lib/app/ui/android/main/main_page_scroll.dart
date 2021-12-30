import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/loby/init_controller.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
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
  final box = GetStorage();
  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PageController outsidePageController = PageController();
    changeStatusBarColor(Color(0xfff6f6f6), Brightness.dark);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 45.3,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.only(
              top: 9, left: 21, right: 15, bottom: 24.5 / 2),
          width: size.width,
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   // Alignment(0.5, 0),
            //   end: Alignment.bottomCenter,
            //   // Alignment(0.5, 1),
            //   stops: [
            //     0.0,
            //     1.0,
            //   ],
            //   colors: [
            //     // Colors.lightBlue[100],
            //     // Colors.lightBlue[50],
            //     // const Color(0xfff6f6f6),
            //     const Color(0xff1a4678),
            //     const Color(0xff275180),
            //   ],
            // ),
            color: const Color(0xfff6f6f6),
            // color: const Color(0xffffffff),
          ),
          child: Container(
            height: 24,
            child: Row(
              children: [
                Container(
                  child: Text(
                    "POLAR STAR",
                    style: TextStyle(
                        // fontSize: 25,
                        fontSize: 18,
                        // color: Colors.white,
                        color: const Color(0xff1a4678),
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Spacer(),
                Container(
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.MAIN_PAGE_SEARCH);
                      },
                      child: Icon(
                        Icons.search,
                        color: const Color(0xff1a4678),
                        // color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Ink(
                  child: InkWell(
                    onTap: () async {
                      print("adfadsfdfsdfasf");
                      await box.erase();
                      await box.remove('id');
                      await box.remove('pw');
                      await box.remove('isAutoLogin');
                      // await box.write('isAutoLogin', false);

                      await box.save();
                      print("id = " + box.read('id').toString());

                      Session.cookies = {};
                      Session.headers['Cookie'] = '';

                      await Session().getX('/logout');

                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/login', (Route<dynamic> route) => false);
                      await Get.offAllNamed('/login');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.logout,
                        color: const Color(0xff1a4678),
                        // color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // ! 알림 로직 & 재로그인 구현 후 삭제
      floatingActionButton: FloatingActionButton(onPressed: () async {
        // if (!box.hasData("PS")) {
        //   box.write("PS", 0);
        // }
        // print(box.read("PS"));
        // box.write("PS", box.read("PS") + 1);

        await mainController.refreshLikeList();

        // InitController initController = await Get.put(InitController(
        //     repository: LoginRepository(apiClient: LoginApiClient())));
        // await checkFcmToken(initController);
      }),
      bottomNavigationBar:
          CustomBottomNavigationBar(mainController: mainController),
      body: Obx(() {
        if (!mainController.dataAvailalbe) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     // Alignment(0.5, 0),
                //     end: Alignment.bottomCenter,
                //     // Alignment(0.5, 1),
                //     stops: [
                //       0.0,
                //       0.05,
                //       0.1
                //     ],
                //     colors: [
                //       // Colors.lightBlue[100],
                //       // Colors.lightBlue[50],
                //       // const Color(0xfff6f6f6),
                //       // const Color(0xff1a4678),
                //       const Color(0xff275180),
                //       const Color(0xba1a4678),
                //       const Color(0xfff6f6f6),
                //     ]),
                // color: const Color(0xffffffff)
                color: const Color(0xfff6f6f6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 정보제공
                  // ToDo: 서버에서 정보 제공해주면 수정해야함
                  Container(
                    margin: const EdgeInsets.only(top: 24.5 / 2, bottom: 18),
                    height: 180,
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
                          dotWidth: 8.5,
                          dotHeight: 8.5,
                          expansionFactor: 2,
                          dotColor: const Color(0xffbacde3),
                          activeDotColor: const Color(0xff1a4678)),
                    ),
                  ),

                  //핫게
                  Container(
                    // padding: const EdgeInsets.all(18),
                    margin: const EdgeInsets.fromLTRB(18, 17.5, 14, 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Hotboard",
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0),
                            textAlign: TextAlign.center),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed("/board/hot/page/1");
                          },
                          child: Text("View more",
                              style: const TextStyle(
                                  color: const Color(0xff1a4678),
                                  fontWeight: FontWeight.w700,
                                  // fontFamily: "PingFangSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.center),
                        )
                      ],
                    ),
                  ),
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
                        const EdgeInsets.only(left: 15, right: 15, top: 18.5),
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
                                      mainController.followingCommunity.length,
                                  child: ListView.builder(
                                      itemCount: mainController
                                          .followingCommunity.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
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
                                              borderRadius: BorderRadius.all(
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
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
                        const EdgeInsets.only(left: 15, right: 15, top: 18.5),
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
