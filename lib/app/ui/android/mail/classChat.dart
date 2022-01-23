import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final double chatHeight =
        box.read("keyBoardHeight") == null ? 342.0 : box.read("keyBoardHeight");

    int chatIndex = initController.findChatHistory();
    print("build!!");
    return WillPopScope(
      onWillPop: () async {
        initController.tapTextField.value = false;
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          resizeToAvoidBottomInset: false,
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                initController.chatScrollController.jumpTo(initController
                    .chatScrollController.position.maxScrollExtent);
              });

              return GestureDetector(
                onTap: () {
                  initController.canChatFileShow.value = false;
                  initController.tapTextField.value = false;
                  initController.chatFocusNode.unfocus();
                  // FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  controller: initController.chatScrollController,
                  child: Column(children: [
                    ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        Rx<ClassChatModel> model = initController
                            .chatBox[chatIndex].value.ClassChatList[index];
                        Rx<ClassChatModel> prevModel;
                        Rx<ClassChatModel> nextModel;
                        if (index - 1 < 0) {
                          prevModel = null;
                        } else {
                          prevModel = initController.chatBox[chatIndex].value
                              .ClassChatList[index - 1];
                        }

                        if (index + 1 >=
                            initController.chatBox[chatIndex].value
                                .ClassChatList.length) {
                          nextModel = null;
                        } else {
                          nextModel = initController.chatBox[chatIndex].value
                              .ClassChatList[index + 1];
                        }
                        bool showLine = ((nextModel != null) &&
                            (nextModel.value.TIME_CREATED.day !=
                                model.value.TIME_CREATED.day));
                        // print(
                        //     "${index} => ${model.value.TIME_CREATED.toString()}");
                        return showLine
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // 선 77
                                      Container(
                                          height: 1,
                                          width: Get.mediaQuery.size.width,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffeaeaea))),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14.5),
                                        color: Colors.white,
                                        child: Text(
                                            "${model.value.TIME_CREATED.year}年${model.value.TIME_CREATED.month}月${model.value.TIME_CREATED.day}日",
                                            style: const TextStyle(
                                                color: const Color(0xff9b9b9b),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "NotoSansSC",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 10.0),
                                            textAlign: TextAlign.center),
                                      ),
                                    ]),
                              )
                            : Container();
                      },
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: initController
                          .chatBox[chatIndex].value.ClassChatList.length,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(
                          top: 24,
                          bottom: initController.tapTextField.value
                              ? 60 + 6.0 + chatHeight
                              : 60 + 6.0),
                      itemBuilder: (context, index) {
                        Rx<ClassChatModel> model = initController
                            .chatBox[chatIndex].value.ClassChatList[index];

                        Rx<ClassChatModel> prevModel;
                        Rx<ClassChatModel> nextModel;
                        if (index - 1 < 0) {
                          prevModel = null;
                        } else {
                          prevModel = initController.chatBox[chatIndex].value
                              .ClassChatList[index - 1];
                        }

                        if (index + 1 >=
                            initController.chatBox[chatIndex].value
                                .ClassChatList.length) {
                          nextModel = null;
                        } else {
                          nextModel = initController.chatBox[chatIndex].value
                              .ClassChatList[index + 1];
                        }

                        bool MY_SELF = model.value.MY_SELF;

                        bool isContinueSame = (prevModel != null &&
                            prevModel.value.PROFILE_NICKNAME ==
                                model.value.PROFILE_NICKNAME &&
                            prevModel.value.PROFILE_PHOTO ==
                                model.value.PROFILE_PHOTO);

                        bool isContinueDifferent = (prevModel != null &&
                            prevModel.value.PROFILE_NICKNAME !=
                                model.value.PROFILE_NICKNAME &&
                            prevModel.value.PROFILE_PHOTO !=
                                model.value.PROFILE_PHOTO);

                        /**
                         * displayTime: 시간 표시 boolean
                         * 앞 사람이 다른 사람일때 - isContinueDifferent
                         * 앞 사람이 같은 사람이고 이 채팅이 해당 시간에 쓴 마지막일때
                         * 맨 마지막 톡 일때
                         */
                        bool isChatSamePersonEnd = (nextModel != null &&
                                nextModel.value.PROFILE_NICKNAME !=
                                    model.value.PROFILE_NICKNAME &&
                                nextModel.value.PROFILE_PHOTO !=
                                    model.value.PROFILE_PHOTO) ||
                            nextModel == null;

                        bool lastChatInTime = (nextModel != null &&
                                (nextModel.value.TIME_CREATED.day !=
                                        model.value.TIME_CREATED.day ||
                                    nextModel.value.TIME_CREATED.hour !=
                                        model.value.TIME_CREATED.hour ||
                                    nextModel.value.TIME_CREATED.minute !=
                                        model.value.TIME_CREATED.minute)) ||
                            nextModel == null;

                        bool firstChatInTime = (prevModel != null &&
                                (prevModel.value.TIME_CREATED.day !=
                                        model.value.TIME_CREATED.day ||
                                    prevModel.value.TIME_CREATED.hour !=
                                        model.value.TIME_CREATED.hour ||
                                    prevModel.value.TIME_CREATED.minute !=
                                        model.value.TIME_CREATED.minute)) ||
                            prevModel == null;

                        bool displayTime =
                            isChatSamePersonEnd || lastChatInTime;

                        bool showProfile = prevModel == null ||
                            isContinueDifferent ||
                            firstChatInTime;

                        // bool isTimeDifferent = (isContinueSame &&
                        //         (prevModel.value.TIME_CREATED.day !=
                        //                 model.value.TIME_CREATED.day ||
                        //             prevModel.value.TIME_CREATED.hour !=
                        //                 model.value.TIME_CREATED.hour ||
                        //             prevModel.value.TIME_CREATED.minute !=
                        //                 model.value.TIME_CREATED.minute)) ||
                        //     isContinueDifferent ||
                        //     prevModel == null;

                        return Container(
                            padding: (prevModel == null
                                ? MY_SELF
                                    ? EdgeInsets.only(right: 20, top: 0)
                                    : EdgeInsets.only(left: 20, top: 0)
                                : MY_SELF
                                    ? EdgeInsets.only(
                                        right: 20, top: isContinueSame ? 6 : 24)
                                    : EdgeInsets.only(
                                        left: 20, top: showProfile ? 24 : 6)),
                            child: Align(
                              alignment: (MY_SELF
                                  ? Alignment.topRight
                                  : Alignment.topLeft),
                              child: (MY_SELF
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                          MAIL_CONTENT_ITEM(
                                            model: model.value,
                                            isTimeDifferent: displayTime,
                                          )
                                        ])
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          showProfile
                                              ? MAIL_PROFILE_ITEM(
                                                  model: model.value,
                                                  FROM_ME: MY_SELF,
                                                )
                                              : Container(
                                                  width: 42,
                                                ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                showProfile
                                                    ? Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 4),
                                                        child: Text(
                                                            "${model.value.PROFILE_NICKNAME}",
                                                            style: const TextStyle(
                                                                color: const Color(
                                                                    0xff6f6e6e),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "NotoSansSC",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 10.0),
                                                            textAlign:
                                                                TextAlign.left),
                                                      )
                                                    : Container(),
                                                MAIL_CONTENT_ITEM(
                                                    model: model.value,
                                                    isTimeDifferent:
                                                        displayTime),
                                              ]),
                                        ])),
                            ));
                      },
                    ),
                  ]),
                ),
              );
            } else {
              return Container(
                color: Colors.white,
              );
            }
          }),
          //입력창
          bottomSheet: Obx(() {
            // print(MediaQuery.of(context).viewInsets.bottom);
            // final inputHeight = box.read("keyBoardHeight");
            // if (MediaQuery.of(context).viewInsets.bottom == 0) {
            //   initController.tapTextField.value = false;
            //   print("??");
            // }
            if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
              print("keyboard visivle");
            } else {
              print("keyboard unvisivle");
            }
            return Container(
              height: initController.tapTextField.value
                  ? 60.0 + box.read("keyBoardHeight")
                  : 60,
              decoration: BoxDecoration(color: const Color(0xffe6f1ff)),
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: Get.mediaQuery.size.width - 20 - 20,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                color: const Color(0xffeaeaea), width: 1),
                            color: const Color(0xffffffff)),
                        child: Row(children: [
                          Container(
                            margin: const EdgeInsets.only(left: 24),
                            // width: Get.mediaQuery.size.width - 150,
                            width:
                                Get.mediaQuery.size.width - 20 - 16 - 70 - 20,
                            child: GestureDetector(
                              onTap: () {
                                initController.chatScrollController.jumpTo(
                                    initController.chatScrollController.position
                                        .maxScrollExtent);
                              },
                              child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  focusNode: initController.chatFocusNode,
                                  onTap: () async {
                                    initController.tapTextField.value = true;
                                    initController.canChatFileShow.value =
                                        false;
                                    Timer(Duration(milliseconds: 100), () {
                                      initController.chatScrollController
                                          .jumpTo(
                                        initController.chatScrollController
                                            .position.maxScrollExtent,
                                      );
                                      // initController.chatScrollController.animateTo(
                                      //     initController.chatScrollController.position
                                      //         .maxScrollExtent,
                                      //     duration: Duration(milliseconds: 100),
                                      //     curve: Curves.fastOutSlowIn);
                                    });
                                    initController.chatScrollController.jumpTo(
                                      initController.chatScrollController
                                          .position.maxScrollExtent,
                                    );
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
                                      margin: const EdgeInsets.only(right: 10),
                                      width: 16,
                                      height: 20,
                                      child: Image.asset(
                                          "assets/images/file_plus.png"),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      )),
                              onTap: () async {
                                initController.tapTextField.value = true;
                                // initController.canChatFileShow.value = true;
                                if (initController.canChatFileShow.value) {
                                  initController.chatFocusNode.requestFocus();
                                } else {
                                  FocusScope.of(context).unfocus();
                                }

                                initController.canChatFileShow.value =
                                    !initController.canChatFileShow.value;
                              }),
                          InkWell(
                              child: // 타원 20
                                  Container(
                                      margin: const EdgeInsets.only(right: 6),
                                      width: 28,
                                      height: 28,
                                      child: Image.asset(
                                          "assets/images/chat_input_send.png"),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Get.theme.primaryColor,
                                      )),
                              onTap: () async {
                                String text = commentWriteController.text;
                                String testText = text;
                                if (testText.trim().isEmpty) {
                                  return;
                                }
                                initController
                                    .sendMessage(commentWriteController.text);

                                commentWriteController.clear();
                              }),
                        ]),
                      ),
                    ],
                  ),
                ),
                initController.canChatFileShow.value
                    ? Builder(builder: (context) {
                        double height = box.read("keyBoardHeight");
                        double containerSize =
                            (Get.mediaQuery.size.width - 42 * 2 - 24 * 2) / 3.0;
                        containerSize = 76.0;
                        return Container(
                            height: height,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 34, left: 42, right: 42),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Ink(
                                          child: InkWell(
                                            onTap: () {
                                              print("camera");
                                            },
                                            child: Container(
                                                width: containerSize,
                                                height: containerSize,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xffeaeaea),
                                                        width: 1),
                                                    color: const Color(
                                                        0xffffffff))),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 6),
                                          child: Text("Camera",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff9b9b9b),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Roboto",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 10.0),
                                              textAlign: TextAlign.center),
                                        )
                                      ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Ink(
                                          child: InkWell(
                                            onTap: () {
                                              print("Image");
                                            },
                                            child: Container(
                                                width: containerSize,
                                                height: containerSize,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xffeaeaea),
                                                        width: 1),
                                                    color: const Color(
                                                        0xffffffff))),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 6),
                                          child: Text("Image",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff9b9b9b),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Roboto",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 10.0),
                                              textAlign: TextAlign.center),
                                        )
                                      ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Ink(
                                          child: InkWell(
                                            onTap: () {
                                              print("File");
                                            },
                                            child: Container(
                                                width: containerSize,
                                                height: containerSize,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xffeaeaea),
                                                        width: 1),
                                                    color: const Color(
                                                        0xffffffff))),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 6),
                                          child: Text("File",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff9b9b9b),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Roboto",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 10.0),
                                              textAlign: TextAlign.center),
                                        )
                                      ]),
                                ],
                              ),
                            ),
                            decoration:
                                BoxDecoration(color: const Color(0xfff4f9ff)));
                      })
                    : Container(
                        decoration:
                            BoxDecoration(color: const Color(0xfff4f9ff)))
              ]),
            );
          }),
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
    // print("pf: ${model.PROFILE_PHOTO}");
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
      ]),
    );
  }
}

class MAIL_CONTENT_ITEM extends StatelessWidget {
  const MAIL_CONTENT_ITEM(
      {Key key, @required this.model, @required this.isTimeDifferent})
      : super(key: key);

  final ClassChatModel model;
  final bool isTimeDifferent;

  @override
  Widget build(BuildContext context) {
    // print("${isTimeDifferent} ${prettyChatDate(model.TIME_CREATED)}");
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      model.MY_SELF
          ? isTimeDifferent
              ? Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Text("${prettyChatDate(model.TIME_CREATED)}",
                      style: const TextStyle(
                          color: const Color(0xffd6d4d4),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0),
                      textAlign: TextAlign.right),
                )
              : Container()
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
          : isTimeDifferent
              ? Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Text("${prettyChatDate(model.TIME_CREATED)}",
                      style: const TextStyle(
                          color: const Color(0xffd6d4d4),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0),
                      textAlign: TextAlign.right),
                )
              : Container(),
    ]);
  }
}
