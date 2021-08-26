import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/data/model/profile/mypage_model.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';

class Mypage extends StatelessWidget {
  final MyPageController myPageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(
            pageName: "마이 페이지",
          ),
          body: RefreshIndicator(
            onRefresh: myPageController.getRefresh,
            child: Stack(
              children: [
                ListView(),
                Obx(
                  () {
                    if (myPageController.dataAvailableMypage) {
                      return Column(
                        children: [
                          Spacer(
                            flex: 10,
                          ),
                          Expanded(
                            flex: 80,
                            child: MyPageProfile(
                                myPageController: myPageController),
                          ),
                          Spacer(
                            flex: 18,
                          ),
                          Expanded(flex: 24, child: ProfileIndex()),
                          Spacer(
                            flex: 26,
                          ),
                          Expanded(
                            flex: 16,
                            child: MyPageProfilePostIndex(
                                myPageController: myPageController),
                          ),
                          Spacer(
                            flex: 4,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.purple,
                            ),
                          ),
                          Expanded(
                              flex: 412,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Obx(() {
                                    List<bool> dataAvailable = [
                                      myPageController.dataAvailableMypageWrite,
                                      myPageController.dataAvailableMypageLike,
                                      myPageController.dataAvailableMypageScrap
                                    ];

                                    List<RxList<MyPageBoardModel>> userPost = [
                                      myPageController.myBoardWrite,
                                      myPageController.myBoardLike,
                                      myPageController.myBoardScrap,
                                    ];

                                    if (dataAvailable[myPageController
                                        .profilePostIndex.value]) {
                                      return Column(
                                        children: [
                                          for (var i = 0;
                                              i <
                                                  userPost[myPageController
                                                          .profilePostIndex
                                                          .value]
                                                      .length;
                                              i++)
                                            Container(
                                                height: 120,
                                                child: getPosts(
                                                    userPost[myPageController
                                                        .profilePostIndex
                                                        .value][i],
                                                    myPageController))
                                        ],
                                      );
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  })))
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )
              ],
            ),
          )),
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
      return Row(
        children: [
          Spacer(
            flex: 27,
          ),
          Expanded(
            flex: 61,
            child: InkWell(
              child: Text(
                "내가 쓴 글",
                textScaleFactor: 0.8,
                style: TextStyle(
                    color: myPageController.profilePostIndex.value == 0
                        ? Colors.red[700]
                        : Colors.black),
              ),
              onTap: () {
                myPageController.profilePostIndex.value = 0;
              },
            ),
          ),
          Spacer(
            flex: 63,
          ),
          Expanded(
            flex: 70,
            child: InkWell(
              child: Text("좋아요 누른 글",
                  textScaleFactor: 0.8,
                  style: TextStyle(
                      color: myPageController.profilePostIndex.value == 1
                          ? Colors.red[700]
                          : Colors.black)),
              onTap: () {
                myPageController.profilePostIndex.value = 1;
              },
            ),
          ),
          Spacer(
            flex: 45,
          ),
          Expanded(
            flex: 54,
            child: InkWell(
              child: Text("저장한 글",
                  textScaleFactor: 0.8,
                  style: TextStyle(
                      color: myPageController.profilePostIndex.value == 2
                          ? Colors.red[700]
                          : Colors.black)),
              onTap: () {
                myPageController.profilePostIndex.value = 2;
              },
            ),
          ),
          Spacer(
            flex: 40,
          )
        ],
      );
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
                "setting",
                textScaleFactor: 0.8,
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () => {print("text")},
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

class MyPageProfile extends StatelessWidget {
  const MyPageProfile({
    Key key,
    @required this.myPageController,
  }) : super(key: key);

  final MyPageController myPageController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Spacer(
            flex: 10,
          ),
          Expanded(
            flex: 80,
            child: InkWell(
                onTap: () {
                  Get.toNamed('/myPage/profile');
                },
                child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    child: CachedNetworkImage(
                        imageUrl:
                            'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/${myPageController.myProfile.value.PROFILE_PHOTO}',
                        fadeInDuration: Duration(milliseconds: 0),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                Image(image: AssetImage('image/spinner.gif')),
                        errorWidget: (context, url, error) {
                          print(error);
                          return Icon(Icons.error);
                        }))),
          ),
          Spacer(
            flex: 20,
          ),
          Expanded(
            flex: 250,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Spacer(flex: 12),
              Expanded(
                  flex: 20,
                  child: Text(
                    '닉네임 : ${myPageController.myProfile.value.PROFILE_NICKNAME}',
                    textScaleFactor: 0.7,
                  )),
              Spacer(
                flex: 2,
              ),
              Expanded(
                  flex: 12,
                  child: Text(
                    '프로필 메시지 : ${myPageController.myProfile.value.PROFILE_MESSAGE}',
                    textScaleFactor: 0.7,
                  )),
              Spacer(
                flex: 2,
              ),
              Expanded(
                  flex: 12,
                  child: Text(
                    '학교 : ${myPageController.myProfile.value.PROFILE_SCHOOL}',
                    textScaleFactor: 0.8,
                  )),
              Spacer(
                flex: 8,
              )
            ]),
          )
        ],
      );
    });
  }
}

