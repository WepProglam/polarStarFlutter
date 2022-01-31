import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polarstar_flutter/app/controller/class/class_chat_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/ui/android/functions/file_name.dart';
import 'package:polarstar_flutter/app/ui/android/functions/time_pretty.dart';
import 'package:file_picker/file_picker.dart';
import 'package:polarstar_flutter/app/ui/android/photo/see_photo.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

final box = GetStorage();

class ClassChatHistory extends StatefulWidget {
  @override
  State<ClassChatHistory> createState() => _ClassChatHistoryState();
}

class _ClassChatHistoryState extends State<ClassChatHistory> {
  final ClassChatController controller = Get.find();

  final commentWriteController = TextEditingController();

  double getKeyboardHeight() {
    final double chatHeight =
        box.read("keyBoardHeight") == null || box.read("keyBoardHeight") == 0
            ? 342.0
            : box.read("keyBoardHeight");
    print("chat height : $chatHeight");
    return chatHeight;
  }

  ReceivePort _port = ReceivePort();

  StreamSubscription<bool> keyboardSubscription;
  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((event) {
      if (event && !mounted) {
        double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;
        box.write("keyBoardHeight", keyBoardHeight);
        print("keyboard : ${keyBoardHeight}");

        Timer(Duration(milliseconds: 400), () {
          double keyBoardHeightTemp = MediaQuery.of(context).viewInsets.bottom;
          if (keyBoardHeightTemp > keyBoardHeight) {
            box.write("keyBoardHeight", keyBoardHeightTemp);
            print("keyboard : ${keyBoardHeightTemp}");
          }
        });
      }
      if (!event && (controller.tapTextField.value)) {
        double target_pos =
            controller.chatScrollController.offset - getKeyboardHeight() < 0
                ? 0
                : controller.chatScrollController.offset - getKeyboardHeight();
        controller.chatScrollController.jumpTo(target_pos);
      }
      if (!event && !controller.canChatFileShow.value) {
        controller.tapTextField.value = false;
      }
    });

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      controller.fileFindCurChat(id).update((val) {
        val.FILE_PROGRESS = progress;

        // * 완료
        if (status.value == 3) {
          val.FILE_DOWNLOADING = false;
          val.FILE_DOWNLOADED = true;
        }
      });
      // setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  bool isPreCacheNeeded = true;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Map<String, dynamic> chatMeta = controller.findChatHistory();
    int chatIndex = chatMeta["index"];
    bool isClass = chatMeta["isClass"];

    Rx<ChatBoxModel> model = isClass
        ? controller.classChatBox[chatIndex]
        : controller.majorChatBox[chatIndex];

    if (isPreCacheNeeded) {
      controller.dataAvailble.value = false;
      await preCacheImage(model);
      // await Timer(Duration(milliseconds: 100), () {
      // });
      controller.dataAvailble.value = true;
      isPreCacheNeeded = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Future.delayed(_).then((value) async {
        //   controller.frameComplete(true);
        //   await Future.delayed(Duration(seconds: 1));

        // });
        controller.chatScrollController
            .jumpTo(controller.chatScrollController.position.maxScrollExtent);
      });
  }

