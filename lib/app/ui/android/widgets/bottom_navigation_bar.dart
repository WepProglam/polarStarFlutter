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
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outlined),
            label: '정보 제공',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '강의평가/시간표',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.doorbell),
            label: '알림함',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이 페이지',
          ),
        ],
        unselectedItemColor: Colors.black,
        currentIndex: mainController.mainPageIndex.value,
        selectedItemColor: Colors.amber[800],
        onTap: (index) async {
          mainController.mainPageIndex.value = index;
          myPageController.profilePostIndex.value = 0;
          notiController.pageViewIndex.value = 0;
        },
      );
    });
  }
}
