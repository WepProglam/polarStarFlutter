import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

class Profile extends StatelessWidget {
  final MyPageController myPageController = Get.find();

  final ImagePicker _picker = ImagePicker();

  final nicknameController = TextEditingController();

  final profilemessageController = TextEditingController();

  final box = GetStorage();

  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: AppBars().profileAppBar(),
          body: RefreshIndicator(
            onRefresh: myPageController.getMineWrite,
            child: Stack(
              children: [
                ListView(),
                Obx(
                  () {
                    if (myPageController.dataAvailableMypage) {
                      return Column(children: [
                        Container(
                            height: 207,
                            child: Stack(children: [
                              Container(
                                  height: 207,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: const Color(0xff4570ff))),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                      height: 80,
                                      width: 80,
                                      margin: EdgeInsets.only(top: 72),
                                      decoration: BoxDecoration(
                                          color: const Color(0xff4570ff)),
                                      child: InkWell(
                                        onTap: () async {
                                          await myPageController
                                              .getMultipleGallertImage(context);
                                          await myPageController.upload();
                                        },
                                        child: CachedNetworkImage(
                                            imageUrl:
                                                '${myPageController.myProfile.value.PROFILE_PHOTO}',
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.fill))),
                                            fadeInDuration:
                                                Duration(milliseconds: 0),
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Image(
                                                    image: AssetImage(
                                                        'assets/images/spinner.gif')),
                                            errorWidget: (context, url, error) {
                                              print(error);
                                              return Icon(Icons.error);
                                            }),
                                      ))),
                              Align(
                                alignment: Alignment.topCenter,
                                child: InkWell(
                                  onTap: () async {
                                    await myPageController
                                        .getMultipleGallertImage(context);
                                    await myPageController.upload();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 132, left: 62),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xffffffff)),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 137.7, left: 67.1, right: 4),
                                  child: Ink(
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    width: 9.8,
                                    height: 8.7,
                                    child: InkWell(
                                      onTap: () async {
                                        await myPageController
                                            .getMultipleGallertImage(context);
                                        await myPageController.upload();
                                      },
                                      child: Image.asset(
                                          "assets/images/camera.png"),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    margin: EdgeInsets.only(top: 164),
                                    height: 19,
                                    child: // Userd
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                          Text(
                                              '${myPageController.myProfile.value.PROFILE_NICKNAME}',
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xffffffff),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0),
                                              textAlign: TextAlign.center),
                                          // ! 닉네임 수정 불가
                                          // Container(
                                          //     margin: EdgeInsets.only(
                                          //         left: 4, top: 4),
                                          //     width: 8.9,
                                          //     height: 8.5,
                                          //     child: InkWell(
                                          //         onTap: () async {
                                          //           NicknameDialog(context,
                                          //               myPageController);
                                          //         },
                                          //         child: Image.asset(
                                          //             "assets/images/edit_3.png")))
                                        ])),
                              )
                            ])),
                        Container(
                            height: 10,
                            decoration:
                                BoxDecoration(color: const Color(0xfff6f6f6))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(top: 34.5),
                                child: Column(
                                  children: [
                                    // Container(
                                    //     height: 54.6,
                                    //     width: MediaQuery.of(context).size.width,
                                    //     decoration: BoxDecoration(
                                    //         border: Border(
                                    //             bottom: BorderSide(
                                    //                 color: const Color(0xffdedede),
                                    //                 width: 1))),
                                    //     child: Stack(children: [
                                    //       Align(
                                    //           alignment: Alignment.centerLeft,
                                    //           child: Container(
                                    //               margin: EdgeInsets.only(left: 15),
                                    //               child: Text("Name",
                                    //                   style: const TextStyle(
                                    //                       color:
                                    //                           const Color(0xff333333),
                                    //                       fontWeight: FontWeight.w400,
                                    //                       fontFamily: "PingFangSC",
                                    //                       fontStyle: FontStyle.normal,
                                    //                       fontSize: 16.0),
                                    //                   textAlign: TextAlign.left))),
                                    //       Align(
                                    //           alignment: Alignment.centerRight,
                                    //           child: Container(
                                    //               margin: EdgeInsets.only(right: 18),
                                    //               child: Text("Li Ming",
                                    //                   style: const TextStyle(
                                    //                       color:
                                    //                           const Color(0xff666666),
                                    //                       fontWeight: FontWeight.w400,
                                    //                       fontFamily: "PingFangSC",
                                    //                       fontStyle: FontStyle.normal,
                                    //                       fontSize: 16.0),
                                    //                   textAlign: TextAlign.left)))
                                    //     ])),
                                    // Container(
                                    //     height: 54.6,
                                    //     width: MediaQuery.of(context).size.width,
                                    //     decoration: BoxDecoration(
                                    //         border: Border(
                                    //             bottom: BorderSide(
                                    //                 color: const Color(0xffdedede),
                                    //                 width: 1))),
                                    //     child: Stack(children: [
                                    //       Align(
                                    //           alignment: Alignment.centerLeft,
                                    //           child: Container(
                                    //               margin: EdgeInsets.only(left: 15),
                                    //               child: Text("University",
                                    //                   style: const TextStyle(
                                    //                       color:
                                    //                           const Color(0xff333333),
                                    //                       fontWeight: FontWeight.w400,
                                    //                       fontFamily: "PingFangSC",
                                    //                       fontStyle: FontStyle.normal,
                                    //                       fontSize: 16.0),
                                    //                   textAlign: TextAlign.left))),
                                    //       Align(
                                    //           alignment: Alignment.centerRight,
                                    //           child: Container(
                                    //               margin: EdgeInsets.only(right: 18),
                                    //               child: Text("Li Ming",
                                    //                   style: const TextStyle(
                                    //                       color:
                                    //                           const Color(0xff666666),
                                    //                       fontWeight: FontWeight.w400,
                                    //                       fontFamily: "PingFangSC",
                                    //                       fontStyle: FontStyle.normal,
                                    //                       fontSize: 16.0),
                                    //                   textAlign: TextAlign.left)))
                                    //     ])),
                                    Container(
                                        height: 54.6,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        const Color(0xffdedede),
                                                    width: 1))),
                                        child: Stack(children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 0),
                                                  child: Text("学校",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff6f6e6e),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                      textAlign:
                                                          TextAlign.left))),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(right: 0),
                                                  child: Text("성균관대학교",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff9b9b9b),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              "NotoSansKR",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                      textAlign:
                                                          TextAlign.left))),
                                        ])),
                                    Container(
                                        height: 54.6,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        const Color(0xffdedede),
                                                    width: 1))),
                                        child: Stack(children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 0),
                                                  child: Text("专业",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff6f6e6e),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "NotoSansSC",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                      textAlign:
                                                          TextAlign.left))),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(right: 0),
                                                  child: Text(
                                                      "${myPageController.myProfile.value.MAJOR_NAME}",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff9b9b9b),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              "NotoSansKR",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                      textAlign:
                                                          TextAlign.left))),
                                        ])),
                                    Container(
                                        height: 54.6,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        const Color(0xffdedede),
                                                    width: 1))),
                                        child: Stack(children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 0),
                                                  child: Text("ID",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff6f6e6e),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                      textAlign:
                                                          TextAlign.left))),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(right: 0),
                                                  child: Text(
                                                      "${myPageController.myProfile.value.LOGIN_ID}",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff9b9b9b),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                      textAlign:
                                                          TextAlign.left))),
                                        ])),

                                    // ! profile message 무쓸모
                                    // InkWell(
                                    //     child: Container(
                                    //         height: 54.6,
                                    //         width: MediaQuery.of(context)
                                    //             .size
                                    //             .width,
                                    //         decoration: BoxDecoration(
                                    //             border: Border(
                                    //                 bottom: BorderSide(
                                    //                     color: const Color(
                                    //                         0xffdedede),
                                    //                     width: 1))),
                                    //         child: Stack(children: [
                                    //           Align(
                                    //               alignment:
                                    //                   Alignment.centerLeft,
                                    //               child: Container(
                                    //                   margin: EdgeInsets.only(
                                    //                       left: 21),
                                    //                   child: Text(
                                    //                       "PROFILE MESSAGE",
                                    //                       style: const TextStyle(
                                    //                           color: const Color(
                                    //                               0xff6f6e6e),
                                    //                           fontWeight:
                                    //                               FontWeight
                                    //                                   .w500,
                                    //                           fontFamily:
                                    //                               "Roboto",
                                    //                           fontStyle:
                                    //                               FontStyle
                                    //                                   .normal,
                                    //                           fontSize: 14.0),
                                    //                       textAlign:
                                    //                           TextAlign.left))),
                                    //           Align(
                                    //               alignment:
                                    //                   Alignment.centerRight,
                                    //               child: Container(
                                    //                   margin: EdgeInsets.only(
                                    //                       right: 20),
                                    //                   child: Row(
                                    //                       mainAxisAlignment:
                                    //                           MainAxisAlignment
                                    //                               .end,
                                    //                       crossAxisAlignment:
                                    //                           CrossAxisAlignment
                                    //                               .center,
                                    //                       children: [
                                    //                         Text(
                                    //                             "${myPageController.myProfile.value.PROFILE_MESSAGE}",
                                    //                             style: const TextStyle(
                                    //                                 color: const Color(
                                    //                                     0xff9b9b9b),
                                    //                                 fontWeight:
                                    //                                     FontWeight
                                    //                                         .w400,
                                    //                                 fontFamily:
                                    //                                     "Roboto",
                                    //                                 fontStyle:
                                    //                                     FontStyle
                                    //                                         .normal,
                                    //                                 fontSize:
                                    //                                     14.0),
                                    //                             textAlign:
                                    //                                 TextAlign
                                    //                                     .left),
                                    //                         Image.asset(
                                    //                             "assets/images/188.png",
                                    //                             height: 16,
                                    //                             width: 16)
                                    //                       ]))),
                                    //         ])),
                                    //     onTap: () async {
                                    //       ProfileMessageDialog(
                                    //           context, myPageController);
                                    //     }),
                                    Ink(
                                      child: InkWell(
                                        enableFeedback: false,
                                        child: Container(
                                            height: 54.6,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: const Color(
                                                            0xffdedede),
                                                        width: 1))),
                                            child: Stack(children: [
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 0),
                                                      child: Text("NICKNAME",
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff6f6e6e),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 14.0),
                                                          textAlign:
                                                              TextAlign.left))),
                                              Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                "${myPageController.myProfile.value.PROFILE_NICKNAME}",
                                                                style: const TextStyle(
                                                                    color: const Color(
                                                                        0xff9b9b9b),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        "Roboto",
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left),
                                                            // ! 닉네임 수정 불가
                                                            // Image.asset(
                                                            //     "assets/images/188.png",
                                                            //     height: 16,
                                                            //     width: 16)
                                                          ]))),
                                            ])),
                                        // onTap: () async {
                                        //   // ! 닉네임 수정 불가
                                        //   // NicknameDialog(
                                        //   //     context, myPageController);
                                        // },
                                      ),
                                    ),
                                    // Container(
                                    //     height: 54.6,
                                    //     width: MediaQuery.of(context).size.width,
                                    //     decoration: BoxDecoration(
                                    //         border: Border(
                                    //             bottom: BorderSide(
                                    //                 color: const Color(0xffdedede),
                                    //                 width: 1))),
                                    //     child: Stack(children: [
                                    //       Align(
                                    //           alignment: Alignment.centerLeft,
                                    //           child: Container(
                                    //               margin: EdgeInsets.only(left: 15),
                                    //               child: Text("STUDENT ID",
                                    //                   style: const TextStyle(
                                    //                       color:
                                    //                           const Color(0xff333333),
                                    //                       fontWeight: FontWeight.w400,
                                    //                       fontFamily: "PingFangSC",
                                    //                       fontStyle: FontStyle.normal,
                                    //                       fontSize: 16.0),
                                    //                   textAlign: TextAlign.left))),
                                    //       Align(
                                    //           alignment: Alignment.centerRight,
                                    //           child: Container(
                                    //               margin: EdgeInsets.only(right: 18),
                                    //               child: Text(
                                    //                   "${myPageController.myProfile.value.PROFILE_SCHOOL}",
                                    //                   style: const TextStyle(
                                    //                       color:
                                    //                           const Color(0xff666666),
                                    //                       fontWeight: FontWeight.w400,
                                    //                       fontFamily: "PingFangSC",
                                    //                       fontStyle: FontStyle.normal,
                                    //                       fontSize: 16.0),
                                    //                   textAlign: TextAlign.left))),
                                    //     ]))
                                  ],
                                )))
                      ]);
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

