import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutsidePreview extends StatelessWidget {
  const OutsidePreview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      child: Container(
        margin: const EdgeInsets.only(left: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 首尔地区包括
            Text("首尔地区包括",
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),
            // 成均馆大学，汉阳大学，高丽大学
            Text("成均馆大学，汉阳大学，高丽大学",
                style: const TextStyle(
                    color: const Color(0xff9b75ff),
                    fontWeight: FontWeight.w400,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                textAlign: TextAlign.left)
          ],
        ),
      ),
      // child: Container(
      //   margin: const EdgeInsets.only(top: 6),
      //   child: Image.asset(
      //     // "assets/images/main_card_temp.png",
      //     "assets/images/main_card_expanded.png",
      //     fit: BoxFit.fitWidth,
      //   ),
      // ),
      // Center(
      //   child: Text(
      //     " T E S T ",
      //     style: TextStyle(
      //         color: Colors.white,
      //         fontSize: 20,
      //         fontWeight: FontWeight.normal),
      //   ),
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
              color: const Color(0xffffffff),
              offset: Offset(0, 9),
              blurRadius: 0,
              spreadRadius: 0)
        ],
        color: Get.theme.primaryColor,
      ),
    );
  }
}
