import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({
    Key key,
    @required this.mainController,
  }) : super(key: key);

  final MainController mainController;
  final MyPageController myPageController = Get.find();
  final NotiController notiController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 80,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: const Color(0x1c000000),
              offset: Offset(0, -3),
              blurRadius: 6,
              spreadRadius: 0)
        ], color: const Color(0xffffffff)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                  width: 20,
                  height: 20,
                  // margin: const EdgeInsets.only(top: 15),
                  child: mainController.mainPageIndex.value == 0
                      ? Image.asset("assets/images/homepage_selected.png")
                      : Image.asset("assets/images/500.png")),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                  width: 20,
                  height: 20,
                  // margin: const EdgeInsets.only(top: 15),
                  child: mainController.mainPageIndex.value == 1
                      ? Image.asset("assets/images/outside_selected.png")
                      : Image.asset("assets/images/306.png")),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                  width: 20,
                  // margin: const EdgeInsets.only(top: 15),
                  height: 20,
                  child: mainController.mainPageIndex.value == 2
                      ? Image.asset("assets/images/outside_selected.png")
                      : Image.asset("assets/images/306.png")),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                  width: 20,
                  height: 20,
                  // margin: const EdgeInsets.only(top: 15),
                  child: mainController.mainPageIndex.value == 3
                      ? Image.asset("assets/images/timetable_selected.png")
                      : Image.asset("assets/images/687.png")),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                  width: 20,
                  height: 20,
                  // margin: const EdgeInsets.only(top: 15),
                  child: mainController.mainPageIndex.value == 4
                      ? Image.asset("assets/images/mypage_selected.png")
                      : Image.asset("assets/images/689.png")),
              label: '',
            ),
          ],
          unselectedItemColor: const Color(0xffbbc7d4),
          currentIndex: mainController.mainPageIndex.value,
          selectedItemColor: const Color(0xff1a4678),
          unselectedFontSize: 0.0,
          onTap: (index) async {
            mainController.mainPageIndex.value = index;
            myPageController.profilePostIndex.value = 0;
            notiController.pageViewIndex.value = 0;
          },
        ),
      );
    });
  }
}
