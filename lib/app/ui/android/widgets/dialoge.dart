import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> TFdialogue(BuildContext context, String title, String content,
    Function ontapConfirm, Function ontapCancel) async {
  await Get.defaultDialog(
    titlePadding: const EdgeInsets.only(top: 20.0),
    titleStyle: const TextStyle(
        color: const Color(0xff6f6e6e),
        fontWeight: FontWeight.w400,
        fontFamily: "NotoSansSC",
        fontStyle: FontStyle.normal,
        fontSize: 12.0),
    contentPadding: const EdgeInsets.only(top: 20),
    title: "${title}",
    content: Column(children: [
      Text("${content}",
          style: const TextStyle(
              color: const Color(0xff2f2f2f),
              fontWeight: FontWeight.w400,
              fontFamily: "NotoSansSC",
              fontStyle: FontStyle.normal,
              fontSize: 16.0),
          textAlign: TextAlign.center),
      // 선 122
      Container(
          margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
          width: 280,
          height: 1,
          decoration: BoxDecoration(color: const Color(0xffd6d4d4))),
      Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Ink(
                  child: InkWell(
                    onTap: () async {
                      await ontapCancel();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: // 한국문화와언어
                          Text("否",
                              style: const TextStyle(
                                  color: const Color(0xff4570ff),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center),
                    ),
                  ),
                ),
                Ink(
                  child: InkWell(
                    onTap: () async {
                      await ontapConfirm();
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Text("是",
                            style: const TextStyle(
                                color: const Color(0xff4570ff),
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            textAlign: TextAlign.center)),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
                width: 1,
                height: 20,
                decoration: BoxDecoration(color: const Color(0xffd6d4d4))),
          )
        ]),
      )
    ]),
    // actions: [
    //   TextButton(
    //       onPressed: () async {
    //         LoginController loginController = Get.find();
    //         loginController.logout();
    //         InitController initController = Get.find();
    //         initController.dispose();

    //         await Get.offAllNamed('/login');
    //         // initController.mainPageIndex.value = 0;
    //       },
    //       child: Text("YES")),
    //   TextButton(
    //       onPressed: () {
    //         Get.back();
    //       },
    //       child: Text("NO"))
    // ],
  );
}

Future<int> getArrestType() async {
  var response = await Get.defaultDialog(
      // * 신고 사유 선택
      title: "举报成功",
      titlePadding: const EdgeInsets.only(top: 20),
      titleStyle: const TextStyle(
          color: const Color(0xff6f6e6e),
          fontWeight: FontWeight.w400,
          fontFamily: "NotoSansSC",
          fontStyle: FontStyle.normal,
          fontSize: 12.0),
      content: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            InkWell(
              // * 게시판 성격에 안 맞는 글
              child: Text("不符合本论坛的帖子",
                  style: const TextStyle(
                      color: const Color(0xff2f2f2f),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.center),
              onTap: () {
                Get.back(result: 0);
              },
            ),
            InkWell(
              // * 광고
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text("广告",
                    style: const TextStyle(
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.center),
              ),
              onTap: () {
                Get.back(result: 1);
              },
            ),
            InkWell(
              // * 허위 사실
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text("虚假事实",
                    style: const TextStyle(
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.center),
              ),
              onTap: () {
                Get.back(result: 2);
              },
            ),
            // * 욕설/비난
            InkWell(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text("谩骂/诋毁",
                    style: const TextStyle(
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.center),
              ),
              onTap: () {
                Get.back(result: 3);
              },
            ),
            InkWell(
              // * 저작권
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text("版权",
                    style: const TextStyle(
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.center),
              ),
              onTap: () {
                Get.back(result: 4);
              },
            ),
            InkWell(
              // * 풍기문란
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text("扰乱风气",
                    style: const TextStyle(
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.center),
              ),
              onTap: () {
                Get.back(result: 5);
              },
            ),
          ],
        ),
      ));
  return response;
}