Widget getPosts(MyPageBoardModel item, myPageController) {
  String communityBoardName(int COMMUNITY_ID) {
    final box = GetStorage();
    var boardList = box.read('boardInfo');
    for (var item in boardList) {
      if (item.COMMUNITY_ID == COMMUNITY_ID) {
        return item.COMMUNITY_NAME;
      }
    }
    return null;
  }

  String boardName(int COMMUNITY_ID) {
    return communityBoardName(COMMUNITY_ID);
  }

  return InkWell(
    onTap: () async {
      String url = item.COMMUNITY_ID < 4
          ? "/outside/${item.COMMUNITY_ID}/read/${item.BOARD_ID}"
          : "/board/${item.COMMUNITY_ID}/read/${item.BOARD_ID}";

      Get.toNamed(url);
    },
    child: Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black54))),
      child: Row(
        children: [
          Spacer(
            flex: 6,
          ),
          Expanded(
              flex: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(
                    flex: 7,
                  ),
                  Expanded(
                      flex: 20,
                      child: CachedNetworkImage(
                          imageUrl:
                              'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/${item.PROFILE_PHOTO}',
                          fadeInDuration: Duration(milliseconds: 0),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  Image(image: AssetImage('image/spinner.gif')),
                          errorWidget: (context, url, error) {
                            print(error);
                            return Icon(Icons.error);
                          })),
                  Spacer(
                    flex: 5,
                  ),
                  Expanded(
                    flex: 9,
                    child: Text(
                      "${item.PROFILE_NICKNAME}",
                      textScaleFactor: 0.8,
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text(
                      '${boardName(item.COMMUNITY_ID)} 게시판',
                      textScaleFactor: 0.5,
                    ),
                  ),
                  Spacer(
                    flex: 8,
                  )
                ],
              )),
          Spacer(
            flex: 10,
          ),
          Expanded(
              flex: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(
                    flex: 11,
                  ),
                  Expanded(
                      flex: 18,
                      child: Text(
                        item.TITLE.toString(),
                        textScaleFactor: 1.5,
                      )),
                  Spacer(
                    flex: 11,
                  ),
                  Expanded(
                      flex: 12,
                      child: Text(
                        item.CONTENT.toString(),
                        textScaleFactor: 1.0,
                      )),
                  Spacer(
                    flex: 7,
                  )
                ],
              )),
          item.PHOTO == "" || item.PHOTO == null //빈 문자열 처리해야함
              ? Expanded(
                  flex: 80,
                  child: Column(children: [
                    Spacer(
                      flex: 40,
                    ),
                    Expanded(
                      child: Text(
                        "좋아요${item.LIKES} 댓글${item.COMMENTS} 스크랩${item.SCRAPS}",
                        textScaleFactor: 0.5,
                      ),
                      flex: 9,
                    )
                  ]))
              : Expanded(
                  flex: 80,
                  child: Column(children: [
                    Expanded(
                      flex: 40,
                      child: CachedNetworkImage(
                          imageUrl:
                              'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/board/${item.PHOTO}',
                          fadeInDuration: Duration(milliseconds: 0),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  Image(image: AssetImage('image/spinner.gif')),
                          errorWidget: (context, url, error) {
                            print(error);
                            return Icon(Icons.error);
                          }),
                    ),
                    Expanded(
                      child: Text(
                        "좋아요${item.LIKES} 댓글${item.COMMENTS} 스크랩${item.SCRAPS}",
                        textScaleFactor: 0.5,
                      ),
                      flex: 9,
                    )
                  ])),
          Spacer(
            flex: 4,
          )
        ],
      ),
    ),
  );
}
