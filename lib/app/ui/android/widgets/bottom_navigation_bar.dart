import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key key,
    @required this.mainController,
  }) : super(key: key);

  final MainController mainController;

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
            label: '취알공',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '강의평가/시간표',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: '유니티',
          ),
        ],
        unselectedItemColor: Colors.black,
        currentIndex: mainController.mainPageIndex.value,
        selectedItemColor: Colors.amber[800],
        onTap: (index) async {
          mainController.mainPageIndex.value = index;
        },
      );
    });
  }
}
