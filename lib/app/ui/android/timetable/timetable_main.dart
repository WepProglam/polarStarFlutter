import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

class TimetableMain extends StatelessWidget {
  const TimetableMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find();

    return Scaffold(
      bottomNavigationBar:
          CustomBottomNavigationBar(mainController: mainController),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          // 상태변화 필요
                          Text(
                            'Third Grade',
                            textScaleFactor: 1.5,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      )),
                  Spacer(),
                  InkWell(
                    onTap: () {},
                    child: Icon(Icons.person),
                  ),
                  InkWell(onTap: () {}, child: Icon(Icons.add)),
                  InkWell(onTap: () {}, child: Icon(Icons.settings)),
                  InkWell(onTap: () {}, child: Icon(Icons.menu)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text("21-22 scholl year First semmester"),
            )
          ],
        ),
      ),
    );
  }
}
