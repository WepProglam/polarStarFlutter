import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4570ff),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          margin: const EdgeInsets.only(top: 235.2),
          child: Center(
            child: Image.asset(
              "assets/images/polarstar_logo.png",
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 31.2),
          child: // 폴라스타, 여러분의 유학 생활 동반자
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0),
                      text: "폴라스타,\n",
                    ),
                    TextSpan(
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansKR",
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0),
                        text: "여러분의 유학 생활 동반자")
                  ])),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          child: // 北北, 你的留韩同窗
              RichText(
                  text: TextSpan(children: [
            TextSpan(
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
                text: "北北, "),
            TextSpan(
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
                text: "你的留韩同窗")
          ])),
        ),
        Spacer(),
        Container(
          margin: const EdgeInsets.only(bottom: 50),
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
    );
  }
}
