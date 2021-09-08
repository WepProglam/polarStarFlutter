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
          body: RefreshIndicator(
        onRefresh: myPageController.getRefresh,
        child: Stack(
          children: [
            ListView(),
            Obx(
              () {
                if (myPageController.dataAvailableMypage) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/279.png'),
                                  fit: BoxFit.none)),
                          child: MyPageProfile(
                              myPageController: myPageController)),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          decoration:
                              BoxDecoration(color: const Color(0xffffffff)),
                          child: MyPageProfilePostIndex(
                              myPageController: myPageController)),
                      Expanded(
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

                                if (dataAvailable[
                                    myPageController.profilePostIndex.value]) {
                                  return Column(
                                    children: [
                                      for (var i = 0;
                                          i <
                                              userPost[myPageController
                                                      .profilePostIndex.value]
                                                  .length;
                                          i++)
                                        Container(
                                            height: 120,
                                            child: getPosts(
                                                userPost[myPageController
                                                    .profilePostIndex.value][i],
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
      return Column(children: [
        Container(
            height: 58,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 14),
                            child: Text("Posted",
                                style: TextStyle(
                                    color: myPageController
                                                .profilePostIndex.value ==
                                            0
                                        ? Color(0xff1a4678)
                                        : Color(0xff666666),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0),
                                textAlign: TextAlign.left)),
                        Container(
                            margin: EdgeInsets.only(top: 14),
                            width: 46.5,
                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              color:
                                  myPageController.profilePostIndex.value == 0
                                      ? Color(0xff1a4678)
                                      : Color(0xffffffff),
                            ))
                      ]),
                  onTap: () {
                    myPageController.profilePostIndex.value = 0;
                  },
                ),
                InkWell(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 68.5, top: 14),
                            child: Text("Replied",
                                style: TextStyle(
                                    color: myPageController
                                                .profilePostIndex.value ==
                                            1
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              color:
                                  myPageController.profilePostIndex.value == 1
                                      ? Color(0xff1a4678)
                                      : Color(0xffffffff),
                            ))
                      ]),
                  onTap: () {
                    myPageController.profilePostIndex.value = 1;
                  },
                ),
                InkWell(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 71, top: 14),
                            child: Text("Favorite",
                                style: TextStyle(
                                    color: myPageController
                                                .profilePostIndex.value ==
                                            2
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              color:
                                  myPageController.profilePostIndex.value == 2
                                      ? Color(0xff1a4678)
                                      : Color(0xffffffff),
                            ))
                      ]),
                  onTap: () {
                    myPageController.profilePostIndex.value = 2;
                  },
                )
              ],
            )),
      ]);
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
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            width: 87,
            height: 87,
            margin: EdgeInsets.only(top: 22.5),
            child: CachedNetworkImage(
                imageUrl:
                    'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/${myPageController.myProfile.value.PROFILE_PHOTO}',
                imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill))),
                fadeInDuration: Duration(milliseconds: 0),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Image(image: AssetImage('assets/images/spinner.gif')),
                errorWidget: (context, url, error) {
                  print(error);
                  return Icon(Icons.error);
                })),
        Container(
            height: 28,
            margin: EdgeInsets.only(top: 6),
            child: Text('${myPageController.myProfile.value.PROFILE_NICKNAME}',
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                  onTap: () async {
                    await Get.toNamed('/myPage/profile');
                  },
                  child: Container(
                      height: 31,
                      width: 98,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(31)),
                          border: Border.all(
                              color: const Color(0xffffffff), width: 2)),
                      child: Row(children: [
                        Container(
                            margin: EdgeInsets.only(left: 17.2),
                            width: 11.8406982421875,
                            height: 13.6337890625,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/931.png")))),
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
                  onTap: () => {print("text")},
                  child: Container(
                      height: 31,
                      width: 98,
                      margin: EdgeInsets.only(left: 46.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(31)),
                          border: Border.all(
                              color: const Color(0xffffffff), width: 2)),
                      child: Row(children: [
                        Container(
                            margin: EdgeInsets.only(left: 17.2),
                            width: 11.8406982421875,
                            height: 13.6337890625,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/601.png")))),
                        Container(
                            margin: EdgeInsets.only(left: 9),
                            child: Text("Setting",
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left))
                      ])))
            ]))
      ]);
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
                              (context, url, downloadProgress) => Image(
                                  image:
                                      AssetImage('assets/images/spinner.gif')),
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
                      child: item.PHOTO.length == 0 || item.PHOTO == null
                          ? Container()
                          : CachedNetworkImage(
                              imageUrl:
                                  'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/board/${item.PHOTO[0]}',
                              fit: BoxFit.fill,
                              fadeInDuration: Duration(milliseconds: 0),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Image(
                                      image: AssetImage(
                                          'assets/images/spinner.gif')),
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
