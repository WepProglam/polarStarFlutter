import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/ui/android/noti/widgets/mailBox.dart';
import 'package:polarstar_flutter/app/ui/android/noti/widgets/notiBox.dart';
import 'package:polarstar_flutter/app/ui/android/noti/widgets/noti_appbar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

class Noti extends StatelessWidget {
  Noti({
    Key key,
  }) : super(key: key);
  final MainController mainController = Get.find();
  final NotiController notiController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: Obx(() {
              int pageViewIndex = notiController.pageViewIndex.value;
              return NotiAppBar(
                  pageViewIndex: pageViewIndex, notiController: notiController);
            })),
        // bottomNavigationBar: CustomBottomNavigationBar(
        //   mainController: mainController,
        // ),
        backgroundColor: const Color(0xfff6f6f6),
        body: PageView.builder(
            itemCount: 2,
            controller: notiController.pageController,
            onPageChanged: (index) {
              notiController.pageViewIndex.value = index;
            },
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return NotiNotiBox(notiController: notiController);
              } else {
                return NotiMailBox(
                  notiController: notiController,
                );
              }
            }));
  }
}
