import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/init_page/init_controller.dart';

import 'package:polarstar_flutter/app/modules/login_page/login_controller.dart';

import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/mypage/mypage_controller.dart';

import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/modules/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/global_widgets/dialoge.dart';
import 'package:polarstar_flutter/main.dart';

const mainColor = 0xff4570ff;

class Mypage extends StatelessWidget {
  final MyPageController myPageController = Get.find();
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(Get.theme.primaryColor, Brightness.light);
    return SafeArea(
      top: false,
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            toolbarHeight: 0.0,
            elevation: 0.0,
          ),
          body: Obx(
            () {
              if (myPageController.dataAvailableMypage) {
                return NestedScrollView(
                  controller: myPageController.scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [MyPageProfile(myPageController: myPageController)];
                  },
                  body: Container(
                    margin: const EdgeInsets.only(top: 14),
                    child: TabBarView(
                        controller: myPageController.tabController,
                        children: [
                          MyPagePostList(
                              mainController: mainController,
                              myPageController: myPageController,
                              index: 0,
                              postList: myPageController.myBoardWrite),
                          MyPagePostList(
                              mainController: mainController,
                              myPageController: myPageController,
                              index: 1,
                              postList: myPageController.myBoardLike),
                          MyPagePostList(
                              mainController: mainController,
                              myPageController: myPageController,
                              index: 2,
                              postList: myPageController.myBoardScrap),
                        ]),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }
}

class MyPagePostList extends StatelessWidget {
  const MyPagePostList(
      {Key key,
      @required this.myPageController,
      @required this.mainController,
      @required this.index,
      @required this.postList})
      : super(key: key);

  final MyPageController myPageController;
  final MainController mainController;
  final int index;
  final RxList<Rx<Post>> postList;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => MainUpdateModule.updateMyPage(index),
      child: Obx(() {
        if (postList.length == 0) {
          return Stack(children: [
            ListView(),
            Center(
              // * 아직 정보가 없습니다.
              child: Text("目前没有相关帖子"),
            ),
          ]);
        } else {
          return ListView.builder(
              cacheExtent: 10,
              itemCount: myPageController.curPage == myPageController.MaxPage
                  ? postList.length
                  : postList.length + 1,
              itemBuilder: (BuildContext context, int i) {
                if (i >= postList.length) {
                  Timer(Duration(seconds: 1), () {
                    myPageController.setMaxPageEqualCurPage();
                  });
                  return Center(
                    child: CircularProgressIndicator(
                      color: Get.theme.primaryColor,
                    ),
                  );
                }

                postList[i].value.MYSELF = true;
                print(i);
                print(postList.length);
                print(i >= postList.length);
                return Container(
                  margin: const EdgeInsets.only(bottom: 5), //자체 패딩 10 + 5 = 15
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          '/board/${postList[i].value.COMMUNITY_ID}/read/${postList[i].value.BOARD_ID}',
                        ).then((value) {
                          MainUpdateModule.updateMyPage(index);
                        });
                      },
                      child: PostWidget(
                        index: index,
                        mainController: mainController,
                        item: postList[i],
                      ),
                    ),
                  ),
                );
              });
        }
      }),
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
      automaticallyImplyLeading: false,
      expandedHeight: 56 + 254.0,
      backgroundColor: Get.theme.primaryColor,
      bottom: MenuTabBar(
        myPageController: myPageController,
        tabBar: TabBar(
            labelStyle: const TextStyle(
                color: const Color(0xff9b75ff),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSansSC",
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
            indicatorColor: Colors.white,
            tabs: <Tab>[
              Tab(
                text: "发帖",
              ),
              Tab(
                text: "赞过",
              ),
              Tab(
                text: "收藏",
              )
            ],
            controller: myPageController.tabController),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Obx(() {
          return Container(
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20))),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 11.0),
                child: Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        //! 번역 필요
                        Function onTapConfirm = () async {
                          LoginController loginController = Get.find();
                          loginController.logout();
                          InitController initController = Get.find();
                          initController.dispose();

                          await Get.offAllNamed('/login');
                          // initController.mainPageIndex.value = 0;
                        };
                        Function onTapCancel = () async {
                          Get.back();
                        };
                        await TFdialogue(context, "想要退出账号登陆吗？", "想要退出账号登陆吗？",
                            onTapConfirm, onTapCancel);

                        //   // actions: [
                        //   //   TextButton(
                        //   //       onPressed: () async {
                        //   //         LoginController loginController = Get.find();
                        //   //         loginController.logout();
                        //   //         InitController initController = Get.find();
                        //   //         initController.dispose();

                        //   //         await Get.offAllNamed('/login');
                        //   //         // initController.mainPageIndex.value = 0;
                        //   //       },
                        //   //       child: Text("YES")),
                        //   //   TextButton(
                        //   //       onPressed: () {
                        //   //         Get.back();
                        //   //       },
                        //   //       child: Text("NO"))
                        //   // ],
                        // );
                      },
                      child: Ink(
                        padding: const EdgeInsets.all(14.0),
                        child: Container(
                          child: Icon(
                            Icons.logout,
                            color: const Color(0xffffffff),
                            size: 24,
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: 80,
                  height: 80,
                  child: CachedNetworkImage(
                      imageUrl:
                          '${myPageController.myProfile.value.PROFILE_PHOTO}',
                      width: 80,
                      height: 80,
                      placeholder: (context, url) => Container(
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
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                      '${myPageController.myProfile.value.PROFILE_NICKNAME}',
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left)),
              Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Text(
                      //"${myPageController.myProfile.value.PROFILE_MESSAGE}，${myPageController.myProfile.value.PROFILE_SCHOOL}",
                      "",
                      style: const TextStyle(
                          color: const Color(0xff9b75ff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0),
                      textAlign: TextAlign.left)),
              Container(
                  height: 30,
                  margin: EdgeInsets.only(top: 14, bottom: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () async {
                              await Get.toNamed(Routes.MYPROFILE);
                            },
                            child: Container(
                                height: 30,
                                width: 90,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(
                                        color: const Color(0xffffffff),
                                        width: 1),
                                    color: Get.theme.primaryColor),
                                child: Center(
                                  child: Text("个人资料",
                                      style: const TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "NotoSansSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left),
                                ))),
                        Container(width: 8),
                        InkWell(
                            onTap: () async {
                              await Get.toNamed(Routes.SETTING);
                            },
                            child: Container(
                                height: 30,
                                width: 90,
                                //margin: EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(
                                        color: const Color(0xffffffff),
                                        width: 1),
                                    color: Get.theme.primaryColor),
                                child: Center(
                                  child: Text("隐私",
                                      style: const TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "NotoSansSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left),
                                )))
                      ]))
            ]),
          );
        }),
      ),
    );
  }
}

