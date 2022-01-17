import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/class/class_chat_controller.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:polarstar_flutter/app/data/model/class/class_chat_model.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailSend_model.dart';
import 'package:polarstar_flutter/app/ui/android/functions/time_pretty.dart';

class ClassChatHistory extends StatelessWidget {
  final ClassChatController controller = Get.find();
  final commentWriteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    child: Ink(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          'assets/images/back_icon.png',
                          // fit: BoxFit.fitWidth,
                          width: 24,
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
              return ListView.builder(
                // controller: mailController.scrollController,
                itemCount: controller.chatHistory.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 24, bottom: 75),
                itemBuilder: (context, index) {
                  bool MY_SELF = controller.chatHistory[index].MY_SELF;
                  ClassChatModel model = controller.chatHistory[index];
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
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          child: Text(
                                              "${prettyDate(model.TIME_CREATED)}",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xffd6d4d4),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Roboto",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 10.0),
                                              textAlign: TextAlign.right),
                                        ),
                                        MAIL_CONTENT_ITEM(
                                          // mailController: mailController,
                                          model: controller.chatHistory[index],
                                        )
                                      ])
                                : Row(children: [
                                    MAIL_CONTENT_ITEM(
                                      model: controller.chatHistory[index],
                                    ),
                                    MAIL_PROFILE_ITEM(
                                      model: controller.chatHistory[index],
                                      FROM_ME: MY_SELF,
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
            height: 75,
            decoration: BoxDecoration(color: const Color(0xffe0e4ff)),
            child: Row(
              children: [
                Container(
                  height: 36,
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 31),
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
                      child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          onEditingComplete: () async {
                            print(commentWriteController.text);
                            controller.sendMessage(commentWriteController.text);
                            commentWriteController.clear();
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
                    InkWell(
                        child: // 타원 20
                            Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xff371ac7))),
                        onTap: () async {
                          // await mailController.sendMailIn(
                          //     commentWriteController.text,
                          //     mailController.scrollController);
                          print(commentWriteController.text);

                          controller.sendMessage(commentWriteController.text);

                          commentWriteController.clear();
                        }),
                  ]),
                ),
              ],
            ),
          )),
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
    return Container(
        // width: 41.5,
        // height: 41.5,
        margin:
            FROM_ME ? EdgeInsets.only(left: 14) : EdgeInsets.only(right: 14),
        child: Column(children: [
          // CachedNetworkImage(
          //     imageUrl: '${model.PHOTO}',
          //     imageBuilder: (context, imageProvider) => Container(
          //         decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             image: DecorationImage(
          //                 image: imageProvider, fit: BoxFit.fill))),
          //     fadeInDuration: Duration(milliseconds: 0),
          //     progressIndicatorBuilder: (context, url, downloadProgress) =>
          //         Image(image: AssetImage('assets/images/spinner.gif')),
          //     errorWidget: (context, url, error) {
          //       print(error);
          //       return Icon(Icons.error);
          //     }),
          Center(
            child: Text(
              "${model.USERNAME}",
            ),
          ),
          Center(
            child: Text(
              "${model.TIME_CREATED}",
            ),
          )
        ]));
  }
}

class MAIL_CONTENT_ITEM extends StatelessWidget {
  const MAIL_CONTENT_ITEM({Key key, @required this.model}) : super(key: key);

  final ClassChatModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: model.MY_SELF == 0
                    ? Radius.circular(36)
                    : Radius.circular(0),
                bottomRight: Radius.circular(36),
                bottomLeft: Radius.circular(36)),
            color: model.MY_SELF == 0
                ? const Color(0xfff5f5f5)
                : const Color(0xffe0e4ff)),
        child: Container(
            padding: EdgeInsets.only(left: 16, top: 10, right: 24, bottom: 10),
            child: Text("${model.CONTENT}",
                style: const TextStyle(
                    color: const Color(0xff2f2f2f),
                    fontWeight: FontWeight.w400,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left)));
  }
}
