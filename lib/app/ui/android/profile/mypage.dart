import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/loby/login_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';

class Mypage extends StatelessWidget {
  final MyPageController myPageController = Get.find();
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    // changeStatusBarColor(Color(0xff1a4678), Brightness.dark);
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xfff2f2f2),
          // bottomNavigationBar:
          //     CustomBottomNavigationBar(mainController: mainController),
          body: Stack(children: [
            Obx(
              () {
                if (myPageController.dataAvailableMypage) {
                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        MyPageProfile(myPageController: myPageController)
                      ];
                    },
                    body: TabBarView(
                        controller: myPageController.tabController,
                        children: [
                          RefreshIndicator(
                            onRefresh: () => myPageController.getMineWrite(),
                            child: Obx(() {
                              if (myPageController.myBoardWrite.length == 0) {
                                return Stack(children: [
                                  ListView(),
                                  Center(
                                    child: Text("아직 정보가 없습니다."),
                                  ),
                                ]);
                              } else {
                                return ListView.builder(
                                    cacheExtent: 10,
                                    itemCount:
                                        myPageController.myBoardWrite.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 5), //자체 패딩 10 + 5 = 15
                                        child: PostPreview(
                                          item:
                                              myPageController.myBoardWrite[i],
                                          /*
                                           * type 0 : 메인 -> 핫
                                           * type 1 : 마이 -> 게시글
                                           * type 2 : 게시판 -> 게시글
                                           */
                                          type: 1,
                                        ),
                                      );
                                    });
                              }
                            }),
                          ),
                          RefreshIndicator(
                            onRefresh: () => myPageController.getMineWrite(),
                            child: Obx(() {
                              if (myPageController.myBoardScrap.length == 0) {
                                return Stack(children: [
                                  ListView(),
                                  Center(
                                    child: Text("아직 정보가 없습니다."),
                                  ),
                                ]);
                              } else {
                                return ListView.builder(
                                    cacheExtent: 10,
                                    itemCount:
                                        myPageController.myBoardScrap.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 5), //자체 패딩 10 + 5 = 15
                                        child: PostPreview(
                                          item:
                                              myPageController.myBoardScrap[i],
                                          /*
                                           * type 0 : 메인 -> 핫
                                           * type 1 : 마이 -> 게시글
                                           * type 2 : 게시판 -> 게시글
                                           */
                                          type: 1,
                                        ),
                                      );
                                    });
                              }
                            }),
                          ),
                          RefreshIndicator(
                            onRefresh: () => myPageController.getMineWrite(),
                            child: Obx(() {
                              if (myPageController.myBoardLike.length == 0) {
                                return Stack(children: [
                                  ListView(),
                                  Center(
                                    child: Text("아직 정보가 없습니다."),
                                  ),
                                ]);
                              } else {
                                return ListView.builder(
                                    cacheExtent: 10,
                                    itemCount:
                                        myPageController.myBoardLike.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 5), //자체 패딩 10 + 5 = 15
                                        child: PostPreview(
                                          item: myPageController.myBoardLike[i],
                                          /*
                                           * type 0 : 메인 -> 핫
                                           * type 1 : 마이 -> 게시글
                                           * type 2 : 게시판 -> 게시글
                                           */
                                          type: 1,
                                        ),
                                      );
                                    });
                              }
                            }),
                          )
                        ]),
                  );

                  // ! Non-Sliver Code
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //         height: 294,
                  //         width: MediaQuery.of(context).size.width,
                  //         // decoration: BoxDecoration(
                  //         //     image: DecorationImage(
                  //         //         image: AssetImage('assets/images/279.png'),
                  //         //         fit: BoxFit.none)),
                  //         // ! 왜 이걸 이미지를?
                  //         color: const Color(0xff1a4678),
                  //         child:
                  //             MyPageProfile(myPageController: myPageController)),
                  //     Container(
                  //         width: MediaQuery.of(context).size.width,
                  //         height: 61.5,
                  //         // margin: const EdgeInsets.only(bottom: 10),
                  //         decoration:
                  //             BoxDecoration(color: const Color(0xffffffff)),
                  //         child: MyPageProfilePostIndex(
                  //             myPageController: myPageController)),

                  //     //* Posted, Scraped, Liked 표시하는 부분
                  //     Expanded(child: Obx(() {
                  //       List<bool> dataAvailable = [
                  //         myPageController.dataAvailableMypageWrite,
                  //         myPageController.dataAvailableMypageScrap,
                  //         myPageController.dataAvailableMypageLike,
                  //       ];

                  //       List<RxList<Rx<Post>>> userPost = [
                  //         myPageController.myBoardWrite,
                  //         myPageController.myBoardScrap,
                  //         myPageController.myBoardLike,
                  //       ];

                  //       return PageView.builder(
                  //           allowImplicitScrolling: true,
                  //           controller: myPageController.pageController,
                  //           onPageChanged: (value) {
                  //             myPageController.profilePostIndex.value = value;
                  //           },
                  //           itemCount: 3,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             print(index);
                  //             return RefreshIndicator(
                  //               onRefresh: () async {
                  //                 switch (index) {
                  //                   case 0:
                  //                     myPageController.getMineWrite();
                  //                     break;
                  //                   case 1:
                  //                     myPageController.getMineScrap();
                  //                     break;
                  //                   case 2:
                  //                     myPageController.getMineLike();
                  //                     break;
                  //                   default:
                  //                 }

                  //                 return true;
                  //               },
                  //               child: Obx(
                  //                 () {
                  //                   if (dataAvailable[myPageController
                  //                       .profilePostIndex.value]) {
                  //                     if (userPost[index].length == 0) {
                  //                       return Center(
                  //                         child: Text("아직 정보가 없습니다."),
                  //                       );
                  //                     } else {
                  //                       return Container(
                  //                         margin: const EdgeInsets.only(top: 10),
                  //                         child: ListView.builder(
                  //                             cacheExtent: 10,
                  //                             itemCount: userPost[index].length,
                  //                             itemBuilder:
                  //                                 (BuildContext context, int i) {
                  //                               return Container(
                  //                                 margin: const EdgeInsets.only(
                  //                                     bottom:
                  //                                         5), //자체 패딩 10 + 5 = 15
                  //                                 child: PostPreview(
                  //                                   item: userPost[index][i],
                  //                                   /**
                  //                                    * * type 0 : 메인 -> 핫
                  //                                    * * type 1 : 마이 -> 게시글
                  //                                    * * type 2 : 게시판 -> 게시글
                  //                                    */
                  //                                   type: 1,
                  //                                 ),
                  //                               );
                  //                             }),
                  //                       );
                  //                     }
                  //                   } else {
                  //                     return Center(
                  //                       child: Text("아직 정보가 없습니다."),
                  //                     );
                  //                   }
                  //                 },
                  //               ),
                  //             );
                  //           });
                  //     }))
                  //   ],
                  // );

                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Positioned(
              right: 16,
              top: 20,
              child: Ink(
                child: InkWell(
                  onTap: () async {
                    LoginController loginController = Get.find();
                    loginController.logout();

                    await Get.offAllNamed('/login');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.logout,
                      color: const Color(0xffffffff),
                      size: 24,
                      // color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ])),
    );
  }
}

class MyPageProfile extends StatelessWidget {
  const MyPageProfile({
    Key key,
    @required this.myPageController,
  }) : super(key: key);

  final MyPageController myPageController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: false,
      expandedHeight: 370,
      backgroundColor: Color(0xff1a4678),
      bottom: TabBar(
          indicatorColor: Colors.white,
          tabs: <Tab>[
            Tab(
              text: "Posted",
            ),
            Tab(
              text: "Scraped",
            ),
            Tab(
              text: "Liked",
            )
          ],
          controller: myPageController.tabController),
      flexibleSpace: FlexibleSpaceBar(
        // title: Text('${myPageController.myProfile.value.PROFILE_NICKNAME}'),
        background: Obx(() {
          return Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  width: 87,
                  height: 87,
                  margin: EdgeInsets.only(top: 22.5),
                  child: CachedNetworkImage(
                      imageUrl:
                          '${myPageController.myProfile.value.PROFILE_PHOTO}',
                      placeholder: (context, url) => Container(
                            width: 87,
                            height: 87,
                            decoration: BoxDecoration(
                              color: const Color(0xff194678),
                              shape: BoxShape.circle,
                            ),
                          ),
                      imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fill))),
                      errorWidget: (context, url, error) {
                        print(error);
                        return Icon(Icons.error);
                      })),
              Container(
                  height: 28,
                  margin: EdgeInsets.only(top: 6),
                  child: Text(
                      '${myPageController.myProfile.value.PROFILE_NICKNAME}',
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 21.0),
                      textAlign: TextAlign.left)),
              Container(
                  margin: EdgeInsets.only(top: 3.5),
                  height: 18.5,
                  child: Text(
                      "${myPageController.myProfile.value.PROFILE_MESSAGE}，${myPageController.myProfile.value.PROFILE_SCHOOL}",
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w400,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left)),
              Container(
                  height: 31,
                  margin: EdgeInsets.only(top: 29.5, bottom: 30),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () async {
                              await Get.toNamed('/myPage/profile');
                            },
                            child: Container(
                                height: 31,
                                width: 98,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(31)),
                                    border: Border.all(
                                        color: const Color(0xffffffff),
                                        width: 2)),
                                child: Row(children: [
                                  Container(
                                      margin: EdgeInsets.only(left: 17.2),
                                      width: 11.8406982421875,
                                      height: 13.6337890625,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/931.png")))),
                                  Container(
                                      margin: EdgeInsets.only(left: 9),
                                      child: Text("Profile",
                                          style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "PingFangSC",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.left))
                                ]))),
                        InkWell(
                            onTap: () async {
                              // await Get.toNamed('/mail');
                            },
                            child: Container(
                                height: 31,
                                width: 98,
                                margin: EdgeInsets.only(left: 46.5),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(31)),
                                    border: Border.all(
                                        color: const Color(0xffffffff),
                                        width: 2)),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 17.2),
                                          width: 11.8406982421875,
                                          height: 13.6337890625,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/601.png")))),
                                      Container(
                                          margin: EdgeInsets.only(left: 9),
                                          child: Text("Setting",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xffffffff),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "PingFangSC",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.left))
                                    ])))
                      ]))
            ]),
          );
        }),
      ),
    );
  }
}

