import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: SettingAppBars().classBasicAppBar(),
          body: Column(
            children: [
              Container(
                  height: 10,
                  decoration: BoxDecoration(color: const Color(0xfff6f6f6))),
              Container(
                  height: 54.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: const Color(0xffdedede), width: 1))),
                  child: Stack(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text("Dark mode",
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
                            width: 38,
                            height: 20,
                            margin: EdgeInsets.only(right: 18),
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                    width: 38,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: const Color(0xffd6d4d4))),
                                Container(
                                    margin: EdgeInsets.only(left: 2),
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      shape: BoxShape.circle,
                                    ))
                              ],
                            )))
                  ])),
              Container(
                  height: 54.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: const Color(0xffdedede), width: 1))),
                  child: Stack(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text("Message reminding",
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
                            width: 38,
                            height: 20,
                            margin: EdgeInsets.only(right: 18),
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                    width: 38,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: const Color(0xff4570ff))),
                                Container(
                                    margin: EdgeInsets.only(left: 20),
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      shape: BoxShape.circle,
                                    ))
                              ],
                            )))
                  ])),
              Container(
                  height: 54.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: const Color(0xffdedede), width: 1))),
                  child: Stack(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text("Password",
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
                            margin: EdgeInsets.only(right: 18),
                            child: Image.asset("assets/images/938.png",
                                height: 9.5, width: 5.4)))
                  ])),
              Container(
                  height: 54.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: const Color(0xffdedede), width: 1))),
                  child: Stack(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text("Notice",
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
                            margin: EdgeInsets.only(right: 18),
                            child: Image.asset("assets/images/938.png",
                                height: 9.5, width: 5.4)))
                  ]))
            ],
          )),
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

      title: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16.5),
              child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "设置",
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
            ),
          ),
          Positioned(
            // left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Ink(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(
                    'assets/images/back_icon.png',
                    // fit: BoxFit.fitWidth,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
