import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/modules/classChat/class_chat_controller.dart';
import 'package:polarstar_flutter/app/modules/init_page/init_controller.dart';

import 'package:polarstar_flutter/app/modules/mailHistory/mail_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/noti/noti_controller.dart';

import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/modules/claa_view/widgets/app_bars.dart';
import 'package:polarstar_flutter/app/global_functions/board_name.dart';
import 'package:polarstar_flutter/app/global_functions/time_pretty.dart';
import 'package:polarstar_flutter/app/global_widgets/banner_widget.dart';

import 'package:polarstar_flutter/app/global_widgets/dialoge.dart';
import 'package:webview_flutter/webview_flutter.dart';

final box = GetStorage();

class Noti extends StatelessWidget {
  Noti({
    Key key,
  }) : super(key: key);
  final MainController mainController = Get.find();
  final NotiController notiController = Get.find();
  final ClassChatController classChatController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 56,

      //   backgroundColor: Get.theme.primaryColor,
      //   titleSpacing: 0,
      //   // elevation: 0,
      //   automaticallyImplyLeading: false,

      //   title: Center(
      //     child: Container(
      //       margin: const EdgeInsets.symmetric(vertical: 16.5),
      //       child: Text(
      //         "消息",
      //         style: const TextStyle(
      //             color: const Color(0xffffffff),
      //             fontWeight: FontWeight.w500,
      //             fontFamily: "NotoSansSC",
      //             fontStyle: FontStyle.normal,
      //             fontSize: 14.0),
      //       ),
      //     ),
      //   ),
      // ),
      backgroundColor: const Color(0xffffffff),
      body: Container(
        margin: const EdgeInsets.only(top: 12),
        child: RefreshIndicator(
          onRefresh: () async {
            await MainUpdateModule.updateNotiPage(0);
          },
          child: NotiWidget(notiController: notiController),
        ),
      ),
    );
  }
}

class MailWidget extends StatelessWidget {
  const MailWidget({
    Key key,
    @required this.notiController,
  }) : super(key: key);

