import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';
import 'package:polarstar_flutter/app/ui/android/functions/crypt.dart';
import 'package:polarstar_flutter/app/ui/android/loby/sign_up_major.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/dialoge.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:webview_flutter/webview_flutter.dart';

final box = GetStorage();

class Setting extends StatelessWidget {
  final MainController mainController = Get.find();
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
            body: Column(
              children: [
                Container(
                    height: 10,
                    decoration: BoxDecoration(color: const Color(0xfff6f6f6))),
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
                                color: const Color(0xffdedede), width: 1))),
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
                              child: Text("${mainController.current_version}",
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
                    onTap: myPageController.PersonalInfoURL.value == null ||
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
                                        backgroundColor: Get.theme.primaryColor,
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
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "NotoSansSC",
                                                fontStyle: FontStyle.normal,
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
                                    color: const Color(0xffdedede), width: 1))),
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
                                  child: Image.asset("assets/images/938.png",
                                      height: 9.5, width: 5.4)))
                        ])),
                  ),
                ),
                Ink(
                  child: InkWell(
                    onTap: myPageController.PersonalInfoURL.value == null ||
                            myPageController.PersonalInfoURL.value.isEmpty
                        ? null
                        : () {
                            Get.to(
                                CommunityRule(
                                  isSignUp: false,
                                ),
                                transition: Transition.cupertino);
                          },
                    child: Container(
                        height: 54.6,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: const Color(0xffdedede), width: 1))),
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
                                  child: Image.asset("assets/images/938.png",
                                      height: 9.5, width: 5.4)))
                        ])),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Function ontapConfirm = () async {
                      var salt = Session.cookies['salt'];
                      salt = Uri.decodeComponent(salt);
                      String pw = box.read("pw");
                      var cryptedPw =
                          sha512.convert(utf8.encode(pw + salt)).toString();

                      for (int i = 0; i < 1000; i++) {
                        cryptedPw = sha512
                            .convert(utf8.encode(cryptedPw + salt))
                            .toString();
                      }
                      await Session()
                          .postX("/users/withdrawal", {"pw": cryptedPw});
                      Session.cookies = {};
                      Session.headers['Cookie'] = '';

                      box.write('isAutoLogin', false);
                      box.remove('id');
                      box.remove('pw');
                      box.remove('token');

                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (Route<dynamic> route) => false);
                      Get.offAllNamed('/');
                    };
                    Function ontapCancel = () {
                      Get.back();
                    };

                    await TFdialogue(context, '确定要删除账号吗？', "确定要删除账号吗？",
                        ontapConfirm, ontapCancel);
                  },
                  child: Ink(
                    child: Container(
                        height: 54.6,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: const Color(0xffdedede), width: 1))),
                        child: Stack(children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  margin: EdgeInsets.only(left: 0),
                                  child: Text("退出服务",
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
                                  child: Image.asset("assets/images/938.png",
                                      height: 9.5, width: 5.4)))
                        ])),
                  ),
                ),
              ],
            )),
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
