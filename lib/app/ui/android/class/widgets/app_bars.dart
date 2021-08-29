import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 다른 모양 AppBar도 만들면됨
class AppBars {
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
        "Course Evaluation",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
