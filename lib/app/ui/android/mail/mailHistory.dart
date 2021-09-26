import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailSend_model.dart';

class MailHistory extends StatelessWidget {
  final MailController mailController = Get.find();
  final commentWriteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.only(top: 8),
              child: InkWell(
                child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onTap: () {
                  Get.back();
                },
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Container(
                  margin: const EdgeInsets.only(top: 8, right: 8),
                  height: 15.5,
                  width: 19.2,
                  child: Image.asset("assets/images/16_10.png"),
                ),
                //여기다 삭제 추가 신고 메서드 추가 필요
                onSelected: (String result) {
                  switch (result) {
                    case '전체 삭제하기':
                      print('filter 1 clicked');
                      break;
                    case '차단하기':
                      print('filter 2 clicked');
                      break;
                    case '신고하기':
                      print('Clear filters');
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: '전체 삭제하기',
                    child: Text('전체 삭제하기'),
                  ),
                  const PopupMenuItem<String>(
                    value: '차단하기',
                    child: Text('차단하기'),
                  ),
                  const PopupMenuItem<String>(
                    value: '신고하기',
                    child: Text('신고하기'),
                  ),
                ],
              ),
            ],
            leadingWidth: 35,
            titleSpacing: 0,
            title: Obx(() {
              return Container(
                margin: const EdgeInsets.only(top: 1.5),
                child: Row(children: [
                  Text(
                      mailController.opponentProfile.value.PROFILE_NICKNAME ==
                              null
                          ? ""
                          : "${mailController.opponentProfile.value.PROFILE_NICKNAME}",
                      style: const TextStyle(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.w700,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 21.0),
                      textAlign: TextAlign.left),
                ]),
              );
            }),
          ),
          body: RefreshIndicator(
            onRefresh: mailController.getMail,
            child: Obx(() {
              if (mailController.dataAvailableMailSendPage.value) {
                return ListView.builder(
                  controller: mailController.scrollController,
                  itemCount: mailController.mailHistory.length,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 10, bottom: 97),
                  itemBuilder: (context, index) {
                    return Container(
                        padding: (mailController.mailHistory[index].FROM_ME == 0
                            ? EdgeInsets.only(left: 15, bottom: 33.5)
                            : EdgeInsets.only(right: 15, bottom: 26.5)),
                        child: Align(
                          alignment:
                              (mailController.mailHistory[index].FROM_ME == 0
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                          child: (mailController.mailHistory[index].FROM_ME == 0
                              ? Row(children: [
                                  MAIL_PROFILE_ITEM(
                                      FROM_ME: false,
                                      profile: mailController.opponentProfile),
                                  MAIL_CONTENT_ITEM(
                                    mailController: mailController,
                                    model: mailController.mailHistory[index],
                                  )
                                ])
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                      MAIL_CONTENT_ITEM(
                                        mailController: mailController,
                                        model:
                                            mailController.mailHistory[index],
                                      ),
                                      MAIL_PROFILE_ITEM(
                                          FROM_ME: true,
                                          profile: mailController.myProfile),
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
          ),
          //입력창
          bottomSheet: Container(
              height: 107 - 13.0 - 22,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: const Color(0xffffffff)),
              child:
                  //키보드
                  Column(children: [
                Container(
                    margin: EdgeInsets.only(bottom: 42 - 22.0),
                    width: MediaQuery.of(context).size.width - 30,
                    height: 52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(52)),
                        border: Border.all(
                            color: const Color(0xffd4d4d4), width: 1),
                        color: const Color(0x05333333)),
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 18.5,
                          right: 18.5,
                        ),
                        width: MediaQuery.of(context).size.width -
                            30 -
                            37 -
                            38 -
                            15,
                        child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            onEditingComplete: () async {
                              await mailController.sendMailIn(
                                  commentWriteController.text,
                                  mailController.scrollController);
                              commentWriteController.clear();
                              FocusScope.of(context).unfocus();
                            },
                            maxLines: null,
                            controller: commentWriteController,
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w500,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            onFieldSubmitted: (value) {
                              mailController.sendMailIn(
                                  commentWriteController.text,
                                  mailController.scrollController);
                              FocusScope.of(context).unfocus();
                            },
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Please enter content",
                              border: InputBorder.none,
                            )),
                      ),
                      InkWell(
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: const Color(0xff1a4678),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage('assets/images/869.png'),
                                    scale: 1.8)),
                          ),
                          onTap: () async {
                            await mailController.sendMailIn(
                                commentWriteController.text,
                                mailController.scrollController);

                            commentWriteController.clear();
                            FocusScope.of(context).unfocus();
                          }),
                    ]))
              ]))),
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
      {Key key, @required this.mailController, @required this.model})
      : super(key: key);

  final MailController mailController;
  final MailHistoryModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
                bottomRight: model.FROM_ME == 0
                    ? Radius.circular(36)
                    : Radius.circular(0),
                bottomLeft: model.FROM_ME == 0
                    ? Radius.circular(0)
                    : Radius.circular(36)),
            border: Border.all(color: const Color(0xffdcdcdc), width: 1),
            color: model.FROM_ME == 0 ? Color(0xfff2f2f2) : Color(0xff1a4678)),
        child: Container(
            margin: EdgeInsets.only(left: 11.5, top: 13, right: 13, bottom: 16),
            child: Text("${model.CONTENT}",
                style: TextStyle(
                    color: model.FROM_ME == 0
                        ? Color(0xff333333)
                        : Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0),
                textAlign: TextAlign.left)));
  }
}
