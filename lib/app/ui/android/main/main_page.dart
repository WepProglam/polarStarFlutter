import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/main_page_scroll.dart';
import 'package:polarstar_flutter/app/ui/android/outside/outside_board.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/timetable_main.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

class MainPage extends StatelessWidget {
  final box = GetStorage();
  final List<Widget> mainPageWidget = [
    MainPageScroll(),
    OutSide(
      from: "main",
    ),
    TimetableMain(),
    TimetableMain(),
  ];

  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Obx(() {
      return mainPageWidget[mainController.mainPageIndex.value];
    })
        // Scaffold(
        //   appBar: CustomAppBar(
        //     pageName: "POLAR STAR",
        //   ),
        //   bottomNavigationBar:
        //       CustomBottomNavigationBar(mainController: mainController),
        //   body: Obx(() {
        //     // if (mainController.mainPageIndex.value == 1) {
        //     //   return OutSide(
        //     //     from: "main",
        //     //   );
        //     // }
        //     return mainPageWidget[mainController.mainPageIndex.value];
        //   }),
        // ),
        );
  }
}
