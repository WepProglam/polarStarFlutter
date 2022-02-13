import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/loby/init_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';

const mainColor = 0xff4570ff;
const subColor = 0xff91bbff;
const whiteColor = 0xffffffff;
const textColor = 0xff2f2f2f;

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({
    Key key,
  }) : super(key: key);

  // final MainController mainController;
  final MainController mainController = Get.find();

  // final MyPageController myPageController = Get.find();
  final NotiController notiController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 56 + 1.0,
        // decoration: BoxDecoration(boxShadow: [
        //   BoxShadow(
        //       color: const Color(0x1c000000),
        //       offset: Offset(0, -3),
        //       blurRadius: 6,
        //       spreadRadius: 0)
        // ], color: const Color(0xff571df0)),
        child: ClipRRect(
          // borderRadius: BorderRadius.only(
          //   topRight: Radius.circular(40),
          // ),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            backgroundColor: const Color(mainColor),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: mainController.mainPageIndex.value == 0
                        ? Image.asset("assets/images/icn_home_selected.png")
                        : Image.asset("assets/images/icn_home_normal.png")),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                    width: 24,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    height: 24,
                    child: mainController.mainPageIndex.value == 1
                        ? Image.asset("assets/images/icn_calendar_selected.png")
                        : Image.asset("assets/images/icn_calendar_normal.png")),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: mainController.mainPageIndex.value == 2
                        ? Image.asset("assets/images/icn_check_selected.png")
                        : Image.asset("assets/images/icn_check_normal.png")),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Obx(() {
                  bool isAllReaded = notiController.isUnreadNotiExist();
                  return Stack(children: [
                    Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: mainController.mainPageIndex.value == 3
                            ? Image.asset(
                                "assets/images/icn_alarm_selected.png")
                            : Image.asset(
                                "assets/images/icn_alarm_normal.png")),
                    isAllReaded
                        ? Positioned(
                            top: 12,
                            right: 0,
                            child: Container(
                              height: 12,
                              width: 12,
                            ),
                          )
                        : Positioned(
                            top: 12,
                            right: 0,
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xff91e5dd)),
                            )),
                  ]);
                }),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: mainController.mainPageIndex.value == 4
                        ? Image.asset("assets/images/icn_profile_selected.png")
                        : Image.asset("assets/images/icn_profile_normal.png")),
                label: '',
              ),
            ],
            unselectedItemColor: const Color(0xffbbc7d4),
            currentIndex: mainController.mainPageIndex.value,
            selectedItemColor: const Color(0xff1a4678),
            onTap: (index) async {
              mainController.mainPageIndex.value = index;
              // myPageController.profilePostIndex.value = 0;
              // notiController.pageViewIndex.value = 0;
            },
          ),
        ),
      );
    });
  }
}
