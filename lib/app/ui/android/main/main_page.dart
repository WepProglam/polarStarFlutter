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
    Noti(),
    Mypage()
  ];

  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime pre_backpress = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          final snack = SnackBar(
            content: Text('종료하시려면 뒤로가기를 한번 더 눌러주세요'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.black,
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Obx(() {
          return mainPageWidget[mainController.mainPageIndex.value];
        }),
      ),
    );
  }
}
