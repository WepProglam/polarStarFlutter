import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';

class MailHistory extends StatelessWidget {
  final MailController mailController = Get.find();
  final commentWriteController = TextEditingController();
  //스크롤 초기 설정 필요함
  ScrollController controller =
      new ScrollController(initialScrollOffset: 10000);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: InkWell(
              child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onTap: () {
                Get.back();
              },
            ),
            leadingWidth: 35,
            titleSpacing: 0,
            title: Text(
              "${mailController.opponentProfile.value.PROFILE_NICKNAME}",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: mailController.getMail,
            child: Stack(
              children: [
                ListView(),
                Obx(() {
                  if (mailController.dataAvailableMailSendPage) {
                    //data가 available한 상태인지 확인
                    return Container(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: mailController.mailHistory.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        itemBuilder: (context, index) {
                          if (index == mailController.mailHistory.length - 1) {
                            print((mailController.mailHistory[index].FROM_ME));
                          }
                          return Container(
                              padding: (mailController.mailHistory[index].FROM_ME == 0
                                  ? EdgeInsets.only(left: 15, bottom: 33.5)
                                  : EdgeInsets.only(right: 15, top: 26.5)),
                              child: Align(
                                  alignment:
                                      (mailController.mailHistory[index].FROM_ME == 0
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                  child: (mailController.mailHistory[index].FROM_ME == 0
                                      ? Container(
                                          width: 41.5,
                                          height: 41.5,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      const Color(0x59ffffff),
                                                  width: 3)))
                                      : Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 260),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(36),
                                                  topRight: Radius.circular(36),
                                                  bottomLeft: Radius.circular(36)),
                                              border: Border.all(color: const Color(0xffdcdcdc), width: 1),
                                              color: const Color(0xff1a4678)),
                                          child: Container(margin: EdgeInsets.only(left: 11.5, top: 13, right: 13, bottom: 16), child: Text("${mailController.mailHistory[index].CONTENT}", style: const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w700, fontFamily: "PingFangSC", fontStyle: FontStyle.normal, fontSize: 16.0), textAlign: TextAlign.left))))));
                        },
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                })
              ],
            ),
          ),
          //입력창
          bottomSheet: Container(
            height: 60,
            child: Stack(children: [
              //키보드
              Container(
                child: TextFormField(
                  controller: commentWriteController,
                  onFieldSubmitted: (value) {
                    mailController.sendMailIn(
                        commentWriteController.text, controller);
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      hintText: "쪽지 보내기", border: OutlineInputBorder()),
                ),
              ),
              Positioned(
                top: 15,
                right: 20,
                child: InkWell(
                  onTap: () {
                    mailController.sendMailIn(
                        commentWriteController.text, controller);

                    commentWriteController.clear();
                  },
                  child: Icon(
                    Icons.send,
                    size: 30,
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
