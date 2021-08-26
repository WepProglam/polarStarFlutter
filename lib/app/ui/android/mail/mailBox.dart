import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';

class MailBox extends StatelessWidget {
  final MailController mailController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('쪽지함'),
          ),
          body: RefreshIndicator(
            onRefresh: mailController.getMailBox,
            child: Stack(
              children: [
                ListView(),
                Obx(() {
                  //데이터가 사용가능한 상태인지 확인
                  if (mailController.dataAvailalbeMailPage) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var item in mailController.mailBox)
                            InkWell(
                              onTap: () async {
                                mailController.MAIL_BOX_ID.value =
                                    item.value.MAIL_BOX_ID;
                                //처음에 정보(쪽지 주고 받은 내역) 받고 보냄
                                await mailController.getMail();
                                Get.toNamed("/mail/${item.value.MAIL_BOX_ID}");
                              },
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        //상대방 닉네임 or 익명
                                        child: Text(
                                          "${item.value.PROFILE_NICKNAME}",
                                          textScaleFactor: 1.2,
                                        ),
                                        flex: 30,
                                      ),
                                      Expanded(
                                        //최근 내용
                                        child: Text(
                                          "${item.value.CONTENT}",
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 1.2,
                                        ),
                                        flex: 100,
                                      ),
                                      Expanded(
                                        //문자 보낸 시각
                                        child: Text(
                                          "${item.value.TIME_CREATED}",
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 1,
                                        ),
                                        flex: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                })
              ],
            ),
          )),
    );
  }
}
