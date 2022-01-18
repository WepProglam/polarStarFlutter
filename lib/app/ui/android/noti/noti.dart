import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
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
              height: 24,
            ),
            Expanded(
              child: Obx(() {
                RxBool isNotiPage =
                    (notiController.pageViewIndex.value == 0).obs;

                return PageView.builder(
                    itemCount: 3,
                    controller: notiController.pageController,
                    onPageChanged: (index) {
                      print(index);
                      notiController.pageViewIndex.value = index;
                    },
                    itemBuilder: (BuildContext context, int i) {
                      if (isNotiPage.value && i == 0) {
                        return RefreshIndicator(
                            onRefresh: () async {
                              await MainUpdateModule.updateNotiPage(
                                  notiController.pageViewIndex.value);
                            },
                            child: Obx(() => ListView.builder(
                                shrinkWrap: true,
                                itemCount: notiController.noties.isEmpty
                                    ? 1
                                    : notiController.noties.length,
                                itemBuilder: (context, index) {
                                  if (notiController.noties.length == 0) {
                                    return Center(
                                      child: Text(
                                        "아직 알림이 없습니다.",
                                        style: const TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                      ),
                                    );
                                  }

                                  RxString title = (notiController
                                              .noties[index].value.NOTI_TYPE ==
                                          0
                                      ? "${communityBoardName(notiController.noties[index].value.COMMUNITY_ID)}"
                                          .obs
                                      : "${notiController.noties[index].value.TITLE}"
                                          .obs);

                                  RxString content =
                                      "${notiController.noties[index].value.CONTENT}"
                                          .obs;

                                  RxString dateTime =
                                      "${prettyDate(notiController.noties[index].value.TIME_CREATED)}"
                                          .obs;

                                  return NotiPreview(
                                    notiController: notiController,
                                    title: title,
                                    content: content,
                                    dateTime: dateTime,
                                    index: index,
                                  );
                                })));
                      } else if (i == 1) {
                        // ! 단톡방으로 수정
                        return RefreshIndicator(onRefresh: () async {
                          await MainUpdateModule.updateNotiPage(
                              notiController.pageViewIndex.value);
                        }, child: Obx(() {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Text("战功课",
                                      style: const TextStyle(
                                          color: const Color(0xff2f2f2f),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "NotoSansSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.left),
                                ),
                                // * 강의별 단톡방
                                RefreshIndicator(
                                  displacement: 0.0,
                                  color: Get.theme.primaryColor,
                                  onRefresh: () async {
                                    await MainUpdateModule.updateNotiPage(
                                        notiController.pageViewIndex.value);
                                  },
                                  child: ListView.builder(
                                      itemCount: notiController.chatBox.isEmpty
                                          ? 1
                                          : notiController.chatBox.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (notiController.chatBox.length ==
                                            0) {
                                          return Center(
                                            child: Text(
                                              "아직 채팅이 없습니다.",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff6f6e6e),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "NotoSansKR",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                            ),
                                          );
                                        }
                                        Rx<ChatBoxModel> model =
                                            notiController.chatBox[index];
                                        // * 채팅방 UI
                                        return ChatItem(model: model);
                                      }),
                                )
                              ],
                            ),
                          );
                        }));
                      } else {
                        return RefreshIndicator(
                            onRefresh: () async {
                              await MainUpdateModule.updateNotiPage(
                                  notiController.pageViewIndex.value);
                            },
                            child: Obx(() => ListView.builder(
                                shrinkWrap: true,
                                itemCount: notiController.mailBox.isEmpty
                                    ? 1
                                    : notiController.mailBox.length,
                                itemBuilder: (context, index) {
                                  if (notiController.mailBox.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "아직 쪽지가 없습니다.",
                                        style: const TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                      ),
                                    );
                                  }
                                  RxString title = notiController.mailBox[index]
                                      .value.PROFILE_NICKNAME.obs;

                                  RxString content =
                                      "${notiController.mailBox[index].value.CONTENT}"
                                          .obs;

                                  RxString dateTime =
                                      "${prettyDate(notiController.mailBox[index].value.TIME_CREATED)}"
                                          .obs;
                                  return NotiPreview(
                                    notiController: notiController,
                                    title: title,
                                    content: content,
                                    dateTime: dateTime,
                                    index: index,
                                  );
                                })));
                      }
                    });
              }),
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

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key key,
    @required this.model,
  }) : super(key: key);

  final Rx<ChatBoxModel> model;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: () async {
          await Get.toNamed(Routes.CLASSCHAT,
              arguments: {"roomID": "${model.value.CLASS_ID}"}).then((value) {
            MainUpdateModule.updateNotiPage(1);
          });
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    child: Image.asset("assets/images/class_chat_profile.png"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.mediaQuery.size.width - 135,
                          child: Text(
                              "${model.value.CLASS_NAME}-${model.value.CLASS_PROFESSOR}ffffffffffffffffffffffffffffffffffffdfddddddddddddd",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: const TextStyle(
                                  color: const Color(0xff2f2f2f),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansKR",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          child: // 在校生交流区
                              Text("${model.value.LAST_CHAT}",
                                  style: const TextStyle(
                                      color: const Color(0xff9b9b9b),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                  textAlign: TextAlign.left),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              model.value.TIME_LAST_CHAT_SENDED != null
                                  ? "${prettyDate(model.value.TIME_LAST_CHAT_SENDED)}"
                                  : "",
                              style: const TextStyle(
                                  color: const Color(0xff9b9b9b),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 10.0),
                              textAlign: TextAlign.right),
                          Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Get.theme.primaryColor),
                          )
                        ]),
                  ),
                  // 선 21
                ],
              ),
            ),
            Container(
                height: 1,
                decoration: BoxDecoration(color: const Color(0xffeaeaea)))
          ],
        ),
      ),
    );
  }
}