//어따 둬야할지 몰라서 여기다 둠
class ProfileAppBars {
  AppBar classBasicAppBar() {
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: InkWell(
        child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onTap: () {
          Get.back();
        },
      ),
      leadingWidth: 35,
    );
  }
}

void ProfileMessageDialog(
    BuildContext context, MyPageController myPageController) {
  final profileMessageController = TextEditingController();
  showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(
            children: <Widget>[
              new Text("Change Profile Message",
                  style: TextStyle(fontSize: 20)),
            ],
          ),
          //
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                  controller: profileMessageController,
                  style: const TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.w500,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText:
                        "${myPageController.myProfile.value.PROFILE_MESSAGE}",
                    border: InputBorder.none,
                  ))
            ],
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("Confirm"),
              onPressed: () async {
                myPageController.updateProfile(
                    profileMessageController.text != ""
                        ? profileMessageController.text
                        : '${myPageController.myProfile.toJson()['PROFILE_MESSAGE']}',
                    '${myPageController.myProfile.value.PROFILE_NICKNAME}');
              },
            ),
            new TextButton(
              child: new Text("Cancel"),
              onPressed: () async {
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}

void NicknameDialog(BuildContext context, MyPageController myPageController) {
  final nicknameController = TextEditingController();
  showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(
            children: <Widget>[
              new Text("Change Nickname", style: TextStyle(fontSize: 20)),
            ],
          ),
          //
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                  controller: nicknameController,
                  style: const TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.w500,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText:
                        "${myPageController.myProfile.value.PROFILE_NICKNAME}",
                    border: InputBorder.none,
                  )),
            ],
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("Confirm"),
              onPressed: () async {
                myPageController.updateProfile(
                    '${myPageController.myProfile.toJson()['PROFILE_MESSAGE']}',
                    nicknameController.text != ""
                        ? nicknameController.text
                        : '${myPageController.myProfile.value.PROFILE_NICKNAME}');
              },
            ),
            new TextButton(
              child: new Text("Cancel"),
              onPressed: () async {
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}
