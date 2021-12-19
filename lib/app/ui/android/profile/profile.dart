import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';

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
          appBar: ProfileAppBars().classBasicAppBar(),
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
                            height: 268.5,
                            child: Stack(children: [
                              Container(
                                height: 141,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/images/279.png'),
                                        fit: BoxFit.none)),
                              ),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                      height: 129,
                                      width: 129,
                                      margin: EdgeInsets.only(top: 70.5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color(0x24ffffff),
                                            width: 11),
                                      ),
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              '${myPageController.myProfile.value.PROFILE_PHOTO}',
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              Container(
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                    BoxShadow(
                                                        color: const Color(
                                                            0x4a143a66),
                                                        offset: Offset(0, 10),
                                                        blurRadius: 26,
                                                        spreadRadius: 0)
                                                  ],
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: imageProvider,
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
                                          }))),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: EdgeInsets.only(top: 172, left: 100),
                                  width: 30.5,
                                  height: 30.5,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: const Color(0x3352749d),
                                            offset: Offset(0, 6),
                                            blurRadius: 20,
                                            spreadRadius: 0)
                                      ],
                                      color: const Color(0xffffffff)),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 180, left: 100),
                                  child: Ink(
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    width: 13.7,
                                    height: 11.8,
                                    child: InkWell(
                                      onTap: () async {
                                        await myPageController
                                            .getMultipleGallertImage(context);
                                        await myPageController.upload();
                                      },
                                      child:
                                          Image.asset("assets/images/605.png"),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    margin: EdgeInsets.only(top: 217),
                                    height: 28,
                                    child: // Userd
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                          Text(
                                              '${myPageController.myProfile.value.PROFILE_NICKNAME}',
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff333333),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "PingFangSC",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 21.0),
                                              textAlign: TextAlign.center),
                                        ])),
                              )
                            ])),
                        Container(
                            height: 10,
                            decoration:
                                BoxDecoration(color: const Color(0xfff6f6f6))),
                        Expanded(
                            child: Container(
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
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: const Color(0xffdedede),
                                            width: 1))),
                                child: Stack(children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text("ID",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff333333),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "PingFangSC",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0),
                                              textAlign: TextAlign.left))),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                          margin: EdgeInsets.only(right: 18),
                                          child: Text(
                                              "${myPageController.myProfile.value.LOGIN_ID}",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff666666),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "PingFangSC",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0),
                                              textAlign: TextAlign.left))),
                                ])),
                            InkWell(
                                child: Container(
                                    height: 54.6,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: const Color(0xffdedede),
                                                width: 1))),
                                    child: Stack(children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Text("PROFILE MESSAGE",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff333333),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "PingFangSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.left))),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 18),
                                              child: Text(
                                                  "${myPageController.myProfile.value.PROFILE_MESSAGE}",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff666666),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "PingFangSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.left))),
                                    ])),
                                onTap: () async {
                                  ProfileMessageDialog(
                                      context, myPageController);
                                }),
                            InkWell(
                                child: Container(
                                    height: 54.6,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: const Color(0xffdedede),
                                                width: 1))),
                                    child: Stack(children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Text("NICKNAME",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff333333),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "PingFangSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.left))),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 18),
                                              child: Text(
                                                  "${myPageController.myProfile.value.PROFILE_NICKNAME}",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff666666),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "PingFangSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.left))),
                                    ])),
                                onTap: () async {
                                  NicknameDialog(context, myPageController);
                                }),
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