class MyPageProfilePostIndex extends StatelessWidget {
  const MyPageProfilePostIndex({
    Key key,
    @required this.myPageController,
  }) : super(key: key);

  final MyPageController myPageController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Ink(
            child: InkWell(
              onTap: () {
                myPageController.profilePostIndex.value = 0;
                myPageController.pageController.jumpToPage(0);

                // myPageController.pageController.animateToPage(0,
                //     duration: Duration(milliseconds: 300),
                //     curve: Curves.fastOutSlowIn);
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 14),
                        child: Text("Posted",
                            style: TextStyle(
                                color:
                                    myPageController.profilePostIndex.value == 0
                                        ? Color(0xff1a4678)
                                        : Color(0xff666666),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0),
                            textAlign: TextAlign.left)),
                    Container(
                        margin: EdgeInsets.only(top: 14),
                        width: 46.5,
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: myPageController.profilePostIndex.value == 0
                              ? Color(0xff1a4678)
                              : Color(0xffffffff),
                        ))
                  ]),
            ),
          ),
          Ink(
            child: InkWell(
              onTap: () {
                myPageController.profilePostIndex.value = 1;
                myPageController.pageController.jumpToPage(1);

                // myPageController.pageController.animateToPage(1,
                //     duration: Duration(milliseconds: 300),
                //     curve: Curves.fastOutSlowIn);
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 68.5, top: 14),
                        child: Text("Scraped",
                            style: TextStyle(
                                color:
                                    myPageController.profilePostIndex.value == 1
                                        ? Color(0xff1a4678)
                                        : Color(0xff666666),
                                fontWeight: FontWeight.w700,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0),
                            textAlign: TextAlign.left)),
                    Container(
                        margin: EdgeInsets.only(left: 68.5, top: 14),
                        width: 46.5,
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: myPageController.profilePostIndex.value == 1
                              ? Color(0xff1a4678)
                              : Color(0xffffffff),
                        ))
                  ]),
            ),
          ),
          Ink(
            child: InkWell(
              onTap: () {
                myPageController.profilePostIndex.value = 2;
                myPageController.pageController.jumpToPage(2);

                // myPageController.pageController.animateToPage(2,
                //     duration: Duration(milliseconds: 300),
                //     curve: Curves.fastOutSlowIn);
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 71, top: 14),
                        child: Text("Liked",
                            style: TextStyle(
                                color:
                                    myPageController.profilePostIndex.value == 2
                                        ? Color(0xff1a4678)
                                        : Color(0xff666666),
                                fontWeight: FontWeight.w700,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0),
                            textAlign: TextAlign.left)),
                    Container(
                        margin: EdgeInsets.only(left: 71, top: 14),
                        width: 46.5,
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: myPageController.profilePostIndex.value == 2
                              ? Color(0xff1a4678)
                              : Color(0xffffffff),
                        ))
                  ]),
            ),
          )
        ],
      ));
    });
  }
}