  void preCacheImage(Rx<ChatBoxModel> model) {
    for (Rx<ChatModel> item in model.value.ChatList) {
      if (item.value.PHOTO != null && item.value.PHOTO.length > 0) {
        precacheImage(item.value.PRE_IMAGE[0].image, context);
        // await precacheImage(item.value.PRE_CACHE_IMAGE[0].image, context);
      }
    }
    return;
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> chatMeta = controller.findChatHistory();
    int chatIndex = chatMeta["index"];
    bool isClass = chatMeta["isClass"];

    Rx<ChatBoxModel> model = isClass
        ? controller.classChatBox[chatIndex]
        : controller.majorChatBox[chatIndex];
    // int chatIndex = model.value.BOX_ID;
    // bool isClass = model.value.;
    // Rx<ChatBoxModel> box_model = isClass
    //     ? classChatController.classChatBox[chatIndex]
    //     : classChatController.majorChatBox[chatIndex];
    // controller.dataAvailble.value = false;
    // for (Rx<ChatModel> item in model.value.ChatList) {
    //   if (item.value.PHOTO != null && item.value.PHOTO.length > 0) {
    //     precacheImage(item.value.PRE_IMAGE[0], context);
    //   }
    // }
    // controller.dataAvailble.value = true;

    return WillPopScope(
      onWillPop: () async {
        if (controller.canChatFileShow.value) {
          controller.canChatFileShow.value = false;
          controller.tapTextField.value = false;
          return false;
        }
        controller.canChatFileShow.value = false;
        controller.tapTextField.value = false;
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          endDrawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 51, left: 20),
                child: Text("대화상대",
                    style: const TextStyle(
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansKR",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
              ),
              Container(
                  margin: const EdgeInsets.only(
                      top: 9, left: 10, right: 10, bottom: 14),
                  height: 1,
                  decoration: BoxDecoration(color: const Color(0xffeaeaea))),
              Expanded(
                child: Obx(() {
                  controller.chatScrollController.jumpTo(
                      controller.chatScrollController.position.maxScrollExtent);
                  return ListView.builder(
                      itemCount: controller.chatProfileList.length,
                      itemBuilder: (BuildContext context, int index) {
                        ChatPrifileModel prifileModel =
                            controller.chatProfileList[index];
                        print(prifileModel.PROFILE_PHOTO);
                        return Container(
                          height: 32,
                          margin: const EdgeInsets.only(left: 20, bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                child: CachedNetworkImage(
                                    imageUrl: prifileModel.PROFILE_PHOTO),
                              ),
                              prifileModel.MY_SELF
                                  ? Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      width: 16,
                                      height: 16,
                                      child: Center(
                                        child: Text("나",
                                            style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "NotoSansKR",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 10.0),
                                            textAlign: TextAlign.center),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          color: const Color(0xff91bbff)))
                                  : Container(
                                      margin: const EdgeInsets.only(left: 10)),
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                child: Text("${prifileModel.PROFILE_NICKNAME}",
                                    style: const TextStyle(
                                        color: const Color(0xff6f6e6e),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "NotoSansSC",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.0),
                                    textAlign: TextAlign.left),
                              )
                            ],
                          ),
                        );
                      });
                }),
              ),
              // ! 알림 끄기 기능 구현 후 장착 필요
              // // 사각형 62
              // Container(
              //     height: 75,
              //     decoration: BoxDecoration(color: const Color(0xffe6f1ff)))
            ],
          )),
          backgroundColor: const Color(0xffffffff),
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 56,

            backgroundColor: Get.theme.primaryColor,
            titleSpacing: 0,
            // elevation: 0,
            automaticallyImplyLeading: false,
            // actions: [
            //   InkWell(
            //     onTap: () {
            //       Get.toNamed("/timetable/bin");
            //     },
            //     child: Image.asset(
            //       "assets/images/menu.png",
            //     ),
            //   ),
            // ],
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Ink(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: Image.asset(
                  'assets/images/891.png',
                  color: const Color(0xffffffff),
                ),
              ),
            ),
            centerTitle: true,

            title: Container(
                margin: const EdgeInsets.symmetric(vertical: 16.5),
                child: // 设置
                    Obx(() {
                  Rx<ChatBoxModel> box_model = isClass
                      ? controller.classChatBox[chatIndex]
                      : controller.majorChatBox[chatIndex];
                  return Text(
                      box_model.value.CLASS_PROFESSOR != null
                          ? "${box_model.value.BOX_NAME}-${box_model.value.CLASS_PROFESSOR}"
                          : "${box_model.value.BOX_NAME}",
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.center);
                })),
          ),
          body: Obx(() {
            if (controller.dataAvailble.value ||
                controller.frameComplete.value) {
              print("data available");

              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   controller.chatScrollController.jumpTo(
              //       controller.chatScrollController.position.maxScrollExtent);
              // });
              // if (controller.chatScrollController.hasClients) {
              //   controller.chatScrollController.jumpTo(
              //       controller.chatScrollController.position.maxScrollExtent);
              // }
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   controller.chatScrollController.jumpTo(
              //       controller.chatScrollController.position.maxScrollExtent);
              // });
              Rx<ChatBoxModel> box_model = isClass
                  ? controller.classChatBox[chatIndex]
                  : controller.majorChatBox[chatIndex];
              return GestureDetector(
                onTap: () {
                  if (controller.tapTextField.value) {
                    print(controller
                        .chatScrollController.position.maxScrollExtent);
                    double target_pos = controller.chatScrollController.offset -
                                getKeyboardHeight() <
                            0
                        ? 0
                        : controller.chatScrollController.offset -
                            getKeyboardHeight();
                    controller.chatScrollController.jumpTo(target_pos);
                  }

                  controller.canChatFileShow.value = false;
                  controller.tapTextField.value = false;
                  controller.chatFocusNode.unfocus();
                },
                child: SingleChildScrollView(
                  controller: controller.chatScrollController,
                  child: Column(children: [
                    Obx(() {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        if (controller.isNewMessage.value) {
                          controller.chatScrollController.jumpTo(controller
                              .chatScrollController.position.maxScrollExtent);
                          controller.isNewMessage.value = false;
                          // Future.delayed(_).then((value) async {
                          //   controller.frameComplete(true);
                          //   await Future.delayed(Duration(seconds: 1));
                          //   controller.chatScrollController.jumpTo(controller
                          //       .chatScrollController.position.maxScrollExtent);
                          //   controller.isNewMessage.value = false;
                          // });
                        }
                      });
                      print("re build!!");
                      return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          Rx<ChatModel> model;

                          Rx<ChatModel> prevModel;
                          Rx<ChatModel> nextModel;

                          if (index <= box_model.value.ChatList.length - 1) {
                            model = box_model.value.ChatList[index];
                            if (index - 1 < 0) {
                              prevModel = null;
                            } else {
                              prevModel = box_model.value.ChatList[index - 1];
                            }

                            if (index + 1 >= box_model.value.ChatList.length) {
                              nextModel = null;
                            } else {
                              nextModel = box_model.value.ChatList[index + 1];
                            }
                          } else {
                            int loadingIndex =
                                index - box_model.value.ChatList.length;
                            model =
                                box_model.value.LoadingChatList[loadingIndex];

                            if (loadingIndex - 1 < 0) {
                              prevModel = null;
                            } else {
                              prevModel = box_model
                                  .value.LoadingChatList[loadingIndex - 1];
                            }

                            if (loadingIndex + 1 >=
                                box_model.value.LoadingChatList.length) {
                              nextModel = null;
                            } else {
                              nextModel = box_model
                                  .value.LoadingChatList[loadingIndex + 1];
                            }
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
                                                color:
                                                    const Color(0xffeaeaea))),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14.5),
                                          color: Colors.white,
                                          child: Text(
                                              "${model.value.TIME_CREATED.year}年${model.value.TIME_CREATED.month}月${model.value.TIME_CREATED.day}日",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff9b9b9b),
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
                        itemCount: box_model.value.ChatList.length +
                            box_model.value.LoadingChatList.length,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(top: 24, bottom: 60 + 6.0),
                        // bottom: controller.tapTextField.value
                        //     ? 60 + 6.0 + getKeyboardHeight()
                        //     : 60 + 6.0),
                        itemBuilder: (context, index) {
                          Rx<ChatModel> model;

                          Rx<ChatModel> prevModel;
                          Rx<ChatModel> nextModel;

                          if (index <= box_model.value.ChatList.length - 1) {
                            model = box_model.value.ChatList[index];
                            if (index - 1 < 0) {
                              prevModel = null;
                            } else {
                              prevModel = box_model.value.ChatList[index - 1];
                            }

                            if (index + 1 >= box_model.value.ChatList.length) {
                              nextModel = null;
                            } else {
                              nextModel = box_model.value.ChatList[index + 1];
                            }
                          } else {
                            int loadingIndex =
                                index - box_model.value.ChatList.length;
                            model =
                                box_model.value.LoadingChatList[loadingIndex];

                            if (loadingIndex - 1 < 0) {
                              prevModel = null;
                            } else {
                              prevModel = box_model
                                  .value.LoadingChatList[loadingIndex - 1];
                            }

                            if (loadingIndex + 1 >=
                                box_model.value.LoadingChatList.length) {
                              nextModel = null;
                            } else {
                              nextModel = box_model
                                  .value.LoadingChatList[loadingIndex + 1];
                            }
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

                          bool isEntryChat = false;
                          if (model.value.ENTRY_CHAT != null) {
                            isEntryChat = true;
                          }

                          return isEntryChat
                              ? Center(
                                  child: Text("${model.value.ENTRY_CHAT}"),
                                )
                              : Container(
                                  padding: (prevModel == null
                                      ? MY_SELF
                                          ? EdgeInsets.only(right: 20, top: 0)
                                          : EdgeInsets.only(left: 20, top: 0)
                                      : MY_SELF
                                          ? EdgeInsets.only(
                                              right: 20,
                                              top: isContinueSame ? 6 : 24)
                                          : EdgeInsets.only(
                                              left: 20,
                                              top: showProfile ? 24 : 6)),
                                  child: Align(
                                    alignment: (MY_SELF
                                        ? Alignment.topRight
                                        : Alignment.topLeft),
                                    child: (MY_SELF
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                                Obx(() {
                                                  return MAIL_CONTENT_ITEM(
                                                    model: model,
                                                    FILE_DOWNLOADED: model
                                                        .value.FILE_DOWNLOADED,
                                                    FILE_DOWNLOADING: model
                                                        .value.FILE_DOWNLOADING,
                                                    classChatController:
                                                        controller,
                                                    isTimeDifferent:
                                                        displayTime,
                                                  );
                                                })
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      showProfile
                                                          ? Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          4),
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
                                                                      fontSize:
                                                                          10.0),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left),
                                                            )
                                                          : Container(),
                                                      Obx(() {
                                                        return MAIL_CONTENT_ITEM(
                                                            FILE_DOWNLOADED: model
                                                                .value
                                                                .FILE_DOWNLOADED,
                                                            FILE_DOWNLOADING: model
                                                                .value
                                                                .FILE_DOWNLOADING,
                                                            model: model,
                                                            classChatController:
                                                                controller,
                                                            isTimeDifferent:
                                                                displayTime);
                                                      }),
                                                    ]),
                                              ])),
                                  ));
                        },
                      );
                    }),
                  ]),
                ),
              );
            } else {
              print("data not available");
              return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()),
              );
            }
          }),
          //입력창
          bottomSheet: Obx(() {
            return Container(
              // height: controller.tapTextField.value
              //     ? 60.0 + getKeyboardHeight()
              //     : 60,
              decoration: BoxDecoration(color: const Color(0xffe6f1ff)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // height: 40,
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
                            child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                focusNode: controller.chatFocusNode,
                                onTap: () async {
                                  controller.canChatFileShow.value = false;

                                  if (!controller.tapTextField.value) {
                                    controller.tapTextField.value = true;
                                    Future.delayed(Duration(milliseconds: 10),
                                        () {
                                      double max_extent = controller
                                          .chatScrollController
                                          .position
                                          .maxScrollExtent;
                                      double offset_height = controller
                                              .chatScrollController.offset +
                                          getKeyboardHeight();

                                      print(
                                          "off_set : ${offset_height} - max_extent : ${max_extent}");

                                      double target_pos =
                                          offset_height > max_extent
                                              ? max_extent
                                              : offset_height;

                                      controller.chatScrollController
                                          .jumpTo(target_pos);
                                    });
                                  }

                                  // Timer(
                                  //     Duration(
                                  //       milliseconds: 100,
                                  //     ), () {
                                  //   double keyBoardHeight =
                                  //       MediaQuery.of(context)
                                  //           .viewInsets
                                  //           .bottom;
                                  //   box.write("keyBoardHeight", keyBoardHeight);
                                  //   print("keyboard : ${keyBoardHeight}");
                                  // });

                                  // Timer(Duration(milliseconds: 100), () {
                                  //   controller.chatScrollController
                                  //       .jumpTo(target_pos);
                                  // });

                                  // controller.tapTextField.value = true;
                                  // controller.canChatFileShow.value =
                                  //     false;

                                  // Timer(Duration(milliseconds: 100), () {
                                  //   controller.chatScrollController
                                  //       .jumpTo(
                                  //     controller.chatScrollController
                                  //             .position.pixels +
                                  //         box.read("keyBoardHeight"),
                                  //   );
                                  //   // controller.chatScrollController.animateTo(
                                  //   //     controller.chatScrollController.position
                                  //   //         .maxScrollExtent,
                                  //   //     duration: Duration(milliseconds: 100),
                                  //   //     curve: Curves.fastOutSlowIn);
                                  // });
                                  // controller.chatScrollController.jumpTo(
                                  //   controller.chatScrollController
                                  //       .position.maxScrollExtent,
                                  // );
                                },
                                onEditingComplete: () async {
                                  // controller
                                  //     .sendMessage(commentWriteController.text);
                                  // commentWriteController.clear();

                                  // double max_hight = controller
                                  //     .chatScrollController
                                  //     .value
                                  //     .position
                                  //     .maxScrollExtent;

                                  // controller.chatScrollController.value
                                  //     .jumpTo(max_hight);
                                },
                                minLines: 1,
                                maxLines: 5,
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
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: "",
                                  hintStyle: const TextStyle(
                                      color: const Color(0xff9b9b9b),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                )),
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
                                if (controller.tapTextField.value) {
                                  if (controller.canChatFileShow.value) {
                                    controller.chatFocusNode.requestFocus();
                                  } else {
                                    FocusScope.of(context).unfocus();
                                  }
                                } else {
                                  if (controller.canChatFileShow.value) {
                                    controller.chatFocusNode.requestFocus();
                                  } else {
                                    FocusScope.of(context).unfocus();
                                    double target_pos =
                                        controller.chatScrollController.offset +
                                            getKeyboardHeight();

                                    controller.chatScrollController
                                        .jumpTo(target_pos);
                                  }
                                }
                                controller.tapTextField.value = true;

                                controller.canChatFileShow.value =
                                    !controller.canChatFileShow.value;
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
                                // if (controller.files.length != 0) {
                                //   await controller.sendFile();
                                // } else if (controller.photos.length != 0) {
                                //   await controller.sendPhoto();
                                // } else {
                                String text = commentWriteController.text;
                                String testText = text;
                                if (testText.trim().isEmpty) {
                                  return;
                                }
                                controller
                                    .sendMessage(commentWriteController.text);

                                commentWriteController.clear();
                                // }
                              }),
                        ]),
                      ),
                    ],
                  ),
                ),
                controller.canChatFileShow.value
                    ? Builder(builder: (context) {
                        double height = getKeyboardHeight();
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
                                                child: Center(
                                                    child: Image.asset(
                                                  "assets/images/file_send_camera.png",
                                                )),
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
                                            onTap: () async {
                                              print('사진추가');
                                              controller.photos.addAll(
                                                  await AssetPicker.pickAssets(
                                                      context,
                                                      maxAssets: 10));
                                              controller.sendPhoto();
                                            },
                                            child: Container(
                                                width: containerSize,
                                                height: containerSize,
                                                child: Center(
                                                  child: Image.asset(
                                                      "assets/images/file_send_gallery.png"),
                                                ),
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
                                            onTap: () async {
                                              print("File");
                                              FilePickerResult result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                          allowMultiple: true);

                                              if (result != null) {
                                                controller.files = result.paths
                                                    .map((path) => File(path))
                                                    .toList();
                                                controller.sendFile();
                                              } else {
                                                // User canceled the picker
                                              }
                                            },
                                            child: Container(
                                                width: containerSize,
                                                height: containerSize,
                                                child: Center(
                                                  child: Image.asset(
                                                      "assets/images/file_send_etc.png"),
                                                ),
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
                        height: 0.0,
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

  final ChatModel model;
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
  MAIL_CONTENT_ITEM(
      {Key key,
      @required this.model,
      @required this.FILE_DOWNLOADED,
      @required this.FILE_DOWNLOADING,
      @required this.isTimeDifferent,
      @required this.classChatController})
      : super(key: key);

  final Rx<ChatModel> model;
  final bool isTimeDifferent;
  bool FILE_DOWNLOADED, FILE_DOWNLOADING;
  final ClassChatController classChatController;
  String taskID;
  final box = GetStorage();
  void download(String url) async {
    // * 이미 다운 받았으면 return
    if (classChatController.isFileDownloaded(url)) {
      return;
    }

    final status = await Permission.storage.request();

    if (status.isGranted) {
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      // final externalDir = await getExternalStorageDirectory();
      model.update((val) {
        val.FILE_DOWNLOADING = true;
      });

      final String taskID = await FlutterDownloader.enqueue(
          url: url,
          savedDir: dirloc,
          showNotification: true,
          openFileFromNotification: true,
          saveInPublicStorage: true);

      model.update((val) {
        val.FILE_TID = taskID;
      });

      box.write(url, taskID);
    } else {
      print('Permission Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPhotoExist = false;
    bool isFileExist = false;
    String TID;
    if (model.value.PHOTO != null && model.value.PHOTO.length != 0) {
      isPhotoExist = true;
    } else if (model.value.FILE != null && model.value.FILE.length != 0) {
      isFileExist = true;
      try {
        TID = classChatController.findFileTID(model.value.FILE[0]);
      } catch (e) {}
    }

    // print("${isTimeDifferent} ${prettyChatDate(model.value.TIME_CREATED)}");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        model.value.MY_SELF && !model.value.IS_PRE_SEND
            ? isTimeDifferent
                ? Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Text("${prettyChatDate(model.value.TIME_CREATED)}",
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
        Obx(() {
          // if (model.value.FILE_DOWNLOADING &&
          //     model.value.FILE_PROGRESS) {
          //   print("????");
          //   model.update((val) {
          //     val.FILE_DOWNLOADED = true;
          //     val.FILE_DOWNLOADING = false;
          //   });
          //   print("다운 !!!!!!!!!!!!!!!!!!!!!! 완료");
          // }
          return Opacity(
            opacity: model.value.IS_PRE_SEND ? 0.4 : 1.0,
            child: Container(
                constraints: BoxConstraints(maxWidth: 200),
                decoration: isPhotoExist || isFileExist
                    ? null
                    : BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: model.value.MY_SELF
                                ? Radius.circular(36)
                                : Radius.circular(0),
                            topRight: model.value.MY_SELF
                                ? Radius.circular(0)
                                : Radius.circular(36),
                            bottomRight: Radius.circular(36),
                            bottomLeft: Radius.circular(36)),
                        color: model.value.MY_SELF
                            ? const Color(0xffe6f1ff)
                            : const Color(0xfff5f5f5)),
                child: Container(
                    child: (isFileExist)
                        ? Ink(
                            child: InkWell(
                              onTap: () async {
                                FILE_DOWNLOADED
                                    ? FlutterDownloader.open(taskId: TID)
                                    : download(model.value.FILE[0]);
                                // final taskID = await FlutterDownloader.enqueue(
                                //     url: model.value.FILE[0],
                                //     savedDir: "./",
                                //     showNotification: true,
                                //     openFileFromNotification: true);
                              },
                              child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: model.value.MY_SELF
                                          ? Color(0xffe6f1ff)
                                          : Color(0xfff5f5f5)),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xffffffff)),
                                            width: 38,
                                            height: 38,
                                            child: model.value.IS_PRE_SEND
                                                ? CircularProgressIndicator()
                                                : FILE_DOWNLOADED
                                                    ? Center(
                                                        child: Image.asset(
                                                          "assets/images/file_before_download.png",
                                                          height: 25,
                                                          width: 25,
                                                        ),
                                                      )
                                                    : FILE_DOWNLOADING
                                                        ? Container(
                                                            height: 25,
                                                            width: 25,
                                                            child:
                                                                CircularProgressIndicator(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              value: model.value
                                                                      .FILE_PROGRESS
                                                                      .toDouble() /
                                                                  100,
                                                              valueColor:
                                                                  new AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Get.theme
                                                                          .primaryColor),
                                                            ),
                                                          )
                                                        : Center(
                                                            child: Image.asset(
                                                              "assets/images/file_after_download.png",
                                                              height: 25,
                                                              width: 25,
                                                            ),
                                                          )),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 12),
                                        child: model.value.IS_PRE_SEND
                                            ? Container()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    model.value.FILE_META !=
                                                            null
                                                        ? "${convertFileName(model.value.FILE_META[0].FILE_NAME)}"
                                                        : "unknown",
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff2f2f2f),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: "Roboto",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 12.0),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    "유효기간: ${trimExpire(model.value.FILE_META[0].EXPIRE)}",
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff9b9b9b),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            "NotoSansKR",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 10.0),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    "용량: ${trimFileSize(model.value.FILE_META[0].FILE_SIZE)}",
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff9b9b9b),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            "NotoSansKR",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 10.0),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                      )
                                    ],
                                  )),
                            ),
                          )

                        // CachedNetworkImage(imageUrl: model.value.FILE[0])

                        // Text("파일입니다",
                        //     style: const TextStyle(
                        //         color: const Color(0xff2f2f2f),
                        //         fontWeight: FontWeight.w400,
                        //         fontFamily: "NotoSansSC",
                        //         fontStyle: FontStyle.normal,
                        //         fontSize: 14.0),
                        //     textAlign: TextAlign.left)
                        : (isPhotoExist
                            ? Builder(builder: (context) {
                                // print(model.value.PHOTO_META[0].PIXEL_HEIGHT);
                                // print(model.value.PHOTO_META[0].PIXEL_WIDTH);
                                // print(model.value.PHOTO_META[0].PHOTO_NAME);
                                double image_height = (200 *
                                        model
                                            .value.PHOTO_META[0].PIXEL_HEIGHT) /
                                    model.value.PHOTO_META[0].PIXEL_WIDTH
                                        .toDouble();

                                bool isHeightNormal = !image_height.isNaN;
                                // (model.value.PHOTO_META[0].PIXEL_HEIGHT > 0 &&
                                //     model.value.PHOTO_META[0].PIXEL_WIDTH > 0);
                                if (!isHeightNormal) {
                                  // print("!!!!!!!!!!!!!!!!!!!!!!!!!");
                                  // print(image_height);
                                }

                                return Ink(
                                    child: InkWell(
                                        onTap: () {
                                          if (!model.value.IS_PRE_SEND) {
                                            Get.to(SeePhotoDirect(
                                                    photo: model
                                                        .value.PRE_IMAGE[0],
                                                    index: 0))
                                                .then((value) =>
                                                    changeStatusBarColor(
                                                        Get.theme.primaryColor,
                                                        Brightness.dark));
                                          }
                                        },
                                        child: isHeightNormal
                                            ? Container(
                                                height: image_height,
                                                // child: ImageP
                                                // child: model.value.PRE_CACHE_IMAGE[0]
                                                child: model.value.PRE_IMAGE[0]
                                                // Image(image: model.value.PRE_IMAGE[0]),
                                                // child: CachedNetworkImage(
                                                //     alignment: model.value.MY_SELF
                                                //         ? Alignment.topRight
                                                //         : Alignment.topLeft,
                                                //         imageBuilder: (context, imageProvider) => model.value.PRE_IMAGE,
                                                //     imageUrl: model.value.PHOTO[0]),
                                                )
                                            : Container(
                                                child:
                                                    model.value.PRE_IMAGE[0])));
                              })

                            // Text("사진입니다",
                            //     style: const TextStyle(
                            //         color: const Color(0xff2f2f2f),
                            //         fontWeight: FontWeight.w400,
                            //         fontFamily: "NotoSansSC",
                            //         fontStyle: FontStyle.normal,
                            //         fontSize: 14.0),
                            //     textAlign: TextAlign.left)
                            : Container(
                                padding: EdgeInsets.only(
                                    left: 16, top: 10, right: 24, bottom: 10),
                                child: Text("${model.value.CONTENT}",
                                    style: const TextStyle(
                                        color: const Color(0xff2f2f2f),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "NotoSansSC",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                    textAlign: TextAlign.left),
                              )))),
          );
        }),
        model.value.MY_SELF || model.value.IS_PRE_SEND
            ? Container()
            : isTimeDifferent
                ? Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Text("${prettyChatDate(model.value.TIME_CREATED)}",
                        style: const TextStyle(
                            color: const Color(0xffd6d4d4),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 10.0),
                        textAlign: TextAlign.right),
                  )
                : Container(),
      ],
    );
  }
}