  final NotiController notiController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        itemCount:
            notiController.mailBox.isEmpty ? 1 : notiController.mailBox.length,
        itemBuilder: (context, index) {
          if (notiController.mailBox.isEmpty) {
            return Center(
              child: Text(
                "目前还没有新的私信",
                style: const TextStyle(
                    color: const Color(0xff6f6e6e),
                    fontWeight: FontWeight.w400,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
              ),
            );
          }

          // return NotiPreview(
          //   notiController: notiController,
          //   title: title,
          //   content: content,
          //   dateTime: dateTime,
          //   index: index,
          // );
          return Ink(
            child: InkWell(
              onTap: () async {
                await checkMail(notiController, index);
              },
              child: Obx(() {
                Rx<MailBoxModel> model = notiController.mailBox[index];
                RxString title = model.value.PROFILE_NICKNAME.obs;

                RxString content = "${model.value.CONTENT}".obs;

                RxString dateTime =
                    "${prettyDate(model.value.TIME_CREATED)}".obs;

                bool isReaded = model.value.isReaded;
                return Container(
                  // height: 83,
                  color: model.value.isReaded
                      ? const Color(0xfff7fbff)
                      : const Color(0xffffffff),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: MailTop(title: title, dateTime: dateTime),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.only(top: 3),
                        child: // 在校生交流区
                            MailBody(model: model),
                      ),
                      // 선 87
                      Container(
                          margin: const EdgeInsets.only(top: 21),
                          height: 1,
                          decoration:
                              BoxDecoration(color: const Color(0xffeaeaea)))
                    ],
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

class MailBody extends StatelessWidget {
  const MailBody({Key key, @required this.model}) : super(key: key);

  final Rx<MailBoxModel> model;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Text("${model.value.CONTENT}",
              style: const TextStyle(
                  color: const Color(0xff6f6e6e),
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
        ),
        Spacer(),
        model.value.isReaded
            ? Container(
                child: Image.asset("assets/images/right_arrow.png",
                    width: 16, height: 16))
            : Container(
                width: 16,
                height: 16,
                child: Center(
                  child: Text("N",
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 9.0),
                      textAlign: TextAlign.left),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Get.theme.primaryColor),
              ),
      ],
    );
  }
}

class MailTop extends StatelessWidget {
  const MailTop({
    Key key,
    @required this.title,
    @required this.dateTime,
  }) : super(key: key);

  final RxString title;
  final RxString dateTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Text("${title}",
              style: const TextStyle(
                  color: const Color(0xff2f2f2f),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left),
        ),
        Spacer(),
        Container(
          margin: const EdgeInsets.only(bottom: 4.5),
          child: Text("${dateTime}",
              style: const TextStyle(
                  color: const Color(0xff9b9b9b),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 10.0),
              textAlign: TextAlign.right),
        )
      ],
    );
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key key,
    @required this.notiController,
    @required this.classChatController,
  }) : super(key: key);

  final NotiController notiController;
  final ClassChatController classChatController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * 전공별 단톡방
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text("专业群聊",
                  style: const TextStyle(
                      color: const Color(0xff2f2f2f),
                      fontWeight: FontWeight.w500,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                  textAlign: TextAlign.left),
            ),
            ListView.builder(
                itemCount: classChatController.majorChatBox.isEmpty
                    ? 1
                    : classChatController.majorChatBox.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (classChatController.majorChatBox.length == 0) {
                    return Center(
                      child: Text(
                        "目前还没有已加入的群聊",
                        style: const TextStyle(
                            color: const Color(0xff6f6e6e),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                    );
                  }
                  Rx<ChatBoxModel> model =
                      classChatController.majorChatBox[index];

                  // * 채팅방 UI
                  return ChatItem(model: model, isClass: 0);
                }),

            // * 강의별 단톡방
            Container(
                margin: const EdgeInsets.only(left: 20, top: 35.5),
                child: Text("课程群聊",
                    style: const TextStyle(
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left)),
            ListView.builder(
                itemCount: classChatController.classChatBox.isEmpty
                    ? 1
                    : classChatController.classChatBox.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (classChatController.classChatBox.length == 0) {
                    return Center(
                      child: Text(
                        "目前还没有已加入的群聊",
                        style: const TextStyle(
                            color: const Color(0xff6f6e6e),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                    );
                  }
                  Rx<ChatBoxModel> model =
                      classChatController.classChatBox[index];

                  // * 채팅방 UI
                  return ChatItem(model: model, isClass: 1);
                }),
          ],
        ),
      );
    });
  }
}

class NotiWidget extends StatelessWidget {
  const NotiWidget({
    Key key,
    @required this.notiController,
  }) : super(key: key);