class ProfileIndex extends StatelessWidget {
  const ProfileIndex({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(
          flex: 10,
        ),
        Expanded(
            flex: 80,
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Text(
                  "profile",
                  textScaleFactor: 0.8,
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () async {
                await Get.toNamed('/myPage/profile');
              },
            )),
        Spacer(
          flex: 8,
        ),
        Expanded(
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Text(
                "Mail",
                textScaleFactor: 0.8,
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () async {
              await Get.toNamed('/mail');
            },
          ),
          flex: 80,
        ),
        Spacer(
          flex: 8,
        ),
        Expanded(
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Text(
                "쪽지함",
                textScaleFactor: 0.8,
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () async {
              Get.toNamed("/mail");
            },
          ),
          flex: 80,
        ),
        Spacer(
          flex: 94,
        )
      ],
    );
  }
}

// Widget getPosts(MyPageBoardModel item, myPageController) {
//   String communityBoardName(int COMMUNITY_ID) {
//     final box = GetStorage();
//     var boardList = box.read('boardInfo');
//     for (var item in boardList) {
//       if (item.COMMUNITY_ID == COMMUNITY_ID) {
//         return item.COMMUNITY_NAME;
//       }
//     }
//     return null;
//   }

//   String boardName(int COMMUNITY_ID) {
//     return communityBoardName(COMMUNITY_ID);
//   }

