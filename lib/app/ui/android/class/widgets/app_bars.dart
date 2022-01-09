import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 다른 모양 AppBar도 만들면됨
class AppBars {
  AppBar classBasicAppBar() {
    const mainColor = 0xff371ac7;

    return AppBar(
      backgroundColor: const Color(mainColor),
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: InkWell(
        child: Image.asset("assets/images/icn_back_white.png"),
        onTap: () => Get.back(),
      ),
      elevation: 0,
      titleSpacing: 0,
      centerTitle: true,
      title: Text("课程评价",
          style: const TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w500,
              fontFamily: "NotoSansTC",
              fontStyle: FontStyle.normal,
              fontSize: 14.0),
          textAlign: TextAlign.left),
    );
  }
}
