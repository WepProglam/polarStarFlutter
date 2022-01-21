import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/class/class_chat_controller.dart';
import 'package:polarstar_flutter/app/controller/loby/init_controller.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:polarstar_flutter/app/data/model/class/class_chat_model.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailSend_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/ui/android/functions/time_pretty.dart';

class ClassChatHistory extends StatelessWidget {
  final ClassChatController controller = Get.find();
  final commentWriteController = TextEditingController();
  final InitController initController = Get.find();
  @override
  Widget build(BuildContext context) {
    int chatIndex = initController.findChatHistory();
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   foregroundColor: Colors.black,
        //   elevation: 0,
        //   leading: Container(
        //     margin: const EdgeInsets.only(top: 8),
        //     child: InkWell(
        //       child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        //       onTap: () {
        //         Get.back();
        //       },
        //     ),
        //   ),
        //   actions: [
        //     PopupMenuButton<String>(
        //       padding: EdgeInsets.zero,
        //       icon: Container(
        //         margin: const EdgeInsets.only(top: 8, right: 8),
        //         height: 15.5,
        //         width: 19.2,
        //         child: Image.asset("assets/images/16_10.png"),
        //       ),
        //       //여기다 삭제 추가 신고 메서드 추가 필요
        //       onSelected: (String result) {
        //         switch (result) {
        //           case '전체 삭제하기':
        //             print('filter 1 clicked');
        //             break;
        //           case '차단하기':
        //             print('filter 2 clicked');
        //             break;
        //           case '신고하기':
        //             print('Clear filters');
        //             break;
        //           default:
        //         }
        //       },
        //       itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        //         const PopupMenuItem<String>(
        //           value: '전체 삭제하기',
        //           child: Text('전체 삭제하기'),
        //         ),
        //         const PopupMenuItem<String>(
        //           value: '차단하기',
        //           child: Text('차단하기'),
        //         ),
        //         const PopupMenuItem<String>(
        //           value: '신고하기',
        //           child: Text('신고하기'),
        //         ),
        //       ],
        //     ),
        //   ],
        //   leadingWidth: 35,
        //   titleSpacing: 0,
        //   title: Obx(() {
        //     return Container(
        //       margin: const EdgeInsets.only(top: 1.5),
        //       child: Row(children: [
        //         Text("nickname",
        //             style: const TextStyle(
        //                 color: const Color(0xff333333),
        //                 fontWeight: FontWeight.w700,
        //                 fontFamily: "PingFangSC",
        //                 fontStyle: FontStyle.normal,
        //                 fontSize: 21.0),
        //             textAlign: TextAlign.left),
        //       ]),
        //     );
        //   }),
        // ),
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
                    child: // 设置
                        Text("设置",
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            textAlign: TextAlign.center)),
              ),
              Positioned(
                // left: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(
                        'assets/images/891.png',
                        color: const Color(0xffffffff),
                        width: 12,
                        height: 24,
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   right: 0,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(
              //         vertical: 16, horizontal: 20),
              //     child: Ink(
              //       child: InkWell(
              //         onTap: () async {
              //           await Get.toNamed("/searchBoard")
              //               .then((value) async {
              //             await MainUpdateModule.updateBoard();
              //           });
              //         },
              //         child: Image.asset(
              //           'assets/images/icn_search.png',
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
        body: Obx(() {
          if (controller.dataAvailble.value) {
            if (controller.chatScrollController.hasClients) {
              Timer(Duration(milliseconds: 100), () {
                controller.chatScrollController.jumpTo(
                    controller.chatScrollController.position.maxScrollExtent);
              });
            }

            return ListView.builder(
              shrinkWrap: true,
              controller: controller.chatScrollController,
              itemCount:
                  initController.chatBox[chatIndex].value.ClassChatList.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(top: 24, bottom: 75),
              itemBuilder: (context, index) {
                Rx<ClassChatModel> model = initController
                    .chatBox[chatIndex].value.ClassChatList[index];
                bool MY_SELF = model.value.MY_SELF;
                //print(MY_SELF);
                return Container(
                    padding: (MY_SELF
                        // mailController.mailHistory[index].FROM_ME == 0
                        ? EdgeInsets.only(right: 20, bottom: 16)
                        : EdgeInsets.only(left: 20, bottom: 16)),
                    child: Align(
                      alignment: (MY_SELF
                          // mailController.mailHistory[index].FROM_ME == 0
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child:
                          // Text("${controller.chatHistory[index].CONTENT}"),
                          // child:
                          (MY_SELF
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                      // MAIL_PROFILE_ITEM(
                                      //   model: controller.chatHistory[index],
                                      //   FROM_ME: MY_SELF,
                                      // ),

                                      MAIL_CONTENT_ITEM(
                                        // mailController: mailController,
                                        model: model.value,
                                      )
                                    ])
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      MAIL_PROFILE_ITEM(
                                        model: model.value,
                                        FROM_ME: MY_SELF,
                                      ),
                                      MAIL_CONTENT_ITEM(
                                        model: model.value,
                                      ),
                                    ])),
                    ));
              },
            );
          } else {
            return Container(
              color: Colors.white,
            );
          }
        }),
        //입력창
        bottomSheet: Container(
          height: 60,
          decoration: BoxDecoration(color: const Color(0xffe6f1ff)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 20, right: 20),
                width: Get.mediaQuery.size.width - 20 - 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    border:
                        Border.all(color: const Color(0xffeaeaea), width: 1),
                    color: const Color(0xffffffff)),
                child: Row(children: [
                  Container(
                    margin: const EdgeInsets.only(left: 24),
                    width: Get.mediaQuery.size.width - 20 - 20 - 32 - 24,
                    child: GestureDetector(
                      onTap: () {
                        controller.chatScrollController.jumpTo(controller
                            .chatScrollController.position.maxScrollExtent);
                      },
                      child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          onTap: () async {
                            // controller.chatScrollController.jumpTo(controller
                            //     .chatScrollController.position.maxScrollExtent);
                            await Future.delayed(Duration(milliseconds: 1000));
                            controller.chatScrollController.animateTo(
                                controller.chatScrollController.position
                                    .maxScrollExtent,
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.fastOutSlowIn);
                          },
                          onEditingComplete: () async {
                            // initController
                            //     .sendMessage(commentWriteController.text);
                            // commentWriteController.clear();

                            // double max_hight = initController
                            //     .chatScrollController
                            //     .value
                            //     .position
                            //     .maxScrollExtent;

                            // initController.chatScrollController.value
                            //     .jumpTo(max_hight);
                          },
                          maxLines: 1,
                          controller: commentWriteController,
                          style: const TextStyle(
                              color: const Color(0xff2f2f2f),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          onFieldSubmitted: (value) {},
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: "你好吗，麦克斯？",
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                                color: const Color(0xff9b9b9b),
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                          )),
                    ),
                  ),
                  InkWell(
                      child: // 타원 20
                          Container(
                              width: 28,
                              height: 28,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: const Color(0xffffffff),
                                ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Get.theme.primaryColor,
                              )),
                      onTap: () async {
                        String text = commentWriteController.text;
                        initController.sendMessage(commentWriteController.text);

                        commentWriteController.clear();
                      }),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MAIL_PROFILE_ITEM extends StatelessWidget {
  const MAIL_PROFILE_ITEM(
      {Key key, @required this.model, @required this.FROM_ME})
      : super(key: key);

  final ClassChatModel model;
  final bool FROM_ME;
  @override
  Widget build(BuildContext context) {
    print("pf: ${model.PROFILE_PHOTO}");
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: 32,
          height: 32,
          child: CachedNetworkImage(
            imageUrl: "${model.PROFILE_PHOTO}",
            imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover))),
          ),
        ),
        Center(
            child: Text(
          "${model.PROFILE_NICKNAME}",
          style: const TextStyle(
              color: Color(0xff2f2f2f),
              fontWeight: FontWeight.w400,
              fontFamily: "NotoSansSC",
              fontStyle: FontStyle.normal,
              fontSize: 10.0),
        ))
      ]),
    );
  }
}

