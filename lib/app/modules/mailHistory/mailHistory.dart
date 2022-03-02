import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linkwell/linkwell.dart';
import 'package:polarstar_flutter/app/modules/mailHistory/mail_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailSend_model.dart';
import 'package:polarstar_flutter/app/global_functions/time_pretty.dart';

class MailHistory extends StatelessWidget {
  final MailController mailController = Get.find();
  final commentWriteController = TextEditingController();
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    final double chatHeight =
        box.read("keyBoardHeight") == null ? 342.0 : box.read("keyBoardHeight");
    return Container(
      color: const Color(0xffe6f1ff),
      child: SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: const Color(0xffffffff),
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
                            Obx(() {
                          return Text(
                              mailController.opponentProfile.value
                                          .PROFILE_NICKNAME ==
                                      null
                                  ? ""
                                  : "${mailController.opponentProfile.value.PROFILE_NICKNAME}",
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center);
                        })),
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
                ],
              ),
            ),
            body: RefreshIndicator(
              onRefresh: mailController.getMail,
              child: Obx(() {
                if (mailController.dataAvailableMailSendPage.value) {
                  return GestureDetector(
                    onTap: () {
                      mailController.tapTextField.value = false;
                      mailController.chatFocusNode.unfocus();
                    },
                    child: ListView.builder(
                      controller: mailController.chatScrollController,
                      itemCount: mailController.mailHistory.length,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(
                          top: 24,
                          bottom: mailController.tapTextField.value
                              ? 60 + 6.0 + chatHeight
                              : 60 + 6.0),
                      itemBuilder: (context, index) {
                        MailHistoryModel model =
                            mailController.mailHistory[index];

                        MailHistoryModel prevModel;
                        MailHistoryModel nextModel;
                        if (index - 1 < 0) {
                          prevModel = null;
                        } else {
                          prevModel = mailController.mailHistory[index - 1];
                        }

                        if (index + 1 >= mailController.mailHistory.length) {
                          nextModel = null;
                        } else {
                          nextModel = mailController.mailHistory[index + 1];
                        }

                        bool MY_SELF = model.FROM_ME == 1 ? true : false;

                        bool isContinueSame = (prevModel != null &&
                            prevModel.FROM_ME == model.FROM_ME);

                        bool isContinueDifferent = (prevModel != null &&
                            prevModel.FROM_ME != model.FROM_ME);

                        /**
                           * displayTime: 시간 표시 boolean
                           * 앞 사람이 다른 사람일때 - isContinueDifferent
                           * 앞 사람이 같은 사람이고 이 채팅이 해당 시간에 쓴 마지막일때
                           * 맨 마지막 톡 일때
                           */
                        bool isChatSamePersonEnd = (nextModel != null &&
                                nextModel.FROM_ME != model.FROM_ME) ||
                            nextModel == null;

                        bool lastChatInTime = (nextModel != null &&
                                (nextModel.TIME_CREATED.day !=
                                        model.TIME_CREATED.day ||
                                    nextModel.TIME_CREATED.hour !=
                                        model.TIME_CREATED.hour ||
                                    nextModel.TIME_CREATED.minute !=
                                        model.TIME_CREATED.minute)) ||
                            nextModel == null;

                        bool firstChatInTime = (prevModel != null &&
                                (prevModel.TIME_CREATED.day !=
                                        model.TIME_CREATED.day ||
                                    prevModel.TIME_CREATED.hour !=
                                        model.TIME_CREATED.hour ||
                                    prevModel.TIME_CREATED.minute !=
                                        model.TIME_CREATED.minute)) ||
                            prevModel == null;

                        bool displayTime =
                            isChatSamePersonEnd || lastChatInTime;

                        bool showProfile = prevModel == null ||
                            isContinueDifferent ||
                            firstChatInTime;
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
                                            isTimeDifferent: displayTime,
                                            mailController: mailController,
                                            model: mailController
                                                .mailHistory[index],
                                          )
                                        ])
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MAIL_CONTENT_ITEM(
                                                  isTimeDifferent: displayTime,
                                                  mailController:
                                                      mailController,
                                                  model: mailController
                                                      .mailHistory[index],
                                                ),
                                              ]),
                                        ])),
                            ));

                        // Container(
                        //     padding:
                        //         (mailController.mailHistory[index].FROM_ME == 0
                        //             ? EdgeInsets.only(left: 15, bottom: 33.5)
                        //             : EdgeInsets.only(right: 15, bottom: 26.5)),
                        //     child: Align(
                        //       alignment:
                        //           (mailController.mailHistory[index].FROM_ME == 0
                        //               ? Alignment.topLeft
                        //               : Alignment.topRight),
                        //       child: (mailController.mailHistory[index].FROM_ME ==
                        //               0
                        //           ? Row(children: [
                        //               MAIL_PROFILE_ITEM(
                        //                   FROM_ME: false,
                        //                   profile:
                        //                       mailController.opponentProfile),
                        //               MAIL_CONTENT_ITEM(
                        //                 mailController: mailController,
                        //                 model: mailController.mailHistory[index],
                        //               )
                        //             ])
                        //           : Row(
                        //               mainAxisAlignment: MainAxisAlignment.end,
                        //               children: [
                        //                   MAIL_CONTENT_ITEM(
                        //                     mailController: mailController,
                        //                     model:
                        //                         mailController.mailHistory[index],
                        //                   ),
                        //                   MAIL_PROFILE_ITEM(
                        //                       FROM_ME: true,
                        //                       profile: mailController.myProfile),
                        //                 ])),
                        //     ));
                      },
                    ),
                  );
                } else {
                  return Container(
                    color: Colors.white,
                  );
                }
              }),
            ),
            //입력창
            bottomSheet: Builder(builder: (context) {
              final box = GetStorage();

              return Container(
                height: 60.0,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                                  focusNode: mailController.chatFocusNode,
                                  onTap: () async {
                                    mailController.tapTextField.value = true;

                                    if (mailController.chatScrollController
                                            .position.maxScrollExtent ==
                                        0) {
                                      return;
                                    }
                                    double target_pos = mailController
                                            .chatScrollController.offset +
                                        box.read("keyBoardHeight");

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
                                        margin: const EdgeInsets.only(
                                            right: 6, left: 26),
                                        width: 28,
                                        height: 28,
                                        child: Image.asset(
                                            "assets/images/chat_input_send.png"),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Get.theme.primaryColor,
                                        )),
                                onTap: () async {
                                  await mailController.sendMailIn(
                                      commentWriteController.text,
                                      mailController.scrollController);

                                  commentWriteController.clear();
                                }),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            })

            //  Container(
            //     height: 107 - 13.0 - 22,
            //     width: MediaQuery.of(context).size.width,
            //     decoration: BoxDecoration(color: const Color(0xffffffff)),
            //     child:
            //         //키보드
            //         Column(children: [
            //       Container(
            //           margin: EdgeInsets.only(bottom: 42 - 22.0),
            //           width: MediaQuery.of(context).size.width - 30,
            //           height: 52,
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.all(Radius.circular(52)),
            //               border: Border.all(
            //                   color: const Color(0xffd4d4d4), width: 1),
            //               color: const Color(0x05333333)),
            //           child: Row(children: [
            //             Container(
            //               margin: EdgeInsets.only(
            //                 left: 18.5,
            //                 right: 18.5,
            //               ),
            //               width: MediaQuery.of(context).size.width -
            //                   30 -
            //                   37 -
            //                   38 -
            //                   15,
            //               child: TextFormField(
            //                   keyboardType: TextInputType.multiline,
            //                   onEditingComplete: () async {
            //                     await mailController.sendMailIn(
            //                         commentWriteController.text,
            //                         mailController.scrollController);

            //                     commentWriteController.clear();
            //                   },
            //                   maxLines: null,
            //                   controller: commentWriteController,
            //                   style: const TextStyle(
            //                       color: const Color(0xff333333),
            //                       fontWeight: FontWeight.w500,
            //                       fontFamily: "PingFangSC",
            //                       fontStyle: FontStyle.normal,
            //                       fontSize: 16.0),
            //                   onFieldSubmitted: (value) {
            //                     mailController.sendMailIn(
            //                         commentWriteController.text,
            //                         mailController.scrollController);
            //                   },
            //                   textInputAction: TextInputAction.done,
            //                   decoration: InputDecoration(
            //                     hintText: "Please enter content",
            //                     border: InputBorder.none,
            //                   )),
            //             ),
            //             InkWell(
            //                 child: Container(
            //                   width: 38,
            //                   height: 38,
            //                   decoration: BoxDecoration(
            //                       color: const Color(0xff1a4678),
            //                       shape: BoxShape.circle,
            //                       image: DecorationImage(
            //                           image: AssetImage('assets/images/869.png'),
            //                           scale: 1.8)),
            //                 ),
            //                 onTap: () async {
            //                   await mailController.sendMailIn(
            //                       commentWriteController.text,
            //                       mailController.scrollController);

            //                   commentWriteController.clear();
            //                 }),
            //           ]))
            //     ])),
            ),
      ),
    );
  }
}

