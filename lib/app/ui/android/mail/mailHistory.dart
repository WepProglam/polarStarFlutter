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
          appBar: AppBar(
            title: Text(
                '${mailController.opponentProfile.value.PROFILE_NICKNAME}'),
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
                      margin: const EdgeInsets.only(bottom: 60),
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
                              padding:
                                  EdgeInsets.only(left: 14, right: 14, top: 10),
                              child: Align(
                                alignment: (mailController
                                            .mailHistory[index].FROM_ME ==
                                        0
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (mailController
                                                .mailHistory[index].FROM_ME ==
                                            0
                                        ? Colors.grey.shade400
                                        : Colors.blue[200]),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: (mailController
                                              .mailHistory[index].FROM_ME ==
                                          0
                                      ? Text(
                                          '${mailController.opponentProfile.value.PROFILE_NICKNAME} : ${mailController.mailHistory[index].CONTENT}',
                                          style: TextStyle(fontSize: 15))
                                      : Text(
                                          '${mailController.mailHistory[index].CONTENT}',
                                          style: TextStyle(fontSize: 15))),
                                ),
                              ));
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