class MAIL_CONTENT_ITEM extends StatelessWidget {
  const MAIL_CONTENT_ITEM({Key key, @required this.model}) : super(key: key);

  final ClassChatModel model;

  @override
  Widget build(BuildContext context) {
    print(model.MY_SELF);
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      model.MY_SELF
          ? Container(
              margin: const EdgeInsets.only(right: 8),
              child: Text("${prettyDate(model.TIME_CREATED)}",
                  style: const TextStyle(
                      color: const Color(0xffd6d4d4),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 10.0),
                  textAlign: TextAlign.right),
            )
          : Container(),
      Container(
          constraints: BoxConstraints(maxWidth: 260),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft:
                      model.MY_SELF ? Radius.circular(36) : Radius.circular(0),
                  topRight:
                      model.MY_SELF ? Radius.circular(0) : Radius.circular(36),
                  bottomRight: Radius.circular(36),
                  bottomLeft: Radius.circular(36)),
              color: model.MY_SELF
                  ? const Color(0xffe6f1ff)
                  : const Color(0xfff5f5f5)),
          child: Container(
              padding:
                  EdgeInsets.only(left: 16, top: 10, right: 24, bottom: 10),
              child: Text("${model.CONTENT}",
                  style: const TextStyle(
                      color: const Color(0xff2f2f2f),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left))),
      model.MY_SELF
          ? Container()
          : Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text("${prettyDate(model.TIME_CREATED)}",
                  style: const TextStyle(
                      color: const Color(0xffd6d4d4),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 10.0),
                  textAlign: TextAlign.right),
            ),
    ]);
  }
}
