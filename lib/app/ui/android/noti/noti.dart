import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';
import 'package:polarstar_flutter/app/ui/android/functions/time_pretty.dart';
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
        appBar: AppBar(
          toolbarHeight: 56,

          backgroundColor: Get.theme.primaryColor,
          titleSpacing: 0,
          // elevation: 0,
          automaticallyImplyLeading: false,

          title: Stack(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.5),
                  child: Text(
                    "成均馆大学",
                    style: const TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                ),
              ),
              // Positioned(
              //   // left: 20,
              //   child: Container(
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              //     child: Ink(
              //       child: InkWell(
              //         onTap: () {
              //           Get.back();
              //         },
              //         child: Image.asset(
              //           'assets/images/back_icon.png',
              //           // fit: BoxFit.fitWidth,
              //           width: 24,
              //           height: 24,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),

        // PreferredSize(
        //     preferredSize: Size.fromHeight(56),
        //     child: Obx(() {
        //       int pageViewIndex = notiController.pageViewIndex.value;
        //       return NotiAppBar(
        //           pageViewIndex: pageViewIndex, notiController: notiController);
        //     })),
        // bottomNavigationBar: CustomBottomNavigationBar(
        //   mainController: mainController,
        // ),
        backgroundColor: const Color(0xffffffff),
        body: Column(
          children: [
            NotiMailSelect(notiController: notiController),
            Container(
              height: 14,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await notiController.getNoties();
                },
                child: Obx(() {
                  if (notiController.noties.length == 0) {
                    return Stack(children: [
                      ListView(),
                      Center(
                        child: Text(
                          "아직 알림이 없습니다.",
                          style: const TextStyle(
                              color: const Color(0xff6f6e6e),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansKR",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                        ),
                      ),
                    ]);
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: notiController.noties.length,
                      itemBuilder: (BuildContext context, int index) {
                        Rx<NotiModel> model = notiController.noties[index];
                        return // Rectangle 2
                            Ink(
                          child: InkWell(
                            onTap: () async {
                              String COMMUNITY_ID;
                              String BOARD_ID;
                              if (model.value.NOTI_TYPE == 0) {
                                COMMUNITY_ID = model.value.URL.split("/")[1];
                                BOARD_ID = model.value.URL.split("/")[3];
                                Get.toNamed(
                                    "/board/${COMMUNITY_ID}/read/${BOARD_ID}");
                              } else {
                                Get.toNamed("/board/32/read/20");
                              }
                              if (!model.value.isReaded) {
                                model.update((val) {
                                  val.isReaded = true;
                                });
                                notiController.setReadNotied(
                                    SaveNotiModel.fromJson({
                                  "NOTI_ID": model.value.NOTI_ID,
                                  "LOOKUP_DATE": "${DateTime.now()}"
                                }));
                              }
                            },
                            child: Container(
                                height: 108,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        child: Row(children: [
                                          Text(
                                              model.value.NOTI_TYPE == 0
                                                  ? "${communityBoardName(model.value.COMMUNITY_ID)}"
                                                  : "${model.value.TITLE}",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff2f2f2f),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "NotoSansSC",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.left),
                                          // Rectangle 7
                                          Container(
                                              width: 38,
                                              height: 18,
                                              child: Center(
                                                child: // New
                                                    Text("New",
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xffffffff),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                "Roboto",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 10.0),
                                                        textAlign:
                                                            TextAlign.left),
                                              ),
                                              margin: const EdgeInsets.only(
                                                  top: 1.5,
                                                  bottom: 1.5,
                                                  left: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  color:
                                                      const Color(0xff571df0)))
                                        ]),
                                      ),
                                      // 恭喜你上热棒了：大家这次期末考的怎么样啊？
                                      Container(
                                        margin: const EdgeInsets.only(top: 2),
                                        child: Text("${model.value.CONTENT}",
                                            style: const TextStyle(
                                                color: const Color(0xff6f6e6e),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "NotoSansSC",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.left),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 14),
                                        child: Text(
                                            "${prettyDate(model.value.TIME_CREATED)}",
                                            style: const TextStyle(
                                                color: const Color(0xff6f6e6e),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Roboto",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.left),
                                      )
                                    ],
                                  ),
                                ),
                                margin: const EdgeInsets.only(
                                    bottom: 10, left: 20, right: 20),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(
                                        color: const Color(0xffeaeaea),
                                        width: 1),
                                    color: const Color(0xffffffff))),
                          ),
                        );
                      });
                }),
              ),
            ),
          ],
        ));

    // PageView.builder(
    //     itemCount: 2,
    //     controller: notiController.pageController,
    //     onPageChanged: (index) {
    //       notiController.pageViewIndex.value = index;
    //     },
    //     itemBuilder: (BuildContext context, int index) {
    //       if (index == 0) {
    //         return NotiNotiBox(notiController: notiController);
    //       } else {
    //         return NotiMailBox(
    //           notiController: notiController,
    //         );
    //       }
    //     }));
  }
}

class NotiMailSelect extends StatelessWidget {
  const NotiMailSelect({
    Key key,
    @required this.notiController,
  }) : super(key: key);

  final NotiController notiController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: const Color(0xff2f2f2f),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 14),
              child: Ink(
                child: InkWell(
                  onTap: () {
                    notiController.pageViewIndex.value = 1;
                  },
                  child: Text("消息",
                      style: TextStyle(
                          color: notiController.pageViewIndex.value == 0
                              ? Color(0xffffffff)
                              : Color(0xff9b75ff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                ),
              ),
            ),
            Container(
                width: 1,
                height: 16,
                decoration: BoxDecoration(color: const Color(0xff535353))),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 14),
              child:
                  // 私信
                  Ink(
                child: InkWell(
                  onTap: () {
                    notiController.pageViewIndex.value = 0;
                  },
                  child: Text("私信",
                      style: TextStyle(
                          color: notiController.pageViewIndex.value == 0
                              ? Color(0xff9b75ff)
                              : Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
