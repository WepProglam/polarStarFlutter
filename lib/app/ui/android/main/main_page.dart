import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/ui/android/main/main_page_scroll.dart';
import 'package:polarstar_flutter/app/ui/android/noti/noti.dart';
import 'package:polarstar_flutter/app/ui/android/profile/mypage.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/timetable.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';
import 'package:flutter/services.dart';

class MainPage extends StatelessWidget {
  final box = GetStorage();
  final List<Widget> mainPageWidget = [
    MainPageScroll(),
    Timetable(),
    Timetable(),
    // OutSide(
    //   from: "main",
    // ),
    Noti(),
    Mypage()
  ];

  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Obx(() {
          return mainPageWidget[mainController.mainPageIndex.value];
        }),
      ),
    );
  }
}