  final NotiController notiController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
        shrinkWrap: true,
        itemCount:
            notiController.noties.isEmpty ? 1 : notiController.noties.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (notiController.noties.length == 0) {
            return Center(
              child: Text(
                "目前还没有新的通知",
                style: const TextStyle(
                    color: const Color(0xff6f6e6e),
                    fontWeight: FontWeight.w400,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
              ),
            );
          }

          RxString title = (notiController.noties[index].value.NOTI_TYPE == 0
              ? "${communityBoardName(notiController.noties[index].value.COMMUNITY_ID)}"
                  .obs
              : "${notiController.noties[index].value.TITLE}".obs);

          RxString content =
              "${notiController.noties[index].value.CONTENT}".obs;

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
        }));
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({Key key, @required this.model, this.isClass})
      : super(key: key);
  final isClass;
  final Rx<ChatBoxModel> model;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Ink(
        color: model.value.UNREAD_AMOUNT == 0
            ? const Color(0xfff7fbff)
            : Color(0xffffffff),
        child: InkWell(
          onTap: () async {
            final ClassChatController classChatController = Get.find();
            // Map<String, dynamic> chatMeta =
            //     classChatController.findChatHistory();

            // // int chatIndex = model.value.BOX_ID;
            // // bool isClass = model.value.;
            // // Rx<ChatBoxModel> box_model = isClass
            // //     ? classChatController.classChatBox[chatIndex]
            // //     : classChatController.majorChatBox[chatIndex];
            // for (Rx<ChatModel> item in model.value.ChatList) {
            //   if (item.value.PHOTO != null && item.value.PHOTO.length > 0) {
            //     await precacheImage(item.value.PRE_IMAGE[0], context);
            //   }
            // }

            print("============================");
            print("${model.value.BOX_ID}");
            await Get.toNamed(Routes.CLASSCHAT,
                    arguments: {"roomID": "${model.value.BOX_ID}"})
                .then((value) async {
              classChatController.dataAvailble.value = false;

              // * 채팅방 나갈때 보내는걸로 수정
              if (isClass == 1) {
                await classChatController.readClassChat(model.value.BOX_ID);
              } else {
                await classChatController.readMajorChat(model.value.BOX_ID);
              }

              // // * 가장 마지막으로 읽은 class_id 등록
              // if (model.value.ChatList.length != 0) {
              //   await box.write("LastChat_${model.value.BOX_ID}",
              //       model.value.ChatList.last.value.CHAT_ID);
              // }

              MainUpdateModule.updateNotiPage(1,
                  curClassID: model.value.BOX_ID);
            });
          },
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Obx(() {
                  return Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        child:
                            Image.asset("assets/images/class_chat_profile.png"),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.mediaQuery.size.width - 135,
                                child: Text(
                                    model.value.CLASS_PROFESSOR == null
                                        ? "${model.value.BOX_NAME}"
                                        : "${model.value.BOX_NAME}-${model.value.CLASS_PROFESSOR}",
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
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                            overflow: TextOverflow.clip,
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
                              model.value.UNREAD_AMOUNT == 0
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 9),
                                      child: Image.asset(
                                          "assets/images/right_arrow.png",
                                          width: 16,
                                          height: 16))
                                  : Container(
                                      width: 16,
                                      height: 16,
                                      child: Center(
                                        child: FittedBox(
                                          child: Text(
                                            "${model.value.UNREAD_AMOUNT}",
                                            style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 10.0),
                                          ),
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(top: 9),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Get.theme.primaryColor),
                                    )
                            ]),
                      ),
                      // 선 21
                    ],
                  );
                }),
              ),
              Container(
                  height: 1,
                  decoration: BoxDecoration(color: const Color(0xffeaeaea)))
            ],
          ),
        ),
      );
    });
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
          await checkNoti(notiController, index);
        },
        child: Obx(() {
          RxBool isReaded = notiController.noties[index].value.isReaded.obs;
          return Container(
            decoration: BoxDecoration(
                color: isReaded.value ? Color(0xfff7fbff) : Color(0xffffffff)),
            child: Container(
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Obx(() {
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
                                                  color:
                                                      const Color(0xffffffff),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 10.0),
                                              textAlign: TextAlign.left),
                                    ),
                                    margin: const EdgeInsets.only(
                                        top: 1.5, bottom: 1.5, left: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        color: Get.theme.primaryColor)),
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
                // 선 21
                Container(
                    height: 1,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(color: const Color(0xffeaeaea)))
              ]),
            ),
          );
        }),
      ),
    );
  }
}

// class NotiMailSelect extends StatelessWidget {
//   const NotiMailSelect({
//     Key key,
//     @required this.notiController,
//   }) : super(key: key);

