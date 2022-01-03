import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/main.dart';

class NotiAppBar extends StatelessWidget {
  const NotiAppBar(
      {Key key, @required this.notiController, @required this.pageViewIndex})
      : super(key: key);

  final NotiController notiController;
  final int pageViewIndex;

  @override
  Widget build(BuildContext context) {
    // changeStatusBarColor(Colors.white, Brightness.dark);
    return AppBar(
      toolbarHeight: 55,
      // backgroundColor: const Color(0xff194678),
      // backgroundColor: const Color(0xfff6f6f6),
      backgroundColor: const Color(0xffffffff),

      elevation: 0,
      titleSpacing: 0,
      title: Container(
        margin: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 18.5 - 8, top: 4),
              child: Ink(
                child: InkWell(
                  onTap: () {
                    notiController.pageController.animateToPage(0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Stack(children: [
                      Container(
                          height: 28,
                          width: 42 + 8.0 * 2,
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Text("알림",
                              style: TextStyle(
                                  color: const Color(0xff194678),
                                  // color: const Color(0xffffffff),
                                  fontWeight: pageViewIndex == 0
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  fontFamily: "PingFangSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 21.0),
                              textAlign: TextAlign.center)),
                      pageViewIndex == 0
                          ? Positioned(
                              left: 8 - 6.5,
                              top: 28 + 2.0,
                              child: NotiTopLine())
                          : Container()
                    ]),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20 - 8.0 * 2, top: 4),
              child: Ink(
                child: InkWell(
                  onTap: () {
                    notiController.pageController.animateToPage(1,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            width: 42 + 8.0 * 2,
                            height: 28,
                            child: Text(
                              "쪽지",
                              style: TextStyle(
                                  color: const Color(0xff194678),
                                  // color: const Color(0xffffffff),
                                  fontWeight: pageViewIndex == 0
                                      ? FontWeight.w400
                                      : FontWeight.w700,
                                  fontFamily: "PingFangSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 21.0),
                              textAlign: TextAlign.center,
                            )),
                        pageViewIndex == 0
                            ? Positioned(child: Container())
                            : Positioned(
                                left: 8 - 6.5,
                                top: 28 + 2.0,
                                child: NotiTopLine())
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NotiTopLine extends StatelessWidget {
  const NotiTopLine({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.black, statusBarBrightness: Brightness.light));
    return Container(
        width: 55,
        height: 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          // color: const Color(0xffffffff),
          color: const Color(0xff194678),
        ));
  }
}
