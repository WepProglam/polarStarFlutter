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

          title: Center(
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
        ),
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
                  await MainUpdateModule.updateNotiPage(
                      notiController.pageViewIndex.value);
                },
                child: Obx(() {
                  RxBool isNotiPage =
                      (notiController.pageViewIndex.value == 0).obs;
                  if (isNotiPage.value && notiController.noties.length == 0) {
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
                  } else if (!isNotiPage.value &&
                      notiController.mailBox.length == 0) {
                    return Stack(children: [
                      ListView(),
                      Center(
                        child: Text(
                          "아직 쪽지가 없습니다.",
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
                  return PageView.builder(
                      itemCount: 2,
                      controller: notiController.pageController,
                      onPageChanged: (index) {
                        notiController.pageViewIndex.value = index;
                      },
                      itemBuilder: (BuildContext context, int i) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: isNotiPage.value
                                ? notiController.noties.length
                                : notiController.mailBox.length,
                            itemBuilder: (BuildContext context, int index) {
                              RxString title = isNotiPage.value
                                  ? (notiController
                                              .noties[index].value.NOTI_TYPE ==
                                          0
                                      ? "${communityBoardName(notiController.noties[index].value.COMMUNITY_ID)}"
                                          .obs
                                      : "${notiController.noties[index].value.TITLE}"
                                          .obs)
                                  : notiController.mailBox[index].value
                                      .PROFILE_NICKNAME.obs;

                              RxString content = isNotiPage.value
                                  ? "${notiController.noties[index].value.CONTENT}"
                                      .obs
                                  : "${notiController.mailBox[index].value.CONTENT}"
                                      .obs;

                              RxString dateTime = isNotiPage.value
                                  ? "${prettyDate(notiController.noties[index].value.TIME_CREATED)}"
                                      .obs
                                  : "${prettyDate(notiController.mailBox[index].value.TIME_CREATED)}"
                                      .obs;
                              return // Rectangle 2
                                  Ink(
                                child: InkWell(
                                  onTap: () async {
                                    // * Noti Page
                                    if (isNotiPage.value) {
                                      checkNoti(notiController, index);
                                    }
                                    // * Mail Page
                                    else {
                                      checkMail(notiController, index);
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
                                              margin: const EdgeInsets.only(
                                                  top: 20),
                                              child: Obx(() {
                                                RxBool isReaded =
                                                    isNotiPage.value
                                                        ? notiController
                                                            .noties[index]
                                                            .value
                                                            .isReaded
                                                            .obs
                                                        : notiController
                                                            .mailBox[index]
                                                            .value
                                                            .isReaded
                                                            .obs;
                                                return Row(children: [
                                                  Text("${title.value}",
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff2f2f2f),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "NotoSansSC",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                      textAlign:
                                                          TextAlign.left),
                                                  // Rectangle 7
                                                  isReaded.value
                                                      ? Container()
                                                      : Container(
                                                          width: 38,
                                                          height: 18,
                                                          child: Center(
                                                            child: // New
                                                                Text("New",
                                                                    style: const TextStyle(
                                                                        color: const Color(
                                                                            0xffffffff),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            "Roboto",
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        fontSize:
                                                                            10.0),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left),
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 1.5,
                                                                  bottom: 1.5,
                                                                  left: 8),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15)),
                                                              color: const Color(
                                                                  0xff571df0)))
                                                ]);
                                              }),
                                            ),
                                            // 恭喜你上热棒了：大家这次期末考的怎么样啊？
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(top: 2),
                                              child: Text("${content.value}",
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff6f6e6e),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "NotoSansSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 12.0),
                                                  textAlign: TextAlign.left),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 14),
                                              child: Text("${dateTime.value}",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff6f6e6e),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "Roboto",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 12.0),
                                                  textAlign: TextAlign.left),
                                            )
                                          ],
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(
                                          bottom: 10, left: 20, right: 20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          border: Border.all(
                                              color: const Color(0xffeaeaea),
                                              width: 1),
                                          color: const Color(0xffffffff))),
                                ),
                              );
                            });
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
              // margin: const EdgeInsets.symmetric(vertical: 14),
              padding: const EdgeInsets.all(14),
              child: Ink(
                child: InkWell(
                  onTap: () {
                    notiController.pageViewIndex.value = 0;
                  },
                  child: Text("消息",
                      style: TextStyle(
                          color: notiController.pageViewIndex.value == 1
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
              padding: const EdgeInsets.all(14),
              child:
                  // 私信
                  Ink(
                child: InkWell(
                  onTap: () {
                    notiController.pageViewIndex.value = 1;
                  },
                  child: Text("私信",
                      style: TextStyle(
                          color: notiController.pageViewIndex.value == 1
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

void checkNoti(NotiController notiController, int index) {
  String COMMUNITY_ID;
  String BOARD_ID;
  if (notiController.noties[index].value.NOTI_TYPE == 0) {
    COMMUNITY_ID = notiController.noties[index].value.URL.split("/")[1];
    BOARD_ID = notiController.noties[index].value.URL.split("/")[3];
    Get.toNamed("/board/${COMMUNITY_ID}/read/${BOARD_ID}");
  } else {
    Get.toNamed("/board/32/read/20");
  }
  if (!notiController.noties[index].value.isReaded) {
    notiController.noties[index].update((val) {
      val.isReaded = true;
    });
    notiController.setReadNotied(SaveNotiModel.fromJson({
      "NOTI_ID": notiController.noties[index].value.NOTI_ID,
      "LOOKUP_DATE": "${DateTime.now()}"
    }));
  }
}

void checkMail(NotiController notiController, int index) {
  Get.toNamed("/mail/${notiController.mailBox[index].value.MAIL_BOX_ID}");
  if (!notiController.mailBox[index].value.isReaded) {
    notiController.mailBox[index].update((val) {
      val.isReaded = true;
    });
    notiController.setReadMails(SaveMailBoxModel.fromJson({
      "MAIL_BOX_ID": notiController.mailBox[index].value.MAIL_BOX_ID,
      "MAIL_ID": notiController.mailBox[index].value.MAIL_ID,
      "LOOKUP_DATE": "${DateTime.now()}"
    }));
  }
}