class NotiPreview extends StatelessWidget {
  const NotiPreview({
    Key key,
    @required this.notiController,
    @required this.title,
    @required this.content,
    @required this.dateTime,
    @required this.index,
  }) : super(key: key);

  final NotiController notiController;
  final RxString title;
  final RxString content;
  final RxString dateTime;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: () async {
          await checkMail(notiController, index);
        },
        child: Container(
            height: 80,
            child: Container(
              margin: const EdgeInsets.only(left: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Obx(() {
                      RxBool isReaded =
                          notiController.noties[index].value.isReaded.obs;
                      return Row(children: [
                        Text("${title.value}",
                            maxLines: 1,
                            style: const TextStyle(
                                color: const Color(0xff2f2f2f),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left),
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
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Roboto",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 10.0),
                                          textAlign: TextAlign.left),
                                ),
                                margin: const EdgeInsets.only(
                                    top: 1.5, bottom: 1.5, left: 8),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: const Color(0xff571df0))),
                        Spacer(),
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Text("${dateTime.value}",
                              style: const TextStyle(
                                  color: const Color(0xff6f6e6e),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.left),
                        )
                      ]);
                    }),
                  ),
                  // 恭喜你上热棒了：大家这次期末考的怎么样啊？
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    child: Text("${content.value}",
                        maxLines: 1,
                        style: const TextStyle(
                            color: const Color(0xff6f6e6e),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),
            margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: const Color(0xffeaeaea), width: 1),
                color: const Color(0xffffffff))),
      ),
    );
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
            // * 알림
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
            ),
            Container(
                width: 1,
                height: 16,
                decoration: BoxDecoration(color: const Color(0xff535353))),
            // * 단톡방
            Container(
              // margin: const EdgeInsets.symmetric(vertical: 14),
              padding: const EdgeInsets.all(14),
              child: Ink(
                child: InkWell(
                  onTap: () {
                    notiController.pageViewIndex.value = 1;
                  },
                  child: Text("聊天群",
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
            ),
            Container(
                width: 1,
                height: 16,
                decoration: BoxDecoration(color: const Color(0xff535353))),
            // * 쪽지함
            Container(
              padding: const EdgeInsets.all(14),
              child:
                  // 私信
                  Ink(
                child: InkWell(
                  onTap: () {
                    notiController.pageViewIndex.value = 2;
                  },
                  child: Text("私信",
                      style: TextStyle(
                          color: notiController.pageViewIndex.value == 2
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

void checkNoti(NotiController notiController, int index) async {
  String COMMUNITY_ID;
  String BOARD_ID;
  if (notiController.noties[index].value.NOTI_TYPE == 0) {
    COMMUNITY_ID = notiController.noties[index].value.URL.split("/")[1];
    BOARD_ID = notiController.noties[index].value.URL.split("/")[3];
    await Get.toNamed("/board/${COMMUNITY_ID}/read/${BOARD_ID}")
        .then((value) async {
      await MainUpdateModule.updateNotiPage(0);
    });
  } else {
    await Get.toNamed("/board/32/read/20").then((value) async {
      await MainUpdateModule.updateNotiPage(0);
    });
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

void checkMail(NotiController notiController, int index) async {
  await Get.toNamed("/mail/${notiController.mailBox[index].value.MAIL_BOX_ID}")
      .then((value) async {
    await MainUpdateModule.updateNotiPage(1);
  });
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