class MenuTabBar extends Container implements PreferredSizeWidget {
  MenuTabBar({this.myPageController, this.tabBar});

  final MyPageController myPageController;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.primaryColor,
      child: tabBar,
    );
  }
}

// class MyPageProfilePostIndex extends StatelessWidget {
//   const MyPageProfilePostIndex({
//     Key key,
//     @required this.myPageController,
//   }) : super(key: key);

//   final MyPageController myPageController;

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Container(
//           child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Ink(
//             child: InkWell(
//               onTap: () {
//                 myPageController.profilePostIndex.value = 0;
//                 myPageController.pageController.jumpToPage(0);

//                 // myPageController.pageController.animateToPage(0,
//                 //     duration: Duration(milliseconds: 300),
//                 //     curve: Curves.fastOutSlowIn);
//               },
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                         margin: EdgeInsets.only(top: 14),
//                         child: Text("Posted",
//                             style: TextStyle(
//                                 color:
//                                     myPageController.profilePostIndex.value == 0
//                                         ? Color(0xff1a4678)
//                                         : Color(0xff666666),
//                                 fontWeight: FontWeight.w700,
//                                 fontStyle: FontStyle.normal,
//                                 fontSize: 18.0),
//                             textAlign: TextAlign.left)),
//                     Container(
//                         margin: EdgeInsets.only(top: 14),
//                         width: 46.5,
//                         height: 3,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(3)),
//                           color: myPageController.profilePostIndex.value == 0
//                               ? Color(0xff1a4678)
//                               : Color(0xffffffff),
//                         ))
//                   ]),
//             ),
//           ),
//           Ink(
//             child: InkWell(
//               onTap: () {
//                 myPageController.profilePostIndex.value = 1;
//                 myPageController.pageController.jumpToPage(1);

//                 // myPageController.pageController.animateToPage(1,
//                 //     duration: Duration(milliseconds: 300),
//                 //     curve: Curves.fastOutSlowIn);
//               },
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                         margin: EdgeInsets.only(left: 68.5, top: 14),
//                         child: Text("Scraped",
//                             style: TextStyle(
//                                 color:
//                                     myPageController.profilePostIndex.value == 1
//                                         ? Color(0xff1a4678)
//                                         : Color(0xff666666),
//                                 fontWeight: FontWeight.w700,
//                                 fontFamily: "PingFangSC",
//                                 fontStyle: FontStyle.normal,
//                                 fontSize: 18.0),
//                             textAlign: TextAlign.left)),
//                     Container(
//                         margin: EdgeInsets.only(left: 68.5, top: 14),
//                         width: 46.5,
//                         height: 3,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(3)),
//                           color: myPageController.profilePostIndex.value == 1
//                               ? Color(0xff1a4678)
//                               : Color(0xffffffff),
//                         ))
//                   ]),
//             ),
//           ),
//           Ink(
//             child: InkWell(
//               onTap: () {
//                 myPageController.profilePostIndex.value = 2;
//                 myPageController.pageController.jumpToPage(2);

//                 // myPageController.pageController.animateToPage(2,
//                 //     duration: Duration(milliseconds: 300),
//                 //     curve: Curves.fastOutSlowIn);
//               },
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                         margin: EdgeInsets.only(left: 71, top: 14),
//                         child: Text("Liked",
//                             style: TextStyle(
//                                 color:
//                                     myPageController.profilePostIndex.value == 2
//                                         ? Color(0xff1a4678)
//                                         : Color(0xff666666),
//                                 fontWeight: FontWeight.w700,
//                                 fontFamily: "PingFangSC",
//                                 fontStyle: FontStyle.normal,
//                                 fontSize: 18.0),
//                             textAlign: TextAlign.left)),
//                     Container(
//                         margin: EdgeInsets.only(left: 71, top: 14),
//                         width: 46.5,
//                         height: 3,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(3)),
//                           color: myPageController.profilePostIndex.value == 2
//                               ? Color(0xff1a4678)
//                               : Color(0xffffffff),
//                         ))
//                   ]),
//             ),
//           )
//         ],
//       ));
//     });
//   }
// }

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