class MAIL_PROFILE_ITEM extends StatelessWidget {
  const MAIL_PROFILE_ITEM(
      {Key key, @required this.profile, @required this.FROM_ME})
      : super(key: key);

  final Rx<MailProfile> profile;
  final bool FROM_ME;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 41.5,
        height: 41.5,
        margin:
            FROM_ME ? EdgeInsets.only(left: 14) : EdgeInsets.only(right: 14),
        child: CachedNetworkImage(
            imageUrl: '${profile.value.PROFILE_PHOTO}',
            imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fill))),
            fadeInDuration: Duration(milliseconds: 0),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Image(image: AssetImage('assets/images/spinner.gif')),
            errorWidget: (context, url, error) {
              print(error);
              return Icon(Icons.error);
            }));
  }
}

class MAIL_CONTENT_ITEM extends StatelessWidget {
  const MAIL_CONTENT_ITEM(
      {Key key,
      @required this.mailController,
      @required this.model,
      @required this.isTimeDifferent})
      : super(key: key);

  final MailController mailController;
  final MailHistoryModel model;
  final bool isTimeDifferent;

  @override
  Widget build(BuildContext context) {
    bool MY_SELF = model.FROM_ME == 1 ? true : false;
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      MY_SELF
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
        constraints: BoxConstraints(maxWidth: Get.mediaQuery.size.width - 110),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: MY_SELF ? Radius.circular(20) : Radius.circular(0),
                    topRight:
                        MY_SELF ? Radius.circular(0) : Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                border: Border.all(
                    color: MY_SELF ? Color(0xff6da3fc) : Color(0xffd6d4d4),
                    width: 1)),
            child: Container(
                padding:
                    EdgeInsets.only(left: 16, top: 10, right: 24, bottom: 10),
                child: LinkWell("${model.CONTENT}",
                    linkStyle: TextStyle(
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    style: const TextStyle(
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left))),
      ),
      MY_SELF
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
