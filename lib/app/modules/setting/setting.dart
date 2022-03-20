import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polarstar_flutter/app/modules/init_page/init_controller.dart';
import 'package:polarstar_flutter/app/modules/login_page/login_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/mypage/mypage_controller.dart';

import 'package:polarstar_flutter/app/modules/claa_view/widgets/app_bars.dart';
import 'package:polarstar_flutter/app/modules/sign_up_major/sign_up_major.dart';
import 'package:polarstar_flutter/app/global_widgets/dialoge.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

final box = GetStorage();

class Setting extends StatelessWidget {
  final MainController mainController = Get.find();
  final InitController initController = Get.find();
  final MyPageController myPageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: SettingAppBars().classBasicAppBar(),
            body: Obx(() {
              return Stack(children: [
                Opacity(
                  opacity: myPageController.isPushySetting.value ? 0.3 : 1.0,
                  child: Column(
                    children: [
                      Container(
                          height: 10,
                          decoration:
                              BoxDecoration(color: const Color(0xfff6f6f6))),
                      // Container(
                      //     height: 54.6,
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //         border: Border(
                      //             bottom: BorderSide(
                      //                 color: const Color(0xffdedede), width: 1))),
                      //     child: Stack(children: [
                      //       Align(
                      //           alignment: Alignment.centerLeft,
                      //           child: Container(
                      //               margin: EdgeInsets.only(left: 15),
                      //               child: Text("Dark mode",
                      //                   style: const TextStyle(
                      //                       color: const Color(0xff6f6e6e),
                      //                       fontWeight: FontWeight.w500,
                      //                       fontFamily: "Roboto",
                      //                       fontStyle: FontStyle.normal,
                      //                       fontSize: 14.0),
                      //                   textAlign: TextAlign.left))),
                      //       Align(
                      //           alignment: Alignment.centerRight,
                      //           child: Container(
                      //               width: 38,
                      //               height: 20,
                      //               margin: EdgeInsets.only(right: 18),
                      //               child: Stack(
                      //                 alignment: Alignment.centerLeft,
                      //                 children: [
                      //                   Container(
                      //                       width: 38,
                      //                       height: 20,
                      //                       decoration: BoxDecoration(
                      //                           borderRadius: BorderRadius.all(
                      //                               Radius.circular(10)),
                      //                           color: const Color(0xffd6d4d4))),
                      //                   Container(
                      //                       margin: EdgeInsets.only(left: 2),
                      //                       width: 16,
                      //                       height: 16,
                      //                       decoration: BoxDecoration(
                      //                         color: const Color(0xffffffff),
                      //                         shape: BoxShape.circle,
                      //                       ))
                      //                 ],
                      //               )))
                      //     ])),
                      // Container(
                      //     height: 54.6,
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //         border: Border(
                      //             bottom: BorderSide(
                      //                 color: const Color(0xffdedede), width: 1))),
                      //     child: Stack(children: [
                      //       Align(
                      //           alignment: Alignment.centerLeft,
                      //           child: Container(
                      //               margin: EdgeInsets.only(left: 15),
                      //               child: Text("Message reminding",
                      //                   style: const TextStyle(
                      //                       color: const Color(0xff6f6e6e),
                      //                       fontWeight: FontWeight.w500,
                      //                       fontFamily: "Roboto",
                      //                       fontStyle: FontStyle.normal,
                      //                       fontSize: 14.0),
                      //                   textAlign: TextAlign.left))),
                      //       Align(
                      //           alignment: Alignment.centerRight,
                      //           child: Container(
                      //               width: 38,
                      //               height: 20,
                      //               margin: EdgeInsets.only(right: 18),
                      //               child: Stack(
                      //                 alignment: Alignment.centerLeft,
                      //                 children: [
                      //                   Container(
                      //                       width: 38,
                      //                       height: 20,
                      //                       decoration: BoxDecoration(
                      //                           borderRadius: BorderRadius.all(
                      //                               Radius.circular(10)),
                      //                           color: const Color(0xff4570ff))),
                      //                   Container(
                      //                       margin: EdgeInsets.only(left: 20),
                      //                       width: 16,
                      //                       height: 16,
                      //                       decoration: BoxDecoration(
                      //                         color: const Color(0xffffffff),
                      //                         shape: BoxShape.circle,
                      //                       ))
                      //                 ],
                      //               )))
                      //     ])),
                      // Container(
                      //     height: 54.6,
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //         border: Border(
                      //             bottom: BorderSide(
                      //                 color: const Color(0xffdedede), width: 1))),
                      //     child: Stack(children: [
                      //       Align(
                      //           alignment: Alignment.centerLeft,
                      //           child: Container(
                      //               margin: EdgeInsets.only(left: 15),
                      //               child: Text("Password",
                      //                   style: const TextStyle(
                      //                       color: const Color(0xff6f6e6e),
                      //                       fontWeight: FontWeight.w500,
                      //                       fontFamily: "Roboto",
                      //                       fontStyle: FontStyle.normal,
                      //                       fontSize: 14.0),
                      //                   textAlign: TextAlign.left))),
                      //       Align(
                      //           alignment: Alignment.centerRight,
                      //           child: Container(
                      //               margin: EdgeInsets.only(right: 18),
                      //               child: Image.asset("assets/images/938.png",
                      //                   height: 9.5, width: 5.4)))
                      //     ])),
                      Container(
                          height: 54.6,
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: const Color(0xffdedede),
                                      width: 1))),
                          child: Stack(children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    margin: EdgeInsets.only(left: 0),
                                    child: Text("版本",
                                        style: const TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        textAlign: TextAlign.left))),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    margin: EdgeInsets.only(right: 0),
                                    child: Text(
                                        "${initController.current_version}",
                                        style: const TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        textAlign: TextAlign.left)))
                          ])),

                      // Container(
                      //     height: 54.6,
                      //     width: MediaQuery.of(context).size.width - 40,
                      //     decoration: BoxDecoration(
                      //         border: Border(
                      //             bottom: BorderSide(
                      //                 color: const Color(0xffdedede), width: 1))),
                      //     child: Stack(children: [
                      //       Align(
                      //           alignment: Alignment.centerLeft,
                      //           child: Container(
                      //               margin: EdgeInsets.only(left: 0),
                      //               child: Text("공지사항",
                      //                   style: const TextStyle(
                      //                       color: const Color(0xff6f6e6e),
                      //                       fontWeight: FontWeight.w500,
                      //                       fontFamily: "Roboto",
                      //                       fontStyle: FontStyle.normal,
                      //                       fontSize: 14.0),
                      //                   textAlign: TextAlign.left))),
                      //       Align(
                      //           alignment: Alignment.centerRight,
                      //           child: Container(
                      //               margin: EdgeInsets.only(right: 0),
                      //               child: Image.asset("assets/images/938.png",
                      //                   height: 9.5, width: 5.4)))
                      //     ])),
                      // Container(
                      //     height: 54.6,
                      //     width: MediaQuery.of(context).size.width - 40,
                      //     decoration: BoxDecoration(
                      //         border: Border(
                      //             bottom: BorderSide(
                      //                 color: const Color(0xffdedede), width: 1))),
                      //     child: Stack(children: [
                      //       Align(
                      //           alignment: Alignment.centerLeft,
                      //           child: Container(
                      //               margin: EdgeInsets.only(left: 0),
                      //               child: Text("服务协议",
                      //                   style: const TextStyle(
                      //                       color: const Color(0xff6f6e6e),
                      //                       fontWeight: FontWeight.w500,
                      //                       fontFamily: "Roboto",
                      //                       fontStyle: FontStyle.normal,
                      //                       fontSize: 14.0),
                      //                   textAlign: TextAlign.left))),
                      //       Align(
                      //           alignment: Alignment.centerRight,
                      //           child: Container(
                      //               margin: EdgeInsets.only(right: 0),
                      //               child: Image.asset("assets/images/938.png",
                      //                   height: 9.5, width: 5.4)))
                      //     ])),
                      Ink(
                        child: InkWell(
                          onTap: myPageController.PersonalInfoURL.value ==
                                      null ||
                                  myPageController.PersonalInfoURL.value.isEmpty
                              ? null
                              : () {
                                  Get.to(Obx(() {
                                    return Container(
                                      color: Colors.white,
                                      child: SafeArea(
                                        top: false,
                                        child: Scaffold(
                                          // 隐私政策
                                          appBar: AppBar(
                                              toolbarHeight: 56,
                                              backgroundColor:
                                                  Get.theme.primaryColor,
                                              titleSpacing: 0,
                                              elevation: 1,
                                              automaticallyImplyLeading: false,
                                              leading: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Ink(
                                                  child: Image.asset(
                                                    'assets/images/back_icon.png',
                                                    // fit: BoxFit.fitWidth,
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                ),
                                              ),
                                              centerTitle: true,
                                              title: Text("隐私政策",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "NotoSansSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0))),
                                          body: WebView(
                                            initialUrl: myPageController
                                                .PersonalInfoURL.value,
                                            javascriptMode:
                                                JavascriptMode.unrestricted,
                                          ),
                                        ),
                                      ),
                                    );
                                  }), transition: Transition.cupertino);
                                },
                          child: Container(
                              height: 54.6,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: const Color(0xffdedede),
                                          width: 1))),
                              child: Stack(children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        margin: EdgeInsets.only(left: 0),
                                        child: Text("隐私政策",
                                            style: const TextStyle(
                                                color: const Color(0xff6f6e6e),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14.0),
                                            textAlign: TextAlign.left))),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                        margin: EdgeInsets.only(right: 0),
                                        child: Image.asset(
                                            "assets/images/938.png",
                                            height: 9.5,
                                            width: 5.4)))
                              ])),
                        ),
                      ),
                      Ink(
                        child: InkWell(
                          onTap: myPageController.PersonalInfoURL.value ==
                                      null ||
                                  myPageController.PersonalInfoURL.value.isEmpty
                              ? null
                              : () {
                                  Get.toNamed(Routes.SIGNUPCOMMUNITYRULE,
                                      parameters: {"isSignUp": "false"});
                                  // Get.to(
                                  //     SigunUpCommunityRule(
                                  //       isSignUp: false,
                                  //     ),
                                  //     transition: Transition.cupertino);
                                },
                          child: Container(
                              height: 54.6,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: const Color(0xffdedede),
                                          width: 1))),
                              child: Stack(children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        margin: EdgeInsets.only(left: 0),
                                        child: Text("论坛使用规则",
                                            style: const TextStyle(
                                                color: const Color(0xff6f6e6e),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14.0),
                                            textAlign: TextAlign.left))),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                        margin: EdgeInsets.only(right: 0),
                                        child: Image.asset(
                                            "assets/images/938.png",
                                            height: 9.5,
                                            width: 5.4)))
                              ])),
                        ),
                      ),

                      Ink(
                        child: InkWell(
                          onTap: myPageController.PersonalInfoURL.value ==
                                      null ||
                                  myPageController.PersonalInfoURL.value.isEmpty
                              ? null
                              : () {
                                  Get.to(Obx(() {
                                    return Container(
                                      color: Colors.white,
                                      child: SafeArea(
                                        top: false,
                                        child: Scaffold(
                                          // 隐私政策
                                          appBar: AppBar(
                                              toolbarHeight: 56,
                                              backgroundColor:
                                                  Get.theme.primaryColor,
                                              titleSpacing: 0,
                                              elevation: 1,
                                              automaticallyImplyLeading: false,
                                              leading: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Ink(
                                                  child: Image.asset(
                                                    'assets/images/back_icon.png',
                                                    // fit: BoxFit.fitWidth,
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                ),
                                              ),
                                              centerTitle: true,
                                              title: Text("隐私政策",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "NotoSansSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0))),
                                          body: WebView(
                                            initialUrl: myPageController
                                                .PersonalInfoURL.value,
                                            javascriptMode:
                                                JavascriptMode.unrestricted,
                                          ),
                                        ),
                                      ),
                                    );
                                  }), transition: Transition.cupertino);
                                },
                          child: Container(
                              height: 54.6,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: const Color(0xffdedede),
                                          width: 1))),
                              child: Stack(children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        margin: EdgeInsets.only(left: 0),
                                        child: Text("隐私政策",
                                            style: const TextStyle(
                                                color: const Color(0xff6f6e6e),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14.0),
                                            textAlign: TextAlign.left))),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                        margin: EdgeInsets.only(right: 0),
                                        child: Image.asset(
                                            "assets/images/938.png",
                                            height: 9.5,
                                            width: 5.4)))
                              ])),
                        ),
                      ),

                      // InkWell(
                      //   onTap: () async {},
                      //   child: Ink(
                      //     child: Container(
                      //         height: 54.6,
                      //         width: MediaQuery.of(context).size.width - 40,
                      //         decoration: BoxDecoration(
                      //             border: Border(
                      //                 bottom: BorderSide(
                      //                     color: const Color(0xffdedede),
                      //                     width: 1))),
                      //         child: Stack(children: [
                      //           Align(
                      //               alignment: Alignment.centerLeft,
                      //               child: Container(
                      //                   margin: EdgeInsets.only(left: 0),
                      //                   child: Text("알림 설정",
                      //                       style: const TextStyle(
                      //                           color: const Color(0xff6f6e6e),
                      //                           fontWeight: FontWeight.w500,
                      //                           fontFamily: "Roboto",
                      //                           fontStyle: FontStyle.normal,
                      //                           fontSize: 14.0),
                      //                       textAlign: TextAlign.left))),
                      //           Align(
                      //               alignment: Alignment.centerRight,
                      //               child: Container(
                      //                 margin: EdgeInsets.only(right: 0),
                      //                 child: Container(
                      //                   width: 52,
                      //                   height: 10,
                      //                   child: Obx(() {
                      //                     return CupertinoSwitch(
                      //                       activeColor: Get.theme.primaryColor,
                      //                       value: myPageController
                      //                           .activatePushNoti.value,
                      //                       onChanged: (bool value) async {
                      //                         print(value);

                      //                         if (value) {
                      //                           if (await myPageController
                      //                               .activateAllPushNoti()) {
                      //                             myPageController
                      //                                 .activatePushNoti
                      //                                 .value = true;
                      //                           }
                      //                         } else {
                      //                           if (await myPageController
                      //                               .deactivateAllPushNoti()) {
                      //                             myPageController
                      //                                 .activatePushNoti
                      //                                 .value = false;
                      //                           }
                      //                         }
                      //                       },
                      //                     );
                      //                   }),
                      //                 ),
                      //               ))
                      //         ])),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                myPageController.isPushySetting.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Get.theme.primaryColor,
                        ),
                      )
                    : Container()
              ]);
            })),
      ),
    );
  }
}

//어따 둬야할지 몰라서 여기다 둠
class SettingAppBars {
  AppBar classBasicAppBar() {
    return AppBar(
      toolbarHeight: 56,

      backgroundColor: Get.theme.primaryColor,
      titleSpacing: 0,
      // elevation: 0,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Ink(
          child: Image.asset(
            'assets/images/back_icon.png',
            // fit: BoxFit.fitWidth,
            width: 24,
            height: 24,
          ),
        ),
      ),
      centerTitle: true,
      title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "隐私",
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
              )
            ],
            style: const TextStyle(
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w500,
                fontFamily: "NotoSansSC",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
          ),
          textAlign: TextAlign.left),
    );
  }
}