//   return InkWell(
//     onTap: () async {
//       String url = item.COMMUNITY_ID < 4
//           ? "/outside/${item.COMMUNITY_ID}/read/${item.BOARD_ID}"
//           : "/board/${item.COMMUNITY_ID}/read/${item.BOARD_ID}";

//       Get.toNamed(url);
//     },
//     child: Container(
//       decoration: BoxDecoration(
//           border: Border(bottom: BorderSide(color: Colors.black54))),
//       child: Row(
//         children: [
//           Spacer(
//             flex: 6,
//           ),
//           Expanded(
//               flex: 40,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Spacer(
//                     flex: 7,
//                   ),
//                   Expanded(
//                       flex: 20,
//                       child: CachedNetworkImage(
//                           imageUrl: '${item.PROFILE_PHOTO}',
//                           fadeInDuration: Duration(milliseconds: 0),
//                           progressIndicatorBuilder:
//                               (context, url, downloadProgress) => Image(
//                                   image:
//                                       AssetImage('assets/images/spinner.gif')),
//                           errorWidget: (context, url, error) {
//                             print(error);
//                             return Icon(Icons.error);
//                           })),
//                   Spacer(
//                     flex: 5,
//                   ),
//                   Expanded(
//                     flex: 9,
//                     child: Text(
//                       "${item.PROFILE_NICKNAME}",
//                       textScaleFactor: 0.8,
//                     ),
//                   ),
//                   Expanded(
//                     flex: 9,
//                     child: Text(
//                       '${boardName(item.COMMUNITY_ID)} 게시판',
//                       textScaleFactor: 0.5,
//                     ),
//                   ),
//                   Spacer(
//                     flex: 8,
//                   )
//                 ],
//               )),
//           Spacer(
//             flex: 10,
//           ),
//           Expanded(
//               flex: 200,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Spacer(
//                     flex: 11,
//                   ),
//                   Expanded(
//                       flex: 18,
//                       child: Text(
//                         item.TITLE.toString(),
//                         textScaleFactor: 1.5,
//                       )),
//                   Spacer(
//                     flex: 11,
//                   ),
//                   Expanded(
//                       flex: 12,
//                       child: Text(
//                         item.CONTENT.toString(),
//                         textScaleFactor: 1.0,
//                       )),
//                   Spacer(
//                     flex: 7,
//                   )
//                 ],
//               )),
//           item.PHOTO == "" || item.PHOTO == null //빈 문자열 처리해야함
//               ? Expanded(
//                   flex: 80,
//                   child: Column(children: [
//                     Spacer(
//                       flex: 40,
//                     ),
//                     Expanded(
//                       child: Text(
//                         "좋아요${item.LIKES} 댓글${item.COMMENTS} 스크랩${item.SCRAPS}",
//                         textScaleFactor: 0.5,
//                       ),
//                       flex: 9,
//                     )
//                   ]))
//               : Expanded(
//                   flex: 80,
//                   child: Column(children: [
//                     Expanded(
//                       flex: 40,
//                       child: item.PHOTO.length == 0 || item.PHOTO == null
//                           ? Container()
//                           : CachedNetworkImage(
//                               imageUrl: '${item.PHOTO[0]}',
//                               fit: BoxFit.fill,
//                               fadeInDuration: Duration(milliseconds: 0),
//                               progressIndicatorBuilder:
//                                   (context, url, downloadProgress) => Image(
//                                       image: AssetImage(
//                                           'assets/images/spinner.gif')),
//                               errorWidget: (context, url, error) {
//                                 print(error);
//                                 return Icon(Icons.error);
//                               }),
//                     ),
//                     Expanded(
//                       child: Text(
//                         "좋아요${item.LIKES} 댓글${item.COMMENTS} 스크랩${item.SCRAPS}",
//                         textScaleFactor: 0.5,
//                       ),
//                       flex: 9,
//                     )
//                   ])),
//           Spacer(
//             flex: 4,
//           )
//         ],
//       ),
//     ),
//   );
// }
