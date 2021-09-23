import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/ui/android/noti/widgets/mailBox.dart';
import 'package:polarstar_flutter/app/ui/android/noti/widgets/noti_appbar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';

class Noti extends StatelessWidget {
  Noti({
    Key key,
  }) : super(key: key);
  final MainController mainController = Get.find();
  final MailController mailController = Get.find();
  final NotiController notiController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(44),
            child: Obx(() {
              int pageViewIndex = notiController.pageViewIndex.value;
              return NotiAppBar(
                  pageViewIndex: pageViewIndex, notiController: notiController);
            })),
        bottomNavigationBar: CustomBottomNavigationBar(
          mainController: mainController,
        ),
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
                return NotiMailBox(mailController: mailController);
              }
            }));
  }
}

class NotiNotiBox extends StatelessWidget {
  const NotiNotiBox({
    Key key,
    @required this.notiController,
  }) : super(key: key);

  final NotiController notiController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (notiController.notiFetched.value) {
        return ListView.builder(
            itemCount: notiController.noties.length,
            itemBuilder: (BuildContext context, int index) {
              NotiModel model = notiController.noties[index];
              return Ink(
                child: InkWell(
                  onTap: () async {
                    // mailController.MAIL_BOX_ID.value = model.MAIL_BOX_ID;
                    // //처음에 정보(쪽지 주고 받은 내역) 받고 보냄
                    // await mailController.getMail();
                    // Get.toNamed("/mail/${model.MAIL_BOX_ID}");
                  },
                  child: Container(
                    height: 56,
                    margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                              height: 46,
                              child: Row(
                                children: [
                                  Container(
                                    height: 46,
                                    width: 46,
                                    child: Image.asset(
                                        "assets/images/temp_pencil.png"),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    height: 46,
                                    width: Get.mediaQuery.size.width -
                                        16 -
                                        46 -
                                        30,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 1.5),
                                            child: Text("자유 게시판",
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff333333),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "PingFangSC",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15.0),
                                                textAlign: TextAlign.left),
                                          ),
                                          Spacer(),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 2, right: 0.5),
                                            child: Text("${model.TIME_CREATED}",
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff333333),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "PingFangSC",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 9.0),
                                                textAlign: TextAlign.left),
                                          )
                                        ]),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 2.5),
                                          child: Text("${model.CONTENT}",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff333333),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "PingFangSC",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 13.0),
                                              textAlign: TextAlign.left),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          Spacer(),
                          Container(
                              height: 0.5,
                              decoration:
                                  BoxDecoration(color: const Color(0xffdedede)))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      } else {
        return Container(
          color: Colors.black,
        );
      }
    });
  }
}