//   final NotiController notiController;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 48,
//       color: const Color(0xff2f2f2f),
//       child: Obx(() {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // * 알림
//             Container(
//               // margin: const EdgeInsets.symmetric(vertical: 14),
//               padding: const EdgeInsets.all(14),
//               child: Ink(
//                 child: InkWell(
//                   onTap: () {
//                     notiController.pageViewIndex.value = 0;
//                   },
//                   child: Text("消息",
//                       style: TextStyle(
//                           color: notiController.pageViewIndex.value == 0
//                               ? Color(0xff9b75ff)
//                               : Color(0xffffffff),
//                           fontWeight: FontWeight.w500,
//                           fontFamily: "NotoSansSC",
//                           fontStyle: FontStyle.normal,
//                           fontSize: 14.0),
//                       textAlign: TextAlign.left),
//                 ),
//               ),
//             ),
//             Container(
//                 width: 1,
//                 height: 16,
//                 decoration: BoxDecoration(color: const Color(0xff535353))),
//             // * 단톡방
//             Container(
//               // margin: const EdgeInsets.symmetric(vertical: 14),
//               padding: const EdgeInsets.all(14),
//               child: Ink(
//                 child: InkWell(
//                   onTap: () {
//                     notiController.pageViewIndex.value = 1;
//                   },
//                   child: Text("聊天群",
//                       style: TextStyle(
//                           color: notiController.pageViewIndex.value == 1
//                               ? Color(0xff9b75ff)
//                               : Color(0xffffffff),
//                           fontWeight: FontWeight.w500,
//                           fontFamily: "NotoSansSC",
//                           fontStyle: FontStyle.normal,
//                           fontSize: 14.0),
//                       textAlign: TextAlign.left),
//                 ),
//               ),
//             ),
//             Container(
//                 width: 1,
//                 height: 16,
//                 decoration: BoxDecoration(color: const Color(0xff535353))),
//             // * 쪽지함
//             Container(
//               padding: const EdgeInsets.all(14),
//               child:
//                   // 私信
//                   Ink(
//                 child: InkWell(
//                   onTap: () {
//                     notiController.pageViewIndex.value = 2;
//                   },
//                   child: Text("私信",
//                       style: TextStyle(
//                           color: notiController.pageViewIndex.value == 2
//                               ? Color(0xff9b75ff)
//                               : Color(0xffffffff),
//                           fontWeight: FontWeight.w500,
//                           fontFamily: "NotoSansSC",
//                           fontStyle: FontStyle.normal,
//                           fontSize: 14.0),
//                       textAlign: TextAlign.left),
//                 ),
//               ),
//             )
//           ],
//         );
//       }),
//     );
//   }
// }

void checkNoti(NotiController notiController, int index) async {
  String COMMUNITY_ID;
  String BOARD_ID;
  switch (notiController.noties[index].value.NOTI_TYPE) {
    case 0:
      COMMUNITY_ID = notiController.noties[index].value.URL.split("/")[1];
      BOARD_ID = notiController.noties[index].value.URL.split("/")[3];
      await Get.toNamed("/board/${COMMUNITY_ID}/read/${BOARD_ID}")
          .then((value) async {
        await MainUpdateModule.updateNotiPage(0);
      });
      break;
    case 3:
      if (notiController.noties[index].value.URL == null ||
          notiController.noties[index].value.URL.isEmpty) {
        Textdialogue(Get.context, notiController.noties[index].value.TITLE,
            notiController.noties[index].value.CONTENT);
      } else {
        Get.to(Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: Scaffold(
              appBar: AppBars().WebViewAppBar(),
              body: WebView(
                initialUrl: notiController.noties[index].value.URL,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ),
        ));
      }
      break;
    case 4:
      if (notiController.noties[index].value.URL == null ||
          notiController.noties[index].value.URL.isEmpty) {
        Textdialogue(Get.context, notiController.noties[index].value.TITLE,
            notiController.noties[index].value.CONTENT);
      } else {
        Get.to(Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: Scaffold(
              appBar: AppBars().WebViewAppBar(),
              body: WebView(
                initialUrl: notiController.noties[index].value.URL,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ),
        ));
      }
      break;
    case 8:
      COMMUNITY_ID = notiController.noties[index].value.URL.split("/")[1];
      BOARD_ID = notiController.noties[index].value.URL.split("/")[3];
      await Get.toNamed("/board/${COMMUNITY_ID}/read/${BOARD_ID}")
          .then((value) async {
        await MainUpdateModule.updateNotiPage(0);
      });
      break;
    default:
      break;
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
    await MainUpdateModule.updateNotiPage(2);
  });
  if (!notiController.mailBox[index].value.isReaded) {
    print("!!");
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
