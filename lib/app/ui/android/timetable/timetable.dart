import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/top_icon.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

class Timetable extends StatelessWidget {
  const Timetable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find();
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 0.0,
        //   backgroundColor: Colors.white,
        //   foregroundColor: Colors.black,
        //   titleSpacing: 0,
        //   automaticallyImplyLeading: false,
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        //         child: Row(
        //           children: [
        //             InkWell(
        //                 onTap: () {},
        //                 child: Row(
        //                   children: [
        //                     // 상태변화 필요
        //                     Text(
        //                       'Third Grade',
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.black),
        //                     ),
        //                     Icon(
        //                       Icons.arrow_drop_down,
        //                       color: Colors.black,
        //                     ),
        //                   ],
        //                 )),
        //             Spacer(),
        //             InkWell(
        //               onTap: () {
        //                 Get.toNamed('/class');
        //               },
        //               child: Icon(Icons.person, color: Colors.black),
        //             ),
        //             InkWell(
        //                 onTap: () {},
        //                 child: Icon(Icons.add, color: Colors.black)),
        //             InkWell(
        //                 onTap: () {},
        //                 child: Icon(Icons.settings, color: Colors.black)),
        //             InkWell(
        //                 onTap: () {},
        //                 child: Icon(Icons.menu, color: Colors.black)),
        //           ],
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text(
        //           "21-22 scholl year First semmester",
        //           textScaleFactor: 0.6,
        //           style: TextStyle(color: Colors.black),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        bottomNavigationBar:
            CustomBottomNavigationBar(mainController: mainController),
        body: SingleChildScrollView(
            child: Column(
          children: [
            TopIcon(),
            Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 3.5, 0, 0),
                child: // 21-22 school year First semmester
                    Text("21-22 school year First semmester",
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w400,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
              ),
              Spacer(),
            ]),
            Container(
              width: size.width,
              color: Colors.black,
              height: 479.3,
              child: Center(
                child: Text(
                  "시간표",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
