import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/global_functions/form_validator.dart';

import 'package:polarstar_flutter/app/modules/init_page/init_controller.dart';

import 'package:polarstar_flutter/main.dart';

class InitPage extends GetView<InitController> {
  InitPage({Key key}) : super(key: key);
  final InitController initController = Get.find();

  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(Color(0xff4570ff), Brightness.light);

    return Container(
      color: const Color(0xff4570ff),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xff4570ff),
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Obx(() => AnimatedOpacity(
                  opacity: initController.opacityControl.isTrue ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 700),
                  child: Column(
                    children: [
                      // Container(
                      //   margin: const EdgeInsets.only(top: 235.2),
                      //   child: Center(
                      //     child: Image.asset(
                      //       "assets/images/polarstar_logo.png",
                      //     ),
                      //   ),
                      // ),
                      Container(
                          margin: const EdgeInsets.only(top: 177),
                          child: // 폴라스타, 여러분의 유학 생활 동반자
                              Column(
                            children: [
                              Text(
                                "폴라스타,",
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NotoSansKR",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "여러분의 유학 생활 동반자",
                                  style: const TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "北北, ",
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0),
                              ),
                              Text(
                                "你的留韩同窗",
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0),
                              )
                            ],
                          )),
                    ],
                  ),
                )),
            Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 83.1),
              child: // 北北上学堂
                  Text("北北上学堂",
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.center),
            )
          ]),
        ),
      ),
    );
  }
}
