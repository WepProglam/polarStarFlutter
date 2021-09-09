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
                                    color: const Color(0xff333333),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                                textAlign: TextAlign.left))),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            margin: EdgeInsets.only(right: 18),
                            child: Image.asset("assets/images/606.png",
                                height: 22.5, width: 44.8)))
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
                            child: Text("Dark mode",
                                style: const TextStyle(
                                    color: const Color(0xff333333),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                                textAlign: TextAlign.left))),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            margin: EdgeInsets.only(right: 18),
                            child: Image.asset("assets/images/607.png",
                                height: 22.5, width: 44.8)))
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
                            child: Text("Dark mode",
                                style: const TextStyle(
                                    color: const Color(0xff333333),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
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
                            child: Text("Dark mode",
                                style: const TextStyle(
                                    color: const Color(0xff333333),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
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
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      leading: InkWell(
        child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onTap: () {
          Get.back();
        },
      ),
      leadingWidth: 35,
      titleSpacing: 0,
      title: Text(
        "Setting",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
